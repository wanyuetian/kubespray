base_path="/var/lib/kubernetes"
for url in `cat ./contrib/offline/temp/files.list | grep -v 10.0.0.10`
do
  filename=`echo $url | awk -F/ '{print $NF}'`
  sub_path=`echo $url | awk -F/ '{for (i=4;i<=NF-1;i++)printf("%s/", $i);print ""}'`
  origin_domain=`echo $url | awk -F/ '{print $3}'`
  dest_path=`echo $base_path/$origin_domain/$sub_path`
  if [ ! -f $dest_path$filename ] 
  then
    echo Downloading $dest_path$filename ... 
    mkdir -p $dest_path
    wget $url -O $dest_path$filename
    echo Download $dest_path$filename success
  else
    echo $dest_path$filename is existed
  fi
done

for image in `cat ./contrib/offline/temp/images.list`
do
  echo $image
  docker pull $image
  docker tag $image localhost:5000/$image
  docker push localhost:5000/$image
done
