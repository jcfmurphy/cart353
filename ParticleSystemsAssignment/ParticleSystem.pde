//define the ParticleSystem class

class ParticleSystem {
  /*----------------------------------- Properties -------------------------------------*/
  ArrayList<Particle> particles;

  /*----------------------------------- Constructors ----------------------------------------*/

  ParticleSystem() {
    particles = new ArrayList<Particle>();

    //start with some clouds in the sky
    particles.add(new Cloud(200));
    particles.add(new Cloud(500));
    particles.add(new Cloud(650));
    particles.add(new Cloud(1050));
    particles.add(new Cloud(1200));
  }

  /*----------------------------------- Methods ----------------------------------------*/

  void run() {
    //create an iterator for the particles ArrayList
    Iterator<Particle> it = particles.iterator();
    //iterate through the ArrayList
    while (it.hasNext()) {
      Particle p = it.next();
      //run the particle
      p.run();
      //remove the particle if it has run through its lifespan
      if (p.isDead()) {
        it.remove();
      }
    }
  }

  void addParticle() {
    //add a flame every tenth frame
    if (frameCount % 10 == 0) {
      particles.add(new Flame());
    }

    //add a spark every tenth frame
    if (frameCount % 10 == 0) {
      particles.add(new Spark());
    }

    //add a wave every fifth frame
    if (frameCount % 5 == 0) {
      particles.add(new Wave());
    }

    //add a cloud every 600 frames
    if (frameCount % 600 == 0) {
      particles.add(new Cloud());
    }
  }
}