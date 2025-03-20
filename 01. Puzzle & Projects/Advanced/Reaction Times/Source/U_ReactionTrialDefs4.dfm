object Form2: TForm2
  Left = 418
  Top = 341
  Width = 1181
  Height = 757
  Caption = 'Edit trial definitions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 20
    Top = 20
    Width = 234
    Height = 64
    Caption = 
      'Defined Trial Types                          Press Insert key to' +
      ' make a new case. Press Delete key to delete selected entry'
    PopupMenu = PopupMenu1
    WordWrap = True
  end
  object Label10: TLabel
    Left = 27
    Top = 386
    Width = 88
    Height = 16
    Caption = 'Early Click ms'
  end
  object Label11: TLabel
    Left = 216
    Top = 387
    Width = 100
    Height = 16
    Caption = 'Missing click ms'
  end
  object Label12: TLabel
    Left = 24
    Top = 328
    Width = 441
    Height = 57
    AutoSize = False
    Caption = 
      'Response times outside of limits below will not  count in summar' +
      'y statistics as samples but the number of occurrences per trial ' +
      'will be recorded in statistics '
    WordWrap = True
  end
  object Label13: TLabel
    Left = 24
    Top = 604
    Width = 155
    Height = 16
    Caption = 'Default logon user name'
  end
  object TrialsBox: TListBox
    Left = 316
    Top = 18
    Width = 149
    Height = 179
    ItemHeight = 16
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnClick = TrialsBoxClick
    OnKeyDown = TrialsBoxKeyDown
  end
  object GroupBox1: TGroupBox
    Left = 494
    Top = 20
    Width = 651
    Height = 661
    TabOrder = 1
    object Label2: TLabel
      Left = 46
      Top = 161
      Width = 106
      Height = 16
      Caption = 'Samples per trial'
    end
    object Label7: TLabel
      Left = 20
      Top = 98
      Width = 71
      Height = 16
      Caption = 'Description'
    end
    object Label8: TLabel
      Left = 35
      Top = 202
      Width = 117
      Height = 16
      Caption = 'Min delay seconds'
    end
    object Label9: TLabel
      Left = 32
      Top = 235
      Width = 120
      Height = 16
      Caption = 'Max delay seconds'
    end
    object CaseIdLbl: TLabel
      Left = 30
      Top = 30
      Width = 73
      Height = 20
      Caption = 'Case Id: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 40
      Top = 400
      Width = 561
      Height = 241
      Caption = 'Panel1'
      TabOrder = 10
      Visible = False
      object FileCheckListBox: TCheckListBox
        Left = 232
        Top = 16
        Width = 313
        Height = 193
        OnClickCheck = FileCheckListBoxClickCheck
        ItemHeight = 16
        TabOrder = 0
      end
      object Memo1: TMemo
        Left = 16
        Top = 16
        Width = 201
        Height = 193
        Lines.Strings = (
          'Choose images to display by '
          'clicking the check boxes in '
          'reverse of the desired display '
          'order. Each box checked will '
          'move to the top of the list. '
          'Checkedimages will be '
          'displayed in the order in '
          'which they appear in the list.')
        TabOrder = 1
      end
    end
    object Nbrsampsedt: TEdit
      Left = 164
      Top = 161
      Width = 40
      Height = 24
      TabOrder = 0
      Text = '0'
      OnChange = Casechanged
    end
    object NbrSampsUD: TUpDown
      Left = 204
      Top = 161
      Width = 15
      Height = 24
      Associate = Nbrsampsedt
      TabOrder = 1
    end
    object DescEdt: TEdit
      Left = 118
      Top = 98
      Width = 336
      Height = 24
      TabOrder = 2
      OnChange = Casechanged
    end
    object Edit1: TEdit
      Left = 164
      Top = 202
      Width = 40
      Height = 24
      TabOrder = 3
      Text = '0'
      OnChange = Casechanged
    end
    object MinDelayUD: TUpDown
      Left = 204
      Top = 202
      Width = 20
      Height = 24
      Associate = Edit1
      TabOrder = 4
    end
    object Edit2: TEdit
      Left = 164
      Top = 235
      Width = 40
      Height = 24
      TabOrder = 5
      Text = '0'
      OnChange = Casechanged
    end
    object MaxDelayUD: TUpDown
      Left = 204
      Top = 235
      Width = 20
      Height = 24
      Associate = Edit2
      TabOrder = 6
    end
    object ActiveBox: TCheckBox
      Left = 30
      Top = 59
      Width = 355
      Height = 21
      Caption = 'Check this box to make case available to users'
      TabOrder = 7
      OnClick = Casechanged
    end
    object PageControl1: TPageControl
      Left = 325
      Top = 148
      Width = 297
      Height = 493
      ActivePage = SoundSheet
      TabOrder = 8
      OnChange = Casechanged
      object VisualSheet: TTabSheet
        Caption = 'Visual Stimulus'
        object PosCBox: TCheckBox
          Left = 20
          Top = 20
          Width = 178
          Height = 21
          Caption = 'Target in fixed position'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = Casechanged
        end
        object ShapeGrp: TRadioGroup
          Left = 20
          Top = 59
          Width = 247
          Height = 126
          Caption = 'Target shape'
          ItemIndex = 2
          Items.Strings = (
            'Rectangle'
            'Round Cornered Rectangle'
            'Elllipse'
            'Use JPG image list')
          TabOrder = 1
          OnClick = ShapeGrpClick
        end
        object GroupBox2: TGroupBox
          Left = 20
          Top = 225
          Width = 247
          Height = 169
          Caption = 'Target Size (Percent of screen)'
          TabOrder = 2
          OnClick = Casechanged
          object Label4: TLabel
            Left = 30
            Top = 34
            Width = 30
            Height = 16
            Caption = 'XMin'
          end
          object Label3: TLabel
            Left = 30
            Top = 69
            Width = 33
            Height = 16
            Caption = 'XMax'
          end
          object Label5: TLabel
            Left = 30
            Top = 98
            Width = 31
            Height = 16
            Caption = 'YMin'
          end
          object Label6: TLabel
            Left = 30
            Top = 128
            Width = 34
            Height = 16
            Caption = 'YMax'
          end
          object XMinEdt: TEdit
            Left = 108
            Top = 34
            Width = 41
            Height = 24
            TabOrder = 0
            Text = '1'
          end
          object XMinUD: TUpDown
            Left = 149
            Top = 34
            Width = 18
            Height = 24
            Associate = XMinEdt
            Min = 1
            Position = 1
            TabOrder = 1
          end
          object XMaxEdt: TEdit
            Left = 108
            Top = 64
            Width = 41
            Height = 24
            TabOrder = 2
            Text = '1'
          end
          object XMaxUD: TUpDown
            Left = 149
            Top = 64
            Width = 18
            Height = 24
            Associate = XMaxEdt
            Min = 1
            Position = 1
            TabOrder = 3
          end
          object YMinEdt: TEdit
            Left = 108
            Top = 94
            Width = 41
            Height = 24
            TabOrder = 4
            Text = '1'
          end
          object YMinUD: TUpDown
            Left = 149
            Top = 94
            Width = 18
            Height = 24
            Associate = YMinEdt
            Min = 1
            Position = 1
            TabOrder = 5
          end
          object YMaxEdt: TEdit
            Left = 108
            Top = 123
            Width = 41
            Height = 24
            TabOrder = 6
            Text = '1'
          end
          object YMaxUD: TUpDown
            Left = 149
            Top = 123
            Width = 18
            Height = 24
            Associate = YMaxEdt
            Min = 1
            Position = 1
            TabOrder = 7
          end
        end
        object TColorPnl: TPanel
          Left = 160
          Top = 412
          Width = 107
          Height = 31
          Caption = 'Target Color'
          TabOrder = 3
          OnClick = TColorPnlClick
        end
        object BColorPnl: TPanel
          Left = 20
          Top = 412
          Width = 129
          Height = 31
          Caption = 'Background Color'
          TabOrder = 4
          OnClick = BColorPnlClick
        end
      end
      object SoundSheet: TTabSheet
        Caption = 'Audio Stimulus'
        ImageIndex = 1
        object SoundGrp: TRadioGroup
          Left = 61
          Top = 15
          Width = 159
          Height = 274
          Caption = 'Select sound file'
          ItemIndex = 0
          Items.Strings = (
            'Click'
            'Ding'
            'Laser'
            'Pinball'
            'RingIn'
            'Tone500x2'
            'User1')
          TabOrder = 0
          OnClick = Casechanged
        end
      end
    end
    object UseStimulusGrp: TRadioGroup
      Left = 32
      Top = 280
      Width = 225
      Height = 105
      Caption = 'Stimulus type to use'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Use Visual stimulus'
        'Use Audible stimulus'
        'Use both')
      ParentFont = False
      TabOrder = 9
      OnClick = Casechanged
    end
  end
  object OKBtn: TBitBtn
    Left = 23
    Top = 651
    Width = 92
    Height = 30
    TabOrder = 2
    OnClick = OKBtnClick
    Kind = bkOK
  end
  object DetailBox: TCheckBox
    Left = 20
    Top = 203
    Width = 237
    Height = 21
    Caption = 'Create/append to detail data file'
    TabOrder = 3
  end
  object SumryBox: TCheckBox
    Left = 20
    Top = 272
    Width = 247
    Height = 21
    Caption = 'Create/append to summary data file'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object DetailNameEdt: TEdit
    Left = 23
    Top = 233
    Width = 442
    Height = 24
    TabOrder = 5
    Text = 'Reaction Times.rsd'
    OnClick = DetailNameEdtClick
  end
  object SumryNameEdt: TEdit
    Left = 23
    Top = 294
    Width = 442
    Height = 24
    TabOrder = 6
    Text = 'ReactionTimes.rsp'
    OnClick = SumryNameEdtClick
  end
  object Delimiter: TRadioGroup
    Left = 20
    Top = 104
    Width = 253
    Height = 81
    Caption = 'Field delimiter for data files'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      ',  (comma)'
      '   (space)'
      ';   (semicolon'
      '* (asterisk)')
    TabOrder = 7
  end
  object EarlyGrp: TRadioGroup
    Left = 24
    Top = 424
    Width = 409
    Height = 41
    Caption = 'Early click actions'
    Columns = 2
    ItemIndex = 1
    Items.Strings = (
      'Ignore'
      ' "No cheating" message ')
    TabOrder = 8
  end
  object Edit3: TEdit
    Left = 128
    Top = 386
    Width = 44
    Height = 24
    TabOrder = 9
    Text = '0'
  end
  object EarlyUD: TUpDown
    Left = 172
    Top = 386
    Width = 20
    Height = 24
    Associate = Edit3
    Min = -5000
    TabOrder = 10
    OnChangingEx = EarlyUDChangingEx
  end
  object LateUD: TUpDown
    Left = 388
    Top = 387
    Width = 20
    Height = 24
    Associate = Edit4
    Min = 1000
    Max = 10000
    Position = 1000
    TabOrder = 11
    OnChangingEx = LateUDChangingEx
  end
  object Edit4: TEdit
    Left = 328
    Top = 387
    Width = 60
    Height = 24
    TabOrder = 12
    Text = '1,000'
  end
  object DefaultName: TEdit
    Left = 192
    Top = 600
    Width = 121
    Height = 24
    TabOrder = 13
    Text = 'Guest'
  end
  object WriteAllDetail: TCheckBox
    Left = 24
    Top = 480
    Width = 433
    Height = 113
    Caption = 
      'Write detail records even for out of range samples . Out of rang' +
      'e times will be "Early click"  or "Missing click"  times.  If ch' +
      'ecked, total stimuli displayed will = "Samples per trial".  If u' +
      'nchecked, vaild responses will = Samples per trial.  This option' +
      ' is to allow JPEG image tests to associate response times with s' +
      'pecific images.  It should remain unchecked otherwise.'
    TabOrder = 14
    WordWrap = True
  end
  object ColorDialog1: TColorDialog
    Left = 536
  end
  object PopupMenu1: TPopupMenu
    Left = 184
    object Insert1: TMenuItem
      Caption = 'Insert'
      OnClick = Insert1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
    object Activate1: TMenuItem
      Caption = 'Activate'
      OnClick = Activate1Click
    end
    object Modify1: TMenuItem
      Caption = 'Modify'
      OnClick = Modify1Click
    end
  end
  object DetailDialog: TSaveDialog
    DefaultExt = 'rsd'
    Filter = 'Response detail (*.rsd)|*.rsd'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofCreatePrompt, ofEnableSizing]
    Title = 'Enter or select a  file for response time detail'
    Left = 504
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'jpg'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 704
    Top = 192
  end
  object SumryDialog: TSaveDialog
    DefaultExt = 'rsp'
    Filter = 'Response summary by trial (*.rsp)|*.rsp'
    Title = 'Enter or select a tiral  summary  file'
    Left = 600
    Top = 16
  end
  object OpenDialog2: TOpenDialog
    Left = 992
    Top = 16
  end
end
