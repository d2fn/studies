import processing.pdf.PGraphicsPDF;

float noiseScale = 0.03f;
float lineHeight = 8.0f;

float theta0 = 0;
float weight = 0.3;
long frame = 0L;

void setup() {
  size(750,750);
  noiseDetail(0, 0.2);
  noiseSeed(0);
  background(0);
}

void draw() {
  colorMode(HSB, 360);
  stroke(frame*0.5%360, 360, 360, 360);
  strokeWeight(weight);
  float rad = 10f;
  float inc = 0.05f;
  for(float theta = theta0; theta < TWO_PI + theta0; theta += inc) {
    float x1 = width/2f  + rad * cos(theta);
    float x2 = width/2f  + rad * cos(theta-inc);
    float y1 = height/2f + rad * sin(theta);
    float y2 = height/2f + rad * sin(theta-inc);
    rad += lineHeight;
    line(x1, y1, x2, y2);
  }
  theta0 += 0.05f;
  weight += 0.01;
  frame++;  
}

