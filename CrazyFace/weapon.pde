class Weapon {

  Body body;
  PVector[] trail;
  
 
  Weapon(float x_, float y_,float alpha, float vx, float vy) {
    float x = x_;
    float y = y_;
    trail = new PVector[6];
    for (int i = 0; i < trail.length; i++) {
      trail[i] = new PVector(x,y);
    }
    makeBody(new Vec2(x,y),0.2f);
    body.setLinearVelocity(new Vec2 (vx,vy));
    body.setUserData(this);
    
  }
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);

    // Keep track of a history of screen positions in an array
    for (int i = 0; i < trail.length-1; i++) {
      trail[i] = trail[i+1];
    }
    trail[trail.length-1] = new PVector(pos.x,pos.y);

    // Draw particle as a trail
    beginShape();
    fill(0,255,0);
    strokeWeight(3);
    stroke(0,255,0);
    for (int i = 0; i < trail.length; i++) {
      vertex(trail[i].x,trail[i].y);
    }
    endShape();
  }
  
  void makeBody(Vec2 center, float r) {
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;

    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(random(-1,1),random(-1,1)));

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
  
    fd.density = 0.5;
    fd.friction = 0;  // Slippery when wet!
    fd.restitution = 3;

    // We could use this if we want to turn collisions off
    fd.filter.groupIndex = -10;

    // Attach fixture to body
    body.createFixture(fd);

  }
  /*
  Weapon(float x, float y,float alpha, float vx, float vy) {
    makeBody(x, y,alpha);
    body.setLinearVelocity(new Vec2 (vx,vy));
    body.setUserData(this);
  }
  */
  
 void killBody() {
    box2d.destroyBody(body);
  }
  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height+10*2 || pos.x<-50 || pos.x>width+50) {
      killBody();
      return true;
    }
    return false;
  }

  /*
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
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

  void makeBody(float x, float y,float alpha) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.KINEMATIC;
    bd.gravityScale=0.0;
    bd.angle=alpha;
    body = box2d.world.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(10);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    body.createFixture(fd);
  }
*/


};
