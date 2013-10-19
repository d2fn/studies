class CellLayout {
  
  int xcells, ycells, canvasWidth, canvasHeight;
  float cellWidth, cellHeight;
  
  CellLayout(int xcells, int ycells, int canvasWidth, int canvasHeight) {
    this.xcells = xcells;
    this.ycells = ycells;
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    this.cellWidth = (float)canvasWidth / (float)xcells;
    this.cellHeight = (float)canvasHeight / (float)ycells;
  }
  
  Cell makeCell(int gridx, int gridy) {
    return new Cell(gridx * cellWidth, gridy * cellHeight, cellWidth, cellHeight, gridx, gridy);
  }
}
