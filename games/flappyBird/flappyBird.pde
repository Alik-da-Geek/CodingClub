/* @pjs preload="data/CollisionSound.wav"; */
/* @pjs preload="data/InvincibilitySound.wav"; */
/* @pjs preload="data/JumpSound.wav"; */
/* @pjs preload="data/SlowMotionSound.wav"; */
/* @pjs preload="data/SpeedUpSound.wav"; */
/* @pjs preload="data/flappyBird.png"; */
/* @pjs preload="data/invincible.png"; */
/* @pjs preload="data/slowMo.png"; */
/* @pjs preload="data/speedUp.png"; */


import processing.sound.*;
float x, y, r=25;
float velY=0, accY=0.25, upBoost=-7;
float velPipes=-3;
int score;
PImage player, invincibleImg, slowMoImg, speedUpImg;
boolean up=false, alive=true;
boolean slowMoPowerup=false, slowMo=false;
boolean invinciblePowerup=false, invincible=false;
boolean speedUpPowerup=false, speedUp=false;
SoundFile invincibleSound, slowMoSound, speedUpSound, collisionSound, jumpSound;
ArrayList<Pipe> pipes;
int slowMoFrame, invincibleFrame, speedUpFrame;
SlowMo slow;
Invincible inv;
SpeedUp speed;
void setup() {
  player=loadImage("flappyBird.png");
  invincibleImg=loadImage("invincible.png");
  slowMoImg=loadImage("slowMo.png");
  speedUpImg=loadImage("speedUp.png");
  invincibleSound= new SoundFile(this, "InvincibilitySound.wav");
  slowMoSound= new SoundFile(this, "SlowMotionSound.wav");
  speedUpSound= new SoundFile(this, "SpeedUpSound.wav");
  collisionSound=new SoundFile(this, "CollisionSound.wav");
  jumpSound=new SoundFile(this, "JumpSound.wav");
  frameRate(60);
  size(window.innerHeight*0.836, window.innerHeight*0.836);
  y=height/2;
  x=width/4;
  alive=true;
  velY=0;
  pipes=new ArrayList<Pipe>();
  score=0;
  slow=new SlowMo();
  slow.reset();
  inv=new Invincible();
  inv.reset();
  speed=new SpeedUp();
  speed.reset();
}
void draw() {
  if (alive) {
    background(#3ddeff);
    powerups();
    move();
    drawMap();
    spawnPipes();
    movePipes();
    if (!invincible) collide();
  } else {
    dead();
  }
  score();
}
void move() {
  velY+=accY;
  y+=velY;
  for (Pipe p : pipes) {
    if (Math.abs(p.x-x)<=1.0) score++;
  }
}
void drawMap() {
  image(player, x-r/2-2, y-r/2, r+4, r);
  fill(#00d100);
  rect(0, height/8*7, width, height);
  fill(#f7ea33);
  noStroke();
  int sunSize=200;
  ellipse(width-10, 10, sunSize, sunSize);
  stroke(0);
}
void spawnPipes() {
  if (frameCount%100==0) {
    pipes.add(new Pipe());
  }
}
void movePipes() {
  for (int i=0; i<pipes.size(); i++) {
    if (pipes.get(i).x+pipes.get(i).w<0) {
      pipes.remove(i);
    } else {
      pipes.get(i).move(velPipes);
      pipes.get(i).drawPipe();
    }
  }
}
void collide() {
  if (y-r<-5) {
    alive=false;
    collisionSound.play();
  } else if (y+r>height/8*7+5) {
    alive=false;
    collisionSound.play();
  } else {
    for (int i=0; i<pipes.size(); i++) {
      Pipe p= pipes.get(i);
      if ((x+r/2>p.x-p.w&&x+r/2<p.x)||(x-r/2>p.x-p.w&&x-r/2<p.x)) {
        if (x==p.x-p.w/2) score+=10;
        if (y-r/2<p.yTop||y+r/2>p.yBottom) {
          alive=false;
          collisionSound.play();
        }
      }
    }
  }
}
void score() {
  fill(0);
  textSize(25);
  textAlign(CENTER, TOP);
  text("score: "+score, width/2, 20);
}
void powerups() {
  int gapTime=900;
  if (frameCount%gapTime==0)  slowMoPowerup=true;
  if (frameCount%gapTime==gapTime/3) invinciblePowerup=true;
  if (frameCount%gapTime==gapTime*2/3) speedUpPowerup=true;
  //slow motion
  if (slowMoPowerup) {
    slow.move(velPipes*2);
    image(slowMoImg, slow.x-slow.r/2, slow.y-slow.r/2, slow.r, slow.r);
    if (slow.collide(x, y, r)) {
      slowMoSound.play();
      frameRate(30);
      slowMoFrame=frameCount;
      slowMoPowerup=false;
      slowMo=true;
      slow.reset();
    } else if (slow.offScreen()) {
      slowMoPowerup=false;
      slow.reset();
    }
  }
  if (slowMoFrame+150<=frameCount) {
    slowMo=false;
  } else if (slowMo) {
    fill(0);
    int a=15+(slowMoFrame-frameCount)/10;
    text("slow mo: "+a, width/2, 50);
  }
  //invincible
  if (invinciblePowerup) {
    image(invincibleImg, inv.x-inv.r/2-4, inv.y-inv.r/2+2, inv.r, inv.r);
    inv.move(velPipes*2);
    if (inv.collide(x, y, r)) {
      invincibleSound.play();
      invincibleFrame=frameCount;
      invinciblePowerup=false;
      invincible=true;
      inv.reset();
    } else if (inv.offScreen()) {
      invinciblePowerup=false;
      inv.reset();
    }
  }
  if (invincibleFrame+150<=frameCount) {
    invincible=false;
  } else if (invincible) {
    fill(0);
    int a=15+(invincibleFrame-frameCount)/10;
    text("invincible: "+a, width/2, 50);
  }
  //speed up
  if (speedUpPowerup) {
    image(speedUpImg, speed.x-speed.r/2-3, speed.y-speed.r/2+1, speed.r, speed.r);
    speed.move(velPipes*2);
    if (speed.collide(x, y, r)) {
      speedUpSound.play();
      frameRate(90);
      speedUpFrame=frameCount;
      speedUpPowerup=false;
      speedUp=true;
      speed.reset();
    } else if (speed.offScreen()) {
      speedUpPowerup=false;
      speed.reset();
    }
  }
  if (speedUpFrame+200<=frameCount) {
    speedUp=false;
  } else if (speedUp) {
    fill(0);
    int a=20+(speedUpFrame-frameCount)/10;
    text("speed up: "+a, width/2, 50);
  }
  //reset speed
  if (speedUp==false&&slowMo==false) frameRate(60);
}
void dead() {
  fill(0);
  textSize(25);
  textAlign(CENTER, BOTTOM);
  text("you died", width/2, height/2);
  text("press r to restart", width/2, height/2+50);
}
void keyPressed() {
  if (keyCode==UP&&alive) {
    velY=upBoost;
    jumpSound.play();
  }
  if (key=='r') setup();
}

public class Pipe {
  public float x, yTop, yBottom;
  public float w=50, spacing=150;
  Pipe() {
    x=width+w;
    yTop=random(width/6,width/5*3);
    yBottom=yTop+spacing;
  }
  void move(float velX) {
    x+=velX;
  }

  void drawPipe() {
    fill(#2377ff);
    rect(x-w, 0, w, yTop);
    rect(x-w, yBottom, w, height/8*7-yBottom);
  }
}

public class Invincible {
  public float x, y, r=25, velY=0;
  public int frame;
  Invincible() {
    x=width-r;
    if (random(0, 1)==1) {
      y=height*7/8-r;
      velY=-3;
    } else {
      y=r;
      velY=3;
    }
  }
  void move(float velX) {
    y+=velY;
    x+=velX;
    if (y-r<0||y+r>height*7/8) velY*=-1;
  }
  boolean collide(float xBird, float yBird, float rBird) {
    float size=r+rBird;
    float dif=dist(xBird, yBird, x, y);
    return dif<=size;
  }
  boolean offScreen() {
    return x+r<0;
  }
  void reset() {
    x=width-r;
    if (random(0, 1)==1) {
      y=height*7/8-r;
      velY=-3;
    } else {
      y=r;
      velY=3;
    }
  }
}

public class SlowMo {
  public float x, y, r=25, velY=0;
  SlowMo() {
    x=width-r;
    if (Math.round(random(0, 1))==1) {
      y=height*7/8-r;
      velY=-3;
    } else {
      y=r;
      velY=3;
    }
  }
  void move(float velX) {
    y+=velY;
    x+=velX;
    if (y-r<0||y+r>height*7/8) velY*=-1;
  }
  boolean collide(float xBird, float yBird, float rBird) {
    float size=r+rBird;
    float dif=dist(xBird, yBird, x, y);
    return dif<=size;
  }
  boolean offScreen() {
    return x+r<0;
  }
  void reset() {
    x=width-r;
    if (Math.round(random(0, 1))==1) {
      y=height*7/8-r;
      velY=-3;
    } else {
      y=r;
      velY=3;
    }
  }
}

public class SpeedUp {
  public float x, y, r=25, velY=0;
  SpeedUp() {
    x=width-r;
    if (Math.round(random(0, 1))==1) {
      y=height*7/8-r;
      velY=-3;
    } else {
      y=r;
      velY=3;
    }
  }
  void move(float velX) {
    y+=velY;
    x+=velX;
    if (y-r<0||y+r>height*7/8) velY*=-1;
  }
  boolean collide(float xBird, float yBird, float rBird) {
    float size=r+rBird;
    float dif=dist(xBird, yBird, x, y);
    return dif<=size;
  } 
  boolean offScreen() {
    return x+r<0;
  }
  void reset() {
    x=width-r;
    if (Math.round(random(0, 1))==1) {
      y=height*7/8-r;
      velY=-3;
    } else {
      y=r;
      velY=3;
    }
  }
}
