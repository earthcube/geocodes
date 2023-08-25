# notes on ECRR


Original ECCR Google Drive
 * [Resource Registry Project](https://drive.google.com/drive/u/0/folders/11gGtkE47MShoW0Q12qSi3eqMqfuYpYSw)
 * [ECRR Files](https://drive.google.com/drive/u/0/folders/11gGtkE47MShoW0Q12qSi3eqMqfuYpYSw)


## Rlcone to copy from google drive to s3.

* install rclone

`rclone config`

add a ecrr_gdrive

make a link to the ECRR in your google drive.

configure advanced to all for access to shared

rclone ls ecrr_gdrive:RegistryProject2019/ECRR_Resources --max-depth 1


