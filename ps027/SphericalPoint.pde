class SphericalPoint {
  
  float r, phi, theta;

  SphericalPoint(float r, float phi, float theta) {
    this.r = r;
    this.phi = phi;
    this.theta = theta;
  }

  SphericalPoint latlng(float r, float lat, float lng) {
    this.r = r;
    this.phi = radians(lng);
    this.theta = map(radians(lat), -PI/2, PI/2, 0, PI);
    return this;
  }

  float x() { return r * sin(theta) * cos(phi); }
  float y() { return r * sin(theta) * sin(phi); }
  float z() { return r * cos(theta); }

  void projectVertex() {
    vertex(x(), y(), z());
  }

  SphericalPoint extend(float dr) {
    return new SphericalPoint(r + dr, phi, theta);
  }

  void lineTo(SphericalPoint p) {
    line(x(), y(), z(), p.x(), p.y(), p.z());
  }

  void triangles(SphericalPoint a, SphericalPoint b, SphericalPoint c) {
    beginShape(TRIANGLES);
    projectVertex();
    a.projectVertex();
    b.projectVertex();
    c.projectVertex();
    b.projectVertex();
    a.projectVertex();
    endShape();
  }
}

