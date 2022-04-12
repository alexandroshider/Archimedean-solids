/*
This programe makes a cuboctahedron inside a cube.
*/

//used libraries
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"

//set camera and background
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


//lenght of the bonds 
//cube vertices
#declare acube=2;                //cube edges length            
#declare Dmax=acube+0.1;
      

#declare Pos= array[8];         // cube positions
#declare PosCuboc= array [12]; // cuboctahedron vertices

// Cube positions
// first and second verticess are related by an inversion center
#declare Pos[0]= <acube/2,    acube/2,  acube/2>;  
#declare Pos[1]= <-acube/2,  -acube/2, -acube/2>;
#declare Pos[2]= <-acube/2,   acube/2,  acube/2>;
#declare Pos[3]= <acube/2,   -acube/2,  acube/2>;
#declare Pos[4]= <acube/2,    acube/2,  -acube/2>;
#declare Pos[5]= <-acube/2,  -acube/2,  acube/2>;
#declare Pos[6]= <-acube/2,   acube/2,  -acube/2>;
#declare Pos[7]= <acube/2,   -acube/2,  -acube/2>;


//generate the cube                                        
#declare i=0;
#while (i<8)
 sphere {Pos[i], 0.1 pigment{color Blue} finish{phong 1}} 
 #declare i=i+1;
#end             


//cube's arists and their middle points   
#declare h=0; 
#declare i=0;              
#while(i<7) 
    #declare j=i+1;
    #while(j<8)  
        #declare dist=VDist(Pos[i],Pos[j]); 
        #declare VecUnion=Pos[j]-Pos[i];
        #if(dist<Dmax)
            #declare k=1;
            #while (k<2)
                //middle point in cube's arist (cuboctaedron vertices)
                #declare PosCuboc[h] = Pos[i]+VecUnion*k/2;   
                sphere{PosCuboc[h], 0.1 texture{pigment {color Red}} finish{phong 1}}                       
                #declare h=h+1;
                #declare k=k+1;
            #end
            cylinder{Pos[i],Pos[j],0.05 texture {pigment {color Green}} finish{phong 1}} //Cube arists 
        #end
        #declare j=j+1;
    #end 
    #declare i=i+1;
#end


//cuboctaedron's arists using cylinders
#declare i=0;        
#while(i<11)
    #declare j=i+1; 
    #while(j<12)
        #declare distan=VDist(PosCuboc[i],PosCuboc[j]); 
        #if(distan<acube*sqrt(2)/2+.1)
            cylinder{PosCuboc[i],PosCuboc[j], 0.05 texture {pigment {color Green}} finish{phong 1}}         
        #end  
        #declare j=j+1;     
    #end  
    #declare i=i+1;   
#end        
                    
                    