# ethos-nvidia-fan fix

# Name:             Autofan script for NVIDIA Cards in HiveOS
# Preparation:      Setting up script sheduled run from CRON (Crontab)
#                    1) Copy script to /home/user/script/ (create folder script).
#                    2) Run mc -> go to script folder
#                    3) Make script executable - execute command in the same folder - chmod u+x autofan.sh.
# Sheduled-Start:    4) Edit crontab (sudo crontab -L) and add line */5 * * * * /home/user/script/autofan.sh
#                       This command will start script every 5 minutes, if you want to change - correct "*/5" value.
#                    5) Edit hive/etc/crontab.root to have autofan running from Cron after reboot.
# Additional Info:  DELAY is not applicable unless the script is set-up for single running in cycle
