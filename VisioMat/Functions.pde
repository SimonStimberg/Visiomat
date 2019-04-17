// stroboscope - fast changing of colors

void strobe()
{
  if(strobeOn)
  {
    if(strobeTime == 0)
    {
      int store = color1;
      color1 = color2;
      color2 = store;
      strobeTime = 5;
    }
    strobeTime--;
  }
}



// switches the two main colors (red and yellow) once

void switchColorsOnce()
{
  int store = color1;
  color1 = color2;
  color2 = store;
  //color2 = bgcolor;
  //bgcolor = store;
}



// switches the colors on the beat

void switchColorsOnBeat()
{
  if (colorBeat && !strobeOn)
  {
    if(millis() >= colorBeatTrigger)
    {
      switchColorsOnce();
      colorBeatTrigger = colorBeatTrigger + tempo;
    }
  }
}



// function to tap (determine) the tempo of a song

void tapTempo()
{ 
  
  // at least two taps are required for measurement
  if(tap.length >= 2)
  {
    
    // calculate average time interval
    tempo = 0.0;
    for(int i=1; i<tap.length; i++)
    {
      tempo += tap[i]-tap[i-1];      
    }
    tempo = tempo / (tap.length - 1);
    
    float bpm = round(600000 / tempo) * 0.1;
    println("Tempo: " + bpm + " bpm / " + tempo + " ms");
  }
}



// zooms in with an ease in/out - results in a "breathing effect"
// the motion has a duration of 2 beats (1 beat = tempo)

void zoomIn()
{
  if(zoom)
  {
    if (zoomTrigger-millis() >= tempo)
    {
      shiftFactor = lerp(shiftFactor, shiftControl, 0.1);  // accelerates over 1 beat
    }
    else if (zoomTrigger-millis() < tempo)
    {
      shiftFactor = lerp(shiftFactor, 1.0, 0.1);    // slows down over 1 beat
    }
    
    if(millis() >= zoomTrigger)
    {
      zoomTrigger = zoomTrigger + tempo*2;  // sets the trigger for the next movement
    }
  }
  else
  {
    shiftFactor = lerp(shiftFactor, shiftControl, 0.1);  // if the zoom function is deactivated return to the speed determined by the controller
  }
}



// a twist effect - similar to the zoom effect only in rotation

void twistIn()
{
  if(twist)
  {
    if (twistTrigger-millis() >= tempo)
    {
      rotationFactor = lerp(rotationFactor, rotationControl, 0.2);
    }
    else if (twistTrigger-millis() < tempo)
    {
      rotationFactor = lerp(rotationFactor, 1.0, 0.2);    
    }
    
    if(millis() >= twistTrigger)
    {
      twistTrigger = twistTrigger + tempo*2;
    }
  }
  else
  {
    rotationFactor = lerp(rotationFactor, rotationControl, 0.2);
  }
}
