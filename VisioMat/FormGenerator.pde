void graphicBuffer()
{ 
  graphics.beginDraw();
  
  //bgcolor = calcGradient(gradColor[0], gradColor[1]);
  //bgcolor = fftColor(gradColor[0], gradColor[1], 2);
  
  graphics.background(bgcolor);
  graphics.stroke(strokeColor);

  
  graphics.translate(0, shift+100);  // push the forms down the y axis
      
  
  // adds the visual elements if activated
  
  if(mandalaOn)
  {
    mandala();
  }
  if(dotsOn)
  {
    dots();
  }  
  if(starsOn)
  {
    stars();
  }


  // overlay filmgrain/dirt
  
  if (dirt.available()) {
    dirt.read();
  }    
  graphics.blend(dirt, 0, 0, 250, 1000, 0, 0, bufferWidth, bufferHeight, OVERLAY);
  
  graphics.endDraw();   
}


int calcGradient(int c1, int c2)
{
  //if (c == gradColor[1])
  //{
  //  tgtcolor = gradColor[0];    
  //}
  //if (c == gradColor[0])
  //{
  //  tgtcolor = gradColor[1];    
  //}
  if(lerpCounter >= 1.0)
  {
    lerpCounter = -1.0;
  }
  
  lerpCounter += 0.01;
  return lerpColor(c1, c2, abs(lerpCounter));
  //println(c);
  //println("c1: " + gradColor[1]);
  //println("c2: " + gradColor[1]+1);
  //return c;
  
    
}



// generates some lines - which if shifted result in nice star patterns
void stars()
{
  graphics.stroke(strokeColor, starAlpha);
  // iterates over the height of the graphic buffer and draws some lines now and then
  // the thickness of the lines and distribution can be controlled via the parameters patternSpread and lineSpread
  for (float i = -bufferHeight; i < shift+300; i+=lineSpread)
  { 
    if(i >= shift-bufferHeight-150+patternSpread)  // only draw those that are actually to be seen on the screen (to save performance)
    {
      graphics.strokeWeight(lineSpread/3);
      graphics.line(0, -i+1*starFactor,  bufferWidth, -i);
    }
  }
  
  //  for (float i = -shift-100; i < -shift+bufferHeight-patternSpread; i+=lineSpread)
  //{ 
  //  //if(i >= shift-bufferHeight-150)  // only draw those that are actually to be seen on the screen (to save performance)
  //  //{
  //    graphics.strokeWeight(lineSpread/3);
  //    graphics.line(0, i+1*starFactor,  bufferWidth, i);
  //  //}
  //}
}



// generates some dots - similar to the star generator
void dots()
{
  // to compensate the distortion which happens due to the scaling of the texture - in other words to make the dots appear like perfect circles
  float antiDistort = (1.0 * graphics.width / graphics.height) * (cos(PI / numFacets) * radius) / (2 * sin(PI / numFacets) * radius);
  
  //graphics.strokeWeight(0);
  graphics.noStroke();
  graphics.fill(strokeColor, dotAlpha);
  
  for (float i = -bufferHeight; i < shift+300; i+=20)
  {
    if(i >= shift-bufferHeight-150+patternSpread)
    {
      for (float j = 0; j <= graphics.width/2; j+=15*antiDistort)
      {
        graphics.ellipse(bufferWidth/2+j, -i, dotSize*antiDistort, dotSize);  // starts in the horizontal center to align the dots to the center
        if(j!=0)
        {
          graphics.ellipse(bufferWidth/2-j, -i, dotSize*antiDistort, dotSize);
        }
      }
    }
  }
}



// generates some random numbers for the vertices to be drawn
void randomGenerator()
{
  //if (timeCount == 0)
  //if (petalTrigger)
  //{
    float peak = -(shift+random(bufferWidth));

      // creates six values which are needed to draw a bezier curve (x1, y1, x2, y2, x3, y3)
      vertices = (float[][])append(vertices, new float[]{0, -shift,  random(bufferWidth), -(shift+random(bufferWidth)), bufferWidth, peak} );

      vertices = (float[][])append(vertices, new float[]{bufferWidth, peak,  random(bufferWidth), peak-random(bufferWidth), 0, peak-random(bufferWidth)} );
      
      

    
    //if (vertices[vertices.length-1][4] == 0) // seeds a vertex alternately on the left and right side of the graphic buffer
    //{
    //  // creates six values which are needed to draw a bezier curve (x1, y1, x2, y2, x3, y3)
    //  vertices = (float[][])append(vertices, new float[]{0, -100-shift,  random(bufferWidth), -100-(shift+random(bufferWidth)), bufferWidth, -100-(shift+random(bufferWidth))} );
    //}
    //else if (vertices[vertices.length-1][4] == bufferWidth)
    //{
    //  vertices = (float[][])append(vertices, new float[]{bufferWidth, -100-shift,  random(bufferWidth), -100-(shift+random(bufferWidth)), 0, -100-(shift+random(bufferWidth))} );
    //}
   
    // wait a random amount of time before drawing the next object
  //  timeCount = 200+int(random(bufferWidth*0.25/shiftFactor, bufferWidth/shiftFactor));
  //  petalTrigger = false;
  //}
  //timeCount--;
}


// uses the generated numbers to draw forms
void mandala()
{
  graphics.strokeWeight(12);
  
  graphics.stroke(strokeColor, mandalaAlpha);
  
  
  
  // draws some ellipses first
  
  //color1 = calcGradient(colorScheme[0], colorScheme[1]);
  //color1 = fftColor(gradColor[3], gradColor[4], 2);
  
  graphics.fill(color1, mandalaAlpha);
  //graphics.noFill();
  

  for (int i = 0; i < vertices.length; i++)  // iterates over the vertex array
  {
    if(vertices[i][1] <= -shift+15000)   // again only draws what is to seen on the screen
    {    
      graphics.ellipse(vertices[i][2], vertices[i][3],  vertices[i][4], vertices[i][5]+shift);
    }
  }

  
  // then draws bezier curves in a different color - which results in those nice sunflower patterns
  
  //color2 = calcGradient(colorScheme[1], gradColor[1]);
  //color2 = fftColor(gradColor[2], gradColor[3], 3);
  
  graphics.stroke(strokeColor);
  graphics.fill(color2, mandalaAlpha);
  //graphics.noFill();
    
  //graphics.beginShape();
  //graphics.vertex(0, 0);
  
  for (int i = 0; i < vertices.length; i+=2)
  {
    if(vertices[i][1] <= -shift+15000)
    {      
      graphics.beginShape();
      graphics.vertex(vertices[i][0], vertices[i][1]);
      graphics.bezierVertex(vertices[i][0], vertices[i][1],  vertices[i][2], vertices[i][3],  vertices[i][4], vertices[i][5]);
      graphics.bezierVertex(vertices[i+1][0], vertices[i+1][1],  vertices[i+1][2], vertices[i+1][3],  vertices[i+1][4], vertices[i+1][5]);
      graphics.endShape();  
    }
  }
  
  //graphics.vertex(0, vertices[vertices.length-1][5]);
  //graphics.endShape();  
}
