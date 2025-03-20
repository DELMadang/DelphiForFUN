object Form1: TForm1
  Left = 88
  Top = 101
  Width = 696
  Height = 480
  Caption = 
    'Runge-Kutta Solution of 2nd Order Ordinary Differential Equation' +
    's w/ Initial Conditions '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 328
    Top = 8
    Width = 337
    Height = 241
  end
  object Test1InfoMemo: TMemo
    Left = 152
    Top = 8
    Width = 409
    Height = 145
    Lines.Strings = (
      
        'A Weight with a mass m lies on a frictionless table and is conne' +
        'cted to a spring with '
      'constant k.'
      ''
      
        'If the weight is subject to a driving force F sin(omega   t) (om' +
        'ega is the frequency of '
      
        'the driving force and t is time), the equation of motion of the ' +
        'mass is as follows:'
      ''
      'M d^2x/dt^2 + kx = F sin(omega t)'
      ''
      'Given'
      ''
      'M= 2 kg'
      'F = 9 N'
      'k = 32 N/m'
      'omega = 5 cycles/sec'
      'x() = 0 m'
      'dx(0)/dt = -2.5 m/sec'
      ''
      
        'find the position and velocity of the block from t = 0 second to' +
        ' t = 2 seconds')
    TabOrder = 6
    Visible = False
  end
  object Test2InfoMemo: TMemo
    Left = 152
    Top = 152
    Width = 409
    Height = 169
    Lines.Strings = (
      
        'Two weights of mass M each hang from a pedulum of length L and a' +
        're connected '
      'by a spring with spring constant K.'
      ''
      'The equations of motion of these two masses are as follows:'
      ''
      'M d^2x/dt^2 = -M G x/L - K(x-y)'
      'M d^2y/dt^2 = -M G y/L + K(x-y)'
      ''
      
        'where G is the acceleration due to gravity, t is time, and x and' +
        ' y are the '
      
        'displacements of the two weights from their rest positions.  Giv' +
        'en'
      ''
      'M = 2 kg'
      'K = 32 N/m'
      'G = 9.8 m/sec^2'
      'L = 0.6125 m'
      'x(0) = 0.01 m'
      'y(0) =  - 0.01 m'
      'dx(0)/dt = 0 m/sec'
      'dy(0)/dt = 0 m/sec'
      ''
      
        'find the positions and velocities of the two weights from t = 0 ' +
        'to t  = 1 second.')
    TabOrder = 7
    Visible = False
  end
  object Memo1: TMemo
    Left = 16
    Top = 256
    Width = 425
    Height = 169
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Test1Btn: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Test #1'
    TabOrder = 1
    OnClick = Test1BtnClick
  end
  object PendulumBtn: TButton
    Left = 480
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Pendulum'
    TabOrder = 2
    OnClick = PendulumBtnClick
  end
  object Memo2: TMemo
    Left = 96
    Top = 8
    Width = 209
    Height = 105
    Color = clYellow
    Lines.Strings = (
      'Check solution for initial value problem for '
      'a second-order ordinary differential '
      'equation using classical  Runge-Kutta '
      'method (adapted from Borland'#39's Turbo '
      'Pascal Numerical Methods Toolbox, p175)')
    TabOrder = 3
  end
  object Memo3: TMemo
    Left = 96
    Top = 136
    Width = 209
    Height = 105
    Color = clYellow
    Lines.Strings = (
      'Check solution for initial value problem for '
      'a system of COUPLED 2nd order ordinary '
      'differential equations using classical '
      'Runge-Kutta method (adapted from '
      'Borland'#39's Turbo Pascal Numerical Methods '
      'Toolbox, p 203)')
    TabOrder = 4
  end
  object Test2Btn: TButton
    Left = 8
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Test #2'
    TabOrder = 5
    OnClick = Test2BtnClick
  end
  object PendulumInfoMemo: TMemo
    Left = 152
    Top = 272
    Width = 401
    Height = 129
    Lines.Strings = (
      
        'A simple pendulum is suspended from the ceiling with  massless s' +
        'tring of length L'
      ''
      'The equation of motion for the pendulum is as follows'
      ''
      'd^2(theta)/dt^2 = G/L sin(theta)'
      ''
      
        'where G is the acceleration due to gravity, t is time, L is the ' +
        'pendulum length, and '
      'theta is the angular '
      'displacment.  Given'
      ''
      'G = 9.81 m/sec^2'
      'L = 1 meter'
      'theta at time 0 = -22.5 degrees'
      ''
      
        'find the angular displacement as function of time from t = 0 to ' +
        't = 5. '
      ''
      '')
    TabOrder = 8
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 434
    Width = 688
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright 2002, Gary Darby   www.delphiforfun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
