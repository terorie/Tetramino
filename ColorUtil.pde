// Could have used HSB but WHY EASY WHEN YOU CAN GO TETRAMINO
int precision = 1000;
float colorSpread = 1000;
float colorIndex = 0;
int[] rWave;
int[] gWave;
int[] bWave;

// Current color
int wr, wg, wb;

// r = sin(x + phase_shift(0%))
// g = sin(x + phase_shift(33%))
// b = sin(x + phase_shift(66%))
void initColors() {
  rWave = new int[precision];
  gWave = new int[precision];
  bWave = new int[precision];
  
  float pi_2_3 = (2f/3f)*PI;
  float pi_4_3 = (4f/3f)*PI;
  
  for(int i = 0; i < precision; i++) {
    rWave[i] = (int) (255 * sin((float) (2*i*PI) / precision));
    gWave[i] = (int) (255 * sin(pi_2_3 + (float) (2*i*PI) / precision));
    bWave[i] = (int) (255 * sin(pi_4_3 + (float) (2*i*PI) / precision));
  }
}

int getIndex(float colorState) {
  return (int) (colorState * (precision / colorSpread));
}

void nextColor(float progress) {
  wr = rWave[getIndex(colorIndex)];
  wg = gWave[getIndex(colorIndex)];
  wb = bWave[getIndex(colorIndex)];
  colorIndex = (colorIndex+progress) % colorSpread;
}