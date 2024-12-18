#!/bin/bash

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H:%M:%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
#echo "user ID is: $USERID"

R="\e[31m"
G="\e[32m"
N="\e0m"
Y="\e33m"


CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then 
        echo -e "$R Please run this script with root privileges $N" | tee -a &>>$LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 is...$R FAILED $N" | tee -a &>>$LOG_FILE
        exit 1
    else 
        echo -e "$2 is...$G SUCCESS $N" | tee -a &>>$LOG_FILE
    fi 
}


echo "Script started executing at: $(date)" | tee -a &>>$LOG_FILE

CHECK_ROOT

dnf install mysql-server -y
VALIDATE $? "Installing MYSQL Server"

systemctl enable mysqld
VALIDATE $? "Enabled MySQL Server"

systemctl start mysqld
VALIDATE $? "Started MySQL Server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "settingup the root password"