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
    return x + 2*girth > 0 && x - 2*girth < width &&
           y + 2*girth > 0 && y - 2*girth < height;
  }
  
  void draw() {
    stroke(10, 19, 86, 40);
    strokeWeight(0.5f);
    noFill();
    ellipse(x, y, girth, girth);
  }
}
