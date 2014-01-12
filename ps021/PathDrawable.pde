class PathDrawable {
  
  Path path;
  
  PathDrawable(Path p) {
    this.path = p;
  }
  
  void draw() {
    for(Point p : path.getPoints()) {
      pushMatrix();
      translate(p.x, p.y, p.z);
      sphere(p.girth);
      popMatrix();
    }
  }
}
