class Ball_c{
  PVector location, location_ini;
  PVector velocity, velocity_ini;
  float   radius;
  float   restitution;  //coefficient of restitution
  float   vel_th;       //threshold of velocity
  float   friction;

 
  
  Ball_c(PVector loc, PVector vel){
    location_ini = loc;
    velocity_ini = vel;
    radius = 30;
    restitution = 0.6;
    friction = 0.2;
    
    vel_th = 0.001;
  }
  
  
  //////////////////////////////////////////////////
  //////////      Initialization Ball     //////////
  //////////////////////////////////////////////////
  void Initialization(){
    location = location_ini.copy();
    velocity = velocity_ini.copy();
  }
  
  
  //////////////////////////////////////////////////
  //////////         Restitution          //////////
  //////////////////////////////////////////////////
  void Restitution(int house_width, int house_height){
    if(location.x > house_width / 2 - radius){
      //attenuation by restitution
      velocity.x = (abs(velocity.x * -restitution) < vel_th) ? 0 : (velocity.x * -restitution);
      location.x = house_width / 2 - radius;  //location correction
    }
    else if(location.x < -house_width / 2 + radius){
      //attenuation by restitution
      velocity.x = (abs(velocity.x * -restitution) < vel_th) ? 0 : (velocity.x * -restitution);
      location.x = -house_width / 2 + radius;  //location correction
    }
    
    if(location.z > house_width / 2 - radius){
      //attenuation by restitution
      velocity.z = (abs(velocity.z * -restitution) < vel_th) ? 0 : (velocity.z * -restitution);
      location.z = house_width / 2 - radius;  //location correction
    }
    else if(location.z < -house_width / 2 + radius){
      //attenuation by restitution
      velocity.z = (abs(velocity.z * -restitution) < vel_th) ? 0 : (velocity.z * -restitution);
      location.z = -house_width / 2 + radius;  //location correction
    }
    
    if(location.y > house_height - radius){
      //attenuation by restitution
      velocity.y = (abs(velocity.y * -restitution) < vel_th) ? 0 : (velocity.y * -restitution);
      location.y = house_height - radius;  //location correction
    }
    else if(location.y < radius){
      //attenuation by restitution
      velocity.y = (abs(velocity.y * -restitution) < vel_th) ? 0 : (velocity.y * -restitution);
      location.y = radius;  //location correction
    }
  }
  
  
  //////////////////////////////////////////////////
  //////////       frictional force       //////////
  //////////////////////////////////////////////////
  void Friction(float dynamic_friction){
    if(location.y <= radius){
      PVector d_velocity = new PVector(velocity.x, 0, velocity.z);
      d_velocity.setMag(d_velocity.mag() - (dynamic_friction + friction)* 9.8 / framerate);
      
      velocity.x = d_velocity.x;
      velocity.z = d_velocity.z;
      
      location.y = radius;
    }
  }
  
  
  //////////////////////////////////////////////////
  //////////        air resistance        //////////
  //////////////////////////////////////////////////
  /*void Air(){
    //air resistance
    PVector air = new PVector();
    air.setMag((6*PI*(radius/100)*(18.2/1000000)*velocity.mag() + 1.205*PI*(radius/100)*(radius/100)*velocity.mag()*velocity.mag()*(24/(velocity.mag()*1.205*(2*radius)/1.205))/2)/(22.4*1000) / framerate);
    velocity.sub(air);
  }*/
  
  
  //////////////////////////////////////////////////
  //////////        Update Velocity       //////////
  //////////////////////////////////////////////////
  void Update_Velocity(){    
    //acceleration of gravity
    velocity.add(0, -9.8 / framerate, 0);
  }
  
  
  //////////////////////////////////////////////////
  //////////        Update Location       //////////
  //////////////////////////////////////////////////
  void Update_Location(){
    location.add(velocity);
  }
  
  
  //////////////////////////////////////////////////
  //////////           collision          //////////
  //////////////////////////////////////////////////
  void Collision(PVector target_location, PVector target_velocity){
    float between = dist(location.x, location.y, location.z, target_location.x, target_location.y, target_location.z);
    
    if(between < 2 * radius){
      
      PVector direction_vector = new PVector();
      direction_vector = location.copy().sub(target_location).normalize();
      location.add(direction_vector.copy().mult((2 * radius) - between));
      
      PVector normal_vector = new PVector();
      normal_vector = location.copy().add(target_location).normalize();
      
      PVector d_velocity = new PVector();
      d_velocity.x = (normal_vector.x*normal_vector.x*2 - 1)*velocity.x + (normal_vector.x*normal_vector.y*2)*velocity.y     + (normal_vector.z*normal_vector.x*2)*velocity.z;
      d_velocity.y = (normal_vector.x*normal_vector.y*2)*velocity.x     + (normal_vector.y*normal_vector.y*2 - 1)*velocity.y + (normal_vector.y*normal_vector.z*2)*velocity.z;
      d_velocity.z = (normal_vector.z*normal_vector.x*2)*velocity.x     + (normal_vector.y*normal_vector.z*2)*velocity.y     + (normal_vector.z*normal_vector.z*2 - 1)*velocity.z;
      
      PVector d_target_velocity = new PVector();
      d_target_velocity.x = (normal_vector.x*normal_vector.x*2 - 1)*target_velocity.x + (normal_vector.x*normal_vector.y*2)*target_velocity.y     + (normal_vector.z*normal_vector.x*2)*target_velocity.z;
      d_target_velocity.y = (normal_vector.x*normal_vector.y*2)*target_velocity.x     + (normal_vector.y*normal_vector.y*2 - 1)*target_velocity.y + (normal_vector.y*normal_vector.z*2)*target_velocity.z;
      d_target_velocity.z = (normal_vector.z*normal_vector.x*2)*target_velocity.x     + (normal_vector.y*normal_vector.z*2)*target_velocity.y     + (normal_vector.z*normal_vector.z*2 - 1)*target_velocity.z;
      
      velocity = d_target_velocity.copy();
      target_velocity = d_velocity.copy();
    }
  }
  
  
  //////////////////////////////////////////////////
  //////////            Display           //////////
  //////////////////////////////////////////////////
  void Display(){
    pushMatrix();
    translate(location.x, -location.y, location.z);
    stroke(0);
    fill(175);
    sphere(radius);
    popMatrix();
  }
}