#include <Stepper.h>
#include <SoftwareSerial.h>

SoftwareSerial bluetooth(2,3);
const int stepsPerRevolution = 200;
Stepper myStepper(stepsPerRevolution, 8, 9, 10, 11);

void setup() {
  myStepper.setSpeed(90);
  Serial.begin(9600);
  bluetooth.begin(9600);
}

void loop() {
   if (Serial.available() > 0) {
      int steps = Serial.readString().toInt();
      myStepper.step(steps);
      
      Serial.print("Stepped: ");
      Serial.println(steps); 
    }
    if (bluetooth.available()) {
      int steps = bluetooth.read();
      if (steps > 100) steps = -(steps - 100);
      steps = -steps;
      myStepper.step(steps);
      Serial.print("Bluetooth: ");
      Serial.println(steps); 
    }
}
