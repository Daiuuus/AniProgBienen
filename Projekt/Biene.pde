class Biene{
  
  //Position der Biene
  float posX, posY;
  
  //Ziel der Biene
  float zielX, zielY;
  
  //Variablen für Schwebe
  float schwebeX, schwebeY;
  int zaehlerS, zeitS;
  
  //Variablen für Drehung
  float zielAusrichtung;
  float aktuelleAusrichtung;
  
  //Bool für Zielabstand
  boolean zielErreicht;
  
  boolean keinZiel;
  
  //Timer für Bewegungen
  int timerBiene;
  int timerBieneMax;
  
  //Manuelle Tweaks
  final float speed = 1.5;
  final int minAbstand = 50;
  final int maxAbstand = 90;
  final int kollisionsAbstand = 45;
  final float kollsionsBewegung = 1.2;
  
  //Konstruktor
  Biene(float x, float y){
    
    //Position setzen
    posX = x;
    posY = y;
    
    //Ziel is Position am Start
    zielX = posX;
    zielY = posY;
    
    aktuelleAusrichtung = random(0, PI);
    
    //Variablen initialisieren
    zielErreicht = false;
    keinZiel = true;
    timerBiene = 0;
    timerBieneMax = (int) random(120, 240);
  }
  
  
  void draw(){
    
    pushMatrix();
    
    //Verschiebung
    translate(posX, posY);
      
    //Drehen (+PI weil Biene sonst falschherum)
    rotate(berechneDrehung() + PI);
    
    //Biene zeichnen -----------------------------------------------------------------
    
    //Körper
    pushStyle();
    fill(220,195,0);
    noStroke();
    ellipse(0, 0, 30, 15);
    popStyle();
    
    //Streifen + Stachel
    pushStyle();
    fill(30,15,0);
    noStroke();
    ellipse(9, 0, 3, 13);
    ellipse(-9, 0, 3, 13);
    ellipse(3, 0, 3, 15);
    ellipse(-3, 0, 3, 15);
    ellipse(-17, 0, 6, 2);
    popStyle();
    
    //Kopf
    pushStyle();
    fill(70,40,0);
    noStroke();
    ellipse(18, 0, 12, 14);
    popStyle();
    
    //Flügel
    pushStyle();
    fill(0, 40);
    stroke(0, 80);
    ellipse(4, -12, 15, 25);
    ellipse(4, 12, 15, 25);
    popStyle();
    
    popMatrix();
    
    //Biene gezeichnet -----------------------------------------------------------------
    
    //Bienenbewegung
    if(timerBiene > timerBieneMax && keinZiel){
      findeZiel();
      resetZiel();
      timerBiene = 0;
      timerBieneMax = (int) random(120, 240);
    }
    
    if(timerBiene > 60){
      findeZiel();
    }
    
    //Erhöhe Bewegungstimer
    timerBiene++;
    
    //Zielbewegung
    bewegen();
    
    //Schwebebewegung
    schweben();
    
    //Kollision
    kollidieren();
    
  }
  
  //Drehung berechnen
  float berechneDrehung(){
    
    //Drehwinkel bestimmen
    zielAusrichtung = atan2(zielY-posY, zielX-posX) + PI;
    
    //Drehrichtung festlegen
    if(aktuelleAusrichtung < zielAusrichtung - PI/64) {
      if(abs(aktuelleAusrichtung - zielAusrichtung)<PI){
        aktuelleAusrichtung += PI/64;
      }
      else {
        aktuelleAusrichtung -= PI/64;
      }
    }
    else if(aktuelleAusrichtung > zielAusrichtung + PI/64){
      if(abs(aktuelleAusrichtung - zielAusrichtung)<PI){
         aktuelleAusrichtung -= PI/64;
      }
      else {
        aktuelleAusrichtung += PI/64;
      }
    } 
    
    //Normalisieren
    aktuelleAusrichtung %= 2*PI;
    if(aktuelleAusrichtung < 0){
      aktuelleAusrichtung += 2*PI;
    }
    
    return aktuelleAusrichtung;
  }
  
  //Bewegung
  void bewegen(){
    //Differenzen bestimment
    float deltaX = abs(posX - zielX);
    float deltaY = abs(posY - zielY);
    
    float moveX, moveY;
    
    //Bewegung auf max 1 normalisieren
    if(deltaX >= deltaY){
      moveX = 1;
      moveY = deltaY/deltaX;
    }
    else{
      moveX = deltaX/deltaY;
      moveY = 1;
    }
    
    //Geschwindigkeit festlegen
    moveX *= speed;
    moveY *= speed;
    
    //Abstand berechnen
    float abstand = sqrt(pow(deltaX, 2) + pow(deltaY, 2));
    
    //Bewegung zum Ziel
    if(!zielErreicht){
      if(posX > zielX && abstand > minAbstand){
        posX -= moveX;
      }
      else if(posX < zielX && abstand > minAbstand){
        posX += moveX;
      }
      if(posY > zielY && abstand > minAbstand){
        posY -= moveY;
      }
      else if(posY < zielY && abstand > minAbstand){
        posY += moveY;
      }
    }  
    else if( abstand > maxAbstand) {
      //Ziel Erreicht
      zielErreicht = false;      
    }
    
    if(abstand < minAbstand){
      //Zielbereich verlassen
      zielErreicht = true;
    }
    
  }
  
  //Kollision
  void kollidieren(){
    for(int i = 0; i < anzahlBienen; i++){
      //Postion von Kollisionsobjekt bekommen
      float posX2 = schwarm[i].getX();
      float posY2 = schwarm[i].getY();
      
      //Abstand berechnen
      float deltaPosX = abs(posX - posX2);
      float deltaPosY = abs(posY - posY2);    
      float abstandPos = sqrt(pow(deltaPosX, 2) + pow(deltaPosY, 2));
      
      //Kollidierbewegung
      if(posX < posX2 && abstandPos < kollisionsAbstand){
        posX -= kollsionsBewegung;
      }
      else if(posX > posX2 && abstandPos < kollisionsAbstand){
        posX += kollsionsBewegung;
      }
      if(posY < posY2 && abstandPos < kollisionsAbstand){
        posY -= kollsionsBewegung;
      }
      else if(posY > posY2 && abstandPos < kollisionsAbstand){
        posY += kollsionsBewegung;
      }    
    }  
  }
  
  //Schwebebewegung
  void schweben(){
    //Schwebebewegung zurücksetzen falls zufällige Zeit erreicht
    if(zaehlerS >= zeitS){
      schwebeX = random(-0.1,0.1);
      schwebeY = random(-0.1,0.1);
      zeitS = (int) random(0,90);
      zaehlerS = 0;
    }   
    
    //Schwebebewegung durchführen
    posX += schwebeX;
    posY += schwebeY;
    zaehlerS++;
  }
  
  //Finde nächstes Ziel
  void findeZiel(){
    
    //Annahme dass Ziel gefunden wird
    keinZiel = false;
    
    //Temp Variablen für Berechnung
    float tempX;
    float tempY;
    float tempAbstand = 1000000;
    
    //Durchlaufe Ziele
    for(int i = 0; i < ziele.size(); i++){
      
      //Hole Positionen
      tempX = ziele.get(i).getX();
      tempY = ziele.get(i).getY();
      
      //Berechne Abstand
      float deltaZielX = abs(posX - tempX);
      float deltaZielY = abs(posY - tempY);    
      float abstandZiel = sqrt(pow(deltaZielX, 2) + pow(deltaZielY, 2));
      
      //Ersetze Ziel falls näher als vorheriges
      if(abstandZiel < tempAbstand){
        zielX = tempX;
        zielY = tempY;
        tempAbstand = abstandZiel;
      }
    }
    //Kein Ziel falls zu weit weg
      if(tempAbstand > 500){
        zielX = posX;
        zielY = posY;
        keinZiel = true;
      }
    
    //Falls keine Ziele, zufällige setzen
    if(ziele.size() == 0){
      keinZiel = true;
    }
  }
  
  //Neues Ziel setzen
  void resetZiel(){
    float tempX = random(-200, 200);
    zielX = (posX + tempX > width) ? width - 50 :  (posX + tempX < 0) ? 50 : posX + tempX;
    
    float tempY = random(-200, 200);
    zielY = (posY + tempY > height) ? height - 50 : (posY + tempY < 0) ? 50 : posY + tempY;

  }
  
  float getX(){
     return posX;
  }
  
  float getY(){
     return posY;
  }
  
}
