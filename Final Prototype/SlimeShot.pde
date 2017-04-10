//class for the slime's slimeshot projectile

class SlimeShot extends Projectile {
  /*----------------------------------- Properties -------------------------------------*/

    PImage slimeShotImage = loadImage("SlimeShot.png");

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  SlimeShot(float x, float y, boolean faceRight) {
    super(x, y, faceRight);

    projectileHeight = 40;
    projectileWidth = 40;
    
    //this projectile hits enemies, so hitsUnicorn is false
    hitsUnicorn = true;

    if (goRight) {
      velocity = new PVector(30, -30);
    } else {
      velocity = new PVector(-30, -30);
    }
  }

  //update the slimeshot
  void update() {
    velocity.add(system.game.getGravity());
    
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

  void display() {
    image(slimeShotImage, position.x - 5, position.y - 5);
  }
}