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
  int crouchOffset = 40;


  //movement forces
  PVector jumpForce = new PVector(0, -32);
  PVector swimForce = new PVector(0, -50);
  PVector walkForce = new PVector(3, 0);

  //top speed for horizontal movement
  float topSpeed = 10;

  //variables to track the action state of the unicorn
  State idleRight = new State("UnicornIdleRight", 1, -10, -10, 100, 55);
  State idleRightUp = new State("IdleRightUp", 1, -5, -41, 22, -30);
  State walkRight = new State("UnicornWalkRight", 24, -40, -10, 100, 55);
  State walkRightUp = new State("WalkRightUp", 24, -40, -41, 22, -30);
  State jumpRight = new State("UnicornJumpRight", 1, -10, -10, 100, 55);
  State jumpRightUp = new State("JumpRightUp", 1, -5, -41, 22, -30);
  State slideRight = new State("UnicornSlideRight", 1, -10, -10, 100, 55);
  State slideRightUp = new State("SlideRightUp", 1, -5, -41, 22, -30);
  State hitRight = new State("UnicornHitRight", 30, -100, -10, 100, 55);
  State crouchRight = new State("UnicornCrouchRight", 1, -20, 28, 100, 95);
  State idleLeft = new State("UnicornIdleLeft", 1, -45, -10, -95, 55);
  State idleLeftUp = new State("IdleLeftUp", 1, -14, -41, -14, -30);
  State walkLeft = new State("UnicornWalkLeft", 24, -45, -10, -95, 55);
  State walkLeftUp = new State("WalkLeftUp", 24, -31, -41, -14, -30);
  State jumpLeft = new State("UnicornJumpLeft", 1, -45, -10, -95, 55);
  State jumpLeftUp = new State("JumpLeftUp", 1, -30, -41, -14, -30);
  State slideLeft = new State("UnicornSlideLeft", 1, -45, -10, -95, 55);
  State slideLeftUp = new State("SlideLeftUp", 1, -22, -41, -14, -30);
  State hitLeft = new State("UnicornHitLeft", 30, -60, -10, -95, 55);
  State crouchLeft = new State("UnicornCrouchLeft", 1, -55, 28, -95, 95);

  State currentState;
  int stateFrame;
  boolean faceRight;
  boolean onGround;
  boolean inWater;
  boolean crouched;
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
      
      currentState.display(stateFrame, position.x, position.y);
      
    }

    //show hitbox for testing
    //stroke(0);
    //strokeWeight(1);
    //fill(255, 0, 0, 100);
    //if (!crouched) {
    //  rect(position.x, position.y, unicornWidth, unicornHeight);
    //} else {
    //  rect(position.x, position.y + crouchOffset, unicornWidth, unicornHeight - crouchOffset);
    //}
  }


  //manages the unicorn's animation states 
  void updateState() {
    //boolean to store the store the state determined this frame and compare to the previous frame
    State newState;

    //reset the crouched boolean
    crouched = false;

    //logic to find the state as of this frame
    if (hit) {
      if (faceRight) {
        newState = hitRight;
      } else {
        newState = hitLeft;
      }
    } else {
      if (onGround) {
        if (s) {
          crouched = true;
          if (faceRight) {
            newState = crouchRight;
          } else {
            newState = crouchLeft;
          }
        } else if (d) {
          if (w) {
            newState = walkRightUp;
          } else {
            newState = walkRight;
          }
        } else if (a) {
          if (w) {
            newState = walkLeftUp;
          } else {
            newState = walkLeft;
          }
        } else {
          if (velocity.x > 1) {
            if (w) {
              newState = slideRightUp;
            } else {
              newState = slideRight;
            }
          } else if (velocity.x < -1) {
            if (w) {
              newState = slideLeftUp;
            } else {
              newState = slideLeft;
            }
          } else {
            if (faceRight) {
              if (w) {
                newState = idleRightUp;
              } else {
                newState = idleRight;
              }
            } else {
              if (w) {
                newState = idleLeftUp;
              } else {
                newState = idleLeft;
              }
            }
          }
        }
      } else {
        if (faceRight) {
          if (w) {
            newState = jumpRightUp;
          } else {
            newState = jumpRight;
          }
        } else {
          if (w) {
            newState = jumpLeftUp;
          } else {
            newState = jumpLeft;
          }
        }
      }
    }

    //if the state has changed from last frame, then set the stateFrame back to zero
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
    if (velocity.mag() < 0.3) {
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
      faceRight = false;
      if (!s) {
        applyForce(PVector.mult(walkForce, -1));
      }
    }
    if (d && !hit) {
      faceRight = true;
      if (!s) {
        applyForce(walkForce);
      }
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
    system.game.setLives(system.game.getLives() - 1);
    hit = false;
    invincible = true;
    invincibleFrame = frameCount;
    system.game.setCurrentWeapon("ArcShot");

    //set a safe location for resurrection
    position = system.game.safePosition();
    velocity.x = 0;
    velocity.y = 0;

    //game over if no remaining lives
    if (system.game.getLives() <= 0) {
      system.game.setGameOver(true);
    }
  }

  void hit() {
    if (!hit && !invincible) {
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

  float getShotXPos() {
    return position.x + currentState.getGunOffsetX();
  }

  float getShotYPos() {
    return position.y + currentState.getGunOffsetY();
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

  boolean getFaceRight() {
    return faceRight;
  }

  int getCrouchOffset() {
    return crouchOffset;
  }

  boolean getCrouched() {
    return crouched;
  }

  boolean getHit() {
    return hit;
  }
}