// required Libraries: "The MidiBus" and "Video"

import themidibus.*; 
import processing.video.*;

MidiBus myBus;
Movie dirt;


// start values for the control parameters

float shiftControl = 2.0;
float shiftFactor = shiftControl;
float rotationControl = 0.5;
float rotationFactor = rotationControl;
float starFactor = 200.0;
float lineSpread = 80.0;
float patternSpread = 700.0;
float dotSize = 10.0;

float patternAlpha = 255.0;
float mandalaAlpha = 1.0;


// some basic variables

int bufferWidth = 250;
int bufferHeight = 1000;
int timeCount = 0;
int numFacets = 24; 
float radius, rotation, shift;

float[][] vertices = new float[0][0];    // array that will contain the random generated vertex positions
PGraphics graphics;                      // graphic buffer

float tempo = 600.0;    // tempo to start with (in Milliseconds) - equals 100bpm    
int[] tap = new int[0];

//int[] colorScheme = {#f5100f, #ffcc00, #005066, #ffffff}; // ORIGINAL!
//int[] colorScheme = {#ffa600, #9361ff, #000000, #ffffff};
int[] colorScheme = {#f6a410, #e25612, #544193, #ffffff};
//int[] colorScheme = {#fec404, #e30713, #544193, #ffffff};
//int[] gradColor = {#393686, #ad87bd};
int[] gradColor = {#393686, #5959a4};
//int[] gradColor = {#2a377c, #50529f};
int color1 = colorScheme[0];
int color2 = colorScheme[1]; 
int bgcolor = gradColor[0];
int tgtcolor = gradColor[1];
int strokeColor = colorScheme[3];
int strobeTime = 10;
float lerpCounter = 0.0;


// some toggles

boolean mandalaOn = true;
boolean starsOn = false;
boolean dotsOn = false;
boolean spiral = false;
boolean strobeOn = false;

boolean record = false;

float colorBeatTrigger;
boolean colorBeat = false;

float zoomTrigger;
boolean zoom = false;

float twistTrigger;
boolean twist = false;

boolean displayBuffer = false;
boolean displayMIDI = false;
boolean showFPS = false;



void setup() 
{  
  //fullScreen(P2D, 2);        // show in fullScreen - with a SECOND PARAMETER a screen can be addressed. has to be set if there are multiple screens to choose from
  size(1280, 720, P2D);
  //frameRate(25);
    
  
  myBus = new MidiBus(this, 2, 0);    // sets the MIDI in/out device - the second parameter is the input. choose the right device from the list
  MidiBus.list();    // logs all available MIDI ins/outs
 
 
  rotation = 0;
  shift = 0;
  
  textureMode(NORMAL);
  radius = sqrt(sq(width/2)+sq(height/2))*1.01;   // +1% to be sure it overlaps the screen entirely ;)

  vertices = (float[][])append(vertices, new float[]{0, 0,  50, 5, bufferWidth, 10} );    // add a first vertex to the array
  
  dirt = new Movie(this, "filmgrain.mov");    // a video-file with film grain and dirt - to emulate an analogue texture and add grit/character to the graphics 
  dirt.loop();
  
  // create graphic buffer
  graphics = createGraphics(bufferWidth, bufferHeight);
}



void draw() 
{
  background(0);
  noStroke();
  
  
  // calls the modules/functions
  randomGenerator();
  graphicBuffer();
  switchColorsOnBeat();
  zoomIn();
  twistIn();
  strobe();
  
  
  push();
  translate(width/2, height/2);
  
  rotate(rotation*0.005);
  
  
  // kaleidoscope script by Prof. Lena Gieseke :)
  beginShape(TRIANGLE_FAN);
  

  // The angle of one facet
  // (at the center point of the kaleidoscope)
  float angleFacets = radians(360.0/numFacets);
  
  texture(graphics);

  // Center of the triangle fan
  vertex(0, 0, 0.5, 0);

  // Draw the triangles around the center
  for (int i = 0; i < numFacets; i++)
  {  
      // The first vertex of the triangel on
      // the circumference of the kaleidoscope
      float x1 = cos(angleFacets*i) * radius;
      float y1 = sin(angleFacets*i) * radius;

      // The second vertex of the triangel 
      float x2 = cos(angleFacets*(i+1)) * radius;
      float y2 = sin(angleFacets*(i+1)) * radius;

      if (i % 2 == 0)
      {
          vertex(x1, y1, 0, 1);
          vertex(x2, y2, 1, 1);
      }
      // every other facet the texture 
      // or better its uvs should be 
      // switched horizontally
      else if(spiral)
      {
          vertex(x1, y1, 0, 0);
          vertex(x2, y2, 1, 0);
      }
      else
      {
          vertex(x1, y1, 1, 1);
          vertex(x2, y2, 0, 1);
      }
  }
  endShape();
  
  pop();
  
  
  // displays the graphic buffer - for debugging purposes 
  if(displayBuffer)
  {
    stroke(0);
    rect(0, 0, 100, 500);
    image(graphics, 0, 0);
  }
  
  // logs framerate
  if(showFPS)
  {
    println("FPS: " + frameRate);
  }
  
  // adds a constant rotation to the triangle fan - the strength can be controlled via the rotationFactor
  rotation = rotation+rotationFactor;
  
  // shifts the graphic buffer constantly down the y-axis - creates the inward drag in the visuals
  shift = shift+shiftFactor;
  
  if(record)
  {
    saveFrame("output/grab_####");
    fill(0);
    ellipse(width-50, height-50, 20, 20);
  }
  
  //println(timeCount);
}
