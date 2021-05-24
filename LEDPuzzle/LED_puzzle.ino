
//introduce LED pin variables
int blueLedPin = 10;
int greenLedPin = 11;
int yellowLedPin = 12;
int redLedPin = 13;


//introduce Button pin variables
int redButtonPin = 7;
int yellowButtonPin = 6;
int greenButtonPin = 5;
int blueButtonPin = 4;

//introduce variable to keep track of steps
int stepNo = 0;


void setup() {
  //set pin modes
  pinMode(redLedPin, OUTPUT);
  pinMode(yellowLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);
  pinMode(blueLedPin,OUTPUT);

  pinMode(redButtonPin, INPUT);
  pinMode(yellowButtonPin, INPUT);
  pinMode(greenButtonPin, INPUT);
  pinMode(blueButtonPin, INPUT);
  
  Serial.begin(9600);

}

void loop() {
  //creating variables for all button states, to read if button is pressed 
  int redButtonState = digitalRead(redButtonPin);
  int yellowButtonState = digitalRead(yellowButtonPin);
  int greenButtonState = digitalRead(greenButtonPin);
  int blueButtonState = digitalRead(blueButtonPin);

  //using a switch function to move between steps, this makes the sequence aspect of the puzzle possible.
  switch (stepNo) {
    // 1st color is red, move must be red button
    case 0:
    // checks if red button is pressed, and turns it on then off accordingly
      if (redButtonState ==  HIGH) {
        digitalWrite(redLedPin, HIGH);
        delay(700);
        digitalWrite(redLedPin, LOW);
        //if the step is performed correctly, it moves on to the next step of the puzzle
        stepNo += 1;
        //here, there's a possibility to add an else if statement, where if any of the other buttons are pressed an 
        //additional "error" LED light would flash, indicating a mistake
      }
      break;

    case 1:
    //2nd color is orange, move must be red + yellow buttons
      if (yellowButtonState == HIGH && redButtonState == HIGH) {
        digitalWrite(redLedPin, HIGH);
        digitalWrite(yellowLedPin, HIGH);
        delay(700);
        digitalWrite(redLedPin, LOW);
        digitalWrite(yellowLedPin, LOW);
        stepNo += 1;
      }
      break;
    case 2:
    //3rd color is yellow, move must be yellow button
      if (yellowButtonState == HIGH) {
        digitalWrite(yellowLedPin, HIGH);
        delay(700);
        digitalWrite(yellowLedPin, LOW);
        stepNo += 1;
      }
      break;

    case 3:
    //4th color is green, move must be green button
      if (greenButtonState == HIGH) {
        digitalWrite(greenLedPin, HIGH);
        delay(700);
        digitalWrite(greenLedPin, LOW);
        stepNo += 1;
      }
      break;
    case 4:
    //5th color is blue, move must be blue button
      if (blueButtonState == HIGH) {
        digitalWrite(blueLedPin, HIGH);
        delay(700);
        digitalWrite(blueLedPin, LOW);
        stepNo += 1;
      }
      break;

      case 5:
      //6th color is violet, move must be blue + red buttons
      if (blueButtonState == HIGH && redButtonState == HIGH) {
        //introducing a variable for number of times that all the lights will flash, will use in a while loop
        int flashes = 0;
        //10 flashes when the user finishes the pattern
        while(flashes < 10){
          //flashing technique from class, all LEDs on, delay, LEDs off, delay
        digitalWrite(blueLedPin, HIGH);
        digitalWrite(redLedPin, HIGH);
        digitalWrite(yellowLedPin, HIGH);
        digitalWrite(greenLedPin, HIGH);
        delay(400);
        digitalWrite(blueLedPin, LOW);
        digitalWrite(redLedPin, LOW);
        digitalWrite(yellowLedPin, LOW);
        digitalWrite(greenLedPin, LOW);
        delay(400);
        //adding flashes to eventually exit the while loop
        flashes+=1;}

        //restarts the puzzle
        stepNo = 0;
      }
      break;

      

  }








}
