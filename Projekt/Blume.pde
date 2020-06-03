class Blume{
 
 //Position der Blume
 float posX, posY;
  
 //Farben der Blume
 color narbeFill, narbeStroke;
 color blueteFillTop, blueteFillBottom; 
 color blueteStrokeTop, blueteStrokeBottom;
 
 //Timer für das Wachstum
 float timerBluete, timerNarbe;
 
 //Größen der Blütenblätter
 float breite, laenge;
 
 //Konstruktor -----------------------------------------------------------------------------------------------------
 Blume(float x, float y, color bluetenFarbe, color narbenFarbe, float breite, float laenge){
   
   //Position setzen
   posX = x;
   posY = y;
   
   //Farben setzen
   blueteFillTop = bluetenFarbe;
   narbeFill = narbenFarbe;
   
   //Berechne Farbe für untere Blüten
   blueteFillBottom = lerpColor(bluetenFarbe, color(0), 0.2);
   
   //Berechne Stroke Farben
   blueteStrokeTop = lerpColor(bluetenFarbe, color(0), 0.35);
   blueteStrokeBottom = lerpColor(bluetenFarbe, color(0), 0.55); 
   narbeStroke = lerpColor(narbenFarbe, color(0), 0.2);
   
   //Größen der Blütenblätter
   this.breite = breite;
   this.laenge = laenge;
   
   //Initialisiere Timer
   timerBluete = 0;
   timerNarbe= 0;
 }
 
 
 // Draw-Methode -----------------------------------------------------------------------------------------------------
 void draw(){
  
   //Narbe zuerst zeichnen
   pushStyle();
   
   //Farbwahl
   fill(narbeFill);
   stroke(narbeStroke);
   
   //Mittige Narbe
   ellipseMode(CENTER);
   
   
   //Wächst alle 2 Frames bis 70 erreicht bei 140 Frames
   ellipse(posX, posY, (timerNarbe / 2 > 70) ? 70 : timerNarbe / 2, (timerNarbe / 2 > 70) ? 70 : timerNarbe / 2);
   
   popStyle();
   
   //Falls Narbe fast fertig, starte Blütenwachstum
   if(timerNarbe > 130){
     
     //Winkel für Blütenreihenverschiebung
     float winkelReihe = 0;
     
     //Zeichnen der zwei Blütenblattreihen
     for(float i = 0; i < 2; i++){
       
       //Winkel für Blütenverschiebung
       float winkelBluete = 0 + winkelReihe;
       
       //Zeichnen bis 360Grad BluetenKreis
       pushStyle();
       
       while(winkelBluete < 2 * PI){
         
         pushMatrix();
         
         //Verschiebung
         translate(posX, posY);
         
         //Drehung + Animation
         rotate(winkelBluete + (timerBluete * PI / 512));
         
         //Farbwahl abhänig von Blütenreihe
         fill((i == 1) ? blueteFillTop : blueteFillBottom);
         stroke((i == 1) ? blueteStrokeTop : blueteStrokeBottom); 
         
         //Blüten beginnen am Rand der Narbe
         ellipseMode(CORNER);
         
         //Wächst alle 2 Frames in Breite bis Variable erreicht ist, wächst alle 2 Frames in Länge bis Variable erreicht ist
         ellipse(-15, 30, (timerBluete / 2 * (breite / laenge) > breite) ? breite : timerBluete / 2 * (breite / laenge), (timerBluete / 2 > laenge) ? laenge : timerBluete / 2);
         
         //Verschiebung des Blütenblattes
         winkelBluete += (PI / 8);
         
         popMatrix();
      }
      
      //Zeichnen eines Halbkreises für kontinuierliche Überlagerung
      if(winkelBluete >= 2 * PI){
        
        //Winkel der Problemstelle
        winkelBluete = PI/16;
        
        pushMatrix();
        
        //Verschiebung
        translate(posX, posY);
        
        //Drehung + Animation
        rotate(winkelBluete + (timerBluete * PI / 512));
        
        //Wächst alle 2 Frames in Breite bis Variable erreicht ist, wächst alle 2 Frames in Länge bis Vatiable erreicht ist
        arc(-15, 30, (timerBluete / 2 * (breite / laenge) > breite) ? breite : timerBluete / 2 * (breite / laenge), (timerBluete / 2 > laenge) ? laenge : timerBluete / 2, PI + PI / 2, 2 * PI + PI /2, OPEN); 
      }
      
      popMatrix();
      
      popStyle();
      
      //Verschiebung der Blütenblattreihen
      winkelReihe += PI/16;
     }
     
     //Erhöht Timer für BLütenwachstum
     timerBluete++;
   } 
   
   //Erhöht Timer für Narbenwachstum
   timerNarbe++;
 }
 
 //Blendet Blume aus
 void ausblenden(){
   narbeFill = lerpColor(narbeFill, color(100,0), 0.02);
   narbeStroke = lerpColor(narbeStroke, color(100,0), 0.02);
   blueteFillTop = lerpColor(blueteFillTop, color(100,0), 0.02);
   blueteFillBottom = lerpColor(blueteFillBottom, color(100,0), 0.02); 
   blueteStrokeTop = lerpColor(blueteStrokeTop, color(100,0), 0.02);
   blueteStrokeBottom = lerpColor(blueteStrokeBottom, color(100,0), 0.02);  
 }
 
 float getX(){
  return posX;
 }

 float getY(){
  return posY;
 }
 
 
}
