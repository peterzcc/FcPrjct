
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
  float eyeLength = 2;
  float eyeWidth =1;

  PVector[] eyeL;
  PVector[] eyeR;
  PVector[] mouth = new PVector[8];
  

  
  Face() {
    for(int i=0;i<mouth.length;++i){
      mouth[i] = new PVector();
    }
  }
  
  void updateMouthLocal(){
    float tX=mouthWidth/2;
    float tY=mouthHeight/2;
    mouth[0].x=-tX;mouth[4].x=tX;
    mouth[2].y=-tY;mouth[6].y=tY;
    mouth[1].x=mouth[7].x=-tX/2;mouth[3].x=mouth[5].x=tX/2;
    mouth[1].y=mouth[3].y=-3*tY/4;
    mouth[7].y=mouth[5].y=3*tY/4;
    mouth[0].y=mouth[4].y=mouth[2].x=mouth[6].x=0;
    for(int i =0; i<mouth.length;++i){
      mouth[i].y+=10;
    }
  
  }

  // parse an OSC message from FaceOSC
  // returns true if a message was handled
  boolean parseOSC(OscMessage m) {
    
    if(m.checkAddrPattern("/found")) {
        found = m.get(0).intValue();
        return true;
    }      
          
    // pose
    else if(m.checkAddrPattern("/pose/scale")) {
        poseScale = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/pose/position")) {
        posePosition.x =frame.x= m.get(0).floatValue();
        posePosition.y =frame.y= m.get(1).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/pose/orientation")) {
        poseOrientation.x = m.get(0).floatValue();
        poseOrientation.y = m.get(1).floatValue();
        poseOrientation.z =frame.z= m.get(2).floatValue();
        return true;
    }
    
    // gesture
    else if(m.checkAddrPattern("/gesture/mouth/width")) {
        mouthWidth = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/gesture/mouth/height")) {
        mouthHeight = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/gesture/eye/left")) {
        eyeLeft = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/gesture/eye/right")) {
        eyeRight = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/gesture/eyebrow/left")) {
        eyebrowLeft = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/gesture/eyebrow/right")) {
        eyebrowRight = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/gesture/jaw")) {
        jaw = m.get(0).floatValue();
        return true;
    }
    else if(m.checkAddrPattern("/gesture/nostrils")) {
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
