//GLOBAL VARIABLES FOR THE GRAPH

// GUI Data on the Graph
static final int GVMAXVAR=9999999; //Maximum Default Global Value for the Variables to be draw
static final int GVMINVAR=-9999999; //Minimum Default Global Value for the Variables to be draw
static final int NMAXVAR=8; //Maximum number of variables to be draw
int nVar = 4;
int xnVar;

int gMaxVar = 1000;
int xgMaxVar;

int gMinVar = -1000;
int xgMinVar;
int gCero = 0;
boolean chgnVar = false;
boolean chgMaxVar = false;
boolean chgMinVar = false;
boolean chgScala =false;

int barraSelect = -1;
boolean scalaDim = false;

///Variables to control the drawing of the bars
int[] valBarra = {0, 0, 0, 0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0};
int[] minBarra = {0, 0, 0, 0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0};
int[] maxBarra = {0, 0, 0, 0, 0, 0, 0, 0,
                  0, 0, 0, 0, 0, 0, 0, 0};
                    
//Maximum and Minimun value of all bars                    
int maxAllBar = 0;
int minAllBar = 0;
                    
//Variables for Vertical Dynamic Scale according to Bar values 
int gdMinVar = -10;
int gdMaxVar = 10;

//Graphics mode / Bars
//If Graphics mode is false --> Bar graph
//If Graphics mode is true --> Line graph vs virtual time. 
boolean modeGraficas = true;

//Flag for first time the Matrix is filled
boolean fpv = true;
//Flag for Initialization of the Matrix
boolean finit = true;
//Matrix for data storage in graphic mode
int[][] punto = new int[16][800];

//Pointer for Matrix data handling
int px = 0; 
//Previous point drawn
int[] Xpre = new int[16];
int[] Ypre = new int[16];

//Other Modes to Work
boolean mStop = false;    //Stop Graphics and Bar
boolean mClear = false;   //Clear Graphics and Bar
boolean mCont = true;     //Default is set to Continuous Mode
boolean newTrama = false;

//FUNCTIONS FOR DRAWING GRAPHS AND BARS

