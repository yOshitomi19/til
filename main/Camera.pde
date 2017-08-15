class Camera_c{
  PVector pov, pov_ini;  //point of view
  PVector cp,  cp_ini;   //central point
  PVector hae, hae_ini;  //heaven and earth
  
  
  
  Camera_c(PVector point_of_view, PVector central_point, PVector heaven_and_earth){
    pov_ini = point_of_view;
    cp_ini  = central_point;
    hae_ini = heaven_and_earth;
  }
  
  
  //////////////////////////////////////////////////
  //////////     Initialization Camera    //////////
  //////////////////////////////////////////////////
  void Initialization(){
    pov = pov_ini.copy();
    cp  = cp_ini.copy();
    hae = hae_ini.copy();
  }
  
  
  //////////////////////////////////////////////////
  //////////             Move             //////////
  //////////////////////////////////////////////////
  void Move(PVector move){
    pov.add(move);
  }
  
  
  //////////////////////////////////////////////////
  //////////            Camera            //////////
  //////////////////////////////////////////////////
  void Main(PVector point, PVector central){
    camera(  point.x,   -point.y,   point.z,
           central.x, -central.y, central.z,
               hae.x,      hae.y,     hae.z);
  }
  
}