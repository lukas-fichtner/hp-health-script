#!/bin/bash
###
#HP-Health  v0.1.3
#Script by Xedon 19.06.2019
#last update 14.05.2020
#If something went wrong with your HP Server this script will send an error email
###
MAIL=xedon@arctic-network.com
HPACUCLI_TMP_drive=/tmp/hpacucli-drive.log
HPACUCLI_TMP_fan=/tmp/hpacucli-fan.log
HPACUCLI_TMP_powersupply=/tmp/hpacucli-powersupply.log
HPACUCLI_TMP_fan_speed=/tmp/hpacucli-fan-speed.log


if sudo hpacucli controller slot=0 physicaldrive all show | grep -E 'Failed|Rebuilding'
then
msg="RAID Controller Errors"
echo $msg
sudo logger -p syslog.error -t RAID "$msg"
sudo hpacucli controller slot=0 pd all show > $HPACUCLI_TMP_drive
sudo mail -s "[HP] $HOSTNAME [ERROR] - $msg" "$MAIL" < $HPACUCLI_TMP_drive
sudo rm -f $HPACUCLI_TMP_drive
else
echo "Everything Good"
fi


if sudo hpasmcli -s "show fan" | grep -Eo 'NORMAL'
then
echo "Everything Good"
else
msg="Fan ERROR"
echo $msg
sudo logger -p syslog.error -t fan "$msg"
sudo hpasmcli -s "show fan; show server; show temp" > $HPACUCLI_TMP_fan
sudo mail -s "[HP] $HOSTNAME [ERROR] - $msg" "$MAIL" < $HPACUCLI_TMP_fan
sudo rm -f $HPACUCLI_TMP_fan
fi


if sudo hpasmcli -s "show fan" | grep -Eo '80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100'
then
msg="Fan Speed Warning"
echo $msg
sudo logger -p syslog.error -t fan "$msg"
sudo hpasmcli -s "show fan; show server; show temp" > $HPACUCLI_TMP_fan_speed
sudo mail -s "[HP] $HOSTNAME [WARNING] - $msg" "$MAIL" < $HPACUCLI_TMP_fan_speed
sudo rm -f $HPACUCLI_TMP_fan_speed
else
echo "Everything Good"
fi


if sudo hpasmcli -s "show powersupply" | grep -E 'Ok|Yes'
then
echo "Everything Good"
else
msg="Power Supply ERROR"
echo $msg
sudo logger -p syslog.error -t powersupply "$msg"
sudo hpasmcli -s "show powersupply; show server" > $HPACUCLI_TMP_fan
sudo mail -s "[HP] $HOSTNAME [ERROR] - $msg" "$MAIL" < $HPACUCLI_TMP_powersupply
sudo rm -f $HPACUCLI_TMP_powersupply
fi
