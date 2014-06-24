class Dog extends Particle
{
  
  int w1,h1,w2,h2,w3,h3;
  Dog(float x, float y,float vx,float vy) {
    w1=44;h1=30;
    makeBody(x, y);
    body.setUserData(this);
    animation=new Animation(dogIm);
    body.setLinearVelocity(new Vec2(vx,vy));
    
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    imageMode(CENTER );

    animation.display(0, -2, 0.2);
    
    imageMode(CORNER );
    
    noFill();
    stroke(0);
    rectMode(RADIUS);
    rect(0,0,w1,h1);
    
    
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
    PolygonShape s1 = new PolygonShape();
    float bw1=box2d.scalarPixelsToWorld(w1);
    float bh1=box2d.scalarPixelsToWorld(h1);
    s1.setAsBox(bw1, bh1);
    
    body.createFixture(s1,2.0);
    
    
  }
  
  void adjust(){
    /*
    Vec2 v = body.getLinearVelocity();
    float t = getAngle(-v.x,v.y);
    float a = body.getAngle();
    body.setAngularVelocity((-t-a)*9);
    */
  }
};
