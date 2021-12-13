{

  Project: EE-7 Assignment - SensorControl
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Bryan Sentoso
  Date 22nd Nov 2021
  Log:
        Date Desc
        15/11/2021:
}

CON

    '' [Declare Pins for Ultra Sensors]
    'ultra sonic 1 (Front) - I2C Bus 1
    ultra1SCL =  6         '(Trig : Pin6)
    ultra1SDA =  7         '(Echo : Pin7)

    'ultra sonic 2 (Back) - I2C Bus 2
    ultra2SCL = 8          '(Trig : Pin8)
    ultra2SDA = 9          '(Echo : Pin9)

    '' [Declare Pins for ToF Sensors]
    'ToF1 Sensors  (Front)      '(GPIO0, Pin14)
    tof1SCL = 0                 '(SCL : Pin 0)
    tof1SDA = 1                 '(SDA : Pin 1)
    tof1RST = 14


    'ToF2 Sensors  (Back)        '(GPIO0 : Pin15)
    tof2SCL = 2                  '(SCL : Pin 2)
    tof2SDA = 3                  '(SDA : Pin 3)
    tof2RST = 15


    tofADD = $29'

VAR 'Global variable

  long cogIDNum, cogStack[128]     'ID for new cog and stack space
  long _Ms_001


OBJ    ' Objects

  'Term  : "FullDuplexSerial.spin"   'UART communication for debugging
  Ultra : "EE-7_Ultra_v2.spin"
  ToF[2] : "EE-7_ToF.spin"

  'Create a hardware definition file




PUB Start(mainMSVal, mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add)

  _Ms_001 := mainMSVal

  Stop

  cogIDNum := cognew(sensorCore(mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add), @cogStack)

  return

PUB Stop

  if cogIDNum > 0    '<-- if there is a value
    cogstop(cogIDNum~)

  return

PUB sensorCore(mainToF1Add, mainToF2Add, mainUltra1Add, mainUltra2Add)

  ' Declaration & Initialization
  Ultra.Init(Ultra1SCL, ultra1SDA, 0)
  Ultra.Init(Ultra2SCL, ultra2SDA, 1)

  tofInit   'Perform init for both ToF sensors

  ' Run & get readings
  repeat
    long[mainUltra1Add] := Ultra.readSensor(0)
    long[mainUltra2Add] := Ultra.readSensor(1)
    long[mainToF1Add]   := ToF[0].GetSingleRange(tofAdd)
    long[mainToF2Add]   := ToF[1].GetSingleRange(tofAdd)
    Pause(50)


PUB tofInit   | i

  'Declaration & Initialization (ToF1)
  ToF[0].Init(tof1SCL, tof1SDA, tof1RST)
  ToF[0].ChipReset(1)   ' Last state is ON position
  Pause(1000)
  ToF[0].FreshReset(tofAdd)
  ToF[0].MandatoryLoad(tofAdd)
  ToF[0].RecommendedLoad(tofAdd)
  ToF[0].FreshReset(tofAdd)

  'Declaration & Initialization (ToF2)
  ToF[1].Init(tof2SCL, tof2SDA, tof2RST)
  ToF[1].ChipReset(1)   ' Last state is ON position
  Pause(1000)
  ToF[1].FreshReset(tofAdd)
  ToF[1].MandatoryLoad(tofAdd)
  ToF[1].RecommendedLoad(tofAdd)
  ToF[1].FreshReset(tofAdd)

  return


PRI Pause(ms) | t
  t := cnt - 1088               ' sync with system counter
  repeat (ms #> 0)              ' delay must be > 0
    waitcnt(t+=_MS_001)
  return