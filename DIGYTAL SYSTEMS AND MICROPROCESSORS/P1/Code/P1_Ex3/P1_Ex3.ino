// Set the name of the LED's and their corresponding pin
int led1 = 1;
int led2 = 2;
int led3 = 3;

// Define the pins the LED's are connected to
void setup() {
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
}

void loop() {
  for(int i = 0; i < 8; ++i) // In a 3-bit counter there are 8 possible combinations (2^8) of turned on LED's (000,001,010,011,100,101,110,111)
  {
    if(i==2 || i==4 || i==6 || i==0) // By buildig the circuit excitation table if conditions can be defined
  {
   digitalWrite(led1,LOW);  // Pin 3 or LED 1 low when even, not glow
  }
    else
  {
   digitalWrite(led1,HIGH);
  }
  if(i==2 || i==3 || i==6 || i==7)
  {
   digitalWrite(led2,HIGH);  //Pin no 4 or LED 2 High -> Glow
  }
  else
  {
   digitalWrite(led2,LOW);
  }
  if(i>3)
  {
   digitalWrite(led3,HIGH);  //Pin 5 or LED 3 HIGH -> Glow
  }
  else
  {
   digitalWrite(led3,LOW);
  }
  delay(1000); /// wait for 1 second  
  }
  reset();   
}

  // Set all LEDs off to make sure we start at zero
void reset() {
  digitalWrite(led1,LOW);
  digitalWrite(led2,LOW);
  digitalWrite(led3,LOW);
}