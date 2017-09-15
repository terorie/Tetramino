Kekramino FIG_I;
Kekramino FIG_J;
Kekramino FIG_L;
Kekramino FIG_O;
Kekramino FIG_S;
Kekramino FIG_T;
Kekramino FIG_Z;

void spawnRandomTetramino() {
  switch(rand.nextInt(7)) {
    case 0: newBlock = FIG_I; break;
    case 1: newBlock = FIG_J; break;
    case 2: newBlock = FIG_L; break;
    case 3: newBlock = FIG_O; break;
    case 4: newBlock = FIG_S; break;
    case 5: newBlock = FIG_T; break;
    case 6: newBlock = FIG_Z; break;
    
    default: assert false; newBlock = null; break;
  }
}

void initTetraminos() {
  boolean[][] f;
  
  f = new boolean[4][1];
  f[0][0] = f[1][0] = f[2][0] = f[3][0] = true;
  FIG_I = new Kekramino(4, 1, f);
  
  f = new boolean[3][2];
  f[0][0] = f[0][1] = f[1][1] = f[2][1] = true;
  FIG_J = new Kekramino(3, 2, f);
  
  f = new boolean[3][2];
  f[2][0] = f[0][1] = f[1][1] = f[2][1] = true;
  FIG_L = new Kekramino(3, 2, f);
  
  f = new boolean[2][2];
  f[0][0] = f[0][1] = f[1][0] = f[1][1] = true;
  FIG_O = new Kekramino(2, 2, f);
    
  f = new boolean[2][3];
  f[0][1] = f[0][2] = f[1][0] = f[1][1] = true;
  FIG_S = new Kekramino(2, 3, f);
  
  f = new boolean[2][3];
  f[0][1] = f[1][0] = f[1][1] = f[1][2] = true;
  FIG_T = new Kekramino(2, 3, f);
  
  f = new boolean[2][3];
  f[0][0] = f[0][1] = f[1][1] = f[1][2] = true;
  FIG_Z = new Kekramino(2, 3, f);
}