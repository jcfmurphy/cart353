//define the class for the System that runs the various windows (menu, editor, game)

class System {
  /*----------------------------------- Properties -------------------------------------*/
  //booleans to determine which screen to show
  boolean showMenu;
  boolean showEditor;
  boolean showGame;
  //the different screens available to the user
  Editor editor;
  Game game;
  Menu menu;


  /*--------------------------------- Constructors -------------------------------------*/

  //Constructor for creating a new map
  System() {
    showMenu = true;
    showEditor = false;
    showGame = false;
    menu = new Menu();
  }

  /*----------------------------------- Methods ----------------------------------------*/

  //calls the functions needed to run the game
  void run() {

    //show the title screen if the showMenu boolean is set to true
    if (showMenu) {
      menu.display();
    } 
    //show the editor if the showEditor boolean is set to true
    else if (showEditor) {
      editor.display();
    } else {
      //otherwise run the game as normal
      game.display();
    }
  }

  void startEditor() {
    editor = new Editor();
    showEditor = true;
    showMenu = false;
    showGame = false;
  }

  void startGame() {
    game = new Game();
    showMenu = false;
    showEditor = false;
    showGame = true;
  }

  boolean getShowEditor() {
    return showEditor;
  }

  boolean getShowMenu() {
    return showMenu;
  }

  boolean getShowGame() {
    return showGame;
  }

  void setShowEditor(boolean show) {
    showEditor = show;
  }

  void setShowMenu(boolean show) {
    showMenu = show;
  }

  void setShowGame(boolean show) {
    showGame = show;
  }
}