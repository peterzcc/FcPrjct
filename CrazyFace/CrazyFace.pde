
import oscP5.*;
OscP5 oscP5;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


Box2DProcessing box2d;

// our FaceOSC tracked face dat
Face face;
ArrayList<Particle> particles;

int score=0;
int HP = 10;
int level = 0;

PShape mouth;
PShape leftEye; 
PShape rightEye;
PShape leftBro;
PShape rightBro;
float step=0;

PImage[] monsterImages;
PImage red;
void setup() {
  size(1024, 768, P2D);
  frameRate(60);
  oscP5 = new OscP5(this, 8338);

  // Initialize box2d
  box2d = new Box2DProcessing(this);

  box2d.createWorld();
  //  box2d.step(1/30.0,8,3);
  box2d.listenForCollisions();
  particles = new ArrayList<Particle>();
  face = new Face();
  monsterImages = readImages("heihei", 12, 30, 0);
  red = loadImage("red.png");
  red.resize(30, 0);
}

void draw() {  

//  println(frameRate );

  level = score/10+1;
  background(200);
  stroke(0);

  // Simulating particles
  if (random(1) < (level*3-2)/100.0) {
    Particle p = new Particle(width+20, random(0+20, height-20), 30);
    p.animation=new Animation(monsterImages, 12);
    particles.add(p);
    p.body.setLinearVelocity(new Vec2(random(-10, -5), random(-5, 5)));
    p.body.setAngularVelocity(random(-1, 1));
  }
  if (random(1) < (level*3-2)/100.0) {
    Particle p = new Particle(-20, random(0+20, height-20), 30);
    p.animation=new Animation(monsterImages, 12);
    particles.add(p);
    p.body.setLinearVelocity(new Vec2(random(5, 10), random(-5, 5)));
    p.body.setAngularVelocity(random(-1, 1));
  }
  box2d.step();



  face.track1();
  face.track2();
  //  if (face.found > 0) {
  noFill();
  
  
  face.eyeRightLocalUpdate();
  face.eyeRightGlobalUpdate();
  face.eyeLeftLocalUpdate();
  face.eyeLeftGlobalUpdate();
  

  rightEye=createShape();
  rightEye.beginShape();
  for (PVector rightEyeVertex : face.geyeR) {
    rightEye.vertex(rightEyeVertex.x, rightEyeVertex.y);
  }
  rightEye.endShape(CLOSE);
  shape(rightEye);

  leftEye=createShape();
  leftEye.beginShape();
  for (PVector leftEyeVertex : face.geyeL) {
    leftEye.vertex(leftEyeVertex.x, leftEyeVertex.y);
  }
  leftEye.endShape(CLOSE);
  shape(leftEye);


  PVector coorL,coorR;
  coorR = PVector.add(face.geyeR[0], face.geyeR[3]);
  coorR.div(2 );
  coorL = PVector.add(face.geyeL[0], face.geyeL[3]);
  coorL.div(2 );
  pushMatrix();
  translate(coorR.x,coorR.y);
  rotate(-face.frame.z);
  ellipse(0,0,face.eyeWidth*3,face.eyeHeight*3);
  popMatrix();
  pushMatrix();
  translate(coorL.x,coorL.y);
  rotate(-face.frame.z);
  ellipse(0,0,face.eyeWidth*3,face.eyeHeight*3);
  popMatrix();

  face.eyeBroRightLocalUpdate();
  face.eyeBroRightGlobalUpdate();
  face.eyeBroLeftLocalUpdate();
  face.eyeBroLeftGlobalUpdate();
  
  /*
  rightBro=createShape();
  rightBro.beginShape();
  for (PVector rightBroVertex : face.geyeBR) {
    rightBro.vertex(rightBroVertex.x, rightBroVertex.y);
  }
  rightBro.endShape(CLOSE);
  shape(rightBro);

  leftBro=createShape();
  leftBro.beginShape();
  for (PVector leftBroVertex : face.geyeBL) {
    leftBro.vertex(leftBroVertex.x, leftBroVertex.y);
  }
  leftBro.endShape(CLOSE);
  shape(leftBro);
  */
  
  

  face.mouthLocalUpdate();
  face.mouthGlobalUpdate();
  
  fill(255, 0, 0);
  mouth=createShape();
  mouth.beginShape();
  for (PVector mouthVertex : face.gmouth) {
     mouth.vertex(mouthVertex.x, mouthVertex.y);
   }
     
   mouth.endShape(CLOSE);
   shape(mouth);
   
  face.display();
  for (int i = particles.size ()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.move(face.eyeLeftPos);
    p.display();
    face.eatCheck(p );
    face.inMouthCheck(p );
    face.inEyesCheck(p );
    if (p.done()) {
      particles.remove(i);
    }
    //     print(face.toString());
  }
  
  fill(0, 0, 255);
  textSize(30 );
  text("Score: "+score, 30, 50);
  text("Level "+level, width/2-50, 50);
  fill(255, 0, 0);
  text("HP: "+ HP, width-200, 50);
  
  //  if (HP<=0) {
  //      fill(255, 0, 0);
  //      rect(0, 0, width, height);
  //      noLoop();
  //    }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

void beginContact(Contact cp) {
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  if ( o2.getClass() == Face.class) {
    Particle p1=(Particle) o1;
    p1.hitted=true;
  } else if (o1.getClass() == Face.class) {
    Particle p2=(Particle) o2;
    p2.hitted=true;
  } else if (o1.getClass()==Particle.class && o2.getClass()==Particle.class) {
    Particle p1=(Particle) o1;
    Particle p2=(Particle) o2;
    if (p1.hitted==true) {
      p1.destroyed=true;
      p2.hitted=true;
    } else 
      if (p2.hitted==true) {
      p2.destroyed = true;
      p1.hitted=true;
    }
  }
}

// Objects stop touching each other
void endContact(Contact cp) {
}
