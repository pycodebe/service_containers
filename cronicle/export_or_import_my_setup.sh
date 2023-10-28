#!/bin/bash

set -e

current_date_time=$(date '+%Y%m%d_%H%M%S')
filename=${current_date_time}.txt
backup_directory=/opt/cronicle/history
bin_path=/opt/cronicle/bin
command=docker
container_name=cronicle


if [ "$1" == "export" ];
then
    echo
    echo "# ---------------------------------------------"
    echo "# Stopping Cronicle"
    echo
    
    ${command} exec -d -it ${container_name} bin/control.sh stop
    if [ $? -ne 0 ];
    then
        echo "Something bad did happen with the export"
    else 
        echo "Cronicle has been stopped"
    fi

    echo
    echo "# ---------------------------------------------"
    echo "# Exporting/Importing the configuration"

    ${command} exec -it ${container_name} bin/control.sh export ${backup_directory}/${filename} -verbose
    ./remove_unused_keys_from_my_setup.sh history/${filename}
    if [ $? -ne 0 ];
    then
        echo "Something bad did happen with the export"
    else
        echo
        echo "File ${filename} has been exported"
        ${command} exec -d -it ${container_name} bin/control.sh start
        
        echo
        echo "# ---------------------------------------------"
        echo "# Restarting Cronicle"
        echo
        
        if [ $? -ne 0 ];
        then
            echo "Something bad did happen with the export"
        else
            echo "Cronicle has been started"
            echo
        fi
    fi
fi

if [ "$1" == "import" ]; 
then
    if [ $# -eq 2 ];
    then
        file=${backup_directory}/$2
        if ${command} exec ${container_name} [ -f $file ];
        then
            ${command} exec -d -it ${container_name} bin/control.sh stop
            if [ $? -ne 0 ];
            then
                echo "Something bad did happen with the import"
            else 
                echo "Cronicle has been stopped"
            fi
            ${command} exec -it ${container_name} bin/control.sh import $file
            if [ $? -ne 0 ];
            then
                echo "Something bad did happen with the $1"
            else
                echo "File $file has been imported"
                ${command} exec -d -it ${container_name} bin/control.sh start
                if [ $? -ne 0 ];
                then
                    echo "Something bad did happen with the $1"
                else
                    echo "Cronicle has been started"
                    echo
                fi
            fi
        else
            echo "The filename $2 does not exist in the directory ${backup_directory}"    
        fi
    else
        echo "The filename is missing in the parameters of the command"
    fi 
fi

