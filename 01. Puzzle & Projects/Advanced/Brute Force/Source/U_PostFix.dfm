object PostFixForm: TPostFixForm
  Left = 446
  Top = 108
  AutoScroll = False
  AutoSize = True
  Caption = 'PostFix form of equations'
  ClientHeight = 457
  ClientWidth = 717
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 144
  TextHeight = 20
  object PostFixMemo: TMemo
    Left = 0
    Top = 226
    Width = 717
    Height = 231
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Memo1: TMemo
    Left = 2
    Top = 0
    Width = 715
    Height = 174
    Lines.Strings = (
      
        'Postfix notation is a simple method of evaluating aritmetic expr' +
        'essions using a "stack" data '
      
        'structure.  In a stack, insertions and removals are always from ' +
        'the top.'
      ''
      
        'In operation each token of the equation is examined, if it is a ' +
        'variable, the current value of the '
      
        'variable is pushed onto the stack.  If it is a constant, the val' +
        'ue is pushed onto the stack.  If it is an '
      
        'operator, then top two entires of the stack are popped off, the ' +
        'operation performed and the result '
      'pushed back onto the stack.')
    TabOrder = 1
  end
end
