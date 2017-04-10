//defines an action state for animating a sprite

//define the Unicorn class

class State {

  /*----------------------------------- Properties -------------------------------------*/
  String stateName;
  //array of images for the animation
  PImage[] frames;
  //Vector for the display offset to have the unicorn image match its hitbox
  PVector displayOffset;
  //Vector for the offset to have the projectiles fire from the gun's muzzle
  PVector gunOffset;

  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  State(String name, int frameNum) {
    stateName = name;
    frames = new PImage[frameNum];
    for (int i = 0; i < frames.length; i++) {
      String imageName = stateName + "_" + nf(i, 3) + ".png";
      frames[i] = loadImage(imageName);
    }
  }

  State(String name, int frameNum, float displayOffsetX, float displayOffsetY, float gunOffsetX, float gunOffsetY) {
    stateName = name;
    frames = new PImage[frameNum];
    for (int i = 0; i < frames.length; i++) {
      String imageName = stateName + "_" + nf(i, 3) + ".png";
      frames[i] = loadImage(imageName);
    }

    displayOffset = new PVector(displayOffsetX, displayOffsetY);
    gunOffset = new PVector(gunOffsetX, gunOffsetY);
  }
  
  //display the correct frame with the correct display offset
  void display(int stateFrame, float x, float y) {
    stateFrame %= frames.length;
    PImage currentImage = frames[stateFrame];
    
    image(currentImage, x + displayOffset.x, y + displayOffset.y);
  }

  PImage getFrame(int frameNum) {
    frameNum %= frames.length;
    return frames[frameNum];
  }

  float getDisplayOffsetX() {
    return displayOffset.x;
  }

  float getDisplayOffsetY() {
    return displayOffset.y;
  }

  float getGunOffsetX() {
    return gunOffset.x;
  }

  float getGunOffsetY() {
    return gunOffset.y;
  }
}