#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/../scripts/utils.sh

# go to root folder
cd ${DIR}/..

for dir in $@
do
    if [ ! -d $dir ]
    then
        continue
    fi

    cd $dir > /dev/null

    for script in *.sh
    do
        if [[ "$script" = "stop.sh" ]]
        then
            continue
        fi

        # check for ignored scripts in scripts/tests-ignored.txt
        grep "$script" ${DIR}/tests-ignored.txt > /dev/null
        if [ $? = 0 ]
        then
            log "####################################################"
            log "skipping $script in dir $dir"
            log "####################################################"
            continue
        fi

        log "####################################################"
        log "Executing $script in dir $dir"
        log "####################################################"
        bash $script
        bash stop.sh
    done
    cd - > /dev/null
done