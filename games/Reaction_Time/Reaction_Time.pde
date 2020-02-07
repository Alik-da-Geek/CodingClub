int state;
int startTime;
int randTime;
void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  state = 0;
}

void draw() {
  background(100);
  if (state == 0) {
    textSize(32);
    fill(255);
    text("REACTION TIME TEST!\nPress SPACE to begin", width/2, height/3);
    clock(width/2, 2*height/3, 150);
  } else if (state == 1) {
    textSize(32);
    fill(255);
    text("When the clock turns green\nhit a key!", width/2, height/3);
    clock(width/6, 2*height/3, 150);
    line(width/6+150/2, 2*height/3, 5*width/6-150/2, 2*height/3);
    fill(0, 255, 0);
    ellipse(5*width/6, 2*height/3, 150, 150);
  } else if (state == 2) {
    if (millis() >= randTime) {
      fill(0, 255, 0);
      ellipse(width/2, height/2, 200, 200);
    } else clock(width/2, height/2, 200);
  } else if (state == 3) {
    fill(255);
    textSize(32);
    text("Reaction Time: " + startTime + "ms\nprobably trash tbh", width/2, height/2);
  } else if (state == 4) {
    fill(255);
    textSize(32);
    text("BOI\ndon't jump next time", width/2, height/2);
  }
}

void clock(int x, int y, int d) {
  fill(255);
  ellipse(x, y, d, d);
  line(x, y, 0.75*d/2*cos(millis()/1000.)+x, 0.75*d/2*sin(millis()/1000.)+y);
  line(x, y, d/6*cos(millis()/1000./12)+x, d/6*sin(millis()/1000./12)+y);
  fill(0);
  textSize(12);
  for (int i = 0; i < 12; i++) {
    text(i+1, x+0.9*d/2*cos(PI*(i-2)/6), y+0.9*d/2*sin(PI*(i-2)/6));
  }
}

void keyPressed() {
  state = (state+1)%4;
  if (state == 2) {
    startTime = millis();
    randTime = int(random(startTime+2000, startTime+8000));
  }
  if (state == 3 && millis() < randTime) state = 4;
  else if (state == 3) startTime = millis()-randTime;
}
