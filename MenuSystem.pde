class MenuSystem {
  boolean inSettings = false;
  boolean settingsChanged = false;
  Button playButton;
  Button settingsButton;
  Button backButton;
  Slider echoSlider;
  Slider speedSlider;
  
  MenuSystem() {
    playButton = new Button(width/2, height/2 - 40, 200, 50, "Play");
    settingsButton = new Button(width/2, height/2 + 40, 200, 50, "Settings");
    backButton = new Button(width/2, height - 60, 200, 50, "Back");
    echoSlider = new Slider(width/2, height/2 - 40, 300, "Echo Stream", 0.5, 5.0, ECHO_STREAM);  
    speedSlider = new Slider(width/2, height/2 + 40, 300, "Player Speed", 3.0, 12.0, PLAYER_MAX_SPEED);  
  }
  
  void draw() {
    background(0);
    fill(255);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("Echo Explorer", width/2, height/3);
    
    if (inSettings) {
      drawSettings();
    } else {
      drawMainMenu();
    }
  }
  
  void drawMainMenu() {
    playButton.draw();
    settingsButton.draw();
  }
  
  void drawSettings() {
    textSize(32);
    text("Settings", width/2, height/4);
    
    echoSlider.draw();
    speedSlider.draw();
    backButton.draw();
    
    // Save Button
    fill(0, 255, 0);
    rect(width/2 - 100, height - 120, 200, 40);
    fill(0);
    textSize(20);
    text("Save Settings", width/2, height - 100);
  }
  
  boolean handleMousePressed() {
    if (inSettings) {
      if (backButton.isClicked(mouseX, mouseY)) {
        inSettings = false;
        return false;
      } else if (mouseY > height - 120 && mouseY < height - 80 &&
                 mouseX > width/2 - 100 && mouseX < width/2 + 100) {
        saveSettings();
        applySettings();
        return false;
      }
      echoSlider.checkMouse(mouseX, mouseY);
      return false;
    } else {
      if (playButton.isClicked(mouseX, mouseY)) {
        return true;
      } else if (settingsButton.isClicked(mouseX, mouseY)) {
        inSettings = true;
        return false;
      }
    }
    return false;
  }
  
  void handleMouseDragged() {
    if (inSettings) {
      echoSlider.checkMouse(mouseX, mouseY);
      speedSlider.checkMouse(mouseX, mouseY);
    }
  }
  
  void handleMouseReleased() {
    if (inSettings) {
      echoSlider.isDragging = false;
      speedSlider.isDragging = false;
    }
  }
  
  private void saveSettings() {
    String[] configLines = {
      "final float ECHO_STREAM = " + nf(echoSlider.getValue(), 0, 2) + ";",
      "static final float PLAYER_MAX_SPEED = " + nf(speedSlider.getValue(), 0, 2) + ";"
    };
    saveStrings("data/Config.pde", configLines);
    settingsChanged = true;
  }
  
  void applySettings() {
    echoStrength = echoSlider.getValue();
    maxSpeed = speedSlider.getValue();
    PLAYER_MAX_SPEED = speedSlider.getValue();
    ECHO_STREAM = echoSlider.getValue();
  }
  
  float getEchoStreamValue() {
    return echoSlider.getValue();
  }
  
  float getPlayerSpeedValue() {
    return speedSlider.getValue();
  }
}
