//defines an action state for animating a sprite

//define the Unicorn class

class State {

  /*----------------------------------- Properties -------------------------------------*/
    String stateName;
    PImage[] frames;



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
  
  PImage getFrame(int frameNum) {
    frameNum %= frames.length;
    return frames[frameNum];
  }

}