#! /bin/bash

echo "WELCOME TO TIC_TAC_TOE SIMULATOR";
declare -A board									#-->declare Board
ROWS=3;											#-->Constant
COLUMNS=3;										#-->Constant
totalMove=0;										#-->Counter for stopping
winner=false;										#---
flag=0;											#	|
checkCount=0;										#	|-->Flags
block=0;										#	|
sidesFlag=0;										#---

function initializeBoard()						#-->Board reset function
{
	for (( i=0 ; i<$ROWS; i++ ))
	do
		for (( j=0 ; j<$COLUMNS; j++ ))
		do
			board[$i,$j]="+";
		done
	done
}

function gameBoard()								#-->Board display function
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

function playerLetterAssignment()			#-->Letter Assignment and Toss
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

function winningRowAndColumnAndDiagonal()					#-->Game Winning Conditions
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

function checkBlockComputer()								#-->Computer's Blocking  Condition
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

function checkWinComputer()								#-->Computer Winning Conditions
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

function takeCorners()									#-->Computer Occupies Corners Function
{
	for (( i=0; i<$ROWS; i++ ))
	do
		for (( j=0; j<$COLUMNS; j++ ))
	 	do
			if [[ ${board[$i,$j]} == + ]]
			then
				board[$i,$j]=$computerLetter;
				gameBoard;
				block=2
				break;
			elif [[ ${board[$i,$((COLUMNS-1))]} == + ]]
			then
				board[$i,$((COLUMNS-1))]=$computerLetter
				gameBoard;
				block=2
				break;
			elif [[ ${board[$((ROWS-1)),$j]} == + ]]
			then
				board[$((ROWS-1)),$j]=$computerLetter
				gameBoard;
				block=2;
				break;
			elif [[ ${board[$((ROWS-1)),$((COLUMNS-1))]} == + ]]
			then
				board[$((ROWS-1)),$((COLUMNS-1))]=$computerLetter;
				gameBoard;
				block=2;
				break;
			elif [[ ${board[$((ROWS/2)),$((COLUMNS/2))]} == + ]]
			then
				board[$((ROWS/2)),$((COLUMNS/2))]=$computerLetter;
				gameBoard;
				block=2;
				break;
			else
				block=2;
				sidesFlag=1;
				break;
			fi
		done
		if [ $block -eq 2 ]
		then
			break;
		fi
	done
}

function takeSides()										#-->Computer takes Sides if no centre and Corners are Available
{
for (( c=0; c<$COLUMNS; c++ ))
do
	for (( r=0; r<$ROWS; r++ ))
	do
		if [[ ${board[$r,$c]} == + ]]
		then
			board[$r,$c]=$computerLetter;
			gameBoard;
			block=3;
			break;
		fi
	done
	if [[ $block -eq 3 ]]
	then
		break;
	fi
done
}

function gamePlay()										#-->Player and Computer Moves Function
{
	playerLetterAssignment
	while [[ $totalMove -lt 9 ]]
	do
		if [[ $flag -eq 0 ]]
		then
			read -p "Enter the row(0,1,2): " row
			read -p "Enter the Col(0,1,2): " col
				if [[ ${board[$row,$col]} == + ]]
				then
					board[$row,$col]=$playerLetter
					gameBoard;
					winningRowAndColumnAndDiagonal $playerLetter
					getWinner "Player"
					((totalMove++))
					flag=1
				fi
		elif [[ $flag -eq 1 ]]
		then
				checkWinComputer
				checkBlockComputer
				if [ $block -ne 1 ]
				then
					takeCorners
				fi
				if [[ $sidesFlag -eq 1 ]]
				then
					takeSides;
					gameBoard;
					((totalMove++))
					flag=0;
				fi
				if [ $block -eq 2 ]
				then
					((totalMove++))
					flag=0;
				fi
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

function getWinner()									#-->Winner Display Function
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
