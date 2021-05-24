PImage tvFrame;
PImage noSignal;
PImage months[];

String gratefulFor[];
PFont f;
int picsNumber;
int time = 0;
int slideDuration = 100;
int currentSlide = 0;



void setup() {
  size(1000, 1000); 
  f = createFont("Nocturne-Rough.otf",60);
  textFont(f);
  tvFrame = loadImage("tv_frame.png");
  tvFrame.resize(1000, 760);

  noSignal = loadImage("noSignal.jpg");
  noSignal.resize(500, 500);
  picsNumber = 9;
  months = new PImage[picsNumber];
  months[0] = loadImage("jan.JPG");
  months[1] = loadImage("feb.JPG");
  months[2] = loadImage("march.jpg");
  months[3] = loadImage("april.jpg");
  months[4] = loadImage("may.JPG");
  months[5] = loadImage("june.jpg");
  months[6] = loadImage("july.JPG");
  months[7] = loadImage("aug.JPG");
  months[8] = loadImage("sept.jpg");
  for (int i = 0; i < months.length; i++) {
    months[i].resize(600, 600);
  }
  gratefulFor = new String[picsNumber];
  gratefulFor[0] = "January: travel";
  gratefulFor[1] = "February: live music";
  gratefulFor[2] = "March: safety";
  gratefulFor[3] = "April: windows";
  gratefulFor[4] = "May: family";
  gratefulFor[5] = "June: archives/memories";
  gratefulFor[6] = "July: nature";
  gratefulFor[7] = "August: loss";
  gratefulFor[8] = "September: friendship";
}



void draw() {
  background(225, 205, 181);
  imageMode(CENTER);
  image(months[currentSlide], width/2-80, height/2-60);
  fill(0);
  textSize(50);
  text(gratefulFor[currentSlide], width/2 - 450, height/2 + 450);

  time+=1;
  if (time>slideDuration) {
    currentSlide +=1;
    if (currentSlide > months.length-1) {
      currentSlide = 0;
    }
    time = 0;
  }







  int glitchNo = (int)(random(1, 5));
  if (glitchNo == 1) {
    glitch1();
  } else if (glitchNo ==2) {
    glitch2();
  } else if (glitchNo == 3) {
    glitch3();
  } else if (glitchNo == 4) {
    glitch4();
  }
  image(tvFrame, width/2, height/2-100);
}




void glitch1() {
  image(months[currentSlide], width/2-80, height/2-60); 
  blend(noSignal, width/2-80-300, height/2-60-300, 600, 600, width/2-80-300, height/2-60-300, 600, 600, MULTIPLY);
}

void glitch2() {
  pushStyle();
  tint(255, 20);
  if (time%7 == 0) {
    PImage subSection = months[currentSlide].get(300, 300, 500, 200);
    PImage subSection2 = months[currentSlide].get((int)random(0, 550), (int)random(0, 550), 100, 400);
    PImage subSection3 = months[currentSlide].get((int)random(0, 550), (int)random(0, 550), 50, 200);

    image(subSection, random(width/2-80-100, width/2-80), random(height/2-60-300, height/2-60));
    image(subSection2, random(width/2-80-100, width/2-80), random(height/2-60-200, height/2-30));
    image(subSection3, random(width/2-80-100, width/2-80), random(height/2-60-200, height/2-30));
    //subSection.filter(INVERT);
    subSection2.filter(INVERT);
    months[currentSlide].filter(INVERT);
  }
  popStyle();
}

void glitch3() {
  
image(months[currentSlide], width/2-80, height/2-60);
  
}

void glitch4() {
  months[currentSlide].loadPixels();
  for (int x = 0; x < months[currentSlide].width; x++) {
    for (int y = 0; y < random(months[currentSlide].height-400, months[currentSlide].height); y++) { 
      float pix = random(255);
      months[currentSlide].pixels[x+y*months[currentSlide].width] = color(pix);
    }
  }

  updatePixels();
}
