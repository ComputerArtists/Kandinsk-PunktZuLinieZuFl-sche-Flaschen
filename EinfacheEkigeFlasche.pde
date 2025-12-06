void setup() {
  size(1000, 800);
  background(30);
  noStroke();
  
  // Anzahl der zu zeichnenden Formen
  int anzahlFormen = 40;
  
  for (int i = 0; i < anzahlFormen; i++) {
    zeichneZufallsPolygon();
  }
  
  // Optional: Rahmen um jede Form (entferne "//" bei stroke() oben, falls gewünscht)
  // stroke(255, 50);
  // strokeWeight(2);
}

void draw() {
  // Falls du Animation möchtest, kannst du hier jede Frame neue Formen malen
  // Aktuell wird nur einmal in setup() gezeichnet
}

// Funktion, die ein zufälliges eckiges Polygon zeichnet
void zeichneZufallsPolygon() {
  pushMatrix();
  
  // Zufällige Position
  float x = random(width);
  float y = random(height);
  translate(x, y);
  
  // Zufällige Rotation
  rotate(random(TWO_PI));
  
  // Zufällige Anzahl Ecken (3 bis 12 für schön eckige Formen)
  int ecken = floor(random(3, 13));
  
  // Grundradius der Form
  float radius = random(30, 150);
  
  // Zufällige Farbe mit etwas Transparenz für Überlappungseffekt
  fill(random(100, 255), random(100, 255), random(100, 255), random(120, 220));
  
  // Optional: leichter schwarzer Rand
  // stroke(0, 100);
  // strokeWeight(random(1, 4));
  
  beginShape();
  for (int i = 0; i < ecken; i++) {
    float winkel = map(i, 0, ecken, 0, TWO_PI);
    
    // Leichte Unregelmäßigkeit für interessantere Formen
    float r = radius + random(-radius*0.3, radius*0.3);
    
    float vx = cos(winkel) * r;
    float vy = sin(winkel) * r;
    
    vertex(vx, vy);
  }
  endShape(CLOSE);
  
  popMatrix();
}

void zeichne(){
  int N = int(random(3, 36));
  
  background(0);
  
  for(int i = 0; i < N; i++)
  {
    zeichneZufallsPolygon();
  }
}

void keyPressed() {
  if (key == 'n') {
    zeichne();
  }
  if (key == 's' || key == 'S') {
    saveFrame("Einfache-Polygon-Grafik-####.png");
    println("Gespeichert!");
  }
}
