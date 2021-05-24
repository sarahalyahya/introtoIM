class Letter {
  char letter; 
  int xLoc, yLoc; 
  int blockW = 70;
  int blockH = 70;
  int colNo;
  int rowNo;
  //booleans to check during the game
  boolean letterClicked;
  boolean letterCorrect;


  Letter(char letterTemp, int tempColNo, int tempRowNo) {
    letter = letterTemp;
    colNo = tempColNo;
    rowNo = tempRowNo;
  }


  void display() {
    //as it is a grid object, col and row number are used for x and y coordinates
    rectMode(CORNER);
    fill(0);
    stroke(255);
    rect(700+colNo*70, 150+rowNo*70, blockW, blockH);
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(letter, 735+colNo*70, 185+rowNo*70);
  }
  
  
//the function that checks if the letter is clicked
 void letterIsClicked() {
    if (mousePressed && mouseX >=  700+(colNo)*70  && mouseX <= 700+(colNo)*70 + blockW && mouseY >= 150+(rowNo)*70 && mouseY <= 150+(rowNo)*70+blockH) {
     // println("mouseY: ", mouseY, " - 200+(rowNo-1)*70: ", 200+(rowNo-1)*70, " - 200+(rowNo-1)*70+blockH: ", 200+(rowNo-1)*70+blockH);

      letterClicked = true;
      //println(letter, " Clicked");
    }
  }
  
}
