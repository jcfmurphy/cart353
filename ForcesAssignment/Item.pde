//define the Item class

class Item {

  /*----------------------------------- Properties -------------------------------------*/
  //The item's position, velocity, and acceleration
  PVector position;
  PVector velocity;
  PVector acceleration;

  //The item's mass
  int mass;
  
  //the gravitational constant for orbiting the ball
  float g = 0.1;

  //a boolean recording whether the item has been collected yet
  boolean collected;

  //An int that determines which picture is shown for the item
  int itemNum;

  //store the ball so that the item can refer to the ball's mass and display accordingly
  Ball ball;

  /*----------------------------------- Methods ----------------------------------------*/

  Item(float x, float y, int itemNum, Ball ball) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);

    //The item is not collected until touched by the ball
    collected = false;

    //randomize which picture represents this item
    this.itemNum = itemNum;

    //store the ball
    this.ball = ball;

    //set the mass based on the itemNum
    switch(itemNum) {
    case 0:
      mass = 32;
      break;
    case 1:
      mass = 32;
      break;
    case 2:
      mass = 64;
      break;
    case 3:
      mass = 64;
      break;
    case 4:
      mass = 80;
      break;
    case 5:
      mass = 80;
      break;
    case 6:
      mass = 96;
      break;
    case 7:
      mass = 96;
      break;
    }
  }


  void orbit() {
    //if the item has been collected...
    if (collected) {
      //calculate gravitational force 
      PVector gravity = PVector.sub(ball.position, position);
      float distance = gravity.mag();
      
      //constrain the distance so that the force does not get out of control
      distance = constrain(distance, 5, 25);
      
      //calculate the magnitude of the gravity vector and set it
      float magnitude = (g * mass * ball.mass) / (distance * distance);
      gravity.setMag(magnitude);
      
      //add the force to the item's acceleration
      acceleration.add(gravity);
    }
  }


  void update() {
    velocity.add(acceleration);
    position.add(velocity);

    //reset the acceleration to zero
    acceleration.mult(0);
  }


  void display() {

    imageMode(CENTER);

    switch(itemNum) {
    case 0:
      image(cake, position.x, position.y);
      break;
    case 1:
      image(dollar, position.x, position.y);
      break;
    case 2:
      image(mailbox, position.x, position.y);
      break;
    case 3:
      image(dog, position.x, position.y);
      break;
    case 4:
      image(man, position.x, position.y);
      break;
    case 5:
      image(sign, position.x, position.y);
      break;
    case 6:
      image(car, position.x, position.y);
      break;
    case 7:
      image(tree, position.x, position.y);
      break;
    }

    //draw an outline for uncollected items indicating 
    //whether the ball is large enough to collect the item
    if (!collected) {
      ellipseMode(CENTER);
      noFill();
      strokeWeight(2);
      //set the stroke of the outline depending on whether the item is more 
      //or less massive than the ball
      if (mass > ball.mass) {
        stroke(255, 0, 0);
      } else {
        stroke(0, 255, 0);
      }
      //draw the outline
      ellipse(position.x, position.y, mass, mass);
    }
  }
}