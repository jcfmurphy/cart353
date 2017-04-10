// This class defines the user interaction with the game

class Controls {

  /*----------------------------------- Properties -------------------------------------*/
  System system;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Controls (System _system) {
    system = _system;
  }

  /*---------------------------- Control Schema Methods---------------------------------*/

  void mousePress() {

    //game mousePressed controls
    if (system.getShowGame()) {
      system.game.shoot();
    } 
    //editor mousePressed controls
    else if (system.getShowEditor()) {
      //if in the map grid window...
      if (system.editor.inGrid(mouseX, mouseY)) {
        //fill the grid square with the selected sprite
        system.editor.fillGridSquare();
      } else {
        //otherwise trigger the appropriate hud button
        system.editor.hud.triggerButton();
      }
    }
  }

  void mouseDrag() {

    //editor mouseDragged controls 
    if (system.getShowEditor()) {
      //if in the map grid window...
      if (system.editor.inGrid(mouseX, mouseY)) {
        //fill the grid square with the selected sprite
        system.editor.fillGridSquare();
      }
    }
  }

  void mouseRelease() {

    //menu mouseReleased controls
    if (system.getShowMenu()) {
      system.menu.menuClick();
    }
  }

  void keyPress() {

    //in-game keyPressed controls
    if (system.getShowGame()) {
      setKeys(true);
      if (key == ' ' || key == ' ') {
        system.game.unicorn.jump();
      }
    }
    //editor keyPressed controls
    else if (system.getShowEditor()) {
      if (key == CODED) {
        if (keyCode == LEFT) {
          //left key moves camera left      
          system.editor.cameraLeft();
        } else if (keyCode == RIGHT) {
          //right key moves camera right
          system.editor.cameraRight();
        } else if (keyCode == UP) {
          //up key extends the map
          system.editor.extendMap();
        } else if (keyCode == DOWN) {
          //down key cuts a column off the right side of the map
          system.editor.cutMap();
        }
      } else if (key == 's' || key == 'S') {
        system.editor.saveMap();
      }
    }
  }

  void keyRelease() {
    //in-game keyReleased controls
    if (system.getShowGame()) {
      setKeys(false);
    }
  }

  //method to set the booleans for directional keys
  void setKeys(boolean press) {
    //set the directional booleans based on the press and release of the wasd keys
    if (key == 'w' || key == 'W') {
      w = press;
    }
    if (key == 'a' || key == 'A') {
      a = press;
    }
    if (key == 's' || key == 'S') {
      s = press;
    }
    if (key == 'd' || key == 'D') {
      d = press;
    }
  }
}