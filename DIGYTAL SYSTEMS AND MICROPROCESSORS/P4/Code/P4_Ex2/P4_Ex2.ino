// STEP 1: INITIALIZE VARIABLES
const int analogpin = A0; // Analog pin
const int baudrate = 9600; // Baudrate is the speed at which data bits are going to be transmitted
float sensorvalue = 0; // Variable used for the sensor value
const int lowestPin = 2;  // Red pin
const int mediumPin = 3;  // Green pin
const int highestPin = 4; // Blue pin
int brightness = 255;   // variable defined for brightness

// The following variables will be used for the musical notes of the buzzer
int tempo = 200; // tempo used
char notesName[] = {'b', 'c'}; // names for the notes
int tones[]= {500, 250}; // variable to define the tones
int duration = 3; // variable to define the duration
int buzzerPin = 23;  // Pin at which the buzzer is connected

// STEP 2: SETUP FUNCTION. This routine runs once when reset is pressed
void setup() {

  // initialize serial communication at 9600 bits per second:
  Serial.begin(baudrate);

  // Set analog reference to the default system voltage
  analogReference(DEFAULT);

  // All the pins used are set as outputs
  pinMode(lowestPin, OUTPUT);
  pinMode(mediumPin, OUTPUT);
  pinMode(highestPin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);
  delay(500); // delay of half a second
}

// STEP 3: LOOP FUNCTION
void loop() {
  resetled(); // Reset the LED, helping to tern them off in each iteration
  // read the input (sensor value) on analog pin 0
  sensorvalue = analogRead(A0);

  // print out the value read:
  Serial.print("ADC code = ");
  Serial.println(sensorvalue);
  Serial.print("Inpt voltage source = ");
  float temp = sensorvalue*5/1023;
  Serial.println(temp);
  // Computing the temperature in degrees
  float t = temp*100;
  delay(1000); // delay of 1s

  // Determine the tone of the piezoelectric based on the sensor value in the following if-else body
  if (temp<0.25){
    Serial.print("Temperature is below 25 degrees: ");
    Serial.println(t);
    analogWrite(lowestPin, brightness); // Red brights
    tone(buzzerPin, tones[0], duration * tempo);
    delay(200);
  }
  else if ((temp>=0.25)&&(temp<=0.3)){
    Serial.print("Temperature is normal: ");
    Serial.println(t);
    analogWrite(mediumPin, brightness); // Green brights
    noTone(23); // No sound
    delay(200); 
  }
  else{
    Serial.print("Temperature is above 30 degrees: ");
    Serial.println(t);
    analogWrite(highestPin, brightness);
    tone(buzzerPin, tones[1], duration * tempo); // Blue brights
    delay(200);
  }

  delay(1000);  // delay in between reads for stability
}


// STEP 4: reset LED color from measurement to measurement
void resetled(){
  int brightness = 0;
  analogWrite(highestPin, brightness);
  analogWrite(mediumPin, brightness);
  