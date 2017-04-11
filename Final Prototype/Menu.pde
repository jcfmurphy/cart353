//define the class for the Game 

class Menu {
  /*----------------------------------- Properties -------------------------------------*/

  //stores the transparency of a black layer that fades to reveal the title screen
  int transparency = 255;
  //the menu buttons
  Button[] buttons = new Button[2];
  //the images
  PImage unicorn = loadImage("UnicornTitle.png");
  PImage title = loadImage("Title.png");

  /*--------------------------------- Constructors -------------------------------------*/

  //Constructor for creating a new menu
  Menu() {
    buttons[0] = new Button(width * 0.5, 500, 600, 100, "Play Game");
    buttons[1] = new Button(width * 0.5, 700, 600, 100, "Level Editor");
    //buttons[2] = new Button(width * 0.5, 800, 600, 100, "Instructions");
    
    title.resize(1600, 370);
    
  }

  /*----------------------------------- Methods ----------------------------------------*/

  //calls the functions needed to run the menu
  void display() {
    background(0);
    
    imageMode(CENTER);
    image(unicorn, width * 0.25, height * 0.65);
    image(title, width * 0.5, 200);
        
    //draw the buttons
    for (Button b : buttons) {
      b.display();
    }

    //draw a black layer overtop that will fade
    if (transparency > 0) {
      fill(0, transparency);
      rect(0, 0, width, height);
    }

    //make the black layer more transparent
    transparency = transparency - 4;
  }
  
  //deals with menu button input
  void menuClick() {
    if (buttons[0].mouseInButton()) {
      system.startGame();
    } else if (buttons[1].mouseInButton()) {
      system.startEditor();
    }
  }
    
}