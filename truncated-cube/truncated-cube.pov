//truncated cube  
//Blue gigant spheres together are the truncated cube

//used libraries
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"

//set scenario
camera{
location <5,2,7>   
look_at <0,0,0>}
light_source {
<1000,0, 0>
color	White}
light_source {
<0,1000, -1000>
color	White} 
background { color rgb< 1, 1, 1> }

//truncated cube size
#declare c=2;
#declare a=c*(2+sqrt(2))/sqrt(2);

//conditionals
#declare Dmax=a+0.1;
#declare Dmax1=sqrt(2)*a/(2+sqrt(2))+0.1;

//***************************************************

//arrays for atoms
#declare Pos= array[8];   
#declare Vert=array[24]                                           

//coordinates of cube's vertices
#declare Pos[0]=<a/2,  a/2,  a/2>;
#declare Pos[1]=<-a/2,  -a/2,  -a/2>;
#declare Pos[2]=<-a/2,  -a/2,  a/2>;
#declare Pos[3]=<-a/2,  a/2,  -a/2>;
#declare Pos[4]=<a/2, -a/2,  -a/2>;
#declare Pos[5]=<a/2,  -a/2,  a/2>;
#declare Pos[6]=<-a/2,  a/2,  a/2>;
#declare Pos[7]=<a/2,  a/2,  -a/2>;

//generate cube's vertices
#declare i=0;
#while (i<8)
    sphere {Pos[i], 0.3 pigment{color Red} finish{phong 1}}                
    #declare i=i+1;
#end       

//generate cube's arists
#declare i=0;
#while (i<7)
    #declare j=i+1;
    #while (j<8)    
        #declare DistancesTp=VDist(Pos[i],Pos[j]);  
        #if (DistancesTp<Dmax)
            cylinder {Pos[i], Pos[j], 0.1 pigment{color Blue} finish{phong 1}}   
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end


//generate truncated cube's vertices   
#declare CO=0;
#declare i=0;
#while(i<7) 
    #declare j=i+1;
    #while(j<8)  
        #declare distancia=VDist(Pos[i],Pos[j]); 
        #declare VectorUnion=Pos[j]-Pos[i];  
        //conditional for finding 2 colinear and close points  
        #if(distancia<Dmax)       
            //First point on the arist
            #declare Vert[CO] = Pos[i]+VectorUnion/(2+sqrt(2));              
            sphere{Vert[CO], 0.5 texture{ pigment{color Blue}} finish{phong 1}} 
            #declare CO=CO+1;         
            //second point on the arist
            #declare Vert[CO] = Pos[i]+VectorUnion*(1-1/(2+sqrt(2)));
            sphere{Vert[CO], 0.5 texture{ pigment{color Blue}} finish{phong 1}}  
            #declare CO=CO+1;
        #end
        #declare j=j+1;
    #end 
    #declare i=i+1;
#end 


//generate truncated cube's arists  
#declare i=0;
#while (i<23)
    #declare j=i+1;
    #while (j<24)    
        #declare DistancesTp=VDist(Vert[i],Vert[j]);  
        #if (DistancesTp<Dmax1)
            //Make the arists using the points saved in array Vert
            cylinder {Vert[i], Vert[j], 0.1 pigment{color Green} finish{phong 1}}    
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end


                
              