class Animation
{
  PImage [] images;
  int currentFrame=0;
  int numFrames=0;
  
  Animation(String prefix, int num,int scaleX,int scaleY){
    numFrames=num;
    images = new PImage[numFrames];
    for (int i=0; i<numFrames;++i){
      String name = prefix+nf(i,4)+".png";
      images[i]= loadImage(name);
      images[i].resize(scaleX,scaleY);
  }
}
  void display(float x,float y,float freq){
    if (images==null) return;
    if (images[currentFrame]==null) return;
    image(images[currentFrame],x,y);
    if (random(1)<time)
      currentFrame = (currentFrame+1) % numFrames;
  }
};
