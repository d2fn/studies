import processing.pdf.PGraphicsPDF;

float noiseScale = 0.2;
int frame = 0;
float speed = 0.05;
int lines = 135;

void setup() {
  size(1000,1000, PDF, "out.pdf");
  noiseDetail(9, 0.1);
  noiseSeed(1);
  background(200);
  stroke(65);
 for(int i = 0; i < lines; i++) {
   for(int x = 0; x < width; x++) {
     float progress = (float)i/(float)lines;
     stroke(65 + (200-65)*progress);
     float y0 = f(x-1,i);
     float y1 = f(x  ,i);
     line(x-1,y0,x,y1);
   }
   frame++;
 }
}

float f(float x, int i) {
  return i*8 + 2*i*noise(x*noiseScale);
}

