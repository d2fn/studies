int xcells = 50;
int ycells = 50;

Cell[] cells = new Cell[xcells * ycells];

void setup() {
  size(1000,1000);
  noiseSeed(1);
  noiseDetail(2,0.5);
  CellLayout layout = new CellLayout(xcells, ycells, width, height);
  int n = 0;
  for(int i = 0; i < xcells; i++) {
    for(int j = 0; j < ycells; j++) {
      cells[n++] = layout.makeCell(i, j); 
    }
  } 
}

void draw() {
  background(0);
  for(Cell c : cells) {
    c.draw();
  }
}
