{

  Project: EE-7 Assignment - MyLiteKit
  Platform: Parallax Project USB Board
  Revision: 1.1
  Author: Bryan
  Date 22nd Nov 2021
  Log:
        Date Desc
}


CON
        _clkmode = xtal1 + pll16x                                               'Standard clock mode * crystal frequency = 80 MHz
        _xinfreq = 5_000_000
        _conClkFreq = ((_clkmode - xtal1) >> 6) * _xinfreq
        _Ms_001 = _conClkFreq / 1_000


      'Config for Motor Controls
        motTypeFor    = 1
        motTypeReV    = 2
        motTypeRight  = 3
        motTypeLeft   = 4

        'Config for Comm Controls
        commForward = 1
        commReverse = 2
        commLeft    = 3
        commRight   = 4
        commStop    = 0


VAR  ' Global variables

  long mainToF1Val, mainToF2Val, mainUltra1Val, mainUltra2Val

  long motordirection

  long commdirection

  long Stop

  long motionType

  long motionSpeed

OBJ    'Object Files

  Term  : "FullDuplexSerial.spin"   'UART communication for debugging
  Sensor: "SensorControl_V2.spin"
  Motor : "MotorControl_V2.spin"
  Comm  : "CommControl.spin"

PUB Main 'Core 0


  Sensor.Start(_Ms_001, @mainToF1Val, @mainToF2Val, @mainUltra1Val, @mainUltra2Val)    'Starts up the SensorControl_v2 file
  Comm.Start(_Ms_001, @commdirection)                                                   'Starts up the CommControl file
  Motor.Start(_Ms_001, @motordirection, @Stop)                                          'Starts up the MotorControl_v2 file

  repeat
    case commdirection
      commForward:

        if ((mainToF1Val < 200) and (mainUltra1Val > 400 or mainUltra1Val == 0))            'Checks if the sensors readings surpasses the threshold that is set.
          motordirection := motTypeFor                               ' Robocar moves forward if the logic is true
        else
          motordirection := commStop                                 'else it stops


      commReverse:

        if((mainToF2Val < 200) and (mainUltra2Val > 400 or mainUltra2Val == 0))
          motordirection := motTypeRev
        else
          motordirection := commStop


      commRight:

        motordirection := motTypeRight                             'Robocar turns right)

      commLeft:

        motordirection := motTypeLeft                              'Robocar turns left

      commStop:
        motordirection := commStop




PRI Pause(ms) | t
  t := cnt - 1088               ' sync with system counter
  repeat (ms #> 0)              ' delay must be > 0
    waitcnt(t+=_MS_001)
  return