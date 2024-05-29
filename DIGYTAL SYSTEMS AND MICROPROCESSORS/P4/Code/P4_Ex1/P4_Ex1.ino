// STEP 1: INITIALIZE VARIABLES
const int redPin = 2; // Pin for the red color of the RGB LED
const int greenPin = 3; // Pin for the green color of the RGB LED
const int bluePin = 4; // Pin for the blue color of the RGB LED
const int analogpin = A0; // Analog pin
const int baudrate = 9600; // Baudrate is the speed at which data bits are going to be transmitted
float sensorvalue = 0; // Variable used for the sensor value
int brightness = 0; // Variable used for the brightness of the LED
int cont = 0; // variable used to count

// STEP 2: SETUP FUNCTION. This routine runs once when reset is pressed
void setup() {
  // Set the pins as outputs
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);

  // Initialize serial communication with a specific baud rate defined previously
  Serial.begin(baudrate);

  // Set analog reference to the default system voltage
  analogReference(DEFAULT);

  delay(100); // delay of 100 ms 
}

// STEP 3: LOOP FUNCTION
void loop() {
  // read the input (sensor value) on analog pin 0
  sensorvalue = analogRead(A0);  

  // Print out the value read
  Serial.print("ADC code = ");
  Serial.println(sensorvalue);
  Serial.print("Input voltage source = ");
  Serial.println(sensorvalue * 5 / 1023);
  delay(200); // delay in between reads for stability

  // Determine the brightness of the LED based on the sensor value in the following if-else body
  if ((sensorvalue >= 0) && (sensorvalue<171)){
      cont = 0;
      brightness = 255;
      delay(10);
  }
    else if ((sensorvalue >=171) && (sensorvalue < 342)){
      cont = 1;
      brightness = 210;
      delay(10);
  }
    else if ((sensorvalue >=342) && (sensorvalue < 513)){
      cont = 2;
      brightness = 160;
      delay(10);
  }
    else if ((sensorvalue >=513) && (sensorvalue < 684)){
      cont = 3;
      brightness = 105;
      delay(10);
  }
    else if ((sensorvalue >=684) && (sensorvalue <855)){
      cont = 4;
      brightness = 55;
      delay(10);
  }
    else if ((sensorvalue >=855) && (sensorvalue <= 1023)){
      cont = 5;
      brightness = 0;
      delay(10);
  }

  // Set brightness of the three RGB LEDs
  analogWrite(redPin, brightness);
  analogWrite(greenPin, brightness);
  analogWrite(bluePin, brightness);

  // Print the measured light range
  Serial.print("MEASURED LIGHT RANGE = ");
  Serial.println(cont);
  delay(200); // Delay of 200ms
}
