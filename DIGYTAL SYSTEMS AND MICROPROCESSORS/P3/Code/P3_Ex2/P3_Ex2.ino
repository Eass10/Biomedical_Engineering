// STEP 1: INITIALIZE VARIABLES
const int analogpin = A0; // analog pin
const int baudrate = 9600; // baudrate is the speed at which data bits are going to be transmitted
float sensorvalue = 0; // variable used for the sensor value

// STEP 2: SETUP FUNCTION. This routine runs once when reset is pressed
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(baudrate);
  // the analog reference pin is connected to the power supply of the board
  analogReference(DEFAULT);
  delay(500); // delay of 500 ms
}

// STEP 3: LOOP FUNCTION
void loop() {
  // read the input on analog pin 0:
  sensorvalue = analogRead(A0);

  // print out the value read:
  Serial.print("ADC code = ");
  Serial.println(sensorvalue);
  Serial.print("Inpt voltage source = ");

  // Computing the temperature in voltage
  float temp = sensorvalue*5/1023;
  // and printing it
  Serial.println(temp);

  // Computing the temperature in degrees
  float t = temp*100;
  
  delay(1000); // delay of 1s
  // The following if-else body for the different values that the temp variable will get depending on the sensor value
  if (temp<0.25){
    Serial.print("Temperature is below 25 degrees. Exactly ");
    Serial.println(t);
  }
  else if ((temp>=0.25)&&(temp<=0.3)){
    Serial.print("Temperature is normal. Exactly ");
    Serial.println(t);
  }
  else{
    Serial.print("Temperature is above 30 degrees. Exactly ");
    Serial.println(t);
  }

  delay(1000);  // delay in between reads for stability
}
