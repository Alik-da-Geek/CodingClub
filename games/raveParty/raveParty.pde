int rows = 25;
int cols = 50;
square[][] arr = new square[rows][cols];

void setup() {
  size(window.innerWidth*0.9,window.innerHeight*0.836);
  colorMode(HSB);
  background(255);
  stroke(0);
  rectMode(CENTER);
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      arr[r][c] = new square((c+0.5)*width/cols, (r+0.5)*height/rows, width/cols, height/rows);
    }
  }
}

void draw() {
  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      arr[r][c].update();
      if (arr[r][c].scale > 1 && arr[r][c].scale < 2.8) {
        if (r+1 != rows) {
          if (arr[r+1][c].scale == 1) {
            arr[r+1][c].setScale(3);
          }
        }
        if (r-1 != -1) {
          if (arr[r-1][c].scale == 1) {
            arr[r-1][c].setScale(3);
            arr[r-1][c].update();
          }
        }
        if (c+1 != cols) {
          if (arr[r][c+1].scale == 1) {
            arr[r][c+1].setScale(3);
          }
        }
        if (c-1 != -1) {
          if (arr[r][c-1].scale == 1) {
            arr[r][c-1].setScale(3);
            arr[r][c-1].update();
          }
        }
      }
    }
  }
}

void mousePressed() {
  for (int r = 0; r < rows; r++) {
    for (square s : arr[r]) {
      if (s.pos.x-s.lenx/2 <= mouseX && s.pos.x+s.lenx/2 >= mouseX && s.pos.y-s.leny/2 <= mouseY && s.pos.y+s.leny/2 >= mouseY) {
        if (s.scale == 1) {
          s.setScale(3);
        }
      }
    }
  }
}

public class square {

  PVector pos;
  int lenx, leny;
  color c;
  float scale = 1;

  public square(float x, float y, int lenx, int leny) {
    this.pos = new PVector(x, y);
    this.lenx = lenx;
    this.leny = leny;
    c = color(0);
  }

  public void update() {
    c = color(random(256), 255, (scale-1)*255);
    if (scale < 1.0001) scale = 1;
    else {
      scale = scale * .96;
    }
    fill(c);
    rect(pos.x, pos.y, lenx, leny);
  }

  public void setScale(float s) {
    scale = s;
  }
}
