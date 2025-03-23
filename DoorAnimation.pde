class DoorAnimation {
  PImage[] frames;
  float frameTime;
  float accumulator;
  int currentFrame;
  boolean opening;
  boolean open;
  
  DoorAnimation(PImage spriteSheet, int numFrames, float fps) {
    frames = new PImage[numFrames];
    frameTime = 1.0 / fps;
    accumulator = 0;
    currentFrame = 0;
    opening = false;
    open = false;
    
    // Framebreite korrekt berechnen
    int originalFrameWidth = spriteSheet.width / numFrames;
    int frameWidth = originalFrameWidth + 3; // 3 Pixel extra
    int frameHeight = spriteSheet.height;
    
    for (int i = 0; i < numFrames; i++) {
      frames[i] = createImage(frameWidth, frameHeight, ARGB);
      frames[i].copy(spriteSheet, 
                    i * originalFrameWidth, 0,    // Original-Position im Spritesheet
                    originalFrameWidth + 3, frameHeight,  // Kopiere mit 3 extra Pixeln
                    0, 0,                         
                    frameWidth, frameHeight);
      frames[i].resize(frameWidth * 2, frameHeight * 2);
    }
  }
  
  void startOpening() {
    if (!open) {
      opening = true;
      currentFrame = 0;
    }
  }
  
  void update(float dt) {
    if (opening) {
      accumulator += dt;
      if (accumulator >= frameTime) {
        if (currentFrame < frames.length - 1) {
          currentFrame++;
        } else {
          open = true;
          opening = false;
        }
        accumulator -= frameTime;
      }
    }
  }
  
  void draw(float x, float y) {
    imageMode(CENTER);
    image(frames[currentFrame], x, y);
  }
}
