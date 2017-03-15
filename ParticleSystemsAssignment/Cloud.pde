//define the Cloud class

class Cloud extends Particle {
  /*----------------------------------- Properties -------------------------------------*/


  /*----------------------------------- Constructors ----------------------------------------*/


  Cloud() {
    super();
    size = int(random(20, 40));

    //determine starting x position based on wind direction
    int xPos;
    if (wind.getWindVelocity().x >= 0) {
      xPos = -3 * size;
    } else {
      xPos = width + 3 * size;
    }

    position = new PVector(xPos, random(size, 350));
    velocity = new PVector(0, 0);
    lifespan = 1200;
    transparency = 150;
  }

  Cloud(int xPos) {
    super();
    size = int(random(20, 40));
    position = new PVector(xPos, random(size, 350));
    velocity = new PVector(0, 0);
    lifespan = 1200;
    transparency = 150;
  }

  /*----------------------------------- Methods ----------------------------------------*/

  void display() {

    ellipseMode(RADIUS);
    noStroke();

    //the clouds are light during the day and dark at night
    if (day) {
      fill(255, transparency);
    } else {
      fill(0, transparency);
    }

    ellipse(position.x, position.y, size, size);
    ellipse(position.x - 1.5 * size, position.y - 0.25 * size, size, size);
    ellipse(position.x + 1.5 * size, position.y - 0.25 * size, size, size);
    ellipse(position.x - 0.75 * size, position.y - size, size, size);
    ellipse(position.x + 0.75 * size, position.y - size, size, size);
  }

  //transfer the velocity of the wind to the cloud
  void applyWindVelocity(PVector windVelocity) {
    velocity = windVelocity.copy();
  }

  //override the particle's isDead function
  boolean isDead() {
    if (position.x < -4 * size || position.x > width + 4 * size) {
      return true;
    } else {
      return false;
    }
  }
}