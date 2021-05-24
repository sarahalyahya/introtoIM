ArrayList<Particle> pts;
boolean yes;
int coolingTime;

//drawing particles of our "bloom" 
void drawcool(PGraphics pg, Integer x, Integer y, float a, float b, float c, float d, float e, float f) {  
  pg.beginDraw(); //begin drawing onto PGraphics layer
  if (yes) //if it doesn't need to stop yet
  { 
    //add particles to a bloom
    for (int i=0;i<10;i++) {
      Particle newP = new Particle(x, y, i+pts.size(), i+pts.size(), a,b,c,d,e,f);
      pts.add(newP);
    }
    
  }
  //update and display the particles
  for (int i=0; i<pts.size(); i++) {
    Particle p = pts.get(i);
    p.update();
    p.display(pg);
  }
  //remove particles from the Arraylist once they're dead/no longer moving
  for (int i=pts.size()-1; i>-1; i--) {
    Particle p = pts.get(i);
    if (p.dead) 
    {
      pts.remove(i);
    }
   
  }
  coolingTime++;
  stop(); //to set the variable "yes" back to false
  pg.endDraw(); //stop drawing onto the PGraphics layer
}

void stop(){
  if (coolingTime>1)
  {
    yes = false;
    coolingTime = 0;
  }
}

//CLASS OUR "BLOOM" USES
//CREDITS TO POST FROM OPENPROCESSING 
class Particle{
  PVector loc, vel, acc;
  int lifeSpan, passedLife;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  color c;
  float a, b,cc,d,e,f; 
  
  Particle(float x, float y, float xOffset, float yOffset, float thisa , float thisb , float thisc, float thisd, float thise ,float thisf){
    loc = new PVector(x,y);
    a = thisa;
    b = thisb;
    cc = thisc;
    d = thisd;
    e = thise;
    f = thisf;
    
    float randDegrees = random(360);
    vel = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    vel.mult(random(1));
    
    // ****************
    //VARIABLES WE SET IN THE CONSTRUCTOR TO CONTROL THE SIZE AND SHAPE OF OUR "BLOOM"
    acc = new PVector(0,0);
    lifeSpan = int(random(a, b)); 
    decay = random(cc, d); 
    c = color (random(255), random(255), 255, 75);
    weightRange = random(e,f);
    
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
  
  void update(){
    if(passedLife>=lifeSpan){
      dead = true;
    }else{
      passedLife++;
    }
    
    alpha = float(lifeSpan-passedLife)/lifeSpan * 70+50;
    weight = float(lifeSpan-passedLife)/lifeSpan * weightRange;
    
    acc.set(0,0);
    
    float rn = (noise((loc.x+frameCount+xOffset)*0.01, (loc.y+frameCount+yOffset)*0.01)-0.5)*4*PI;
    float mag = noise((loc.y+frameCount)*0.01, (loc.x+frameCount)*0.01);
    PVector dir = new PVector(cos(rn),sin(rn));
    acc.add(dir);
    acc.mult(mag);
    
    float randDegrees = random(360);
    PVector randV = new PVector(cos(radians(randDegrees)), sin(radians(randDegrees)));
    randV.mult(0.5);
    acc.add(randV);
    
    vel.add(acc);
    vel.mult(decay);
    vel.limit(3);
    loc.add(vel);
  }
  
 //displaying onto a PGraphics layer
 void display(PGraphics pg){
    pg.beginDraw();
    pg.strokeWeight(0);
    pg.stroke(0, alpha);
    pg.point(loc.x, loc.y);
    
    pg.strokeWeight(weight);
    pg.stroke(c);
    pg.point(loc.x, loc.y);
    pg.tint (255,125);
    pg.endDraw();
  }
}
