#!/bin/bash

lp="/home/anmolnar/lastpass/lastpass-cli/lpass"
FOLDER="SSH"
TEXT_MODE=NO

while [[ $# > 0 ]]
do
    key="$1"

    case $key in
        -f|--folder)
        FOLDER="$2"
        shift # past argument
        ;;
        -d|--download-file)
        DOWNLOAD_FILE="$2"
        shift # past argument
        ;;
        --text)
        TEXT_MODE=YES
        ;;
        *)
            echo "Unknown option: $key"
            exit 1
        ;;
    esac
    shift # past argument or value
done

if [ "$DOWNLOAD_FILE" == "" ];
then
    echo "You must specify the file to download with -d or --download-file."
    exit 0
fi

if [ -f "$DOWNLOAD_FILE" ];
then
    echo "File already exists locally: $DOWNLOAD_FILE"
    exit 0
fi

if [ "$TEXT_MODE" == "YES" ];
then
    $lp show $FOLDER/$DOWNLOAD_FILE --notes > $DOWNLOAD_FILE
    if [ "$?" != "0" ];
    then
        echo "Download failed. File doesn't exist in LastPass?"
        rm $DOWNLOAD_FILE
    fi
else
    $lp show $FOLDER/$DOWNLOAD_FILE --notes | base64 -d > $DOWNLOAD_FILE
    if [ "$?" != "0" ];
    then
        echo "Download failed. Not binary file?"
        rm $DOWNLOAD_FILE
    fi
fi



