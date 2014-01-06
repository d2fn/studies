import processing.pdf.PGraphicsPDF;
import java.io.*;

//int bg = color(50, 90, 183);
//int bg = color(208, 239, 234);
//int bg = color(221, 218, 206);
int bg = color(19, 55, 109, 15);
int fg = color(19, 19, 19, 15);

float girth = 30.5;
float x0 = 0;
float xf;
float y0 = 0;
float yf;
float ydelta;
float inc = 0.2;

float girthNoiseScale = 0.055;
float jitterNoiseScale = 0.025;
float timeNoiseScale = 0.01;

boolean pdf = false;
boolean png = true;

int frame = 0;

long time = System.currentTimeMillis()/1000;

void setup() {
  if(pdf) {
    size(720,930,PDF,"renders/vector-" + time + ".pdf");
  }
  else {
    size(720,930);
  }
  noiseDetail(2, 0.5);
  randomSeed(0);
  noiseSeed(10);
  frameRate(15);
}

void draw() {
  background(bg);
  translate(0, height+10);
  rotate(-PI/2);
  
  xf = height;
  yf = width;
  ydelta = yf - y0;
  
  translate(0, ydelta/2);
  
  stroke(fg);
  noFill();
  strokeWeight(0.5);
  
  if(System.getenv("RENDER_FRAME") != null) {
    frame = Integer.parseInt(System.getenv("RENDER_FRAME"));
    println("rendering frame " + frame);
  }

  scale(0.75);  
  for(int i = 0; i < 10; i++) {
    filter(BLUR, 0.9);
    lines(30, i);
    scale(1.15);
  }
  
  if(pdf) {
    exit();
  }
  else if(png) {
    saveFrame("renders/raster-"+time+".png");
  }
  
  if(pdf || png) {
    copyFile("./ps015.pde", "./renders/code-" + time + ".pde");
  }
  
  if(System.getenv("RENDER_FRAME") != null) {
    saveFrame("frames/frame-" + frame + ".png");
    exit();
  }
  
  frame++;
  
  noLoop();
}
 
void lines(int n, float z) {
  colorMode(HSB, 360, 100, 100);
  color basecolor = color(0, 0, 10, 10+z*5);
  color tipcolor = color(115, 80, 55, 10+z*5);
  /*
  color basecolor = color(190, 57, 45, 1+z*5);
  color tipcolor = color(212, 57, 75, 1+z*5);
  */ 
  for(int i = 0; i < n; i++) {
    float starty = random(-ydelta/2, ydelta/2);
    float endx = random(x0, xf);
    float tipx = endx * 0.1;
    float tiplength = endx - tipx;
    float randline = random(0, 1000);
    for(float x = 0; x <= endx; x += inc) {
      float progress = (endx - x) / x;
      float tipprogress = (x-tipx)/tiplength;
      // red veins
      //stroke(360, progress > 0.9 ? 360*(endx*0.9-x)/(endx*0.9) : 0, 100, 50);
      if(x > tipx) {
        stroke(lerpColor(basecolor, tipcolor, tipprogress));
      }
      else {
        stroke(basecolor);       
      }
      float y = starty + map(noise(jitterNoiseScale*x, randline), 0, 1, -10, 10);
      //starty += map(noise(jitterNoiseScale*x, randline), 0, 1, 0, sin(x/300));
      float g = map(noise(randline,girthNoiseScale*x), 0, 1, 1, girth);
      g *= (endx-x)/endx;
      ellipse(x, y, g, g);
    }
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
