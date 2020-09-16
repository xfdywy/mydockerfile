echo -e "root\nroot" | passwd  root
service ssh start

mkdir -p /data/td1b1
export AZURE_STORAGE_ACCOUNT= 
export AZURE_STORAGE_ACCESS_KEY= 

blobfuse /data/td1b1 --tmp-path=/mnt/blobfusetmp -o attr_timeout=240  -o allow_other -o entry_timeout=240 -o negative_timeout=120 --container-name=yuewang --log-level=LOG_DEBUG --file-cache-timeout-in-seconds=120
 
bash
