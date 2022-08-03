#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    #get_WINNER_ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert team
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
        then
        echo Inserted winner into temas, $winner
      fi
      #get_WINNER_ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    fi    
    #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert team
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
        then
        echo Inserted opponent into temas, $opponent
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    fi
    #insert into games
    INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")        
  fi
done