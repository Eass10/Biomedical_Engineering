void setup() {  
  // Here we define the components of our circuit, and the pins where the LED's are connected to supply them with power:
  pinMode(1,OUTPUT);
  pinMode(2,OUTPUT);
  pinMode(3,OUTPUT);
  pinMode(4,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);

}

void loop() {
  for (int i = 0;i<7;i++){ // The i value will increase from 0 to 7 (i++ increase)
    digitalWrite(i+1, HIGH); //The LED i+1 turns on
    digitalWrite(i, LOW); //The LED i turns off
    delay(200); //delay of 200 ms
  }
  for (int s = 6; s >1;s--){ //The s value will decerase from 6 to 2 (s-- decrease)
    if (s == 2){ //When s == 2
      digitalWrite(s-1,LOW); //LED 1 TURNS OFF
      digitalWrite(s, LOW); // LED 2 TURNS OFF
    }
    else{   //When s is == 6,5,4,3:
    digitalWrite(s-1, HIGH); //LED s-1 turns on
    digitalWrite(s, LOW); //LED s turns off
    delay(200); //delay of 200 ms
    }
  }

}



