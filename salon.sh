#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo "Welcome to My Salon, how can I help you?"

MAIN_MENU(){  
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICE_LIST=$($PSQL "select service_id, name from services ")
  echo "$SERVICE_LIST" | while read service_id bar name
  do
    echo -e "$service_id) $name"
  done
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"  
  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
      then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    SERVICE=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your$SERVICE,$CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERT_APPO=$($PSQL "insert into appointments(customer_id, phone, time, service_id) values($CUSTOMER_ID,'$CUSTOMER_PHONE','$SERVICE_TIME',$SERVICE_ID_SELECTED)")    
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}
MAIN_MENU
