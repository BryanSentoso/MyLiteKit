{
  Platform: Parallax Project USB Board
  Revision: 1.0
  Author: Bryan Sentoso
  Date: 22nd Nov 2021
  Log:
        Date: Desc
        17/11/2021: Creating object file for Comm Control
}


CON


        commRxPin   = 20
        commTxPin   = 21
        commBaud    = 9600


        commStart   = $7A
        commForward = $01
        commReverse = $02
        commLeft    = $03
        commRight   = $04
        commStopAll = $AA

VAR     'Global variable

  long CommCogID, CommStack[64]       'ID for new cog and stack space
  long _Ms_001


OBJ     'Object Files
  Comm      : "FullDuplexSerial.spin"  'UART communication for Control
  ' Create a hardware definition file

PUB Start(mainMSVal,direction)


  _Ms_001 := mainMSVal

  Stop

  CommCogID := cognew(Read(direction), @CommStack)


PUB Stop

  if CommCogID > 0    '<-- if there is a value
    cogstop(CommCogID~)

  return

PUB Read(direction) | rxValue

  'Declaration & Initialization
   Comm.Start(commRxPin, commTxPin, 0, commBaud)
  Pause(1000) 'Wait 2 seconds

  'Run & get readings
  repeat
    rxValue := Comm.Rx
    if (RxValue == commStart)
        Rxvalue := Comm.Rx


          case rxValue
            commForward:
             long[direction] := 1 'Motors move forward


            commReverse:
             long[direction] := 2'Motors move backward


            commLeft:
             long[direction] := 3'Turn right

            commRight:
             long[direction] := 4'Turn left

            commStopAll:
             long[direction] := 0'Stop All motors
    Comm.Dec(long[direction])
    Pause(25)




PRI Pause(ms) | t
  t:= cnt - 1088                'sync with system counter
  repeat (ms #> 0)              'delay must be > 0
   waitcnt(t += _Ms_001)
  return