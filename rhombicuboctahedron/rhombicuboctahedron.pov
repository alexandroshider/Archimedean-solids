/*
In this code, a rhombicuboctahedron is modeled.
*/

//Libraries 
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"

//set camera and lights            
camera{
location <2.9,1.25,-1.75>   
look_at <0,-0.25,0>}

light_source {
<1000,0, 0>
color	White}
  
light_source {
<0,1000, -1000>
color	White} 

// Set a color of the background (sky)
background { color rgb< 1, 1, 1> }    


#declare acube=1;               // cube edges length
#declare Pos= array[8];         // cube positions
#declare Rho= array [24];       // Rhombicuboctahedron vertices

// Insert here cube positions given as (±acube/2, ± acube/2, ± acube/2) 
// Calculation of center of cube faces (perpendicular vectors)           

//Cube positions are declared
#declare Pos[0]= <acube/2,    acube/2,  acube/2>;  
#declare Pos[1]= <-acube/2,  -acube/2, -acube/2>;
#declare Pos[2]= <-acube/2,   acube/2,  acube/2>;
#declare Pos[3]= <acube/2,   -acube/2,  acube/2>;
#declare Pos[4]= <acube/2,    acube/2,  -acube/2>;
#declare Pos[5]= <-acube/2,  -acube/2,  acube/2>;
#declare Pos[6]= <-acube/2,   acube/2,  -acube/2>;
#declare Pos[7]= <acube/2,   -acube/2,  -acube/2>;

//limit for find cube's arists
#declare L=acube+0.1;

//Center is array with the vector in the aiming to the center on the cube's faces
#declare Center=array[6];
#declare counter=0;
#declare n=8;
#declare i=1;
#while (i<n)
    #declare L= VDist(Pos[0],Pos[i]);
    #if(L=acube*sqrt(2)  )                                
        #declare Center[counter]= Pos[0]+(Pos[i]-Pos[0])/2;    
        #declare Center[counter+1]= -1*Center[counter];    
        #declare counter=counter+2;      
    #end 
    #declare i=i+1;
#end
          
          
//selecting vertices to translate on each square face    
#declare i=0;
#declare lado= acube*sqrt(2)/2;
#declare coun=0;
#while (i<counter) 
    #declare j=0;
    #while (j<n) 
        #if(VDist(Center[i],Pos[j])= lado)
            #declare Rho[coun]=Pos[j];
            #declare coun=coun+1;
        #end
        #declare j=j+1;
    #end 
    #declare i=i+1; 
#end
   
//Translation of square faces
#declare i=0;
#declare n=24;
#while(i<n)   
    #declare Rho[i]=Rho[i]+ 0.7071*acube *vnormalize((Center[i/4]));  
    #declare Rho[i+1]=Rho[i+1]+0.7071*acube *vnormalize((Center[i/4])); 
    #declare Rho[i+2]=Rho[i+2]+0.7071*acube *vnormalize((Center[i/4])); 
    #declare Rho[i+3]=Rho[i+3]+0.7071*acube *vnormalize((Center[i/4]));    
    #declare i= i+4;   
#end
              
// Drawing the model with spheres
#declare h=pow(10,-3);
#declare i=0;     
#while (i<n-1)                                              
    sphere {Rho[i],0.2 texture { pigment { color Red}  } finish{phong 1} }    
    #declare j=i+1;
    #while(j<n) 
        #if (VDist(Rho[i],Rho[j])<acube+2*h  & VDist(Rho[i],Rho[j])>acube-2*h )
            cylinder {Rho[i], Rho[j], 0.1 texture {pigment { color Yellow }  }finish{phong 1} }  
        #end 
        #declare j=j+1;
    #end 
    #declare i=i+1;
#end  
     
