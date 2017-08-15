class System_c{
  Ball_c[] ball = new Ball_c[1];
  Camera_c cmr;
  Player_c player;
  
  int house_width, house_height;
  float dynamic_friction;
  
  
  int scene;
  final int INITIALIZATION  = 0;
  final int READY           = 1;
  
  
  int N = 0;
  
  
  System_c(){
    
    house_width = 1500;
    house_height = 1500;
    //dynamic_friction = 0.32;  //silver
    dynamic_friction = 0.5;  //sement
    
    //new Ball_c(location, velocity)
    //new Camera_c(point_of_view, central_point, heaven_and_earth)
    
    ball[0] = new Ball_c(new PVector(0, 30, 0), new PVector(0, 5, 0));
    cmr = new Camera_c(new PVector(house_width / 2, house_width / 2, house_width / 2), new PVector(0, 0, 0), new PVector(0, 1, 0));
    
    player = new Player_c();
    
    scene = INITIALIZATION;
  }
  
  
  //////////////////////////////////////////////////
  //////////     Initialization System    //////////
  //////////////////////////////////////////////////
  void Initialization(){
    cmr.Initialization();
    player.Initialization();
    
    scene = READY;
  }
  
  
  //////////////////////////////////////////////////
  //////////             Ready            //////////
  //////////////////////////////////////////////////
  void Ready(){
    player.Update_Throwing();
    
    for(int i = 0; i < N; i++){
      ball[i].Update_Velocity();
      ball[i].Update_Location();
      ball[i].Restitution(house_width, house_height);
      ball[i].Friction(dynamic_friction);
    }
    
    for(int collision_cnt1 = 0; collision_cnt1 < N-1; collision_cnt1++){
      for(int collision_cnt2 = collision_cnt1 + 1; collision_cnt2 < N; collision_cnt2++){
        ball[collision_cnt1].Collision(ball[collision_cnt2].location, ball[collision_cnt2].velocity);
      }
    }
    
    for(int display_cnt = 0; display_cnt < N; display_cnt++){
      ball[display_cnt].Display();
    }
    
    Display(house_width, house_height, true);
    
    
    
    if(keyPressed && keyCode == CONTROL && 0 < N){
      cmr.Main(cmr.pov, ball[N - 1].location);
    }
    else if(keyPressed && keyCode == SHIFT){
      cmr.Main(cmr.pov, new PVector(0, 0, 0));
    }
    else{
      cmr.Main(player.Return_Vector(0.5), player.Return_Vector(1));
    }
    
    if(player.Injection()){
      //ball = new Ball_c(new PVector(0, 10, 0), player.throw_direction);
      ball[N].Initialization();
      ball[N].velocity = player.throw_direction.copy();
      ball = (Ball_c[])append(ball, new Ball_c(new PVector(0, 30, 0), new PVector(0, 5, 0)));
      N++;
    }
    
    if(player.Eliminate_Object()){
      while(0 < N){
        ball = (Ball_c[])shorten(ball);
        N--;
      }
    }
  }
  
  
  //////////////////////////////////////////////////
  //////////             wheel            //////////
  //////////////////////////////////////////////////
  void mouseWheel(MouseEvent event){
    player.mouseWheel(event);
  }
  
  
  //////////////////////////////////////////////////
  //////////            Display           //////////
  //////////////////////////////////////////////////
  void Display(int house_width, int house_height, boolean axis){
    if(axis){
      //stroke(r, g, b);  line(x1, y1, z1, x2, y2, z2);
      stroke(255,   0,   0);  line(-200,    0,    0, 200,   0,   0);  //x-axis
      stroke(  0, 255,   0);  line(   0, -200,    0,   0, 200,   0);  //y-axis 
      stroke(  0,   0, 255);  line(   0,    0, -200,   0,   0, 200);  //z-axis
    }
    
    //floor
    pushMatrix();
    stroke(0);
    fill(175);
    translate(0, -house_height / 2, 0);
    box(house_width, house_height, house_width);
    popMatrix();
    
    player.Display(25, 15);
  }
  
  
  //////////////////////////////////////////////////
  //////////          System Main         //////////
  //////////////////////////////////////////////////
  void Main(){
    switch(scene){
      //scene INITIALIZATION
      case 0:  Initialization();
               break;
               
      //scene READY         
      case 1:  Ready();
               break;
      
      //scene default
      default:  println("Error: System.Main()");
                break;
    }
  }
}