class Animation
{
  PImage [] images;
  int currentFrame=0;
  int numFrames=0;

  Animation(PImage[] input,int num){
    numFrames=num;
    images = new PImage[numFrames];
    for (int i=0;i<numFrames;++i){
      images[i]=input[i].get();
    }
  }
  void display(float x,float y,float freq){
    if (images==null) return;
    if (images[currentFrame]==null) return;
    image(images[currentFrame],x,y);
    if (random(1)<freq)
      currentFrame = (currentFrame+1) % numFrames;
  }
};
