import java.util.Random;

static final Random rand = new Random(System.currentTimeMillis());

float LSD = 10f;
float LIDOCAIN = 0.8f;

int w, h;
int bs = 50;
int tickSpeedBase = 30;
int tickSpeed = 30;
boolean[][] grid;
int tickDown;
int tick;
boolean over = false;
boolean forceGravity = false;

// How linear faster the game gets
float diffBase = 1.05;
// How exponentially faster the game gets
float diffExp = 0.8f;
// Hardest level
int minSpeed = 5;

int level = 0;

Kekramino newBlock;

void setup() {
  size(400, 600, P2D);
  frameRate(60);
  
  w = width / bs;
  h = height / bs;
  
  grid = new boolean[w][h];
  tickDown = tickSpeed;
  initTetraminos();
  initColors();
  initText();
  
  // Steroide
  System.out.printf("TetrAmino initialized, %d x %d at blocksize %d\n", w, h, bs);
}

void draw() {
  tick++;
  if(!over)
    redraw();
  else {
    drawOverBackground();
    drawGrid();
    drawOverBlocks();
    drawOverText();
  }
  
  if(tick % 4 == 0 && newBlock != null && forceGravity && gravity())
    drawTetramino();
  
  if(tickDown-- <= 0) {
    act();
    tickDown = tickSpeed;
  }
}

void act() {
  if(!over) {
    if(newBlock == null)
      spawnRandomTetramino();
    else {
      gravity();
      clearRows();
    }
  }
}

void redraw() {
  background(0);
  drawGrid();
  drawBlocks();
  if(newBlock != null) drawTetramino();
}

boolean keyUp, keyLeft, keyRight;

void keyPressed() { 
  switch(keyCode) {
    case DOWN: 
      forceGravity = true;
      break;
    case LEFT:
      keyLeft = true;
      break;
    case RIGHT:
      keyRight = true;
      break;
    case UP:
      keyUp = true;
      break;
  }
}

void keyReleased() {
  if(keyCode == DOWN) {
    forceGravity = false;
    return;
  }
  
  if(newBlock == null)
    return;
  
  switch(keyCode) {
    case LEFT:
      if(keyLeft && newBlock.toLeft())
        drawTetramino();
      keyLeft = false;
      break;
    case RIGHT:
      if(keyRight && newBlock.toRight())
        drawTetramino();
      keyRight = false;
      break;
    case UP:
      if(keyUp && newBlock.doRot())
        drawTetramino();
      keyUp = false;
  }
}

void keyTyped() {
  switch(key) {
    case 'R': case 'r':
      tickSpeed = tickSpeedBase;
      level = 0;
      for(int i = 0; i < w; i++)
        for(int j = 0; j < h; j++)
          grid[i][j] = false;
      over = false;
      return;
  }
}

boolean gravity() {
  if(!newBlock.fall()) {
    newBlock.persist();
    newBlock = null;
    return false;
  }
  return true;
}

void clearRows() {
  for(int j = 0; j < h; j++) {
    if(clearRow(j)) {
      for(int jj = j-1; jj >= 0; jj--)
        for(int i = 0; i < w; i++)
          grid[i][jj+1] = grid[i][jj];
      clearRows();
      return;
    }
  }
}

boolean clearRow(int j) {
  for(int i = 0; i < w; i++)
    if(!grid[i][j])
      return false;
  tickSpeed = minSpeed + (int) (((tickSpeedBase-minSpeed) * pow(diffBase, -diffExp * level++)));
  System.out.printf("Level %d, New Speed: %d\n", level, tickSpeed);
  return true;
}

void drawGrid() {
  strokeWeight(1);
  stroke(0x44);
 
  // X-lines
  for(int j = 0; j < h; j++)
    line(0, j * bs, width, j*bs);
  
  // Y-lines
  for(int i = 0; i < w; i++)
    line(i * bs, 0, i * bs, height);
}

void drawOverBackground() {
  nextColor(LIDOCAIN);
  float xd = sin(0.02f * tick);
  for(int i = 0; i < w; i++)
    for(int j = 0; j < h; j++) {
      wr *= xd;
      wg *= xd;
      wb *= xd;
      fill(wr, wg, wb);
      rect(i*bs+1, j*bs+1, bs-2, bs-2);
    }
}

void drawOverBlocks() {
  float oc = colorIndex;
  noStroke();
  float xd = 128 + 255 * sin(0.02f * tick);
  for(int i = 0; i < w; i++)
    for(int j = 0; j < h; j++)
      if(grid[i][j]) {
        nextColor(LSD);
        wr = min(0xFF, (int) (wr + xd));
        wg = min(0xFF, (int) (wg + xd));
        wb = min(0xFF, (int) (wb + xd));
        fill(wr, wg, wb);
        rect(i*bs+1, j*bs+1, bs-2, bs-2);
      }
  colorIndex = oc;
}

