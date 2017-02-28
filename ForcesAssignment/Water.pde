//define the Water class

class Water {

  /*----------------------------------- Properties -------------------------------------*/
  //The water's position and width and height
  float x, y, w, h;

  //The coefficient of drag
  float c = 0.02;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Water() {
    
    //randomize width and height of the water patch
    w = int(random(200, 400));
    h = int(random(200, 400));
    
    //randomize placement of the water patch, but keep it on the left side of the screen
    x = int(random(0, ((width / 2) - (w))));
    y = int(random(0, height - h));       
  }
  
  
  void display() {
    rectMode(CORNER);
    noStroke();
    fill(0, 0, 255);
    rect(x, y, w, h);
  }
  
}