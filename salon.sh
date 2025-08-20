#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"


MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Please choose one of the services from the list:"
  echo "$($PSQL "SELECT * FROM services")" | while IFS="|" read SERVICE_ID NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  # get service_id
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  # if it doesn't exist
  if [[ -z $SERVICE_ID ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  
  # if valid
  else

    echo -e "\nPlease enter your phone number."

    read CUSTOMER_PHONE
    # get phone number from database
    PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

    # get service name
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")

    if [[ -z $PHONE_NUMBER ]]
    # if it doesn't exist
    then         
      echo -e "\nI don't have a record for that phone number. What's your name?"

      read CUSTOMER_NAME

      # insert customer into database
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")


      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"

      read SERVICE_TIME

      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

      # get customer_id
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      # insert appointment
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
      echo $INSERT_APPOINTMENT_RESULT 
    else
      # get cusomter name
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

      echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"

      read SERVICE_TIME

      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

      # insert appointment
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")
      echo $INSERT_APPOINTMENT_RESULT 

    fi
  fi
}

MAIN_MENU
