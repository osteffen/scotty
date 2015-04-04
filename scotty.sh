#!/bin/bash

function die() {
    xmessage "${*}"
    exit 1
}

SELF=$(readlink -f "${0}")
SELFDIR=$(dirname "${SELF}")
CONFIG_FILE="${HOME}/.config/scottyrc"

function createLauncher() {
launcher="${HOME}/Desktop/scotty.sh.desktop"
cat > "${launcher}" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=${SELF}
Name=scotty
Icon=${SELFDIR}/icon.svg
EOF
chmod +x "${launcher}"
}
if [ $# -ne 1 ]; then
    echo "Usage: scotty.sh file-to-upload"
    echo "or"
    echo "       scotty -makeLauncher   to crate a launcher icon on the desktop"
    exit 2
fi

if [ "${1}" == "-makeLauncher" ]; then
    echo "Creating Launcher Icon"
    createLauncher
    exit 0
fi

if [ ! -f "${CONFIG_FILE}" ]; then
    echo
    echo "Creating config template at ${CONFIG_FILE}"
    echo "Edit this file and retry."
    echo
    echo "You can also create a launcher icon on the desktop by running"
    echo "${SELF} -makeLauncher"
    mkdir -p $(dirname "${CONFIG_FILE}") && cp "${SELFDIR}/config_example" "${CONFIG_FILE}"
    exit 1
fi

file="${1}"

source "${CONFIG_FILE}" 

if [ "${SCP_TARGET}" == "" ]; then
    die "Config Error: SCP_TARGET not set!"
fi
if [ "${HTML_ROOT}" == "" ]; then
    die "Config Error: HTTP_ROOT not set!"
fi

function getRandomName() {
    tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1
}

if [ -r "${file}" ]; then

    filename=$(basename "${1}")
    targetfile=$(getRandomName)

    rsync_options="--partial --progress"

    if [ -d "${file}" ]; then
        rsync $rsync_options -r "${file}" "${SELFDIR}/.htaccess" "${SCP_TARGET}/${targetfile}" || die "${0} Transfer Error"
    elif [ -f "${file}" ]; then
        extension="${filename##*.}"
        targetfile+=.$extension
        rsync $rsync_options "${file}" "${SCP_TARGET}/${targetfile}" || die "${0} Transfer Error"
    fi

    echo "${HTML_ROOT}${targetfile}" | xclip -selection clipboard & disown
    xmessage "${file} --->  ${HTML_ROOT}${targetfile}"

else
    die "${0}: Error: Can't read ${file}"
    exit 1
fi

exit 0
