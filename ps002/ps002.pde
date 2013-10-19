import processing.pdf.PGraphicsPDF;

float noiseScale = 0.2;
int frame = 0;
float speed = 0.05;
int lines = 120;

float f(float x, int i) {
  float progress = (float)i/lines;
  float factor = sin(progress*3*PI);
  return i*8 + 2*factor*i*noise(x*noiseScale);
}

void setup() {
  size(1000,1000, PDF, "out.pdf");
  noiseDetail(9, 0.1);
  noiseSeed(1);
  background(200);
  stroke(85,85,85,200);
 for(int i = 0; i < lines; i++) {
   for(int x = 0; x < width; x++) {
     stroke(65);
     float y0 = f(x-1,i);
     float y1 = f(x  ,i);
     line(x-1,y0,x,y1);
   }
   frame++;
 }
}


