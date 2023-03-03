import processing.serial.*;
import controlP5.*;
import static javax.swing.JOptionPane.*;
import javax.swing.JDialog;

Serial arduinoPort;
ControlP5 cp5;

String textValue = "";

final boolean debug = true;

Knob lFoot;
Knob lThigh;
Knob rFoot;
Knob rThigh;

Textfield rt;
Textfield lt;
Textfield lf;
Textfield rf;


 int servo1;
 int servo2;
 int servo3;
 int servo4;


void setup() {
  background(color(0,0,0));
    size(550,320);
   surface.setTitle("Arduino Servo Serial Controller");  

////////////////------------------------------- Find out which port the Arduino is plugged into
String COMx, COMlist = "";
  JDialog frame = new JDialog();
  try {
    if(debug) printArray(Serial.list());
    int i = Serial.list().length;
    if (i != 0) {
      if (i >= 2) {
        // need to check which port the inst uses -
        // for now we'll just let the user decide
        for (int j = 0; j < i;) {
          COMlist += char(j+'a') + " = " + Serial.list()[j];
          if (++j < i) COMlist += ",  ";
        }
        JDialog dialog = new JDialog(); 
        dialog.setAlwaysOnTop(true); 
        COMx = showInputDialog(dialog, "Which COM port...\n"+COMlist);
        if (COMx == null) exit();
        if (COMx.isEmpty()) exit();
        i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
      }
      String portName = Serial.list()[i-1];
      if(debug) println(portName);
      arduinoPort = new Serial(this, portName, 9600); // change baud rate to your liking
      arduinoPort.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
    }
    else {
      showMessageDialog(frame,"Device is not connected to the PC");
      exit();
    }
  }
  catch (Exception e)
  { //Print the type of error
    showMessageDialog(frame,"COM port is not available (may\nbe in use by another program)");
    println("Error:", e);
    exit();
  }
/////////////////////////////------------------ Set up the CP5 Objects
  
  
  cp5 = new ControlP5(this);
  /////////////-------------- KNOBS ---------------------
  lThigh = cp5.addKnob("Left_Thigh")
               .setRange(0,180)
               .setValue(90)
               .setPosition(20,20)
               .setRadius(60)
               .setDragDirection(Knob.HORIZONTAL)
               .setLabel("Left Thigh")
               .setNumberOfTickMarks(180)
               .setTickMarkLength(1)
               .snapToTickMarks(true)
               .hideTickMarks()
               ;
                     
  lFoot = cp5.addKnob("Left_Foot")
               .setRange(0,180)
               .setValue(90)
               .setPosition(150,20)
               .setRadius(60)
               .setDragDirection(Knob.HORIZONTAL)
               .setLabel("Left Foot")
               .setNumberOfTickMarks(180)
               .setTickMarkLength(1)
               .snapToTickMarks(true)
               .hideTickMarks()
               ;
               
  rThigh = cp5.addKnob("Right_Thigh")
               .setRange(0,180)
               .setValue(int(90))
               .setPosition(280, 20)
               .setRadius(60)
               .setDragDirection(Knob.HORIZONTAL)
               .setLabel("Right Thigh")
               .setNumberOfTickMarks(180)
               .setTickMarkLength(1)
               .snapToTickMarks(true)
               .hideTickMarks()
               ;
                     
  rFoot = cp5.addKnob("Right_Foot")
               .setRange(0,180)
               .setValue(90)
               .setPosition(410,20)
               .setRadius(60)
               .setDragDirection(Knob.HORIZONTAL)
               .setLabel("Right Foot")
               .setNumberOfTickMarks(180)
               .setTickMarkLength(1)
               .snapToTickMarks(true)
               .hideTickMarks()
               ;
               
  ////////////////-----------------------TEXT FIELDS----------------------             
   PFont font = createFont("arial",20);
  
    lt = cp5.addTextfield("LT")
         .setFont(createFont("arial",40))
         .setSize(60,40)
         .setPosition(50,170)
         .setAutoClear(false)
         .setText("90")
         ; 
     
     lf = cp5.addTextfield("LF")
         .setFont(createFont("arial",40))
         .setSize(60,40)
         .setPosition(179,170)
         .setAutoClear(false)
         .setText("90")
         ; 
     
    rt = cp5.addTextfield("RT")
         .setFont(createFont("arial",40))
         .setSize(60,40)
         .setPosition(310,170)
         .setAutoClear(false)
         .setText("90")
         ;  
     
     rf = cp5.addTextfield("RF")
         .setFont(createFont("arial",40))
         .setSize(60,40)
         .setPosition(440,170)
         .setAutoClear(false)
         .setText("90")
         ;      
                 
  cp5.addTextfield("Command")
     .setPosition(50,240)
     .setSize(200,40)
     .setFont(createFont("arial",20))
     .setAutoClear(false)
     .setLabel("Manual Command")
     ;
       
  cp5.addBang("reset")
     .setPosition(420,240)
     .setSize(80,40)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;  
     
     cp5.addBang("send")
     .setPosition(275,240)
     .setSize(120,40)
     .setCaptionLabel("Send All Positions") 
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     
     ;
       
  textFont(font);
  
  cp5.getController("LT").getCaptionLabel().setVisible(false);
  cp5.getController("LF").getCaptionLabel().setVisible(false);
  cp5.getController("RT").getCaptionLabel().setVisible(false);
  cp5.getController("RF").getCaptionLabel().setVisible(false);
  
 
}

