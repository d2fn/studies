import processing.pdf.PGraphicsPDF;

float noiseScale = 3f;
float lineHeight = 60.0f;
float lines = 20f;

float theta0 = -PI/4f;
long frame = 0L;

boolean saveFrames = true;

void setup() {
  size((int)(1.6*500), 500);//,PDF,"out.pdf");
  noiseDetail(0, 0.2);
  noiseSeed(0);
  stroke(40,40,40,255);
  strokeWeight(1);
  colorMode(HSB,360);
  background(0);
}

void draw() {
  //background(0, 0, 0);
  fill(0, 0, 0, 5);
  noStroke();
  rect(0, 0, width, height);
  stroke((360*theta0/TWO_PI)%360,360,360,360);
  float arc = TWO_PI;
  float rad = 10f;
  float inc = 0.01f;
  for(int i = 0; i < lines; i++) {
    for(float theta = 0; theta < arc; theta += inc) {
      float t = theta;// + theta0;
      float n1 = continuousNoise(theta);
      float n2 = continuousNoise(theta-inc);
      float r1 = rad + (rad * n1);
      float r2 = rad + (rad * n2);
      float x1 =  width/2f + r1 * cos(t);
      float x2 =  width/2f + r2 * cos(t-inc);
      float y1 = height/2f + r1 * sin(t);
      float y2 = height/2f + r2 * sin(t-inc);
      line(x1, y1, x2, y2);
    }
    rad += lineHeight;
  }
  
  stroke(0, 0, 200, 200);
  float x = 0f;
  float dx = width/(arc/inc);
  for(float theta = 0; theta < arc; theta += inc) {
    line(x, height-10-100*continuousNoise(theta), x-dx, height-10-100*continuousNoise(theta-inc));
    x += dx;
  }
  
  theta0 += 0.001f;
  frame++;
  
  if(saveFrames && theta0 >= 0) {
    saveFrame("frames/frame-#####.png");
    if(theta0 >= TWO_PI) {
      exit();
    }
  }  
}

float continuousNoise(float theta) { 
  float centerX = 10f * cos(theta0);
  float centerY = 10f * sin(theta0);
  return noise(centerX + noiseScale * cos(theta), centerY + noiseScale * sin(theta));
}

