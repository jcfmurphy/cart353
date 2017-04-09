//define the Unicorn class

class Unicorn {

  /*----------------------------------- Properties -------------------------------------*/

  //the position, velocity, and acceleration of the unicorn
  PVector position;
  PVector velocity;
  PVector acceleration;

  //the width and height of the unicorn
  int unicornWidth = 45;
  int unicornHeight = 190;

  //movement forces
  PVector jumpForce = new PVector(0, -32);
  PVector swimForce = new PVector(0, -50);
  PVector walkForce = new PVector(3, 0);

  //top speed for horizontal movement
  float topSpeed = 8;

  //variables to track the action state of the unicorn
  State idleRight = new State("UnicornIdleRight", 1);
  State walkRight = new State("UnicornWalkRight", 24);
  State jumpRight = new State("UnicornJumpRight", 1);
  State slideRight = new State("UnicornSlideRight", 1);
  State hitRight = new State("UnicornHitRight", 30);
  State idleLeft = new State("UnicornIdleLeft", 1);
  State walkLeft = new State("UnicornWalkLeft", 24);
  State jumpLeft = new State("UnicornJumpLeft", 1);
  State slideLeft = new State("UnicornSlideLeft", 1);
  State hitLeft = new State("UnicornHitLeft", 30);

  State currentState;
  int stateFrame;
  boolean faceRight;
  boolean onGround;
  boolean inWater;
  int lastJump;

  //booleans to indicate hit status
  boolean hit = false;

  //boolean to flash unicorn on and off after being hit and during invincibility
  boolean flash = false;

  //track invincibility after death
  boolean invincible = false;
  int invincibleFrame = -50000;
  int invincibleDuration = 90;

  int lives = 3;


  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Unicorn(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    currentState = idleRight;
    stateFrame = 0;
    faceRight = true;
  }

  //method to draw the Unicorn in different states
  void display() {
    updateState();

    //display the unicorn (if it is not flashed out)
    if (!flash) {
      PImage currentImage = currentState.getFrame(stateFrame);
      if (currentState == walkRight) {
        image(currentImage, position.x - 40, position.y - 10);
      } else if (!faceRight) {
        image(currentImage, position.x - 45, position.y - 10);
      } else if (currentState == hitRight) {
        image(currentImage, position.x - 100, position.y - 10);
      } else {
        image(currentImage, position.x - 10, position.y - 10);
      }
    }

    ////show hitbox for testing
    //stroke(0);
    //strokeWeight(1);
    //fill(255, 0, 0, 100);
    //rect(position.x, position.y, unicornWidth, unicornHeight);
  }


  //manages the unicorn's animation states 
  void updateState() {
    //boolean to store the store the state determined this frame and compare to the previous frame
    State newState;

    //logic to find the state as of this frame
    if (hit) {
      if (faceRight) {
        newState = hitRight;
        flash = !flash;
      } else {
        newState = hitLeft;
        flash = !flash;
      }
    } else {
      if (onGround) {
        if (d) {
          newState = walkRight;
        } else if (a) {
          newState = walkLeft;
        } else {
          if (velocity.x > 1) {
            newState = slideRight;
          } else if (velocity.x < -1) {
            newState = slideLeft;
          } else {
            if (faceRight) {
              newState = idleRight;
            } else {
              newState = idleLeft;
            }
          }
        }
      } else {
        if (faceRight) {
          newState = jumpRight;
        } else {
          newState = jumpLeft;
        }
      }
    }

    //the the state has changed from last frame, then set the stateFrame back to zero
    if (currentState != newState) {
      currentState = newState;
      stateFrame = 0;
    } else {
      stateFrame++;
    }

    //if the unicorn has been hit and reached the end of her death animation, then she dies
    if (hit && stateFrame == 30) {
      die();
    }
  }


