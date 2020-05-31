/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void button1_click1(GButton source, GEvent event) { //_CODE_:button1:332547:
  if(DebugGUI) println("button1 - GButton >> GEvent." + event + " @ " + millis());
  if(source == button1 && nPorts >=1 && !pValidado){
    configPuerto();
    dropList1.setEnabled(false);
    dropList2.setEnabled(false);
    mensajeInferior("", color(255,255,255)); 
    pValidado = true;
  }
    else if(nPorts >=1 && pValidado){
      pgrmReinit = true;    
  }
 
} //_CODE_:button1:332547:

public void textfield1_change1(GTextField source, GEvent event) { //_CODE_:textfield1:256810:
 
  if(DebugGUI) println("textfield1 - GTextField >> GEvent." + event + " @ " + millis());
  if(source == textfield1 && event.toString() == "ENTERED" || event.toString() == "LOST_FOCUS") chgnVar = true;
} //_CODE_:textfield1:256810:

public void textfield2_change1(GTextField source, GEvent event) { //_CODE_:textfield2:925463:
  if(DebugGUI) println( "textfield2 - GTextField >> GEvent." + event + " @ " + millis());
  if(source == textfield2 && event.toString() == "ENTERED" || event.toString() == "LOST_FOCUS") chgMaxVar = true;
} //_CODE_:textfield2:925463:

public void textfield3_change1(GTextField source, GEvent event) { //_CODE_:textfield3:425804:
  println("textfield3 - GTextField >> GEvent." + event + " @ " + millis());
  if(source == textfield3 && event.toString() == "ENTERED" || event.toString() == "LOST_FOCUS") chgMinVar = true;
} //_CODE_:textfield3:425804:

public void option1_clicked1(GOption source, GEvent event) { //_CODE_:option1:442401:
  if(DebugGUI) println("option1 - GOption >> GEvent." + event + " @ " + millis());
   textfield2.setEnabled(false);
   textfield3.setEnabled(false);
   scalaDim = true;
} //_CODE_:option1:442401:

public void option2_clicked1(GOption source, GEvent event) { //_CODE_:option2:647663:
  if(DebugGUI) println("option2 - GOption >> GEvent." + event + " @ " + millis());
   textfield2.setEnabled(true);
   textfield3.setEnabled(true);
   chgScala = true;
   scalaDim = false;
} //_CODE_:option2:647663:

public void dropList1_click1(GDropList source, GEvent event) { //_CODE_:dropList1:572749:
  if(DebugGUI) println("dropList1 - GDropList >> GEvent." + event + " @ " + millis());
} //_CODE_:dropList1:572749:

public void dropList2_click1(GDropList source, GEvent event) { //_CODE_:dropList2:507234:
  if(DebugGUI) println("dropList2 - GDropList >> GEvent." + event + " @ " + millis());
  if(nPorts >=1 ) selectPuerto();
  
} //_CODE_:dropList2:507234:

public void checkbox1_clicked1(GCheckbox source, GEvent event) { //_CODE_:checkbox1:929127:
  if(DebugGUI) println("checkbox1 - GCheckbox >> GEvent." + event + " @ " + millis());
  modeGraficas = !modeGraficas;
  if(modeGraficas) npxini=npx; else npxini = 0;
  //println(npxini);
} //_CODE_:checkbox1:929127:

public void button2_click1(GButton source, GEvent event) { //_CODE_:button2:570007:
  if(DebugGUI) println("button2 - GButton >> GEvent." + event + " @ " + millis());
  if( source == button2 && event.toString() == "PRESSED" ){
    mClear = true;
    npx=0;  //Erase the Serial Frames received
  }
  else if( source == button2 && ( event.toString() == "RELEASED" || event.toString() =="CLICKED") ){
    mClear = false;
  }
} //_CODE_:button2:570007:

public void button3_click1(GButton source, GEvent event) { //_CODE_:button3:925745:
  if(DebugGUI) println("button3 - GButton >> GEvent." + event + " @ " + millis());
  mStop = !mStop;
  /*if(mCont) mStop = !mStop;
  else mStop = false;*/
} //_CODE_:button3:925745:

