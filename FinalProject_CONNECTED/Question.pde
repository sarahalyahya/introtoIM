class Question {
  
  PImage image; //for the question display
  //variables to store input answers
  int user1Answer;
  int user2Answer; 
  //this will store the absolute value of the answers to check how similar the answers were
  int answerDifference;
  //question location (corresponding to area on screen)
  int x;
  int y;

  int questionNumber; 
  //booleans to check if the users both answered the question
  boolean user1Answered = false;
  boolean user2Answered = false;

  Question(int tempQNumber, int tempX, int tempY) {
    questionNumber = tempQNumber;
    x = tempX;
    y = tempY;
    image = loadImage("question"+(questionNumber+1)+".png"); 
  }
  //displaying method of the qestion
  void display() {
   image(questionBg,0,0); 
    fill(0);
    //noStroke();
    stroke(255);
    image(image,x, y);
    fill(255);
  } 
}
