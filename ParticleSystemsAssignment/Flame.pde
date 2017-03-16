//define the Flame class

class Flame extends Particle {
  /*----------------------------------- Properties -------------------------------------*/
  //the color fo the flame
  color flameColor;
  //the baseline angle of the flame
  float baselineAngle;
  //the angle of the flame after considering wind
  float windAngle;

  /*----------------------------------- Constructors ----------------------------------------*/


  Flame() {
    super();
    position = new PVector(800, 875);
    velocity = new PVector(0, 0);
    lifespan = 40;
    size = 50;
    transparency = 150;

    //randomly set the color to one of four colors
    int colorRandom = int(random(4));
    if (colorRandom == 0) {
      flameColor = color(232, 61, 19, transparency);
    } else if (colorRandom == 1) {
      flameColor = color(245, 127, 30, transparency);
    } else if (colorRandom == 2) {
      flameColor = color(245, 195, 80, transparency);
    } else {
      flameColor = color(237, 245, 30, transparency);
    }

    baselineAngle = random(1.35 * PI, 1.65 * PI);
  }

  /*----------------------------------- Methods ----------------------------------------*/

  void display() {
    if (!day) {
      pushMatrix();
      translate(position.x, position.y);
      noStroke();
      fill(flameColor);
      triangle(-50, 0, 50, 0, size * cos(windAngle), size * sin(windAngle));
      popMatrix();

      size += 5;
    }
  }

  //method to have the wind velocity affect the angle of the flame
  void applyWindVelocity(PVector windVelocity) {
    //get the x magnitude of the velocity
    float windMag = windVelocity.x;
    //map the magnitude to a change in angle
    windMag = map(windMag, -1, 1, -0.2 * PI, 0.2 * PI);
    //increment the flame's angle by the change due to wind
    windAngle = windMag + baselineAngle;
  }
}