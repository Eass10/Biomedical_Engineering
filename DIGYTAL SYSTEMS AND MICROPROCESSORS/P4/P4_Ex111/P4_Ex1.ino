// STEP 1: INITIALIZE VARIABLES
const int analogpin = A0; // analog pin
const int baudrate = 9600; // baudrate is the speed at which data bits are going to be transmitted
float sensorvalue = 0; // variable used for the sensor value
int brightness = 0; // variable used for the brightness of the LED
const int highestPin = 4; // Only the highest pin is defined as only one color of the RGB LED
int cont = 0; // variable used to count


// STEP 2: SETUP FUNCTION. This routine runs once when reset is pressed
void setup() {
  // set up the pin 4 as an ouput
  pinMode(highestPin, OUTPUT);

  // initialize serial communication with a specific baud rate defined previously
  Serial.begin(baudrate);

  // the analog reference pin is connected to the power supply of the board
  analogReference(DEFAULT);

  Serial.begin(baudrate);
  delay(100); // delay of 100 ms 
}

// STEP 3: LOOP FUNCTION
void loop() {
  // read the input on analog pin 0
  sensorvalue = analogRead(A0);  

  // print out the value you read:
  Serial.print("ADC code = ");
  Serial.println(sensorvalue);
  Serial.print("Inpt voltage source = ");
  Serial.println(sensorvalue*5/1023);
  delay(200);  // delay in between reads for stability

  // The following if-else body for the different values that the cont variable will get depending on the sensor value
    if ((sensorvalue >= 0) && (sensorvalue<171)){
      cont = 0;
      brightness = 255;
      analogWrite(highestPin, brightness);
      delay(10);
  }
    else if ((sensorvalue >=171) && (sensorvalue < 342)){
      cont = 1;
      brightness = 210;
      analogWrite(highestPin, brightness);
      delay(10);
  }
    else if ((sensorvalue >=342) && (sensorvalue < 513)){
      cont = 2;
      brightness = 160;
      analogWrite(highestPin, brightness);
      delay(10);
  }
    else if ((sensorvalue >=513) && (sensorvalue < 684)){
      cont = 3;
      brightness = 105;
      analogWrite(highestPin, brightness);
      delay(10);
  }
    else if ((sensorvalue >=684) && (sensorvalue <855)){
      cont = 4;
      brightness = 55;
      analogWrite(highestPin, brightness);
      delay(10);
  }
    else if ((sensorvalue >=855) && (sensorvalue <= 1023)){
      cont = 5;
      brightness = 0;
      analogWrite(highestPin, brightness);
      delay(10);
  }
  // display the number carried by the cont variable and print it in serial monitor for the user to see
  Serial.print("MEASURED LIGHT RANGE = ");
  Serial.println(cont);
  delay(200); //delay of 200ms
}
