
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

PShape mouth;
PShape leftEye; 
PShape rightEye;
PShape leftBro;
PShape rightBro;
float step=0;

void setup() {
  size(640, 480, P2D);
  frameRate(60);
  oscP5 = new OscP5(this, 8338);
  
  // Initialize box2d
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  //To be deleted
  particles = new ArrayList<Particle>();
  face = new Face();
}

void draw() {  
  background(200);
  stroke(0);
  
  // Simulating particles
  if (random(1) < 0.1) {
    float sz = random(4,8);
    particles.add(new Particle(random(250,300),-20,sz));
  }
  box2d.step();
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    if (p.done()) {
      particles.remove(i);
    }
  }
  face.track();
  
  if (face.found > 0) {
    noFill();
    face.eyeRightLocalUpdate();
    face.eyeRightGlobalUpdate();
    rightEye=createShape();
    rightEye.beginShape();
    for(PVector rightEyeVertex :face.geyeR){
      rightEye.vertex(rightEyeVertex.x,rightEyeVertex.y);
    }
    rightEye.endShape(CLOSE);
    shape(rightEye);
    
    face.eyeLeftLocalUpdate();
    face.eyeLeftGlobalUpdate();
    leftEye=createShape();
    leftEye.beginShape();
    for(PVector leftEyeVertex :face.geyeL){
      leftEye.vertex(leftEyeVertex.x,leftEyeVertex.y);
    }
    leftEye.endShape(CLOSE);
    shape(leftEye);
    
    face.eyeBroRightLocalUpdate();
    face.eyeBroRightGlobalUpdate();
    rightBro=createShape();
    rightBro.beginShape();
    for(PVector rightBroVertex : face.geyeBR){
      rightBro.vertex(rightBroVertex.x,rightBroVertex.y);
    }
    rightBro.endShape(CLOSE);
    shape(rightBro);

    face.eyeBroLeftLocalUpdate();
    face.eyeBroLeftGlobalUpdate();
    leftBro=createShape();
    leftBro.beginShape();
    for(PVector leftBroVertex : face.geyeBL){
      leftBro.vertex(leftBroVertex.x,leftBroVertex.y);
    }
    leftBro.endShape(CLOSE);
    shape(leftBro);
    
    
    
    face.mouthLocalUpdate();
    face.mouthGlobalUpdate();
    mouth=createShape();
    mouth.beginShape();
    for(PVector mouthVertex : face.gmouth){
      mouth.vertex(mouthVertex.x,mouthVertex.y);
    }
    mouth.endShape(CLOSE);
    shape(mouth);
    
    face.display();
//    print(face.frame.x+"\t"+face.frame.y+"\t"+face.frame.z+"\n");
//     print(face.toString());
  }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

