class Cell {
  
  float noiseScale = 0.05f;
  float radius = 150.0f;
  
  float x, y, w, h;
  int cellx, celly;
  
  int frame = 0;
  float speed = 0.005;
  
  Cell(float x, float y, float w, float h, int cellx, int celly) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.cellx = cellx;
    this.celly = celly;
  }
  
  void draw() {
    noStroke();
    noiseDetail(2,0.5);
    float noize = noise(cellx*noiseScale, celly*noiseScale + frame*speed);
    float clr = noize * 255;
    fill(clr/3, clr/21, clr, 200);
    float dir = -PI/4.0;
    float xshift = noize*radius*cos(dir);
    float yshift = noize*radius*sin(dir);
    rect(x + xshift, y + yshift, w*cos(noize) + 3, h*noize);
    
    frame++;
  }
  
  void print() {
    System.out.println("("+x+","+y+","+w+","+h+")");
  }
}
