/****************************************************************/
/*                 Main Sketch Processing                       */
/****************************************************************/

//IMPORTS LIBRARYS
// Need G4P library for GUI in Processing
//Quarks place --> http://www.lagers.org.uk/g4p/index.html
import g4p_controls.*;
//Other Java librarys
import java.awt.*;
import java.lang.Math.*;
//Processing Serial Ports Library
import processing.serial.*;

//Specific char font for de GUI
Font mifont = new Font("Arial", Font.BOLD, 14);

//Resolución de la Pantalla
int displayX = 0;
int displayY = 0;

//Var for control time Cycle draw()
int mideCiclo = 0;
int difmideCiclo = 0;

//Debug Console GUI
boolean DebugGUI = false;

//SETUP: Config Function
public void setup(){
  //Frame main windows size
  size(900, 750, JAVA2D);
  //Color for background Window
  background(230);
  //Tamaño de la pantalla del PC
  displayX =displayWidth;
  displayY =displayHeight;
  //Create GUI
  createGUI();
  //Custom GUI
  customGUI();
  //Flag for Init Program Warning
  pgrmReinit = false;
  //Flag for Validated Serial Port Control
  pValidado = false;
  //Search for Serial Ports
  buscarPuertos();
  //Present Serial Ports Detected in the GUI
  guiPuertos();
  //Read Colors from the Graphic Bars of the configuration file
  readFileColors();
   //Variable for measuring a complete program scan (time in draw() running)
  mideCiclo = millis();
  

}//END SETUP


//SETUP: Cyclic Function
public void draw(){
  //Color for background Window
   background(230);
   stroke(0);
   line(10,87,890,87);
   line(10,110,890,110);
    
   //GUI: Rectangle for Boutton Stop/Run
    if(mStop){
    noStroke();
    fill(152,12,47);
    rect(648,41,94,37,6);
  }
  else{
    noStroke();
    fill(86,129,73);
    rect(648,41,94,37,6);
  }
 
  // Management for Waiting Port Validation
   if(nPorts == 0){
    mensajeInferior("No Serial Port Detected", color(255,0,0)); 
   }
   else if(nPorts ==1 ){
     if(!pValidado) mensajeInferior("Validate Serial Port Detected", color(0,0,192));
     selectPuerto();
   }
   else{
     if(!pValidado) mensajeInferior("Select Serial Port Before Validating", color(0,0,192));
     selectPuerto();
   }
   
   //Text Field Management: Number of Signals, Maximum and Minimum 
   //(look in Lower Part of Screen)
   if(chgnVar){
    xnVar = parseInt(textfield1.getText());
    if(xnVar > 0 && xnVar <= NMAXVAR ){
      nVar = xnVar;
    }
    chgnVar = false;
   }
   
   if((chgMaxVar & !scalaDim) | chgScala){
    xgMaxVar = parseInt(textfield2.getText());
    if(xgMaxVar <= GVMAXVAR ){
      gMaxVar = xgMaxVar;
    }
    chgMaxVar = false;
   }
   
   if((chgMinVar & !scalaDim) | chgScala){
    xgMinVar = parseInt(textfield3.getText());
    if(xgMinVar >= GVMINVAR ){
      gMinVar = xgMinVar;
    }
    chgMinVar = false;
   }
   chgScala = false;
   
   //Global Dynamic Scale Management
   if(scalaDim){
     gMaxVar= gdMaxVar;
     gMinVar= gdMinVar;
   }

  //Management Port Validated to Work
  if (pValidado){
      if(fpTrama){
        pTrama = cTrama;
        plenDat = clenDat;
        //fpTrama = false;
      }
      mensajeRecibido( "N. Data: "+plenDat+"   Data:"+pTrama, color(0,48,0));
      if(plenDat != nVar){
          stroke(0,0,0);
          fill(255, 0, 0);
          rect(505,50,54,19,6);

        fill(128,0,0);
        textSize(14);
        text("Unsynchronized Data", 350, 65);
      }
      else{
        stroke(0,0,0);
        fill(0, 255, 0);
        rect(500,50,54,19,6); 
        fill(34,103,33);
        textSize(14);
        text("Synchronized Data", 365, 65);         
        noStroke();
      }
  }
  
  //Graphic Base where all functions for the realization of the Graphics are called
    drawGraphics();
    
  //Semafore to View Lost Frames 
    if(!pOpen) lossFrameSemphore(830,98, 1, false, false, false);
    else{
         if(difnpx <= 1) lossFrameSemphore(830,98, 1, false, false, true); 
        if(difnpx == 2) lossFrameSemphore(830,98, 1, false, true, false);
        if(difnpx > 2 ) lossFrameSemphore(830,98, 1, true, false, false);
    }
 
    fill(128,0,0);
    textSize(14);
    text("Lost S. Frames:", 708, 103);
    
  //Message of Reset of the Program. It is Necessary to Restart the Program 
  //if we Want to Use Another Serial Port after Having Validated one Previously
  if(pgrmReinit && nPorts >1){
    mensajeInferior("Close and Open Program if you Want to Select Another Serial Port", color(0,192,0)); 
  }
  //Displaying scan time runtime information for cyclic draw method
  difmideCiclo = millis()-mideCiclo;
  if(pOpen){
    if(plenDat != nVar ){
      fill(255);
      textSize(14);
      text(difmideCiclo + " ms", 512, 65);
    }
    else{
      fill(0);
      textSize(14);
      text(difmideCiclo + " ms", 507, 65);         
    }
  }  
  //restart var for measure draw cycle time
  mideCiclo = millis();

}//FIN DRAW


