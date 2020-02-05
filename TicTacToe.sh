#! /bin/bash

echo "WELCOME TO TIC_TAC_TOE SIMULATOR";
declare -A board
ROWS=3;
COLUMNS=3;

function gameBoard()
{
	for (( i=0; i<ROWS; i++ ))
	do
		echo "---------------"
			for (( j=0; j<COLUMNS; j++))
			do
				board[$i,$j]="+"
				echo -n "| ${board[$i,$j]} |"
			done
		echo
	done
	echo "---------------"
}
gameBoard
