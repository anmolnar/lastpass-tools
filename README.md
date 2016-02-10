# lastpass-tools

This script is able to store binary files in LastPass Secure Notes with base64 encoding.

## upload

> lp-upload.sh

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
./lp-upload.sh -f SSH -t secure-note-tpl -u xively-dev.pem --text
```

