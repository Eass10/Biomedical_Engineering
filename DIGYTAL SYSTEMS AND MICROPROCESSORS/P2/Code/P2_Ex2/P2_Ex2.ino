// STEP 1: INITIALIZE VARIABLES
int cont; // variable used to count
int displaypin[] = {2,3,4,5,6,7,8}; //pins used to connect the 7-segment display to the microcontroller
const int baudrate = 9600; // baudrate is the speed at which data bits are going to be transmitted
int displaycode[10][7]= // this is the dimension of the matrix as in the previous exercise
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
  // this solves floating pin effect of the button
  // each of the vector's values will be configured as an output pin of the microcontroller with a for loop that starts when the counter (i) is zero and stops when the counter is i<=6 to equal the length of the pin vector 
  for(int i=0;i<=6;i++){
    pinMode(displaypin[i], OUTPUT);
  }
  // initialize serial communications module with a specific baud rate defined previously
  Serial.begin(baudrate);
  delay(1000); // delay of 1s
  Serial.print("Type a number between 0 and 9: \n"); // print number itself
  delay(300); // delay of 300ms
}

// STEP 3: LOOP FUNCTION
void loop() {
  if (Serial.available()>0){
    String read = Serial.readStringUntil('\n');
    Serial.print("You typed: ");
    Serial.println(read);
    cont = read.toInt();
    // Conditions for correct numbers between 0 and 9
    if (cont >= 0 && cont <= 9){
      segmentdisplay(cont); 
      delay(300);
    }
    else{
      Serial.print("Choose another number! ");
    }
  }
}

// STEP 4: SEGMENTDISPLAY FUNCTION
void segmentdisplay(int x){
  //write the 7 segment display code to the output port pins
  for(int i=0;i<=6;i++){
    digitalWrite(displaypin[i], displaycode[x][i]);
  }
}

// To send characters over serial from your computer to the Arduino just open the serial monitor and type something in the field next to the Send button. Press the Send button or the Enter key on your keyboard to send.