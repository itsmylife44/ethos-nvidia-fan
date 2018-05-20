#!/bin/bash
#sleep 30
export DISPLAY=:0

#DELAY=60            # Pause for cycle disabled / пауза для цикла замкнутого цикла while-do - отключена для однократного запуска
MIN_TEMP=43          # Set Min Temperature Target 
MAX_TEMP=76          # Set Max Temperature Target 
MIN_FAN_SPEED=30     # Set Min Fan Speed applied below MIN_TEMP / 
MAX_FAN_SPEED=80     # Set Min Fan Speed applied above  MAX_TEMP /

# BEGIN

if [[ $MAX_FAN_SPEED > 100 ]]; then
    MAX_FAN_SPEED=80
fi

n=`gpu-detect NVIDIA`
if [ $n == 0 ]; then
    echo "[$(date +"%d/%m/%y %T")] No NVIDIA cards detected, exiting"
    exit
fi

CARDS_NUM=`nvidia-smi -L | wc -l`
echo "[$(date +"%d/%m/%y %T")] Found ${CARDS_NUM} GPU(s) : MIN ${MIN_TEMP}°C - ${MAX_TEMP}°C MAX : Delay ${DELAY}s"
echo "[$(date +"%d/%m/%y %T")] Found ${CARDS_NUM} GPU(s) : MIN ${MIN_TEMP}°C - ${MAX_TEMP}°C MAX" >> /var/log/autofan.log

#while true # this while-do-done cycle is disabled for single-run from cron, to be setup in cron
#do         
#echo "$(date +"%d/%m/%y %T")"
#echo "$(date +"%d/%m/%y %T")" >> /var/log/autofan.log

for ((i=0; i<$CARDS_NUM; i++))
do
GPU_TEMP=`nvidia-smi -i $i --query-gpu=temperature.gpu --format=csv,noheader`
if [[ $GPU_TEMP < $MIN_TEMP ]]
then
FAN_SPEED=$MIN_FAN_SPEED
elif [[ $GPU_TEMP > $MAX_TEMP ]]
then
FAN_SPEED=$MAX_FAN_SPEED
else
FAN_DIFF=$(($MAX_FAN_SPEED-$MIN_FAN_SPEED))
FAN_SPEED_ADDED=$(( ($GPU_TEMP - $MIN_TEMP)*$FAN_DIFF/($MAX_TEMP - $MIN_TEMP) ))
FAN_SPEED=$(($MIN_FAN_SPEED+$FAN_SPEED_ADDED))
fi
result=`nvidia-settings -a [gpu:$i]/GPUFanControlState=1 | grep "assigned value 1"`
test -z "$result" && echo "GPU${i} ${GPU_TEMP}°C -> Fan speed management is not supported" && exit 1
#nvidia-settings -a [gpu:$i]/GPUFanControlState=1 | grep -v "^$" > /dev/null
nvidia-settings -a [fan:$i]/GPUTargetFanSpeed=$FAN_SPEED > /dev/null
echo "GPU${i} ${GPU_TEMP}°C -> ${FAN_SPEED}%"
echo "GPU${i} ${GPU_TEMP}°C -> ${FAN_SPEED}%" >> /var/log/autofan.log
done

#sleep $DELAY
#done