void drawGraphics(){

  //Write the Lower Rectangle
  stroke(0);
  //fill(222,230,240);
  fill(235,240,250);
  rect(80,114,799,502);
  //Save Origin of Coordinates
  pushMatrix();
  //Translating origin of Coordinates
  translate(80,114);
  fill(0);
  stroke(180,180,180);

  if(!modeGraficas){
    //Drawing Vertical Grid
    for (int i=0; i<80; i++){
      line(i*10, 0, i*10, 502);
    }
    //Draw Horizontal Grid
    for (int j=0; j<50; j++){
      line(0, j*10, 799, j*10);
    }
  }

  //Draw Vertical Grid every 10 pixel, offset 5 pixel
  stroke(0,0,80);
  for (int i=0; i<8; i++){
    line(i*100+50, 0, i*100+50, 502);
  }
  //Draw Horizontal Grid every 10 pixel, offset 5 pixel
  for (int j=0; j<5; j++){
    line(0, j*100+50, 799, j*100+50);
  }
  //Draw Vertical Grid every 10 pixel
  stroke(160,0,0);
  for (int i=0; i<8; i++){
    line(i*100, 0, i*100, 502);
  }
  //Draw Horizontal Grid every 10 pixel
  for (int j=0; j<5; j++){
    line(0, j*100, 799, j*100);
  }
 
  //Drawing Numbers Vertical Scale
  dibujaEscalaV(gMaxVar, gMinVar);
  //Drawing Numbers Associated with the Horizontal Scale
  dibujaEscalaH();
  if(modeGraficas) numerosEscalaH();
  //Drawing Zero axis
  textAlign(LEFT);
  strokeWeight(2);
  if(Math.signum(gMinVar) == Math.signum(gMaxVar))
    stroke(255,0,0); 
  else
    stroke(21,129,234);
  gCero = alturaBarra(0);
  line(0,gCero+1, 799, gCero+1);
  strokeWeight(1);

  if(!modeGraficas){    //Init Mode Bars
     //If there is a new data frame by the Serial Port
     if(fpTrama & !mStop & !mClear){
       for(int i=0; i<nVar; i++){
          valBarra[i]= valTrama[i];
       }
       timeNoTrans = millis();
       fpTrama = false; 
     }
     //If in a time nothing data arrives through the serial port (60 ms).
     if(((millis()-timeNoTrans > limTimeNoTrans) & !mStop & !mCont) | mClear){
       for(int i=0; i<nVar; i++){
         valBarra[i]= 0;
       }  
     }
    color mb = color(255, 200, 0);
    color mbb = color (0);
    for(int k=0; k<nVar; k++){
      mb = colorBarras[k];
      dibujaBarra(alturaBarra(valBarra[k]), k, nVar , mb, mbb);
    } 
    //Resseting Graphics mode variables
    px=0;
    fpv= true;
    finit = true;
  }  //End mode Bars
  else{   
    //Init Modo Graphics
     //Initialize Matrix
    if(finit | mClear){
      for(int i=0; i<16; i++){
        for(int j=0;j<800; j++){
          punto[i][j]=0;
        }
      }
      finit = false;
    }
    if(mClear){
      px=0;
      fpv = true;
    }
    //Generation of Data Points for Graph
    //If there's a new data to plot by the Serial Port:
     if(fpTrama & !mStop & !mClear){ 
       for(int i=0; i < 16; i++){
           if(i<nVar) valBarra[i]= valTrama[i];
           else valBarra[i] = 0;
       }
       timeNoTrans = millis();
       fpTrama = false;
       newTrama = true;
     }

    for(int i=0; i<nVar; i++){
      if (i< nVar) punto[i][px] = (int) valBarra[i];
      else punto[i][px] = 0;
    }
    if(fpv && px<=799){
      dibujaGrp(0,px,0); 
    }//End Mode Barras
    else{
      //The graphical drawing parameters are the pointers to the data matrix
      dibujaGrp(px+1,799,0);
      dibujaGrp(0,px,1);
    }
   if(pOpen & modeGraficas & firstDate){
      //Continuous Mode
      //In this mode if no data is received the graph stops
      if( mCont & newTrama & !mStop ){
        px++;
        difnpx = npx - npxAnt;
        println("Trama: " + npx + " Dif: "+ difnpx);
        npxAnt = npx;
        newTrama = false;  
      }
         
      //Discontinuous Mode
      //In this mode if no graphical data is received, it continues to run with null signals
      if(!mCont & newTrama & !mStop){
        px++;
        newTrama = false;
      }
      //Graphical progress in Discontinuous Mode
      if(!mCont & !newTrama &!mStop){
        if(millis()-timeNoTrans > limTimeNoTrans){
          for(int i=0; i<nVar; i++){
            valBarra[i] = 0;
          }
          px++;
          npx++;
        }
      } 
      

           
      //Control Resetting last Value pointer px
      if(px>799){
        px=0;
        fpv = false;  
      } 
   }
}//Fin Mode Graficas
  
  //Draw lower boxes to select Bar or Graphics
  cuadrosSelectEscalaV();
  detectSelectEscalaV();

  //Calculate the Maximum and Minimum Bar Values
  cmaximo();
  cminimo();
  //Calculate the Maximum and Minimum of all Bars
  cmaximoAllBar();
  cminimoAllBar();
  //Calculates dynamic vertical scale
  if(scalaDim) calculaEscalaDimV();

  //Restore Origin of Coordinates
  popMatrix();
  stroke(0);
  noFill();
  rect(80,114,799,502); 
}

//Function for Drawing Bars
//High => Bar height (<= 500 pixel)
//npos => Bar position on the graph (0 ... nvars-1)
//nvars => Maximum number of variables (bars) to be draw on the Graph
void dibujaBarra( int yalto, int npos, int nvars, color cb, color cbb){
  int iXmax = 800;
  int iYmax = 500;
  int ebarra = 0;
  int Abarra = 0;
  int hbarra = 0;
  int xposBarra =0;
  int yposBarra = 0;
  int altBarra = 0;
  if(nvars != 0){
    ebarra = iXmax/nvars;
    hbarra = ebarra / 4;
    Abarra = 2 * hbarra;
    if(npos>=0 && npos< nvars){
      if(barraSelect !=-1){
        if(barraSelect == npos){
          stroke(cbb);
          fill(cb); 
        }
        else{
          stroke(cbb);
          fill(225);
        }
      }
      else{
        stroke(cbb);
        fill(cb);
      }
      xposBarra = npos*ebarra+hbarra;
      if(yalto > iYmax) yalto = iYmax;
      //Set if Bar have zero value to show as something above the Zero axis
      if(valBarra[npos]== 0) yalto = (int) alturaBarra(5);
      yposBarra = yalto;
      altBarra = (int) (gCero - yalto);
      rect(xposBarra, yposBarra, Abarra, altBarra);
      if(barraSelect == npos){
        fill(225);
        stroke(cbb);
        rect(npos*ebarra, (altBarra/2)+yposBarra+12, ebarra, -20);
        textAlign(CENTER);
        noStroke();
        //Change text size according to number of bars
        if(nVar<=8) textSize(14);
        else if(nVar <=12) textSize(13);
        else textSize(12);
        fill(0);
        text((int)valBarra[npos],xposBarra+hbarra, (altBarra/2)+yposBarra+8);
        textAlign(LEFT);
      }
    }
  }
}

