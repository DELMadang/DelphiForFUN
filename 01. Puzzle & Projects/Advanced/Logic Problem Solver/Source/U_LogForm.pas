unit U_LogForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellAPI;

type
  TLogform = class(TForm)
    InfoMemo: TMemo;
    StaticText1: TStaticText;
    LogMemo: TRichEdit;
    FindBtn: TButton;
    FindDialog1: TFindDialog;
    procedure FindBtnClick(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Logform: TLogform;

implementation

uses U_Logic;
{$R *.dfm}
procedure TLogform.FindBtnClick(Sender: TObject);
begin
  logform.logmemo.tag:=0;
  FindDialog1.Position := Point(Logmemo.Left + logmemo.width- 250,
                               top+Logmemo.top);
  finddialog1.execute;
end;

procedure TLogForm.FindDialog1Find(Sender: TObject);
var
  FoundAt: LongInt;
  StartPos, ToEnd: Integer;
  opts:TSearchtypes;
begin
  with LogMemo do
  begin
    { begin the search after the current selection if there is one }
    { otherwise, begin at the start of the text }
    if SelLength <> 0 then  StartPos := SelStart + SelLength
    else StartPos := 0;

    { ToEnd is the length from StartPos to the end of the text in the rich edit control }

    ToEnd := Length(Text) - StartPos;
    opts:=[];
    with finddialog1 do
    begin
      if frmatchcase in options then opts:=[stMatchcase];
      if frWholeWord in options then opts:=opts + [stWholeWord];

    end;
    FoundAt := FindText(FindDialog1.FindText, StartPos, ToEnd, opts);
    if FoundAt <> -1 then
    begin
      SelStart := FoundAt;
      SelLength := Length(FindDialog1.FindText);
      Perform(EM_SCROLLCARET, 0, 0);
      SetFocus;
    end;
  end;
end;


procedure TLogform.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
