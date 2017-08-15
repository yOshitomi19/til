class Player_c{
  PVector throw_direction, throw_direction_ini;  //direction of throwing(vel0)
  PVector mouse;
  boolean mouse_cnt = true;
  
  
  
  Player_c(){
    throw_direction_ini = new PVector(0, 0, -25);
    mouse = new PVector(width / 2, height / 2);
  }
  
  
  //////////////////////////////////////////////////
  //////////     Initialization Player    //////////
  //////////////////////////////////////////////////
  void Initialization(){
    throw_direction = throw_direction_ini.copy();
  }
  
  
  //////////////////////////////////////////////////
  //////////           Injection          //////////
  //////////////////////////////////////////////////
  boolean Injection(){
    
    if(mousePressed){
      if(mouse_cnt && mouseButton == LEFT){
        mouse_cnt = false;
        return true;
      }
    }
    else if(!mouse_cnt){
      mouse_cnt = true;
    }
    
    return false;
  }
  
  
  //////////////////////////////////////////////////
  //////////        eliminate object      //////////
  //////////////////////////////////////////////////
  boolean Eliminate_Object(){
    if(mousePressed){
      if(mouse_cnt && mouseButton == RIGHT){
        mouse_cnt = false;
        return true;
      }
    }
    else if(!mouse_cnt){
      mouse_cnt = true;
    }
    
    return false;
  }
  
  
  //////////////////////////////////////////////////
  //////////         return vector        //////////
  //////////////////////////////////////////////////
  PVector Return_Vector(float range){
    PVector vector = new PVector();
    vector = throw_direction.copy();
    vector.normalize();
    vector.mult(range);
    return vector.copy();
  }
  
  
  //////////////////////////////////////////////////
  //////////        Update throwing       //////////
  //////////////////////////////////////////////////
  void Update_Throwing(){
    
    if(mouse.x != mouseX || mouse.y != mouseY){
      
      PVector d_throw_direction = new PVector();
      float alpha = 0.0;
      float beta  = 0.0;
      
      
      alpha = (mouse.y < mouseY) ? -radians(1) : radians(1);
      beta  = (mouse.x < mouseX) ? -radians(1) : radians(1);
      
      
      if((throw_direction.x < 0 && 0 < throw_direction.z && 0.0 < beta) || (0 < throw_direction.x && 0 < throw_direction.z && beta < 0.0))
        beta = 0.0;      
        
      if((throw_direction.y < 0 && alpha < 0.0) || (0.0 < throw_direction.z && 0.0 < alpha))
        alpha = 0.0;
      
      
      //coordinate transformation
      //around X axis
      d_throw_direction.x = throw_direction.x;
      d_throw_direction.y = cos(alpha)*throw_direction.y - sin(alpha)*throw_direction.z;
      d_throw_direction.z = sin(alpha)*throw_direction.y + cos(alpha)*throw_direction.z;
      //around Y axis
      throw_direction.x = cos(beta)*d_throw_direction.x + sin(beta)*d_throw_direction.z;
      throw_direction.y = d_throw_direction.y;
      throw_direction.z = -sin(beta)*d_throw_direction.x + cos(beta)*d_throw_direction.z;
      
      
      //update mouse location
      mouse.x = mouseX;
      mouse.y = mouseY;
      
      //println(throw_direction.x, throw_direction.y, throw_direction.z, alpha, beta);
    }
  }
  
  
  //////////////////////////////////////////////////
  //////////             wheel            //////////
  //////////////////////////////////////////////////
  void mouseWheel(MouseEvent event){
    float wheel = (event.getAmount() == 1) ? -1 : 1;
    
    if(!(throw_direction.mag() <= 1 && wheel == -1)){
      throw_direction.setMag(throw_direction.mag() + wheel);
    }
    
  }
  
  
  //////////////////////////////////////////////////
  //////////            Display           //////////
  //////////////////////////////////////////////////
  void Display(int size, int range){
    pushMatrix();
    translate(throw_direction.x * range, -throw_direction.y * range, throw_direction.z * range);
    //stroke(r, g, b);  line(x1, y1, z1, x2, y2, z2);
    stroke(255,   0,   0);  line(-size,     0,     0, size,    0,    0);  //x-axis
    stroke(  0, 255,   0);  line(    0, -size,     0,    0, size,    0);  //y-axis 
    stroke(  0,   0, 255);  line(    0,     0, -size,    0,    0, size);  //z-axis
    popMatrix();
    
    
    //stroke(0); line(0, 0, 0, throw_direction.x * range, -throw_direction.y * range, throw_direction.z * range);
  }
}