//Function to draw the Left Vertical Scale of the Graphics
void dibujaEscalaV(int pYini, int pYfin){
  //Drawing vertical scale lines
  stroke(0,0,80);
  for (int j=0; j<5; j++){
    line(-3, j*100+50, -22, j*100+50);
  }
  stroke(160,0,0);
  for (int j=0; j<6; j++){
    line(-3, j*100, -12, j*100);
  }
  //Drawing Numbers Vertical Scale
  textAlign(RIGHT);
  noStroke();
  textSize(14);
  for(int t=0; t<6; t++){
    if(t==0){
      fill(230);
      rect(-76,t*100,60,26);
      fill(160,0,0);
      text((int)trafosInversa(t*100, pYini, pYfin), -14, t*100+12);  
    }
    else if(t==5) {
      fill(230);
      rect(-76,t*100-25,60,25);
      fill(160,0,0);
      text((int)trafosInversa(t*100, pYini, pYfin), -14, t*100-2);  
    }
    else{
      fill(230);
      rect(-76,t*100-13,60,24);
      fill(160,0,0);
      text((int)trafosInversa(t*100, pYini, pYfin), -14, t*100+5);  
    } 
  }
  textAlign(LEFT);
}

//Function to draw the Horizontal Scale of the Graphics
void dibujaEscalaH(){
  int iXmax = 800;
  int ebarra = 0;
  int Abarra = 0;
  int hbarra = 0;
  if(nVar != 0){
    ebarra = iXmax/nVar;
    hbarra = ebarra / 4;
    Abarra = 2 * hbarra;
    //Put Text of the values: current, maximum and minimum
    //Text Current Value
    textSize(14);
    fill(120,0,120);
    stroke(120,0,120);
    text("Actual Val:", -75, 518+25);
    line(-76, 518+30, 0, 518+30);
    //Text Maximal Value
    fill(160,0,0);
    stroke(160,0,0);
    text("Maximal V:", -75, 543+25);
    line(-76, 543+30, 0, 543+30);
    //Text Minimal Value
    fill(0,0,160);
    stroke(0,0,160);
    text("Minimal V:", -75, 568+25);
    line(-76, 568+30, 0, 568+30);
    fill(0);
    //For each of the bars shown in the graph
    for(int i=0; i<nVar; i++){
      //Small Vertical Line
      stroke(0);
      fill(230);
      if(!modeGraficas) line(ebarra*i+Abarra, 505, ebarra*i+Abarra, 515); //<>//
      //Horizontal lines Under text / values
      noStroke();
      rect(ebarra*i,518, ebarra,25);
      rect(ebarra*i,543, ebarra,25);
      rect(ebarra*i,568, ebarra,25);
      fill(0);
      //Change text size according to number of bars
      if(nVar<=8) textSize(14);
      else if(nVar <=12) textSize(13);
      else textSize(12);
      //New Centerline Alignment
      textAlign(CENTER);
      //Print Current Values and Separation Lines Below the Text
      fill(120,0,120);
      stroke(120,0,120);
      line(ebarra*i, 518+30, ebarra*(i+1), 518+30); 
      text( (int) valBarra[i], ebarra*i+Abarra, 518+25);
      //Print Maximum Values and Separation Lines Below the Text
      fill(160,0,0);
      stroke(160,0,0);
      line(ebarra*i, 543+30, ebarra*(i+1), 543+30); 
      text( (int) maxBarra[i], ebarra*i+Abarra, 543+25);
      //Print Minimum Values and Separation Lines Below theText
      fill(0,0,160);
      stroke(0,0,160);
      line(ebarra*i, 568+30, ebarra*(i+1), 568+30); 
      text( (int) minBarra[i], ebarra*i+Abarra, 568+25);
      //Restore Default Alignment
      textAlign(LEFT);
    } 
  }
}

