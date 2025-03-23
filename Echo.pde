// Neue Variablen für Power-Ups und Scoring
ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();
int score = 0;
boolean isInvincible = false;
int invincibilityTimer = 0;
float echoStrength = 1.0;
int powerUpTimer = 0;
int maxInvincibilityTime = 300;

// Bestehende Variablen
boolean inMenu = true;
int level = 1;
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
PVector player;
ArrayList<PVector> echoes = new ArrayList<PVector>();
PVector velocity;
PVector acceleration;
PVector keyPos;
PVector doorPos;
boolean hasKey = false;
float maxSpeed = 5;
boolean up, down, left, right;
boolean gameOver = false;
boolean levelComplete = false;
int echoCooldown = 0;
int maxEchoCooldown = 20;
float maxEchoRange = 100;
PImage playerSheet;
PImage[] playerFrames;
int animFrameCount = 4;
int currentFrame = 0;
float animationTimer = 0;
float lastFrameTime;
PlayerAnimation playerAnimation;
PImage keySheet;
KeyAnimation keyAnimation;
PImage doorSheet;
DoorAnimation doorAnimation;
MenuSystem menuSystem;
PImage xenomorphSheet;

void setup() {
  size(800, 600);
  menuSystem = new MenuSystem();
  playerSheet = loadImage("player.png");
  keySheet = loadImage("key.png");
  doorSheet = loadImage("Door.png");
  xenomorphSheet = loadImage("xenomorph.png");
  playerAnimation = new PlayerAnimation(playerSheet, 4, 8);
  keyAnimation = new KeyAnimation(keySheet, 10);
  doorAnimation = new DoorAnimation(doorSheet, 6, 10);
  lastFrameTime = millis();
  startLevel(1);
}

void startLevel(int lvl) {
  level = lvl;
  player = new PVector(width / 2, height / 2);
  velocity = new PVector(0, 0);
  acceleration = new PVector(0, 0);
  obstacles.clear();
  powerUps.clear();

  int obstacleCount = 4 + level * 2;
  for (int i = 0; i < obstacleCount; i++) {
    obstacles.add(new Obstacle(random(width), random(height)));
  }

  int powerUpCount = 2 + level;
  for (int i = 0; i < powerUpCount; i++) {
    float x = random(50, width - 50);
    float y = random(50, height - 50);
    while (dist(x, y, width/2, height/2) < 100) {
      x = random(50, width - 50);
      y = random(50, height - 50);
    }
    powerUps.add(new PowerUp(x, y));
  }

  keyPos = new PVector(random(50, width - 50), random(50, height - 50));
  doorPos = new PVector(random(50, width - 50), random(50, height - 50));
  hasKey = false;
  levelComplete = false;
  gameOver = false;
  echoStrength = ECHO_STREAM;
  maxSpeed = 5;
  doorAnimation = new DoorAnimation(doorSheet, 6, 10);
}

