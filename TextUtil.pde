String text;
PFont font;

void initText() {
  font = loadFont("VT323.vlw");
  textFont(font, 50);
  textAlign(CENTER);
  textSize(width/10);
}

void drawText(int x, int y) {
  text(text, x, y);
}