object Form1: TForm1
  Left = 370
  Top = 152
  Width = 1166
  Height = 784
  Caption = 'StringGrids and BitMaps'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 716
    Width = 1148
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1148
    Height = 716
    Align = alClient
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 1146
      Height = 714
      ActivePage = IntroSheet
      Align = alClient
      TabOrder = 0
      OnChange = PageControl1Change
      object IntroSheet: TTabSheet
        Caption = 'Introsheet'
        object Memo4: TMemo
          Left = 48
          Top = 32
          Width = 985
          Height = 625
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'This program was motivated by an email exchange with a hobbyist ' +
              'programmer involving two programs that'
            
              'were giving him trouble.   I'#39'm not sure of George'#39's age, but in ' +
              'one of his replies he said "You have made a '
            
              'Great Granddad very happy", so he must be of the up there with m' +
              'e as part of the "old fogey" generation.  '
            ''
            
              'The first problem has two parts.  For one, he wanted the cells o' +
              'f a StringGrid to change as the mouse cursor'
            
              'passed over them.   Initially the objective was to highlight the' +
              ' cell by coloring the background. This is '
            
              'implemented as "StringGrid Demo 1".  The secondary objective was' +
              ' to change the text in the cell when the '
            
              'mouse cursor was present and restore the original text when the ' +
              'mouse leaves.  This is "StringGrid Demo 2".'
            ''
            
              'The second problem, was actually Geroge'#39's first request, how to ' +
              'successfully transfer an image, or portion of '
            
              'an image canvas, to a bitmap for further processing.  The proble' +
              'm was that he did not realize that the Width '
            
              'and Height of a bitmap must be specified before attempting to tr' +
              'ansfer to it.  I decided to illustrate this, and '
            
              'have a little fun, by transferring cell-sized pieces of a Bitmap' +
              ' image to the stringgrid as the mouse moves over '
            
              'cells.   This is "StringGrid Demo 3" with two options:  the "Sim' +
              'ple" one just "paints" the bitmap to the '
            
              'StringGrid cell by cell as the cursor moves over it.  The "Trick' +
              'y" option  places images on empty cells as the '
            
              'mouse passes over them, but  erases any cell touched by the curs' +
              'or if the image piece is already displayed.   '
            
              'Zigzagging across columns and down the rows makes this almost to' +
              'o easy, so the program randomly paints a '
            'few cells initially just to make it a little more interesting.'
            ''
            
              'All the demos use the same two Event exits: "OnMouseMove" gets c' +
              'alled when the mouse cursor is on the '
            
              'StringGrid and moves.  The exit receives the screen coordinates ' +
              'of the cursor but StringGrid objects include a '
            
              '"MouseToCell" method that  converts (X, Y) screen coordinates to' +
              ' Column and Row values. The specific action '
            
              'taken varies with the demo, but the key is that any change made ' +
              'to a cell will trigger a call to the "OnDrawCell" '
            
              'event exit where the appropriate action can be taken to change w' +
              'hat the user sees.'
            ''
            '')
          ParentFont = False
          TabOrder = 0
        end
      end
      object DemoSheet1: TTabSheet
        Caption = 'StringGrid Demo 1'
        ImageIndex = 1
        object Memo1: TMemo
          Left = 50
          Top = 24
          Width = 615
          Height = 561
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'Simplest possible version.  Redraws the entire stringgrid on eve' +
              'ry '
            'mouse move.'
            ''
            'OnMouseMove exit simply converts screen coordinate to cell '
            
              'coordinates and saves them in global variables that OnDrawCell c' +
              'an '
            
              'check.  Since no cell data is  changed, MouseMove calls the  gri' +
              'd'#39's '
            '"Invalidate" method to force all cells to be redrawn.  The '
            
              'DrawCell exit is called once for each cell to be redrawn.  This ' +
              'exit  '
            
              'checks the saved cell coordinates against those of the cell to b' +
              'e '
            'redrawn and when they match, the exit  colors the background as '
            
              'desired.   All other cells get the default (white) background co' +
              'lor. '
            ''
            
              'All three StringGrids in this program have their "DefaultDrawing' +
              '" '
            'property  set to False when  they were defined..  This lets the '
            'DrawCell exits completely control Cell appearance.  All other '
            'properties are at their initial default values.'
            ''
            
              'A better solution would be to have the Mouse move routine save x' +
              ',y '
            
              'at end of  each entry (as previous location) and compare new x,y' +
              ' '
            
              'with previous x,y and "Update"  rather than "Invalidate" the str' +
              'inggrid '
            'to redraw only the changed cells. String Demo 2 implements this '
            'idea.')
          ParentFont = False
          TabOrder = 0
        end
        object StringGrid1: TStringGrid
          Left = 720
          Top = 120
          Width = 385
          Height = 145
          DefaultDrawing = False
          TabOrder = 1
          OnDrawCell = StringGrid1DrawCell
          OnMouseMove = StringGrid1MouseMove
          RowHeights = (
            24
            24
            24
            24
            24)
        end
      end
      object Demosheet2: TTabSheet
        Caption = 'StringGrid Demo 2'
        ImageIndex = 2
        object Memo2: TMemo
          Left = 50
          Top = 24
          Width = 639
          Height = 641
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            'Version 2:   Redraw only the cells that have changed.'
            ''
            
              'This version also modifies the text (to '#39'!!!!'#39') in the cell curr' +
              'ently under the '
            
              'mouse and restores it to the initial value when the mouse leaves' +
              ' the cell.'
            ''
            
              'On entry, MouseMove saves the current cell location in variables' +
              ' NewCol and '
            'NewRow. It then checks to see if:'
            
              '1) the cursor is on a cell since area covered by the cells maybe' +
              ' less than the '
            'grid dimensions.'
            
              '2) The current cursor location is different from the previous lo' +
              'cation (saved in '
            
              'SaveCol and SaveRow).  Since MouseMove is called for every detec' +
              'ted '
            
              'movement, multiple calls may be made as the cursor moves inside ' +
              'the cell.  '
            'We want only to process the first entry in this cell.'
            ''
            'If 1) and 2) are true, then:'
            
              '3) If SaveCol has a valid value (i.e. this is not the first entr' +
              'y),  we will restore a '
            
              'previously saved SaveCell value into the cell.  SaveCol iinitial' +
              'ly s set to -1 in a '
            
              'PageControlChange exit indicating to the other methods that ther' +
              'e is no '
            'previous value to restore.'
            ''
            '4) Move Newcol & NewRow values to SaveCol & SaveRow and save the'
            
              'current cell value in SaveCell so that it can be restored when t' +
              'he Mouse'
            'leaves this cell.'
            ''
            
              'Since we are now changing Cell values rather just the background' +
              ' color, we'
            
              'can call the grid'#39's "Update" method which will redraw only chang' +
              'ed cells rather'
            
              'than calling "Invalidate" which forces all cells to be withdrawn' +
              '.'
            '')
          ParentFont = False
          TabOrder = 0
        end
        object StringGrid2: TStringGrid
          Left = 720
          Top = 120
          Width = 385
          Height = 145
          DefaultDrawing = False
          TabOrder = 1
          OnDrawCell = StringGrid2DrawCell
          OnMouseMove = StringGrid2MouseMove
          RowHeights = (
            24
            24
            24
            24
            24)
        end
      end
      object DemoSheet3: TTabSheet
        Caption = 'StringGrid Demo 3'
        ImageIndex = 3
        OnEnter = DemoSheet3Enter
        OnMouseMove = DemoSheet3MouseMove
        object Image2: TImage
          Left = 872
          Top = 368
          Width = 249
          Height = 249
          Stretch = True
        end
        object PicLbl: TLabel
          Left = 808
          Top = 624
          Width = 38
          Height = 16
          Caption = 'PicLbl'
        end
        object Memo3: TMemo
          Left = 8
          Top = 8
          Width = 769
          Height = 417
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'Version 3:   Create a bitmap and "paint" image pieces on the gri' +
              'd.'
            ''
            
              'Bitmap manipulation was another problem George had because he di' +
              'd not realize that'
            
              'bitmap width and height must be set before copying images to the' +
              'm.  This grid demo'
            
              'version uses a default image or one you load to prime a bitmap w' +
              'ith a "stretch" version to'
            'make it the size of the grid.'
            ''
            
              'When the mouse moves over the grid this time, the portion of the' +
              ' image relative to that cell'
            
              'is copied to the grid.  The "Tricky" paint version primes the gr' +
              'id with a few cell images and'
            
              'then toggles images on and off each time the mouse enters the ce' +
              'll.  A little'
            
              'experimentation will train you to plug the "holes" left from you' +
              'r first attempts and complete'
            'the image.'
            ''
            
              'The "Change image" button allow the user to choose a replacement' +
              ' image for the default '
            
              'image.  Note that images will be stretched to fit the square str' +
              'inggrid dimensions regardless of '
            
              'their original domensions.  Note that the program uses the Delph' +
              'i JPEG component to load '
            '".jpg" files as well as ".bmp" bitmap files.')
          ParentFont = False
          TabOrder = 0
        end
        object StringGrid3: TStringGrid
          Left = 792
          Top = 0
          Width = 329
          Height = 329
          DefaultRowHeight = 64
          DefaultDrawing = False
          FixedCols = 0
          FixedRows = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnDrawCell = StringGrid3DrawCell
          OnMouseMove = StringGrid3MouseMove
        end
        object OpenBtn: TButton
          Left = 536
          Top = 568
          Width = 177
          Height = 25
          Caption = 'Change image'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = OpenBtnClick
        end
        object DrawMode: TRadioGroup
          Left = 528
          Top = 440
          Width = 185
          Height = 105
          Hint = 'For "Tricky", mouse moves toggle cell images .'
          Caption = 'Drawing Mode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'Simple Paint'
            'Tricky Paint')
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = DrawModeClick
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BMP (*.Bmp), JPEG (*.jpg)|*.bmp; *.jpg'
    Title = 'Select JPEg or BMP file '
    Left = 1061
    Top = 396
  end
end
