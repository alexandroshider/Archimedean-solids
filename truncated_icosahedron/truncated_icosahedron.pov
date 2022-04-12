// Libraries containing color, texture, vector operations
#include "colors.inc"
#include "shapes.inc"
#include "math.inc"
                   
//set camera                   
light_source {
<0,0, -50>
color	White}
     
light_source {
<0,0,0>
color	White} 
       
// Set a color of the background (sky)
//Scenario definition
camera {location <0,0,-10> look_at <0,0,0>}
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
           
           
           
#fopen CompIco "Icosaedro.xyz" write
#write(CompIco,12,"\n")
#write(CompIco,"The edge of the truncated icosahedron measures","\n") 


//_____________________________________________
//This is the golden ratio. It is used for each point in a icosahedron. 
#declare GR=(1+sqrt(5))/2;


//Icosahedron's parameters
#declare a=5;   //The size of the icosahedron's arist   

//In this file I gonna save ALL THE POINTS 
#fopen all_points "all_points_vertices_arists_faces.txt" write 



#declare f=a/(-1+sqrt(5));    //Transformation for make the icosahedron the size we want

//Dmax is the limit of distance between the icosahedron coordinates 
//so that the program won't make "arists" inside the icosahedron
#declare Dmax=(-1+sqrt(5))*f+0.01;

//Array with the icosahedron's vertices 
#declare Pos_ico=array[12];
#declare Pos_ico[0]=f*<1, 0, 1/GR>;
#declare Pos_ico[1]=f*<1, 0, -1/GR>;
#declare Pos_ico[2]=f*<-1, 0, 1/GR>;
#declare Pos_ico[3]=f*<-1, 0, -1/GR>;
#declare Pos_ico[4]=f*<1/GR, 1, 0>;
#declare Pos_ico[5]=f*<-1/GR, 1, 0>;
#declare Pos_ico[6]=f*<0, 1/GR, 1>;
#declare Pos_ico[7]=f*<0, -1/GR, 1>;
#declare Pos_ico[8]=f*<1/GR, -1, 0>;
#declare Pos_ico[9]=f*<-1/GR, -1, 0>;
#declare Pos_ico[10]=f*<0, 1/GR, -1>;
#declare Pos_ico[11]=f*<0, -1/GR, -1>;

//This macro finds where we need to put 2 points in all the arists, so we can get the truncated icosahedron
//joining all of those points 
Found_inc(60)    

#declare cont=0;
#declare PosT=array[60]; 
#declare i=0;
#while(i<11)
    #declare j=i+1;
    #while (j<12)
        #declare Distan=VDist(Pos_ico[i],Pos_ico[j]);
        #declare Desp=Pos_ico[j]-Pos_ico[i];
        #if(Distan<Dmax)
            //First point
            #declare PosT[cont  ]=Pos_ico[i]+Desp/3;  
            //Second point	 
            #declare PosT[cont+1]=Pos_ico[i]+2*Desp/3;
            #declare cont=cont+2;	  
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end                 

//Generate the image of truncated icosahedron
//Normal icosahedron is commented
//PrintSphere (12,Pos_ico,0.1,Red)
PrintSphere (60,PosT,0.4,Red) 
//PrintCylinders (12,Pos_ico,L,0.05,Green)
PrintCylinders (60,PosT,0.4*Dmax,0.2,Green)
