class Dog extends Particle
{
  
  int w1,h1,w2,h2,w3,h3;
  Dog(float x, float y,float vx,float vy) {
    w1=57;h1=69;w2=9;h2=34;w3 = 33;h3=17;
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

    animation.display(-22, 19, 0.05);
    
    imageMode(CORNER );
    /*
    noFill();
    stroke(0);
    rectMode(RADIUS);
    rect(0,0,w1,h1);
    rect(-31,91,w2,h2);
    rect(48,87,w2,h2);
    rect(-88,23,w3,h3);
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
    PolygonShape s1 = new PolygonShape();
    float bw1=box2d.scalarPixelsToWorld(w1);
    float bh1=box2d.scalarPixelsToWorld(h1);
    s1.setAsBox(bw1, bh1);
    
    float bw2=box2d.scalarPixelsToWorld(w2);
    float bh2=box2d.scalarPixelsToWorld(h2);
    Vec2 center = box2d.vectorPixelsToWorld(-31,91);
    PolygonShape s2 = new PolygonShape();
    s2.setAsBox(bw2, bh2,center,0);
    
    Vec2 center2 = box2d.vectorPixelsToWorld(48,87);
    PolygonShape s2r = new PolygonShape();
    s2r.setAsBox(bw2, bh2,center2,0);
    
    float bw3=box2d.scalarPixelsToWorld(w3);
    float bh3=box2d.scalarPixelsToWorld(h3);
    Vec2 center3 = box2d.vectorPixelsToWorld(-88,23);
    PolygonShape s3 = new PolygonShape();
    s3.setAsBox(bw3, bh3,center3,0);
    
    body.createFixture(s1,2.0);
    body.createFixture(s2,2.0);
    body.createFixture(s2r,2.0);
    body.createFixture(s3,2.0);
    
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
