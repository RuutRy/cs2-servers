CS2 docker images
==============
Credit to [juksuu](https://github.com/Juksuu), copied from repo: [Juksuu/cs2-docker](https://github.com/Juksuu/cs2-docker)

## Versions
There are two different versions

* juksuu/cs2:latest (Vanilla cs2 server)
* juksuu/cs2:matchup (Cs2 server with [MatchUp](https://github.com/Juksuu/MatchUp) plugin)

## Environment variables

### General

#### HOST_NAME

Default: cs2-server

Defines the name for the server


#### STARTING_MAP

Default: de_mirage

Map to load on server start


#### GAME_MODE

Default: competitive

Game mode to use in server. One of the following values deathmatch|competitive|wingman|casual|armsrace


#### RCON_PASS

Default: changeme

Rcon password to use for the server


#### ENABLE_TV

Default: 0

Enable or disable cs tv 0|1


#### BACKUP_FILE_PREFIX

Default: backup

File prefix for backup file. The whole pattern for the file is %prefix%_round%round%.txt


### MatchUp

#### MATCHUP_VERSION

Default: v0.2.0

Change version for MatchUp plugin