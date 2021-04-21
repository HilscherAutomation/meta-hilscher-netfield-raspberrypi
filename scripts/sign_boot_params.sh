platform=$1
bootparam_args=$2

rm bootparam bootparam.unsigned bootparam.signature*


if [ -z "${bootparam_args}" ]; then
  bootparam_args='{"force_boot":"yes"}'
fi
echo "${bootparam_args}" > bootparam.unsigned


openssl dgst -sha512 -sign ../keys/${platform}/boot/db.key -out bootparam.signature bootparam.unsigned
base64 bootparam.signature > bootparam.signature64
cat bootparam.signature64 bootparam.unsigned > bootparam

echo 'created signed boot file "bootparam" for "'"${platform}"'" with content "'"${bootparam_args}"'"'

