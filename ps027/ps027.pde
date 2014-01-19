import joons.JoonsRenderer;
import java.util.*;
import java.lang.reflect.*;

float noiseScale = 0.09;

boolean png = true;

//Camera Setting.
float eyeX = 150;
float eyeY = -60;
float eyeZ = 100;
float centerX = -eyeX;
float centerY = -eyeY;
float centerZ = 0;

float upX = 0;
float upY = 0;
float upZ = -1;
float fov = PI/3; 
float aspect = 16/9f;  
float zNear = 1;
float zFar = 10000;

color bg = color(0);
color blue = color(50, 90, 183);

int frame = 0;
int steps = 60;
boolean renderingStarted = false;
long time = System.currentTimeMillis()/1000;

boolean triggerRender = System.getenv("RENDER_FRAME") != null || System.getenv("SAVE") != null;
JoonsRenderer jr;
Field jrRendered;

int ycount;
int xcount;

void setup() {
  
  int w = 1280;
  int h = 720;
  
  if(System.getenv("RENDER_FRAME") != null) {
    frame = Integer.parseInt(System.getenv("RENDER_FRAME"));
  }
  
  size(w, h, P3D);
  jr = new JoonsRenderer(this);
  jr.setSampler("bucket");
  jr.setSizeMultiplier(1);
  //jr.setAA(0, 2, 4); //setAA(minAA, maxAA, AASamples), increase AASamples to increase blur fidelity.
  jr.setAA(0, 2, 1); //setAA(minAA, maxAA, AASamples), increase AASamples to increase blur fidelity.
  //jr.setCaustics(20);
  //jr.setDOF(55, 0.6); //setDOF(focusDepth, lensRadius), bigger the lens radius, the blurrier the unfocused objects.
  noiseDetail(3, 0.5);
  randomSeed(0);
  noiseSeed(0);

  frameRate(5);

  try {
    jrRendered = JoonsRenderer.class.getDeclaredField("rendered");
    jrRendered.setAccessible(true);
  }
  catch(Exception e) {
    println("couldn't make private 'rendered' field in JoonsRenderer public");
  }
}

void draw() {

  if(isRendered()) {
    println("finished rendering frame " + frame + " exiting");
    copyFile("rendered.png", "renders/raster-" + time + ".png");
    copyFile("ps027.pde", "renders/code-" + time + ".pde");
    noLoop();
  }
  else if(!renderingStarted && triggerRender) {
    println("starting rendering for frame " + frame);
    jr.render();
    renderingStarted = true;
  }

  if(System.getenv("RENDER_FRAME") != null) {
    exit();
  }
  
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  perspective(fov, aspect, zNear, zFar);
  jr.beginRecord();
  jr.background(bg);
  
  //lights
  /*
  jr.fill("light", 30, 30, 30, 64);
  pushMatrix();
  beginShape(QUADS);
  float lsize = 150;
  rotateY(PI/8);
  translate(0, 0, 700);
  vertex(-lsize, -lsize, 0);
  vertex(-lsize,  lsize, 0);
  vertex( lsize,  lsize, 0);
  vertex( lsize, -lsize, 0);
  endShape();
  popMatrix();
  */

  //floor
  jr.fill("diffuse", 30, 30, 30);
  beginShape(QUADS);
  vertex(-10000, -10000, 0);
  vertex( 10000, -10000, 0);
  vertex( 10000,  10000, 0);
  vertex(-10000,  10000, 0);
  endShape();

  color hi = color(200, 200, 200);
  color lo = color(30, 30, 30);

  hi = color(255, 109, 31);
  lo = color(200, 40, 255);

  pushMatrix();
  translate(0, 0, 45);
  Rock r = new Rock(60, 20, 0.015, 500);
  r.draw(hi, lo);
  popMatrix();

  hi = color(200, 200, 200);
  lo = color(30, 30, 30);

  translate(0, 0, 2);

  float b = 15;
  float turns = 2;
  float rsize = 0.5;
  float radius = 0;
  float t;
  pushMatrix();
  for(t = 0.01; t < turns*TWO_PI; ) {
    pushMatrix();
    radius = b * t;
    translate(radius*cos(t), radius*sin(t), 0);
    r = new Rock(rsize, rsize/3, 0.020, map(t, 0.01, turns*TWO_PI, 50, 450));
    r.draw(hi, lo);
    popMatrix();
    rsize *= 1.07;
    translate(0, 0, rsize*0.07);
    float dt = 2 * atan(rsize/radius) * 1.03;
    t += dt;
  }

  translate(radius*cos(t), radius*sin(t), rsize*0.07);
  jr.fill("light", 30, 30, 30, 64);
  sphere(rsize);
  popMatrix();

  
  jr.endRecord();
  jr.displayRendered(true);

  if(System.getenv("RENDER_FRAME") == null) {
    frame++;
  }
}

boolean isRendered() {
  try {
    return (Boolean)jrRendered.get(jr);
  }
  catch(Exception e) {
    throw new RuntimeException("couldn't access private 'rendered' field in JoonsRenderer");
  }
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

void keyPressed() {
  if (key == 'r' || key == 'R') {
    triggerRender = true;
    loop();
  }
}



