/***********************************************/
/*   Envio de Variables analogicas mediante    */
/*   la generación de cadenas de caracteres    */ 
/*   con los valores separados por comas.      */
/*********************************************+*/    

//Libraries and Defines
#define SIGNAL  7   //Signal number minus one

//Global Variables
int id = 0;
float Y[8];
String S[] = {"", "", "", "", "", "", "", "" };
String s;
int led = LED_BUILTIN;
boolean estadoLed = true;

void setup() {
  //Config Serial por to 115200 baud
  Serial.begin(115200);
  //Config pin Led Builtin
  pinMode(led, OUTPUT);
  //Config pin for input stop transmision serial port
  pinMode(2, INPUT_PULLUP);
}   //END setup()

void loop() {
  //Diverse mathematical functions of analog signal for compose the text 
  //string with their values separated by commas for sent through the serial port
  //and to be able to test the Analogic Variables monitor written in Processing
  if (digitalRead(2)){ //If input is made low, data is no longer sent by the serial port
    //Función 1
    Y[0] = 600 * cos( 2 * PI * id / 400 );
    S[0] =  String(Y[0]);
    //Function 2
    Y[1] = 600 * sin( 2 * PI * id / 400 );
    S[1] =  String(Y[1]);
    //Function 3
    Y[2] = (Y[0] + Y[1]) * 0.6;
    S[2] =  String(Y[2]);
    //Function 4
    if (id >= 0 && id < 100) Y[3] = 4 * id;
    else if ( id >= 100 && id < 300) Y[3] = -4 * ( id - 100 ) + 400;
    else Y[3] = 4 * ( id - 300 ) - 400;
    S[3] =  String(Y[3]);
    //Function 5
    if ( id >= 0 && id < 200) Y[4] = 500;
    else Y[4] = -500;
    S[4] =  String(Y[4]);
    //Function 6
    if ( id >= 0 && id < 200) Y[5] = -3 * id + 300;
    else Y[5] = -3 * ( id - 200 ) + 300;
    S[5] =  String(Y[5]);
    //Function 7
    if ( id >= 0 && id < 200 ) Y[6] = 300 * sin( PI * id / 200 ) + 300;
    else Y[6] = 0;
    S[6] =  String(Y[6]);
    //Function 8
    if (id >= 0 && id < 100) Y[7] = 400;
    else if ( id >= 100 && id < 200) Y[7] = 0;
    else if ( id >= 200 && id < 300) Y[7] = -400;
    else Y[7] = 0;
    S[7] =  String(Y[7]);
    //Create the String to send by the Serial Port
    s = "";
    for ( int i = 0; i <= SIGNAL; i++ ) {
      s = s + S[i];
      if ( i < SIGNAL ) s = s + ",";
    }
    Serial.println(s);
    if (id <= 200) {
      estadoLed = LOW;
    }
    else estadoLed = HIGH;
    digitalWrite(led, estadoLed);
    delay(25);
    id++;
    if (id > 400) id = 0;
  }
}   //END setup()
