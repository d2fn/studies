import processing.pdf.PGraphicsPDF;
import java.io.*;
import java.util.*;

//int bg = color(50, 90, 183);
//int bg = color(208, 239, 234);
int bg = color(221, 218, 206);
//int bg = color(19, 19, 19, 15);
int fg = color(19, 19, 19, 15);

float girthNoiseScale = 0.025;
float jitterNoiseScale = 0.025;
float timeNoiseScale = 0.01;

boolean pdf = true;
boolean png = true;

int frame = 0;

long time = System.currentTimeMillis()/1000;

void setup() {
  if(pdf) {
    size(1000,1000,PDF,"renders/vector-" + time + ".pdf");
  }
  else {
    size(1000,1000);
  }
  noiseDetail(3, 0.5);
  randomSeed(0);
  noiseSeed(10);
  frameRate(15);
}

void draw() {
  background(bg);
  
  for(int i = 0; i < 7; i++) {
    line();
  }
  
  if(pdf) {
    exit();
  }
  else if(png) {
    saveFrame("renders/raster-"+time+".png");
  }
  
  if(pdf || png) {
    copyFile("./ps016.pde", "./renders/code-" + time + ".pde");
  }
  
  if(System.getenv("RENDER_FRAME") != null) {
    saveFrame("frames/frame-" + frame + ".png");
    exit();
  }
  
  frame++;
  
  noLoop();
}

void line() {
  Path p = new Path();
  pushMatrix();
  rotate(PI/16);
  float randline = random(0, 1000);
  float randgirth = random(0, 1000);
  float lastx = 0, lasty = 0;
  float x = 0, y = 0;
  for(float t = 0; t < 300; t += 0.05) {
    float theta = map(noise(t*0.45, randline), 0, 1, -3*PI/2 + PI/4, 3*PI/2 + PI/2);
    float girth = map(noise(t*0.45, randline), 0, 1, 1, 35);
    //line(x, y, lastx, lasty);
    lastx = x;
    lasty = y;
    x += cos(theta);
    y += sin(theta);
    p.add(new Point(x, y, girth));
  }
  new PathDrawable(p).draw();
  popMatrix();
}

void copyFile(String from, String to) {
  try {
    String command = "cp " + sketchPath("") + from + " " + sketchPath("") + to;
    println("running command \"" + command + "\""); 
    Process p = Runtime.getRuntime().exec(command);
    copy(p.getInputStream(), System.out);
    copy(p.getErrorStream(), System.err);
    int exitValue = p.waitFor();
    println("command exited with code " + exitValue);
  }
  catch(Exception ignored) {
    println(ignored.getMessage());
    ignored.printStackTrace();
  }
}

void copy(InputStream in, OutputStream out) throws IOException {
  while (true) {
    int c = in.read();
    if (c == -1) break;
    out.write((char)c);
  }
}
