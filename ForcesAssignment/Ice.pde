//define the Ice class

class Ice {

  /*----------------------------------- Properties -------------------------------------*/
  //The ice's position and width and height
  float x, y, w, h;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Ice() {
    
    //randomize width and height of the ice patch
    w = int(random(200, 400));
    h = int(random(200, 400));
    
    //randomize placement of the ice patch, but keep it on the right side of the screen
    x = int(random((width / 2), (width - w)));
    y = int(random(0, height - h));       
  }
  
  
  void display() {
    rectMode(CORNER);
    noStroke();
    fill(200, 200, 255);
    rect(x, y, w, h);
  }
  
}