PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"
NUMBER_REGEX="^[0-9]+$"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ $NUMBER_REGEX ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    ELEMENT_INFO=$($PSQL "SELECT * FROM elements WHERE name='$1' OR symbol='$1'")
  fi

  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    # Destructuring element info
    IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT_INFO"
    
    #Getting more info
    MORE_INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    
    # Destructuring more info
    IFS="|" read -r ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$MORE_INFO"

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
