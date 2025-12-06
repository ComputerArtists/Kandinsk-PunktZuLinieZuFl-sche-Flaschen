ArrayList<PVector> points;
PVector current;
float angle;
float len = 8;        // Länge der Segmente
float noiseScale = 0.008;
float noiseStrength = 1.8;

void setup() {
  size(1000, 1000);
  background(20);
  colorMode(HSB, 360, 100, 100, 100);
  smooth(8);
  
  points = new ArrayList<PVector>();
  
  // Startpunkt in der Mitte
  current = new PVector(width/2, height/2);
  points.add(current.copy());
  
  angle = random(TWO_PI);
  
  strokeWeight(2.5);
}

void draw() {
  // Je Frame mehrere Segmente wachsen lassen → fließender
  for (int i = 0; i < 8; i++) {
    wachse();
  }
}

void wachse() {
  // Organische Richtungsänderung durch Perlin-Noise
  float noiseX = current.x * noiseScale;
  float noiseY = current.y * noiseScale + frameCount * 0.002;
  float noiseAngle = noise(noiseX, noiseY) * TWO_PI * noiseStrength;
  
  angle += noiseAngle - PI;  // -PI damit es sich schön einrollt und verzweigt
  
  // Neuer Punkt
  PVector next = PVector.fromAngle(angle);
  next.mult(len + random(-2, 3));   // leichte Längen-Variation
  next.add(current);
  
  // Farbe wird langsam wärmer oder kühler je nach Tiefe
  float hue = (frameCount * 0.2 + points.size() * 0.1) % 360;
  stroke(hue, 70, 90, 80);
  
  line(current.x, current.y, next.x, next.y);
  
  current = next;
  points.add(current.copy());
  
  // Optional: leichter "Schatten" durch halbtransparente dickere Linie
  stroke(0, 30);
  strokeWeight(5);
  line(current.x-1, current.y-1, current.x+1, current.y+1);
  
  // Zurücksetzen der Stroke für die Hauptlinie
  strokeWeight(2.5);
  stroke(hue, 70, 90, 90);
  
  // Wenn es den Rand erreicht → neuer Startpunkt oder Reset
  if (current.x < 50 || current.x > width-50 || 
      current.y < 50 || current.y > height-50) {
    neueWurzel();
  }
}

void neueWurzel() {
  background(20);
  points.clear();
  current = new PVector(random(200, width-200), random(200, height-200));
  points.add(current.copy());
  angle = random(TWO_PI);
  noiseSeed((long)random(100000));
}

void mousePressed() {
  neueWurzel();
}

void keyPressed() {
  if (key == 's') saveFrame("organische-wurzel-####.png");
}
