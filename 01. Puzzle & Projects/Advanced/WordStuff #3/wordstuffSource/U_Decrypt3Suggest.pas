unit U_Decrypt3Suggest;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, dialogs;

type
  TSuggestionDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations}
    firstfrom, firstto:string;
  end;

var
  SuggestionDlg: TSuggestionDlg;

implementation

{$R *.dfm}

Uses U_Decrypt3;

{*************** OKBtnClick ***************}
procedure TSuggestionDlg.OKBtnClick(Sender: TObject);
var  i,j:integer;
     OK:boolean;
     s1,s2:string;
     errmsg:string;
begin
  {check that suggestions have valid format
   same number, lengths match, and are all letters}
   OK:=true;
   {default error message}
   errmsg:='Suggestion "From" and "To" fields must be letters and agree in number and size';
   for i:=memo1.lines.count-1 downto 0 do
   if trim(memo1.lines[i])='' then memo1.lines.delete(i);

   for i:=memo2.lines.count-1 downto 0 do
   if trim(memo2.lines[i])='' then memo2.lines.delete(i);

  if (memo1.lines.count=memo2.lines.count) then
  begin
    for i:=0 to memo1.lines.count-1 do
    begin
      memo1.Lines[i]:=lowercase(memo1.lines[i]);
      memo2.Lines[i]:=lowercase(memo2.lines[i]);
      s1:=memo1.lines[i];
      s2:=memo2.lines[i];
      if length(s1)<>length(s2) then  OK:=false
      else
      for j:=1 to length(s1) do
      begin
        if (not (s1[j] in ['a'..'z']))
          or (not (s2[j] in ['a'..'z']))
        then
        begin
          OK:=false;
          break;
        end;
      end;
      if not OK then break;
    end;
  end
  else OK:=false;
  {now check that assignments are unique, i.e. no two encrypted letter assigned to the
   same decryted letter and the same encrypted letter is not assigned to two
   different decrypted letters}
     if memo1.lines.count>0 then
     with memo1 do
     begin
       firstfrom:='';
       firstTo:='';
       for i:=0 to lines.count-1 do
      begin
        firstfrom:=firstfrom+lines[i];
        firstto:=firstto+memo2.lines[i];
      end;
      decryptform.removedups(firstfrom);
      decryptform.removedups(firstto);
      if length(firstfrom)<> length(firstto) then
      begin
        errmsg:='After removing duplicates, lengths of "from" and "to" strings differ';
        OK:=false;
      end;
   end;


  if not OK then
  begin
    showmessage(errmsg + #13 + 'From: '+ firstfrom + #13 + 'To:  ' + firstto);
    modalresult:=mrnone;
  end;

end;

end.
