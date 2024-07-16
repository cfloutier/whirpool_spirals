

static class VectorTools
{
    public static int DONT_INTERSECT = 0;
    public static int COLLINEAR = 1;
    public static int DO_INTERSECT = 2;
    
    public static PVector resultIntersection;
  
    public static int intersect(PVector p1, PVector p2, PVector p3, PVector p4)
    {
      float a1, a2, b1, b2, c1, c2;
      float r1, r2 , r3, r4;
      float denom, offset, num;
      resultIntersection = null;
    
      // Compute a1, b1, c1, where line joining points 1 and 2
      // is "a1 x + b1 y + c1 = 0".
      a1 = p2.y - p1.y; //<>//
      b1 = p1.x - p2.x;
      c1 = (p2.x * p1.y) - (p1.x * p2.y);
    
      // Compute r3 and r4.
      r3 = ((a1 * p3.x) + (b1 * p3.y) + c1);
      r4 = ((a1 * p4.x) + (b1 * p4.y) + c1);
      
      //println("r3 " + r3);
      //  println("r4 " + r4);
    
      // Check signs of r3 and r4. If both point 3 and point 4 lie on
      // same side of line 1, the line segments do not intersect.
      if ((r3 != 0) && (r4 != 0) && same_sign(r3, r4)){
        return DONT_INTERSECT;
      }
    
      // Compute a2, b2, c2
      a2 = p4.y - p3.y; //<>//
      b2 = p3.x - p4.x;
      c2 = (p4.x * p3.y) - (p3.x * p4.y);
    
      // Compute r1 and r2
      r1 = (a2 * p1.x) + (b2 * p1.y) + c2;
      r2 = (a2 * p2.x) + (b2 * p2.y) + c2;
    
      // Check signs of r1 and r2. If both point 1 and point 2 lie
      // on same side of second line segment, the line segments do
      // not intersect.
      if ((r1 != 0) && (r2 != 0) && (same_sign(r1, r2))){
        return DONT_INTERSECT;
      }
    
      //Line segments intersect: compute intersection point.
      denom = (a1 * b2) - (a2 * b1); //<>//
    
      if (denom == 0) {
        
        return COLLINEAR;
      }
    
      if (denom < 0){ 
        offset = -denom / 2; 
      } 
      else {
        offset = denom / 2 ;
      }
      resultIntersection = new PVector();
      // The denom/2 is to get rounding instead of truncating. It
      // is added or subtracted to the numerator, depending upon the
      // sign of the numerator.
      num = (b1 * c2) - (b2 * c1);
      if (num < 0){
        resultIntersection.x = (num - offset) / denom;
      } 
      else {
        resultIntersection.x = (num + offset) / denom;
      }
    
      num = (a2 * c1) - (a1 * c2);
      if (num < 0){
        resultIntersection.y = ( num - offset) / denom;
      } 
      else {
        resultIntersection.y = (num + offset) / denom;
      }
    
      // lines_intersect
      return DO_INTERSECT;
  }
  
  
  static boolean same_sign(float a, float b)
  {
    return (( a * b) >= 0);
  }

}