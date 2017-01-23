//declare the source images
PImage orange1;
PImage orange2;

//create a variable for the font being used
PFont cooper;
//create a string to hold the instructions
String instructions;

//declare the heads-up display
Hud hud;

//declare an arraylist of raindrops
ArrayList<Raindrop> raindrops;
//declare the differentiator object
Differentiator differentiator;
//declare the InterlaceBlur object
InterlaceBlur interlaceBlur;

//variable to track the number of the image being save to the sketch folder
int outputNum;

//boolean to determine which source image is the default background image
boolean background;

void setup() {
  size(480, 480);
  //load the source images
  orange1 = loadImage("orange1.png");
  orange2 = loadImage("orange2.png");

  //load the font
  cooper = createFont("CooperHewitt-BookItalic.otf", 40);

  //set the instructions string
  instructions = "Click the image to switch backgrounds. Click the buttons below to select effects.";

  //initialize the heads-up display
  hud = new Hud();

  //initialize the raindrops arraylist
  raindrops = new ArrayList<Raindrop>();
  //initialize the differentiator
  differentiator = new Differentiator();
  //initialize the interlaceBlur object
  interlaceBlur = new InterlaceBlur();

  //set the initial image output number
  outputNum = 1;

  //initialize the background boolean to true
  background = true;
}

void draw() {

  //if the background boolean is true...
  if (background) {
    //display source image 1
    image(orange1, 0, 0);
  } 
  //otherwise display source image 2
  else {
    image (orange2, 0, 0);
  }

  //display the effect depending on the selected button in the heads-up display
  if (hud.getSelected() == 1) {

    //display the instructions text
    if (background) {
      fill(255, 150);
    } else {
      fill(0, 150);
    }
    textFont(cooper);
    textSize(40);
    textAlign(CENTER, CENTER);

    text(instructions, 0, 0, orange1.width, orange1.height);
  } else if (hud.getSelected() == 2) {

    //add a new raindrop each frame
    raindrops.add(new Raindrop());

    //go through the arraylist...
    for (int i = raindrops.size() - 1; i >= 0; i--) {
      //get the raindrop from the arraylist
      Raindrop raindrop = raindrops.get(i);

      //if the raindrop has a transparency of 0, remove it from the arraylist...
      if (raindrop.getTransparency() <= 0) {
        raindrops.remove(i);
      } else {
        //or else display the raindrop
        raindrop.activate();
      }
    }
  } else if (hud.getSelected() == 3) {
    //activate the differentiator effect
    differentiator.activate();
  } else if (hud.getSelected() == 4) {
    //activate the interlaceBlur effect
    interlaceBlur.activate();
  }

  //display the heads-up display
  hud.display();
}

void keyPressed() {
  if (key == ENTER) {
    save("savedPic" + outputNum + ".png");
    outputNum++;
  }
}

void mouseReleased() {
  //if the mouse is in the hud region...
  if (mouseY >= orange1.height) {
    hud.select();
  } 
  //or else, if the mouse is in the image region...
  else {
    //switch the default background image
    background = !background;
  }
}