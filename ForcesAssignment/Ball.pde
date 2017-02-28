//define the Ball class

class Ball {

  /*----------------------------------- Properties -------------------------------------*/
  //The ball's position, velocity, and acceleration
  PVector position;
  PVector velocity;
  PVector acceleration;

  //The ball's mass
  int mass;

  //The ball's coefficient of friction
  float c = 0.001;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Ball() {
    position = new PVector(width * 0.5, height * 0.5);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 50;
  }


  void applyForce(PVector force) {
    acceleration.add(force);
  }


  void push(float force) {
    if (w) {
      ball.applyForce(new PVector(0, -force * mass));
    }
    if (s) {
      ball.applyForce(new PVector(0, force * mass));
    }
    if (a) {
      ball.applyForce(new PVector(-force * mass, 0));
    }
    if (d) {
      ball.applyForce(new PVector(force * mass, 0));
    }
  }


  void update() {
    velocity.add(acceleration);
    position.add(velocity);

    if (position.x < mass / 2) {
      position.x = mass / 2;
      velocity.x = 0;
    }
    if (position.x > (width - mass / 2)) {
      position.x = width - mass / 2;
      velocity.x = 0;
    }
    if (position.y < mass / 2) {
      position.y = mass / 2;
      velocity.y = 0;
    }
    if (position.y > (height - mass / 2)) {
      position.y = height - mass / 2;
      velocity.y = 0;
    }
    
    //reset the acceleration to zero
    acceleration.mult(0);
  }


  void display() {
    ellipseMode(CENTER);
    stroke(0);
    strokeWeight(1);
    fill(100, 200, 100);
    ellipse(position.x, position.y, mass, mass);
  }


  boolean isInside(Water water) {
    if (position.x > water.x && position.x < water.x + water.w && 
      position.y > water.y && position.y < water.y + water.h) {
      return true;
    } else {
      return false;
    }
  }


  boolean isInside(Ice ice) {
    if (position.x > ice.x && position.x < ice.x + ice.w && 
      position.y > ice.y && position.y < ice.y + ice.h) {
      return true;
    } else {
      return false;
    }
  }


  void drag(Water water) {
    //calculate the magnitude of drag
    float speed = velocity.mag();
    float dragMagnitude = water.c * speed * speed;

    //create the drag vector with direction opposite to velocity
    PVector drag = velocity.get();
    drag.normalize();
    drag.mult(-dragMagnitude);

    //apply the drag force
    applyForce(drag);
  }


  void collect(Item item) {
    //if the item has not already been collected and the ball's mass is larger than the item's...
    if (!item.collected && mass >= item.mass) {
      //calculate the distance between the ball and item
      float distance = dist(position.x, position.y, item.position.x, item.position.y);
      
      //and if the distance is less than the sum of their radii...
      if (distance < ((mass * 0.5) + (item.mass * 0.5))) {
          //set the item to collected
          item.collected = true;
          //increment the mass of the ball
          mass++;
      }
    }
  }
}