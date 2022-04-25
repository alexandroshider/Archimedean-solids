 /*
generate a truncated octahedron
*/ 

//used libraries
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"


//set camera and background
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


#declare n=3;    //for vertices in octahedron
#declare c=2;    //size of truncated octahedron
#declare a=c*(3*sqrt(2));

//lenght of the bonds
#declare Dmax=a/2*sqrt(2)+.1;
#declare Dmax1=Dmax/3+0.1;
#declare Dmin=0.1;


//arrays for points
#declare Pos= array[8];   
#declare Pos_trun_oct=array[24]                                          

//size and thickness of figures                                           
#declare Rs=0.3;    
#declare ts= texture{ pigment{color Blue}};  

//coords of the octahedron
#declare Pos[0]=<a/2,  0,  0>;
#declare Pos[1]=<-a/2,  0,  0>;
#declare Pos[2]=<0,  -a/2,  0>;
#declare Pos[3]=<0,  0,  -a/2>;
#declare Pos[4]=<0, a/2,  0>;
#declare Pos[5]=<0,  0,  a/2>;


//truncated octahedron positions   
#declare CO=0;
#declare enlaces=
union{
#declare i=0;
#while(i<5) 
    #declare j=i+1;
    #while(j<6)  
        #declare distancia=VDist(Pos[i],Pos[j]); 
        #declare vec_dist=Pos[j]-Pos[i];
        #if(distancia<Dmax)
            #declare k=1;
            #while (k<3) 
                //Find 2 points in each arists
                #declare Pos_trun_oct[CO] = Pos[i]+k*vec_dist/3; 
                sphere{Pos_trun_oct[CO], 0.3 pigment{color Red} finish{phong 1}} 
                #declare CO=CO+1;        
                #declare k=k+1;
            #end
        #end
        #declare j=j+1;
    #end 
    #declare i=i+1;
#end 
} 


//truncated octahedron vertices  
#declare i=0;
#while (i<23)
    #declare j=i+1;
    #while (j<24)    
        #declare DistancesTp=VDist(Pos_trun_oct[i],Pos_trun_oct[j]);
        //Distance conditional between points  
        #if (DistancesTp<Dmax1)              
            //cylinders used as arists
            cylinder {Pos_trun_oct[i], Pos_trun_oct[j], 0.1 pigment{color Green} finish{phong 1}}   
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end
                               
                
object{enlaces}                