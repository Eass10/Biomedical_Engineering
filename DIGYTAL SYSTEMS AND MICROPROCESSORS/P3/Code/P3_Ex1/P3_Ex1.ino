// STEP 1: INITIALIZE VARIABLES
const int analogpin = A0; // analog pin
const int baudrate = 9600; // baudrate is the speed at which data bits are going to be transmitted
float sensorvalue = 0; // variable used for the sensor value
int cont = 0; // variable used to count
int displaypin[] = {2,3,4,5,6,7,8}; //pins used to connect the the 7-segment display to the microcontroller

//7 segment display code is summarised in a matrix, containing in different rows the sequence of pins that must power the corresponding segments of the 7-segment display in order to display numbers from 0 to 9
int displaycode[10][7]=
  {
  {1,1,1,1,1,1,0}, //0
  {0,1,1,0,0,0,0}, //1
  {1,1,0,1,1,0,1}, //2
  {1,1,1,1,0,0,1}, //3
  {0,1,1,0,0,1,1}, //4
  {1,0,1,1,0,1,1}, //5
  {1,0,1,1,1,1,1}, //6
  {1,1,1,0,0,0,0}, //7
  {1,1,1,1,1,1,1}, //8
  {1,1,1,1,0,1,1}, //9
  };

// STEP 2: SETUP FUNCTION. This routine runs once when reset is pressed
void setup() {
  // initialize serial communication with a specific baud rate defined previously
  Serial.begin(baudrate);

  // the analog reference pin is connected to the power supply of the board
  analogReference(DEFAULT);

  // each of the vector's values will be configured as an output pin of the microcontroller with a for loop that starts when the counter (i) is zero and stops when the counter is i<=6 to equal the length of the pin vector 
    for(int i=0;i<=6;i++){
    pinMode(displaypin[i], OUTPUT);
  }

  Serial.begin(baudrate);
  delay(100); // delay of 100 ms 

  // display the number carried by the cont variable and print it in serial monitor for the user to see
  segmentdisplay(cont);
  Serial.print("Number = ");
  Serial.println(cont);
  
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
  Serial.println(sensorvalue*5/1023);
  delay(200);  // delay in between reads for stability
  
  // The following if-else body for the different values that the cont variable will get depending on the sensor value
    if ((sensorvalue >= 0) && (sensorvalue<=171)){
    cont=0;
  }
    else if ((sensorvalue >=171) && (sensorvalue <= 342)){
    cont=1;
  }
    else if ((sensorvalue >=342) && (sensorvalue <= 513)){
    cont=2;
  }
    else if ((sensorvalue >=513) && (sensorvalue <= 684)){
    cont=3;
  }
    else if ((sensorvalue >=684) && (sensorvalue <= 855)){
    cont=4;
  }
    else if ((sensorvalue >=855) && (sensorvalue <= 1023)){
    cont=5;
  }
  // display the number carried by the cont variable and print it in serial monitor for the user to see
  segmentdisplay(cont);
  Serial.print("MEASURED LIGHT RANGE = ");
  Serial.println(cont); 
  
  delay(200); //delay of 200ms
}

// STEP 4: SEGMENTDISPLAY FUNCTION
void segmentdisplay(int x){
  // write the 7 segment display code to the output port pins, display the value in the cont variable using a for loop where the variable used in the for loop called i will be used to track columns in the displaycode matrix and the variable cont will be used to track the rows in the displaycode matrix
  for(int i=0;i<=6;i++){
    digitalWrite(displaypin[i], displaycode[x][i]);
  }
}
