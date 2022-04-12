/*
This program makes a truncated cuboctahedron.
This program only works for a unique size of acube=1. 
Larger size break this program.
*/
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"

// Set camera and color of the background (sky)
camera{
location <2.6,1,0>   
look_at <0,-0.25,0>}

light_source {
<1000,0, 0>
color	White}
  
light_source {
<0,1000, -1000>
color	White} 

light_source {
<0,0, 0>
color	White}

background { color rgb< 1, 1, 1> }                       
                                  
//Parameter cube edge length                                  
#declare acube=1;              // Cube edges length 


#declare cuboc= array [12]; // cuboctahedron vertices    
#declare Pos= array[8];     // Cube positions
#declare TC= array [24];   // Truncated cube vertices
     

//Cube's vertices
#declare Pos[0]= <acube/2,    acube/2,  acube/2>;  
#declare Pos[1]= <-acube/2,  -acube/2, -acube/2>;
#declare Pos[2]= <-acube/2,   acube/2,  acube/2>;
#declare Pos[3]= <acube/2,   -acube/2,  acube/2>;
#declare Pos[4]= <acube/2,    acube/2,  -acube/2>;
#declare Pos[5]= <-acube/2,  -acube/2,  acube/2>;
#declare Pos[6]= <-acube/2,   acube/2,  -acube/2>;
#declare Pos[7]= <acube/2,   -acube/2,  -acube/2>;

//Conditionals for distances
#declare L=acube+0.1;