//Function to draw the Select Rectangles for Bar or Graphics
void cuadrosSelectEscalaV(){
  int iXmax = 800;
  int ebarra = 0;
  int Abarra = 0;
  int hbarra = 0;
  int rad = 0;
  float dbarra = 0;
  if(nVar != 0 && nPorts !=0 && pOpen) { 
    ebarra = iXmax/nVar;
    hbarra = ebarra / 4;
    Abarra = 2 * hbarra;
    if(nVar <=8) dbarra = 0.7*Abarra;
    else dbarra = 0.9*Abarra;
    fill(120,0,120);
    textSize(14);
    text("Select Bar:",-75, 599+28);
    textAlign(CENTER);
    //Change text size according to number of bars
    if(nVar<=8) textSize(14);
    else if(nVar <=12) textSize(13);
    else textSize(12);
    //Change the radius according to the number of bars
    if(nVar<=8) rad = 20;
    else if(nVar <=12) rad = 16;
    else rad = 10;
    for(int i=0; i<nVar; i++){
     fill(colorBarras[i]);
     stroke(0);
     rect(ebarra*i+hbarra, 579+27, Abarra, 28,4); 
     fill(120,0, 120);
     text( i, ebarra*i+Abarra+dbarra, 599+28); 
    }
  }
  //Restore Default Alignment
  textAlign(LEFT);
}

//Function for Detect the mouse Click into Select Rectangles for Bar or Graphics
void detectSelectEscalaV(){
  int iXmax = 800;
  int ebarra = 0;
  int Abarra = 0;
  int hbarra = 0;
  int xi=0;
  int yi=0;
  int xf =0;
  int yf=0;
  if(nVar != 0 && nPorts !=0 & pOpen){
    ebarra = iXmax/nVar;
    hbarra = ebarra / 4;
    Abarra = 2 * hbarra;
    for(int i=0; i<nVar; i++){
       xi = ebarra*i+hbarra+80;
       xf = xi + Abarra;
       yi=  720;
       yf = 720 +28;
       if(mouseX >= xi && mouseX <= xf){
         if(mouseY >= yi && mouseY <= yf){
           if( mousePressed == true){
             barraSelect =i;
          }
          else barraSelect = -1;
        }
      }
    }
  }
}

