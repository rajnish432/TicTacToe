#! /bin/bash

echo "WELCOME TO TIC_TAC_TOE SIMULATOR";
declare -A board
ROWS=3;
COLUMNS=3;
totalMove=0;

function initializeBoard()
{
   for (( i=0 ; i<ROWS; i++ ))
   do
      for (( j=0 ; j<COLUMNS; j++ ))
      do
         board[$i,$j]="+";
      done
   done
}

function gameBoard()
{
	for (( i=0; i<ROWS; i++ ))
	do
		echo "---------------"
			for (( j=0; j<COLUMNS; j++))
			do
				echo -n "| ${board[$i,$j]} |"
			done
		echo
	done
	echo "---------------"
}

function playerLetterAssignment()
{
	if [[ $((RANDOM%2)) -eq 0 ]]
	then
		playerLetter=X
	else
		playerLetter=0;
	fi
	if [[ $playerLetter == X ]]
	then
		echo "Player plays first"
	else
		echo "computer Plays first"
	fi
}

function gamePlay()
{
	playerLetterAssignment
	while [[ $totalMove -lt 9 ]]
	do
			read -p "Enter the row: " row
			read -p "Enter the Col: " col
				if [[ ${board[$row,$col]} == + ]]
				then
					board[$row,$col]=$playerLetter
					gameBoard;
					((totalMove++))
				else
					echo "Invalid move"
				fi
	done
}

initializeBoard
gameBoard
gamePlay

