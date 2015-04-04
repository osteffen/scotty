#!/bin/bash

function getRandomName() {
    tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1
}

function getExtension() {
    "${1##*.}"
}

filename=$(basename "${1}")
extension="${filename##*.}"
targetfile=$(getRandomName)
targetfile+=.$extension


# rsync --progress --partial "${1}" cloudcity.stufflikethis.net:public_html/${targetfile}

echo "https://cloudcity.stufflikethis.net/~f/${targetfile}" | xclip -selection clipboard & disown
xmessage "https://cloudcity.stufflikethis.net/~f/${targetfile}"
