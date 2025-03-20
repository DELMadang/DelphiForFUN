object Form1: TForm1
  Left = 157
  Top = 91
  Width = 800
  Height = 646
  Caption = 'Minimal Spanning tree demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 376
    Top = 32
    Width = 385
    Height = 385
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 337
    Height = 401
    Color = 14548991
    Lines.Strings = (
      'A brief course in Graph processing in visual terms:'
      ''
      
        'A Graph is a collection of Vertices (also called Nodes) and Edge' +
        's.'
      'Vertices are points, Edges are lines connecting the Vertices.'
      
        'Weights are values assigned to the Edges.  A Tree consists of al' +
        'l'
      'of the Vertices which are connected, directly or indirectly by'
      'Edges and which do not loop back on themselves. '
      ''
      'A Spanning Tree is tree which contains all of the Nodes in a '
      
        'graph. And finally, a Minimal Spanning Tree is the Spanning Tree' +
        ' '
      
        'for which the sum of all  Edge weights is as least as small as f' +
        'or '
      'any other Spanning Tree.'
      ''
      'In this demo program, you can create nodes and edges by'
      'clicking on the image box at right.  Click on nodes to delete, '
      
        'move, or to start/end an edge.  Click an edge to delete or modif' +
        'y '
      'the weight.Click an empty space to create a new node.  Graphs '
      'may be saved and reloaded as files by clicking the "File" menu '
      
        'button in the top left corner of the screen.  The "Clear" button' +
        ' '
      
        'erases any highlighted tree lines.  The "Delete" button erases  ' +
        'the '
      'graph area.  '
      ''
      'The "Prim'#39's" button uses Prim'#39's Algorithm to find  the minimal '
      
        'spanning tree.  Prim'#39's technique starts at any node and then loo' +
        'ps '
      
        'examining each node not yet in the tree but which is connected t' +
        'o '
      'a node in the tree.  The one whose connecting edge has the '
      
        'smallest weight is added to the tree and the process is repeated' +
        ' '
      
        'untill all of the nodes have been added.  The running time of Pr' +
        'im'#39's '
      'Algorithm is proportional to the square of the number of nodes.'
      ''
      
        'The "Kruskal'#39's"  button uses Kruskal'#39's algorithm to find a solut' +
        'ion '
      'more efficiently (time proportional to the log of the number of '
      'nodes). The algorithm processes edges in increasing weight '
      'sequence.   If the ends of an edge do not already belong to the '
      
        'same tree, the trees at each end of that edge are joined  to mak' +
        'e a '
      'common larger tree.  Each addition increases the number of '
      
        'connected Vertices by one.  For a graph with N vertices, when N-' +
        '1 '
      'edges have been added, we are guaranteed to have the minimal '
      'sum because the smallest possible way to connect two nodes has '
      'been added at each step.'
      ' ')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object KruskalsBtn: TButton
    Left = 24
    Top = 520
    Width = 137
    Height = 25
    Caption = 'Kruskal'#39's'
    TabOrder = 1
    OnClick = KruskalsBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 580
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, 2007 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object StaticText2: TStaticText
    Left = 376
    Top = 8
    Width = 125
    Height = 17
    Caption = 'Current Graph file: xxx.xxx'
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 376
    Top = 424
    Width = 337
    Height = 129
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object PrimsBtn: TButton
    Left = 24
    Top = 480
    Width = 137
    Height = 25
    Caption = 'Prim'#39's'
    TabOrder = 5
    OnClick = PrimsBtnClick
  end
  object ClearBtn: TButton
    Left = 24
    Top = 440
    Width = 137
    Height = 25
    Caption = 'Clear spanning treee'
    TabOrder = 6
    OnClick = ClearBtnClick
  end
  object ResetBtn: TButton
    Left = 176
    Top = 440
    Width = 137
    Height = 25
    Caption = 'Delete graph'
    TabOrder = 7
    OnClick = ResetBtnClick
  end
  object VertexMenu: TPopupMenu
    Left = 760
    Top = 136
    object EdgeStart: TMenuItem
      Caption = 'Make edge from here'
      OnClick = EdgeStartClick
    end
    object Movevertex1: TMenuItem
      Caption = 'Move vertex'
      OnClick = Movevertex1Click
    end
    object DeleteVertex1: TMenuItem
      Caption = 'Delete vertex'
      OnClick = DeleteVertex1Click
    end
  end
  object EdgeMenu: TPopupMenu
    Left = 760
    Top = 104
    object Changeweight1: TMenuItem
      Caption = 'Change weight'
      OnClick = Changeweight1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 760
    Top = 40
    object File1: TMenuItem
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load...'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save As...'
        OnClick = SaveAs1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'gra'
    Filter = 'Graph files (*.gra)|*.gra|All files (*.*)|*.*'
    Left = 760
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'gra'
    Filter = 'Graph files (*.gra)|*.gra|All files (*.*)|*.*'
    Left = 760
    Top = 72
  end
end
