object Fullscreen: TFullscreen
  Left = 269
  Top = 116
  Align = alClient
  AutoScroll = False
  BorderIcons = []
  ClientHeight = 453
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object memo1: TMemo
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    Align = alClient
    Lines.Strings = (
      'memo2')
    TabOrder = 0
    Visible = False
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    HorzScrollBar.Visible = False
    VertScrollBar.ButtonSize = 4
    VertScrollBar.Increment = 1
    VertScrollBar.Size = 4
    VertScrollBar.ThumbSize = 1
    Align = alClient
    AutoScroll = False
    TabOrder = 1
    OnMouseUp = ScrollBox1MouseUp
    OnMouseWheelDown = ScrollBox1MouseWheelDown
    OnMouseWheelUp = ScrollBox1MouseWheelUp
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 684
      Height = 449
      Align = alClient
      OnMouseUp = ScrollBox1MouseUp
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 560
    Top = 24
  end
end
