# Galaxy-Sound-Engine

![GalaxySoundEngine](https://github.com/juhani-vainio/Galaxy-Sound-Engine/blob/master/SoundEngine/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5%402x.png)

### What is it?
The Galaxy Sound Engine is a multi-effects sound processing app.</br>
It is developed with the [AudioKit](https://audiokit.io/) framework for what is essentially a "Guitar Multi-Effects Pedal".</br>
The idea is to allow the user (the musician) to add multiple effects to a signal for exploring and creating new sounds.</br>

![SoundEngine_UI](https://github.com/juhani-vainio/Galaxy-Sound-Engine/blob/master/SoundEngine_UI.PNG)

### Features include:
<ol>
<li>Switch between Equalizers 
  <ul>
    <li>3-band EQ</br>
    Treble / Middle / Bass
    </li>
    <li>7-band EQ</br>
    Brilliance / Precence / High / Middle / Low / Bass / Sub Bass 

  </ul>
  </li>
<li>Add/remove Effects
  <ul>
<li>Chorus</li>
<li>Costello Reverb</li>
<li>Delay</li>
<li>Distortion</li>
<li>Flanger</li>
<li>Phaser</li>
<li>Reverb</li>
<li>Screamer</li>
<li>String Resonator</li>
<li>Tremolo</li>
<li>Auto Wah Wah</li>
</ul>
  </li>
<li>Switch on/off Filters
  <ul>
  <li>Low cut</li>
   <li>High cut</li>
    <li>Noise gate</li>
  </ul>
  </li>
<li>Save/remove SOUNDS consisting of:
  <ul>
  <li>The EQ (3or7) settings</li>
   <li>The effects that are ON</li>
    <li>The effects settings</li>
    <li>Filters</li>
  </ul>
  </li>
<li>Select sounds from the list of saved sounds</li>
<li>Adjust Volume levels
  <ul>
  <li>Master Volume</li>
   <li>Input Level</li>
    <li>Output Level</li>
  </ul>
  </li>
<li>Monitors
  <ul>
    <li>Tuner</li>
    <li>Waveform graph for input & output</li>
  </ul>
  </li>
  <li>Settings
  <ul>
    <li>Change buffer lenght</li>
    <li>Switch UI color theme</li>
  </ul>
  </li>
</ol>

### Current working setup
Electric Guitar -> Audio Cable -> iRig2 -> iPad 2018 -> Headphones or Audio Cable Plugged to an Amp </br></br>
![SoundEngine_Setup](https://github.com/juhani-vainio/Galaxy-Sound-Engine/blob/master/Sound_Engine_Setup.jpg)

### Made with [AudioKit](https://audiokit.io/)


### Development issues
This is still an ongoing project, and I'm still learning iOS development with XCode and Swift. Starting this project, I had previously made only 2 iOS applications. </br>
<ol><li>AudioKit has more</br>
AudioKit offers way more effects and filters than what is currently available in the working version of this app. I'm not an expert in audio signal processing and not an expert audio engineer to understand everything offered. I did play and try to work with everything offered but had to drop plenty of cool thins just because they didn't make any sense for a regular chap like me.
</li>
  <li>Rearranging effects</br>
  This would actually be possible to allow the user to drag and drop effects on the list. This might be interesting for the musician to test how the audio output changes depending on the order of the effects applied to the signal. This was implemented into the app but the feature is currently dropped from the working version.</br>
  Reason being that it sometimes caused unexpected problems for the design of the audio signal. Also one major drawback was that whenever the effects needed to be rearranged, the Audiokit engine had to be stopped and rebuilt, which takes some time and resulted in a gap in the audio output.
  </li>
  <li>Effects tableview design</br>
  The idea was to make one tableviewcell that could be reused for all effects. Not designed well enoughy, and my hurry to get to testing the effects with my guitar, I eneded up making multiple cells that differ only by the number of sliders in them. This then ofcourse adds repetitive extra lines of code to the tableview controller.
  </li>
  <li>Messy Storyboard</br>
  The frame hierarchy for the app is not that bad actually. The UI elements are organized to frames that can be rearranged on the main screen. However, somehow when you look at the storyboard visually it looks messy. I'm not happy in the way it ended up as this would propably be a nightmare scenario for another developer to have a look at. 
</li>
<li>Color themes</br>
I havent figured out yet what kind of color theme to implement in the final design. For this reason and for learning Swift programming purposes, you can change the UI color themes by selecting segments from what looks like an empty Segmented Controller. Note that some of the color themes won't make any sense but are there just for the heck of it.
  </li>
  </ol>
  
# Buid and Test with Caution!
If you want to build this and test with your own device, remember that this is an audio signal processing app with multiple, multiple ways to increase the VOLUME!!! So start easy and be careful not to cause harm.</br>
### There may be annoying hizz sounds occuring
### Really annoying feedback sounds if you are not plugged in
