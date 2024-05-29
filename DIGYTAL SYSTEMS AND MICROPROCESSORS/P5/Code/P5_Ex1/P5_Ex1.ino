// STEP 1: INITIALIZE VARIABLES
const int baudrate = 9600; // Baudrate is the speed at which data bits are going to be transmitted
const int lowestPin = 2;  // Red Pin
const int mediumPin = 3;  // Green Pin
const int highestPin = 4; // Blue Pin
int brightness = 255; // variable defined for brightness

// The following variables will be used for the musical notes of the buzzer
int tempo = 200; // tempo used
// char notesName[] = {'b', 'c'};
int tones[]= {440}; // variable to define the tones
int duration = 3; // variable to define the duration
int buzzerPin = 22; // Pin at which the buzzer is connected
int range = 0; // variable to define the range

#define EchoPin 36
#define TriggerPin 37

const long SoundSpeed = 173; // variable to define de sound speed
long EchoTime, Distance; 

// STEP 2: SETUP FUNCTION. This routine runs once when reset is pressed
void setup() {

  // initialize serial communication at 9600 bits per second:
  Serial.begin(baudrate);

  // All the pins used are set as outputs except the EchoPin
  pinMode(buzzerPin, OUTPUT);
  pinMode(lowestPin, OUTPUT);
  pinMode(mediumPin, OUTPUT);
  pinMode(highestPin, OUTPUT);
  pinMode(EchoPin, INPUT);
  pinMode(TriggerPin, OUTPUT);
  digitalWrite(TriggerPin, 0);
  
  delay(200); // delay of 200ms
}

// STEP 3: LOOP FUNCTION
void loop() {
  resetled(); // Reset the LED, helping to tern them off in each iteration

  // print out the value you read:
  digitalWrite(TriggerPin, 1);
  delayMicroseconds(10);
  digitalWrite(TriggerPin, 0);
  EchoTime = pulseIn (EchoPin, 1);
  Distance = SoundSpeed*EchoTime/1000;
  Serial.print("Echo Time(us) = ");
  Serial.print(EchoTime);
  Serial.print("  - Distance(mm) = ");
  Serial.println(Distance);
  delay(500);

  // Determine the range based on the sensor value (distance) in the following if-else body
  if ((Distance>=20)&&(Distance<100)){
    range = 0;
    analogWrite(lowestPin, brightness);
    noTone(buzzerPin);
  }
  else if ((Distance>=100)&&(Distance<200)){
    range = 1;
    analogWrite(highestPin, brightness);
    noTone(buzzerPin);
  }
  else if ((Distance>=200)&&(Distance<=300)){
    range = 2;
    analogWrite(mediumPin, brightness);
    noTone(buzzerPin);// stop the sound
  }
  else{
    range = 3;
    tone(buzzerPin, tones[0], duration * tempo);
  }
  Serial.println("The range is: ");
  Serial.print(range);
  delay(1000);  // delay in between distance reads for stability
}

// STEP 4: reset LED color from measurement to measurement
void resetled(){
  int brightness = 0;
  analogWrite(highestPin, brightness);
  analogWrite(mediumPin, brightness);
  analogWrite(lowestPin, brightness); 
}