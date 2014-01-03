float a = 50;

float rotation = 0;
int steps = 1000;

boolean save = false;

void setup() {
  size(420,300);
}

void draw() {
  colorMode(RGB,255);
  background(0, 0, 0, 5);
  translate(width/2, height/2);
  strokeWeight(12);
  colorMode(HSB,360);
  for(int i = 0; i < 20; i++) {
    fill((360*(float)frameCount/steps)%360, 360f * i/10f, 100+260f*i/10);
    stroke((360*(float)frameCount/steps)%360, 360f * i/10f,  360f * i/10f);
    //noStroke();
    noFill();
    float inc = 0.05;
    for(float t = 0; t < TWO_PI; t += inc) {
      float t2 = t + inc;
      float x1 = a * (3*cos(t) + cos(3*t));
      float y1 = a * (3*sin(t) + sin(3*t));
      float x2 = a * (3*cos(t2) + cos(3*t2));
      float y2 = a * (3*sin(t2) + sin(3*t2));
      line(x1, y1, x2, y2);
      //ellipse(x1, y1, 6, 6);
    }
    rotate(PI/2 * sin(TWO_PI*frameCount/steps));
    scale(0.75);
  }
  if(save) {
    saveFrame("frames/frame-##.png");
    if(frameCount == steps) {
      noLoop();
    }
  }
}
