//define the Wave class

class Wave extends Particle {
  /*----------------------------------- Properties -------------------------------------*/


  /*----------------------------------- Constructors ----------------------------------------*/


  Wave() {
    super();
    size = 30;
    position = new PVector(random(width), random(400 + size, 650));
    velocity = new PVector(0, 0.5);
    lifespan = 100;
    transparency = 0;
  }

  /*----------------------------------- Methods ----------------------------------------*/

  void display() {
    //the wave fades in and out using tranparency
    if (lifespan > 45) {
      transparency += 4;
    } else {
      transparency -= 4;
    }

    //only show the waves during the day
    if (day) {

      ellipseMode(RADIUS);
      stroke(255, transparency);
      strokeWeight(3);
      noFill();

      arc(position.x - size, position.y - size, size, size, 0, PI / 2);
      arc(position.x + size, position.y - size, size, size, PI / 2, PI);
    }
  }

  //apply the force of the wind to the wave
  void applyWindForce(PVector windForce) {
    velocity.add(windForce);
  }
}