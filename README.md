# lastpass-tools

This script is able to store binary files in LastPass Secure Notes with base64 encoding.

## install

1. Install LastPass CLI: https://github.com/lastpass/lastpass-cli
2. Edit lp-upload.sh and lp-download.sh to setup location of *lpass* executable.

## upload

> lp-upload.sh -f FOLDER -t TEMPLATE -u FILE {--text}

**Parameters**

- -f, --folder
Specifiy destination folder in LastPass.

- -t, --template
Use template entry to duplicate in LastPass. LP CLI tool is unable to add new entries, so we need an existing one to duplicate. Should be secure note type

- -u, --upload
Name of the local file to upload.

- --text
Upload as text file (no base64 encoding performed). Default is to upload as binary.

**Example**

```
./lp-upload.sh -f SSH -t secure-note-tpl -u ssh-key.pem --text
```

## download

> lp-download.sh -f FOLDER -d FILE {--text}

**Parameters**

- -f, --folder
Specifiy source folder in LastPass.

- -d, --download
Name of the remote file to download.

- - --text
Download as text file (no base64 decoding performed). Default is to download as binary.

**Example**

```
./lp-download.sh -f SSH -d ssh-key.pem --text
```

