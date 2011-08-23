/*   
 if ( buttonSave.over ) {  //Save output file
 String comma = ",";
 
 for (int i = 0; i < rows; i++) {
 // Begin loop for rows
 rowdata = 0;
 for (int j = 0; j < cols; j++) {
 
 if (GrayArray[i*cols + j] > 0)
 {
 rowdata += (1 << j);  
 }
 }
 
 if (i == (rows - 1))
 header = append(header, str(rowdata));
 else
 header = append(header, str(rowdata) + ',');
 }
 FileOutput = concat(header, footer);
 
 File outputDir = new File(sketchPath, "PeggyProgram"); 
 if (!outputDir.exists()) 
 outputDir.mkdirs(); 
 
 saveStrings("PeggyProgram/PeggyProgram.pde", FileOutput);   
 //Note: "/" apparently works as a path separator on all operating systems.
 
 for (int j = 0; j < rows; j++) {
 for (int i = 0; i < cols; i++) { 
 
 }
 }
 }
 */
 
 

class AnimationLoader
{
  String[] header;
  String[] footer;
  /*
  String[] RowData;

  String[] FileOutput; 
  String[] OneRow; 
  */

  AnimationLoader() {
    // Load any constant strings here
    header = loadStrings("PeggyHeader.txt");
    footer = loadStrings("PeggyFooter.txt");

  }
 
  AnimationFrames LoadAnimation(String filename) {
    println("Loading animation from: " + filename);
    
    // Create a new animation
    AnimationFrames animation = new AnimationFrames(cols, rows);
    
    // For demonstration: let's make a generative animation with this many frames
    int demoAnimationFrameCount = 2;
    
    
    int i = 0;
    
    // Repeat while there are still frames to load
    while(i < demoAnimationFrameCount) {
      
      // For demonstration: buld a fake frame
      int[] frameData = new int[rows*cols];
      for (int j = 0; j < frameData.length; j++) {
        frameData[j] = (i + j) % 2;
      }
      int duration = i;
      
      // Add the frame to the end of our animation
      animation.addFrame(new AnimationFrame(cols, rows, frameData, duration), animation.getFrameCount());
     
      // For demonstration: advance to next fake frame
      i++;
    }
    
    return animation;
  }
  
  void SaveAnimation(AnimationFrames animation) {


    println("Saving animation");

    // Now, for each frame, write it's data as an array of longs.
    for (int frameNo = 0; frameNo < animation.getFrameCount(); frameNo++) {
      
      // Load the frame data
      int data[] = animation.getFrame(frameNo).getFrameData();
      
      // Make sure our frame is of the correct size
      if (rows*cols != data.length) {
        print("Error! Data size isn't right!");
        return;
      }
      
      PImage img = createImage(16, 16, ALPHA);
      img.loadPixels();
      
      // Handle the frame data, row by row.
      for (int i = 0; i < rows; i++) {
        long rowData = 0;
        
        for (int j = 0; j < cols; j++) {       
          if (data[i*cols + j] > 0)
          {
            img.pixels[i*cols + j] = color(255);
          }
        }
      }
      
      img.updatePixels();
      String filename = "animation/" + "frame" + (frameNo + 1) + ".png";
      img.save(filename);

      //output.print("},\n");
    }

   
    
    

  }
}
