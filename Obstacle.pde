class Obstacle {
  PVector pos;
  PVector velocity;
  float speed = 2;
  boolean visible = false;  // Zurück auf false als Standard
  int visibilityTimer = 0;
  int visibilityDuration = 60;
  boolean stopped = false;
  int stopTimer = 0;
  XenomorphAnimation animation;
  
  Obstacle(float x, float y) {
    pos = new PVector(x, y);
    speed = random(2, 3);
    velocity = PVector.random2D().mult(speed);
    animation = new XenomorphAnimation(xenomorphSheet);
  }
  
  void update() {
    if (!stopped) {
      pos.add(velocity);
      
      // Wandkollision
      if (pos.x < 0 || pos.x > width) {
        velocity.x *= -1;
        pos.x = constrain(pos.x, 0, width);
      }
      if (pos.y < 0 || pos.y > height) {
        velocity.y *= -1;
        pos.y = constrain(pos.y, 0, height);
      }
    } else {
      stopTimer--;
      if (stopTimer <= 0) {
        stopped = false;
        velocity = PVector.random2D().mult(speed);
      }
    }
    
    // Sichtbarkeits-Timer
    if (visible) {
      visibilityTimer--;
      if (visibilityTimer <= 0) {
        visible = false;
      }
    }
    
    // Animation nur updaten wenn sichtbar
    if (visible) {
      animation.update(1.0/frameRate, velocity);
    }
  }
  
  void display() {
    // Nur anzeigen wenn sichtbar
    if (visible) {
      animation.draw(pos.x, pos.y, velocity);
    }
  }
  
  void makeVisible() {
    visible = true;
    visibilityTimer = visibilityDuration;
  }
  
  void stop(int duration) {
    stopped = true;
    stopTimer = duration;
  }
  
  boolean isVisible() {
    return visible;
  }
  
  PVector getPosition() {
    return pos.copy();
  }
}
