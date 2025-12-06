void setup() {
  size(1000, 1000);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  mondrianBezierKandinsky();
}

void draw() {
  // leer – alles in setup()
}

// Mausklick = neue Komposition
void mousePressed() {
  mondrianBezierKandinsky();
}

void keyPressed() {
  if (key == 's') saveFrame("mondrian-bezier-kandinsky-####.png");
}

void mondrianBezierKandinsky() {
  background(8, 15, 98);  // fast weißes, leicht warmes Papier
  
  // Zufällige Teilungspunkte wie bei Mondrian
  ArrayList<Float> vx = new ArrayList<Float>();
  ArrayList<Float> hy = new ArrayList<Float>();
  
  vx.add(0f);  vx.add((float)width);
  hy.add(0f);  hy.add((float)height);
  
  // 5–10 zufällige vertikale "Linien"-Positionen
  int vLines = (int)random(5, 11);
  for (int i = 0; i < vLines; i++) {
    float x = random(80, width-80);
    if (!zuNah(vx, x, 100)) vx.add(x);
  }
  
  // 4–9 zufällige horizontale "Linien"-Positionen
  int hLines = (int)random(4, 10);
  for (int i = 0; i < hLines; i++) {
    float y = random(80, height-80);
    if (!zuNah(hy, y, 100)) hy.add(y);
  }
  
  vx.sort(null);
  hy.sort(null);
  
  // Jetzt das Gitter aus Bezier-Kurven zeichnen (statt gerader Linien)
  stroke(0);
  strokeWeight(12 + random(-4,4));  // variable Dicke für Lebendigkeit
  noFill();
  
  // Vertikale Bezier-Kurven (wellige "Säulen")
  for (float x : vx) {
    if (x == 0 || x == width) continue;  // Rand überspringen für offeneres Gefühl
    zeichneVertikaleBezier(x);
  }
  
  // Horizontale Bezier-Kurven (wellige "Balken")
  for (float y : hy) {
    if (y == 0 || y == height) continue;
    zeichneHorizontaleBezier(y);
  }
  
  // Kandinsky-Style: die "Rechtecke" füllen (basierend auf den ungefähren Grenzen)
  noStroke();
  for (int i = 0; i < vx.size()-1; i++) {
    for (int j = 0; j < hy.size()-1; j++) {
      
      float x1 = vx.get(i);
      float y1 = hy.get(j);
      float x2 = vx.get(i+1);
      float y2 = hy.get(j+1);
      
      float cw = x2 - x1;
      float ch = y2 - y1;
      
      // 75 % Chance auf Füllung
      if (random(1) < 0.75) {
        
        // Lebendige Farbe
        float hue = random(360);
        float sat = random(100) < 35 ? random(65,100) : random(25,65);
        float bri = random(75,100);
        
        // Leichter Verlauf mit Noise und kleinen Formen
        for (int px = (int)x1+15; px < x2-15; px += 10) {
          for (int py = (int)y1+15; py < y2-15; py += 10) {
            float n = noise(px*0.005, py*0.005, frameCount*0.015);
            fill( (hue + 50*n) % 360, sat*0.85, bri*0.9, 85 );
            
            // Organische Elemente: Kreise oder gedrehte Rechtecke
            pushMatrix();
            translate(px + random(-12,12), py + random(-12,12));
            rotate(random(-PI/4, PI/4));
            if (random(1) < 0.45) {
              rectMode(CENTER);
              rect(0, 0, random(25, cw*0.3), random(25, ch*0.3));
            } else {
              ellipse(0, 0, random(20, max(cw,ch)*0.35), random(20, max(cw,ch)*0.35));
            }
            popMatrix();
          }
        }
      }
    }
  }
  
  // Bezier-Gitter nochmal oben drüber zeichnen für klare Konturen
  stroke(0);
  strokeWeight(12);
  for (float x : vx) {
    if (x == 0 || x == width) continue;
    zeichneVertikaleBezier(x);
  }
  for (float y : hy) {
    if (y == 0 || y == height) continue;
    zeichneHorizontaleBezier(y);
  }
}

// Funktion für vertikale Bezier-Kurve (wellig von oben nach unten)
void zeichneVertikaleBezier(float xBase) {
  beginShape();
  vertex(xBase + random(-10,10), 0);  // Startpunkt oben
  
  int segmente = (int)random(3,6);  // 3–5 Bezier-Segmente für Welligkeit
  float segHeight = height / segmente;
  
  for (int s = 0; s < segmente; s++) {
    float y = (s+1) * segHeight;
    
    // Kontrollpunkte für Kurve (zufällige Abweichung)
    float cp1x = xBase + random(-60,60);
    float cp1y = y - segHeight * random(0.4,0.6);
    float cp2x = xBase + random(-60,60);
    float cp2y = y - segHeight * random(0.2,0.4);
    float endX = xBase + random(-20,20);
    float endY = y;
    
    bezierVertex(cp1x, cp1y, cp2x, cp2y, endX, endY);
  }
  
  endShape();
}

// Funktion für horizontale Bezier-Kurve (wellig von links nach rechts)
void zeichneHorizontaleBezier(float yBase) {
  beginShape();
  vertex(0, yBase + random(-10,10));  // Startpunkt links
  
  int segmente = (int)random(3,6);
  float segWidth = width / segmente;
  
  for (int s = 0; s < segmente; s++) {
    float x = (s+1) * segWidth;
    
    float cp1x = x - segWidth * random(0.4,0.6);
    float cp1y = yBase + random(-60,60);
    float cp2x = x - segWidth * random(0.2,0.4);
    float cp2y = yBase + random(-60,60);
    float endX = x;
    float endY = yBase + random(-20,20);
    
    bezierVertex(cp1x, cp1y, cp2x, cp2y, endX, endY);
  }
  
  endShape();
}

boolean zuNah(ArrayList<Float> list, float val, float minDist) {
  for (float f : list) {
    if (abs(f - val) < minDist) return true;
  }
  return false;
}
