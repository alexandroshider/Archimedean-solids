/*
    This program makes a truncated icosadodecahedron.  
*/

//Libraries used in this program
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"

//set camera and light
camera{
location <0,17,0>   
look_at <0,-0.0,0>}

light_source {
<1000,0, 0>
color	White}
  
light_source {
<0,1000, -1000>
color	White}          

light_source {
<0,0,0>
color	White} 

// Set a color of the background (sky)
background { color rgb< 1, 1, 1> }                           

#declare ico= array[12];         // Icosahedron positions array
#declare fi=(sqrt(5)-1)/2;
#declare acube=3/fi; 

// Icosahedron coordinates, lenght is 1 because of acube
#declare ico[0]=  (acube/2)*<1,0,fi>;   
#declare ico[1]=  (acube/2)*<-1,0,-fi>;
#declare ico[2]=  (acube/2)*<1,0,-fi>;  
#declare ico[3]=  (acube/2)*<-1,0,fi>;
#declare ico[4]=  (acube/2)*<0,fi,1>;  
#declare ico[5]=  (acube/2)*<0,fi,-1>;  
#declare ico[6]=  (acube/2)*<0,-fi,1>;
#declare ico[7]=  (acube/2)*<0,-fi,-1>; 
#declare ico[8]=  (acube/2)*<fi,1,0>;   
#declare ico[9]=  (acube/2)*<fi,-1,0>;
#declare ico[10]= (acube/2)*<-fi,1,0>;  
#declare ico[11]= (acube/2)*<-fi,-1,0>;   

// This block is to calculate the distances among vertices
// of icosahedron
#declare RIc=0.1;
#declare n=12; // vertices of icosahedron
#declare ladoIco=acube*fi;   

#declare kC60=0; // counter
#declare IcoTrun= array[60];  
#declare i=0;
#while (i<n-1)
    #declare j=i+1;
    #while (j<n)
        #declare IcoDist=   VDist(ico[i], ico[j]);
        #if( IcoDist<= ladoIco+0.1 ) //conditional for distances.
            //Find 2 points in each arist
            #declare IcoTrun[kC60 ]=   ico[i]+  (ico[j]-ico[i])/3;                    
            sphere {IcoTrun [kC60], RIc  pigment{color Blue} finish{phong 1}}
            #declare kC60=kC60+1;          
            #declare IcoTrun[kC60]=  ico[i]+   2*(ico[j]-ico[i])/3;    
            sphere { IcoTrun [kC60], RIc  pigment {color Blue} finish{phong 1}}            
            #declare kC60=kC60+1;
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end                 


//Now we calculate the positions of the    
#declare dode=array[20]
#declare n=12;
#declare conter=0;
//Declare tolerance  
#declare tol=0.1;
#declare i = 0;    
#while ( i < n-1)          
    #declare j = i + 1;    
    #while ( j < n)  
        #declare k = j + 1;    
        #while ( k < n)   
            #declare L1= VDist(ico[i], ico[j]);            
            #declare L2= VDist(ico[i], ico[k]);            
            #declare Angulo= VAngleD( ico[j]-ico[i], ico[k]-ico[i]); 
            // Angle formed among edges 
            #if (L1>acube-tol & L2>acube-tol & L1<acube+tol & L2<acube+tol & Angulo=60) 
                //Find the centers in the icosahedron's faces
                #declare dode[conter]= (ico[i]+ico[j]+ico[k])/3;  
                #declare conter=conter+1;                      
            #end
            #declare k= k + 1;
        #end 
        #declare j= j + 1;
    #end           
    #declare i= i + 1;
#end  

#fclose Icotrunc
#fclose donde       


   

// Selection and Translation of hexagonal faces    
#declare icosit=array[10000];   
#declare counter1=0;
#declare i=0;
#while(i<60)  
    #declare j=0;
    #while (j<20)
        // vdot is 0.8710180527 for hexagons and their perpendicular vectors
        #if (  vdot( vnormalize(IcoTrun[i]) ,  vnormalize(dode[j])  ) < (0.89) & vdot( vnormalize(IcoTrun[i]) ,  vnormalize(dode[j])  )>(0.60) ) 
            //declare points of the truncated icosidodecahedron
            #declare icosit[counter1]=IcoTrun[i]+vnormalize(dode[j])*acube*1.05;// +acube*vnormalize(dode[j]);
            sphere { icosit[counter1], 0.35 pigment{color Red} finish {phong 1}}
            #declare counter1=counter1+1; 
        #end
        #declare j=j+1;   
    #end   
    #declare i=i+1;   
#end             

#declare i=0;
#while (i<119)
    #declare j=i+1;
    #while (j<120)
        #declare Dist=VDist(icosit[i],icosit[j]);
        #if (Dist<=2+0.1)
            cylinder{icosit[i],icosit[j], 0.2 texture {pigment{color Green}} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end        

#declare i=0;
#while (i<59)
    #declare j=i+1;
    #while (j<60)
        #declare Dist=VDist(IcoTrun[i],IcoTrun[j]);
        #if (Dist<=ladoIco/3+0.1)
            cylinder{IcoTrun[i],IcoTrun[j], 0.06 texture {pigment{color Blue}} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end
 
 
                                 