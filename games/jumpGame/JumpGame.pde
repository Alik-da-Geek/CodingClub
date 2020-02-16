float ballRadius=10, padWidth=50, padHeight=10;
int numPads=6;
float bounceY=6.5, maxSpeed=10;
float deceleration=0.6, accX=1;

int score=0;
float padSpeed=0.5;
boolean isDead=false;
pad lastPad;
private PVector pos, vel, acc;
ArrayList<pad> pads=new ArrayList<pad>();

void setup() {
  size(window.innerWidth*0.5,window.innerHeight*0.836);
  background(245, 245, 220);
  pos= new PVector(width/2, height-50-ballRadius*2);
  vel= new PVector(0, 0);
  acc=new PVector(0, 0.2);
  lastPad=new pad(0, 0);
  spawnFirstPads();
}

void draw() {
  paint();
  if(!isDead){
    move();
    movePads();
  } else {
    dead();
  }
}

void paint() {
  background(245, 245, 220);
  fill(255, 0, 255);
  ellipse(pos.x, pos.y, ballRadius, ballRadius);
  fill(0);
  for (pad p : pads) {
    rect(p.x, p.y, padWidth, padHeight);
  }
  textAlign(CENTER);
  textSize(16);
  text("Your Score: " + score, width-65, 25 );
}
void move() {
  //move ball x
  if (keyPressed==true) {
    if (keyCode==37) {
      if (vel.x>-maxSpeed) vel.x-=accX;
    } else if (keyCode==39) {
      if (vel.x<maxSpeed) vel.x+=accX;
    }
  } else vel.x*=deceleration;
  //go through side
  if (pos.x>width) pos.x=ballRadius;
  else if (pos.x<0) pos.x=width-ballRadius;
  //bounce on pads
  float sizeX=ballRadius+padWidth/2;
  float sizeY=ballRadius+padHeight/2;
  for (pad p : pads) {
    float difX=Math.abs(p.x+padWidth/2-pos.x);
    float difY=Math.abs(p.y+padHeight/2-pos.y);
    if (difX<=sizeX&&difY<=sizeY) {
      vel.y=-bounceY;
      lastPad.x=p.x;
      lastPad.ID(p.ID());
    }
  }
  //check dead
  if (pos.y>height) isDead=true;

  pos.x+=vel.x;
  pos.y+=vel.y;
  vel.x+=acc.x;
  vel.y+=acc.y;
}
void spawnFirstPads() {
  float padY=height-padHeight-50;
  pads.add(new pad((width-padWidth)/2, padY));
  for (int i=0; i<numPads-1; i++) {
    padY-=100;
    pads.add(new pad((float)(Math.random()*(width-padWidth)), padY));
  }
}
void movePads() {
  if (pos.y<300) padSpeed=1+(300-pos.y)/200;
  else padSpeed=0;

  for (int i=0; i<pads.size(); i++) {
    pads.get(i).y+=padSpeed;
    if (pads.get(i).y>height) {
      pads.remove(i);
      i--;
      score++;
    }
  }
  while (pads.size()<numPads) {
    pads.add(new pad((float)Math.random()*(width-padWidth), 0));
  }
}
void dead() {
  fill(0);
  textAlign(CENTER);
  textSize(32);
  text("ya died",width/2,height/2-75);
  text("press space to play again", width/2, height/2);
  if(keyCode==32){
    isDead=false;
    score=0;
    while(pads.size()>0) pads.remove(pads.size()-1);
    setup();
  }
}

public class pad {
  private float x, y;
  private int id;
  public pad(float x1, float y1) {
    this.x=x1;
    this.y=y1;
    this.id=(int)(Math.random()*1000);
  }
  public int ID(){
    return this.id;
  }
  public void ID(int a){
    this.id=a;
  }
}