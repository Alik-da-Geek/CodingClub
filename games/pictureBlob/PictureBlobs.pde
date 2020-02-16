/* @pjs preload="/assets/westy.png"; */

PImage img; 
int interval;
ArrayList<Circle> circles;

void setup() {
  size(800, 600);
  circles = new ArrayList<Circle>();
  img = loadImage("/assets/westy.png");
  img.resize(width, height);
  //Use interval to change the resolution (lower number = higher resolution)
  interval = 12;
  for (int r = 0; r < 2*width/interval; r++) {
    for (int c = 0; c < height/interval; c++) {
      circles.add(new Circle(r*interval/2+interval/2, c*interval+interval/2+interval/2*(r%2)));
    }
  } 
}

void draw() {
  //image(img, 0, 0);
  background(0);
  for (Circle c : circles) c.update();
}

class Circle {
  
  PVector pos, vel, acc;
  PVector target;
  color c;
  
  Circle(int x, int y) {
    pos = new PVector(x,y);
    target = new PVector(x,y);
    vel = new PVector();
    acc = new PVector();
    if (x >= width && y >= height) this.c = img.get(int(width-1),int(height-1));
    else if (x >= width) this.c = img.get(int(width-1),int(pos.y));
    else if (y > height) this.c = img.get(int(pos.x),int(height-1));
    else this.c = img.get(int(pos.x),int(pos.y));
  }
  
  void update() {
    acc = PVector.sub(target, pos);
    if (mousePressed) mouseForce();
    acc.limit(7);
    vel.add(acc);
    vel.limit(100);
    pos.add(vel);
    vel.mult(0.66);
    fill(c);
    noStroke();
    ellipse(pos.x,pos.y,interval,interval);
  }
  
  void mouseForce() {
    PVector mouse = new PVector(mouseX,mouseY);
    mouse.sub(pos);
    mouse.setMag(5000/mouse.mag());
    acc.sub(mouse);
  }
  
}
