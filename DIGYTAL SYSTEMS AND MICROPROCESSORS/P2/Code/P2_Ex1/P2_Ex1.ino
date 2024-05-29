// STEP 1: INITIALIZE VARIABLES
int cont = 0; // variable used to count
int buttonState = 0; // button state
int prevButtonState = HIGH; // previous state
int button = 22; // button pin
int displaypin[] = {2,3,4,5,6,7,8}; //pins used to connect the 7-segment display to the microcontroller
const int baudrate = 9600; // baudrate is the speed at which data bits are going to be transmitted

// 7 segment display code is summarised in a matrix, containing in different rows the sequence of pins that must power the corresponding segments of the 7-segment display in order to display numbers from 0 to 9
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

// STEP 2: SETUP FUNCTION
void setup() {
  pinMode(button, INPUT_PULLUP); // this solves floating pin effect of the button
  // each of the vector's values will be configured as an output pin of the microcontroller with a for loop that starts when the counter (i) is zero and stops when the counter is i<=6 to equal the length of the pin vector 
  for(int i=0;i<=6;i++){
    pinMode(displaypin[i], OUTPUT);
  }
  // initialize serial communications module with a specific baud rate defined previously
  Serial.begin(baudrate);
  delay(100); // delay of 100ms to give time to the system to initialize
  // display the count and the printed on the serial monitor
  segmentdisplay(cont); 
  Serial.print("Number = ");
  Serial.println(cont);
  delay(1000); //delay of 1000ms before loop starts
}

// STEP 3: LOOP FUNCTION
void loop() {
  buttonState = digitalRead(button); // check if button is pressed (LOW) or not (HIGH)
  delay(50); // delay of 50ms to wait for oscillation of button to stop
  // When the button is pressed we enter the if condition and only changes when pressing and unpressing it
  if (buttonState == LOW && prevButtonState != LOW) {
    // Increase cont, reset to 0 if cont is 9
    cont = (cont == 9) ? 0 : cont + 1;
  }
  // display the number carried by the cont variable and print it in serial monitor for the user to see
  segmentdisplay(cont); 
  Serial.print("Number = ");
  Serial.println(cont);
  
  delay(300); //delay of 300ms before reading the state of the button again
}

// STEP 4: SEGMENTDISPLAY FUNCTION
void segmentdisplay(int x){
  // write the 7 segment display code to the output port pins, display the value in the cont variable using a for loop where the variable used in the for loop called i will be used to track columns in the displaycode matrix and the variable cont will be used to track the rows in the displaycode matrix
  for(int i=0;i<=6;i++){
    digitalWrite(displaypin[i], displaycode[x][i]);
  }
}