  //method to update the position of the unicorn (and calls the display() function)
  void update() {

    //check whether the unicorn is on a solid surface or in water
    onGround = onGround();
    inWater = inWater();

    //apply movement forces from player input
    playerMoves();


    //apply gravity
    if (inWater) {
      applyForce(system.game.getWaterGravity());
    } else {
      applyForce(system.game.getGravity());
    }
    //apply friction (applies only if the unicorn is on the ground)
    friction();
    //apply drag (applies only if the unicorn is in water)
    drag();

    //set velocity to zero if it is below a threshold
    if (velocity.mag() < 0.1) {
      velocity.mult(0);
    } 
    //and enforce the top horizontal speed
    else if (velocity.x > topSpeed) {
      velocity.x = topSpeed;
    } else if (velocity.x < -topSpeed) {
      velocity.x = -topSpeed;
    }

    velocity.add(acceleration);

    //resolve x-movement, checking for obstacles
    resolveX();

    //resolve y-movement, checking for obstacles
    resolveY();

    //keep the unicorn inside the level boundaries
    if (position.x < 0) {
      position.x = 0;
      velocity.x = 0;
    }
    if (position.x > (system.game.getMapWidth() - unicornWidth)) {
      position.x = system.game.getMapWidth() - unicornWidth;
      velocity.x = 0;
    }
    if (position.y < 0) {
      position.y = 0;
      velocity.y = 0;
    }
    //unicorn dies if it falls off the bottom of the screen
    if (position.y > height) {
      hit();
    }

    //flash the unicorn if invincible, and turn off invincibility if its duration has passed
    if (invincible) {
      flash = !flash;
      if (frameCount > invincibleFrame + invincibleDuration) {
        invincible = false;
        flash = false;
      }
    }


    //reset acceleration
    acceleration.mult(0);
  }


  //apply a force to the unicorn
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  //deals with input from the player that moves the unicorn
  void playerMoves() {
    if (a && !hit) {
      applyForce(PVector.mult(walkForce, -1));
      faceRight = false;
    }
    if (d && !hit) {
      applyForce(walkForce);
      faceRight = true;
    }
  }

  //apply the jump force if the unicorn is on the ground or in water
  void jump() {
    if (!hit && (onGround || inWater) && frameCount - lastJump > 10) {
      lastJump = frameCount;
      applyForce(jumpForce);
      if (inWater) {
        waterJump.trigger();
      } else {
        unicornJump.trigger();
      }
    }
  }

  void resolveX() {

    //resolve for moving rightward
    if (velocity.x > 0) {
      //find if there is an upcoming horizontal barrier, and its distance
      boolean barrier = false;
      //start with a way-out-of-range value for barrierDistance
      float barrierDistance = 1000;

      for (GridSquare g : system.game.gridSquares) {
        if (g.getXPos() >= position.x + unicornWidth && 
          g.getXPos() <= position.x + unicornWidth + velocity.x &&
          g.getYPos() > position.y - 100 &&
          g.getYPos() < position.y + unicornHeight &&
          g.getBarrier())
        {
          barrier = true;
          if (barrierDistance > g.getXPos() - (position.x + unicornWidth)) {
            barrierDistance = g.getXPos() - (position.x + unicornWidth);
          }
        }
      }

      //if there is a barrier, then only increment position by the distance to the barrier
      if (barrier) {
        position.x = int(position.x + barrierDistance);
        velocity.x = 0;
      } else {
        position.x += velocity.x;
      }
    } 
    //resolve for moving leftward
    else if (velocity.x < 0) {
      //find if there is an upcoming horizontal barrier, and its distance
      boolean barrier = false;
      //start with a way-out-of-range value for barrierDistance
      float barrierDistance = -1000;

      for (GridSquare g : system.game.gridSquares) {
        if (g.getXPos() >= position.x - 100 + velocity.x && 
          g.getXPos() <= position.x - 100 &&
          g.getYPos() > position.y - 100 &&
          g.getYPos() < position.y + unicornHeight &&
          g.getBarrier())
        {
          barrier = true;
          if (barrierDistance < g.getXPos() + 100 - position.x) {
            barrierDistance = g.getXPos() + 100 - position.x;
          }
        }
      }

      //if there is a barrier, then only increment position by the distance to the barrier
      if (barrier) {
        position.x = int(position.x + barrierDistance + 1);
        velocity.x = 0;
      } else {
        position.x += velocity.x;
      }
    }
  }

