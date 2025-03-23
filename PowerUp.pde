class PowerUp {
  PVector pos;
  int type;
  boolean active = true;
  
  PowerUp(float x, float y) {
    pos = new PVector(x, y);
    type = int(random(3));
  }
  
  void display() {
    if (!active) return;
    
    pushStyle();
    switch(type) {
      case 0: 
        fill(0, 255, 255);
        break;
      case 1: 
        fill(255, 215, 0);
        break;
      case 2: 
        fill(0, 255, 0);
        break;
    }
    stroke(255);
    float size = 15 + sin(frameCount * 0.1) * 3;
    ellipse(pos.x, pos.y, size, size);
    popStyle();
  }
}
