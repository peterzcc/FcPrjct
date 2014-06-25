class button{
  Body body;
  
  float r;
  
  button(float x, float y, float r_){
    r=r_;
    makeBody(x,y,r);
    body.setUserData(this);
    
  }
  
    void killBody() {
    box2d.destroyBody(body);
  }
  
  boolean done(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y<0|| pos.y > displayHeight || pos.x<0 || pos.x>displayWidth) {
      killBody();   
      mode=1;
     return true; 
  }
  return false;
}

void makeBody(float x, float y ,float r){
   // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    bd.gravityScale=0.0;

    body = box2d.world.createBody(bd);
    
     CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    fd.density = 200.0;
    fd.friction = 0.01;
    fd.restitution = 0.3; // Restitution is bounciness

    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    //body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
//    body.setAngularVelocity(random(-10, 10));
}


void display(){
  
  Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    noFill();
    stroke(0);
    strokeWeight(1);
    
    ellipse(0,0,2*r,2*r);
    line(0,0,r,0);
     fill(0,0,255);

    textSize(30);
    if(mode==0){
    text("Play",0,0);
    }
    else if(mode==3){
      text("Replay",0,0);
    }
    popMatrix();
    done();
}
};