#fopen cuboct "cuboctahedron.xyz" write     
//Generate cube
#declare cube_arists=
union{
#declare i=0;
#while (i<7)
    #declare j=i+1;
    #while (j<8)
        #declare Dist=VDist(Pos[i],Pos[j]);
        #if (Dist<=L)
            cylinder{Pos[i],Pos[j], 0.02 texture {pigment{color Red}} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end      
}

                           
// This block is to calculate the distances among vertices
// and to define edges
//Calculating the center of cube edges 
#declare cuboctahedron_vertices=
union{
#declare i=0;
#declare ncub=0;
#declare n=8;
#while (i<n-1)
    #declare j=i+1;
    #while (j<n)
        #declare Dist= VDist(Pos[i],Pos[j]);
        #if(Dist< L) 
            #declare cuboc[ncub]=Pos[i]+0.5*(Pos[j]- Pos[i]);
            sphere{cuboc[ncub], 0.04 pigment{color Red}} 
            #write (cuboct,"Au", " ",vstr(3, cuboc[ncub]," ",3,5),"\n")  
            #declare ncub=ncub+1;
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end 
}        
  
//Everything ok until here  

#fopen out "truncatedcube.xyz" write  
#fopen pointo "arregloTC.dat" write
          
// Selecting triangular faces using the distance to the center of faces 
#declare select_triangular_faces=
union{
#declare i=0;
#declare nsele=0;
#declare TC= array [24]; // selected cuboctahedron vertices
#while (i<8) 
    #declare j=0;
    #while (j<ncub) 
        #if( VDist(Pos[i],cuboc[j]) < acube*sqrt(2)/2 )  
            //Each point of the cube selects 3 points from the cuboctahedron
            //This makes a total of 24 vertices
            #declare TC[nsele]=cuboc[j];
            #write (pointo,nsele+1," ",vstr(3,TC[nsele]," ",5,4),"\n")
            #declare nsele=nsele+1;
        #end
        #declare j=j+1;
    #end 
    #declare i=i+1; 
#end
}         
#fclose pointo

      
//Translation of triangular faces 
//We select 3 points at same time because there is a index relation 
//between Pos and TC arrays               
#declare translation=
union{
#declare i=0;
#while(i<nsele)   
    #declare TC[i  ]=TC[i  ]+0.8660*acube*(sqrt(2)/2)  *vnormalize((Pos[i/3]));  
    #declare TC[i+1]=TC[i+1]+0.8660*acube*(sqrt(2)/2) *vnormalize((Pos[i/3])); 
    #declare TC[i+2]=TC[i+2]+0.8660*acube*(sqrt(2)/2) *vnormalize((Pos[i/3])); 
    #write (out,"Au", " ",vstr(3,TC[i],  " ",3,5),"\n")
    #write (out,"Au", " ",vstr(3,TC[i+1],  " ",3,5),"\n")
    #write (out,"Au", " ",vstr(3,TC[i+2],  " ",3,5),"\n")
    #declare i=i+3;               
#end    
}
      
// Final model of truncated cube using cuboctahedron 
#declare truncated_cube=
union{
#declare h=pow(10,-3);
#declare i=0;     
#while (i<nsele-1)                                              
    sphere {TC[i],0.03 texture {pigment { color Red}} finish{phong 1} }      
    #declare j=i+1  ;
    #while(j<nsele) 
        #if (VDist(TC[i],TC[j])<(sqrt(2)/2)+2*h  & VDist(TC[i],TC[j])>(sqrt(2)/2)-2*h )
            cylinder {TC[i],TC[j], 0.025  texture { pigment { color Green}  } finish{phong 1}}  
        #end 
        #declare j=j+1;
    #end 
    #declare i=i+1;
#end
}


//Generate hexagons in the triangular faces of the truncated cube                     
#declare cutting_corners=
union{                     
#declare hexa1= array [48];
#declare kon=0;
#declare i=0;
#while (i<nsele)
    #declare j=i+1;
    #while (j<nsele)
        #declare V1= TC[j]-TC[i];
        #declare k=j+1;
        #while (k<nsele)
            #declare V2= TC [k]-TC[i];
            #declare Dd=   VDist(TC [i],TC[j]);
            #declare Dd1= VDist(TC [i],TC[k]);
            #declare angulo= VAngleD(V1,V2);
            //finding edges with a common vertex; edge equals sqrt(2)/2
            #if( (Dd<acube*0.8 & Dd>acube*0.7) & (Dd1<acube*0.8 & Dd1> acube*0.7)  & (angulo>59 & angulo<61))
                //Like Pos and TC arrays, there is a index relation between the TC and the hexa1 arrays
                #declare hexa1[kon ]= TC[i]+     (TC[j]-TC[i])/3;    
                #declare hexa1[kon+1]=TC[i]+2*(TC[j]-TC[i])/3;
                #declare hexa1[kon+2 ]=TC[i]+   (TC[k]-TC[i])/3;  
                #declare hexa1[kon+3]= TC[i]+2*(TC[k]-TC[i])/3;
                #declare hexa1[kon+4 ]=TC[j]+   (TC[k]-TC[j])/3;  
                #declare hexa1[kon+5]= TC[j]+   2*(TC[k]-TC[j])/3;    
                sphere {hexa1[kon+0],0.095 texture {pigment{color Yellow}} finish{phong 1}} 
                sphere {hexa1[kon+1],0.095 texture {pigment{color Yellow}} finish{phong 1}}
                sphere {hexa1[kon+2],0.095 texture {pigment{color Yellow}} finish{phong 1}}
                sphere {hexa1[kon+3],0.095 texture {pigment{color Yellow}} finish{phong 1}}
                sphere {hexa1[kon+4],0.095 texture {pigment{color Yellow}} finish{phong 1}}
                sphere {hexa1[kon+5],0.095 texture {pigment{color Yellow}} finish{phong 1}}
                #declare kon=kon+6;
            #end
            #declare k=k+1;
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end
}
         
#declare truncated_cuboctahedron=
union{
//Selection of hexagons and normal vectors to translate them
#declare Thex= array[480];
#declare ladoCuboc= acube*sqrt(2)/2; //Cuboctahedron edge
#fopen TrCubocta "Truncated-cuboc.xyz" write
#declare konter=0;
#declare i=0;
#while(i<48)  
    #declare j=0;
    #while (j<8)                   
        #if ( vdot(hexa1[i],Pos[j])<(acube+0.2) & vdot(hexa1[i], Pos[j] )> (acube-0.2))
            //Moving the hexa1 pointsby gropus for obtaing regular faces (rectangles become into squares)
            #declare Thex[konter]=hexa1[i]-0.985* ladoCuboc     *vnormalize((Pos[j]));  
            sphere {Thex[konter], 0.07 pigment {rgb <1,0,0>}  finish{phong 1}}
            #write (TrCubocta,"H", " ",vstr(3, Thex[konter ]," ",3,5),"\n")
            #declare konter=konter+1;
        #end
        #declare j=j+1;   
    #end   
    #declare i=i+1;   
#end        
}
 
#warning concat(str(konter,2,0)," puntos")

//make truncated cuboctahedron arists with points saved in Thex 
#declare truncated_cuboctahedron_arists=
union{ 
#declare i=0;
#while (i<47)
    #declare j=i+1;
    #while (j<48)
        #declare Dist=VDist(Thex[i],Thex[j]);
        #if (Dist<=acube/5+0.1)
            cylinder{Thex[i],Thex[j], 0.04 texture {pigment{color Green}} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end      
}
  
  
//make hexagons in the triangular faces of the truncated cube
#declare cutting_corners_arists=
union{       
#declare i=0;
#while (i<47)
    #declare j=i+1;
    #while (j<48)
        #declare Dist=VDist(hexa1[i],hexa1[j]);
        #if (Dist<=acube/5+0.1)
            cylinder{hexa1[i],hexa1[j], 0.064 texture {pigment{color Blue}} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end                                          
}                                      
  
/*
object{cube_arists}     
object{cuboctahedron_vertices}    
object{select_triangular_faces}   
object{translation}               
object{truncated_cube}     
object{cutting_corners} 
object{cutting_corners_arists}  */
object{truncated_cuboctahedron} 
object{truncated_cuboctahedron_arists} 