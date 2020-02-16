Apple a;
Snake s;
int boxSize = 20, score = 0;
boolean dead = false;

void setup() {
  size(window.innerWidth*0.95-window.innerWidth*0.95%boxSize,window.innerHeight*0.836-window.innerHeight*0.836%boxSize);
  frameRate(25);
  textAlign(CENTER);
  textSize(100);
  background(0);
  noStroke();
  a = new Apple(boxSize);
  s = new Snake(boxSize);
}

void draw() {
  background(0);
  if (!dead) {
    a.update();
    s.update();
  } else {
    text(score, width/2, height/2);
  }
}

void keyPressed() {
  if (!dead) {
    if (key == 'd') s.direct(0);
    else if (key == 'w') s.direct(1);
    else if (key == 'a') s.direct(2);
    else if (key == 's') s.direct(3);
  } else {
    if (key == ' ') dead = false; 
  }
}

public class Apple {
  
  private PVector pos;
  private int size;
  
  public Apple(int size) {
    pos = new PVector(int(random(width)),int(random(height)));
    this.size = size;
    pos.x -= pos.x%size;
    pos.y -= pos.y%size;
  }
  
  public void update() {
    fill(255);
    rect(pos.x,pos.y,size,size);
  }
  
  public PVector getPos() {
    return pos;
  }
}

public class Snake {

  private ArrayList<PVector> posList;
  private int size, frames = 0, facing; //0 = right, 1 = up, 2 = left, 3 = down
  private boolean toGrow;

  public Snake(int size) {
    posList = new ArrayList<PVector>();
    this.size = size;
    posList.add(new PVector(300, 300));
    facing = 0;
    toGrow = false;
  }

  public void update() {
    if (!dead) {
      fill(0, 255, 0);
      move(facing);
      if (frames < 0) frames = 0;
      for (PVector p : posList) {
        rect(p.x, p.y, size, size);
        if (PVector.dist(p,a.getPos()) < 3) grow();
        if (PVector.dist(posList.get(0),p) < 20 && !p.equals(posList.get(0))) die();
      }
    }
  }

  public void move(int f) {
    PVector pos;
    PVector head = new PVector(posList.get(0).x, posList.get(0).y);
    if (f == 0) pos = new PVector(head.x+size, head.y);
    else if (f == 1) pos = new PVector(head.x, head.y-size);
    else if (f == 2) pos = new PVector(head.x-size, head.y);
    else pos = new PVector(head.x, head.y+size);
    posList.add(0, checkOut(pos));
    if (!toGrow) {
      posList.remove(posList.size()-1);
    } else {
      toGrow = false;
    }
    frames--;
  }

  public void direct(int f) {
    if (abs(facing-f) != 2 && frames == 0) {
      facing = f;
      frames = 1;
    }
  }

  public PVector checkOut(PVector pos) {
    if (pos.x <= -size) pos.x = width-size;
    if (pos.x >= width) pos.x = 0;
    if (pos.y <= -size) pos.y = height-size;
    if (pos.y >= height) pos.y = 0;
    return pos;
  }

  public void grow() {
    a = new Apple(size);
    score++;
    toGrow = true;
  }

  public void die() {
    dead = true;
    a = new Apple(size);
    s = new Snake(size);
  }
}
