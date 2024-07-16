



// Whirpool spiral generator
// by Tomoko fuse from the Spirals book
// code by Christophe Floutier
class WhirpoolSpiral
{

  public int N = 4; // Nb of corners of the primal polygon

  float Rho = 10; // angle of rotation
  float Sigma = 20; // angle of spirality
  
  int NbRows = 50;
  float startLenght = 150;
  
  PVector[][] points; 
  
  // geometrics values;
    float BetaPrim ;
    float AlphaPrim ; 
    float GammaPrim ;
    float Epsilon ;
    float Beta ;
    float Gamma ;
    
   void computeGeoValues()
   {
      BetaPrim = 360/N;
      AlphaPrim = (180 - BetaPrim)/2; 
      GammaPrim = 2 * AlphaPrim;
      
      Epsilon = 90 + Rho/2;
      Beta = Epsilon - AlphaPrim;
      Gamma = 180 - Sigma - Beta;
   }
  
  boolean buildTriangle(int rowIndex, int colIndex, float baseLenght, float curRho)
  {
    float angle = radians(curRho);
    PVector direction = new PVector(cos(angle), sin (angle));
   
    PVector p1 = points[rowIndex][colIndex];
    PVector p3 = PVector.add(p1, PVector.mult(direction, baseLenght));
    points[rowIndex][colIndex + 1] = p3;
    
    angle = radians(curRho +Sigma);
    
    PVector direction1 = new PVector(cos(angle), sin (angle));
    angle = radians(curRho +180 - Gamma);
    PVector direction2 = new PVector(cos(angle), sin (angle));
    
    
    
    PVector p2 = PVector.add( p1, PVector.mult(direction1,startLenght*2) );
    PVector p4 = PVector.add( p3, PVector.mult(direction2,startLenght*2) );
    
    
//     println("row " + rowIndex + " col " + colIndex);
 //    println("curRho " + curRho);
 //    println("Sigma " + Sigma);
     
     
 //   stroke(255);
//    line(p1.x, height-p1.y, p2.x, height-p2.y);
    
    if (VectorTools.intersect(p1,p2,p3,p4) != VectorTools.DO_INTERSECT)
    {
      println("Error points does not intersec");
      return false;
    }
    
    points[rowIndex + 1][colIndex + 1] = VectorTools.resultIntersection;
    return true;
  }
  
  void buildArray()
  {
    points = new PVector[NbRows+1][N+1];
    for (int i = 0; i < NbRows + 1; i++)
      for (int j = 0; j < N + 1 ; j++)
        points[i][j] = new PVector();
  }
  
  boolean buildPoints()
  {
    computeGeoValues();
    buildArray();
    
    // first build the first triangle
  
    float startRho = 0;
    float curLength = startLenght;
    // set startpoint;
    points[0]  [0] = new PVector(0,0);
    
    float curRho = startRho;
    for (int row = 0; row < NbRows; row++)
    {
      for (int col = 0; col < N; col++)
      {
        
        
          
        if (!buildTriangle( row, col, curLength, curRho))
          return false;
          
         
          
        
          curRho = curRho + Rho;
      }
     
      // compute new curRho and startLenght
      PVector dir = PVector.sub(points[row+1][2], points[row+1][1]);
      float newAngle =  degrees(atan2(dir.y, dir.x));
      // remove the rotation 
      startRho = newAngle - Rho;
      
      // compute new Length
      curLength = dir.mag(); 
      
      float angle = radians(startRho+180);
      dir = new PVector(cos(angle), sin(angle));
      PVector deltaVec = PVector.mult(dir, curLength);
      
      // set start Point
      points[row+1][0] = PVector.add(points[row+1][1], deltaVec);
      
      curRho = startRho;
    }
      
    return true;
  }
  
  void drawLine(PVector p1, PVector p2)
  {
      line((p1.x + dx)*mul, height  - (p1.y  + dy ) * mul, (p2.x + dx )* mul  , height  - (p2.y + dy)* mul);
  }
  
  float dx = 0;
  float dy = 0;
  float mul = 1;
  
  void draw()
  {
    // compute minMax;
    float minX = 0; 
    float maxX = 0;
    float minY = 0;
    float maxY = 0;
    
    for (int row = 0; row < spiral.NbRows+1; row++)
    {
      for (int col = 0; col < spiral.N+1; col++)
      {
        PVector p = points[row][col];
        if (minX > p.x)
          minX = p.x;
        else if (maxX < p.x)
          maxX = p.x;
        
        if (minY > p.y)
          minY = p.y;
        else if (maxY < p.y)
          maxY = p.y;
      }
    }
      
      dx = -minX;
      dy = -minY;
      
      float w = maxX - minX;
      float h = maxY - minY;
      
      mul = width / w;
      if ((maxY  + dy) * mul > height)
      {
        // println("too hight");
          mul = height / h;
      }
      
      color blue = color(0, 0, 255);
      color red = color(255, 0, 0);
      
        stroke(blue);
        
    for (int row = 0; row < spiral.NbRows; row++)
    {
      for (int col = 0; col < spiral.N; col++)
      {
        drawLine(points[row][col], points[row+1][col+1]);     
      }
    }
    
    stroke(red);
    
    for (int row = 1; row < spiral.NbRows; row++)
    {
      for (int col = 0; col < spiral.N; col++)
      {
        drawLine(points[row][col], points[row][col+1]);     
       
      }
    }
    
    for (int row = 1; row < spiral.NbRows + 1; row++)
    {
      for (int col = 0; col < spiral.N - 1; col++)
      {
        drawLine(points[row][col+1], points[row-1][col+1]);     
       
      }
    }
    
    
    stroke(0);
    
    // out line (cut)
   for (int row = 0; row < spiral.NbRows ; row++)
   {
     drawLine(points[row][0], points[row+1][0]);   
     drawLine(points[row][spiral.N], points[row+1][spiral.N]);   
   }
   
    for (int col = 0; col < spiral.N; col++)
    {
      drawLine(points[0][col], points[0][col+1]);     
       drawLine(points[spiral.NbRows][col], points[spiral.NbRows][col+1]);     
    }
    
    
    
      
  }
}