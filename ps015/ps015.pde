import processing.pdf.PGraphicsPDF;

int bg = color(221, 218, 206);
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

boolean pdf = true;

void setup() {
  if(pdf) {
    size(720,930,PDF,"out" + System.currentTimeMillis()/1000 + ".pdf");
  }
  else {
    size(720,930);
  }
  background(fg);
  translate(0, height+10);
  rotate(-PI/2);
  noiseDetail(3, 0.5);
  randomSeed(0);
  noiseSeed(0);
  
  xf = height;
  yf = width;
  ydelta = yf - y0;
  
  translate(0, ydelta/2);
  
  stroke(fg);
  noFill();
  strokeWeight(0.5);

  scale(6);  
  for(int i = 0; i < 10; i++) {
    lines(40, i);
    scale(0.8);
  }
}
 
void lines(int n, float z) {
  colorMode(HSB, 360, 100, 100);
  color basecolor = color(0, 0, 20, 10+z*5);
  color tipcolor = color(0, 80, 75, 10+z*5); 
  for(int i = 0; i < n; i++) {
    float starty = random(-ydelta/2, ydelta/2);
    float randline = random(0, 1000);
    float endx = random(x0, xf);
    float tipx = endx * 0.1;
    float tiplength = endx - tipx;
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
      float g = map(noise(randline,girthNoiseScale*x), 0, 1, 1, girth);
      g *= (endx-x)/endx;
      ellipse(x, y, g, g);
    }
  }
}

void draw() {
  noLoop();
  if(pdf) {
    exit();
  }
}
