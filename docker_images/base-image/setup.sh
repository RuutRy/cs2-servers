#!/bin/bash

install_and_update() {
    steamcmd +force_install_dir ${HOME}/${STEAMAPPDIR} \
        +login anonymous \
        +app_update ${STEAMAPPID} \
        +quit
}

start() {
    cd ${HOME}/${STEAMAPPDIR}/game/bin/linuxsteamrt64

    ./cs2 -dedicated \
        -console \
        -usercon \
        +hostname ${HOST_NAME-"cs2 server"} \
        +map ${STARTING_MAP-"de_mirage"} \
        +game_alias ${GAME_MODE-"competitive"} \
        +rcon_password ${RCON_PASS-"changeme"} \
        +sv_hibernate_when_empty ${HIBERNATE_WHEN_EMPTY-0} \
        +tv_enable ${ENABLE_TV-0} \
        +mp_backup_round_file ${BACKUP_FILE_PREFIX-"backup"}
}

if [ ! -z $1 ]; then
  $1
else
  install_and_update
  start
fi