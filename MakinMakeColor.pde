void setup() {
  size(1000, 1000);
  background(15, 10, 25);  // fast schwarzer, leicht bläulicher Fond
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  
  mackFarbe();
}

void draw() {
}

void mackFarbe() {
  int streifen = 280;                    // noch feiner für Farbverläufe
  float abstand = width / (float)streifen;
  
  // Zufällige Farbpalette (kann auch fix sein, wenn du eine Lieblingskombi hast)
  float basisFarbton = random(360);      // Startfarbton
  float farbSpanne   = random(60, 180);  // wie breit das Spektrum wird
  float wellenFreq   = random(0.01, 0.04);
  float wellenAmp    = random(15, 55);
  float globalTilt   = random(-0.12, 0.12);
  
  for (int i = 0; i < streifen; i++) {
    float x = i * abstand;
    
    // Farbe läuft wellenförmig durch den Farbkreis
    float hue = (basisFarbton + i * 0.8 + 80 * sin(i * wellenFreq)) % 360;
    float sat = 70 + 30 * sin(i * 0.03);           // leichte Sättigungsschwankung
    float bri = 85 + 15 * sin(i * wellenFreq * 2); // Helligkeit vibriert
    float alpha = 90;
    
    fill(hue, sat, bri, alpha);
    noStroke();
    
    // Leichte Wellenbewegung + individuelle Neigung
    float offsetY = wellenAmp * sin(i * 0.04 + frameCount * 0.005);
    float tilt = globalTilt + 0.09 * sin(i * 0.06);
    
    pushMatrix();
    translate(x + abstand/2, height/2);
    rotate(tilt);
    rect(-abstand/2 + random(-1,1), -height/2 + offsetY, abstand*0.92, height);
    popMatrix();
  }
}

// Mausklick → neue bunte Komposition
void mousePressed() {
  background(15, 10, 25);
  mackFarbe();
}

// Taste s = speichern
void keyPressed() {
  if (key == 's') {
    saveFrame("mack-farbig-####.png");
    println("gespeichert");
  }
}
