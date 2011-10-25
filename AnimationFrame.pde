
// A collection of image frames, therefore an animation.
class AnimationFrames
{
  private ArrayList<AnimationFrame> frames;     // List of all of the frames
  private int current;          // Current frame
  
  protected int width;
  protected int height;
  
  AnimationFrames(int width, int height)
  {
    this.width = width;
    this.height = height;
    
    frames = new ArrayList<AnimationFrame>();
  }
  
  AnimationFrame getCurrentFrame() {
    return frames.get(current);
  }
  
  AnimationFrame getFrame(int frameNo) {
    return frames.get(frameNo);
  }
    
  void replaceCurrentFrame(AnimationFrame ref) {
    frames.set(current, new AnimationFrame(ref));
  }

  int getFrameCount() {
    return frames.size();
  }

  int getCurrentPosition() {
    return current;
  }
  
  void setCurrentPosition(int position) {
    if (position < getFrameCount() && position >= 0) {
      current = position;
    }
  }

  void addFrame(AnimationFrame frame, int position) {
    // TODO: do we need to check that the position is in range?
    
    frames.add(position, frame);
    
    current = position;
  }
  
  void removeFrame(int position) {
    frames.remove(position);
    
    // If we have deleted all of the frames, make a new blank one to be friendly.
    if (frames.size() == 0) {
//      addFrame(0);
    }
    
    // If the current frame is now invalid, select one that is.
    if (current >= frames.size()) {
      current = frames.size() - 1;
    }
  }
  
  void presetRed(String redString) {
    
    redString = redString.replace("R", "");
    int numFrames = redString.length() / (cols*rows);
    println ("Number of frames: " + numFrames);
    

    
    for (int x=0; x < numFrames; x++) {
      //String frame = redString.substring(numFrames * (cols*rows), (numFrames * (cols*rows)) + (cols*rows));
      println("Frame: " + x);
      int beg = x * (cols*rows);
      int end = (x * (cols*rows)) + (cols*rows);
      String frameString = redString.substring(beg, end);
      
      AnimationFrame frame = new AnimationFrame(cols, rows);
      
      for (int i=0; i < cols; i++) {
        for (int q=0; q < rows; q++) {
          frame.setPixel(i, q, 1);
        } 
      }
      
      this.addFrame(frame, x);
      this.setCurrentPosition(this.getCurrentPosition() + 1);

    }    
    
    
  }
  
  void presetGreen(String greenString) {
    greenString = greenString.replace("G", "");
    //println("Green: " + greenString);
    
  }
  
  
}
  
// A single image frame
class AnimationFrame
{
  int width;
  int height;
  int duration;
  int frameDataRed[];
  int frameDataGreen[];
  
  int defaultDuration = 100;

  AnimationFrame(AnimationFrame ref) {
    width = ref.width;
    height = ref.height;
    duration = ref.duration;
    
    this.frameDataRed = ref.frameDataRed.clone();
    this.frameDataGreen = ref.frameDataGreen.clone();
  }
  
//  AnimationFrame(int width, int height, int[] frameData, int duration) {
//    if (width * height != frameData.length) {
//      // error
//    }
//    
//    this.width = width;
//    this.height = height;
//    this.duration = duration;
//    
//    this.frameData = frameData.clone();
//  }
  
  AnimationFrame(int width, int height) {
    this.width = width;
    this.height = height;
    this.duration = defaultDuration;
    
    frameDataRed = new int[height*width];
    frameDataGreen = new int[height*width];
    
    presetRed(0);
    presetGreen(0);
  }
  
  // TODO: is this a good thing to provide?
  void presetRed(int value) {
    for(int i = 0; i < height*width; i++) {
      frameDataRed[i] = value;
    }
  }
  
  void presetGreen(int value) {
    for(int i = 0; i < height*width; i++) {
      frameDataGreen[i] = value;
    }
  }
  
  void preset(int value) {
    for(int i = 0; i < height*width; i++) {
      frameDataRed[i] = value;
      frameDataGreen[i] = value;
    }
  }
  
  int getPixelRed(int x, int y) {
    if (x < width && y < height) {  
      return frameDataRed[y*width+x];
    }
    
    // out of bounds, just fail silently.
    return 0;
  }
  
  int getPixelGreen(int x, int y) {
    if (x < width && y < height) {  
      return frameDataGreen[y*width+x];
    }
    
    // out of bounds, just fail silently.
    return 0;
  }
  
  int getPixel(int x, int y) {
    if (x < width && y < height) {  
      return frameDataRed[y*width+x] + ( 2 * frameDataGreen[y*width+x] );
    }
    
    // out of bounds, just fail silently.
    return 0;
  }

  void setPixel(int x, int y, int value) {
    // if we were out of bounds, just fail silently.
    if (x < width && y < height) {  
      switch (value) {
        case 0:
          frameDataRed[y*width+x] = 0;
          frameDataGreen[y*width+x] = 0;
          break;
        case 1:
          frameDataRed[y*width+x] = 1;
          frameDataGreen[y*width+x] = 0;
          break;
        case 2:
          frameDataRed[y*width+x] = 0;
          frameDataGreen[y*width+x] = 1;
          break;
        case 3:
          frameDataRed[y*width+x] = 1;
          frameDataGreen[y*width+x] = 1;
          break;
      }
    }
  }
  
  int getDuration() {
    return duration;
  }
  
  void setDuration(int duration) {
    this.duration = duration;
  }
  
  int[] getFrameData() {
    return (int[])frameDataRed.clone();
  }
  
  int[] getRedFrameData() {
     return (int[]) frameDataRed.clone();
  }
  
  int[] getGreenFrameData() {
     return (int[]) frameDataGreen.clone();
  }
  
  void shiftUp() {
    for (int x=0; x < cols; x++) {
      for (int y=1; y < rows; y++) {
        int value = getPixel(x, y);
        setPixel(x, y-1, value);
      } 
      setPixel(x, rows-1, 0);
    }
  }
  
  void shiftDown() {
   for (int x=cols-1; x >= 0; x--) {
      for (int y=rows-1; y >= 0; y--) {
        int value = getPixel(x, y);
        setPixel(x, y+1, value);
      } 
      setPixel(x, 0, 0);
    }
  }
  
  void shiftLeft() {
    
    for (int x=1; x < cols; x++) {
      for (int y=0; y < rows; y++) {
        int value = getPixel(x, y);
        setPixel(x-1, y, value);
      }
    }
    for (int y=0; y < rows; y++) {
      setPixel(cols-1, y, 0);
    }
  }
  

  
  void shiftRight() {
     for (int x=cols-1; x >= 0; x--) {
      for (int y=rows-1; y >= 0; y--) {
        int value = getPixel(x, y);
         setPixel(x+1, y, value);
      } 
    }
    for (int y=0; y < rows; y++) {
      setPixel(0, y, 0);
    }
  }
  
  
}
