// to load OpenDyslexic Font
PFont f; 
//for final screen
PImage confetti; 
boolean wrongLetter = false;
//startScreen
int screenNumber = 0;
//a string array to pick a random animal each time start is pressed:
String[] animalNames = {"CAT", "OWL", "FROG", "FISH", "PANDA", "MONKEY", "TURTLE", "CHAMELEON"}; 
// string where the random animal picked from array is stored:
String word; 
//character array of all letters in the alphabet:
char alphabet[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}; 
//initializing a letter object array for a keypad:
Letter[] keypad = new Letter[12]; 
//initializing the animal object for the animal displayed in the run:
Animals animal4Run; 
//columns for keypad grid display
int cols = 3;
//rows for keypad grid display
int rows =4; 
// a variable that checks the players progress of selecting the correct letters -- e.g. if they have "CA" out of "CAT" it will equal 1 
int playerPosition = 0; 
//initializing a button object for start button
Buttons startButton;
// initializing a button object for replay button
Buttons replayButton; 
//an empty string variable. It will be used to reflect the player's progress in choosing the correct letter
String wordInProg; 

void setup() {
  size(960, 540);
  confetti = loadImage("CONFETTI.png");
  confetti.resize(960, 540);
  //using OpenDyslexic so the font could be readable for most
  f = createFont("OpenDyslexic-Bold.otf", 20);  
  textFont(f);
  //creating the start button object
  startButton = new Buttons(width/2, height/2+100, 100, 70, "Start"); //creating the start button object
  //creating the replay button object
  replayButton = new Buttons(width/2, height/2+200, 100, 70, "Replay"); 
  //setup the word in progress as an empty string, it will fill gradually as the player picks the correct letters.
  wordInProg = "";
  //generates a random index to pick a random animal each time run is clicked
  int indexForRun = (int)random(0, animalNames.length); 
  //sets the word variable using the generated random index
  word = animalNames[indexForRun];
  //creates an animal object using the word
  animal4Run = new Animals(word); 
  //index variable to go through all objects in the keypad array
  int index = 0; 
  for (int c = 0; c < cols; c++) {
    for (int r = 0; r < rows; r++) {
      //using columns and rows for a grid display
      keypad[index] = new Letter('x', c, r); 
      index += 1;
    }
  }

  //function that fills the characters from the animal name into the keypad in random positions
  wordCharsInKeypad(); 
  //function that fills the remaining empty keypad spaces
  fillRemainingKeys();
}

