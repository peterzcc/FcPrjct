class Worm extends Particle
{
    int w=168;
    int h = 20;
    Worm(float x, float y,float vx,float vy) {
    
    // This function puts the particle in the Box2d world
    makeBody(x, y);
    body.setUserData(this);
    animation=new Animation(wormIm, 1);
    body.setLinearVelocity(new Vec2(vx,vy));
  }

  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    imageMode(CENTER );

    animation.display(0, -2, 0.2);
    
    imageMode(CORNER );
    /*
    noFill();
    stroke(255);
    rectMode(RADIUS);
    rect(0,0,w,h);
    */
    
    popMatrix();
    
  }
  void makeBody(float x, float y) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    bd.gravityScale=0.0;

    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    PolygonShape cs = new PolygonShape();
    box2dw=box2d.scalarPixelsToWorld(w);
    box2dh=box2d.scalarPixelsToWorld(h);
    cs.setAsBox(box2dw, box2dh);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    fd.density = 2.0;
    fd.friction = 0.01;
    fd.restitution = 0.3; // Restitution is bounciness

    body.createFixture(fd);
  }
  
  void adjust(){
    Vec2 v = body.getLinearVelocity();
    float t = getAngle(-v.x,v.y);
    float a = body.getAngle();
    body.setAngularVelocity((-t-a)*9);
  }

}
