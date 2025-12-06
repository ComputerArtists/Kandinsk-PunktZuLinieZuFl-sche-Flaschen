void setup() {
  size(1000, 800);
  background(20);
  smooth();
  
  int anzahlFormen = 35;
  
  for (int i = 0; i < anzahlFormen; i++) {
    zeichneBezierBlob();
  }
}

void draw() {
  // leer → alles passiert einmal in setup()
}

void zeichne(){
  background(20);
  
  int N = int(random(3,36));
  
  for (int i = 0; i < N; i++) {
    zeichneBezierBlob();
  }
}

void keyPressed() {
  if (key == 'n') {
    zeichne();
  }
  if (key == 's' || key == 'S') {
    saveFrame("muster-kreise-####.png");
    println("Gespeichert!");
  }
}


void zeichneBezierBlob() {
  pushMatrix();
  
  // Zufällige Position
  float cx = random(100, width-100);
  float cy = random(100, height-100);
  translate(cx, cy);
  
  // Zufällige Gesamtgröße
  float basisRadius = random(60, 180);
  
  // Zufällige Anzahl von Bezier-Segmenten (4–10 → immer geschlossene Form)
  int segmente = floor(random(4, 11));
  
  // Zufällige Farbe (pastellartig oder knallig – wie du magst)
  color c = color(
    random(80, 255), 
    random(80, 255), 
    random(80, 255), 
    random(100, 200)  // Transparenz für Überlappungen
  );
  fill(c);
  noStroke();
  // Alternativ nur Umriss:
  // noFill(); stroke(c); strokeWeight(random(1,5));
  
  beginShape();
  
  for (int i = 0; i < segmente; i++) {
    float winkel = map(i, 0, segmente, 0, TWO_PI);
    
    // Haupt-Ankerpunkt auf einem unregelmäßigen Kreis
    float r = basisRadius + random(-basisRadius*0.4, basisRadius*0.5);
    float x = cos(winkel) * r;
    float y = sin(winkel) * r;
    
    if (i == 0) {
      vertex(x, y);              // erster Ankerpunkt
    } else {
      // Kontrollpunkte (ziehen die Kurve)
      float cp1x = cos(winkel - PI*0.65) * r * random(0.7, 1.6);
      float cp1y = sin(winkel - PI*0.65) * r * random(0.7, 1.6);
      float cp2x = cos(winkel - PI*0.35) * r * random(0.7, 1.6);
      float cp2y = sin(winkel - PI*0.35) * r * random(0.7, 1.6);
      
      bezierVertex(cp1x, cp1y, cp2x, cp2y, x, y);
    }
  }
  
  // Form schließen (letzter zum ersten Punkt)
  float firstX = cos(0) * (basisRadius + random(-basisRadius*0.4, basisRadius*0.5));
  float firstY = sin(0) * (basisRadius + random(-basisRadius*0.4, basisRadius*0.5));
  
  // letzte zwei Kontrollpunkte für sauberen Abschluss
  float lastWinkel = TWO_PI - PI/segmente;
  float cp1x = cos(lastWinkel + PI*0.35) * basisRadius * random(0.8, 1.7);
  float cp1y = sin(lastWinkel + PI*0.35) * basisRadius * random(0.8, 1.7);
  float cp2x = cos(PI*0.65) * basisRadius * random(0.8, 1.7);
  float cp2y = sin(PI*0.65) * basisRadius * random(0.8, 1.7);
  
  bezierVertex(cp1x, cp1y, cp2x, cp2y, firstX, firstY);
  
  endShape(CLOSE);
  
  popMatrix();
}
