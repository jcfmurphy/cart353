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
  }

  //method to detect when the enemy hits the unicorn
  void hitUnicorn(Unicorn u) {
    if (!u.getInvincible() &&
      position.y + enemyHeight > u.getYPos() &&
      position.y < u.getYPos() + u.getHeight() &&
      position.x + enemyWidth > u.getXPos() &&
      position.x < u.getXPos() + u.getWidth()) {
      u.hit();
    }
  }

  void display() {
  }
}