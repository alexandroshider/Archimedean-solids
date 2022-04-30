/*
This script makes a rhombicosidodecahedron
NOTE: IT IS NOT MADE FOR MODIFYING THE SIZE OF THE RHOMBICOSIDODECAHEDRON
IT WILL DEFORM THE SHAPE OF THE FACES. Maybe we can make an update later.
*/
//Libraries
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"


//Set camera and lights
camera{
location <0,3,0>   
look_at <0,-0,0>}

light_source {
<1000,0, 0>
color	White}
  
light_source {
<0,1000, -1000>
color	White} 

// Set a color of the background (sky)
background { color rgb< 1, 1, 1> }                           

#declare ico= array[12];         // Icosahedron positions
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
#declare ico[9]= (acube/2)*<fi,-1,0>;
#declare ico[10]= (acube/2)*<-fi,1,0>;  
#declare ico[11]= (acube/2)*<-fi,-1,0>; 

// This block is to calculate the distances among vertices
// of icosahedron
#declare n=12; // vertices of icosahedron
#declare ladoIco=acube*fi;
#declare kC60=0; // counter
#declare IcoTrun= array[60];  
#declare i=0;
#while (i<n-1)
    #declare j=i+1;
    #while (j<n)
        #declare IcoDist=   VDist(ico[i], ico[j]);  
        //conditional for finding faces using 3 vertices
        #if( IcoDist<= ladoIco+0.1 )
            #declare IcoTrun[kC60 ]=   ico[i]+  (ico[j]-ico[i])/3;            
            #declare kC60=kC60+1;          
            #declare IcoTrun[kC60]=  ico[i]+   2*(ico[j]-ico[i])/3;                          
            #declare kC60=kC60+1;
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end                 
#fclose ITf

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
            // Angle formed among edges for calculate the dual of the icosahedron
            #if (L1>acube-tol & L2>acube-tol & L1<acube+tol & L2<acube+tol & Angulo=60)
                #declare dode[conter]= (ico[i]+ico[j]+ico[k])/3;                   
                #declare conter=conter+1;                      
            #end
            #declare k= k + 1;
        #end 
        #declare j= j + 1;
    #end           
    #declare i= i + 1;
#end  


#declare Rhom=array[100];
#declare konter=0;
#declare i=0;
#while(i<20)  
    #declare j=0;
    #while (j<12) 
        #if ( vdot( vnormalize(dode[i]), vnormalize(ico[j]))> (0.25) & vdot(vnormalize(dode[i]), vnormalize(ico[j] ))< (1.0))
        // dot product among one vertex and the center of one face
            #declare Rhom[konter]=dode[i]+ 0.95088*0.4*vnormalize((ico[j]));  //  magnitude of the perpendicular vector
            #declare konter=konter+1;
        #end
        #declare j=j+1;   
    #end   
    #declare i=i+1;   
#end             
#debug concat("vertices de rhom ",str(konter,2,0),"\n")           


// spheres Model
#declare h=0.1;
#declare i=0;     
#while (i<60)                                              
    sphere {1.33*Rhom[i],0.1 texture { pigment { color Red}  } finish{phong 1} }    
    #declare j=i+1  ;
    #while(j<60) 
        #if (VDist(Rhom[i],Rhom[j])<acube/15+2*h)//  & VDist(Rhom[i],Rhom[j])>lado-2*h )
            cylinder {1.33*Rhom[i],1.33*Rhom[j], 0.05  texture { pigment { color Green} finish  { phong 1 } } }  
        #end 
        #declare j=j+1;
    #end 
    #declare i=i+1;
#end                  


#declare i=0;
#while (i<19)
    #declare j=i+1;
    #while (j<20)
        #declare Dist=VDist(dode[i],dode[j]);
        #if (Dist<=ladoIco/7+0.1)
            cylinder{dode[i],dode[j], 0.03 texture {pigment{color Blue}} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end


