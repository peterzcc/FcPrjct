// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A circular particle

class Weapon {

  // We need to keep track of a Body and a radius
  Body body;
  
  Weapon(float x, float y,float vx, float vy) {
    // This function puts the particle in the Box2d world
    makeBody(x, y);
    body.setLinearVelocity(new Vec2 (vx,vy));
    body.setUserData(this);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }


  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+10*2 || pos.x<-50 || pos.x>width+50) {
      killBody();
      return true;
    }
    return false;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0,0,255);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, 20, 20);

    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.KINEMATIC;
    bd.gravityScale=0.0;
    body = box2d.world.createBody(bd);

    
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(10);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    body.createFixture(fd);

  }

};
