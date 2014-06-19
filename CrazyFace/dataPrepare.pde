
PVector[]leftEye(){
PVector[]eyeL=new PVector[3];
eyeL[0]=new PVector(width/8,2*height/6);
eyeL[1]=new PVector(2*width/8,height/6);
eyeL[2]=new PVector(3*width/8,2*height/6);
return eyeL;
}
PVector[]rightEye(){
PVector[]eyeR=new PVector[3];
eyeR[0]=new PVector(5*width/8,2*height/6);
eyeR[1]=new PVector(6*width/8,height/6);
eyeR[2]=new PVector(7*width/8,2*height/6);
return eyeR;

}
PVector[]mouthUp(){
PVector[]M=new PVector[7] ;
M[0]=new PVector(2*width/8,4*height/6);
M[1]=new PVector(3*width/8,(3*height/6)-step);
M[2]=new PVector(4*width/8,(7*height/12)-step);
M[3]=new PVector(5*width/8,(3*height/6)-step);
M[4]=new PVector(6*width/8,4*height/6);
M[5]=new PVector(5*width/8,(4*height/6)-2*step);
M[6]=new PVector(3*width/8,(4*height/6)-2*step);



return M;

}
PVector[]mouthDown(){
PVector[]M=new PVector[7] ;
M[0]=new PVector(2*width/8,4*height/6);
M[1]=new PVector(3*width/8,(5*height/6)+step);
M[2]=new PVector(4*width/8,(9*height/12)+step);
M[3]=new PVector(5*width/8,(5*height/6)+step);
M[4]=new PVector(6*width/8,4*height/6);
M[5]=new PVector(5*width/8,(4*height/6)+2*step);
M[6]=new PVector(3*width/8,(4*height/6)+2*step);


return M;

}





//_________________________________________________________________________


  int inPolyCheck(float x, float y,PVector[] z) {
    float a = 0;
    PVector v = new PVector(x, y);
    for (int i =0; i<z.length-1; i++) {
      PVector v1 = z[i].get();
      PVector v2 = z[i+1].get();
      a += vAtan2cent180(v, v1, v2);
    }
    PVector v1 = z[z.length-1].get();
    PVector v2 = z[0].get();
    a += vAtan2cent180(v, v1, v2);

    if (abs(abs(a) - TWO_PI) < 0.01) return 1;
    else return 0;
  }
float vAtan2cent180(PVector cent, PVector v2, PVector v1) {
    PVector vA = v1.get();
    PVector vB = v2.get();
    vA.sub(cent);
    vB.sub(cent);
    vB.mult(-1);
    float ang = atan2(vB.x, vB.y) - atan2(vA.x, vA.y);
    if (ang < 0) ang = TWO_PI + ang;
    ang-=PI;
    return ang;
  }

