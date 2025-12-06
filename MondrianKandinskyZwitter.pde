void setup() {
  size(1000, 1000);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  mondrianKandinsky();
}

void draw() {
  // leer – alles in setup()
}

// Mausklick = neue Komposition
void mousePressed() {
  mondrianKandinsky();
}

void keyPressed() {
  if (key == 's') saveFrame("mondrian-kandinsky-####.png");
}

void mondrianKandinsky() {
  background(8, 15, 98);  // fast weißes, leicht warmes Papier
  
  // Zufällige Teilungspunkte wie bei Mondrian
  ArrayList<Float> vx = new ArrayList<Float>();
  ArrayList<Float> hy = new ArrayList<Float>();
  
  vx.add(0f);  vx.add((float)width);
  hy.add(0f);  hy.add((float)height);
  
  // 6–12 zufällige vertikale Linien
  int vLines = (int)random(6, 13);
  for (int i = 0; i < vLines; i++) {
    float x = random(80, width-80);
    if (!zuNah(vx, x, 90)) vx.add(x);
  }
  
  // 5–11 zufällige horizontale Linien
  int hLines = (int)random(5, 12);
  for (int i = 0; i < hLines; i++) {
    float y = random(80, height-80);
    if (!zuNah(hy, y, 90)) hy.add(y);
  }
  
  vx.sort(null);
  hy.sort(null);
  
  // Dicke schwarze Linien wie Mondrian
  stroke(0);
  strokeWeight(14);
  for (float x : vx) line(x, 0, x, height);
  for (float y : hy) line(0, y, width, y);
  
  // Jetzt kommt der Kandinsky-Zauber: die Rechtecke füllen
  noStroke();
  for (int i = 0; i < vx.size()-1; i++) {
    for (int j = 0; j < hy.size()-1; j++) {
      
      float x1 = vx.get(i);
      float y1 = hy.get(j);
      float x2 = vx.get(i+1);
      float y2 = hy.get(j+1);
      
      float cw = x2 - x1;
      float ch = y2 - y1;
      
      // 70 % Chance auf Füllung (Mondrian lässt oft weiß)
      if (random(1) < 0.70) {
        
        // Kandinsky-Style: lebendige, organische Farbe
        float hue = random(360);
        // manche Felder kräftig, manche pastell
        float sat = random(100) < 30 ? random(70,100) : random(20,70);
        float bri = random(80,100);
        
        // leichter Farbverlauf innerhalb des Rechtecks
        for (int px = (int)x1+10; px < x2-10; px += 8) {
          for (int py = (int)y1+10; py < y2-10; py += 8) {
            float n = noise(px*0.004, py*0.004, frameCount*0.01);
            fill( (hue + 40*n) % 360, sat*0.9, bri*0.95, 90 );
            noStroke();
            
            // kleine organische Kreise oder Rechtecke statt harter Fläche
            if (random(1) < 0.4) {
              pushMatrix();
              translate(px + random(-10,10), py + random(-10,10));
              rotate(random(TWO_PI));
              rectMode(CENTER);
              rect(0, 0, random(20, cw*0.25), random(20, ch*0.25));
              popMatrix();
            } else {
              ellipse(px + random(-8,8), py + random(-8,8), random(15, max(cw,ch)*0.3), random(15, max(cw,ch)*0.3));
            }
          }
        }
      }
    }
  }
  
  // dicke schwarze Linien nochmal oben drüber (für klare Konturen)
  stroke(0);
  strokeWeight(14);
  for (float x : vx) line(x, 0, x, height);
  for (float y : hy) line(0, y, width, y);
}

boolean zuNah(ArrayList<Float> list, float val, float minDist) {
  for (float f : list) {
    if (abs(f - val) < minDist) return true;
  }
  return false;
}
