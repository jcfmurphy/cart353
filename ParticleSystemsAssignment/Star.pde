//define the Star class

class Star {
  /*----------------------------------- Properties -------------------------------------*/
  PVector position;
  float size;
  float pulse;

  /*----------------------------------- Constructors ----------------------------------------*/


  Star() {
    position = new PVector(random(width), random(400));
    size = random(4, 8);
    pulse = random(2 * PI);
  }

  /*----------------------------------- Methods ----------------------------------------*/

  void display() {
    if (!day) {
      //set the transparency each frame based on the sin of the pulse counter 
      float transparency = map(sin(pulse), -1, 1, 50, 200);
      fill(225, transparency);
      ellipse(position.x, position.y, size, size);
      
      //increment the pulse to have the stars twinkle
      pulse += .05;
    }
  }
}