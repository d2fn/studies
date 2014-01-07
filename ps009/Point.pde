class Point {
  
  float x;
  float y;
  float girth;
  
  Point(float x, float y, float girth) {
    this.x = x;
    this.y = y;
    this.girth = girth;
  }
  
  boolean visible() {
    return x + 4*girth > 0 && x - 4*girth < width &&
           y + 4*girth > 0 && y - 4*girth < height;
  }
  
  void draw() {
    if(visible()) {
      stroke(10, 19, 86, 15);
      strokeWeight(0.5f);
      noFill();
      ellipse(x, y, girth, girth);
    }
  }
}
