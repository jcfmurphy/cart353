//define the Slime class

class Slime extends Enemy {

  /*----------------------------------- Properties -------------------------------------*/

  //variables to track the action state of the slime
  State walkRight = new State("SlimeWalkRight", 60, -10, -20, 140, 20);
  State walkLeft = new State("SlimeWalkLeft", 60, -25, -20, 20, 20);
  State rWalkRight = new State("RSlimeWalkRight", 60, -10, -20, 140, 20);
  State rWalkLeft = new State("RSlimeWalkLeft", 60, -25, -20, 20, 20);
  State hitRight = new State("RSlimeHitRight", 60, -10, -88, 140, 20);
  State hitLeft = new State("RSlimeHitLeft", 60, -25, -88, 20, 20);
  State currentState;
  int stateFrame;

  //track the next frame that the slime will shoot a slimeShot
  int nextShot;
  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Slime(float x, float y) {
    super(x, y);
    velocity = new PVector(2, 0);
    currentState = walkLeft;
    stateFrame = 0;
    faceRight = false;
    enemyWidth = 160;
    enemyHeight = 80;
    hitPoints = 3;
    scorePoints = 500;
    nextShot = frameCount + int(random(120, 180));
  }


  //method to update the position of the slime (and calls the display() function)
  void update() {

    if (position.x > system.game.getOffset() - 300 && position.x < system.game.getOffset() + system.game.getGameWidth() + 300) {
      //apply gravity
      applyForce(system.game.getGravity());

      //resolve x-movement, checking for obstacles
      resolveX();

      //resolve y-movement, checking for obstacles
      resolveY();

      updateState();

      if (nextShot == frameCount) {
        shoot();
      }
    }

    if (nextShot == frameCount) {
      nextShot = frameCount + int(random(90, 120));
    }
  }

  //manages the slime's animation states 
  void updateState() {
    //boolean to store the store the state determined this frame and compare to the previous frame
    State newState;

    //logic to find the state as of this frame
    if (hit) {
      if (faceRight) {
        newState = hitRight;
      } else {
        newState = hitLeft;
      }
    } else {
      if (frameCount - lastHit < 5) {
        if (faceRight) {
          newState = rWalkRight;
        } else {
          newState = rWalkLeft;
        }
      } else {
        if (faceRight) {
          newState = walkRight;
        } else {
          newState = walkLeft;
        }
      }
    }

    //set the stateFrame back to zero immediately after the slime has been hit to zero life
    if (hit && currentState != hitRight && currentState != hitLeft) {
      stateFrame = 0;
      slimeDeath.trigger();
    } else {
      stateFrame++;
    }

    currentState = newState;

    //if the slime has reached the end of its death animation, then it dies
    if (hit && stateFrame == 60) {
      dead = true;
    }
  }



  //method to draw the Slime in different states
  void display() {    

    currentState.display(stateFrame, position.x, position.y);

    stateFrame++;

    //display hitbox for testing
    //stroke(0);
    //strokeWeight(1);
    //fill(255, 0, 0, 100);
    //rect(position.x, position.y, enemyWidth, enemyHeight);
  }


  void resolveX() {

    //resolve for moving rightward
    if (faceRight) {
      //find if there is an upcoming horizontal barrier, and its distance
      boolean barrier = false;
      //start with a way-out-of-range value for barrierDistance
      float barrierDistance = 1000;

      for (GridSquare g : system.game.gridSquares) {
        if (g.getXPos() >= position.x + enemyWidth && 
          g.getXPos() <= position.x + enemyWidth + velocity.x &&
          g.getYPos() > position.y - 100 &&
          g.getYPos() < position.y + enemyHeight &&
          g.getBarrier())
        {
          barrier = true;
          if (barrierDistance > g.getXPos() - (position.x + enemyWidth)) {
            barrierDistance = g.getXPos() - (position.x + enemyWidth);
          }
        }
      }

      //if there is a barrier, then only increment position by the distance to the barrier
      if (barrier) {
        position.x = int(position.x + barrierDistance);
        faceRight = false;
      } else {
        position.x += velocity.x;
      }
    } 
    //resolve for moving leftward
    else if (!faceRight) {
      //find if there is an upcoming horizontal barrier, and its distance
      boolean barrier = false;
      //start with a way-out-of-range value for barrierDistance
      float barrierDistance = -1000;

      for (GridSquare g : system.game.gridSquares) {
        if (g.getXPos() >= position.x - 100 - velocity.x && 
          g.getXPos() <= position.x - 100 &&
          g.getYPos() > position.y - 100 &&
          g.getYPos() < position.y + enemyHeight &&
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
        faceRight = true;
      } else {
        position.x -= velocity.x;
      }
    }
  }

  void resolveY() {

    //find if there is a vertical barrier below, and its distance
    boolean barrier = false;
    //start with a way-out-of-range value for barrierDistance
    float barrierDistance = 1000;

    for (GridSquare g : system.game.gridSquares) {
      if (g.getXPos() > position.x - 100 && 
        g.getXPos() < position.x + enemyWidth &&
        g.getYPos() >= position.y + enemyHeight &&
        g.getYPos() <= position.y + enemyHeight + velocity.y &&
        (g.getBarrier() || g.getPlatform() || g.getWater())) {
        barrier = true;
        if (barrierDistance > g.getYPos() - (position.y + enemyHeight)) {
          barrierDistance = g.getYPos() - (position.y + enemyHeight);
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

  void shoot() {
    if (!hit) {
      system.game.projectiles.add(new SlimeShot(position.x + currentState.getGunOffsetX(), position.y + currentState.getGunOffsetY(), faceRight));

      slimeSound.trigger();
    }
  }

  void hit(int damage) {
    super.hit(damage);
    slimeSound.trigger();
  }
}