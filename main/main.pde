System_c system;
float framerate = 60;

void setup(){
  size(700, 700, P3D);
  frameRate(framerate);
  
  system = new System_c();
  system.Initialization();
}

void draw(){
  background(255);
  system.Main();
}

void mouseWheel(MouseEvent event){
  system.mouseWheel(event);
}