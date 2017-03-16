//define the Particle class

class Particle {
  /*----------------------------------- Properties -------------------------------------*/
  PVector position;
  PVector velocity;
  float size;
  float lifespan;
  float transparency;

  /*----------------------------------- Constructors ----------------------------------------*/


  Particle() {
  }

  /*----------------------------------- Methods ----------------------------------------*/

  //call the methods that need to run every frame
  void run() {
    //apply the windForce to waves and sparks
    applyWindForce(wind.getWindForce());
    //directly pass the velocity of the wind to clouds and flames
    applyWindVelocity(wind.getWindVelocity());
    move();
    display();
  }

  void display() {
  }

  void move() {
    position.add(velocity);
    lifespan--;
  }

  //check if the particle's lifespan is over
  boolean isDead() {
    if (lifespan <= 0) {
      return true;
    } else {
      return false;
    }
  }

  //apply the force of the wind to the particle
  void applyWindForce(PVector windForce) {
  }

  //transfer the velocity of the wind to the particle
  void applyWindVelocity(PVector windVelocity) {
  }
}