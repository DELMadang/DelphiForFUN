unit U_FastHighLight;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A program to quickly highlight a predefined set of words with specified colors
in a RichEdit control. Technique to intercept WindowProc is converted from
Basic code provided by Emile Tredoux to Delphi.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, RichEdit, Buttons, ExtCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Keywords: TMemo;
    Label1: TLabel;
    ColorDialog1: TColorDialog;
    ColorBtn: TPanel;
    ToggleBtn: TPanel;
    RichEdit1: TRichEdit;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure TogglebtnClick(Sender: TObject);
    procedure ColorBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Showhighlight:boolean;
    highlightcolor:TColor;
    HighLightList:TStringlist;
    OldRichEditWndProc: {integer}pointer;
    PRichEditWndProc:pointer;
    Function HighLight:boolean;
    procedure Setcolor(newcolor:TColor);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


 {************ HighLight ***********888}
 Function Tform1.HighLight:boolean;
 var
   UText, WordName:string;
   FoundAt, WordLength:integer;
   I, Line:integer;
   hdc:integer;
   result1:integer;
   CharPosion:integer;
   FirstVisibleLine, LastVisibleLine:integer;
   FirstCharPosofLine:integer;
   h:hwnd;
   visrect:Trect;
   vispoint:TPoint;
   current:cardinal;
   index:integer;
begin
  If not showhighlight then exit;
  {Get the handle of the device context}
  h:=Richedit1.Handle;
  hdc              := getdc(h);
  result:= SendMessage (h, EM_GETRECT, 0, integer(@visrect))=0;
  if result then
  begin
    VisPoint.x       := VisRect.right;
    VisPoint.y       := VisRect.bottom;
    CharPosion       := SendMessage (h, EM_CHARFROMPOS, 0, integer(@VisPoint));
    LASTVISIBLELINE  := SendMessage (h, EM_LINEFROMCHAR, CharPosion, 0);
    FIRSTVISIBLELINE := SendMessage (h, EM_GETFIRSTVISIBLELINE, 0, 0);

    SetBkMode (hDC, TRANSPARENT);
    SelectObject(hdc, richedit1.font.Handle);


    For Line := FIRSTVISIBLELINE to LASTVISIBLELINE  do
    begin
      UText := ' ' + RichEdit1.Lines[Line];
      FirstCharPosofLine := SendMessage (RichEdit1.Handle, EM_LINEINDEX, Line, 0);
      i := 0;

      While i <= LENgth(UText) do
      begin
        FoundAt := i -1;
        {Any character except these will count as a word delimiter}
        While utext[i] in ['#','$','A'..'Z','a'..'z','0'..'9'] do inc(i);

        WordLength        := i- FoundAt -1;
        WordName          := copy(UText, i-WordLength, WordLength);
        If HighLightList.find(uppercase(WordName),index) Then
        //if uppercase(wordname)='PLAY' then
        begin
          SendMessage (RichEdit1.Handle, EM_POSFROMCHAR, integer(@VisPoint), FirstCharPosofLine + FoundAt-1);
          SetTextColor(hdc, highlightcolor);
          TextOut(hdc,  VisPoint.x,  VisPoint.y,  pchar(WordName), WordLength);
        End;
        (*
        //=====>> DO PURPLE FOR OPERATORS
        If pos(utext[i],'=+-*/()[]:^<>,:') > 0 Then
        begin
           FoundAt := i;
           WordName    := copy(UText, FoundAt, 1);
           SendMessage (RichEdit1.Handle, EM_POSFROMCHAR, integer(@VisPoint), FirstCharPosofLine + FoundAt-2);
           SetTextColor(hdc, clPurple);
           TextOut(hdc,  VisPoint.x,  VisPoint.y,  @WordName, Length(WordName));
        End;
        *)
        inc(i);
      end;
    end;
  end;
  ReleaseDC(RichEdit1.Handle, hDC);

End;

{************** RichEditWndProc **********}
Function RichEditWndProc (handla:HWnd;uMsg,wParam,lParam:longint): longint stdcall;
begin
      Result := CallWindowProc(form1.OldRichEditWndProc, handla, uMsg, wParam, lParam);
      if uMsg=WM_PAINT then form1.HighLight;
End;


