/*
 Program that allows two people to play Connect Four.
 */

int[][]theBoard = new int [6][7]; 
int numRows = 6;
int numColumns = 7; 
int size = 100; 
int currentPlayer =1; 
String winner = "";
boolean wins = false; 
boolean tie = false; 

//sets the size of the panel, makes sure the ellipses and text are centered 
void setup() {
  size(700, 600); 
  //makes sure the ellipses are centered 
  ellipseMode(CORNER);
  textAlign(CENTER);
}

//every time the mouse is clicked the updated board is posted, or a panel that says who won, or a panel that says there's a draw
void mousePressed() {  
  int column = mouseX/size;
  int outcome = 0;
  if (currentPlayer ==1) {
    outcome = player1(theBoard, column);
    //switch player for next round
    currentPlayer = 2;
  } else if (currentPlayer ==2) {
    outcome = player2(theBoard, column);
    //switch player for next round 
    currentPlayer = 1;
  }
  if (wins!=true && tie!=true) {
    //outcome 1 is a win, 2 is a tie, 3 means keep playing 
    if (outcome==1) {
      winnerMethod();
      noLoop(); 
      wins = true;
    } else if (outcome==2) {
      tieMethod();
      noLoop(); 
      tie = true;
    } else if (outcome==3) {
      draw();
    }
  }
}

//method sets up the panel that the user will play on 
void draw() {
  background(0); 
  for (int i=0; i<theBoard.length; i++) {
    //second loop prints columns 
    for (int j=0; j<theBoard[i].length; j++) {
      if (theBoard[i][j] == 0) { 
        //background is pink 
        fill(255, 255, 224);
        ellipse(j*size, i*size, size, size);
      } else if (theBoard[i][j] == 1) {
        //player 1 gets a red color
        fill(255, 76, 76);
        ellipse(j*size, i*size, size, size);
      } else if (theBoard[i][j] == 2) {
        //player 2 gets a blue color 
        fill(76, 76, 255);
        ellipse(j*size, i*size, size, size);
      }
    }
  }
}

//method will make sure the piece isn't out of bounds, also returns if the player won 
int player1(int[][] theBoard, int column) {
  currentPlayer = 1; 
  if (column < 0 || column > theBoard.length+1) {
    return mouseX/size;
  }
  int winner = dropPiece(column, theBoard, currentPlayer);
  return winner;
}

//this method does the same as the one above but it does it for player2
int player2(int[][] theBoard, int column) {
  currentPlayer = 2; 
  if (column < 0 || column > theBoard.length+1) {
    return mouseX;
  }
  int winner = dropPiece(column, theBoard, currentPlayer);
  return winner;
}

//Checks where to drop the piece and returns the winner to the player methods 
int dropPiece(int column, int[][] theBoard, int currentPlayer) { 
  boolean notFilled = true; 
  int i = 0; 
  while (notFilled && i < theBoard.length) {
    if (theBoard[i][column] == 0) {
      notFilled = true;
      i++;
    } else {
      notFilled = false;
    }
  }
  //red = 1 and blue = 2 
  theBoard[i-1][column] = currentPlayer;
  int row = (i-1);   
  int winner = checkingWinner(theBoard, column, row, currentPlayer);
  return winner;
}    

//checks if the rows/columns are ordered in a way in where the player can win, so 4 in a row 
boolean checkingRows(int[][] theBoard, int column, int row, int currentPlayer) {
  for (int i=0; i<theBoard.length; i++) {
    if (i+3 < theBoard.length && theBoard[i][column] == currentPlayer && theBoard[i][column] == theBoard[i+1][column]
      && theBoard[i][column] == theBoard[i+2][column]
      && theBoard[i][column] == theBoard[i+3][column]) {
      return true;
    }
  }
  for (int i=0; i<theBoard.length; i++) {
    if (i+3 < theBoard.length && theBoard[row][i]  == currentPlayer && theBoard[row][i]  == theBoard[row][i+1] 
      && theBoard[row][i]  == theBoard[row][i+2] 
      && theBoard[row][i]  == theBoard[row][i+3] ) {
      return true;
    }
  }
  return false;
}

//checks if there are 4 in a row diagnally 
boolean checkingUpDiagonal(int[][] theBoard, int column, int row, int currentPlayer) {
  //picking the range to find the lowest square of a diagonal line 
  int first = 5-row;
  int second = column - 0;   
  int range = 0;
  int filled =0; 

  if (first < second) {
    range = first;
  } else {
    range = second;
  }
  //checking the lowest square of a diagonal line 
  int initialRow = row + range;
  int initalColumn = column - range;

  while (initialRow > 0 && initalColumn < 7) {
    if (theBoard[initialRow][initalColumn] == currentPlayer) {
      filled++;
    } else if (theBoard[initialRow][initalColumn] != currentPlayer) {
      filled = 0;
    }
    if (filled == 4) {
      return true;
    }

    //incrementing so that we move on box ahead on the diagonal line 
    initialRow -= 1; 
    initalColumn +=1;
  }
  return false;
}

//checks if there are 4 in a row diagonally 
boolean checkingDownDiagonal(int[][] theBoard, int column, int row, int currentPlayer) {
  //picking the range to find the lowest square of a diagonal line 
  int firstDown = row-0;
  int secondDown = column -0;   
  int range2 = 0;
  int filled =0; 

  if (firstDown < secondDown) {
    range2 = firstDown;
  } else {
    range2 = secondDown;
  }

  //checking the lowest square of a diagonal line 
  int initialRowDown = row - range2;
  int initialColumnDown = column - range2;

  while (initialRowDown < 6 && initialColumnDown < 7) {
    if (theBoard[initialRowDown][initialColumnDown] == currentPlayer) {
      filled++;
    } else if (theBoard[initialRowDown][initialColumnDown] != currentPlayer) {
      filled = 0;
    }
    if (filled == 4) {
      return true;
    }

    //incrementing so that we move on box ahead on the diagonal line 
    initialRowDown += 1; 
    initialColumnDown +=1;
  }
  return false;
}

//checks if there is a tie
boolean checkingTie(int[][] theBoard) {
  int filled = 0;
  for (int i=0; i<7; i++) {
    for (int j=0; j<6; j++) {
      if (theBoard[j][i] != 0) {
        filled++;
      }
      if (filled == 42) {
        return true;
      }
    }
  }
  return false;
}

//checks if there is a winner 
int checkingWinner(int[][] theBoard, int column, int row, int currentPlayer) {
  boolean rows =checkingRows(theBoard, column, row, currentPlayer);
  boolean upDiag =checkingUpDiagonal(theBoard, column, row, currentPlayer);
  boolean downDiag = checkingDownDiagonal(theBoard, column, row, currentPlayer);
  boolean tie = checkingTie(theBoard);

  if (rows || upDiag || downDiag) {
    return 1;
  } else if (tie) {
    return 2;
  } else {
    return 3;
  }
}

//prints out a screen that shows which player won 
void winnerMethod() {
  background(0); 
  fill(255); 
  textSize(100);
  if (currentPlayer ==2) {
    winner = "Player 1";
  } else if (currentPlayer ==1) {
    winner = "Player 2";
  }
  text(winner+ " wins!", width/2, height/2);
}

//prints out a screen that tells the players that there has been a draw 
void tieMethod() { 
  background(0);
  fill(255);
  textSize(60);
  text("The game is a draw.", width/2, height/2);
}