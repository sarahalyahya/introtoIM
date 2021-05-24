int button1Pin = 2;
bool prevButton1 = LOW;
int button2Pin = 4;
bool prevButton2 = LOW;
int button3Pin = 8;
bool prevButton3 = LOW;
int button4Pin = 10;
bool prevButton4 = LOW;



int button5Pin = 13;
bool prevButton5 = LOW;
int button6Pin = 12;
bool prevButton6 = LOW;
int button7Pin = 7;
bool prevButton7 = LOW;
int button8Pin = 5;
bool prevButton8 = LOW;

void setup() {
  pinMode(button1Pin, INPUT);
  pinMode(button2Pin, INPUT);
  pinMode(button3Pin, INPUT);
  pinMode(button4Pin, INPUT);

  pinMode(button5Pin, INPUT);
  pinMode(button6Pin, INPUT);
  pinMode(button7Pin, INPUT);
  pinMode(button8Pin, INPUT);
  Serial.begin(9600);
//  Serial.println('0');
  // put your setup code here, to run once:


}

void loop() {
  //if (Serial.available() > 0) {
    char inByte = Serial.read();
    int u1Op1 = digitalRead(button1Pin);
    int u1Op2 = digitalRead(button2Pin) + 2;
    int u1Op3 = digitalRead(button3Pin) + 4;
    int u1Op4 = digitalRead(button4Pin) + 6;

    int u2Op1 = digitalRead(button8Pin) + 10;
    int u2Op2 = digitalRead(button7Pin) + 12;
    int u2Op3 = digitalRead(button6Pin) + 14;
    int u2Op4 = digitalRead(button5Pin) + 16;
    
    if (u1Op1 == 1 &&  prevButton1 == LOW) {
      Serial.write(u1Op1);
    } else if (u1Op2 == 3 &&  prevButton2 == LOW) {
      Serial.write(u1Op2);
    }else if (u1Op3 == 5 &&  prevButton3 == LOW) {
      Serial.write(u1Op3);
    } else if (u1Op4 == 7 &&  prevButton4 == LOW) {
      Serial.write(u1Op4);
    }
    prevButton1 = u1Op1;
    prevButton2 = u1Op2 - 2;
    prevButton3 = u1Op3 - 4;
    prevButton4 = u1Op4 - 6;
    
    if (u2Op1 == 11 &&  prevButton5 == LOW) {
      Serial.write(u2Op1);
    }else if (u2Op2 == 13 &&  prevButton6 == LOW) {
      Serial.write(u2Op2);
    } else if (u2Op3 == 15 &&  prevButton7 == LOW) {
      Serial.write(u2Op3);

  } else if (u2Op4 == 17 &&  prevButton8 == LOW){
    Serial.write(u2Op4); 
  }
  prevButton5 = u2Op1 - 10;
  prevButton6 = u2Op2 - 12;
  prevButton7 = u2Op3 - 14;
  prevButton8 = u2Op4 - 16;
 
  }
