import java.util.*;
import processing.pdf.PGraphicsPDF;

float pathNoiseScale = 4f;
float girthNoiseScale = 3f;

int bgcolor = color(221, 218, 206);

void setup() {
  size(1000,1000);//,PDF,"out.pdf");
  background(bgcolor);
  noiseDetail(3, 0.3);
  randomSeed(0);
  noiseSeed(0);
  float numLines = 10;
  for(float i = 0; i < numLines; i++) {
    drawPath(0, i+1, 0, 0);
  }
}

void drawPath(float heading, float iteration, float startX, float startY) {
  float maxX = 30;
  for(float x = 0; x <= maxX; x+= 0.01) {
      float nrand = noise(iteration*pathNoiseScale*100, x*pathNoiseScale);
      float dir = map(nrand, 0, 1, -PI/2, 3*PI/2);
      dir += heading; 
      startX += cos(dir);
      startY += sin(dir);
      float px = startX;
      float py = startY;
      float wrand = noise(startX*girthNoiseScale/100, startY*girthNoiseScale/100);
      float girth = map(wrand, 0, 1, 1, 40);
      Point p = new Point(px, py, girth);
      p.draw();
    }
}

void draw() {
  //exit();
  noLoop();
}