void numerosEscalaH(){
  int off = 0;
  int lnpx = 0;
  int lnpxoff = 0;
  textSize(14);
  if(nVar!=0){
    for(int i=0; i<9; i++){
      stroke(#9D2518);
      if (i==8) line(799, 505, 799, 508);
      else line(i*100, 505, i*100, 508);
    }
    stroke(0);
    if(fpv){
      lnpxoff = npxini;
      for(int i=0; i<9; i++){
       if(i==8) off = 35; else off = 25;
       fill(#9D2518);
       textAlign(CENTER);
       lnpx = i*100;
       text(lnpx+lnpxoff,i*100-off+25, 521);
      }
    }
    else{
      lnpxoff = npxini;
      if(!mStop) snpx = npx;
      for(int i=0; i<9; i++){
       if(i==8) off = 35; else off = 25;
       fill(#9D2518);
       textAlign(CENTER);
       lnpx = i*100+lnpxoff + (snpx-800-lnpxoff);
       text(lnpx,i*100-off+25, 521);
     }      
    }
    noStroke();
    noFill();
    textAlign(CENTER);  
  }
  
}

//Scale the height of the bar to be drawn as a function of the global variables
//gMinVar and gMaxVar which are the values to be displayed on the Y axis for the bars in the graph
//yAltura is the value we're going to scale to draw for the height bar in proportion
//The maximum height for a bar in the graph is 500
int alturaBarra(int yAltura){
  float Yi = 500;
  float Yf = 0;
  float Xi = gMinVar;
  float Xf = gMaxVar;
  float aBarra =0.0;
  float pBarra =0.0;
  if(yAltura > gMaxVar) yAltura = gMaxVar;
  if(yAltura < gMinVar) yAltura = gMinVar;
  if(gMaxVar > gMinVar){
    pBarra = ( Yf - Yi ) / ( Xf - Xi );
    aBarra = pBarra * (yAltura - Xi)+Yi;
    return (int) aBarra;
  }
  else return 0;
}


//Inverse function to the previous one. Calculates the Value of the Variable 
//for a coordinate value represented on the Graph
//Used to calculate the values to be displayed on the vertical scale
int trafosInversa(int cordY, int Yi, int Yf){
  float Xi = 0;
  float Xf = 500;
  float icordY =0.0;
  float pcordY =0.0; 
  if(cordY > 500) cordY = 500;
  if(cordY < 0) cordY = 0;
  pcordY = ( Yf - Yi ) / ( Xf - Xi );
  icordY = pcordY * (cordY-Xi)+Yi;
  return (int) icordY;
}

//Calculate Maximum Value per Bar over time
void cmaximo(){
    for(int i=0; i<nVar; i++){
      if(valBarra[i] > maxBarra[i]) maxBarra[i] = valBarra[i];
    }
}

//Calculate Minimum Value per Bar over time
void cminimo(){
    for(int i=0; i<nVar; i++){
      if(valBarra[i] < minBarra[i]) minBarra[i] = valBarra[i];
    }
}

//Calculate Absolute Maximum of all Bars at a particular instant
void cmaximoAllBar(){
  int xmaxAllBar =maxBarra[0];
  for(int i=1; i<nVar; i++){
    if(maxBarra[i] > xmaxAllBar) xmaxAllBar = maxBarra[i];
  }
  maxAllBar = xmaxAllBar;
}

//Calculate Absolute Minimum of all Bars at a particular instant
void cminimoAllBar(){
  int xminAllBar =minBarra[0];
  for(int i=1; i<nVar; i++){
    if(minBarra[i] < xminAllBar) xminAllBar = minBarra[i];
  }
  minAllBar = xminAllBar;
}

//Calculates the limit values of the dynamic vertical scale
void calculaEscalaDimV(){
 int xgdMaxVar=0;
 int xgdMinVar=0;
 xgdMaxVar = maxAllBar;
 xgdMinVar = minAllBar;
 //If the bars are almost zero
 if(xgdMaxVar > -1 && xgdMaxVar < 1 && xgdMinVar > -1 && xgdMinVar < 1) {
   gdMaxVar = 100;
   gdMinVar = -100;
 }
 //Values of the bars are all positive
 if(xgdMaxVar > 0 && xgdMinVar >= 0){
     gdMaxVar = (int) (1.1 * xgdMaxVar);
     gdMinVar = 0; 
 }
 //Values of the bars are all negative
 if(xgdMaxVar <= 0 && xgdMinVar < 0){
     gdMaxVar = 0; 
     gdMinVar = (int) (1.1 * xgdMinVar);
 } 
 //Values of the bars are positive and negative
 if(xgdMaxVar > 0 && xgdMinVar < 0){
     gdMaxVar = (int) (1.1 * xgdMaxVar);
     gdMinVar = (int) (1.1 * xgdMinVar);
 }  
}


//Draw Chart from Dot Matrix data punto[][]
void dibujaGrp(int pxi, int pxf, int mode){
  boolean[] primerdat = {true, true, true, true, true, true, true, true,
                        true, true, true, true, true, true, true, true};
  boolean[] primerdat2 = {true, true, true, true, true, true, true, true,
                         true, true, true, true, true, true, true, true};
  int bsi =-1;
  
  for(int i=0; i<nVar; i++){
    if(barraSelect != -1){
       if(barraSelect == i){
          stroke(colorBarras[i]);
          fill(colorBarras[i]); 
       }
       else{
        stroke(195);
        fill(195);
       }
    }
    else{
      stroke(colorBarras[i]);
      fill(colorBarras[i]);
    }
    if(barraSelect != i){
      for(int p=pxi; p<=pxf; p++){
        if(mode == 0){
          if(primerdat[i]){
            strokeWeight(1);
            circle( p-pxi, alturaBarra(punto[i][p]),2);
            Xpre[i] = p-pxi;
            Ypre[i] = alturaBarra(punto[i][p]); 
            primerdat[i] = false;
          }
          else{
            strokeWeight(2);
            line(Xpre[i], Ypre[i], p-pxi, alturaBarra(punto[i][p]));
            Xpre[i] = p-pxi;
            Ypre[i] = alturaBarra(punto[i][p]); 
          }
        }
        else{
          if(primerdat2[i]){
           strokeWeight(1); 
           circle( 799-px+p, alturaBarra(punto[i][p]),2);
           Xpre[i] = 799-px+p;
           Ypre[i] = alturaBarra(punto[i][p]); 
           primerdat2[i] = false;
          }
          else{
           strokeWeight(2); 
           line(Xpre[i], Ypre[i], 799-px+p, alturaBarra(punto[i][p]));
           Xpre[i] =  799-px+p;
           Ypre[i] = alturaBarra(punto[i][p]); 
          }
        }
      }   
    }
    else bsi = barraSelect; 
  }
  //Draw the Highlighted Graphic above all others. 
  if(bsi !=-1){
    stroke(colorBarras[bsi]);
    fill(colorBarras[bsi]); 
      for(int p=pxi; p<=pxf; p++){    
       if(mode == 0){
        if(primerdat[bsi]){
          strokeWeight(2);
          circle( p-pxi, alturaBarra(punto[bsi][p]),2);
          Xpre[bsi] = p-pxi;
          Ypre[bsi] = alturaBarra(punto[bsi][p]); 
          primerdat[bsi] = false;
        }
        else{
          strokeWeight(4);
          line(Xpre[bsi], Ypre[bsi], p-pxi, alturaBarra(punto[bsi][p]));
          Xpre[bsi] = p-pxi;
          Ypre[bsi] = alturaBarra(punto[bsi][p]); 
        }
      }
      else{
        if(primerdat2[bsi]){
         strokeWeight(2);
         circle( 799-px+p, alturaBarra(punto[bsi][p]),2);
         Xpre[bsi] = 799-px+p;
         Ypre[bsi] = alturaBarra(punto[bsi][p]); 
         primerdat2[bsi] = false;
        }
        else{
         strokeWeight(4);
         line(Xpre[bsi], Ypre[bsi], 799-px+p, alturaBarra(punto[bsi][p]));
         Xpre[bsi] =  799-px+p;
         Ypre[bsi] = alturaBarra(punto[bsi][p]); 
        }
      }         
     }
    }
    strokeWeight(1);
}

void lossFrameSemphore(int cx, int cy, int sc, boolean ro, boolean na, boolean ve){
  int D = 14;
  int s = 6;
  int l = 3;
  int h = 3;
  int L =4;
  float arcini = HALF_PI;
  float arcfin = PI + HALF_PI;
  float arcinid = TWO_PI - HALF_PI;
  float arcfind = TWO_PI + HALF_PI;
  pushStyle();
  // Outside
  fill(118,118,118);
  noStroke();
  rect(cx,cy-(D/2+h+L)*sc,(D+s)*2*sc,(D+2*(h+L))*sc);
  stroke(0);
  arc(cx,cy,(D+2*h+2*L)*sc,(D+2*h+2*L)*sc, arcini, arcfin, OPEN);
  arc(cx+(D+s)*2*sc,cy,(D+2*h+2*L)*sc,(D+2*h+2*L)*sc, arcinid, arcfind, OPEN );
  line(cx,cy-(D/2+h+L)*sc,cx+(D+s)*2*sc,cy-(D/2+h+L)*sc );
  line(cx,cy+(D/2+h+L)*sc,cx+(D+s)*2*sc,cy+(D/2+h+L)*sc );
  // Inside
  fill(165,165,165);
  noStroke();
  rect(cx,cy-(D/2+h)*sc,(D+s)*2*sc,(D+2*h)*sc);
  stroke(0);
  arc(cx,cy,(D+2*h)*sc,(D+2*h)*sc,arcini, arcfin, OPEN);
  arc(cx+(D+s)*2*sc, cy, (D+2*h)*sc, (D+2*h)*sc, arcinid, arcfind, OPEN);
  noFill();
  stroke(0);
  line(cx,cy-(D/2+h)*sc, cx+(D+s)*2*sc, cy-(D/2+h)*sc);
  line(cx,cy+(D/2+h)*sc, cx+(D+s)*2*sc, cy+(D/2+h)*sc);
  stroke(0);
  //Red
  noFill();
  circle(cx,cy, D*sc);
  if(ro){
    fill(255,0,0);
    circle(cx,cy, D*sc);
  }
  //Orange
  noFill();
  circle(cx+(D+s)*sc,cy, D*sc); 
  if(na){
    fill(252,146,5);
    circle(cx+(D+s)*sc,cy, D*sc); 
  }
  //Green
  noFill();
  circle(cx+2*(D+s)*sc,cy, D*sc);
  if(ve){
    fill(0,255,0);
    circle(cx+2*(D+s)*sc,cy, D*sc);
  }
  popStyle();
}
