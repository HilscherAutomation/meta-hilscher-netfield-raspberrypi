#!/bin/bash

MYNAME=$(basename ${0})
MYVERSION="20160404"

function usage() {
  echo "${MYNAME} [options]"
  echo ""
  echo "-o --out <img.tar.bz2>       Output tarball name (supported extensions: tar, tar.gz, tgz, tar.bz2, zip)"
  echo "-i --image <imgname>         Input image name (default: hilscher-iotgw-image)"
  echo "-f --force-boot <bootloader> Ignore the image's signature - needs a bootloader without public key"
}

# Show welcome message
echo
echo "==========================================================="
echo " Application: ${MYNAME} (${MYVERSION})"
echo "==========================================================="

# Default values
signing_key="db.key"
input_image="hilscher-iotgw-image"
grub_default="0"
serial_port="ttyS1"
netpi=0
bootloader=""

while [ "$1" != "" ]; do
    case $1 in
        -o | --out )           shift
                               output_image=$1
                               ;;
        -i | --image )         shift
                               input_image=$1
                               ;;
        -f | --force-boot )    shift
                               bootloader=$1
                               ;;
        -h | --help )          usage
                               exit
                               ;;
        * )                    usage
                               exit 1
    esac
    shift
done

if [ -z "$output_image" ]; then
    echo "Missing image file name. Please provide -o <img>"
    exit 1
fi

if [ ! -e "$input_image" ]; then
   # Input image can be given as archive name in tmp/deploy/images/...
   input_image="../../../build/tmp/deploy/images/hilscher-netpi/${input_image}-hilscher-netpi.rpi-sdimg"
fi

[ ! -e "$input_image" ] && echo "Input image ${input_image} cannot be found" && exit 1

input_image=`realpath ${input_image}`

echo "Creation settings: "
echo " Output : ${output_image}"
echo " Input  : ${input_image}"
if [ "x${bootloader}" != "x" ];then
  bootloader=$(realpath ${bootloader})
fi

cwd="$(pwd)"
tmpdir=`mktemp -d --tmpdir=${PWD}`

pushd ${tmpdir}

echo "Extracting bootloader from image"

tar xjf ${input_image} --wildcards --anchored './boot/*'

echo "prearing bootpartion for netpi $PWD"
cp -r ./boot/* .
rm -rf ./boot
rm -f fitImage*
rm -rf overlays
if [ -e "pre_overlays" ]; then
  mv pre_overlays overlays
  for overlay in $(ls ./overlays/*.dtbo); do
    echo dtoverlay=$(basename ${overlay/.dtbo/}) >> "config.txt"
  done
fi
#the given bootloader does not provide signature verification (used for initial boot to able to start every platforms image)
if [ "x${bootloader}" != "x" ];then
  bootloader=$(realpath ${bootloader})
  echo "overwriting bootloader by ${bootloader}"
  cp ${bootloader} kernel7.img
fi

popd

# create archive for placing on USB stick
echo "Creating archive ${output_image}"

# Create different archive types depending on given extension
case "$output_image" in
  *.tar.gz | *.tgz ) 
    # Create tarball
    tar czf ${output_image} -C ${tmpdir} .
    ;;
  *.tar.bz2 ) 
    # Create bzipped tar archive
    tar cjf ${output_image} -C ${tmpdir} .
    ;;
  *.zip )
    [ -e "$output_image" ] && rm $output_image
    pushd $tmpdir > /dev/null
    zip ${output_image} -r *
    popd > /dev/null
    ;;
  *.tar )
    # Create uncompressed tar archive
    tar cf ${output_image} -C ${tmpdir} .
    ;;
  * )
    # Create uncompressed tar archive
    tar cf ${output_image}.tar -C ${tmpdir} .
    ;;
esac

echo "Removing temporary files"
rm -rf ${tmpdir}

echo "Done"
