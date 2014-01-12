class LightSphere {

  float x, y, z, r;

  LightSphere(float x, float y, float z, float r) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.r = r;
  }

  void place() {
    pushMatrix();
    translate(x, y, z);
    jr.fill("light", 30, 30, 30, 64);
    sphere(r);
    popMatrix();
  }
}
