
import oscP5.*;

// a single tracked face from FaceOSC
class Face {

  // num faces found
  int found;

  // pose
  float poseScale;
  PVector posePosition = new PVector();
  PVector poseOrientation = new PVector();

  PVector frame=new PVector();
  // gesture
  float mouthHeight=0;
  float mouthWidth=0;
  float eyeLeft=0;
  float eyeRight=0;
  float eyebrowLeft=0;
  float eyebrowRight=0;
  float jaw=0;
  float nostrils=0;

  //face model
  float eyeX =20;
  float eyeLY;
  float eyeRY;
  float mouthY=10;
  float eyeHeight = 5;
  float eyeWidth =4*eyeHeight;
  float eyebroHeight=3;
  float eyebroWidth=10;

  //Local positions
  PVector[] eyeL =new PVector[6];
  PVector[] eyeR =new PVector[6];
  PVector[] mouth = new PVector[8];
  PVector[] eyeBR= new PVector[5];
  PVector[] eyeBL= new PVector[5];
  //Global positions
  PVector[] gmouth = new PVector[8];
  PVector[] geyeL =new PVector[6];
  PVector[] geyeR =new PVector[6];
  PVector[] geyeBR= new PVector[5];
  PVector[] geyeBL= new PVector[5];  
  
  PVector coorL,coorR;
  PVector geyeBRCenter = new PVector();
  PVector geyeBLCenter = new PVector();
  Body beyeBR;
  Body beyeBL;

  Vec2 eyeLeftPos = new Vec2();
  
  Face() {
    for (int i=0; i<mouth.length; ++i) {
      mouth[i] = new PVector();
      gmouth[i] = new PVector();
    }
    for (int i=0; i<eyeL.length; ++i) {
      eyeL[i]=new PVector();
      geyeL[i]=new PVector();
      eyeR[i]=new PVector();
      geyeR[i]=new PVector();
    }
    for (int i=0; i<eyeBL.length; ++i) {
      eyeBR[i]=new PVector();
      eyeBL[i]=new PVector();
      geyeBL[i]=new PVector();
      geyeBR[i]=new PVector();
    }
    makeBodyR();
    makeBodyL();
  }

  void mouthLocalUpdate() {
    float tX=mouthWidth/2;
    float tY=mouthHeight/2;
    mouth[0].x=-tX;
    mouth[4].x=tX;
    mouth[2].y=-tY;
    mouth[6].y=tY;
    mouth[1].x=mouth[7].x=-tX/2;
    mouth[3].x=mouth[5].x=tX/2;
    mouth[1].y=mouth[3].y=-3*tY/4;
    mouth[7].y=mouth[5].y=3*tY/4;
    mouth[0].y=mouth[4].y=mouth[2].x=mouth[6].x=0;
//    println(mouthHeight );
    for (int i =0; i<mouth.length; ++i) {
      mouth[i].mult(sqrt(mouthHeight*6));
      mouth[i].y+=mouthY;
      mouth[i].mult(4);
    }
  }
  void eyeRightLocalUpdate() {
    eyeR[0].x=-eyeWidth/2; 
    eyeR[0].y=0;
    eyeR[1].x=-eyeWidth/4; 
    eyeR[1].y=-eyeHeight;
    eyeR[2].x=eyeWidth/4;
    eyeR[2].y=-eyeHeight;
    eyeR[3].x=eyeWidth/2; 
    eyeR[3].y=0;
    eyeR[4].x=eyeWidth/4; 
    eyeR[4].y=eyeHeight;
    eyeR[5].x=-eyeWidth/4; 
    eyeR[5].y=eyeHeight;

    for (int i=0; i<eyeR.length; ++i) {
      eyeR[i].x+=20;
      eyeR[i].y-=eyeRight*9;
      eyeR[i].mult(4);
    }
  }

