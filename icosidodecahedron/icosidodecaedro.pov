/*
Libraries used in the project
*/
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"

//set light 
light_source {
<1000,0, 0>
color	White}
  
light_source {
<0,1000, -1000>
color	White}       

light_source {
<0,0, 0>
color	White} 

// Set a color of the background (sky)
background { color rgb< 1, 1, 1> }  
                                                                                                   
                                                                                                   
#declare ico= array[12];       // Icosahedron positions
#declare icosi= array [30]; // Icosidodecahedron vertices
#declare fi=(sqrt(5)-1)/2;
#declare acube=5; //Icosahedron edges       

#fopen Icf "Icosidodecahedron.xyz" write   //File with the coords saved in xyz file

// Icosahedron coordinates  
#declare ico[0 ]=  (acube/2)*<1,0,fi>;   
#declare ico[1 ]=  (acube/2)*<-1,0,-fi>;
#declare ico[2 ]=  (acube/2)*<1,0,-fi>;  
#declare ico[3 ]=  (acube/2)*<-1,0,fi>;
#declare ico[4 ]=  (acube/2)*<0,fi,1>;  
#declare ico[5 ]=  (acube/2)*<0,fi,-1>;  
#declare ico[6 ]=  (acube/2)*<0,-fi,1>;
#declare ico[7 ]=  (acube/2)*<0,-fi,-1>; 
#declare ico[8 ]=  (acube/2)*<fi,1,0>;   
#declare ico[9 ]=  (acube/2)*<fi,-1,0>;
#declare ico[10]=  (acube/2)*<-fi,1,0>;  
#declare ico[11]=  (acube/2)*<-fi,-1,0>;
#declare ladoIco=acube*fi;        

// This block is to calculate the distances among vertices
// and to define edges
//Calculating the middle point of icosahedron arists
#declare i=0;
#declare nicos=0;
#declare n=12;
#while (i<n-1)
    #declare j=i+1;
    #while (j<n)
        #declare L= VDist(ico[i],ico[j]);
        //Conditional for 2 points form an arist
        #if(L< ladoIco+0.1)
            //Find the middle point on the arist 
            #declare icosi[nicos]=ico[i]+0.5*(ico[j]- ico[i]);
            #write (Icf,"Au", " ",vstr(3, icosi[nicos]," ",3,5),"\n")  
            sphere{icosi[nicos], 0.15 texture {pigment{color Red}} finish{phong 1}}  
            #declare nicos=nicos+1;
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end

//Block for drawing the icosidodecahedron arists
#declare i=0;
#while (i<29)
    #declare j=i+1;
    #while (j<30)
        #declare Dist=VDist(icosi[i],icosi[j]);
        #if (Dist<=ladoIco/2+0.0005)
            cylinder{icosi[i],icosi[j], 0.07 texture {pigment{color Green}} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end
 
//Block for drawing a dodecahedron using the duality with the icosahedron
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
            //Declares in order to take 3 points forming a face.   
            #declare L1= VDist(ico[i], ico[j]);            
            #declare L2= VDist(ico[i], ico[k]);            
            #declare Angulo= VAngleD( ico[j]-ico[i], ico[k]-ico[i]); 
            // Angle formed among edges 
            #if (L1>acube-tol & L2>acube-tol & L1<acube+tol & L2<acube+tol & Angulo=60)
                //Icosahedron vertex
                #declare dode[conter]= (ico[i]+ico[j]+ico[k])/3;  
                #declare conter=conter+1;                      
            #end
            #declare k= k + 1;
        #end 
        #declare j= j + 1;
    #end           
    #declare i= i + 1;
#end  

//Camera is declared here because we can see the full icosidodecahedron acording with its 
//size 
camera{
location 13*dode[5]   
look_at <0,0,0>}                                                                                            