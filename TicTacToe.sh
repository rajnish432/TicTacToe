#! /bin/bash

echo "WELCOME TO TIC_TAC_TOE SIMULATOR";
declare -A board
ROWS=3;
COLUMNS=3;
totalMove=0;
winner=false;
flag=0;
checkCount=0;
block=0;

function initializeBoard()
{
	for (( i=0 ; i<$ROWS; i++ ))
	do
		for (( j=0 ; j<$COLUMNS; j++ ))
		do
			board[$i,$j]="+";
		done
	done
}

function gameBoard()
{
	for (( i=0; i<$ROWS; i++ ))
	do
		echo "---------------"
			for (( j=0; j<$COLUMNS; j++))
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
		computerLetter=0
	else
		playerLetter=0;
		computerLetter=X;
	fi
	if [[ $playerLetter == X ]]
	then
		flag=0;
		echo "Player plays first"
	else
		flag=1;
		echo "computer Plays first"
	fi
}

function winningRowAndColumnAndDiagonal()
{
	for (( i=0; i<$ROWS; i++ ))
	do
		for (( j=0; j<$COLUMNS; j++ ))
		do
		if [[ ${board[$i,$j]} == $1 && ${board[$i,$((j+1))]} == $1 && ${board[$i,$((j+2))]} == $1 ]]
		then
			winner=true;
		fi
		if [[ ${board[$i,$j]} == $1  && ${board[$((i+1)),$j]} == $1 && ${board[$((i+2)),$j]} == $1 ]]
		then
			winner=true;
		fi
		if [[ ${board[$i,$j]} == $1  && ${board[$((i+1)),$((j+1))]} == $1 && ${board[$((i+2)),$((j+2))]} == $1 ]]
		then
			winner=true;
		fi
		if [[ ${board[$i,$((j+2))]} == $1 && ${board[$((i+1)),$((j+1))]} == $1 && ${board[$((i+2)),$j]} == $1 ]]
		then
			winner=true;
		fi
		done
	done
}

function checkBlockComputer()
{
	for (( row1=0; row1<$ROWS ; row1++ ))
	do
		for (( col1=0; col1<$COLUMNS ; col1++ ))
		do
			if [[ ${board[$row1,$col1]} == + ]]
			then
				board[$row1,$col1]=$playerLetter
				winningRowAndColumnAndDiagonal $playerLetter
				if [[ $winner == true ]]
				then
						board[$row1,$col1]=$computerLetter
						gameBoard;
						block=1;
						winner=false;
						getWinner "computer"
						break;
				else
					board[$row1,$col1]="+"
				fi
			fi
		done
		if [ $block -eq 1 ]
		then
			break;
		fi
	done
}

function checkWinComputer()
{
	for (( row=0; row<$ROWS ; row++ ))
	do
		for (( col=0; col<$COLUMNS ; col++ ))
		do
			if [[ ${board[$row,$col]} == + ]]
			then
				board[$row,$col]=$computerLetter
				winningRowAndColumnAndDiagonal $computerLetter
				if [[ $winner == false ]]
				then
					board[$row,$col]="+";
				else
					gameBoard
					getWinner "computer"
					exit;
				fi
			fi
		done
	done
}

function gamePlay()
{
	playerLetterAssignment
	while [[ $totalMove -lt 9 ]]
	do
		if [[ $flag -eq 0 ]]
		then
			read -p "Enter the row: " row
			read -p "Enter the Col: " col
				if [[ ${board[$row,$col]} == + ]]
				then
					board[$row,$col]=$playerLetter
					gameBoard;
					winningRowAndColumnAndDiagonal $playerLetter
					getWinner "Player"
					flag=1
					((totalMove++))
				fi
		elif [[ $flag -eq 1 ]]
		then
				checkWinComputer
				checkBlockComputer
				if [ $block -eq 1 ]
				then
					((totalMove++))
					flag=0;
				fi
				block=0;
				if [ $flag -eq 1 ]
				then
					row=$((RANDOM%3))
					col=$((RANDOM%3))
					if [[ ${board[$row,$col]} == + ]]
					then
						board[$row,$col]=$computerLetter
						gameBoard;
						winningRowAndColumnAndDiagonal $computerLetter
						flag=0;
						((totalMove++))
					fi
				fi
		fi
	done
	if [[ $totalMove -eq 9 && $winner == false ]]
	then
		echo " Game Draw"
	fi
}

function getWinner()
{
	if [[ $winner == true ]]
	then
		echo "Winner is $1";
		exit;
	fi
}

initializeBoard
gameBoard
gamePlay
