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
    MAIN_MENU "Think again"
  else
    echo -e "\nPlease enter your phone number."

    read CUSTOMER_PHONE

    # ** Sanitize Phone Number **
      # removes spaces, dashes and brackets
    CLEAN_NUMBER=$(echo "$CUSTOMER_PHONE" | sed -E 's/-//g; s/\(//g; s/\)//g; s/^ *| *$//g; s/ *//g')
    
    # ** Check for A Valid US Phone Number **
      # checks the sanitized phone number against ten digits 
      # US country code not supported
    if [[ ! $CLEAN_NUMBER =~ ^[0-9]{10}$ ]]
    then
      # if not valid
      echo -e "This is not a valid US phone number\nThe phone number has to have one of the following number formats: \nXXXXXXXXXX\nXXX-XXX-XXXX\n(XXX)XXX-XXXX"
    else
      # if valid
      echo "This is a valid US phone number."
    
    fi
  fi
}





MAIN_MENU