  void eyeLeftLocalUpdate() {
    eyeL[0].x=-eyeWidth/2; 
    eyeL[0].y=0;
    eyeL[1].x=-eyeWidth/4; 
    eyeL[1].y=-eyeHeight;
    eyeL[2].x=eyeWidth/4;
    eyeL[2].y=-eyeHeight;
    eyeL[3].x=eyeWidth/2; 
    eyeL[3].y=0;
    eyeL[4].x=eyeWidth/4; 
    eyeL[4].y=eyeHeight;
    eyeL[5].x=-eyeWidth/4; 
    eyeL[5].y=eyeHeight;

    for (int i=0; i<eyeR.length; ++i) {
      eyeL[i].x-=20;
      eyeL[i].y-=eyeLeft*9;
      eyeL[i].mult(4);
    }
  }

  void eyeBroLeftLocalUpdate() {
    eyeBL[0].x=-eyebroWidth;
    eyeBL[0].y=0;
    eyeBL[1].x=-eyebroWidth*0.717;
    eyeBL[1].y=-eyebroHeight*0.717;
    eyeBL[2].x=0;
    eyeBL[2].y=-eyebroHeight;
    eyeBL[3].x=eyebroWidth*0.717;
    eyeBL[3].y=-eyebroHeight*0.717;
    eyeBL[4].x=eyebroWidth;
    eyeBL[4].y=0;

    for (int i=0; i<eyeBL.length; ++i)
    {
      eyeBL[i].x-=20;
      eyeBL[i].y-=eyebrowLeft*6;
      eyeBL[i].mult(4);
    }
  }

  void eyeBroRightLocalUpdate() {
    eyeBR[0].x=-eyebroWidth;
    eyeBR[0].y=0;
    eyeBR[1].x=-eyebroWidth*0.717;
    eyeBR[1].y=-eyebroHeight*0.717;
    eyeBR[2].x=0;
    eyeBR[2].y=-eyebroHeight;
    eyeBR[3].x=eyebroWidth*0.717;
    eyeBR[3].y=-eyebroHeight*0.717;
    eyeBR[4].x=eyebroWidth;
    eyeBR[4].y=0;


    for (int i=0; i<eyeBR.length; ++i)
    {
      eyeBR[i].x+=20;
      eyeBR[i].y-=eyebrowRight*6;
      eyeBR[i].mult(4);
    }
  }

  void mouthGlobalUpdate() {
    transform(mouth, gmouth, frame);
  }

  void eyeRightGlobalUpdate() {
    transform(eyeR, geyeR, frame);
    coorR = PVector.add(geyeR[0], geyeR[3]);
    coorR.div(2 );
  }

  void eyeLeftGlobalUpdate() {
    transform(eyeL, geyeL, frame);
    coorL = PVector.add(geyeL[0], geyeL[3]);
    coorL.div(2 );
    eyeLeftPos = box2d.coordPixelsToWorld(coorL.x, coorL.y);
  }

  void eyeBroLeftGlobalUpdate() {
    transform(eyeBL, geyeBL, frame);
  }
  void eyeBroRightGlobalUpdate() {
    transform(eyeBR, geyeBR, frame);
  }
void update(){
  eyeRightLocalUpdate();
  eyeRightGlobalUpdate();
  eyeLeftLocalUpdate();
  eyeLeftGlobalUpdate();
  eyeBroRightLocalUpdate();
  eyeBroRightGlobalUpdate();
  eyeBroLeftLocalUpdate();
  eyeBroLeftGlobalUpdate();
  mouthLocalUpdate();
  mouthGlobalUpdate();
}