void draw() {
  if (inMenu) {
    drawMenu();
    return;
  }

  if (gameOver || levelComplete) {
    background(0);
    fill(gameOver ? color(255, 0, 0) : color(0, 255, 0));
    textSize(32);
    textAlign(CENTER, CENTER);
    if (gameOver) {
      text("Game Over!\nScore: " + score + "\nPress R to Restart", width / 2, height / 2);
    } else {
      text("Level " + level + " Complete!\nScore: " + score + "\nPress R for Next Level", width / 2, height / 2);
    }
    return;
  }

  background(0);
  drawUI();

  for (int i = powerUps.size() - 1; i >= 0; i--) {
    PowerUp p = powerUps.get(i);
    if (p.active) {
      p.display();
      if (dist(player.x, player.y, p.pos.x, p.pos.y) < 20) {
        activatePowerUp(p);
        p.active = false;
        score += 50;
      }
    }
  }

  for (Obstacle o : obstacles) {
    o.update();
    o.display();
  }

  acceleration.set(0, 0);
  if (up) acceleration.y = -0.5;
  if (down) acceleration.y = 0.5;
  if (left) acceleration.x = -0.5;
  if (right) acceleration.x = 0.5;

  velocity.add(acceleration);
  velocity.limit(PLAYER_MAX_SPEED);
  player.add(velocity);

  player.x = constrain(player.x, 10, width - 10);
  player.y = constrain(player.y, 10, height - 10);

  float currentTime = millis();
  float deltaTime = (currentTime - lastFrameTime) * 0.001f;
  lastFrameTime = currentTime;

  playerAnimation.update(deltaTime, velocity);
  playerAnimation.draw(player.x, player.y, velocity, isInvincible);

  boolean collision = false;
  for (Obstacle o : new ArrayList<Obstacle>(obstacles)) {
    if (dist(player.x, player.y, o.pos.x, o.pos.y) < 15 && !isInvincible) {
      gameOver = true;
      return;
    }
  }

  if (!hasKey) {
    keyAnimation.update(deltaTime);
    keyAnimation.draw(keyPos.x, keyPos.y);
  }

  doorAnimation.update(deltaTime);
  doorAnimation.draw(doorPos.x, doorPos.y);

  if (!hasKey && dist(player.x, player.y, keyPos.x, keyPos.y) < 30) {
    hasKey = true;
    score += 100;
  }

  if (hasKey && dist(player.x, player.y, doorPos.x, doorPos.y) < 30) {
    doorAnimation.startOpening();
  }

  if (doorAnimation.open && dist(player.x, player.y, doorPos.x, doorPos.y) < 30) {
    levelComplete = true;
    score += level * 200;
  }

  noFill();
  stroke(100, 100, 255);
  for (int i = echoes.size() - 1; i >= 0; i--) {
    PVector e = echoes.get(i);
    float echoSize = e.z * echoStrength;
    ellipse(e.x, e.y, echoSize, echoSize);
    e.z += 2;
    if (e.z > maxEchoRange) {
      echoes.remove(i);
      continue;
    }
    ArrayList<Obstacle> currentObstacles = new ArrayList<Obstacle>(obstacles);
    for (Obstacle o : currentObstacles) {
      if (dist(e.x, e.y, o.pos.x, o.pos.y) < echoSize / 2) {
        o.visible = true;
        o.visibilityTimer = o.visibilityDuration;
        o.stopped = true;
        o.stopTimer = 300;
      }
    }
  }

  if (echoCooldown > 0) {
    echoCooldown--;
  }

  updatePowerUpTimers();
  velocity.mult(0.95);
}

void drawUI() {
  fill(255);
  textSize(20);
  textAlign(LEFT, TOP);
  text("Level: " + level, 10, 10);
  text("Score: " + score, 10, 35);

  if (isInvincible) {
    fill(255, 215, 0, 128);
    textAlign(CENTER, TOP);
    text("INVINCIBLE!", width/2, 10);
  }
  if (echoStrength > 1.0) {
    fill(0, 255, 255, 128);
    textAlign(CENTER, TOP);
    text("ECHO BOOST!", width/2, 30);
  }
}

void activatePowerUp(PowerUp p) {
  switch(p.type) {
    case 0:
      echoStrength = 2.0;
      powerUpTimer = 300;
      break;
    case 1:
      isInvincible = true;
      invincibilityTimer = maxInvincibilityTime;
      break;
    case 2:
      maxSpeed = 8;
      powerUpTimer = 300;
      break;
  }
}

void updatePowerUpTimers() {
  if (isInvincible) {
    invincibilityTimer--;
    if (invincibilityTimer <= 0) {
      isInvincible = false;
    }
  }

  if (powerUpTimer > 0) {
    powerUpTimer--;
    if (powerUpTimer <= 0) {
      echoStrength = 1.0;
      maxSpeed = 5;
    }
  }
}

void drawMenu() {
  menuSystem.draw();
}

void keyPressed() {
  if (inMenu) {
    if (key == ENTER && !menuSystem.inSettings) {  // Nur wenn nicht in den Einstellungen
      inMenu = false;
      startLevel(1);
    }
    return;  // Keine weiteren Tasten im Menü verarbeiten
  }

  if (gameOver && key == 'r') {
    score = 0;
    level = 1;
    startLevel(1);
    return;
  }

  if (levelComplete && key == 'r') {
    startLevel(level + 1);
    return;
  }

  if (key == 'w') up = true;
  if (key == 's') down = true;
  if (key == 'a') left = true;
  if (key == 'd') right = true;

  if (key == ' ' && echoCooldown == 0) {
    echoes.add(new PVector(player.x, player.y, 10));
    echoCooldown = maxEchoCooldown;
  }
}

void keyReleased() {
  if (key == 'w') up = false;
  if (key == 's') down = false;
  if (key == 'a') left = false;
  if (key == 'd') right = false;
}

void mousePressed() {
  if (inMenu) {
    boolean startGame = menuSystem.handleMousePressed();
    if (startGame) {
      inMenu = false;
      startLevel(1);
    }
  }
}

void mouseDragged() {
  if (inMenu) {
    menuSystem.handleMouseDragged();
  }
}

void mouseReleased() {
  if (inMenu) {
    menuSystem.handleMouseReleased();
  }
}
