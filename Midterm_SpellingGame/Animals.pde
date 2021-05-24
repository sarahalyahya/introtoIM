class Animals {
  //two vars for animal name and to load the suitable image
  String animalName;
  PImage animalImage;
  
  
  Animals(String tempAnimalName){
    animalName = tempAnimalName;
    //using animal name to load the image
    animalImage = loadImage(animalName+".png");
    animalImage.resize(300,300);
  }
  
  
  void display(){
   fill(0,255,0);
   imageMode(CENTER);
   image(animalImage,width/2-50,height/2);
   //rect(width/2,height/2,100,100);
   //fill(0);
   //textAlign(CENTER,CENTER);
   //textSize(15);
   //text("I am a" + " " + animalName, width/2,height/2);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
