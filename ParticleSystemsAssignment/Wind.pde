//define the Wind class

class Wind {
  /*----------------------------------- Properties -------------------------------------*/

  //A vector to store the force of the wind (used for waves and sparks)
  PVector windForce;

  //A vector to store the velocity of the wind (used for clouds and flames)
  PVector windVelocity;

  //A time variable that will be incremented for the Perlin noise function
  float time;

  /*----------------------------------- Constructors -----------------------------------*/


  Wind() {
    windForce = new PVector(0, 0);
    windVelocity = new PVector(0, 0);
    time = 0;
  }

  /*----------------------------------- Methods ----------------------------------------*/

  void update() {
    //use Perlin noise to get a float between 0 and 1
    float windNoise = noise(time);
    //map that value to be between -0.01 and 0.01
    windNoise = map(windNoise, 0, 1, -0.01, 0.01);
    //set the windForce vector to a unit vector in the positive x direction
    windForce = new PVector(1, 0);
    //multiply this vector by the windNoise value
    windForce.mult(windNoise);

    //multiply the windForce by 100 to get windVelocity
    windVelocity = PVector.mult(windForce, 100);

    //increment time
    time += 0.0005;
  }

  PVector getWindForce() {
    return windForce;
  }

  PVector getWindVelocity() {
    return windVelocity;
  }
}