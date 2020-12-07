#!/bin/bash

excludedImagesFile=/etc/ecs/ecs.images

runningContainers=$(docker ps --filter status=running --format '{{.Image}}')

if [[ -f "${excludedImagesFile}" ]]; then
    excludedImages=$(cat ${excludedImagesFile})
fi

imagesToKeep=$(echo "${runningContainers}" "${excludedImages}" | sed 's/ /\n/g')

dockerImages=$(docker images --format '{{.Repository}}:{{.Tag}};{{.ID}}')

for image in ${imagesToKeep}; do
    dockerImages=$(echo "${dockerImages}" | sed "/${image}/d")
done

if [[ "${dockerImages}" ]]; then
    echo -e "\033[1;91m!!!!!!!!!!!!!!!\n!!! WARNING !!!\n!!!!!!!!!!!!!!!\033[0m"
    echo -e "All $(echo "${dockerImages}" | wc -l) docker images listed below will be removed.\n"
    echo "${dockerImages}"
    echo -e "\n\033[1;93mDo you want to perform these actions?\033[0m"
    echo -e "    ${0##*/} will perform the actions described above.
    Only 'yes' will be accepted to approve.\n"

    read -p "    Enter a value: " confirm
    if [[ ${confirm} != 'yes' ]]; then
        echo -e "\nFailed to approve above actions. Exit 1"
        exit 1
    else
        echo "${dockerImages}" | cut -d';' -f2 | xargs docker rmi -f  
    fi
fi
