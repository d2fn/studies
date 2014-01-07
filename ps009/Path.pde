class Path {
  
  float[] ax;
  float[] ay;
  float range;
  int num;
  int ptr;
  
  Path(int num, float range, float startx, float starty) {
    this.num = num;
    this.range = range;
    ax = new float[num];
    ay = new float[num];
    for(int i = 0; i < num; i++) {
      ax[i] = startx;
      ay[i] = starty;
    }
    ptr = 0;
  }
  
  void step() {
    // Shift all elements 1 place to the left
    for(int i = 1; i < num; i++) {
      ax[i-1] = ax[i];
      ay[i-1] = ay[i];
    }
  
    // Put a new value at the end of the array
    ax[num-1] += random(-range/2, range);
    ay[num-1] += random(-range/2, range);
  
    // Constrain all points to the screen
    ax[num-1] = constrain(ax[num-1], 0, width);
    ay[num-1] = constrain(ay[num-1], 0, height);
    
    println(ptr + " = " + ax[ptr] + ", " + ay[ptr]);
    ptr = (ptr + 1)%num;
  }
  
  void draw() {
    // Draw a line connecting the points
    for(int i=1; i<num; i++) {    
      float val = float(i)/num * 204.0 + 51;
      stroke(val, val, val, 50);
      line(ax[i-1], ay[i-1], ax[i], ay[i]);
    }
    
    for(int i = 0; i < num; i++) {
      float x = ax[i];
      float y = ay[i];
      float wrand = noise(x*girthNoiseScale, y*girthNoiseScale);
      float girth = map(wrand, 0, 1, 4, 25);
      Point p = new Point(x, y, girth);
      p.draw();
    }
  }
}