{************* FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  ShowHighLight:=false;
  HighLightlist:=tStringlist.create;
  setcolor(clblue);
  {replace richedit's window proc call with ours to do the highlighting}
  PRichEditWndProc:=@RichEditWndProc;
  Richedit1.perform(EM_EXLIMITTEXT, 0, 65535*32);
  OldRichEditWndProc := pointer(SetWindowLong(Richedit1.handle, GWL_WNDPROC, longint(@RichEditWndProc)));
  togglebtnclick(sender);
end;

{************* ToggleBtnClick *************}
procedure TForm1.TogglebtnClick(Sender: TObject);
var
  i:integer;
begin
  With TButton(sender) do
  if not Showhighlight then
  begin
    Showhighlight:=true;
    highlightlist.assign(keywords.lines);
    {trim any leading & trailing blanks}
    with highlightlist do for i:=0 to count-1 do strings[i]:=trim(strings[i]);
    highlightlist.sort;  {for faster lookups}
    ToggleBtn.font.Color:=highlightcolor;
  end
  else
  begin  {reset highlighting}
    showhighlight:=false;
    togglebtn.font.color:=clblack;
  end;
  togglebtn.invalidate;
  richedit1.invalidate; {update the richedit control}
end;

procedure TForm1.ColorBtnClick(Sender: TObject);
begin
  with colordialog1 do
  if execute then setcolor(color);
  {force the new highlightcolor to show}
  showhighlight:=false;
  togglebtnclick(sender);
end;

procedure TForm1.Setcolor(newcolor:TColor);
  begin
    highlightcolor:=newcolor;
    colorbtn.font.color:=newcolor;
  end;


{Original Basic code sent to me by Emile Tredoux and used as the basis for thie Delphi version}
(*
'SINCE YOU ARE DELPHI AND I AM BASIC I HAVE EXTRACTED CODE / FUNCTIONS
'DOING THE JOB. I AM SURE THAT YOU WOULD FOLLOW THE BASICS
'AND BE ABLE TO DUPLICATE INTO DELPHI.
'I MAKE USE OF THE WINDOWS API TO ACHIEVE MY GOAL.


'=================================================================================
'= INIT THE Keywords STRING VARIABLE WITH THE WORDS SEPERATED BY A SPACE
'=================================================================================
Keywords = " "
For j = 0 to ListBox1.ItemCount -1
   Keywords = Keywords + RTRIM$(LTRIM$(UCASE$(ListBox1.Item(j)))) + " "
Next


'==================================================================================
'= API CALL TO EXTEND THE FILESIZE FOR THE RICHEDIT CONTROL AND GET A HANDLE TO IT
'==================================================================================
Dummy              = SendMessageA    (RichEdit1.Handle, EM_EXLIMITTEXT, 0, 65535*32)
OldRichEditWndProc = SetWindowLongAPI(RichEdit1.Handle, GWL_WNDPROC, CODEPTR(RichEditWndProc))


'==================================================================================
'= ON THE WM_PAINT MESSAGE DO THE HILIGHT FUNCTION
'==================================================================================
Function RichEditWndProc (hWnd as Long, uMsg as Long, wParam as Long, lParam as Long) as Long
      Result = CallWindowProc(OldRichEditWndProc, hWnd, uMsg, wParam, lParam)

      Select CasE uMsg
          CasE  WM_PAINT  :  HiLight()  'Windows has allready painted, now we are painting.
      End Select
End Function
'================================================================================


 Function Hilight() As Long
      Dim UText as String
      Dim WordName as String
      Dim FoundAt as Long
      Dim WordLength As Integer
      Dim i as Integer
      Dim Line as Integer
      dim hdc as integer
      dim hdc2 as integer
      Dim result1 as Long
      Dim CharPosion as Long
      Dim LASTVISIBLELINE as Long
      Dim FIRSTVISIBLELINE as Long
      Dim Currents as Long
      Dim FirstCharPosofLine as Long
      Dim FirstCharPosofLineR as Long
      Dim FirstCharPosofLineM as Long

      If Pause = 0 Then

      ' GET THE HANDLE OF THE DEVICE CONTEXT FOR THE EDITOR
      hdc              = GetDC(RichEdit1.Handle)
      result1          = SendMessageA (RichEdit1.Handle, EM_GETRECT, 0, VisRect)
      VisPoint.x       = VisRect.x2
      VisPoint.y       = VisRect.y2
      CharPosion       = SendMessageA (RichEdit1.Handle, EM_CHARFROMPOS, 0, VisPoint)
      LASTVISIBLELINE  = SendMessageA (RichEdit1.Handle, EM_LINEFROMCHAR, CharPosion, 0)
      FIRSTVISIBLELINE = SendMessageA (RichEdit1.Handle, EM_GETFIRSTVISIBLELINE, 0, 0)

      SetBkMode (hDC, TRANSPARENT)
      Current = SelectObject(hdc, HiFont.Handle)

      ' GET THE HANDLE OF DEVICE CONTEXT FOR THE LINE RULER
      hdc2 = GetDC(RichEdit2.Handle)
      SetBkMode (hDC2, TRANSPARENT)
      Currents = SelectObject(hdc2, RulerFont.Handle)

      For Line = FIRSTVISIBLELINE to LASTVISIBLELINE
      UText = " " + RichEdit1.Line(Line)
      FirstCharPosofLine = SendMessageA (RichEdit1.Handle, EM_LINEINDEX, Line, 0)
      i = 0
        '======= Start drawing the ruler numbers
        WordName = Str$(Line+1)
        FirstCharPosofLineR = SendMessageA (RichEdit2.Handle, EM_LINEINDEX, Line, 0)
        SendMessageA (RichEdit2.Handle, EM_POSFROMCHAR, VisPoint2, FirstCharPosofLineR )
        VisPoint2.x = 5
        VisPoint2.y = VisPoint2.y + ABS((VAL(FontSizeComboBox1.Item(FontSizeComboBox1.ItemIndex))-8)/2)-1
        Rect.Left   = VisPoint2.x -4
        Rect.Top    = VisPoint2.y +1
        Rect.Right  = VisPoint2.x +30
        Rect.Bottom = VisPoint2.y +13
        FillRect (hdc2, Rect, hBrushGrey)
        SetTextColor(hdc2, clBlack)
        TextOut(hdc2,  VisPoint2.x,  VisPoint2.y,  VARPTR(WordName), Len(WordName))

        WordName = Str$(Marker+1)
        FirstCharPosofLineM = SendMessageA (RichEdit2.Handle, EM_LINEINDEX, Marker, 0)
        SendMessageA (RichEdit2.Handle, EM_POSFROMCHAR, PointMarker, FirstCharPosofLineM )
        PointMarker.x = 5
        PointMarker.y = PointMarker.y + ABS((VAL(FontSizeComboBox1.Item(FontSizeComboBox1.ItemIndex))-8)/2)-1
        Rect.Left   = PointMarker.x -4
        Rect.Top    = PointMarker.y +1
        Rect.Right  = PointMarker.x +30
        Rect.Bottom = PointMarker.y +13
        FillRect (hdc2, Rect, hBrushBlue)
        SetTextColor(hdc2, clWhite)
        TextOut(hdc2,  PointMarker.x, PointMarker.y,  VARPTR(WordName), Len(WordName))
      While i <= LEN(UText)
        '======= End drawing the ruler numbers

        FoundAt = i -1  '================>> DO BLUE FOR KEYWORDS
        While INSTR("#$ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", UText[i]) <> 0
            INC(i)     '===> AS LONG AS THERE IS NO SPACE AVAILABLE
        WEND           '===> FOUND A SPACE - so check the word out for being a Keyword
          WordLength        = i- FoundAt -1
          WordName          = MID$(UText, i-WordLength, WordLength)
          If INSTR(Keywords, UCASE$(" "+WordName+" ")) > 0 Then
          SendMessageA (RichEdit1.Handle, EM_POSFROMCHAR, VisPoint, FirstCharPosofLine + FoundAt-1)
          If UCASE$(WordName) = "MAIN" Then
          SetTextColor(hdc, clRed)
          Else
          SetTextColor(hdc, KeyColor)
          End If
          TextOut(hdc,  VisPoint.x,  VisPoint.y,  VARPTR(WordName), WordLength)
          End If

        FoundAt = i
        '=====>> DO LIGHT BLUE FOR STRINGS   '=====>> between ("")marks
        If MID$(UText, FoundAt, 1) = Chr$(34) Then
             INC(i)
             While INSTR(Chr$(34), UText[i]) <= 0
             INC(i)  '===> AS LONG AS THERE IS NO SPACE AVAILABLE
             Wend
             WordLength  = i - FoundAt +1
             WordName    = MID$(UText, FoundAt, WordLength)
             SendMessageA (RichEdit1.Handle, EM_POSFROMCHAR, VisPoint, FirstCharPosofLine + FoundAt-2)
             SetTextColor(hdc, QuoteColor)  ' LIGHT BLUE
             TextOut(hdc,  VisPoint.x,  VisPoint.y,  VARPTR(WordName), LEN(WordName))
        End If

        FoundAt = i
        '=====>> DO GREEN FOR COMMENTS
        If MID$(UText, FoundAt, 1) = Chr$(39) Then
             WordLength  = LEN(UText) - FoundAt +1
             WordName    = MID$(UText, FoundAt, WordLength)
             SendMessageA (RichEdit1.Handle, EM_POSFROMCHAR, VisPoint, FirstCharPosofLine + FoundAt-2)
             SetTextColor(hdc, ComColor)  ' GREEN
             TextOut(hdc,  VisPoint.x,  VisPoint.y,  VARPTR(WordName), WordLength)
             Goto NewLine
        End If
        '=====>> DO PURPLE FOR OPERATORS
        If INSTR("=+-*/()[]:^<>,:", UText[i]) > 0 Then
             FoundAt = i
             WordName    = MID$(UText, FoundAt, 1)
             SendMessageA (RichEdit1.Handle, EM_POSFROMCHAR, VisPoint, FirstCharPosofLine + FoundAt-2)
             SetTextColor(hdc, OpColor) ' Purple
             TextOut(hdc,  VisPoint.x,  VisPoint.y,  VARPTR(WordName), Len(WordName))
        End If

        INC(i)
       Wend
       NewLine:

      Next

      ReleaseDC(RichEdit1.Handle, hDC)
      ReleaseDC(RichEdit2.Handle, hDC2)

      End If
End Function
*)




procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
