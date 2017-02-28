/*
Roll the ball around the map with the WASD keys.
 Collect the small, green items to increase the ball's size and be able to collect larger items. 
 The water patch drags on the ball. 
 The ice patch is slippery, so the ball has no friction and has difficulty turning on it.
 
 The forces included are gravitational attraction, friction, and fluid resistance.
 */

/*-----------------------GLOBAL VARIABLES--------------------------*/

//declare the game images
PImage cake, dollar, mailbox, dog, man, sign, car, tree;

//declare the text font
PFont bungee;

//booleans for whether each of the directional keys is being pressed
boolean w, a, s, d;

//the ball that the player controls
Ball ball;

//declare a water and ice patch
Water water;
Ice ice;

//an array of items to be collected and a temporary IntList used to fill the array
ArrayList<Item> items;
IntList tempItems;

/*-----------------------DEFAULT FUNCTIONS--------------------------*/

void setup() {
  size(1200, 800);
  background(255);

  //load the game images
  cake = loadImage("cake-slice-with-cherry.png");
  cake.resize(0, 26);
  dollar = loadImage("dollar-bill.png");
  dollar.resize(0, 28);
  mailbox = loadImage("mailbox.png");
  mailbox.resize(0, 64);
  dog = loadImage("poodle.png");
  dog.resize(0, 48);
  man = loadImage("running.png");
  man.resize(0, 66);
  sign = loadImage("street-panels.png");
  sign.resize(0, 72);
  car = loadImage("car.png");
  car.resize(0, 90);
  tree = loadImage("nature.png");
  tree.resize(0, 90);

  //load the font
  bungee = createFont("Bungee-Regular.ttf", 40);

  //initialize the directional booleans
  w = false;
  a = false;
  s = false;
  d = false;

  //instantiate the ball
  ball = new Ball();

  //instantiate the water and ice patches
  water = new Water();
  ice = new Ice();

  //instantiate the items array
  items = new ArrayList<Item>();
  tempItems = new IntList();

  //fill the items array
  createItems();
}

void draw() {
  background(255);

  //check if all the items have been collected...
  if (allItemsCollected()) {
    //display a message saying "You Win!"
    fill(100);
    textFont(bungee);
    textSize(200);
    textAlign(CENTER, CENTER);
    text("You Win!", width / 2, height / 2);
  } else {
    //move the ball with the controls and apply friction 
    //only if the ball is not inside the ice area
    if (!ball.isInside(ice)) {
      //accelerate the ball with the controls
      ball.push(0.002);

      //calculate the magnitude of friction
      float frictionMag = ball.c * ball.mass;

      //create the friction vector and apply it to the ball
      PVector friction = ball.velocity.get();
      friction.normalize();
      friction.mult(-frictionMag);
      ball.applyForce(friction);
    } else {
      //if the ball is on ice, it cannot grip to change direction as easily
      //and there is no friction
      ball.push(0.0006);
    }

    //apply fluid resistance if the ball is in the water area
    if (ball.isInside(water)) {
      ball.drag(water);
    }

    //update the ball's position and velocity
    ball.update();

    //check if the ball has collected any of the items
    for (Item i : items) {
      ball.collect(i);
    }

    //apply gravitational force to the collected objects, then update their positions and velocities
    for (Item i : items) {
      i.orbit();
      i.update();
    }

    //display the objects
    water.display();
    ice.display();
    ball.display();
    for (Item i : items) {
      i.display();
    }
  }
}

/*-----------------------INPUT FUNCTIONS--------------------------*/

void keyPressed() {
  //set the booleans for the pressed directional keys to 'true'
  setKeys(true);
}

void keyReleased() {
  //set the booleans for the released directional keys to 'false'
  setKeys(false);
}

/*-----------------------CUSTOM FUNCTIONS--------------------------*/

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

//populate the map with items
void createItems() {
  //fill the temporary IntList with the appropriate number of each item
  for (int i = 0; i < 96; i++) {
    if (i < 15) {
      tempItems.append(0);
    } else if (i < 30) {
      tempItems.append(1);
    } else if (i < 45) {
      tempItems.append(2);
    } else if (i < 60) {
      tempItems.append(3);
    } else if (i < 69) {
      tempItems.append(4);
    } else if (i < 78) {
      tempItems.append(5);
    } else if (i < 87) {
      tempItems.append(6);
    } else {
      tempItems.append(7);
    }
  }

  //fill the items ArrayList with the items
  for (int x = 0; x < width; x += 100) {
    for (int y = 0; y < height; y += 100) {

      //do nothing if in one of the four center squares so that no items overlap the ball start position
      if ((x == (width / 2) || x == (width / 2) - 100) && (y == (height / 2) || y == (height / 2) - 100)) {
      } 
      //otherwise, create an item in this grid square
      else {

        //select a random item from the tempItems list
        int tempIndex = int(random(tempItems.size()));
        int itemNum = tempItems.get(tempIndex);
        //remove the item from the tempItems list so it does not get selected again
        tempItems.remove(tempIndex);

        //offset the x and y positions by a random number so that the items are not
        //snapped to the grid, but make sure they stay onscreen
        int xPos = x + int(random(100));
        int yPos = y + int(random(100));
        xPos = constrain(xPos, 48, width - 48);
        yPos = constrain(yPos, 48, height - 48);

        //create the appropriate item in the items array
        items.add(new Item(xPos, yPos, itemNum, ball));
      }
    }
  }
}


boolean allItemsCollected() {

  for (Item i : items) {
    if (!i.collected) {
      return false;
    }
  }

  return true;
}