void draw() {
 

}


void controlEvent(ControlEvent theEvent) {
 // println(theEvent.getName());
 servo1 = int(lThigh.getValue());
 servo2 = int(lFoot.getValue());
 servo3 = int(rThigh.getValue());
 servo4 = int(rFoot.getValue());
 
 String val;      
  
  switch(theEvent.getName()) {
   
    case "Right_Thigh":
        rt.setText(str(servo3));
    break;
     case "Left_Thigh":
        lt.setText(str(servo1));
    break;
     case "Right_Foot":
        rf.setText(str(servo4));
       
    break;
     case "Left_Foot":
        lf.setText(str(servo2));
    break;
    /////----Text Boxes
    case "LF":
          val = lf.getText();
          lFoot.setValue(float(val));
          arduinoPort.write("2:"+servo2);
          println("Left Foot moving to position: " +str(servo2));
    break;
    case "RF":
          val = rf.getText();
          rFoot.setValue(float(val));
          arduinoPort.write("4:"+servo4);
        println("Right Foot moving to position: " +str(servo4));
    break;
    case "RT":
          val = rt.getText();
          rThigh.setValue(float(val));
           arduinoPort.write("3:"+servo3);
        println("Right Thigh moving to position: " +str(servo3));
    break;
    case "LT":
          val = lt.getText();
          lThigh.setValue(float(val));
          arduinoPort.write("1:"+servo1);
          println("Left Thigh moving to position: " +str(servo1));
    break;
    //////---- Send Button
     case "send":
          val = lf.getText();
          lFoot.setValue(float(val));
     
          val = rf.getText();
          rFoot.setValue(float(val));
          
          val = rt.getText();
          rThigh.setValue(float(val));
          
          val = lt.getText();
          lThigh.setValue(float(val));
       
          arduinoPort.write("1:"+servo1+"&"+"2:"+servo2+"&"+"3:"+servo3+"&"+"4:"+servo4);
          println("Moving all positions: \n" 
                    +"Left Thigh moving to position: " +str(servo1)+ " \n"
                    +"Left Foot moving to position: " +str(servo2)+ " \n"
                    +"Right Thigh moving to position: " +str(servo3)+ " \n"
                    +"Right Foot moving to position: " +str(servo4)+ " \n"
                   
          );
    break;
    case "reset":
       println("Resetting all positions");
       cp5.get(Textfield.class,"Command").clear(); //clear our command text box
       arduinoPort.write("5:0"); //reset our servos back to 90
       //update our knobs back to 90
       lFoot.setValue(90);
       lThigh.setValue(90);
       rFoot.setValue(90);
       rThigh.setValue(90);
    break;
     case "Command":
          arduinoPort.write(cp5.get(Textfield.class,"Command").getText());
          
    break;
  }
  
}
