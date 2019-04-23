// CONTROLLER CONFIGURATION
// this configuration is mapped to the Akai APC KEY25 MIDI controller 


void noteOn(int channel, int pitch, int velocity) {
  
  
  // toggle numbers of facets
  if(pitch==32)
  {
    numFacets=24;

    padColor(false);
  }
  if(pitch==33)
  {
    numFacets=18;
    
    padColor(false);
  }
  if(pitch==34)
  {
    numFacets=48;
    
    padColor(false);
  }
  
  // un-mirror facets for "spiral-effect"
  //if(pitch==35)
  //{
  //  spiral = !spiral;
  //}

  
  
  // toggle forms on/off  
  //if(pitch==37)
  //{
  //  mandalaOn = !mandalaOn;
  //}
  //if(pitch==38)
  //{
  //  dotsOn = !dotsOn;
  //}
  //if(pitch==39)
  //{
  //  starsOn = !starsOn;
  //  //if(starsOn)
  //  //{
  //  //  numFacets=48;   // switch to more facets to make the lines appear more round
  //  //}
  //}

  // toggle background color
  //if(pitch==30)
  //{
  //  bgcolor = colorScheme[0];
  //}
  
  //if(pitch==31)
  //{
  //  bgcolor = colorScheme[2];
  //}
  
 
  
  
  // switch colors an the beat
  if(pitch==0)
  {    
    colorBeatTrigger = millis() + tempo - tempo/8; // substract a 8th to compensate the controller latency (~65ms)
    colorBeat = !colorBeat;    
    padColor(false);
    
    if(colorBeat)
    {
      switchColorsOnce();
    }
  }
 
  
  // toggle & trigger ZoomIn-Effect 
  if(pitch==1)
  {
    zoomTrigger = millis() + tempo*2 - tempo/8; // substract a 8th to compensate the controller latency (~65ms)
    zoom = !zoom;
    padColor(false);    
  }
  
  
  // toggle & trigger Twist-Effect 
  if(pitch==2)
  {
    twistTrigger = millis() + tempo*2 - tempo/8; // substract a 8th to compensate the controller latency (~65ms)
    twist = !twist;    
    padColor(false);
  }
  
  
  // switch color once
  if(pitch==24)
  {
    switchColorsOnce();
  }
  
  
  // strobe effect (
  if(pitch==7)
  {
    strobeOn = !strobeOn;
    padColor(false);
  }

  
  // fade to/from black
  if(pitch==5)
  {
    fadeTrigger = true;  
    fadeTarget = (fadeTarget == 255.0) ? 0.0 : 255.0;
  }

  
  // spawn new mandala/petals on every beat (or on 1+3 or only on 1)
  if(pitch==37)
  {
    petalBeat = (petalBeat != 1) ? 1 : 0;
    padColor(false);
  }
  if(pitch==38)
  {
    petalBeat = (petalBeat != 2) ? 2 : 0;
    padColor(false);
  }
  if(pitch==39)
  {
    petalBeat = (petalBeat != 4) ? 4 : 0;
    padColor(false);
  }

  
  
  
  // Tap Tempo
  if(pitch==98)
  {
    int now = millis();
    
    // reset tapper if no tap happened for over 2 seconds
    if(tap.length >= 2 && (tap[tap.length-1] - tap[tap.length-2]) > 2000)
    {
      tap = new int[0];
      println("Tap array cleared");     
    }
        
    tap = append(tap, now);
    tapTempo();
  }
  
  if(pitch==91)
  {
    tempo = newTempo;
    globalBeat = millis() + tempo - tempo/8; // substract a 8th to compensate the controller latency (~65ms)
    globalBeatCount = 1;
    petalCreator();
  }
  
  if(pitch==93)
  {
    //petalTrigger = true;
    randomGenerator();
  }
  


  // FOR CONFIGURATION - display MIDI buttons (note ons)
  if(displayMIDI)
  {
    println();
    println("Note On:");
    println("--------");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
  }
}




void controllerChange(int channel, int number, int value) {

  
  if(number==48)
  {
    shiftControl = map(value, 0, 127, 1.0, 12.);    // speed of shifting (inward drag)
  }
 
  if(number==49)
  {
    rotationControl = map(value, 0, 127, 0.5, 6.);  // speed of rotation
  }
  
  if(number==50)
  {
    lineSpread = map(value, 0, 127, 25., 80.);    // thickness of the star-lines
  }
  
  if(number==51)
  {
    starFactor = map(value, 0, 127, 0., 200.);    // amount how much the lines being tilted (resulting in star pattern) 
  }
  
  if(number==52)
  {
    mandalaAlpha = map(value, 0, 127, 0., 255.);    // amount how much the lines being tilted (resulting in star pattern) 
  }
  
  if(number==53)
  {
    starAlpha = map(value, 0, 127, 0., 255.);    // amount how much the lines being tilted (resulting in star pattern) 
  }
  
  if(number==54)
  {
    dotAlpha = map(value, 0, 127, 0., 255.);    // amount how much the lines being tilted (resulting in star pattern) 
  }

  if(number==55)
  {
    patternSpread = map(value, 0, 127, 400.0+bufferHeight , 250.);  // distribution of the dots and stars over the screen
  }
  
  //if(number==55)
  //{
  //  dotSize = map(value, 0, 127, 7., 15.);    // dot size
  //}
  

    
  // FOR CONFIGURATION - display MIDI knobs (controller change)     
  if(displayMIDI)
  {
    println();
    println("Controller Change:");
    println("--------");
    println("Channel:"+channel);
    println("Number:"+number);
    println("Value:"+value);
  }
}




// FOR DEBUGGING
void keyPressed()
{  
  // display graphic buffer
  if (key == 'd')
  {    
    displayBuffer = !displayBuffer;
  }
  // display MIDI signals
  if (key == 'm')
  {    
    displayMIDI = !displayMIDI;
  }
  // display frame rate => to estimate Performance
  if (key == 'f')
  {
    showFPS = !showFPS;
  }
    if (key == 'q')
  {
    record = !record;
  }
}
