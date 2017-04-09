//define the Slime class

class Slime extends Enemy {

  /*----------------------------------- Properties -------------------------------------*/

  //variables to track the action state of the slime
  State walkRight = new State("SlimeWalkRight", 60);
  State walkLeft = new State("SlimeWalkLeft", 60);
  State currentState;
  int stateFrame;


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

      //play slime sound once per animation cycle
      if (stateFrame % 60 == 10) {
        slimeSound.trigger();
      }

      //display hitbox for testing
      //stroke(0);
      //strokeWeight(1);
      //fill(255, 0, 0, 100);
      //rect(position.x, position.y, enemyWidth, enemyHeight);
    }
  }


  //method to draw the Slime in different states
  void display() {    

    PImage currentImage = currentState.getFrame(stateFrame);
    if (faceRight) {
      image(currentImage, position.x - 10, position.y - 20);
    } else {
      image(currentImage, position.x - 25, position.y - 20);
    }
    stateFrame++;
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
        currentState = walkLeft;
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
        currentState = walkRight;
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


  //apply a force to the slime
  void applyForce(PVector force) {
    velocity.add(force);
  }
}