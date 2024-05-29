// Set the name of the LED's, the button and their corresponding pin, as well as other instances
int led1 = 1;
int led2 = 2;
int led3 = 3;
int buttonState = 0;
int button = 52;
int count = 0;

// Define the pins the LED's are connected to
void setup() {
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(button, INPUT_PULLUP); // this solves floating point effect
  // Serial.begin(9600);
}
// When the button is HIGH its not pressed due to the configuration used (a pull down resistor should reverse this situation)
// Therefore, since we want to change states (++count) when we press the botton we say that when the state is LOW (pressed) we light up the corresponding LED
// We want to maintain the previous state after releasing the button, hence we need an if condition where button is high as control 
// when the count value goes over 8 the LEDS reset and we start again
void loop() {
  buttonState = digitalRead(button);
  delay(50);
  if(buttonState == HIGH){ // In a 3-bit counter there are 8 possible combinations (2^8) of turned on LED's (000,111,100,001,010,110,011,101)
  
  }
  else if((buttonState == LOW) && (count < 7)) // when I press botton at count = 7, we enter the if and the we sum +1 to the count, so when <8 we do one more iteration
  {
    ++count;
    if(count==2 || count==4 ||count==6 || count==0) // By buildig the circuit excitation table if conditions for the different states can be defined
  {
   digitalWrite(led1,LOW);
  }
    else
  {
   digitalWrite(led1,HIGH);
  }
    if(count==2 || count==3 || count==6 || count==7)
  {
   digitalWrite(led2,HIGH); 
  }
    else
  {
   digitalWrite(led2,LOW);
  }
    if(count>3)
  {
   digitalWrite(led3,HIGH); 
  }
    else
  {
   digitalWrite(led3,LOW);
  }
    delay(300);
    // Serial.print("LED IS OFF");
    //Serial.print('\n');

  }
  else {
    reset();
    // Serial.print(count);
  }
}

// Set all LEDs off to make sure we start at zero and reset the count
void reset() {
  count = 0;
  digitalWrite(led1,LOW);
  digitalWrite(led2,LOW);
  digitalWrite(led3,LOW);
  delay(500);
}