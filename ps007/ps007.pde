import processing.pdf.PGraphicsPDF;

float noiseScale = 0.7f;
float lineHeight = 130.0f;
float r0 = 60;
float lines = 2f;

float theta0 = -PI/4f;
long frame = 0L;

boolean saveFrames = false;

int w = 600;

void setup() {
  size((int)(1.6*w), w);//,PDF,"out.pdf");
  noiseDetail(0, 0.2);
  noiseSeed(8);
  stroke(40, 40, 40, 255);
  strokeWeight(2);
  strokeCap(SQUARE);
  background(208, 239, 234);
  smooth();
  frameRate(120);
}

void draw() {
  
  //background(0, 0, 0);
  fill(0, 0, 0, 0);
  noStroke();
  rect(0, 0, width, height);
  //colorMode(HSB, 360);
  //stroke((360*theta0*4f/TWO_PI)%360, 360/*theta0*6/TWO_PI*/, 360, 10);
  stroke(0, 47, 183, 30);
  float arc = TWO_PI;
  float rad = r0;
  float inc = 0.01f;
  float centerX = frame-r0-100;//width/2f;
  float centerY = height/2f;
  for (int i = 0; i < lines; i++) {
    for (float theta = 0; theta < arc; theta += inc) {
      float t = theta;// + theta0;
      float n1 = continuousNoise(theta);
      float n2 = continuousNoise(theta-inc);
      float r1 = rad + (rad * n1);
      float r2 = rad + (rad * n2);
      float x1 =  centerX + r1 * cos(t);
      float x2 =  centerX + r2 * cos(t-inc);
      float y1 = centerY + r1 * sin(t);
      float y2 = centerY + r2 * sin(t-inc);
      line(x1, y1, x2, y2);
    }
    rad += lineHeight;
  }

  /**
  stroke(0, 0, 200, 200);
  float x = 0f;
  float dx = width/(arc/inc);
  for (float theta = 0; theta < arc; theta += inc) {
    line(x, height-10-100*continuousNoise(theta), x-dx, height-10-100*continuousNoise(theta-inc));
    x += dx;
  }
  **/

  theta0 += 0.001f;
  frame++;

  if (saveFrames) {
    saveFrame("frames/frame-#####.png");
    if (theta0 >= TWO_PI) {
      exit();
    }
  }
}

float continuousNoise(float theta) { 
  float centerX = 10f * cos(theta0);
  float centerY = 10f * sin(theta0);
  return noise(centerX + noiseScale * cos(theta), centerY + noiseScale * sin(theta));
}

