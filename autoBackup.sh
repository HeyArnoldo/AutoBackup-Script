#!/bin/bash

WEBHOOK_URL="YOUR-WEBHOOK-URL"

echo "\033[1;34m"
echo "       #########################"
echo "       #  Auto Backup Script   #"
echo "       #                       #"
echo "       #       -By HeyArnoldo  #"
echo "       #########################"
echo "       #   Presiona Ctrl + C   #"
echo "       #   Para parar el loop  #"
echo "       #########################"
echo ""
sleep 1

while true; do

echo "\033[0;37m$(date +"%H:%M:%S") \033[1;35m[AutoBackup] \033[0;37m[\033[0;33m⚠︎\033[0;37m] \033[1;34mStarting Backup..."

BACKUPFILENAME="$HOME/$(date +"%G-%m-%d-%H:%M:%S")-Backup.tar.gz"

#########################
#                       #
#    FILES TO BACKUP    #
#                       #
#########################
BACKUP_COMMAND="tar -czf $BACKUPFILENAME carpet1/ carpet2/ file1 file2"
$BACKUP_COMMAND

echo "\033[0;37m$(date +"%H:%M:%S") \033[1;35m[AutoBackup] \033[0;37m[\033[0;32m✔︎\033[0;37m] \033[1;34mBackup succesfully created!"
echo "\033[0;37m$(date +"%H:%M:%S") \033[1;35m[AutoBackup] \033[0;37m[\033[0;33m⚠︎\033[0;37m] \033[1;34mUploading to anonfiles..."

ANONFILESLINK=$(curl -F "file=@$BACKUPFILENAME" https://api.anonfiles.com/upload -s | jq '.data.file.url.short')

echo "\033[0;37m$(date +"%H:%M:%S") \033[1;35m[AutoBackup] \033[0;37m[\033[0;32m✔︎\033[0;37m] \033[1;34mSuccesfully uploaded! - $ANONFILESLINK"
echo "\033[0;37m$(date +"%H:%M:%S") \033[1;35m[AutoBackup] \033[0;37m[\033[0;33m⚠︎\033[0;37m] \033[1;34mSending webhook!"

#########################
#                       #
#   DISCORD-WEBHOOK     #
#                       #
#########################

WEBHOOK_STRING_CONTENT='{"content" : %s}'
WEBHOOK_CONTENT=$(printf "$WEBHOOK_STRING_CONTENT" "$ANONFILESLINK")

WEBHOOKCOMMAND=$(curl -X POST -H "Accept: application/json" -H "Content-Type:application/json; charset=utf-8" -d "$WEBHOOK_CONTENT" ${WEBHOOK_URL} -s)

echo "\n\033[0;37m$(date +"%H:%M:%S") \033[1;35m[AutoBackup] \033[0;37m[\033[0;32m✔︎\033[0;37m] \033[1;34mSuccesfully send webhook :) "
echo "\033[0m"

#################
#               #
#   INTERVAL    #
#               #
#################

sleep 43200 (12 HORAS)
#sleep 60 (1 Min)
done