void drawOverText() {
  if(tick % 3 == 0) {
    noStroke();
    float xd = 128 + 255 * sin(0.02f * tick);
    nextColor(LSD);
    wr = min(0xFF, (int) (wr + xd));
    wg = min(0xFF, (int) (wg + xd));
    wb = min(0xFF, (int) (wb + xd));
    fill(wr, wg, wb);
  } else {
    nextColor(LIDOCAIN);
    float xd = sin(0.02f * tick);
    wr *= xd;
    wg *= xd;
    wb *= xd;
    fill(wr, wg, wb);
  }
  text = String.format("Reached level %d", level);
  drawText(width/2, height/2);
}

void drawBlocks() {
  float oc = colorIndex;
  noStroke();
  for(int i = 0; i < w; i++)
    for(int j = 0; j < h; j++)
      if(grid[i][j]) {
        nextColor(LSD);
        fill(wr, wg, wb);
        rect(i*bs+1, j*bs+1, bs-2, bs-2);
      }
  colorIndex = oc;
  nextColor(LIDOCAIN);
}

void drawTetramino() {
  fill(0xFF);
  
  // Pull tw, th, tx, ty, fig to stack
  int tw = newBlock.tw; int th = newBlock.th; int tx = newBlock.tx; int ty = newBlock.ty; boolean[][]fig = newBlock.fig;
  for(int i = 0; i < tw; i++)
    for(int j = 0; j < th; j++)
      if(fig[i][j])
        rect((tx+i)*bs+1, (ty+j)*bs+1, bs-2, bs-2);
}

class Kekramino {
  int tw, th;
  // Main coords
  int tx, ty;
  boolean[][] fig;
  final boolean[][] figA;
  final boolean[][] figB;
  private byte rot;

  private Kekramino(int tw, int th, boolean[][] fig) {
    int dim = max(tw, th);
    this.figA = new boolean[dim][dim];
    this.figB = new boolean[dim][dim];
    this.fig = this.figA;
    for(int i = 0; i < tw; i++)
      for(int j = 0; j < th; j++)
        this.fig[i][j] = fig[i][j];
    this.tw = tw;
    this.th = th;
    this.tx = (w-tw) / 2;
    this.ty = 0;
  }
  
  // 0 = normal, 1 = 90°, 2 = 180°, 3 = 270°
  public byte getRot() {
    return rot;
  }
  
  // Rotate 90°
  public boolean doRot() {
    byte oldRot = rot;
    rot = (byte)((rot+1) % 4);
    int _tw = tw;
    int _th = th;
    tw = _th;
    th = _tw;
    boolean valid = bounds() && crudeFits();
    if(!valid) {
      rot = oldRot;
      tw = _tw;
      th = _th;
    } else {
      boolean[][] oFig = fig;
      if(fig == figA) fig = figB;
      else            fig = figA;
      for(int i = 0; i < tw; i++)
        for(int j = 0; j < th; j++)
          fig[i][j] = oFig[j][tw - i - 1];
    }

    return valid;
  }
  
  public boolean toLeft() {
    tx--;
    boolean valid = bounds() && fits();
    if(!valid) tx++; // If blocked move back
    return valid;
  }
  
  public boolean toRight() {
    tx++;
    boolean valid = bounds() && fits();
    if(!valid) tx--; // If blocked move back
    return valid;
  }
  
  public boolean fall() {
    ty++;
    boolean valid = bounds() && fits();
    if(!valid) ty--; // If blocked move back
    return valid;
  }
  
  public boolean fits() {
    for(int i = 0; i < tw; i++)
      for(int j = 0; j < th; j++)
        if(fig[i][j] && grid[tx+i][ty+j])
          return false;

    return true;
  }
  
  public boolean crudeFits() {
    for(int i = 0; i < tw; i++)
      for(int j = 0; j < th; j++)
        if(grid[tx+i][ty+j])
          return false;

    return true;
  }
  
  // Performs an array bounds check
  public boolean bounds() {
    return 
      tx >= 0 && 
      tx+tw <= w && 
      ty+th <= h;
  }
  
  public void persist() {
    for(int i = 0; i < tw; i++)
      for(int j = 0; j < th; j++) {
        if(fig[i][j] && grid[tx+i][ty+j])
          setGameOver();
        grid[tx+i][ty+j] |= fig[i][j];
      }
    
    this.tx = (w-tw) / 2;
    this.ty = 0;
  }
}

void setGameOver() {
  tickSpeed = 5;
  over = true;
}