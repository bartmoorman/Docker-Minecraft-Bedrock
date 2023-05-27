#!/usr/bin/env bash

for file in allowlist.json permissions.json server.properties; do
    if [ ! -f /config/${file} ]; then
        cp ${file} /config
    fi

    ln --symbolic --force /config/${file} ${file}
done

for dir in worlds; do
    if [ ! -d /data/${dir} ]; then
        install --directory /data/${dir}
    fi

    ln --symbolic --force /data/${dir} ${dir}
done

for file in server.properties; do
    echo -e "Updating \e[94m${file}\e[39m:"
    fileChanged=false

    for key in $(grep ^[[:lower:]] ${file} | cut -d= -f1); do
        var="MC_$(tr [:punct:] _ <<< ${key} | tr [:lower:] [:upper:])"

        if [ -v ${var} ]; then
            echo -e "\t\e[95m${key}\e[39m=\e[96m${!var}\e[39m"

            sed --in-place --regexp-extended \
            --expression "s|^(${key}=).*|\1${!var}|" \
            ${file}

            fileChanged=true
        fi
    done

    if [ ${fileChanged} == false ]; then
        echo -e '\t\e[93mNothing changed!\e[39m'
    fi
done

exec ${PWD}/bedrock_server
