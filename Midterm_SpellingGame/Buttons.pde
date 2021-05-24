  class Buttons {
    int xLoc, yLoc, buttonW, buttonH; 
    String buttonTitle;
    
    
    
  
    Buttons(int xLocTemp, int yLocTemp, int buttonWTemp, int buttonHTemp, String buttonTitleTemp) {
      xLoc = xLocTemp;
      yLoc = yLocTemp;
      buttonW = buttonWTemp;
      buttonH = buttonHTemp; 
      buttonTitle = buttonTitleTemp;
      
      
    }
  
  
  

  
  
    void buttonDisplay() {
      rectMode(CENTER);
       noStroke();
       fill(200);
       rect(xLoc, yLoc, buttonW, buttonH);
       fill(0);
       textSize(25);
       textAlign(CENTER,CENTER);
       text(buttonTitle, xLoc, yLoc);
      }
  }
