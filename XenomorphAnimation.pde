class XenomorphAnimation {
  PImage spriteSheet;
  PImage[] frames;
  int spriteWidth = 65;  // 260 / 4 für 4 Spalten
  int spriteHeight = 66; // 198 / 3 für 3 Zeilen (angepasst)
  float animationSpeed = 0.2;
  float animationTimer = 0;
  int currentFrame = 0;
  int framesCount = 10; // Gesamtanzahl der Sprites (4+4+2)
  color purpleBackground = color(255, 0, 255); // Lila Farbe (magenta)
  
  XenomorphAnimation(PImage sheet) {
    this.spriteSheet = sheet;
    frames = new PImage[framesCount];
    loadFrames();
  }
  
  void loadFrames() {
    int index = 0;
    
    // Obere Reihe (4 Frames)
    for(int i = 0; i < 4; i++) {
      frames[index] = createTransparentFrame(i * spriteWidth, 0);
      index++;
    }
    
    // Mittlere Reihe (4 Frames)
    for(int i = 0; i < 4; i++) {
      frames[index] = createTransparentFrame(i * spriteWidth, spriteHeight);
      index++;
    }
    
    // Untere Reihe (2 Frames)
    for(int i = 0; i < 2; i++) {
      frames[index] = createTransparentFrame(i * spriteWidth, spriteHeight * 2);
      index++;
    }
  }
  
  PImage createTransparentFrame(int x, int y) {
    PImage frame = createImage(spriteWidth, spriteHeight, ARGB);
    frame.loadPixels();
    
    // Kopiere jeden Pixel und mache lila transparent
    for (int py = 0; py < spriteHeight; py++) {
      for (int px = 0; px < spriteWidth; px++) {
        color c = spriteSheet.get(x + px, y + py);
        // Wenn die Farbe annähernd lila ist (mit etwas Toleranz)
        if (isCloseToPurple(c)) {
          frame.pixels[py * spriteWidth + px] = color(0, 0); // Transparent
        } else {
          frame.pixels[py * spriteWidth + px] = c;
        }
      }
    }
    frame.updatePixels();
    return frame;
  }
  
  boolean isCloseToPurple(color c) {
    float r = red(c);
    float g = green(c);
    float b = blue(c);
    
    // Toleranz für Farbvergleich
    return (r > 200 && g < 50 && b > 200); // Angepasste Werte für lila
  }
  
  void update(float deltaTime, PVector velocity) {
    animationTimer += deltaTime;
    if (animationTimer >= animationSpeed) {
      animationTimer = 0;
      currentFrame = (currentFrame + 1) % framesCount;
    }
  }
  
  void draw(float x, float y, PVector velocity) {
    pushMatrix();
    translate(x, y);
    
    // Spiegeln basierend auf Bewegungsrichtung
    if (velocity.x < 0) {
      scale(-0.7, 0.7); // Skalierung etwas erhöht auf 0.7
    } else {
      scale(0.7, 0.7);  // Skalierung etwas erhöht auf 0.7
    }
    
    imageMode(CENTER);
    image(frames[currentFrame], 0, 0);
    popMatrix();
  }
}
