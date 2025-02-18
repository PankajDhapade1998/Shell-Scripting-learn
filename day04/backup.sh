#!/bin/bash

<< Readme
This is a script for backup with 5 day rotation
usage:
./backup <path to your source> <path to your backup folder>
Readme


function display_usage() {
	echo "Usage: ./backup.sh <path to your source> <path to your backup folder>"
}

if [[ $# -eq 0 ]]; then
	display_usage
fi

source_dir=$1
backup_dir=$2
time_stamp=$(date '+%Y-%m-%d-%H-%M-%S')


function create_backup() {
	zip -r "${backup_dir}/backup_${time_stamp}.zip" "${source_dir}" > /dev/null
	
	if [ $? -eq 0 ]; then
		echo "Backup generated successfully for ${time_stamp}"
	fi
}

function perform_rotation() {
	backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))
#	echo "${backups[@]}"

	if [ "${#backups[@]}" -gt 5 ]; then
		echo "performing rotation for 5 days"

		backups_to_remove=("${backups[@]:5}")
#	echo "${backups_to_remove[@]}"

		for backup in "${backups_to_remove[@]}";
		do
			rm -f ${backup}
		done
	fi
}


create_backup
perform_rotation
