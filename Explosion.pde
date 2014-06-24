class Explosion
{
  PImage [] images;
  int currentFrame=0;
  int numFrames=0;
  int index;
  Explosion(PImage[] input,int num){
    numFrames=num;
    images = new PImage[numFrames];
    for (int i=0;i<numFrames;++i){
      images[i]=input[i].get();
    }
  }
  Boolean display(float x,float y){
    if (currentFrame>numFrames-1) return true;
    if (images==null) return false;
    if (images[currentFrame]==null) return false;
    image(images[currentFrame],x,y);
    currentFrame = currentFrame+1;
    return false;
  }
};
