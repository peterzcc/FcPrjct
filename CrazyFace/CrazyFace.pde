
import oscP5.*;
OscP5 oscP5;

// our FaceOSC tracked face dat
Face face = new Face();
PShape mouth;
PShape leftEye; 
PShape rightEye;
PShape leftBro;
PShape rightBro;
float step=0;

void setup() {
  size(640, 480, P2D);
  frameRate(30);

  oscP5 = new OscP5(this, 8338);
}

void draw() {  
  background(200);
  stroke(0);

  if (face.found > 0) {
    // translate(face.posePosition.x, face.posePosition.y);
    // scale(face.poseScale);
    noFill();
  //  ellipse(-20+face.posePosition.x, (face.eyeLeft * -5)+face.posePosition.y, 20, 7);
  //  ellipse(20+face.posePosition.x, (face.eyeRight * -9)+face.posePosition.y, 20, 7);
//    ellipse(0+100, 20+100, face.mouthWidth* 3, face.mouthHeight * 3);
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
    
    /*
    face.eyeBroLeftLocalUpdate();
    face.eyeBroLeftGlobalUpdate();
    leftBro=createShape();
    leftBro.beginShape();
    for(PVector leftBroVertex : face.geyeBL){
      leftBro.vertex(leftBroVertex.x,leftBroVertex.y);
    }
    leftBro.endShape();
    shape(leftBro);
    */
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
     print(mouthVertex.x+"\t"+mouthVertex.y+"\n");
      mouth.vertex(mouthVertex.x,mouthVertex.y);
    }
    mouth.endShape(CLOSE);
    shape(mouth);
   
//    print(face.frame.x+"\t"+face.frame.y+"\t"+face.frame.z+"\n");
//     print(face.toString());
  }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

