#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(DATE +%F-%H-%M-%-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
validate() 
{   #here we are validating the exit status of every installing package
    if [ $1 -ne 0]  #we are checking if first argument that is exit status of previous command is zero or not
    then 
    echo "$2...failure"  #if not second argument is showing as failure
    exit 1
    echo "$2 success"  #if yes means its success
}
if [ $USERID -ne 0 ]
then  
   echo "please run this script wth root access"
   exit 1 #manually exit error comes

else 
  echo "your super user"
fi
dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MYSQL server"
systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "ENABLING MYSQL SERVER"

systemctl START mysqld &>>$LOGFILE
VALIDATE $? "STARTING MYSQL SERVER"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>&LOGFILE
#VALIDATE $? "setting up root password"

#below code is useful for idempotential nature
mysql -h db.daws78s.online -uroot -pExpenseApp@1 -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0]
then
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>&LOGFILE
VALIDATE $? "Mysql root password setup"
else
echo -e "Mysql root password is already setup ...$Y SKIPPING $N"
fi