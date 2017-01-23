class Hud {

  /*----------------------------------- Properties -------------------------------------*/

  //the position
  int x;
  int y;
  //the dimensions
  int hudWidth;
  int hudHeight;

  //the button radius
  int radius;
  //the selected button
  int selected;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  Hud() {
    x = 0;
    y = 360;
    hudWidth = width;
    hudHeight = 120;
    radius = 60;
    selected = 1;
  }

  void display() {
    //draw the background
    rectMode(CORNER);
    noStroke();
    fill(0);
    rect(x, y, hudWidth, hudHeight);

    //draw the buttons
    ellipseMode(CENTER);
    fill(255);
    ellipse(x + hudWidth * 0.2, y + hudHeight * 0.5, radius, radius);
    ellipse(x + hudWidth * 0.4, y + hudHeight * 0.5, radius, radius);
    ellipse(x + hudWidth * 0.6, y + hudHeight * 0.5, radius, radius);
    ellipse(x + hudWidth * 0.8, y + hudHeight * 0.5, radius, radius);

    //fill in the selected button
    fill(100);
    if (selected == 1) {
      ellipse(x + hudWidth * 0.2, y + hudHeight * 0.5, radius * 0.75, radius * 0.75);
    } else if (selected == 2) {
      ellipse(x + hudWidth * 0.4, y + hudHeight * 0.5, radius * 0.75, radius * 0.75);
    } else if (selected == 3) {
      ellipse(x + hudWidth * 0.6, y + hudHeight * 0.5, radius * 0.75, radius * 0.75);
    } else if (selected == 4) {
      ellipse(x + hudWidth * 0.8, y + hudHeight * 0.5, radius * 0.75, radius * 0.75);
    }
  }
  
  void select() {
    //find the cursor's distance from each button location
    float dist1 = dist(mouseX, mouseY, x +hudWidth * 0.2, y + hudHeight * 0.5);
    float dist2 = dist(mouseX, mouseY, x +hudWidth * 0.4, y + hudHeight * 0.5);
    float dist3 = dist(mouseX, mouseY, x +hudWidth * 0.6, y + hudHeight * 0.5);
    float dist4 = dist(mouseX, mouseY, x +hudWidth * 0.8, y + hudHeight * 0.5);
    
    //change the selected button if the mouse is close enough to the button location
    if (dist1 <= radius) {
      selected = 1;
    } else if (dist2 <= radius) {
      selected = 2;
    } else if (dist3 <= radius) {
      selected = 3;
    } else if (dist4 <= radius) {
      selected = 4;
    }
  }
  
  int getSelected() {
   return selected; 
  }
}