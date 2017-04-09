

class Projectile {
  /*----------------------------------- Properties -------------------------------------*/

  //the position, velocity, and acceleration of the unicorn
  PVector position;
  PVector velocity;



  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Projectile(float x, float y) {
    position = new PVector(x, y);
  }

  //update the projectile
  void update() {
  }

  //apply a force to the projectile
  void applyForce(PVector force) {
    velocity.add(force);
  }
}