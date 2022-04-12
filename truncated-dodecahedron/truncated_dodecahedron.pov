/*
This program makes a truncated dodecahedron
   */         
   
//Libraries used in the project
#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"

// Set camera and color of the background (sky)
camera{
location <5,4,0>   
look_at <0,0,0>}

light_source {
<1000,0, 0>
color	White}
  
light_source {
<0,1000, -1000>
color	White}      

light_source {
<0,1000, 1000>
color	White} 

background { color rgb< 1, 1, 1> }          

//Macro for finding displazement of a vertex on a arist for making the truncation
#macro Found_inc(Angle)                     
    #declare P1=<0,0,0>; 
    #declare P2=<1,0,0>;    
    #declare P3=vaxis_rotate(P2,<0,0,1>,Angle); 
    #declare P4=P1;          
    #declare P5=P2;
    #declare P6=P1;   
    #declare inc=0.27;                     
    #declare h=0.00001;         
    #declare Cad="Au ";             
    #while (VDist(P4,P5)>VDist(P4,P6))   
        #declare P4=inc*P2;
        #declare P5=(1-inc)*P2;
        #declare P6=inc*P3;    	  
        #declare inc=inc+h;
    #end     
#end

//Size of truncated dodecahedron
#declare arist=3*0.27638;

#declare n=20;
#declare dode=array[n]
#declare acube=arist/0.27638;     
#declare L=acube*2/3; 
#declare fi=(sqrt(5)-1)/2;

// Dodecahedron vertices
#declare dode[0]=  (acube/2)*<1+fi,0,fi>;   
#declare dode[1]=  (acube/2)*<-(1+fi),0,-fi>;
#declare dode[2]=  (acube/2)*<1+fi,0,-fi>;  
#declare dode[3]=  (acube/2)*<-(1+fi),0,fi>;
#declare dode[4]=  (acube/2)*<0,fi,1+fi>;  
#declare dode[5]=  (acube/2)*<0,fi,-(1+fi)>;  
#declare dode[6]=  (acube/2)*<0,-fi,1+fi>;
#declare dode[7]=  (acube/2)*<0,-fi,-(1+fi)>; 
#declare dode[8]=  (acube/2)*<fi,1+fi,0>;   
#declare dode[9]= (acube/2)*<fi,-(1+fi),0>;
#declare dode[10]= (acube/2)*<-fi,1+fi,0>;  
#declare dode[11]= (acube/2)*<-fi,-(1+fi),0>;  
#declare dode[12]=  (acube/2)*<1,    1,  1>;  
#declare dode[13]=  (acube/2)*<-1,  -1, -1>;
#declare dode[14]=  (acube/2)*<-1,   1,  1>;
#declare dode[15]=  (acube/2)*<1,   -1,  1>;
#declare dode[16]=  (acube/2)*<1,    1,  -1>;
#declare dode[17]=  (acube/2)*<-1,  -1,  1>;
#declare dode[18]=  (acube/2)*<-1,   1,  -1>;
#declare dode[19]=  (acube/2)*<1,   -1,  -1>;

#fopen DTf "TruncatedDodecahedron.xyz" write         
#write(DTf,"60 \n\n")

Found_inc(108)       
//Call the macro to find the truncation value over the edges of pentagonal faces.     
#declare cont=0;
#declare PosT=array[60]; 
#declare i=0;
#while(i<n-1)
    #declare j=i+1;
    #while (j<n)
        #declare Distan=VDist(dode[i],dode[j]);
        #declare Desp=dode[j]-dode[i];
        //Conditional for identify 2 points for an arist
        #if(Distan<L)    
            //Find two points on the arists using the value we found in the macro
            #declare PosT[cont]=dode[i]+inc*Desp; 
            #write (DTf,"Au", " ",vstr(3, PosT[cont]," ",3,5),"\n")  
            sphere { PosT[cont], 0.1 texture {pigment{color Red}} finish{phong 1} }      
            #declare cont=cont+1;
            #declare PosT[cont]=dode[i]+(1-inc)*Desp;    
            #write (DTf,"Au", " ",vstr(3, PosT[cont]," ",3,5),"\n") 
            sphere { PosT[cont], 0.1 texture {pigment{color Red}} finish{phong 1}}       
            #declare cont=cont+1;	  
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end   


#declare i=0;
#while(i<19)
    #declare j=i+1;
    #while (j<20)
        #declare Distan=VDist(dode[i],dode[j]);
        #if(Distan<L)   
            //There are 2 points in the edge: the closer to PosOct[i] and the closer to PosOct[j]
            cylinder{dode[i],dode[j], 0.02 texture {pigment{color Green}} finish{phong 1}}	  
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end

#declare i=0;
#while(i<59)
    #declare j=i+1;
    #while (j<60)
        #declare Distan=VDist(PosT[i],PosT[j]);
        #if(Distan<L/2)   
            //There are 2 points in the edge: the closer to PosOct[i] and the closer to PosOct[j]
            cylinder{PosT[i],PosT[j], 0.06 texture {pigment{color Green}} finish{phong 1}}	  
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end



#declare i=0;
#while(i<20)   
    //There are 2 points in the edge: the closer to PosOct[i] and the closer to PosOct[j]
    sphere{dode[i], 0.03 texture {pigment{color Red}} finish{phong 1}}	  
    #declare i=i+1;
#end                   