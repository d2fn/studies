class Path {
  List<Point> points = new ArrayList<Point>(100);
  
  void add(Point p) {
    points.add(p);
  }
  
  List<Point> getPoints() {
    return points;
  }
}