  void makeBodyR() {

    BodyDef beyeBRdef = new BodyDef();
    beyeBRdef.position = box2d.coordPixelsToWorld(width, height);
    beyeBRdef.type = BodyType.KINEMATIC;
    beyeBRdef.bullet=true;
    beyeBR = box2d.world.createBody(beyeBRdef);

    // CircleShape cs = new CircleShape();
    //cs.m_radius = box2d.scalarPixelsToWorld(20);

    PolygonShape sd= new PolygonShape();
    Vec2[] vertices=new Vec2[5];
    vertices[0]=box2d.vectorPixelsToWorld(new Vec2(-eyebroWidth/2, 0));
    vertices[1]=box2d.vectorPixelsToWorld(new Vec2(-eyebroWidth*0.717, -eyebroHeight*0.717));
    vertices[2]=box2d.vectorPixelsToWorld(new Vec2(0, -eyebroHeight));
    vertices[3]=box2d.vectorPixelsToWorld(new Vec2(eyebroWidth*0.717, -eyebroHeight*0.717));
    vertices[4]=box2d.vectorPixelsToWorld(new Vec2(eyebroWidth/2, 0));
    for (int i=0; i<vertices.length; ++i) {
      vertices[i].mulLocal(2);
    }
    sd.set(vertices, vertices.length);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 10.0;
    beyeBR.createFixture(fd);
    beyeBR.setUserData(this);
  }

  void makeBodyL() {

    BodyDef beyeBLdef = new BodyDef();
    beyeBLdef.position = box2d.coordPixelsToWorld(width, height);
    beyeBLdef.type = BodyType.KINEMATIC;
    beyeBLdef.bullet=true;
    beyeBL = box2d.world.createBody(beyeBLdef);

    // CircleShape cs = new CircleShape();
    //cs.m_radius = box2d.scalarPixelsToWorld(20);

    PolygonShape sd= new PolygonShape();
    Vec2[] vertices=new Vec2[5];
    vertices[0]=box2d.vectorPixelsToWorld(new Vec2(-eyebroWidth/2, 0));
    vertices[1]=box2d.vectorPixelsToWorld(new Vec2(-eyebroWidth*0.717, -eyebroHeight*0.717));
    vertices[2]=box2d.vectorPixelsToWorld(new Vec2(0, -eyebroHeight));
    vertices[3]=box2d.vectorPixelsToWorld(new Vec2(eyebroWidth*0.717, -eyebroHeight*0.717));
    vertices[4]=box2d.vectorPixelsToWorld(new Vec2(eyebroWidth/2, 0));
    for (int i=0; i<vertices.length; ++i) {
      vertices[i].mulLocal(2);
    }
    sd.set(vertices, vertices.length);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 10.0;
    beyeBL.createFixture(fd);
    beyeBL.setUserData(this);
  }


  void display() {
  
  Vec2 posBR = box2d.getBodyPixelCoord(beyeBR);
  noFill();
  float a = beyeBR.getAngle();
  pushMatrix();
  translate(posBR.x, posBR.y-5);
  rotate(-a);
 // fill(color(255, 0, 0));
  stroke(0);
  strokeWeight(1);
  rectMode(CENTER);
  rect(0,0,7*eyebroWidth,4*eyebroHeight);


  popMatrix();
  Vec2 posBL=box2d.getBodyPixelCoord(beyeBL);
  noFill();
  pushMatrix();
  translate(posBL.x,posBL.y-5);
  rotate(-a);
  stroke(0);
  strokeWeight(1);
  rectMode(CENTER);
  rect(0,0,7*eyebroWidth,4*eyebroHeight);
  popMatrix();

  pushMatrix();
  translate(coorR.x,coorR.y);
  rotate(-frame.z);
  ellipse(0,0,eyeWidth*3,eyeHeight*3);
  popMatrix();

  pushMatrix();
  translate(coorL.x,coorL.y);
  rotate(-frame.z);
  ellipse(0,0,eyeWidth*3,eyeHeight*3);
  popMatrix();

  fill(255, 0, 0);
  mouthDraw=createShape();
  mouthDraw.beginShape();
  for (PVector mouthVertex : gmouth) {
     mouthDraw.vertex(mouthVertex.x, mouthVertex.y);
   }
     
  mouthDraw.endShape(CLOSE);
  shape(mouthDraw);

}


