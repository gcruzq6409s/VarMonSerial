/****************************************************************/
/*        Global Variables Management of Serial Ports           */
/****************************************************************/

// The serial port
Serial pSerie;       
int nPorts = 0;
int nPortSelect = -1;
String[] sPorts;
String[] namePort = new String[9];
String namePortSelect = "COM99:";
String cTrama;
String cgTrama;
String pTrama = "";
boolean pgrmReinit = false;
boolean pValidado = false;
boolean fpTrama = false;
boolean pOpen = false;
boolean firstDate = false;
//baudRate, parity, dataBits, stopBits
int baudRate;
char parity;
int dataBits;
float stopBits;

//Variables of the format received frame
static final String SEPARADOR=","; //The data of each signal is separated by a comma
static final char TERMINADOR=10; //Each data group (frame) is terminated with a code ASCII 10 → New line → \n
int clenDat = 0;
int plenDat = 0;
int[] valTrama =new int[20];
String[] valList;

//For Time Texting without Data Serial Port Transmission
int timeNoTrans = 0;
int limTimeNoTrans = 200;

//Counter Numero Serial Frames
int npx = 0;
int npxAnt = 0;
int difnpx = 0;

int npxini =0;
int snpx =0;


/********************************************************/
/****           SERIAL PORT MANAGEMENT               ****/
/********************************************************/

//Search PC Connected Ports
public void buscarPuertos(){
  sPorts = Serial.list();
  nPorts = 0;
  for (int i = 0; i < sPorts.length; i++) {
    namePort[i] = sPorts[i];
    nPorts++;
  }
  println("-------------------------------");
  println("Number of Ports: " + nPorts);
  for (int i = 0; i < nPorts; i++){
    print(namePort[i]);
    if( i < (nPorts-1) ) print(", ");
  }
  println();
  println("-------------------------------");
}

//Adjusts the dropList of the GUI for the Number of Detected Ports
public void guiPuertos(){
  if(nPorts == 1){
    dropList2.removeItem(2);
    dropList2.removeItem(1);
    dropList2.setItems(namePort,1);
    dropList2.setSelected(2); 
  }
  else if( nPorts == 0){
    dropList2.removeItem(2);
    dropList2.removeItem(1);
    dropList2.setSelected(2); 
  }
  else{
    dropList2.setItems(namePort,1);
    dropList2.setSelected(0); 
  }
}

//Select Serial Port
public void selectPuerto(){
    nPortSelect= dropList2.getSelectedIndex();
    namePortSelect = dropList2.getSelectedText(); 
}

//Configure the Serial Port Validated from the GUI
public void configPuerto(){
  int itemSelect;
  itemSelect = dropList1.getSelectedIndex();
  switch (itemSelect){
    case 0:
      baudRate = 9600;
      break;
    case 1:
      baudRate = 19200;
      break;
    case 2:
      baudRate = 38400;
      break;
    case 3:
      baudRate = 57600;
      break;
    case 4:
      baudRate = 115200;
      break;
  }
  dataBits = 8;
  parity = 'N';
  stopBits = 1.0;
  //Create Objet Serial Port
  pSerie = new Serial(this,  namePortSelect, baudRate, parity, dataBits, stopBits);
  pOpen = true;
  //Config Terminator for detect complet line frame 
  //Arduino Serial.println(...) end the line with <CR><LF> --> /r /n --> Ascii 13 Ascii 10
  //TERMINADOR is set to Ascci 10 --> /n --> <LF>
  pSerie.bufferUntil(TERMINADOR);
  //Print Text Console Parametrisation Serial Port Selected
  println("Serial Port Open");
  println("Name: "+namePortSelect);
  println("baudRate: "+baudRate);
  println("parity: "+parity);
  println("dataBits: "+dataBits);
  println("stopBits: "+stopBits); 
  println("---------------------");
}


//Unused Function for Send a Char for the Serial Port
boolean SerialWrite(char c){
   pSerie.write(c);
  return true;
}

//RecUnused Function for Receiving a Serial Port Char
char SerialRead(){
  char c;
  if(pSerie.available()>0)
  {
    c= pSerie.readChar();
    print(c);
    return c;  
  }
  else return 0;
}

// One Character String Reception Event
// We have set a buffer that will trigger the call to Serial Event
// when the TERMINATOR char is received (default programmed a \n-> New line (10)
void serialEvent(Serial pS)
{
  cgTrama = pS.readString();
  cTrama = "";
  valList = split(cgTrama, SEPARADOR);
  for (int i=0; i<valList.length;i++){
    valTrama[i] =parseInt(valList[i]); 
    cTrama = cTrama + str(valTrama[i]);
    if(i!= (valList.length-1)) cTrama = cTrama + ",";
  }
  clenDat = valList.length;
  fpTrama = true;
  npx ++;
  firstDate = true;
} 
