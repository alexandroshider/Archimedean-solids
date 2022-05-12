// Libraries containing color, texture, vector operations
#include "colors.inc"
#include "shapes.inc"
#include "math.inc"
                   
                   
light_source {
<-50,-50,-50>
color	White}
  
light_source {
<0,1000, -1000>
color	White} 

// Set a color of the background (sky)
//Scenario definition
camera {location <-7,-7,-7> look_at <0,0,0>}
background{color White}
light_source{<1000,1000,-1000> color White}

//Macro to print spheres in arrays
#macro PrintSphere (Final,Arr,Radio,Kolor)
 #declare i=0;
 #while (i<Final)  
  sphere{Arr[i],Radio texture {pigment{color Kolor}} finish{phong 1}}
  #declare i=i+1; 
 #end 
#end 

//Macro to print cylinders between spheres in arrays that have a maximun distance
#macro PrintCylinders (Final,Arr,Dmax,Radio,Kolor)
 #declare i=0;
 #while(i<Final-1)
  #declare j=i+1;
  #while (j<Final)
   #declare Distan=VDist(Arr[i],Arr[j]);
   #if(Distan<Dmax)
    cylinder{Arr[i],Arr[j],Radio texture {pigment {color Kolor}} finish {phong 1}}
   #end
   #declare j=j+1;
  #end
  #declare i=i+1;
 #end 
#end          

//Macro to found which fraction of the arist of a regular face I have to move the vertex to make the truncated platonic solids
//This magnitud is "inc" and only needs the internal angle of the regular polygon in the face.
#macro Found_inc(Angle)                     
 #declare a1=<1,0,0>;    
 #declare a2=vaxis_rotate(a1,<0,0,1>,Angle); 
 #declare zero=<0,0,0>; 
 #declare VTij=zero;          
 #declare VTik=zero;
 #declare NVTij=a1;   
 #declare inc=0.32;                     
 #declare h=0.00001;         
 #declare Cad="Au ";             
 #while (VDist(VTij,NVTij)>VDist(VTij,VTik))   
  #declare VTij=inc*a1;
  #declare VTik=inc*a2;    
  #declare NVTij=(1-inc)*a1;	  
  #declare inc=inc+h;
 #end     
#end 

//_____________________________________________
#declare edge=2.88;        //Measure of the edge in the truncated cube
#declare n=4;
#declare a=edge/0.471;     
#declare L=a*sqrt(2)+0.1;
#declare Pos= array [n];
#declare Pos[0]=<a/2,  a/2,  a/2>;
#declare Pos[1]=<-a/2,  -a/2,  a/2>;
#declare Pos[2]=<-a/2,  a/2,  -a/2>;
#declare Pos[3]=<a/2, -a/2,  -a/2>;


Found_inc(60) 

           
#debug "step 1 \n" 
#declare cont=0;
#declare PosT=array[n*3]; 
#declare i=0;
#while(i<n-1)
 #declare j=i+1;
 #while (j<n)
  #declare Distan=VDist(Pos[i],Pos[j]);
  #declare Desp=Pos[j]-Pos[i];
  #if(Distan<L)   
   #debug "repeticiones pre \n"
   #declare PosT[cont  ]=Pos[i]+Desp/3;  	 
   #declare PosT[cont+1]=Pos[i]+2*Desp/3;         
   #declare cont=cont+2;	  
  #end
  #declare j=j+1;
 #end
 #declare i=i+1;
#end    

PrintSphere (12,PosT,0.4,Red) 
PrintCylinders (12,PosT,0.4*L,0.2,Green)
 
            