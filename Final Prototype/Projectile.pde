

class Projectile {
  /*----------------------------------- Properties -------------------------------------*/

  //the position, velocity, and acceleration of the unicorn
  PVector position;
  PVector velocity;

  int projectileHeight;
  int projectileWidth;

  //angle of rotating projectiles
  float angle;

  //heading right or left
  boolean goRight;

  //track whether the projectile is still active
  boolean active;

  //track whether the projectile hits enemies or hits the unicorn
  boolean hitsUnicorn;
  
  //track the damage dealt by the projectile
  int damage;

  //array of rainbow colors
  color[] colors = {color(255, 0, 0), 
    color(255, 127, 0), 
    color(255, 255, 0), 
    color(0, 255, 0), 
    color(0, 0, 255), 
    color(75, 0, 130), 
    color(143, 0, 255)};

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Projectile(float x, float y, boolean faceRight) {
    position = new PVector(x, y);
    goRight = faceRight;
    active = true;
  }

  //update the projectile
  void update() {
    position.add(velocity);

    //deactivate the projectile if it is offscreen or hits a barrier
    if (hitBarrier(position.x, position.y) ||
      position.x > system.game.getOffset() + system.game.getGameWidth() + 100 ||
      position.x < system.game.getOffset() - 100 ||
      position.y > height + 100 ||
      position.y < -100) {
      active = false;
    }
  }

  boolean hitBarrier(float x, float y) {
    for (GridSquare g : system.game.gridSquares) {
      if (position.y + 0.5 * projectileHeight > g.getYPos() &&
        position.y  + 0.5 * projectileHeight < g.getYPos() + 100 &&
        position.x + 0.5 * projectileWidth > g.getXPos() &&
        position.x + 0.5 * projectileWidth < g.getXPos() + 100 &&
        g.getBarrier()) {
        return true;
      }
    }

    return false;
  }

  void hitEnemy(Enemy enemy) {
    if (position.y + projectileHeight >= enemy.getYPos() &&
      position.y <= enemy.getYPos() + enemy.getEnemyHeight() &&
      position.x + projectileWidth >= enemy.getXPos() &&
      position.x <= enemy.getXPos() + enemy.getEnemyWidth() &&
      !hitsUnicorn) {
      enemy.hit(damage);
      active = false;
    }
  }

  void hitUnicorn(Unicorn unicorn) {
    if (position.y + projectileHeight >= unicorn.getYPos() &&
      position.y <= unicorn.getYPos() + unicorn.getHeight() &&
      position.x + projectileWidth >= unicorn.getXPos() &&
      position.x <= unicorn.getXPos() + unicorn.getWidth() &&
      hitsUnicorn) {
      unicorn.hit();
      active = false;
    }
  }

  //apply a force to the projectile
  void applyForce(PVector force) {
    velocity.add(force);
  }

  void display() {
  }

  boolean getActive() {
    return active;
  }
}