// stroboscope - fast changing of colors

void strobe()
{
  if(strobeOn)
  {
    if(strobeTime == 0)
    {
      //int store = color1;
      //color1 = color2;
      //color2 = store;
      switchColorsOnce();
      strobeTime = 5;
    }
    strobeTime--;
  }
}



// switches the two main colors (red and yellow) once

void switchColorsOnce()
{
  //int store = color1;
  //color1 = color2;
  //color2 = store;
  colorIndex = (colorIndex==2) ? 0 : colorIndex+1;
  
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
    newTempo = 0.0;
    for(int i=1; i<tap.length; i++)
    {
      newTempo += tap[i]-tap[i-1];      
    }
    newTempo = newTempo / (tap.length - 1);
    
    float bpm = round(600000 / newTempo) * 0.1;
    println("Tempo: " + bpm + " bpm / " + newTempo + " ms");
  }
}

void globalBeat()
{
  //myBus.sendNoteOn(0, 16, 0);
  if(millis() >= globalBeat)
  {    
    globalBeat = globalBeat + tempo;
    if(globalBeatCount == 4) { globalBeatCount = 0; }
    globalBeatCount++;
      //println("Beat " + globalBeatCount);
    int cntrl = (globalBeatCount==1) ? 3 : 1;
    cntrl = (globalBeatCount==3) ? 5 : cntrl;
    myBus.sendNoteOn(0, 23, cntrl);  

    petalCreator();
  }
   
  
}


void petalCreator()
{
        
  if( (petalBeat != 0) && ((globalBeatCount+3) % petalBeat == 0) )
  {
    randomGenerator();  
    //println("jetze");
  }
  //randomGenerator();

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


int fftColor(int c1, int c2, int band)
{
  float scaledFFT = sum * 50.0;
  //println("fft-value for band " + band + " is: " + scaledFFT);
  //println("sum: " + scaledFFT);
  return lerpColor(c1, c2, volume);

}


void padColor(boolean kill)
{
  
  if(!kill)
  {
    int cntrl;
      
    // facet controls
    cntrl = (numFacets==24) ? 3 : 1;
    myBus.sendNoteOn(0, 32, cntrl);
    cntrl = (numFacets==18) ? 3 : 1;
    myBus.sendNoteOn(0, 33, cntrl);
    cntrl = (numFacets==48) ? 3 : 1;
    myBus.sendNoteOn(0, 34, cntrl);
    
    cntrl = (petalBeat==1) ? 3 : 1;
    myBus.sendNoteOn(0, 37, cntrl);
    cntrl = (petalBeat==2) ? 3 : 1;
    myBus.sendNoteOn(0, 38, cntrl);
    cntrl = (petalBeat==4) ? 3 : 1;
    myBus.sendNoteOn(0, 39, cntrl);
    
    // beat effects
    cntrl = (colorBeat) ? 3 : 1;
    myBus.sendNoteOn(0, 0, cntrl);  
    cntrl = (zoom) ? 3 : 1;
    myBus.sendNoteOn(0, 1, cntrl);
    cntrl = (twist) ? 3 : 1;
    myBus.sendNoteOn(0, 2, cntrl);  
    
    // strobe
    cntrl = (strobeOn) ? 3 : 1;
    myBus.sendNoteOn(0, 7, cntrl);
    
    // change colors once
    myBus.sendNoteOn(0, 24, 5);
    // fader button
    myBus.sendNoteOn(0, 5, 5);
  }
  else
  {
    for(int i=0; i<=39; i++)
    {
      myBus.sendNoteOn(0, i, 0);      
    }
  }

}
