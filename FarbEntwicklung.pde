int Modea = 1;
int Modeb = 1;

void setup() {
  size(1000, 800);
  colorMode(HSB, 360, 100, 100, 100);  // HSB für schöne Verläufe
  noiseSeed(millis());
  noiseDetail(6, 0.5);
  erzeugeFarbfeld();
}

void draw() {
  // erzeugeFarbfeld();   // auskommentieren für langsame Animation
}

void erzeugeFarbfeld() {
  println(Modea + " t " + Modeb );
  loadPixels();
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      
      // Normalisierte Positionen (0 bis 1)
      float nx = x / (float)width;     // 0.0 links → 1.0 rechts
      float ny = y / (float)height;    // 0.0 oben  → 1.0 unten
      
      // Umkehren, damit die Entwicklung von RECHTS nach LINKS und UNTEN nach OBEN läuft
      float rechtsNachLinks = 1.0 - nx;   // 1.0 rechts → 0.0 links
      float untenNachOben   = 1.0 - ny;   // 1.0 unten → 0.0 oben
      
      
      
      // Farbverlauf steuern
      float hue = 0;
  
      switch(Modea){
        case 1:
          hue = map(rechtsNachLinks, 0, 1, 200, 360)    // z.B. von Magenta rechts → Blau/Cyan links
                  + 60 * sin(frameCount*0.01 + rechtsNachLinks*5);  // leichte Wellen
          break;
        case 2:
          hue = map(rechtsNachLinks, 0, 1, 100, 320);
        case 3:
          hue = map(rechtsNachLinks, 0, 1, 280, 180);
      }
      
      float sat = 0;
      float bri = 0;
      switch(Modeb){
        case 1:
            sat = map(untenNachOben, 0, 1, 30, 95);        // unten satt → oben pastellig
            bri = 95 
                  + 10 * noise(x*0.008, y*0.008, frameCount*0.003); // weiche Wolkenstruktur    
          break;
       case 2: 
           sat = map(untenNachOben, 0, 1, 100, 60);
           bri = 90 + 10 * sin(rechtsNachLinks * PI);
           break;
      case 3:
          sat = map(untenNachOben, 0, 1, 20, 80);
          bri = 95 
                  + 10 * noise(x*0.008, y*0.008, frameCount*0.003); // weiche Wolkenstruktur
      }
      
      
      
      float alpha = 100;
      
      color c = color(hue % 360, sat, bri, alpha);
      pixels[x + y * width] = c;
    }
  }
  updatePixels();
  
  // Optional: dezenter Titel
  fill(0, 80);
  noStroke();
  textAlign(RIGHT, BOTTOM);
  textSize(14);
  text("rechts → links · unten → oben", width-20, height-15);
}

// Mausklick = neue Variation
void mousePressed(){
  noiseSeed((long)random(100000));
  erzeugeFarbfeld();
}

// Taste 's' = speichern
void keyPressed() {
  if (key == 's') {
    saveFrame("farbentwicklung-rechts-links-unten-oben" + Modea + Modeb +"-####.png");
  }
  if (key == '1') {
    Modea = 1;
  }
  if (key == '2') {
    Modea = 2;
  }
  if (key == '3') {
    Modea = 3;
  }
  if (key == 'a') {
    Modeb = 1;
  }
  if (key == 'b') {
    Modeb = 2;
  }
  if (key == 'c') {
    Modeb = 3;
  }
}
