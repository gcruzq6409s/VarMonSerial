/****************************************************************/
/*  Load colors for Graphics Bars from File: data/Colors.cfg   */
/****************************************************************/

//Global Variables for Storage Colors
color[] colorBarras = new color[20];

//Read the Color Configuration File
void readFileColors(){
  int ck = 0;
  int ckmax = 0;
  String[] lines = loadStrings("Colors.cfg");
  for (int i = 0 ; i < lines.length; i++) {
     if(!lines[i].startsWith("#")){
       if( ck!=0 && ck>=1 && ck<=ckmax){
         String[] ccolor = split(lines[i], ',');
         //println("ck: "+ck+" R: "+ccolor[0]+" G: "+ccolor[1]+" B: "+ccolor[2]);
         colorBarras[ck-1] = color(Integer.parseInt(ccolor[0]),Integer.parseInt(ccolor[1]),Integer.parseInt(ccolor[2]));
         ck++;
      }
      if(ck==0){
        ckmax = Integer.parseInt(lines[i]);
        ck++;
      }
    }
  }
}//End readFileColors
 
 
   
