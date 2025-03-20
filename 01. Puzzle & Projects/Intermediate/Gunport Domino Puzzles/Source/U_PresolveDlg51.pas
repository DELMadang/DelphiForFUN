unit U_PresolveDlg51;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, CheckLst;

type
  TPresolveDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    PreSolves: TCheckListBox;
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    SetPresolvesBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SetPresolvesBtnClick(Sender: TObject);
    procedure PreSolvesClickCheck(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    presolvevalues:integer;
    Function GetPreSolves:integer;
    Procedure setPresolves(n:integer);
  end;

var
  PresolveDlg: TPresolveDlg;

implementation

{$R *.dfm}

var
  presolveVals: array [0..11] of integer =
               (1,2,4,8,16,32,64,128,256,8192,16384,262144);

{************* GetPresolves ************}
function TPreSolveDlg.GetPreSolves:integer;
var
  i:integer;
begin
  result:=0;
  with presolves do
  for i:=0 to items.count-1 do if checked[i] then inc(result,presolvevals[i]);
end;

{************* FormActivate ************}
procedure TPresolveDlg.FormCreate(Sender: TObject);
begin
  setpresolves(287135);
  edit1.text:='287135';

end;

{********** OKBtnClick ************}
procedure TPresolveDlg.OKBtnClick(Sender: TObject);
begin
  presolvevalues:=GetPresolves;
end;

{**************** SetPresolves **********8}
Procedure TPresolveDlg.setPresolves(n:integer);
var
 i,j,v:integer;
begin
  with presolves do
  begin
    for i:=0 to items.Count-1 do checked[i]:=false;
    i:=1;
    while i<=262144 do
    begin
      v:=i and n;
      for j:=0 to high(presolvevals) do
      begin
        if v=presolvevals[j] then
        begin
          checked[j]:=true;
          break;
        end
        else if v<presolvevals[j] then break;
      end;
      i:=i shl 1;
    end;
  end;
  presolvevalues:=n;
end;

{************** SetPreSolvesBtnClick **********}
procedure TPresolveDlg.SetPresolvesBtnClick(Sender: TObject);
begin
  setpresolves(strtoint(edit1.text));
end;

{**************** PreSolvesClickCheck **************}
procedure TPresolveDlg.PreSolvesClickCheck(Sender: TObject);
begin
   edit1.text:=inttostr(getpresolves);
end;


end.