  void resolveY() {
    //resolve for moving downward
    if (velocity.y > 0) {
      //find if there is a vertical barrier below, and its distance
      boolean barrier = false;
      //start with a way-out-of-range value for barrierDistance
      float barrierDistance = 1000;

      for (GridSquare g : system.game.gridSquares) {
        if (g.getXPos() > position.x - 100 && 
          g.getXPos() < position.x + unicornWidth &&
          g.getYPos() >= position.y + unicornHeight &&
          g.getYPos() <= position.y + unicornHeight + velocity.y &&
          (g.getBarrier() || g.getPlatform())) {
          barrier = true;
          if (barrierDistance > g.getYPos() - (position.y + unicornHeight)) {
            barrierDistance = g.getYPos() - (position.y + unicornHeight);
          }
        }
      }


      //if there is a barrier, then only increment position by the distance to the barrier
      if (barrier) {
        position.y = int(position.y + barrierDistance);
        velocity.y = 0;
      } else {
        position.y += velocity.y;
      }
    }
    //resolve for moving upward
    else if (velocity.y < 0) {
      //find if there is a vertical barrier above, and its distance
      boolean barrier = false;
      //start with a way-out-of-range value for barrierDistance
      float barrierDistance = -1000;

      for (GridSquare g : system.game.gridSquares) {
        if (g.getXPos() > position.x - 100 && 
          g.getXPos() < position.x + unicornWidth &&
          g.getYPos() >= position.y - 100 + velocity.y &&
          g.getYPos() <= position.y - 100 &&
          g.getBarrier())
        {
          barrier = true;
          if (barrierDistance < g.getYPos() + 100 - position.y) {
            barrierDistance = g.getYPos() + 100 - position.y;
          }
        }
      }

      //if there is a barrier, then only increment position by the distance to the barrier
      if (barrier) {
        position.y = int(position.y + barrierDistance + 1);
        velocity.y = 0;
      } else {
        position.y += velocity.y;
      }
    }
  }

  //check whether the unicorn is intersecting with water
  boolean inWater() {
    boolean tempInWater = false;

    //check for interection with a water gridsquare
    for (GridSquare g : system.game.gridSquares) {
      if (g.getXPos() > position.x - 100 &&
        g.getXPos() < position.x + unicornWidth &&
        g.getYPos() > position.y - 100 &&
        g.getYPos() < position.y + unicornHeight &&
        g.getWater()) {
        tempInWater = true;
        if (inWater == false) {
          splash.trigger();
        }
        break;
      }
    }
    return tempInWater;
  }

  //check whether the unicorn is standing on something
  boolean onGround() {
    boolean tempOnGround = false;

    //check for if barrier gridsquare is within 3 pixels under unicorn's feet
    for (GridSquare g : system.game.gridSquares) {
      if (g.getXPos() > position.x - 100 &&
        g.getXPos() < position.x + unicornWidth &&
        g.getYPos() >= position.y + unicornHeight &&
        g.getYPos() < position.y + unicornHeight + 1 &&
        velocity.y >= 0 &&
        (g.getBarrier() || g.getPlatform())) {
        tempOnGround = true;
        break;
      }
    }
    return tempOnGround;
  }

  void drag() {
    if (inWater) {
      //calculate the magnitude of drag
      float speed = velocity.mag();
      float dragMagnitude = system.game.getDragC() * speed * speed;

      //create the drag vector with direction opposite to velocity
      PVector drag = velocity.copy();
      drag.normalize();
      drag.mult(-dragMagnitude);

      //apply the drag force
      applyForce(drag);
    }
  }

  void friction() {
    if (onGround) {
      //calculate the magnitude of friction
      float frictionMag = system.game.getFrictionC();

      //create the friction vector and apply it to the ball
      PVector friction = velocity.copy();
      friction.normalize();
      friction.mult(-frictionMag);
      applyForce(friction);
    }
  }

  void die() {
    lives--;
    hit = false;
    invincible = true;
    invincibleFrame = frameCount;
    
    //set a safe location for resurrection

    //game over if no remaining lives
    if (lives <= 0) {
      system.game.setGameOver(true);
    }
  }

  void hit() {
    if (!hit) {
      hit = true;
      velocity.y = -32;
      if (faceRight) {
        velocity.x = -30;
      } else {
        velocity.x = 30;
        ;
      }
      deathGrunt.trigger();
    }
  }

  boolean getInvincible() {
    return invincible;
  }

  float getXPos() {
    return position.x;
  }

  float getYPos() {
    return position.y;
  }

  int getWidth() {
    return unicornWidth;
  }

  int getHeight() {
    return unicornHeight;
  }

  int getLives() {
    return lives;
  }
  
  boolean getFaceRight() {
   return faceRight; 
  }
}