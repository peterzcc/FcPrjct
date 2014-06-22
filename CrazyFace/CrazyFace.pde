
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
PShape mouth;
PShape leftEye; 
PShape rightEye;
PShape leftBro;
PShape rightBro;
float step=0;

PImage[] monsterImages;

void setup() {
  size(1024, 768, P2D);
  frameRate(30);
  oscP5 = new OscP5(this, 8338);

  // Initialize box2d
  box2d = new Box2DProcessing(this);
  
  box2d.createWorld();
//  box2d.step(1/30.0,8,3);
  //To be deleted
  particles = new ArrayList<Particle>();
  face = new Face();
  monsterImages = readImages("heihei", 12, 30, 0);
}

void draw() {  
  background(200);
  stroke(0);
  fill(0,0,255);
  textSize(30 );
  text("Score: "+score,30,50);
  // Simulating particles
  if (random(1) < 1/100.0) {
    Particle p = new Particle(random(0+20, width-20), -20, 30);
    p.animation=new Animation(monsterImages, 12);
    particles.add(p);
  }
  box2d.step();



  face.track1();
  face.track2();
  // scale(2);
  if (face.found > 0) {
    noFill();
    face.eyeRightLocalUpdate();
    face.eyeRightGlobalUpdate();
    rightEye=createShape();
    rightEye.beginShape();
    for (PVector rightEyeVertex : face.geyeR) {
      rightEye.vertex(rightEyeVertex.x, rightEyeVertex.y);
    }

    rightEye.endShape(CLOSE);
    //  rightEye.scale(3);
    //shape(rightEye);
    shape(rightEye);

    face.eyeLeftLocalUpdate();
    face.eyeLeftGlobalUpdate();
    leftEye=createShape();
    leftEye.beginShape();
    for (PVector leftEyeVertex : face.geyeL) {
      leftEye.vertex(leftEyeVertex.x, leftEyeVertex.y);
    }
    leftEye.endShape(CLOSE);
    shape(leftEye);

    face.eyeBroRightLocalUpdate();
    face.eyeBroRightGlobalUpdate();
    rightBro=createShape();
    rightBro.beginShape();
    for (PVector rightBroVertex : face.geyeBR) {
      rightBro.vertex(rightBroVertex.x, rightBroVertex.y);
    }
    rightBro.endShape(CLOSE);
    shape(rightBro);

    face.eyeBroLeftLocalUpdate();
    face.eyeBroLeftGlobalUpdate();
    leftBro=createShape();
    leftBro.beginShape();
    for (PVector leftBroVertex : face.geyeBL) {
      leftBro.vertex(leftBroVertex.x, leftBroVertex.y);
    }
    leftBro.endShape(CLOSE);
    shape(leftBro);



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
  }
  for (int i = particles.size ()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.move(face.eyeLeftPos);
    p.display();
    face.eatCheck(p );
    face.inMouthCheck(p );
    if (p.done()) {
      particles.remove(i);
    }
    //     print(face.toString());
  }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}