public void option3_clicked1(GOption source, GEvent event) { //_CODE_:option3:567619:
 if(DebugGUI)  println("option3 - GOption >> GEvent." + event + " @ " + millis());
  mCont = true;
} //_CODE_:option3:567619:

public void option4_clicked1(GOption source, GEvent event) { //_CODE_:option4:293110:
  if(DebugGUI) println("option4 - GOption >> GEvent." + event + " @ " + millis());
  mCont = false;
} //_CODE_:option4:293110:

public void button4_click1(GButton source, GEvent event) { //_CODE_:button4:438759:
  if(DebugGUI) println("button4 - GButton >> GEvent." + event + " @ " + millis());
  if(window1.isVisible()) window1.setVisible(false); else window1.setVisible(true);
} //_CODE_:button4:438759:

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:955091:
  appc.background(173,179,199);
  appc.stroke(0);
  appc.fill(#FCF500);
  appc.textSize(16);
  appc.textAlign(CENTER);
  appc.text("Serial Monitor for Analog Signals. V1.01",274, 30);
  appc.fill(#FAFAFA);
  appc.text("Analog Communication Variables", 270, 50);
  appc.text("with the Arduino by Serial Port.", 270, 70);
  appc.fill(#64355C);
  appc.text("Programmed with Processing.", 265, 100);
  appc.text("https://processing.org/", 265, 120);
  appc.text("Used libraries:", 175, 150);
  appc.text("Serial, for the serial port.", 265, 172);
  appc.text("G4P, for the Graphical User Interface.", 265, 195);
  appc.text("http://www.lagers.org.uk/g4p/",265,215);
  appc.text("Open Source Software (OSS).", 265,243);
  appc.text("GPL (General Public License).", 265, 263);
  appc.textAlign(LEFT);
  appc.text("Frame Format: comma-separated data and ending by \\n", 10, 289);
  appc.text("Sg1,Sg2,Sg3,Sg4,Sg5, ... , Sg8\\n", 100,312);
  appc.text("(GPL) 2020 by G. de la Cruz.", 140, 360);
  appc.fill(#E9FA9F);
  appc.text("https://github.com/gcruzq6409s/VarMonSerial",50,336);
} //_CODE_:window1:955091:

public void imgButton1_click1(GImageButton source, GEvent event) { //_CODE_:imgButton1:648665:
  if(DebugGUI) println("imgButton1 - GImageButton >> GEvent." + event + " @ " + millis());
} //_CODE_:imgButton1:648665:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  button1 = new GButton(this, 577, 8, 68, 32);
  button1.setText("VALIDATE");
  button1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button1.addEventHandler(this, "button1_click1");
  label1 = new GLabel(this, 72, 12, 100, 20);
  label1.setText("Nº Variables");
  label1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  label1.setOpaque(false);
  textfield1 = new GTextField(this, 44, 12, 24, 18, G4P.SCROLLBARS_NONE);
  textfield1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfield1.setOpaque(true);
  textfield1.addEventHandler(this, "textfield1_change1");
  textfield2 = new GTextField(this, 16, 40, 54, 18, G4P.SCROLLBARS_NONE);
  textfield2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfield2.setOpaque(true);
  textfield2.addEventHandler(this, "textfield2_change1");
  label2 = new GLabel(this, 74, 39, 114, 18);
  label2.setText("Maximal Value");
  label2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  label2.setOpaque(false);
  textfield3 = new GTextField(this, 16, 60, 54, 18, G4P.SCROLLBARS_NONE);
  textfield3.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  textfield3.setOpaque(true);
  textfield3.addEventHandler(this, "textfield3_change1");
  label3 = new GLabel(this, 75, 61, 114, 18);
  label3.setText("Minimal Value");
  label3.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  label3.setOpaque(false);
  togGroup1 = new GToggleGroup();
  option1 = new GOption(this, 196, 60, 115, 18);
  option1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option1.setText("Dynamic Scale");
  option1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  option1.setOpaque(false);
  option1.addEventHandler(this, "option1_clicked1");
  option2 = new GOption(this, 196, 40, 115, 20);
  option2.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option2.setText("Fixed Scale");
  option2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  option2.setOpaque(false);
  option2.addEventHandler(this, "option2_clicked1");
  togGroup1.addControl(option1);
  togGroup1.addControl(option2);
  option2.setSelected(true);
  dropList1 = new GDropList(this, 463, 17, 102, 120, 5, 10);
  dropList1.setItems(loadStrings("BLUE_SCHEME"), 5);
  dropList1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  dropList1.addEventHandler(this, "dropList1_click1");
  label4 = new GLabel(this, 461, -1, 102, 18);
  label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label4.setText("Config Serial P.");
  label4.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  label4.setOpaque(false);
  dropList2 = new GDropList(this, 349, 18, 102, 80, 3, 10);
  dropList2.setItems(loadStrings("list_507234"), 0);
  dropList2.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  dropList2.addEventHandler(this, "dropList2_click1");
  label5 = new GLabel(this, 345, -1, 102, 18);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("Select Serial P.");
  label5.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  label5.setOpaque(false);
  checkbox1 = new GCheckbox(this, 196, 12, 120, 20);
  checkbox1.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  checkbox1.setText("Graphics Mode");
  checkbox1.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  checkbox1.setOpaque(false);
  checkbox1.addEventHandler(this, "checkbox1_clicked1");
  checkbox1.setSelected(true);
  button2 = new GButton(this, 656, 8, 80, 32);
  button2.setText("CLEAR GRP:");
  button2.setLocalColorScheme(GCScheme.RED_SCHEME);
  button2.addEventHandler(this, "button2_click1");
  button3 = new GButton(this, 656, 44, 80, 32);
  button3.setText("RUN/STOP");
  button3.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button3.addEventHandler(this, "button3_click1");
  togGroup2 = new GToggleGroup();
  option3 = new GOption(this, 749, 25, 148, 20);
  option3.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option3.setText("Continuous Mode");
  option3.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  option3.setOpaque(false);
  option3.addEventHandler(this, "option3_clicked1");
  option4 = new GOption(this, 749, 49, 148, 20);
  option4.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option4.setText("Discontinuous Mode");
  option4.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  option4.setOpaque(false);
  option4.addEventHandler(this, "option4_clicked1");
  togGroup2.addControl(option3);
  option3.setSelected(true);
  togGroup2.addControl(option4);
  label6 = new GLabel(this, 764, 4, 96, 20);
  label6.setIcon("BLUE_SCHEME", 1, GAlign.EAST, GAlign.RIGHT, GAlign.MIDDLE);
  label6.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label6.setText("Mode Data");
  label6.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  label6.setOpaque(false);
  button4 = new GButton(this, 577, 44, 68, 32);
  button4.setText("ABOUT:");
  button4.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  button4.addEventHandler(this, "button4_click1");
  window1 = GWindow.getWindow(this, "About:", 200, 200, 460, 370, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.CLOSE_WINDOW);
  window1.addDrawHandler(this, "win_draw1");
  imgButton1 = new GImageButton(window1, 10, 17, 97, 97, new String[] { "chipAz.png", "chipAz.png", "chipAz.png" } );
  imgButton1.addEventHandler(this, "imgButton1_click1");
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GButton button1; 
GLabel label1; 
GTextField textfield1; 
GTextField textfield2; 
GLabel label2; 
GTextField textfield3; 
GLabel label3; 
GToggleGroup togGroup1; 
GOption option1; 
GOption option2; 
GDropList dropList1; 
GLabel label4; 
GDropList dropList2; 
GLabel label5; 
GCheckbox checkbox1; 
GButton button2; 
GButton button3; 
GToggleGroup togGroup2; 
GOption option3; 
GOption option4; 
GLabel label6; 
GButton button4; 
GWindow window1;
GImageButton imgButton1; 
