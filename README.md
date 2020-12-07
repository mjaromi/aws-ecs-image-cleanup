# aws-ecs-image-cleanup

## intro

This script will remove all unused docker images. You can also define `/etc/ecs/ecs.images` file with the following convention:
```shell
[root@workstation]> cat /etc/ecs/ecs.images
image1
image2
...
imageN
```
and those images will be excluded from cleanup as well.

## usage
```shell
./aws-ecs-image-cleanup.sh
```