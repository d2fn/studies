import processing.pdf.PGraphicsPDF;

float noiseScale = 2f;
float lineHeight = 55.0f;
float lines = 10f;

float theta0 = 0;

long frame = 0L;

void setup() {
  size(600,500);//,PDF,"out.pdf");
  noiseDetail(0, 0.2);
  noiseSeed(0);
  stroke(40,40,40,255);
  strokeWeight(1);
}

void draw() {
  background(0);
  colorMode(HSB,360);
  stroke(frame*0.3%360,360,360,360);
  float arc = 2*PI;
  float rad = 40f;
  float inc = 0.01f;
  for(int i = 0; i < lines; i++) {
    for(float theta = 0; theta < arc; theta += inc) {
      float t = theta;// + theta0;
      float n1 = continuousNoise(theta);
      float n2 = continuousNoise(theta-inc);
      float r1 = (rad * n1);
      float r2 = (rad * n2);
      float x1 =  width/2f + r1 * cos(t);
      float x2 =  width/2f + r2 * cos(t-inc);
      float y1 = height/2f + r1 * sin(t);
      float y2 = height/2f + r2 * sin(t-inc);
      line(x1, y1, x2, y2);
    }
    rad += lineHeight;
  }
  
  stroke(100, 200, 360, 360);
  float x = 0f;
  float dx = width/(arc/inc);
  for(float theta = 0; theta < arc; theta += inc) {
    line(x, height-10-100*continuousNoise(theta), x-dx, height-10-100*continuousNoise(theta-inc));
    x += dx;
  }
  
  theta0 += 0.001f;
  frame++;
  //exit();  
}

float continuousNoise(float theta) {
  return noise((1000+frame*0.001+cos(theta))*noiseScale, (1000+10*cos(theta0)+sin(theta))*noiseScale);
}

