//define the Spark class

class Spark extends Particle {
  /*----------------------------------- Properties -------------------------------------*/

  color sparkColor;
  //the baseline angle of the spark's velocity
  float baselineAngle;

  /*----------------------------------- Constructors ----------------------------------------*/


  Spark() {
    super();
    position = new PVector(random(750, 850), 875);
    baselineAngle = random(1.35 * PI, 1.65 * PI);
    //use the baseline angle to set the initial velocity of the spark
    velocity = new PVector(3 * cos(baselineAngle), 3 * sin(baselineAngle));
    lifespan = int(random(60, 80));
    size = int(random(4, 8));
    transparency = 100;

    //randomly set the color to one of four colors
    int colorRandom = int(random(4));
    if (colorRandom == 0) {
      sparkColor = color(232, 61, 19, transparency);
    } else if (colorRandom == 1) {
      sparkColor = color(245, 127, 30, transparency);
    } else if (colorRandom == 2) {
      sparkColor = color(245, 195, 80, transparency);
    } else {
      sparkColor = color(237, 245, 30, transparency);
    }
  }

  /*----------------------------------- Methods ----------------------------------------*/

  void display() {
    if (!day) {
      fill(sparkColor);
      noStroke();
      ellipse(position.x, position.y, size, size);
      ellipse(position.x, position.y, size * 0.5, size * 0.5);
    }
  }

  //apply the force of the wind to the wave
  void applyWindForce(PVector windForce) {
    velocity.add(windForce);
    velocity.add(windForce);
    velocity.add(windForce);
  }
}