//Bienen Simulation
//Darius Effert
//version 30.05.2020

//Bienenarray
Biene[] schwarm;

//Blumenlisten
ArrayList<Blume> blumenwiese;
ArrayList<Blume> ziele;
ArrayList<Integer> timer;

//Anzahlen der jeweiligen max Einheiten
final int anzahlBienen = 100;
final int anzahlBlumen = 5;

final int lebenszeit = 840;

//Hintergrundbild von www.myfreetextures.com
// https://www.myfreetextures.com/seven-free-grass-textures-or-lawn-background-images/
PImage bg;

// Setup-Methode-----------------------------------------------------------------------------------------------------
void setup(){
  //für 1920x1080
  size(1500, 1000);
  
  //Erzeugen des Bienenschwarms
  schwarm = new Biene[anzahlBienen];
  for(int i = 0; i < anzahlBienen; i++){
    schwarm[i] = new Biene(random(width), random(height));
  }
  
  //Initialisierung der Listen
  blumenwiese = new ArrayList<Blume>();
  ziele = new ArrayList<Blume>();
  timer = new ArrayList<Integer>(); 
  
  //Hintergrundbild 
  bg = loadImage("grass-texture-number-1.jpg");
  
}

// Draw-Methode -----------------------------------------------------------------------------------------------------
void draw(){
  
  //Hintergrund zeichnen
  background(bg);
  
  //Blumen zeichnen
  for(int i = 0; i < blumenwiese.size(); i++){
    blumenwiese.get(i).draw();
  }
  
  //Timer und Blumenziele updaten
  for(int i = 0; i < timer.size(); i++){
    
    //Timer erhöhen
    timer.set(i, timer.get(i) + 1);
    
    //Blume als Ziel hinzufügen falls gewachsen
    if(timer.get(i) == 200){
      
      //Blume zu Zielen hinzufügen
      ziele.add(blumenwiese.get(i));
      
      //Neue Ziele finden
      for(int j = 0; j < anzahlBienen; j++){
        schwarm[j].findeZiel();
      }
    }
    
    //Löschen des Ziels bei Lebenszeitende
    if(timer.get(i) == lebenszeit){
      ziele.remove(0);
      
      //Neue Ziele finden
      for(int j = 0; j < anzahlBienen; j++){
        schwarm[j].findeZiel();
      }
    }
    
    //Ausblenden der Blume bei Lebenszeitende
    if(timer.get(i) >= lebenszeit){
       blumenwiese.get(i).ausblenden();
    }
    
    //Löschen von Blume und Timer
    if(timer.get(i) >= lebenszeit + 100){
      blumenwiese.remove(0);
      timer.remove(0);
    }
  }
  
  // Bienen zeichnen
  for(int i = 0; i < anzahlBienen; i++){
    schwarm[i].draw();
  }
  
}

//Bei Mausklick neue Blume und Timer erstellen
void mousePressed(){
  
    //Nur falls weniger als max Blumen
    if(blumenwiese.size() < anzahlBlumen){
      
      //Neue Blume hinzufügen
      blumenwiese.add(new Blume(mouseX, mouseY, getBluetenFarbe(), getNarbenFarbe(), random(30,40),random(80,120)));
      timer.add(0);     
    }   
    
}

//Erzeuge Blütenfarbe
color getBluetenFarbe(){
  color col = 0;
  float temp;
  switch((int)random(1,9)){
    //rot
    case 1: col = color(random(230, 255),0 ,0);
      break;
    //gelb
    case 2: col = color(random(230, 255),random(230,255) ,0);
      break;
    //orange
    case 3: col = color(random(230, 255),random(120, 230) ,0);
      break;
    //blau und violett
    case 4: col = color(random(200),random(200), random(230, 255));
      break;
    //weiß
    case 5: col = color(random(240, 255),random(240, 255) ,random(240, 255));
      break;
    //magenta
    case 6: col = color(random(120, 255) ,0 ,random(120, 255));
      break;
    //rosa
    case 7: temp = random(150,180);
      col = color(random(230, 255),temp ,temp);
      break;
    //grünlich
    case 8: temp = random(210,240);
      col = color(temp,random(240, 255),temp);
      break;
  }
  return col;
}
  
//Erzeuge Narbenfarbe
color getNarbenFarbe(){
  color col = 0;
  float temp;
  switch((int)random(1,14)){
    //gelb + orange
    case 1:
    case 2: col = color(random(230, 255),random(120, 230) ,0);
      break;
    //gelb
    case 3:
    case 4:
    case 5: col = color(random(230, 255),random(230,255) ,0);
      break;
    //braun
    case 6:
    case 7: temp = random(50, 70);
      col = color(random(100, 120),temp ,temp / 2);
      break;
    //dunkleres braun
    case 8:
    case 9: temp = random(40, 60);
      col = color(random(90, 100),temp ,temp / 2);
      break;
    //dunkelstes braun
    case 10:
    case 11: temp = random(20, 40);
      col = color(random(60, 70),temp ,temp / 2);
      break;
    //grün
    case 12: col = color(random(140, 210) ,random(230, 255) ,random(50, 100));
      break;
    //rot
    case 13: col = color(random(150, 200), 0 ,random(0, 50));
      break;
  }
  return col;
}
