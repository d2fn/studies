class Rock {

  float r, dr, noiseScale, detail;

  Rock(float r, float dr, float noiseScale, float detail) {
    this.r = r;
    this.dr = dr;
    this.noiseScale = noiseScale;
    this.detail = detail;
  }

  void draw(color hi, color lo) {
    float dphi = PI/detail;
    float dtheta = 2*PI/detail;
    for(float phi = 0; phi <= TWO_PI; phi += dphi) {
      for(float theta = 0; theta <= PI; theta += dtheta) {
        SphericalPoint p1 = new SphericalPoint(r, phi, theta);
        SphericalPoint p2 = new SphericalPoint(r, phi+dphi, theta);
        SphericalPoint p3 = new SphericalPoint(r, phi, theta+dtheta);
        SphericalPoint p4 = new SphericalPoint(r, phi+dphi, theta+dtheta);
        float noise1 = noiseZ(p1.x(), p1.y(), p1.z());
        float noise2 = noiseZ(p2.x(), p2.y(), p2.z());
        float noise3 = noiseZ(p3.x(), p3.y(), p3.z());
        float noise4 = noiseZ(p4.x(), p4.y(), p4.z());
        float h1 = map(noise1, 0, 1, -dr/2, dr/2);
        float h2 = map(noise2, 0, 1, -dr/2, dr/2);
        float h3 = map(noise3, 0, 1, -dr/2, dr/2);
        float h4 = map(noise4, 0, 1, -dr/2, dr/2);
        p1 = p1.extend(h1);
        p2 = p2.extend(h2);
        p3 = p3.extend(h3);
        p4 = p4.extend(h4);
        color c = lerpColor(lo, hi, noise1);
        jr.fill("diffuse", red(c), green(c), blue(c));
        stroke(c);
        fill(c);
        p1.triangles(p2, p3, p4);
      }
    }
  }

  float noiseZ(float x, float y, float z) {
    return noise(noiseScale*(x+10000), noiseScale*(y+10000), noiseScale*(z+10000));
  }
}
