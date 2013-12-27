class PathDrawable {
  
  Path path;
  
  PathDrawable(Path p) {
    this.path = p;
  }
  
  void draw() {
    for(Point p : path.getPoints()) {
      if(p.visible()) {
        p.draw();
      }
    }
  }
}
