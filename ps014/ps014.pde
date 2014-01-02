float a = 50;

float rotation = 0;
int steps = 50;

void setup() {
  size(420,300);
}

void draw() {
  background(0, 0, 0);
  translate(width/2, height/2);
  stroke(94, 100, 240);
  strokeWeight(3);
  for(int i = 0; i < 10; i++) {
    float inc = 0.025;
    for(float t = 0; t < TWO_PI; t += inc) {
      float t2 = t + inc;
      float x1 = a * (3*cos(t) + cos(3*t));
      float y1 = a * (3*sin(t) + sin(3*t));
      float x2 = a * (3*cos(t2) + cos(3*t2));
      float y2 = a * (3*sin(t2) + sin(3*t2));
      line(x1, y1, x2, y2);
    }
    rotate(PI/16 * sin(TWO_PI*frameCount/steps));
    scale(0.75);
  }
  saveFrame("frames/frame-##.png");
  if(frameCount == steps) {
    noLoop();
  }
}
