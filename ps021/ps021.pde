import joons.JoonsRenderer;
import java.util.*;
import java.lang.reflect.*;

boolean png = true;

//Camera Setting.
float eyeX = 1;
float eyeY = 10;
float eyeZ = 190;
float centerX = 0;
float centerY = 10;
float centerZ = 0;

float upX = 0;
float upY = 0;
float upZ = -1;
float fov = PI/3; 
float aspect = 16/9f;  
float zNear = 1;
float zFar = 10000;

int bg = color(0);
color floorcolor = color(252, 120, 55);
color noodlecolor = color(100, 100, 100);

int frame = 0;
int steps = 60;
boolean renderingStarted = false;
long time = System.currentTimeMillis()/1000;

boolean triggerRender = System.getenv("RENDER_FRAME") != null;
JoonsRenderer jr;
Field jrRendered;

int numPaths = 10;
List<PathDrawable> drawables;

LightSphere light = new LightSphere(0, 0, 0, 10);

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
  jr.setAA(0, 2, 4); //setAA(minAA, maxAA, AASamples), increase AASamples to increase blur fidelity.
  //jr.setCaustics(20);
  //jr.setDOF(50, 2); //setDOF(focusDepth, lensRadius), bigger the lens radius, the blurrier the unfocused objects.
  noiseDetail(3, 0.5);
  randomSeed(0);
  noiseSeed(0);


  frameRate(0.25);
  
  try {
    jrRendered = JoonsRenderer.class.getDeclaredField("rendered");
    jrRendered.setAccessible(true);
  }
  catch(Exception e) {
    println("couldn't make private 'rendered' field in JoonsRenderer public");
  }
}

void draw() {

  drawables = new ArrayList<PathDrawable>(numPaths);
  for(int i = 0; i < numPaths; i++) {
    line();
  }

  if(isRendered()) {
    println("finished rendering frame " + frame + " exiting");
    copyFile("rendered.png", "renders/raster-" + time + ".png");
    copyFile("ps021.pde", "renders/code-" + time + ".pde");
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
  
  //floor
  jr.fill("diffuse", 100, 100, 100);
  beginShape(QUADS);
  vertex(-10000, -10000, 0);
  vertex( 10000, -10000, 0);
  vertex( 10000,  10000, 0);
  vertex(-10000,  10000, 0);
  endShape();
  
  jr.fill("light", 30, 30, 30, 64);
  pushMatrix();
  beginShape(QUADS);
  float lsize = 50f;
  rotateY(-PI/4);
  translate(0, 0, 200);
  vertex(-lsize, -lsize, 0);
  vertex(-lsize,  lsize, 0);
  vertex( lsize,  lsize, 0);
  vertex( lsize, -lsize, 0);
  endShape();
  popMatrix();

  //light.place();
  
  jr.fill("diffuse", 60, 60, 60);
  //jr.fill("diffuse", 74, 140, 84);
  //jr.fill("diffuse", noodlecolor);
  for(PathDrawable d : drawables) {
    d.draw();
  }
  
  jr.endRecord();
  jr.displayRendered(true);

  if(System.getenv("RENDER_FRAME") == null) {
    frame++;
  }
}

void line() {
  Path p = new Path();
  float randline = random(0, 1000);
  float pitchline = random(0, 1000);
  float randgirth = random(0, 1000);
  float x = 0, y = 0, z = 0;
  for(int i = 0; i < 2500; i++) {
    float theta = map(noise(i*0.096, 1000+frame*0.0025, randline), 0, 1, -TWO_PI, TWO_PI);
    float pitch = map(noise(i*0.096, 2000+frame*0.0025, pitchline), 0, 1, -TWO_PI, TWO_PI);
    //float theta = map(noise(i*0.066, 1000+frame*0.0025), 0, 1, -3*PI/2, 3*PI/2 + PI);
    //float pitch = map(noise(i*0.016, 2000+frame*0.0025), 0, 1, -3*PI/2, 3*PI/2 + PI);
    float girth = map(noise(i*0.036, 3000+frame*0.0025), 0, 1, 0.1, 4f);
    x += cos(theta);
    y += sin(theta);
    z += sin(pitch);
    p.add(new Point(x, y, 0, girth));
  }
  drawables.add(new PathDrawable(p));
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
  if (key == ' ') frame = 0;
  if (key == 'w') light.y--;
  if (key == 's') light.y++;
  if (key == 'a') light.x--;
  if (key == 'd') light.x++;
  if (key == '-') light.r--;
  if (key == '=') light.r++;
}