  void track1() {
    geyeBRCenter = PVector.add(geyeBR[0], geyeBR[4]);
    geyeBRCenter.div(2);
    Vec2 pos = beyeBR.getWorldCenter();
    Vec2 target = box2d.coordPixelsToWorld(geyeBRCenter.x, geyeBRCenter.y);
    Vec2 diff = target.sub(pos);
    diff.mulLocal(80);
    beyeBR.setLinearVelocity(diff);
    float omega = frame.z-beyeBR.getAngle();
    beyeBR.setAngularVelocity(omega*20);
  }
  void track2() {
    geyeBLCenter = PVector.add(geyeBL[0], geyeBL[4]);
    geyeBLCenter.div(2);
    Vec2 pos = beyeBL.getWorldCenter();
    Vec2 target = box2d.coordPixelsToWorld(geyeBLCenter.x, geyeBLCenter.y);
    Vec2 diff = target.sub(pos);
    diff.mulLocal(80);
    beyeBL.setLinearVelocity(diff);
    float omega = frame.z-beyeBL.getAngle();
    beyeBL.setAngularVelocity(omega*20);
  }

  void eatCheck(Particle p) {
    if (p.inMouse) {
      Vec2 pos = box2d.getBodyPixelCoord(p.body);
      p.eaten = !inPolyCheck(pos.x, pos.y, gmouth);
    }
  }


  void inMouthCheck(Particle p) {
    if (!p.inMouse) {
      Vec2 pos = box2d.getBodyPixelCoord(p.body);
      p.inMouse = inPolyCheck(pos.x, pos.y, gmouth);
    }
  }

  void inEyesCheck(Particle p){
    Vec2 pos = box2d.getBodyPixelCoord(p.body);
    if (inPolyCheck(pos.x, pos.y, geyeL)||
    inPolyCheck(pos.x, pos.y, geyeR)){
      p.inEyes=true;
      --HP;
    }
  }

  // parse an OSC message from FaceOSC
  // returns true if a message was handled
  boolean parseOSC(OscMessage m) {

    if (m.checkAddrPattern("/found")) {
      found = m.get(0).intValue();
      return true;
    }      

    // pose
    else if (m.checkAddrPattern("/pose/scale")) {
      poseScale = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/pose/position")) {
      posePosition.x =frame.x= m.get(0).floatValue();
      posePosition.y =frame.y= m.get(1).floatValue();
      return true;
    } else if (m.checkAddrPattern("/pose/orientation")) {
      poseOrientation.x = m.get(0).floatValue();
      poseOrientation.y = m.get(1).floatValue();
      poseOrientation.z =frame.z= m.get(2).floatValue();
      return true;
    }

    // gesture
    else if (m.checkAddrPattern("/gesture/mouth/width")) {
      mouthWidth = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/mouth/height")) {
      mouthHeight = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eye/left")) {
      eyeLeft = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eye/right")) {
      eyeRight = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eyebrow/left")) {
      eyebrowLeft = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/eyebrow/right")) {
      eyebrowRight = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/jaw")) {
      jaw = m.get(0).floatValue();
      return true;
    } else if (m.checkAddrPattern("/gesture/nostrils")) {
      nostrils = m.get(0).floatValue();
      return true;
    }

    return false;
  }

  // get the current face values as a string (includes end lines)
  String toString() {
    return "found: " + found + "\n"
      + "pose" + "\n"
      + " scale: " + poseScale + "\n"
      + " position: " + posePosition.toString() + "\n"
      + " orientation: " + poseOrientation.toString() + "\n"
      + "gesture" + "\n"
      + " mouth: " + mouthWidth + " " + mouthHeight + "\n"
      + " eye: " + eyeLeft + " " + eyeRight + "\n"
      + " eyebrow: " + eyebrowLeft + " " + eyebrowRight + "\n"
      + " jaw: " + jaw + "\n"
      + " nostrils: " + nostrils + "\n";
  }
};
