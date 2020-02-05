#! /bin/bash

echo "WELCOME TO TIC_TAC_TOE SIMULATOR";
declare -A board
ROWS=3;
COLUMNS=3;
totalMove=0;
winner=false;

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

function winningRow()
{
	for (( i=0; i<ROWS; i++ ))
	do
		for ((j=0; j<COLUMNS; j++))
		do
		if [[ ${board[$i,$j]} == ${board[$i,$((j+1))]} && ${board[$i,$((j+1))]} == ${board[$i,$((j+2))]} && ${board[$i,$j]} == $playerLetter ]]
		then
			winner=true;
		fi
		done
	done
}

function winningColumn()
{
   for (( i=0; i<ROWS; i++ ))
   do
      for ((j=0; j<COLUMNS; j++))
      do
      if [[ ${board[$i,$j]} == ${board[$((i+1)),$j]} && ${board[$((i+1)),$j]} == ${board[$((i+2)),$j]} && ${board[$i,$j]} == $playerLetter ]]
      then
         winner=true;
      fi
      done
   done
}

function winningDiagonal()
{
	result=${board[$1,$2]}${board[$3,$4]}${board[$5,$6]}
	if [[ $result == XXX || $result == 000 ]]
	then
		winner=true;
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
					winningRow
					winningColumn
					winningDiagonal 0 0 1 1 2 2
					winningDiagonal 0 2 1 1 2 0
						if [[ $winner == true ]]
						then
							echo "Winner";
							exit;
						fi
					((totalMove++))
				else
					echo "Invalid move"
				fi
	done
}

initializeBoard
gameBoard
gamePlay

