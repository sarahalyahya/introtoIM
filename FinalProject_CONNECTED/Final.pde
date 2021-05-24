import processing.serial.*;
Serial myPort;

//The 3 PGraphics layers we used :
//One to store user1's path, the second one to store user2's path, the final one to store the blooms.
PGraphics user1, user2, blooms; 

ArrayList<Integer[]> collisions; //arrayList that will store (x,y) of every collision
IntList collisionLocations; //list that will store which question "area" the collision happened in(in question 1 or 2 or 3, etc..) 
int c_index = -1; //index to keep track of which collision we are currently drawing. Default value is -1 since there are no collisions yet

Question[] questions;  //array of Question objects
//This variable will determine which screen we need to display: start screen, end screen, user's paths etc ...
int screen = 0; 
//variables to keep track of user's answers
int questionNumber = 0;
int Answer = 0;
int currentU1Answer = 0; 
int currentU2Answer = 0;
//string to store the name of the file created when screenshot is taken
String timestamp;
//number of questions is 9 SO: 
int qCols = 3;
int qRows = 3;
//variable to keep track and store movement of user 1
int x ,y ,lastX, lastY;  
//variable to keep track and store movement of user 1
int x2, y2, lastX2, lastY2; 
//values we will be passing as arguments for the particles of the bloom to change 
//the size and shape based on difference in answers
float a, b, c, d, e, f ; 
//image variables
PImage traceBg;
PImage questionBg;
PImage startScreen;
PImage endScreen; 

