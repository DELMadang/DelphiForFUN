object Form1: TForm1
  Left = 135
  Top = 143
  Width = 771
  Height = 480
  Caption = 'File Fixup'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poPrintToFit
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 512
    Top = 144
    Width = 169
    Height = 49
    AutoSize = False
    Caption = 
      'Insert CR before LF if missing           Insert LF after CR if m' +
      'issing          Reverse LF/CR to CR/LF'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 472
    Top = 280
    Width = 273
    Height = 105
    AutoSize = False
    Caption = 'label2'
    WordWrap = True
  end
  object FixBtn: TButton
    Left = 472
    Top = 242
    Width = 113
    Height = 25
    Caption = 'Go!'
    TabOrder = 0
    OnClick = FixBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 425
    Height = 409
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Linux and  even some Windows programs can generate line '
      'ending character sequences which confuse Windows/DOS programs  '
      '(that expect a single CR/LF sequence to mark the end of a line).'
      ''
      ''
      'This program has two phase that correct common errors:'
      ''
      'Phase 1 scans a file looking for lines that end with a CR/CR/LF '
      
        'sequence and optionally can fix the problem by eliminating one o' +
        'f the '
      
        'CRs or by  deleting the entire CR/CR/LF sequence.  Some programs' +
        ' '
      
        'mark "Soft" (wordwrap) line breaks by inserting CR/CR/LF into th' +
        'e file.'
      ''
      
        'Note: (CR=Carriage return = 13 = hex 0D,   LF=LineFeed=10=hex 0A' +
        ').'
      ''
      
        'Phase 2 optionally corrects invalid line end sequences for three' +
        '  types '
      
        'of errors: It may insert a character for any CR not followed by ' +
        'a LF ot '
      
        'any LF characters not preceded by a CR to form a valid CR/LF pai' +
        'r.  It '
      
        'also converts LF/CR pairs to CR/LF pairs.   Some editors corrupt' +
        ' PAS '
      
        'files, causing problems with breakpoints  or in extreme cases,pr' +
        'event '
      
        'Delphi from loading source. (The whole file is one  line) The pr' +
        'oblem is '
      'visually evident in Notepad, but not in the IDE. '
      '')
    ParentFont = False
    TabOrder = 1
  end
  object cbChangeName: TCheckBox
    Left = 472
    Top = 208
    Width = 169
    Height = 17
    Caption = 'Change File name automatically'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object BrowseInBtn: TButton
    Left = 472
    Top = 400
    Width = 113
    Height = 25
    Caption = 'Browse input file'
    Enabled = False
    TabOrder = 3
    OnClick = BrowseInBtnClick
  end
  object BrowseOutBtn: TButton
    Left = 632
    Top = 400
    Width = 113
    Height = 25
    Caption = 'Browse output file'
    Enabled = False
    TabOrder = 4
    OnClick = BrowseOutBtnClick
  end
  object CRCRLFGrp: TRadioGroup
    Left = 472
    Top = 16
    Width = 193
    Height = 81
    Caption = 'Soft Line Breaks (CR/CR/LF)'
    ItemIndex = 0
    Items.Strings = (
      'Ignore CR/CR/ LF'
      'Replace CR/CR/ LF with CR/LF'
      'Delete CR/CR/LF')
    TabOrder = 5
  end
  object Adjustbreaks: TCheckBox
    Left = 472
    Top = 120
    Width = 161
    Height = 17
    Caption = 'Adjust Line Breaks'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Title = 'Select file to fix up'
    Left = 368
    Top = 65530
  end
  object SaveDialog1: TSaveDialog
    Title = 'Enter name of output file'
    Left = 344
    Top = 65522
  end
end
