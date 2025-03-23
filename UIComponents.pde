class Button {
  float x, y, w, h;
  String label;
  
  Button(float x, float y, float w, float h, String label) {
    this.x = x - w/2;
    this.y = y - h/2;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void draw() {
    fill(isClicked(mouseX, mouseY) ? color(200) : color(150));
    rect(x, y, w, h);
    fill(0);
    textSize(20);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }
  
  boolean isClicked(float mx, float my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}

class Slider {
  float x, y, w;
  String label;
  float minVal, maxVal, currentVal;
  boolean isDragging = false;
  
  Slider(float x, float y, float w, String label, float minVal, float maxVal, float defaultVal) {
    this.x = x - w/2;
    this.y = y;
    this.w = w;
    this.label = label;
    this.minVal = minVal;
    this.maxVal = maxVal;
    this.currentVal = defaultVal;
  }
  
  void draw() {
    fill(255);
    textSize(16);
    textAlign(CENTER, BOTTOM);
    text(label + ": " + nf(currentVal, 0, 2), x + w/2, y - 5);
    
    stroke(150);
    line(x, y, x + w, y);
    float sliderX = map(currentVal, minVal, maxVal, x, x + w);
    fill(200);
    ellipse(sliderX, y, 20, 20);
  }
  
  void checkMouse(float mx, float my) {
    if (dist(mx, my, map(currentVal, minVal, maxVal, x, x + w), y) < 10) {
      isDragging = true;
    }
    if (isDragging) {
      float newX = constrain(mx, x, x + w);
      currentVal = map(newX, x, x + w, minVal, maxVal);
    }
  }
  
  float getValue() {
    return currentVal;
  }
}
