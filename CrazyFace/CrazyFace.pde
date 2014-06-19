//
// a template for receiving face tracking osc messages from
// Kyle McDonald's FaceOSC https://github.com/kylemcdonald/ofxFaceTracker
//
// this example includes a class to abstract the Face data
//
// 2012 Dan Wilcox danomatika.com
// for the IACD Spring 2012 class at the CMU School of Art
//
// adapted from from Greg Borenstein's 2011 example
// http://www.gregborenstein.com/
// https://gist.github.com/1603230
//
import oscP5.*;
OscP5 oscP5;

// our FaceOSC tracked face dat
Face face = new Face();
PShape mouth;
PShape leftEye; 
PShape rightEye;
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
    ellipse(-20, (face.eyeLeft * -9), 20, 7);
    ellipse(20, (face.eyeRight * -9), 20, 7);
//    ellipse(0+100, 20+100, face.mouthWidth* 3, face.mouthHeight * 3);

    face.mouthLocalUpdate();
    face.mouthGlobalUpdate();
    mouth=createShape();
    mouth.beginShape();
    //mouth.noStroke();
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

