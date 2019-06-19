#!/bin/bash
###
#HP-Health  v0.1.0
#Script by Xedon 19.06.2019
#last update 19.06.2019
#If something went wrong with your HP Server this script will send an error email
###
MAIL=xedon@arctic-network.com
HPACUCLI_TMP_drive=/tmp/hpacucli-drive.log
HPACUCLI_TMP_fan=/tmp/hpacucli-fan.log
HPACUCLI_TMP_powersupply=/tmp/hpacucli-powersupply.log
HPACUCLI_TMP_fan_speed=/tmp/hpacucli-fan-speed.log


if hpacucli controller slot=0 physicaldrive all show | grep -E 'Failed|Rebuilding'
then
msg="RAID Controller Errors"
echo $msg
logger -p syslog.error -t RAID "$msg"
hpacucli controller slot=0 pd all show > $HPACUCLI_TMP_drive
mail -s "[HP] $HOSTNAME [ERROR] - $msg" "$MAIL" < $HPACUCLI_TMP_drive
rm -f $HPACUCLI_TMP_drive
else
echo "Everything Good"
fi


if hpasmcli -s "show fan" | grep -Eo 'NORMAL'
then
echo "Everything Good"
else
msg="Fan ERROR"
echo $msg
logger -p syslog.error -t fan "$msg"
hpasmcli -s "show fan; show server; show temp" > $HPACUCLI_TMP_fan
mail -s "[HP] $HOSTNAME [ERROR] - $msg" "$MAIL" < $HPACUCLI_TMP_fan
rm -f $HPACUCLI_TMP_fan
fi


if hpasmcli -s "show fan" | grep -Eo '80|81|82|83|84|85|86|87|88|89|90|91|92|93|94|95|96|97|98|99|100'
then
msg="Fan Speed Warning"
echo $msg
logger -p syslog.error -t fan "$msg"
hpasmcli -s "show fan; show server; show temp" > $HPACUCLI_TMP_fan_speed
mail -s "[HP] $HOSTNAME [ERROR] - $msg" "$MAIL" < $HPACUCLI_TMP_fan_speed
rm -f $HPACUCLI_TMP_fan_speed
else
echo "Everything Good"
fi


if hpasmcli -s "show powersupply" | grep -E 'Ok|Yes'
then
echo "Everything Good"
else
msg="Power Supply ERROR"
echo $msg
logger -p syslog.error -t powersupply "$msg"
hpasmcli -s "show powersupply; show server" > $HPACUCLI_TMP_fan
mail -s "[HP] $HOSTNAME [ERROR] - $msg" "$MAIL" < $HPACUCLI_TMP_powersupply
rm -f $HPACUCLI_TMP_powersupply
fi
