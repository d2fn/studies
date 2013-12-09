import processing.pdf.PGraphicsPDF;


int frame = 0;
float speed = 0.05;

// amount of noise detail (larger == higher frequency)
float noiseScale = 0.03;
// number of lines
int lines = 250;
// height of line
float lineHeight = 2.0f;
// rate at which amplitude oscillates
float oscillation = 2.5f;
// rate at which lines grow
float growth = 3f;

void setup() {
  size(1000,1000, PDF, "lines-"+lines+"_lineHeight-"+lineHeight+"_oscillation-"+oscillation+"_noiseScale-"+noiseScale+"_growth-"+growth+".pdf");
  noiseDetail(9, 0.2);
  noiseSeed(0);
  background(200);
  stroke(40,40,40,255);
  strokeWeight(0.5);
  for(int i = 0; i < lines; i++) {
    for(int x = 0; x < width; x++) {
      float y0 = f(x-1, i);
      float y1 = f(x  ,i);
      line(x-1,y0,x,y1);
    }
    frame++;
  }
}

float f(float x, int i) {
  float progress = (float)i/lines;
  float factor = oscillation  < 0.01 ? 1f : sin(progress*oscillation*PI);
  return i*lineHeight + growth*factor*i*noise(x*noiseScale);
}
