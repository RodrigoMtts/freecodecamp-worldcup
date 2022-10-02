#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE games, teams"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #if $YEAR equal column name then go next line
  [[ $YEAR == 'year' ]] && continue

  #check if the teams are already entered
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

  #if WINNER yet not been inserted, insert team
  if [[ -z $WINNER_ID ]]
  then
    INSERTED_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERTED_TEAM == 'INSERT 0 1' ]]
    then
      echo "$WINNER team has been inserted"
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  fi

  #if OPPONENT yet not been inserted, insert team
  if [[ -z $OPPONENT_ID ]]
  then
    INSERTED_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERTED_TEAM == 'INSERT 0 1' ]]
    then
      echo "$OPPONENT team has been inserted"
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  fi

  #Insert game
  if [[ -n $WINNER_ID && -n $OPPONENT_ID ]]
  then
    #echo "$YEAR $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS $ROUND"
    INSERTED_GAME=$($PSQL "INSERT INTO games(year,winner_id,opponent_id,winner_goals,opponent_goals,round) VALUES($YEAR,$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")
  fi  
done