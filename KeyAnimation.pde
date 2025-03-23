class KeyAnimation {
  PImage[] frames;
  float frameTime;
  float accumulator;
  int currentFrame;
  
  KeyAnimation(PImage spriteSheet, float fps) {
    frames = new PImage[8];  // 8 Frames total
    frameTime = 1.0 / fps;
    accumulator = 0;
    currentFrame = 0;
    
    int frameWidth = 32;   // 96/3 = 32 Pixel pro Frame
    int frameHeight = 32;  // 96/3 = 32 Pixel pro Frame
    
    // Erste Reihe (3 Frames)
    for (int i = 0; i < 3; i++) {
      frames[i] = createImage(frameWidth, frameHeight, ARGB);
      frames[i].copy(spriteSheet,
                    i * frameWidth, 0,           // Quelle x, y
                    frameWidth, frameHeight,      // Quelle Breite, Höhe
                    0, 0,                         // Ziel x, y
                    frameWidth, frameHeight);     // Ziel Breite, Höhe
    }
    
    // Zweite Reihe (3 Frames)
    for (int i = 0; i < 3; i++) {
      frames[i + 3] = createImage(frameWidth, frameHeight, ARGB);
      frames[i + 3].copy(spriteSheet,
                        i * frameWidth, frameHeight,    // Quelle x, y
                        frameWidth, frameHeight,        // Quelle Breite, Höhe
                        0, 0,                          // Ziel x, y
                        frameWidth, frameHeight);      // Ziel Breite, Höhe
    }
    
    // Dritte Reihe (2 Frames)
    for (int i = 0; i < 2; i++) {
      frames[i + 6] = createImage(frameWidth, frameHeight, ARGB);
      frames[i + 6].copy(spriteSheet,
                        i * frameWidth, frameHeight * 2,  // Quelle x, y
                        frameWidth, frameHeight,          // Quelle Breite, Höhe
                        0, 0,                            // Ziel x, y
                        frameWidth, frameHeight);        // Ziel Breite, Höhe
    }
    
    // Größe für das Spiel anpassen
for (int i = 0; i < frames.length; i++) {
  frames[i].resize(60, 60); 
}
  }
  
  void update(float dt) {
    accumulator += dt;
    if (accumulator >= frameTime) {
      currentFrame = (currentFrame + 1) % frames.length;
      accumulator -= frameTime;
    }
  }
  
  void draw(float x, float y) {
    pushMatrix();
    imageMode(CENTER);
    translate(x, y);
    
    // Leichte Schwebeanimation
    float hover = sin(frameCount * 0.05) * 3;
    translate(0, hover);
    
    // Aktuelle Frame zeichnen
    image(frames[currentFrame], 0, 0);
    popMatrix();
  }
}
