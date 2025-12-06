void setup() {
  size(1000, 1000);
  background(0);
  noStroke();
  smooth(8);
  
  // Heinz-Mack-Style: Relief aus parallelen Streifen mit Helligkeitsverlauf
  mackRelief();
  
  // Optional: leichter Rahmen wie bei echten Mack-Arbeiten
  stroke(40);
  noFill();
  rect(0, 0, width-1, height-1);
}

void draw() {
}

void mackRelief() {
  int streifen = int(random(36,400));              // je höher, desto feiner
  float abstand = width / (float)streifen;
  
  // Zufällige Grundparameter (damit jedes Bild anders wirkt)
  float wellenFreq  = random(0.008, 0.025);
  float wellenAmp   = random(20, 70);
  float phaseShift  = random(TWO_PI);
  float globalTilt  = random(-0.15, 0.15);  // leichte Gesamtschraegung
  
  for (int i = 0; i < streifen; i++) {
    float x = i * abstand;
    
    // Helligkeit = sinusförmige Lichtreflexion über die Breite
    float brightness = 180 + 75 * sin(i * wellenFreq + phaseShift);
    
    // Leichte Wellenbewegung der Streifen (kinetischer Effekt)
    float offsetY = wellenAmp * sin(i * 0.03 + frameCount*0.01);
    
    // Gesamtschraegung + individuelle Neigung pro Streifen
    float tilt = globalTilt + 0.08 * sin(i * 0.05);
    
    fill(brightness);
    
    pushMatrix();
    translate(x + abstand/2, height/2);
    rotate(tilt);
    rect(-abstand/2, -height/2 + offsetY, abstand*0.9, height);
    popMatrix();
  }
}

// Mausklick = neues Mack-Bild
void mousePressed() {
  background(0);
  mackRelief();
}

// Taste 's' = Bild speichern
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("heinz-mack-####.png");
    println("Bild gespeichert");
  }
}
