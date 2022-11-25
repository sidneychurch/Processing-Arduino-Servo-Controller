#include <Servo.h>

#define INPUT_SIZE 30 // Calculate based on max input size expected for one command

Servo lThigh; //servo1
Servo lFoot;  //servo2
Servo rThigh; //servo3
Servo rFoot;  //servo4

int oldValLF = 90;
int oldValLT = 90;
int oldValRT = 90; 
int oldValRF = 90; 



void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);

rFoot.attach(4);//6
rThigh.attach(3);//5
lFoot.attach(5);//9
lThigh.attach(2);//3
rFoot.write(90);
rThigh.write(90);
lFoot.write(90);
lThigh.write(90);
delay(1000);
}

void loop() {
 
   // If data is available to read,
    getServoPos();
  

}


void getServoPos() {

 
// Get next command from Serial (add 1 for final 0)
//char is used to create strings, which are arrays of letters plus a null character ('/0) to dictate the end of the string
//so here we declare a string called input with the array size of our input size plus one to account for the null character.
char input[INPUT_SIZE + 1]; 
//Serial.readBytes stores whatever comes into the serial monitor, which can be char[] or byte[].The second value is how many characters you want to read in.
//We create a byte variable that will return the size of our serial input while setting the values of our serial input to our char array.
 
byte addNull = Serial.readBytes(input, INPUT_SIZE); 

// Add the final 0 to end the C string
//Since an array starts counting at 0, we set the addNull value = 0 since it will be the last value in the array and be our null character.
input[addNull] = 0;
// Read each command pair 
//strtok(): splits a C string into substrings, based on a separator character. So we look at the characters in the input array and where ever a & appears, it'll get split
char* command = strtok(input, "&");

while (command != 0)
{
 //Each command is serperated by the '&' character. It will go through each one, one at a time.
    // Split the command in two values
    //char* creates a pointer to a string and makes writing to that memory illegal. this is good when we just want to look at at string versus write to the array elements
    //strchr(): search for a character in a C string (i.e. char *). So we are looking a the string command and searching for : within the string
    char* separator = strchr(command, ':'); //This will be used to look for the ':' character and whatever is after it will be our degrees
    
    if (separator != 0) //as long as something is inside of our separator
    {
        // Actually split the string in 2: replace ':' with 0. We do this because if we want a servo to move the posistion 25 it comes in like :25. So we change it to 025.
        *separator = 0;
        int servoId = atoi(command); //atoi(): converts a C string to an int
        ++separator;
        int pos = atoi(separator);

        // Do something with servoId and position
        //The format to send commands will be servoId1:pos1&servoId2:pos2&etc...for how ever many servos are attached.
        Serial.print("Move Servo Number: "); Serial.print(servoId); Serial.print("  to position: "); Serial.println(pos);

        moveServo(servoId, pos);
    }
    // Find the next command in input string
    command = strtok(0, "&");
 }
}

void moveServo(int servoNum, int servoPos) {
  
switch (servoNum) {
  case 1: //lThigh
        
//       if (oldValLT < servoPos){
//       for(int i=oldValLT;i<=servoPos;i++)
//          {lThigh.write(i);delay(12);}
//      }
//       if (oldValLT > servoPos){
//       for(int i=oldValLT;i>=servoPos;i--)
//          {lThigh.write(i);delay(12);}
//      }
//      
//      oldValLT = servoPos;
lThigh.write(servoPos);delay(12);
   
    break;
  case 2: //lFoot
       
//       if (oldValLF < servoPos){
//       for(int i=oldValLF;i<=servoPos;i++)
//          {lFoot.write(i);delay(12);}
//      }
//       if (oldValLF > servoPos){
//       for(int i=oldValLF;i>=servoPos;i--)
//          {lFoot.write(i);delay(12);}
//      }
//      
//      oldValLF = servoPos;
lFoot.write(servoPos);delay(12);
   
    break;
    
   case 3: //rThigh
   
//       if (oldValRT < servoPos){
//       for(int i=oldValRT;i<=servoPos;i++)
//          {rThigh.write(i);delay(12);}
//      }
//       if (oldValRT > servoPos){
//       for(int i=oldValRT;i>=servoPos;i--)
//          {rThigh.write(i);delay(12);}
//      }
//      
//      oldValRT = servoPos;
      rThigh.write(servoPos);delay(12);
      break;
    
   case 4: //rFoot
   
//      if (oldValRF < servoPos){
//       for(int i=oldValRF;i<=servoPos;i++)
//          {rFoot.write(i);delay(12);}
//      }
//       if (oldValRF > servoPos){
//       for(int i=oldValRF;i>=servoPos;i--)
//          {rFoot.write(i);delay(12);}
//      }
//      
//      oldValRF = servoPos;
    rFoot.write(servoPos);delay(12);
    break;

     case 5: //reset all servos to 90
   
      Serial.println("Resetting all servos to 90");
       
      rFoot.write(90);
      rThigh.write(90);
      lFoot.write(90);
      lThigh.write(90);
      delay(3000); 
      
      
      oldValLF = 90;
      oldValLT = 90;
      oldValRT = 90; 
      oldValRF = 90; 

    
    break;
  }
  
}

