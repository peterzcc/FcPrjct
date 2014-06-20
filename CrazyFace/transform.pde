/*PVector transform(PVector localPose,PVector coordinate)
{
  PVector globalPose=new PVector();
  float theta=coordinate.z;
  float r=sqrt(coordinate.x*coordinate.x+coordinate.y*coordinate.y);
  float alpha=atan(coordinate.y/coordinate.x);
  globalPose.x=localPose.x+r*cos(alpha+theta);
  globalPose.y=localPose.y+r*sin(alpha+theta);
  return globalPose;
}

void transform(PVector[] localPose,PVector[] globalPose,PVector coordinate)
{
	for(int i=0;i<localPose.length;++i){
	  float theta=coordinate.z;
	  float r=sqrt(coordinate.x*coordinate.x+coordinate.y*coordinate.y);
	  float alpha=atan(coordinate.y/coordinate.x);
	  globalPose[i].x=localPose[i].x+r*cos(alpha+theta);
	  globalPose[i].y=localPose[i].y+r*sin(alpha+theta);
	}
}

*/

PVector transform(PVector localPose,PVector coordinate)
{
  PVector globalPose=new PVector();
  float theta=coordinate.z;
  float r=sqrt(coordinate.x*coordinate.x+coordinate.y*coordinate.y);
  float alpha=atan(coordinate.y/coordinate.x);
  globalPose.x=localPose.x+r*cos(alpha+theta);
  globalPose.y=localPose.y+r*sin(alpha+theta);
  return globalPose;
}

void transform(PVector[] localPose,PVector[] globalPose,PVector coordinate)
{
  float cosTheta = cos(-coordinate.z);
  float sinTheta = sin(-coordinate.z);
  int e=1;
  for(int i=0;i<localPose.length;++i){
    globalPose[i].x=localPose[i].x*e*cosTheta-localPose[i].y*sinTheta+(width-coordinate.x);
    globalPose[i].y=localPose[i].x*e*sinTheta+localPose[i].y*cosTheta+coordinate.y;
  }
}
