unit U_EditVarValue;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TVarValDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    VarValMemo: TMemo;
    Label2: TLabel;
    procedure VarValMemoKeyPress(Sender: TObject; var Key: Char);
    procedure OKBtnClick(Sender: TObject);
    {procedure DelValBtnClick(Sender: TObject);}
  private
    { Private declarations }
  public
    {Public declarations}
    nbrval:integer;  {the number of value for the each variable}
  end;

var
  VarValDlg: TVarValDlg;

implementation

{$R *.DFM}


procedure TVarValDlg.VarValMemoKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  with varvalmemo do
  begin
    if lines.count>nbrval then
    begin
      showmessage('Only '+inttostr(nbrval) +' values allowed');
      while lines.count>nbrval do lines.delete(lines.count-1);
    end;
  end;
end;

procedure TVarValDlg.OKBtnClick(Sender: TObject);
var i,n,count:integer;
     s:string;
begin
  with varvalmemo do
  begin
    while lines.count>nbrval do lines.delete(lines.count-1);
    count:=0;
    for i:=0 to lines.count-1 do  {delete any commas in values}
    begin
      s:=lines[i];
      n:=pos(',',s);
      while n>0 do
      begin
        delete(s,n,1);
        n:=pos(',',s);
        inc(count)
      end;
      lines[i]:=s;
    end;
    if count>0 then showmessage('Commas are not allowed in values, they have been removed');
    If lines.count<nbrval then
    begin
      showmessage(inttostr(nbrval) +' values are required. please enter '
             +inttostr(nbrval-lines.count) +' more values');
      modalresult:=mrNone;
    end
    else modalresult:=MrOK;
  end;  
end;

end.
