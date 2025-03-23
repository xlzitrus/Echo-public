class PlayerAnimation {
  PImage[] frames;
  float frameTime;
  float accumulator;
  int currentFrame;
  float rotationAngle;
  float targetRotation;
  float rotationSpeed = 0.1;
  
  PlayerAnimation(PImage spriteSheet, int numFrames, float fps) {
    frames = new PImage[numFrames];
    frameTime = 1.0 / fps;
    accumulator = 0;
    currentFrame = 0;
    
    int frameWidth = spriteSheet.width / numFrames;  // 100/4 = 25
    int frameHeight = spriteSheet.height;            // 30
    
    for (int i = 0; i < numFrames; i++) {
      frames[i] = createImage(frameWidth, frameHeight, ARGB);
      frames[i].copy(spriteSheet,
                    i * frameWidth, 0,  // Quelle x, y (horizontal aufgeteilt)
                    frameWidth, frameHeight,
                    0, 0,
                    frameWidth, frameHeight);
      frames[i].resize(40, 40);  // Quadratische Größe für besseres Gameplay
    }
  }
  
  void update(float dt, PVector velocity) {
    accumulator += dt;
    if (accumulator >= frameTime) {
      currentFrame = (currentFrame + 1) % frames.length;
      accumulator -= frameTime;
    }
    
    if (velocity.mag() > 0.1) {
      targetRotation = velocity.heading() + PI/2;
    }
    
    float angleDiff = targetRotation - rotationAngle;
    while (angleDiff > PI) angleDiff -= TWO_PI;
    while (angleDiff < -PI) angleDiff += TWO_PI;
    rotationAngle += angleDiff * rotationSpeed;
  }
  
  void draw(float x, float y, PVector velocity, boolean isInvincible) {
    pushMatrix();
    translate(x, y);
    
    float tilt = map(velocity.x, -maxSpeed, maxSpeed, -PI/8, PI/8);
    
    rotate(rotationAngle);
    rotate(tilt);
    
    if (isInvincible) {
      tint(255, 255, 255, 128 + sin(frameCount * 0.2) * 127);
    }
    
    imageMode(CENTER);
    image(frames[currentFrame], 0, 0);
    
    if (isInvincible) {
      noTint();
    }
    
    popMatrix();
  }
}
