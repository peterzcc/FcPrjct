
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
    ellipse(-20+face.posePosition.x, (face.eyeLeft * -9)+face.posePosition.y, 20, 7);
    ellipse(20+face.posePosition.x, (face.eyeRight * -9)+face.posePosition.y, 20, 7);
//    ellipse(0+100, 20+100, face.mouthWidth* 3, face.mouthHeight * 3);

    face.mouthLocalUpdate();
    face.scaleUpdate();
    face.mouthGlobalUpdate();
    mouth=createShape();
    mouth.beginShape();
    for(PVector mouthVertex : face.gmouth){
     print(mouthVertex.x+"\t"+mouthVertex.y+"\n");
      mouth.vertex(mouthVertex.x,mouthVertex.y);
    }
    mouth.endShape(CLOSE);
    shape(mouth);
    if (inPolyCheck(mouseX, mouseY,face.gmouth)==1){
      stroke(255, 0, 0);
      ellipse(mouseX, mouseY, 50, 50);
    }

//     print(face.toString());
  }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

