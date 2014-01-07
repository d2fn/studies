import joons.JoonsRenderer;

JoonsRenderer jr;

int xcount = 100;
int ycount = 50;

float maxMountainHeight = 40;


//Camera Setting.

//*
float eyeX = 0;
float eyeY = 120;
float eyeZ = 80;
float centerX = 0;
float centerY = 0;
float centerZ = 10;

//*/
/*

float eyeX = 200;
float eyeY = 50;
float eyeZ = 40;
float centerX = 0;
float centerY = 50;
float centerZ = 0;
/*/

float upX = 0;
float upY = 0;
float upZ = -1;
float fov = PI / 3; 
float aspect = 4/3f;  
float zNear = 1;
float zFar = 10000;

int bgcolor = color(221, 218, 206);

void setup() {
  size(800, 600, P3D);
  jr = new JoonsRenderer(this);
  jr.setSampler("bucket");
  jr.setSizeMultiplier(1);
  jr.setAA(0, 2, 4); //setAA(minAA, maxAA, AASamples), increase AASamples to increase blur fidelity.
  jr.setCaustics(20);
  jr.setDOF(100, 1); //setDOF(focusDepth, lensRadius), bigger the lens radius, the blurrier the unfocused objects.
  noiseDetail(3, 0.5);
  randomSeed(0);
  noiseSeed(0);
}

void draw() {
  jr.beginRecord();
  jr.background(bgcolor);
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ);
  perspective(fov, aspect, zNear, zFar);

  //Floor.
  jr.fill("diffuse", 100, 100, 100);
  int w = 10000;
  beginShape(QUADS);
  vertex(w, -w, 0);
  vertex(-w, -w, 0);
  vertex(-w, w, 0);
  vertex(w, w, 0);
  endShape();
  
  //Lighting.
  jr.fill("light", 30, 30, 30, 64);
  int z = 120;
  beginShape(QUADS);
  
  z = 50;
  vertex(-z, -z, 150);
  vertex(-z, z, 150);
  vertex(z, z, 150);
  vertex(z, -z, 150);
  /*
  vertex(-120, 0, z+100);
  vertex(-120, 0, 0);
  vertex(-120, z, 0);
  vertex(-120, z, z+100);
  */
  
  endShape();
  
  jr.fill("diffuse", 50, 90, 183);
  for(int y = 0; y < ycount; y++) {
    //beginShape(QUADS);
    for(int x = 0; x < xcount; x++) {
      int x1 = 2 * x;
      int y1 = 2 * y;
      int x2 = 2 * (x+1);
      int y2 = 2 * (y+1);
      pushMatrix();
      translate(x1, y1, 0);
      float yratio = (float)y/(float)ycount;
      float xratio = (float)x/(float)xcount;
      //float boxZ = map(noise(0.1*x2, 0.1*y1),  0, 1, 0, xratio*maxMountainHeight);
      float dist = sqrt(x1*x1 + y1*y1);
      float boxZ = xratio * maxMountainHeight * (sin(dist/10));
      box(1, 1, boxZ);
      popMatrix();
//      vertex(x, y, sin(1.3*sqrt(x*x+y*y)));
//      vertex(x, y+1, sin(1.0*sqrt(x*x+(y+1)*(y+1))));
      
    /*
      vertex( x2 - xcount/2, y1 - ycount/2, map(noise(0.1*x2, 0.1*y1),  0, 1, 0, maxMountainHeight) );
      vertex( x2 - xcount/2, y2 - ycount/2, map(noise(0.1*x2, 0.1*y2),  0, 1, 0, maxMountainHeight) );
      vertex( x1 - xcount/2, y2 - ycount/2, map(noise(0.1*x1, 0.1*y2),  0, 1, 0, maxMountainHeight) );
      vertex( x1 - xcount/2, y1 - ycount/2, map(noise(0.1*x1, 0.1*y1),  0, 1, 0, maxMountainHeight) );
      */
    }
    //endShape();
  }
  
  jr.endRecord();
  jr.displayRendered(true);
}

void keyPressed() {
  if (key == 'r' || key == 'R') jr.render(); //Press 'r' key to start rendering.
}
