#!/bin/bash

lp="/home/anmolnar/lastpass/lastpass-cli/lpass"
FOLDER="SSH"
TEMPLATE="xively-dev.pem"
TEXT_MODE=NO

while [[ $# > 0 ]]
do
    key="$1"

    case $key in
        -f|--folder)
        FOLDER="$2"
        shift # past argument
        ;;
        -t|--template)
        TEMPLATE="$2"
        shift # past argument
        ;;
        -u|--upload-file)
        UPLOAD_FILE="$2"
        shift # past argument
        ;;
        --text)
        TEXT_MODE=YES
        ;;
        *)
                # unknown option
        ;;
    esac
    shift # past argument or value
done

function search_by_name {
    search=`$lp ls $FOLDER | grep "$1 \["`
    id=`expr "$search" : 'SSH/.*id: \([0-9]*\)'`
    echo $id
}

function search_by_name_except {
    search=`$lp ls $FOLDER | grep "$1 \[" | grep -v $2`
    id=`expr "$search" : 'SSH/.*id: \([0-9]*\)'`
    echo $id
}

if [ "$UPLOAD_FILE" == "" ];
then
    echo "You must specify the file to upload with -u or --upload-file."
    exit 0
fi

if [ ! -r "$UPLOAD_FILE" ];
then
    echo "Unable to read file to upload: $UPLOAD_FILE"
    exit 1
fi

echo "Upload file: $UPLOAD_FILE"
up_basename=`basename $UPLOAD_FILE`
f_id=$(search_by_name $up_basename)
if [ "$f_id" != "" ];
then
    echo "File already uploaded with ID: $f_id"
    exit 1
fi

echo "Template file: $TEMPLATE"
template_id=$(search_by_name $TEMPLATE)
echo "Template file ID: $template_id"

#$lp duplicate $template_id
echo "Template duplicated"

while true;
do
    new_id=$(search_by_name_except $TEMPLATE $template_id)
    echo $new_id
    if [[ "$new_id" =~ ^[0-9]{18} ]];
    then
        break;
    fi
    echo "Syncing ..."
    $lp sync
done

echo "New file ID: $new_id"

fullname=$FOLDER/$up_basename
echo $fullname | $lp edit --non-interactive --name $new_id
echo "File renamed to $fullname" 

if [ "$TEXT_MODE" == "YES" ];
then
    cat $UPLOAD_FILE | $lp edit --non-interactive --notes $new_id
else
    base64 $UPLOAD_FILE | $lp edit --non-interactive --notes $new_id
fi
echo "File content uploaded"


