import java.util.*;
import processing.pdf.PGraphicsPDF;

float pathNoiseScale = 0.1f;
float girthNoiseScale = 0.04f;

int bgcolor = color(221, 218, 206);

List<Path> paths;

void setup() {
  size(1000,1000);//,PDF,"out.pdf");
  
  noiseDetail(3, 0.5);
  randomSeed(0);
  noiseSeed(0);
  
  int numPaths = 1;
  int pointsPerPath = 1000;
  paths = new ArrayList<Path>(numPaths);
  println("building paths");
  for(float i = 0; i < numPaths; i++) {
    Path p = new Path(pointsPerPath, 0.5, 100, 100);
    for(int j = 0; j < pointsPerPath; j++) {
      //p.step();
    }
    paths.add(p);
  }
  println("done building paths");
}

void drawPath(float heading, float iteration, float startX, float startY) {
  float maxX = 1900;
  float randline = random(0, 1000);
  float inc = 0.01;
  for(float x = 0; x <= maxX; x+= inc) {
      float nrand = noise(x*pathNoiseScale, randline);
      float dir = map(nrand, 0, 1, -PI/2, PI/2);
      dir += heading; 
      startX += inc * cos(dir);
      startY += inc * sin(dir);
      float px = startX;
      float py = startY;
      float wrand = noise(startX*girthNoiseScale, startY*girthNoiseScale);
      float girth = map(wrand, 0, 1, 4, 25);
      Point p = new Point(px, py, girth);
      p.draw();
    }
}

void draw() {
  background(bgcolor);
  
  for(Path p : paths) {
    p.step();
    p.draw();
  }
  //exit();
  //noLoop();
}
