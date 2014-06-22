// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  Animation animation;
  Boolean isFirst=true;
  color col;

  Particle(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x, y, r);
    body.setUserData(this);
    int R = int(r);
    animation = new Animation("heihei",12,2*R,2*R);
    col = color(175);
//    loopingGif = new Gif(this, "heihei.gif");
//    loopingGif.loop();
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Change color when hit
  void change() {
    col = color(255, 0, 0);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
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
//    translate(pos.x, pos.y);
    rotate(-a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    
    animation.display(pos.x, pos.y,0.2);
 //   ellipse(0, 0, r*2, r*2);
    
    // Let's add a line so we can see the rotation
  //  line(0, 0, r, 0);
    int R=int(r);
  // img.resize(2*R,2*R);
  // image(img,-R,-R);
  
  
  
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    bd.gravityScale=0.0;

    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    fd.density = 2.0;
    fd.friction = 0.01;
    fd.restitution = 0.3; // Restitution is bounciness

    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(random(-5f,5f),random(-5f,-10f)));
    body.setAngularVelocity(random(-1, 1));
  }

  void move(Vec2 target){
    if (random(1)<0.05){
    Vec2 noise = new Vec2(random(-0.5,0.5),random(-3,3));
    body.setLinearVelocity(noise.add(body.getLinearVelocity()));
    }
    Vec2 diff = target.sub(body.getWorldCenter());
    float len=diff.lengthSquared();
    
    if ( len < 800){
      Vec2 noise = new Vec2(random(-0.5,0.5),random(-6,6));
//      if (len<100){
//        body.applyForceToCenter((diff.mul(100.0).add(noise)).sub(body.getLinearVelocity()));
//      }
//      else{
//        body.setLinearVelocity(diff.mul(400.0/len).add(noise));
//      }
    }
    body.applyTorque(-500.0*(body.getAngle()+random(-1,1)));
  }
}
