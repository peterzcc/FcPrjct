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
  Explosion explosion;
  Boolean isFirst=true;
  color col;
  Boolean eaten=false;
  Boolean inMouse=false;
  Boolean inEyes = false;
  Boolean hitted=false;
  Boolean destroyed = false;
  Boolean exploded = false;
  Boolean track=false;
  
  float box2dw=15;
  float box2dh=18;
  Particle(){
  }
  Particle(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x, y, r);
    body.setUserData(this);
    animation=new Animation(monsterImages, 12);
    explosion=new Explosion(explosionImages, 26);
    track = random(1)<level/5.0;
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
    if (pos.y > height+r*2 || pos.x<-50 || pos.x>width+50 
          || eaten
          || inEyes
          ||exploded) {
      if (eaten||exploded) ++score;
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
    noFill();
    stroke(0);
    strokeWeight(1);
    
    float w = box2d.scalarWorldToPixels(box2dw*2);
    float h = box2d.scalarWorldToPixels(box2dh*2);
    
    if (hitted)
    {
      if (destroyed){
        exploded=explosion.display(-40,-40);
      }
      else image(red, -w/2,-h/2-5);
    } 
    else {
      animation.display(-w/2,-h/2-5, 0.2);
    }
//    stroke(255);
//    rectMode(CENTER);
//    rect(0,0,w,h);
    popMatrix();
  }

  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    bd.gravityScale=0.0;

    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    PolygonShape cs = new PolygonShape();
    box2dw=box2d.scalarPixelsToWorld(0.5*r);
    box2dh=box2d.scalarPixelsToWorld(0.6*r);
    cs.setAsBox(box2dw, box2dh);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    fd.density = 2.0;
    fd.friction = 0.01;
    fd.restitution = 0.3; // Restitution is bounciness

    body.createFixture(fd);

  }

  void move(Vec2 target) {
    if (random(1)<0.05) {
      Vec2 noise = new Vec2(random(-0.5, 0.5), random(-4, 4));
      body.setLinearVelocity(noise.add(body.getLinearVelocity()));
    }
    Vec2 diff = target.sub(body.getWorldCenter());
    float len=diff.lengthSquared();
    if (body.getAngle()<PI/2 && body.getAngle()>-PI/2 )
      body.applyTorque(-500.0*(body.getAngle()+random(-1, 1)));
    if (diff.y<-1) return;
    if (track && len < 800) {
      Vec2 noise = new Vec2(random(-0.5, 0.5), random(-6, 6));
      if (len<100) {
        body.applyForceToCenter((diff.mul(200.0).add(noise)).sub(body.getLinearVelocity()));
      } else {
        body.setLinearVelocity(diff.mul(300.0/len).add(noise));
      }
    }
  }
};
