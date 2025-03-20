object ShowIFForm: TShowIFForm
  Left = 654
  Top = 178
  Width = 727
  Height = 686
  Caption = 'Logic Problem solver - "If" rules'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object IFRulesMemo: TMemo
    Left = 16
    Top = 144
    Width = 537
    Height = 241
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object InfoMemo: TMemo
    Left = 16
    Top = 8
    Width = 537
    Height = 121
    Color = 14548991
    Lines.Strings = (
      
        'Order rules, specifying  which variable values occur before or a' +
        'fter others generate facts and IF rules.'
      ''
      
        'Choice rules specify valid variables values for a given variable' +
        ' value and they generate facts for which value s '
      
        'are not assuciated.  (e.g. if value X of Var1 is associated with' +
        ' values A or B of Var2 then X is not associated with '
      'values D, E, or F of Var2. '
      ' '
      ''
      ' Here are the generated facts and rules for the currrent problem')
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 631
    Width = 719
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, 2012 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
end