void draw() {
  background(227, 181, 164);
  //switch function to move between game screens
  switch(screenNumber) { 
  // case 0 is the start screen
  case 0:
  //calls setup to randomize a new animal everytime start is pressed
    setup(); 
    fill(232, 95, 92);
    textSize(60);
    text("Spell the Animal Name Game!", width/2, height/2 - 100);
    //display function for start button
    startButton.buttonDisplay();
    //checks if player clicks the start button and moves on to the next game screen
    if (mousePressed && mouseX >= startButton.xLoc - startButton.buttonW/2 && mouseX <= startButton.xLoc + startButton.buttonW/2 && mouseY >= startButton.yLoc - startButton.buttonH/2 && mouseY <= startButton.yLoc + startButton.buttonH/2) {
      screenNumber = 1; 
    }
    break;
  // playing screen
  case 1: 
    fill(156, 255, 250);
    textSize(50);
    text("What is this animal called?", width/2, height/2 - 200);
     //displays the player's progress in choosing the correct letters on the screen
    text(wordInProg, width/2-50, height/2 + 200);
    for (int i = 0; i < keypad.length; i ++) {
      //displays all letter objects in the keypad
      keypad[i].display(); 
      //displays the image of the animal in question
      animal4Run.display(); 
      //loops through all letters to check if 1. they are clicked , 2. if they are the correct letter 
      for (int j = 0; j < keypad.length; j++ ) { 
        textSize(20);
        //calls a function that checks whether the letter is clicked 
        keypad[j].letterIsClicked(); 
        if (keypad[j].letterClicked == true) {
          keypad[j].letterClicked = false;
          
          if (keypad[j].letter == animal4Run.animalName.charAt(playerPosition)) {
            //this condition ensures that it adds the correct letters only for as long as the word in progress is the same length as the animal name, otherwise you would get "CATTTTTTTTTT" 
            if (wordInProg.length() < animal4Run.animalName.length()) {
              //keeps adding to reflect the player's progress
              wordInProg = wordInProg + animal4Run.animalName.charAt(playerPosition);
              
              //condition: as long as the player position is still less than the length of the animal name, keep adding as the name is not complete yet
              if (playerPosition < animal4Run.animalName.length() -1) {
                playerPosition+= 1;
               //checks if the word is complete to switch to end screen that reflects success and gives replay button
              } else if (playerPosition == animal4Run.animalName.length()-1) {
                screenNumber = 2;
                break;
              }
            }
          }
        }
      }
    }
    break;
   //end screen
  case 2:
  //resets player position for next iteration of the game
    playerPosition = 0;
    for (int k = 0; k < keypad.length; k++ ) {
      //resets any letters clicked
      keypad[k].letterClicked = false; 
    }
    background(227, 181, 164);
    imageMode(CORNER);
    //tint(255);
    //loads confetti image for celebration :)
    image(confetti, 0, 0);
    fill(232, 95, 92);
    textSize(60);
    text("What a Spelling Champ!", width/2, height/2 - 100);
    fill(156, 255, 250);
    text("Press Replay to Spell Again!", width/2, height/2);
    //displaying replay button
    replayButton.buttonDisplay();
    //checks if pressed to go back to start screen
    if (mousePressed && mouseX >= replayButton.xLoc - replayButton.buttonW/2 && mouseX <= replayButton.xLoc + replayButton.buttonW/2 && mouseY >= replayButton.yLoc - replayButton.buttonH/2 && mouseY <= replayButton.yLoc + replayButton.buttonH/2) {
      screenNumber = 0;
    }
  }
}


//function that inputs the characters of the animal name in the keypad
void wordCharsInKeypad() {
  //a boolean to check if all the characters have been input
  boolean complete = false;
  //i variable to loop through all letters in the animal name
  int i = 0;
  while (complete == false) { 
    //generating a random index so letters don't appear in correct order in the keypad
    int randomIndex = (int) random(keypad.length - 1);  
    // condition: if the key is empty, signified by 'x', fill it with this letter, and then move to the next character (to avoid overwriting keys)
    if (keypad[randomIndex].letter == 'x') { 
    
      keypad[randomIndex].letter = animal4Run.animalName.charAt(i); 
      i += 1;
    }
    //if all the letters from the animal name are in the keypad, exit the while loop
    if (i == animal4Run.animalName.length()) { 
      complete = true;
    }
  }
}

//function to fill the rest of the keypad
void fillRemainingKeys() {
 //same boolean and variable concept as before
  boolean complete = false; 
  int j = 0;
  while (complete == false) {
    //this boolean is to check if the chosen letter already exists in the keypad
    boolean duplicated = false;
    //generates a random index to input a random letter from the alphabet
    int randomIndex = (int) random(alphabet.length -1);
   
    //if this position in the keypad is empty AND the chosen character is not in the animal name (as that wouldve been input in the prev function, fill it in the keypad)
    if (keypad[j].letter == 'x' && animal4Run.animalName.indexOf(alphabet[randomIndex]) == -1) {
      //for loop that checks if the letter that we are about to input already exists in the keypad to avoid repetition
      for (int k = 0; k < keypad.length; k++) {
        if (keypad[k].letter == alphabet[randomIndex] ) {
          duplicated = true;
          //if it is a duplicate it breaks out of this for loop and restarts to generate a new letter
          break;
        }
      }
      //to continue trying to generate
      if (duplicated) {
        continue;
      }
      // if it isn't a duplicate it inputs it into the keypad
      keypad[j].letter = alphabet[randomIndex];
    }
    //if the letter is in the word, meaning it is already in the keypad, also continue to generate something else
    if (word.indexOf(alphabet[randomIndex]) != -1) {
      continue;
    }
    j+= 1;
    //condition to exit the while loop when the keypad is fully formed
    if (j == keypad.length) {
      complete = true;
    }
  }

 
}
