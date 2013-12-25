import processing.pdf.PGraphicsPDF;

float[] xbuckets = new float[300];
float[] ybuckets = new float[300];

float zoom = 3f;
float inc = 0.99f;

int count = 90000;

Boolean[] primeLookup = new Boolean[count];

void setup() {
  size(1000,800);//, PDF, "out.pdf");

/**
}

void draw() {
**/  
  
  background(0);
  fill(200);
  noStroke();
  
  for(int i = 0; i < xbuckets.length; i++) {
    xbuckets[i] = 0.0f;
  }
  float barwidth  = ceil((float)width/(float)xbuckets.length);
  float barheight = ceil((float)height/(float)ybuckets.length);
  
  for(int i = 0; i < count; i++) {
    float r = zoom * sqrt(i);
    float t = -TWO_PI * sqrt(i);
    float x = r * cos(t);
    float y = r * sin(t);
    if(isPrime(i)) {
      fill(220);//*exp(-r/700));
      int xpos = floor((width/2f + x)/barwidth);
      if(xpos >= 0 && xpos < xbuckets.length) {
        xbuckets[xpos] += 0.6;
      }
      int ypos = floor((height/2f + y)/barheight);
      if(ypos >= 0 && ypos < ybuckets.length) {
        ybuckets[ypos] += 0.6;
      }
    }
    else {
      fill(40);
    }
    rect(width/2f + x, height/2 + y, 2, 2);
  }
  
  zoom *= inc;
  
  println(zoom);
  
  /**
  float x = 0;
  fill(255, 255, 255, 100);
  for(int i = 0; i < xbuckets.length; i++) {
    rect(x, height-xbuckets[i], barwidth, xbuckets[i]);
    x += barwidth;
  }
  
  float y = 0;
  fill(255, 255, 255, 100);
  for(int i = 0; i < ybuckets.length; i++) {
    rect(0, y, ybuckets[i], barheight);
    y += barheight;
  }
  **/
}

boolean isPrime(int n) {
  if(primeLookup[n] != null) return primeLookup[n];
  if(n <= 2 || n%2 == 0) return false; 
  for(int i = 3; i < sqrt(n); i += 2) {
    if(n%i == 0) {
      primeLookup[n] = false;
      return false;
    }
  }
  primeLookup[n] = true;
  return true;
}

