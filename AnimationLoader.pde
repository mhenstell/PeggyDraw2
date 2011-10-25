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
    //header = loadStrings("PeggyHeader.txt");
    //footer = loadStrings("PeggyFooter.txt");

  }
 
  AnimationFrames LoadAnimation(File file) {
    println("Loading animation from: " + file.getPath());
    
    // Create a new animation
    AnimationFrames animation = new AnimationFrames(cols, rows);
   
    BufferedReader reader = createReader(file);
    String line = "";
    String redLine = null;
    String greenLine = null;
    
    
    while (line != null) {
      try {
        
        line = reader.readLine();
        if (line.contains("R")) redLine = line;
        else if (line.contains("G")) greenLine = line;
        
      } catch (Exception e) {
        //e.printStackTrace(); 
      }
    }
   
    //println("red: " + redLine);
    //println("green: " + greenLine);
    
    animation.presetRed(redLine);
    //animation.presetGreen(greenLine);
    return animation;
  }
  
  void SaveAnimation(String filename, AnimationFrames animation) {
    // File object to write to
    PrintWriter output;

    println("Saving animation to: " + filename);
    // Open the file for writing
    output = createWriter(filename); 
    
    // First, write the header to the file
//    for (String line : header) {
//      output.println(line);
//    }
    
    // Maybe write out the number of frames here?
    output.println("unsigned int frameCount=" + animation.getFrameCount() + ";");
  
    // Write out a definition for a big 2d array of frames
    output.println("unsigned long redFrames[" + animation.getFrameCount() + "][" + cols + "]={");

    // Now, for each frame, write it's data as an array of longs.
    for (int frameNo = 0; frameNo < animation.getFrameCount(); frameNo++) {
      output.print("{");
      
      // Load the frame data
      int data[] = animation.getFrame(frameNo).getRedFrameData();
      
      // Make sure our frame is of the correct size
      if (rows*cols != data.length) {
        print("Error! Data size isn't right!");
        return;
      }

      // Handle the frame data, row by row.
      for (int i = 0; i < rows; i++) {
        long rowData = 0;
        
        for (int j = 0; j < cols; j++) {       
          if (data[i*cols + j] > 0)
          {
            rowData += (1 << j);
          }
        }
        
        output.print(rowData + ",");
      }
      
      output.print("},\n");
    }

    // close the array
    output.println("};");


    // Write out a definition for a big 2d array of frames
    output.println("unsigned long greenFrames[" + animation.getFrameCount() + "][" + cols + "]={");

    // Now, for each frame, write it's data as an array of longs.
    for (int frameNo = 0; frameNo < animation.getFrameCount(); frameNo++) {
      output.print("{");
      
      // Load the frame data
      int data[] = animation.getFrame(frameNo).getGreenFrameData();
      
      // Make sure our frame is of the correct size
      if (rows*cols != data.length) {
        print("Error! Data size isn't right!");
        return;
      }

      // Handle the frame data, row by row.
      for (int i = 0; i < rows; i++) {
        long rowData = 0;
        
        for (int j = 0; j < cols; j++) {       
          if (data[i*cols + j] > 0)
          {
            rowData += (1 << j);
          }
        }
        
        output.print(rowData + ",");
      }
      
      output.print("},\n");
    }

    // close the array
    output.println("};");

    // Write out the durations to display each frame
    output.print("unsigned long frameDurations[] = {");
    for (int frameNo = 0; frameNo < animation.getFrameCount(); frameNo++) {
      output.print(animation.getFrame(frameNo).getDuration() + ",");
    }
    output.print("};");
    
//    // Now, write the footer to the file
//    for (String line : footer) {
//      output.println(line);
//    }
    
    // Finally, make sure the file data is written and close the file.
    output.flush();
    output.close();
    
    
    output = createWriter(filename + "ARRAY");
    
    output.print("R");
    // Now, for each frame, write it's data as an array of longs.
    for (int frameNo = 0; frameNo < animation.getFrameCount(); frameNo++) {
      // Load the frame data
      int data[] = animation.getFrame(frameNo).getRedFrameData();
      for (int pixel : data) {
        output.print(pixel); 
      }
    }
    
    output.println("");
    output.print("G");
     // Now, for each frame, write it's data as an array of longs.
    for (int frameNo = 0; frameNo < animation.getFrameCount(); frameNo++) {
      // Load the frame data
      int data[] = animation.getFrame(frameNo).getGreenFrameData();
      for (int pixel : data) {
        output.print(pixel); 
      }
    }
    

    
    output.flush();
    output.close();
    
  }
}