void setup() {
  //background(0);
  fullScreen();
  //println(width + " " + height);
  
  //making connections between processing and arduino
  String portname = Serial.list()[2];
  myPort = new Serial (this, portname, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');
  
  //initializing position variables
  x = 0;
  y = height/2;
  lastX = 0;
  lastY = height/2;
  x2 = width;
  y2 = height/2;
  lastX2 = width;
  lastY2 = height/2;

  //Creating the questions array
  questions = new Question[qCols*qRows];
  int questionIndex = 0;
  for (int r2 = 0; r2 < qRows; r2++) {
    for (int c2 = 0; c2 < qCols; c2++) {
      questions[questionIndex] = new Question( questionIndex, c2*640, r2*360); //640 is width of question area, and 360 is height
      questionIndex +=1;
    }
  }
  
  //initializing PGraphics layers and lists
  user1 = createGraphics(width, height);
  user2 = createGraphics(width, height);
  blooms = createGraphics(width, height);
  collisions = new ArrayList();
  collisionLocations = new IntList(); 
  pts = new ArrayList<Particle>();
  
  //loading all images
  traceBg = loadImage("bg2darker.jpg");
  startScreen = loadImage("startScreen.png");
  questionBg = loadImage("bg.jpg");
  questionBg.resize(width, height);
  endScreen = loadImage("endScreen.png");
}

void draw() {
  //screen starts at 0, which will display start screen
  if (screen == 0) {
    image(questionBg, 0, 0, width, height);
    image(startScreen, 50, 50 );
  }
  //once the mouse is pressed, screen becomes 1. This will display the questions one by one.
  if (screen == 1) {
    questions[questionNumber].display(); //display questions 1
    populatingQuestion(questionNumber); //do necessary variable assigning for the question
    //when both users answer and as long as we haven't reached the final question yet
    if (questions[questionNumber].user1Answered && questions[questionNumber].user2Answered && questionNumber < 8 ) {
      //calculate difference in answers
      questions[questionNumber].answerDifference = abs(questions[questionNumber].user1Answer - questions[questionNumber].user2Answer); 
      println(questions[questionNumber].answerDifference); 
      questionNumber += 1; //move on to next question
    }
    //once we reach final question and the two users answer
    if (questionNumber == 8 && questions[questionNumber].user1Answered && questions[questionNumber].user2Answered) {
      //calculate answer difference
      questions[questionNumber].answerDifference = abs(questions[questionNumber].user1Answer - questions[questionNumber].user2Answer);
      //set background for next screen
      image(traceBg, 0, 0, width, height); 
      //move on to next screen: which is the users' traces
      screen = 2;
    }
  }
  //when screen is 2, move on to displaying the users' traces
  if (screen == 2) {
    //display user1's path
    stroke(183,150,172,50);
    strokeWeight(5);
    line(x, y, lastX, lastY); 
    //also store it in PGraphics layer that we need for collision detection
    user1.beginDraw();
    user1.stroke(255);
    user1.strokeWeight(5);
    user1.line(x, y, lastX, lastY);
    user1.endDraw();
    //update previous values
    lastX = x;
    lastY = y;
    //display user1's path
    stroke(120,150,220, 50);
    strokeWeight(5);
    line(x2, y2, lastX2, lastY2);
    //also store it in PGraphics layer that we need for collision detection
    user2.beginDraw();
    user2.stroke(255, 0, 0);
    user2.strokeWeight(5);
    user2. line(x2, y2, lastX2, lastY2);
    user2.endDraw();
    //update previous values
    lastX2 = x2;
    lastY2 = y2;
    //load pixels of what we stored in both the users' PGraphics layers
    //we will detect collisions using colors of pixels
    user1.loadPixels();
    user2.loadPixels();
    //iterate through all of the pixels
    for (int i=0; i<width; i++)
    {
      for (int j=0; j<height; j++)
      {
        //if there exists a pixel that's white in user1's layer and a pixel that's red on user2's layer in the same spot
        //there is a collision
        //we also have to check if the collision doesn't already exist in collisions arrayList
        //also since the stroke of the traces are not 1 pixel, we also make sure there are no collisions in close radius
        if ( user1.get(i, j) == color(255) && user2.get(i, j) == color(255, 0, 0) &&!exists(i, j) && !existsInRadius(i, j))
        {
          //once a collision is detected 
          Integer[] c= {i, j}; //we store it's x and y positions
          collisions.add(c); //add them to collisions arraylist
          collisionLocations.append(location(c[0], c[1])); //find their "question area location" and add it to list of locations
          c_index += 1; //move on to next collision index
          yes = true; //set this boolean to true indicating a bloom needs to be drawn
        }
      }
    }
    //drawing onto the PGRaphics layer of the blooms
    blooms.beginDraw();
    blooms.smooth();
    blooms.colorMode(HSB); 
    blooms.rectMode(CENTER);
    //as soon as one collision is detected
    if (c_index > -1) 
    {
      //get size and shape value for bloom particles based on answer difference
      //we do this using a function called bloomValues
      bloomValues(questions[collisionLocations.get(c_index)].answerDifference);
      //if difference is not the largest, draw the bloom
      if (a != -1 && b != -1 && c != -1 && d != -1 && e != -1 && f != -1) {
        drawcool(blooms, collisions.get(c_index)[0], collisions.get(c_index)[1], a, b, c, d, e, f);
      }
    }
    blooms.endDraw();
    image(blooms, 0, 0); //display the blooms PGraphics layer
  }
  //once your done and choose to save the screen using the keyboard "s"
  //End screen is displayed
  if (screen == 3) {
    image(questionBg,0,0);
    image(endScreen,50,50);
  }
}

//function to populate Question objects with arduino answers
void populatingQuestion(int i) {
  //answer is not -1 only when a button has been pressed
  //if one of these buttons is pressed then it's the first user
  if ( Answer == 1 || Answer == 3 || Answer == 5 || Answer == 7) { 
    if (!questions[i].user1Answered) {  // if the question hadn't been answered already 
      questions[i].user1Answer = currentU1Answer; //assign the user 1 arduino variable to the user1 question variable
      questions[i].user1Answered = true;
      //resetting variables
      currentU1Answer = 0; 
      Answer = 0;
    }
  }  
  //if one of these buttons is pressed then it's the second user
  if ( Answer == 11 || Answer == 13 || Answer == 15 || Answer == 17) {
    if (!questions[i].user2Answered) { // if the question hadn't been answered already 
      questions[i].user2Answer = currentU2Answer; //assign the user 2 arduino variable to the user2 question variable
      questions[i].user2Answered = true;
      //resetting variables
      currentU2Answer = 0;
      Answer = 0;
    }
  }
}

//getting multiple values from arduino
void serialEvent(Serial myPort) {
  String s=myPort.readStringUntil('\n');
  s=trim(s);
  if (s!=null) {
    int values[]=int(split(s, ','));
    if (values.length==5) {
      Answer = (int)values[0]; //button values
      //4 potentiometer values
      x=(int)map(values[1], 0, 1023, 0, width);
      y=(int)map(values[2], 0, 1023, 0, height);
      x2=(int)map(values[3], 0, 1023, 0, width);
      y2=(int)map(values[4], 0, 1023, 0, height);
    }
  }
  //button values
  if (Answer != -1) {
    //first set of buttons for user 1
    if (Answer == 1 || Answer == 3 || Answer == 5 || Answer == 7) {
      currentU1Answer = Answer;
    } 
    //second set of buttons for user 2
    if (Answer == 11 || Answer == 13 || Answer == 15 || Answer == 17) {
      currentU2Answer = Answer - 10 ;
    }
  }
  myPort.write('0');
}

//function to check if collision already exists in array
boolean exists(int x, int y)
{
  for (int i=0; i<collisions.size(); i++)
  {
    if (collisions.get(i)[0]==x && collisions.get(i)[1]==y)
    {
      return true;
    }
  }
  return false;
}


//function to check if collisions exists in close radius 
boolean existsInRadius (int x, int y)
{
  for (int i=0; i<collisions.size(); i++)
  {
    if (sq(collisions.get(i)[0] - x) + sq(collisions.get(i)[1] - y) <= 20*20)
    {
      return true;
    }
  }
  return false;
}

//function to check in which question's "area" the collision happened in
int location(int x, int y) {
  int qIndex = 0;
  for (int r2 = 0; r2 < qRows; r2++) {
    for (int c2 = 0; c2 < qCols; c2++) {
      if (x >= c2*640 && x <= (c2+1)*640 && y >= r2*360 && y <= (r2+1)*360) {
        return qIndex;
      } 
      qIndex +=1;
    }
  }
  return -1;
}

//function to take parameters for the bloom based on the answer difference
void bloomValues(int diff) {
  if (diff == 0) {
    //lifespan
    a = 70;
    b = 150;
    //decay
    c = 0.7;
    d = 0.99;
    //weightRange
    e = 60; 
    f = 180;
  } else if (diff == 2) {
    //lifespan
    a = 55;
    b = 80; 
    //decay
    c = 0.63;
    d = 0.9;
    //weightRange
    e = 20;
    f = 100;
  } else if (diff == 4) {
    //lifespan
    a = 30;
    b = 65; 
    //decay
    c = 0.63;
    d = 0.83;
    //weightRange
    e = 8;
    f = 35;  
  } else if (diff == 6) {
    a = b = c = d = e = f = -1;
  }
}

//when "s" is pressed, save screen
void keyPressed() {
  if (key == 'S' || key == 's') {
    timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    saveFrame(timestamp+".png");
    screen = 3;
  }
}

//when mouse is clicked
void mouseClicked(){
 screen = 1; 
}
