Apple a;
Snake s;
int size = 20, score = 0;
boolean dead = false;

void setup() {
  size(600,600);
  frameRate(25);
  textAlign(CENTER);
  textSize(100);
  background(0);
  noStroke();
  a = new Apple(size);
  s = new Snake(size);
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
  private boolean grow;

  public Snake(int size) {
    posList = new ArrayList<PVector>();
    this.size = size;
    posList.add(new PVector(300, 300));
    facing = 0;
    grow = false;
  }

  public void update() {
    if (!dead) {
      fill(0, 255, 0);
      move(facing);
      if (frames < 0) frames = 0;
      if (posList.get(0) == a.getPos()) grow();
      for (PVector p : posList) {
        rect(p.x, p.y, size, size);
        if (p.equals(a.getPos())) grow();
        if (posList.indexOf(p) != posList.lastIndexOf(p)) die();
      }
    }
  }

  public void move(int f) {
    PVector pos;
    if (f == 0) pos = new PVector(posList.get(0).copy().x+size, posList.get(0).copy().y);
    else if (f == 1) pos = new PVector(posList.get(0).copy().x, posList.get(0).copy().y-size);
    else if (f == 2) pos = new PVector(posList.get(0).copy().x-size, posList.get(0).copy().y);
    else pos = new PVector(posList.get(0).copy().x, posList.get(0).copy().y+size);
    posList.add(0, checkOut(pos));
    if (!grow) {
      posList.remove(posList.size()-1);
    } else {
      grow = false;
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
    if (pos.x == -size) pos.x = width-size;
    if (pos.x == width) pos.x = 0;
    if (pos.y == -size) pos.y = height-size;
    if (pos.y == width) pos.y = 0;
    return pos;
  }

  public void grow() {
    a = new Apple(size);
    score++;
    grow = true;
  }

  public void die() {
    dead = true;
    a = new Apple(size);
    s = new Snake(size);
  }
}
