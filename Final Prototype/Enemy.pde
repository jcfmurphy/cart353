//superclass for enemies

class Enemy {

  /*----------------------------------- Properties -------------------------------------*/

  //the position, velocity, and acceleration of the unicorn
  PVector position;
  PVector velocity;

  int enemyWidth;
  int enemyHeight;

  boolean faceRight;
  boolean onGround;
  boolean inWater;

  //track the damage and death of the enemy
  int hitPoints;
  boolean hit = false;
  boolean dead = false;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Enemy(float x, float y) {
    position = new PVector(x, y);
  }

  //update the enemy
  void update() {
  }

  //apply a force to the enemy
  void applyForce(PVector force) {
    velocity.add(force);
  }

  //method to detect when the enemy hits the unicorn
  void hitUnicorn(Unicorn u) {
    if (!u.getCrouched()) {
      if (position.y + enemyHeight > u.getYPos() &&
        position.y < u.getYPos() + u.getHeight() &&
        position.x + enemyWidth > u.getXPos() &&
        position.x < u.getXPos() + u.getWidth()) {
        u.hit();
      }
    } else {
      //adjust for smaller hitbox when unicorn is crouched
      if (!u.getInvincible() &&
        position.y + enemyHeight > u.getYPos() + u.getCrouchOffset() &&
        position.y < u.getYPos() + u.getHeight() &&
        position.x + enemyWidth > u.getXPos() &&
        position.x < u.getXPos() + u.getWidth()) {
        u.hit();
      }
    }
  }

  void display() {
  }

  void hit(int damage) {
    hitPoints -= damage;
    if (hitPoints <= 0) {
      dead = true;
    }
  }

  float getYPos() {
    return position.y;
  }

  float getXPos() {
    return position.x;
  }

  int getEnemyWidth() {
    return enemyWidth;
  }

  int getEnemyHeight() {
    return enemyHeight;
  }

  boolean getDead() {
    return dead;
  }
}