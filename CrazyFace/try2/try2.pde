import processing.video.*;
Movie cartoon;
void setup(){
  cartoon=new Movie(this,"cartoon1.mov");
  cartoon.loop();
}
void draw(){
  image(cartoon,0,0);
  
}
void movieEvent(Movie m){
  m.read();
}