//Use this Method to Add Additional Statements
//to Customise the GUI Controls
public void customGUI(){
  PImage icon = loadImage("chipAz32x32.png");
  surface.setIcon(icon);
  surface.setTitle("Serial Monitor for Analog Signals");
  textfield1.setFont ( mifont );
  textfield1.setNumericType(G4P.INTEGER);
  textfield1.setNumeric(1,NMAXVAR,8);
  textfield1.setText (str(nVar));
  textfield2.setFont ( mifont );
  textfield2.setNumericType(G4P.INTEGER);
  textfield2.setNumeric(GVMINVAR,GVMAXVAR,1000);
  textfield2.setText (str(gMaxVar));
  textfield3.setFont ( mifont );
  textfield3.setNumericType(G4P.INTEGER);
  textfield3.setNumeric(GVMINVAR,GVMAXVAR,-1000);
  textfield3.setText (str(gMinVar));
  label1.setFont ( mifont );
  label2.setFont ( mifont );
  label3.setFont ( mifont );
  label4.setFont ( mifont );
  label5.setFont ( mifont );
  label6.setFont ( mifont );
  option1.setFont ( mifont);
  option2.setFont ( mifont);
  option3.setFont ( mifont);
  option4.setFont ( mifont);
  dropList1.setFont( mifont);
  dropList2.setFont( mifont);
  dropList1.setVisible(true);  
  dropList1.setEnabled(true);  
  dropList2.setVisible(true);  
  dropList2.setEnabled(true);  
  checkbox1.setFont( mifont );
  button2.fireAllEvents(true);
  window1.setVisible(false);
  window1.setLocation((displayX-width)/2+(width-460)/2,(displayY-height)/2+(height-370)/2);
}

//Message Warning Displayed on a Bottom Line of the Screen
public void mensajeInferior( String sMensaje, color pColor){
  //Note: Absolute Coordinates
  //Redraw the Rectangle
  stroke(0,0,255);
  fill(255);
  rect(0,719,899,30);
  //Write Message
  fill(pColor);
  textSize(20);
  text(sMensaje, 10, 740);  
}

//Presentation in ASCII of the Message Received by the Serial Port
public void mensajeRecibido( String sMensaje, color pColor){
  //Note: Absolute Coordinates
  //Redraw the Rectangleo
  noStroke();
  fill(230);
  rect(5,140,899,21);
  //Write Message
  fill(pColor);
  textSize(14);
  text(sMensaje, 15, 104);  
}

/* Cambiar Icono Cuadro Dialogo Acerce de: */
/*  final String ICON  = "chipAz16x16.png";
  final PImage img = loadImage(ICON);
  final PGraphics pg = createGraphics(16, 16, JAVA2D);
  pg.beginDraw();
  pg.image(img, 200, 200, 16, 16);
  pg.endDraw();
  //appc.image(img,200,200);
  //window1.frame.setIconImage(pg.image);
*/
