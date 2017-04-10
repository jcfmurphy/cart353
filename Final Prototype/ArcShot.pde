//class for the rainbow arc projectile

class ArcShot extends Projectile {
  /*----------------------------------- Properties -------------------------------------*/



  /*----------------------------------- Methods ----------------------------------------*/

  //Constructor
  ArcShot(float x, float y, boolean faceRight) {
    super(x, y, faceRight);

    projectileHeight = 40;
    projectileWidth = 40;

    //this projectile hits enemies, so hitsUnicorn is false
    hitsUnicorn = false;

    damage = 1;

    if (w) {
      velocity = new PVector(0, -30);
      angle = PI;
    } else if (goRight) {
      velocity = new PVector(30, 0);
      angle = 0;
    } else {
      velocity = new PVector(-30, 0);
      angle = 1.25 * PI;
    }
  }

  void update() {
    super.update();
    angle += PI * 0.25;
  }

  void display() {
    ellipseMode(CORNER);
    noStroke();
    for (int i = 0; i < colors.length; i++) {
      fill(colors[i]);
      if (w) {
        arc(position.x, position.y - i * 10, projectileWidth, projectileHeight, angle + i * 0.25 * PI, angle + (i + 1) * 0.25 * PI);
      } else if (goRight) {
        arc(position.x - i * 10, position.y, projectileWidth, projectileHeight, angle + i * 0.25 * PI, angle + (i + 1) * 0.25 * PI);
      } else {
        arc(position.x + i * 10, position.y, projectileWidth, projectileHeight, angle + i * 0.25 * PI, angle + (i + 1) * 0.25 * PI);
      }
    }
  }
}