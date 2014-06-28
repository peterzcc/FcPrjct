class Animation
{
  PImage [] images;
  int currentFrame=0;
  int numFrames=0;
  Boolean increase=true;
  
  Animation(PImage[] input,int num){
    numFrames=num;
    images = new PImage[numFrames];
    for (int i=0;i<numFrames;++i){
      images[i]=input[i].get();
    }
  }
  Animation(PImage[] input){
    numFrames=input.length;
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
  void display(Boolean changeframe,Boolean changeDirection){
    if (images==null) return;
    if (images[currentFrame]==null) return;
    image(images[currentFrame],0,0);
    if (changeDirection) increase = !increase;
    if (changeframe)
      currentFrame = (currentFrame+(increase? 1:(numFrames-1))) % numFrames;
  }
};
