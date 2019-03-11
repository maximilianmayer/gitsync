#!/usr/bin/env bash

input_file=$1
if [ -z ./.gitsync ];then
    echo -e "---\nrepos:" > .gitsync
    jq '.[]| "  " +.name +":", "    url: "+ (.ssh_url_to_repo)' ${input_file} | sed -e 's/"//g'>> .gitsync

else
    echo "Error: .gitsync file is not empty!"
fi