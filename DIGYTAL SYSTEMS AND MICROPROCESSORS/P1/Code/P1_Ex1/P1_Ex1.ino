void setup() {
  // Here we define the components of our circuit, 
  //and the pins where the LED's are connected to supply them with power:
pinMode (24,OUTPUT);
pinMode (28,OUTPUT);
pinMode (32,OUTPUT);
pinMode (36,OUTPUT);
pinMode (40,OUTPUT);
pinMode (44,OUTPUT);
}

void loop() { // Turn the 6 LED's ON and OFF every second
  digitalWrite(24,HIGH);
  digitalWrite(28,HIGH);
  digitalWrite(32,HIGH);
  digitalWrite(36,HIGH);
  digitalWrite(40,HIGH);
  digitalWrite(44,HIGH);
  delay(1000); // Turn the 6 LEDs OFF every second (1000 ms = 1 s)
  digitalWrite(24,LOW);
  digitalWrite(28,LOW);
  digitalWrite(32,LOW);
  digitalWrite(36,LOW);
  digitalWrite(40,LOW);
  digitalWrite(44,LOW);
  delay(1000); // Turn the 6 LEDs ON every second (1000 ms = 1 s)
}
