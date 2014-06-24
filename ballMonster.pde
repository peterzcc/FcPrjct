class BallMonster 
{

  Body body;
  float r=45;
  Animation animation;
  Explosion explosion;
  Boolean eaten=false;
  Boolean inMouse=false;
  Boolean inEyes = false;
  Boolean hitted=false;
  Boolean destroyed = false;
  Boolean exploded = false;
  Boolean track=false;

  float box2dw=15;
  float box2dh=18;
  BallMonster(float x, float y, float vx, float vy) {
    makeBody(x, y);
    body.setUserData(this);
    animation = new Animation(monster5, 7);
    track = random(1)<level/5.0;
    body.setLinearVelocity(new Vec2(vx,vy));
  }

  void display() {

    Vec2 pos = box2d.getBodyPixelCoord(body);

    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    imageMode(CENTER );
    animation.display(-5,-10, 0.2);
    imageMode(CORNER );
    /*
    stroke(255);
    noFill();
    ellipseMode(RADIUS );
    ellipse(0, 0, r, r);
    */
    popMatrix();
  }
  void makeBody(float x, float y) {
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    bd.gravityScale=0.0;

    body = box2d.world.createBody(bd);
    //    CircleShape circle = new CircleShape();
    //    circle.m_radius = box2d.scalarPixelsToWorld(r);
    //    Vec2 offset = new Vec2(0,h/2);
    //    offset = box2d.vectorPixelsToWorld(offset);
    //    circle.m_p.set(offset.x,offset.y);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 2.0;
    fd.friction = 0.01;
    fd.restitution = 0.3; // Restitution is bounciness

    body.createFixture(fd);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  void inMouthCheck(Face face) {
    if (!inMouse) {
      Vec2 pos = box2d.getBodyPixelCoord(body);
      inMouse = (inPolyCheck(pos.x, pos.y, face.gmouth)&&face.mouthHeight>2);
    }
  }
  
  void eatCheck(Face face) {
    if (inMouse) {
      Vec2 pos = box2d.getBodyPixelCoord(body);
      eaten = !inPolyCheck(pos.x, pos.y, face.gmouth);
    }
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2 || pos.x<-50 || pos.x>width+50 
      || eaten
      || inEyes
      ||exploded) {
      --face.LHealth; --face.RHealth;
      killBody();
      return true;
    }
    return false;
  }
};
