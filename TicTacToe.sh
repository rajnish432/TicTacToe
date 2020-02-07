#! /bin/bash

echo "WELCOME TO TIC_TAC_TOE SIMULATOR";
declare -A board
ROWS=3;
COLUMNS=3;
totalMove=0;
winner=false;
flag=0;

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

function winningRow()
{
	for (( i=0; i<ROWS; i++ ))
	do
		for ((j=0; j<COLUMNS; j++))
		do
		if [[ ${board[$i,$j]} == ${board[$i,$((j+1))]} && ${board[$i,$((j+1))]} == ${board[$i,$((j+2))]} && ${board[$i,$j]} == $1 ]]
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
      if [[ ${board[$i,$j]} == ${board[$((i+1)),$j]} && ${board[$((i+1)),$j]} == ${board[$((i+2)),$j]} && ${board[$i,$j]} == $1 ]]
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
		if [[ $flag -eq 0 ]]
		then
			read -p "Enter the row: " row
			read -p "Enter the Col: " col
				if [[ ${board[$row,$col]} == + ]]
				then
					board[$row,$col]=$playerLetter
					gameBoard;
					winningRow	$playerLetter
					winningColumn	$playerLetter
					winningDiagonal 0 0 1 1 2 2
					winningDiagonal 0 2 1 1 2 0
					getWinner "Player"
					flag=1
					((totalMove++))
				fi
		elif [[ $flag -eq 1 ]]
		then
			row=$((RANDOM%3))
			col=$((RANDOM%3))
				if [[ ${board[$row,$col]} == + ]]
      		then
					board[$row,$col]=$computerLetter
					gameBoard;
					winningRow $computerLetter
					winningColumn $computerLetter
					winningDiagonal 0 0 1 1 2 2
					winningDiagonal 0 2 1 1 2 0
					getWinner "computer"
					flag=0;
					((totalMove++))
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

