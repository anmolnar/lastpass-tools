#!/bin/bash

lp="/home/anmolnar/lastpass/lastpass-cli/lpass"
folder="SSH"
template="xively-dev.pem"
upload_file="$1"

function search_by_name {
    search=`$lp ls $folder | grep $1`
    id=`expr "$search" : 'SSH/.*id: \([0-9]*\)'`
    echo $id
}

function search_by_name_except {
    search=`$lp ls $folder | grep $1 | grep -v $2`
    id=`expr "$search" : 'SSH/.*id: \([0-9]*\)'`
    echo $id
}

if [ ! -r $upload_file ];
then
    echo "Unable to read file to upload: $upload_file"
    exit 1
fi

echo "Upload file: $upload_file"
up_basename=`basename $upload_file`
f_id=$(search_by_name $up_basename)
if [ "$f_id" != "" ];
then
    echo "File already uploaded with ID: $f_id"
    exit 1
fi

echo "Template file: $template"
template_id=$(search_by_name $template)
echo "Template file ID: $template_id"

$lp duplicate $template_id
echo "Template duplicated"

while true;
do
    new_id=$(search_by_name_except $template $template_id)
    if [[ "$new_id" =~ ^[0-9]{19} ]];
    then
        break;
    fi
    echo "Syncing ..."
    $lp sync
done

echo "New file ID: $new_id"

fullname=$folder/$up_basename
echo $fullname | $lp edit --non-interactive --name $new_id
echo "File renamed to $fullname" 

base64 $upload_file | $lp edit --non-interactive --notes $new_id
echo "File content uploaded"


