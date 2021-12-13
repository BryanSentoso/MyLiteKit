{

  Project: EE-6 - Assignment 6
  Platform: MotorControl_V2.spin, Lite Kit Assembly
  Revision: 1.0
  Author: Bryan Sentoso
  Date: 22nd November 2021
  Log:
    Date: Desc
    25/10/2021: Programming of the motor.
}


CON

  '' [ Declare Pins for Motor ]

  motor1 = 10              'Pin assignment of 10
  motor2 = 11              'Pin assignment of 11
  motor3 = 12              'Pin assingment of 12
  motor4 = 13              'Pin assignment of 13


  motor1Zero = 1520
  motor2Zero = 1520
  motor3Zero = 1520
  motor4Zero = 1520

VAR 'Global variable

  long MotorIDNum      ' ID for new cog
  long MotorStack[64]  ' Stack space for cog
  long _Ms_001


OBJ ' Objects

  Motors        : "Servo8Fast_vZ2.spin"
  Term          : "FullDuplexSerial.spin"     'UART communication for debugging

PUB Start(mainMSVal, direction, Stop2)

    _Ms_001 := mainMSVal

    Stop

    MotorIDNum := cognew(Init(direction,Stop2), @MotorStack)


  return

PUB Init(direction,Stop2)         '<-- Initialise code into a new cog

  Motors.Init  '<-- Performs Init for all the motors.

  Motors.AddSlowPin(motor1)
  Motors.AddSlowPin(motor2)
  Motors.AddSlowPin(motor3)
  Motors.AddSlowPin(motor4)
  Motors.Start
  Pause(1000)


  repeat until long[Stop2]
    case long[direction]
      1:
        Forward(100)

      2:
        Reverse(100)

      3:
        TurnRight(100)

      4:
        TurnLeft(100)

      0:
        StopAllMotors

  StopAllMotors

  repeat


PUB Stop           '<-- releases the cog

  if MotorIDNum > 0    '<-- if there is a value
    cogstop(MotorIDNum~)

  return


PUB Set            '<-- Sends each motors its own speed respectively.

  Motors.Set(motor1, 1520)
  Motors.Set(motor2, 1520)
  Motors.Set(motor3, 1520)
  Motors.Set(motor4, 1520)



PUB StopAllMotors        '<-- Stops all motors.

  Motors.Set(motor1, motor1Zero)
  Motors.Set(motor2, motor2Zero)
  Motors.Set(motor3, motor3Zero)
  Motors.Set(motor4, motor4Zero)

  'Pause(1000)


PUB Forward(i)         '<-- Instructs the robo car to move forward.


    Motors.Set(motor1,motor1Zero + i)
    Motors.Set(motor2,motor2Zero + i)
    Motors.Set(motor3,motor3Zero + i)
    Motors.Set(motor4,motor4Zero + i)


  'Pause(1000)
  'StopAllMotors


PUB Reverse(i)       '<-- Instructs the robo car to move backwards.


    Motors.Set(motor1,motor1Zero - i)
    Motors.Set(motor2,motor2Zero - i)
    Motors.Set(motor3,motor3Zero - i)
    Motors.Set(motor4,motor4Zero - i)

  'Pause(1000)
  'StopAllMotors



PUB TurnRight(i)       '<-- Instructs the robo car to turn to the right.


    Motors.Set(motor1,motor1Zero)
    Motors.Set(motor2,motor2Zero + i)
    Motors.Set(motor3,motor3Zero)
    Motors.Set(motor4,motor4Zero + i)

  'Pause(1100)
  'StopAllMotors


PUB TurnLeft(i)        '<-- Instructs the robo car to turn to the left.


    Motors.Set(motor1,motor1Zero + i)
    Motors.Set(motor2,motor2Zero)
    Motors.Set(motor3,motor3Zero + i)
    Motors.Set(motor4,motor4Zero)


  'Pause(1100)
  'StopAllMotors



PRI Pause(ms) | t
  t:= cnt - 1088           ' sync with system counter
  repeat (ms #> 0)         ' delay must be >0
   waitcnt(t += _Ms_001)
  return

DAT
name    byte  "string_data",0