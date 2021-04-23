Table table;
StringList states = new StringList();
IntList areas = new IntList();

int tableSize;

String loadingMessage = "Connecting to database";
String dots = ".";
int fakeLoadingTime = 2;
int loadingProgress;

int mouseInfoIndex;
String mouseInfoText;

void setup() {
  
  size(1000, 500);
  surface.setResizable(true);
  background(0);
  
  thread("setupArrays");
}

void draw() {
  
  background(0);
  
  if(loadingMessage != "Done")
    drawLoading();
  else
    drawDiagram();
}

void drawLoading() {
  
  textAlign(CENTER);
  textSize(50);
  text(loadingMessage + dots, width/2 + dots.length() * 8, height/2);
  
  delay(500);
  dots += '.';
  if(dots.length() >= 4)
    dots = "";
  
  stroke(255);
  fill(0);
  rect(width * 1f/3f, height * 3f/5f, width * 1f/3f, height * 1f/10f);
  fill(255);
  rect(width * 1f/3f, height * 3f/5f, width * (loadingProgress / 100f)/3f, height * 1f/10f);

}

void drawDiagram() {
  
  noStroke();
  fill(255);
  textAlign(LEFT);
  textSize(width / 100);
  
  for(int i = 0; i < tableSize; i++) {
    
    colorMode(HSB);
    fill((float)i / tableSize * 255, 255, 255);
    
    pushMatrix();
      translate(i * (width / 52), height - areas.get(i) / 750f * (height / 1000f));
      rect(0, 0, (width / 52) - 1, 1000);
      rotate(radians(-90));
      text(states.get(i), 2, (width / 52) - 1);
    popMatrix();
  }
  
  drawMouseInfo();
}

void drawMouseInfo() {
  
  mouseInfoIndex = round(mouseX / (width / states.size()));
  
  if(mouseInfoIndex >= states.size())
    mouseInfoIndex = states.size() - 1;
  
  mouseInfoText = states.get(mouseInfoIndex) + ": " + areas.get(mouseInfoIndex) + " sq. mi";
  
  textSize(25);
  textAlign(LEFT);
  
  fill(0);
  text(mouseInfoText, mouseX + 1, mouseY + 1);
  text(mouseInfoText, mouseX + 1, mouseY - 1);
  text(mouseInfoText, mouseX - 1, mouseY + 1);
  text(mouseInfoText, mouseX - 1, mouseY - 1);
  
  fill(255);
  text(mouseInfoText, mouseX, mouseY);
}

void setupArrays() {
  
  table = loadTable("https://raw.githubusercontent.com/jakevdp/data-USstates/master/state-areas.csv", "header");
  
  tableSize = table.getRowCount();
  int tempHighRow;
  
  float progress = 0;
    
/* Her bliver table sorteret. Den leder først efter den højeste area-værdi i table, så sætter den denne area-værdi og den tilsvarende stat ind i hver deres lister, og så fjerner den denne area-værdi og stat fra table, og så gentager den denne process indtil vi tilsidst har en liste med area og stat, hvor de så vil være sorteret efter area-størrelse. */ //Jeg endte med at finde ud af, at der findes en table.sort()-metode, der gør lige præcis dette...
  for(float i = 0; i < tableSize; i++) {
    
    tempHighRow = 0;
    
    for(int j = 0; j < table.getRowCount(); j++) {
      if(table.getInt(j, "area (sq. mi)") > table.getInt(tempHighRow, "area (sq. mi)"))
        tempHighRow = j;
      
      //Bare falsk loading tid.
      delay(round(random(fakeLoadingTime)));
      
      progress++;
      loadingProgress = round(progress / 13.78);
      
      loadingMessage = "Sorting data table: " + loadingProgress + "%";
    }
    
    states.append(table.getString(tempHighRow, "state"));
    areas.append(table.getInt(tempHighRow, "area (sq. mi)"));
    
    table.removeRow(tempHighRow);
  } //<>//
    
  loadingMessage = "Done";
}
