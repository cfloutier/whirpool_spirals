import controlP5.*; //<>// //<>//
import processing.pdf.*;
import processing.dxf.*;

  WhirpoolSpiral spiral;
  
  int N = 4; // Nb of corners of the primal polygon

  float Rho = 10; // angle of rotation
  float Sigma = 20; // angle of spirality
  
  float size = 1000;
  int NbRows = 30;
  Slider NSlider, RhoSlider, SigmaSlider;

  

ControlP5 cp5;
void setup() 
{
  size(800, 800);
  
  spiral = new WhirpoolSpiral();
  
  setupControls();
  
  //noLoop();  // Run once and stop
}

void setupControls()
{
  
  cp5 = new ControlP5(this);
  
   // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  NSlider = cp5.addSlider("N")
     .setPosition(10,20)
     .setSize(300,20)
     .setValue(N)
     .setRange(3,10)
      .setNumberOfTickMarks(8)
     ;
  
  RhoSlider = cp5.addSlider("Rho")
     .setPosition(10,40)
     .setSize(300,20)
     .setRange(0,90);
     
  SigmaSlider = cp5.addSlider("Sigma")
    .setPosition(10, 60)
    .setSize(300,20)
    .setRange(0,90);
    
   cp5.addSlider("NbRows")
    .setPosition(10, 80)
    .setSize(300,20)
    .setRange(1,100);
    
    
    
  float step = 10;
   float min = 10;
   float max = 200;
  int nbTick = (int) ((max-min)/step) + 1;
    
  cp5.addButton("savePDF")
      .setPosition(10, 100)
      .setSize(150,20);
      
  cp5.addButton("saveDXF")
    .setPosition(160, 100)
    .setSize(150,20);
}


boolean record = false;
boolean pdfMode = false;

String fileName = "";
void savePDF()
{
  record = true;
  pdfMode = true;
  
  
}

void saveDXF()
{
  record = true;
  pdfMode = false;
}

int lastN = -1;

void draw()
{
 
  background(127);
  
   if (record) 
   {
    // Note that #### will be replaced with the frame number. Fancy!
    
    fileName = "export " + spiral.N + "_" + spiral.Rho + "_" + spiral.Sigma + "x"+ spiral.NbRows; 
      if (pdfMode)
        beginRecord(PDF, fileName + ".pdf"); 
      else
        beginRecord(DXF, fileName + ".dxf"); 
  }
  
  
  spiral.N = N;
  spiral.Rho = Rho;
  spiral.Sigma = Sigma;
  spiral.startLenght = size;
  spiral.NbRows = NbRows;
  
  spiral.buildPoints();
  if (lastN != N)
  {
    // compute new range
   
    lastN = N;
    
     float step = 5;
     float min = 0;
     float max = spiral.BetaPrim/2;
     int nbTick = (int) ((max-min)/step) + 1;
      max = nbTick * step;
    RhoSlider.setRange(min, max);
    RhoSlider.setNumberOfTickMarks(nbTick+1);
      
     max = spiral.AlphaPrim;
     nbTick = (int) ((max-min)/step) + 1;
     max = nbTick * step;
     SigmaSlider.setRange(min, max);
     SigmaSlider.setNumberOfTickMarks(nbTick + 1);
  }
  
  strokeWeight(1);
  
  stroke(0);
  spiral.draw();
  
   if (record) 
   {
      endRecord();
      record = false;
   }
}