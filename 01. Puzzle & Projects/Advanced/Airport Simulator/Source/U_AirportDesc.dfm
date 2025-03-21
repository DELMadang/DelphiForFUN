object Form2: TForm2
  Left = 220
  Top = 104
  Width = 696
  Height = 480
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 688
    Height = 456
    Align = alClient
    Lines.Strings = (
      'Airport Simulation'
      ''
      
        '(From Fundamentals of Data Structures in Pascal,  Horowitz and S' +
        'ahni, Computer Science Press, 1987)'
      ''
      
        'This problem is to simulate an airport landing and takeoff patte' +
        'rn.  The airport has 3 runways, runway1, runway 2, and runway 3.' +
        '  There are 4 '
      
        'landing holding patterns, two for each of the first two runways.' +
        '  Arriving planes will enter one of the holding pattern queues, ' +
        'where the queues are '
      'to be as close to the same size as possible.'
      ''
      
        'When a plane enters a holding queue, it is given an integer id a' +
        'nd an integer representing the number of time units that the pla' +
        'ne can remain in '
      
        'the queue before it must land (because of low fuel level). There' +
        ' is also a queue of takeoffs for each of the three runways.  Pla' +
        'nes arriving at an '
      'output queue are also assigned an integer id.'
      ''
      
        'At each time, 0-3 planes may arrive at the landing queue and 0-3' +
        ' planes may arrive at the takeoff queues.  Each arriving plane h' +
        'as from 0 to 20 '
      
        'time untis of fuel remaining.   Each runway can handle one takeo' +
        'ff or landing at each time slot.  Runway 3 is to be used for tak' +
        'eoffs, except '
      
        'when a plane is low on fuel.  At each time unit, planes in any l' +
        'anding queue whose remaining air time (fuel level) has reached 0' +
        ' must be  given '
      
        'priority over other takeoffs and landings.  If one one plane is ' +
        'in this category, Runway 3 is to be used.  If more than one, the' +
        'n the other runways '
      
        'are also used (at each time at most 3 planes can be handled in t' +
        'his way).  '
      ''
      
        'Use successive even (odd) numbers for id'#39's of planes arriving at' +
        ' takeoff (landing) queues.  At each time unit assume that arrivi' +
        'ng planes are '
      
        'entered into queues before takeoff or landing occur.  Try to des' +
        'ign your algorithm so that neither takeoff or landing queues gro' +
        'w excessively.  '
      'However arriving planes must be placed at the end of queues. '
      ''
      
        'The output should clearly indicate what occurs at each time unit' +
        '.  Periodically output (a) then contents of each queue, (b) the ' +
        'average takeoff '
      
        'waiting time, (c) the average landing waiting time, (d) the aver' +
        'age flying time remaining on landing, and (e) the number of plan' +
        'es landing with no '
      
        'fuel reserve.  (b) and (c) are for planes that have taken off an' +
        'd landed respectively.  Use a random number generator to generat' +
        'e the inputs.'
      ' ')
    TabOrder = 0
  end
end
