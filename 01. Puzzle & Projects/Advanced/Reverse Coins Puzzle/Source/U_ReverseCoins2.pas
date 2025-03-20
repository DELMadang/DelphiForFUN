unit U_ReverseCoins2;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Contnrs, Spin;

type

  TPathtohere=class(TObject)
    coins:integer;
    pathtohere:array of integer;
    constructor Create;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    NbrCoinsEdt: TSpinEdit;
    NbrReverseEdt: TSpinEdit;
    ResetBtn: TButton;
    Proto: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    NbrSolutionsGrp: TRadioGroup;
    SearchBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure NbrCoinsEdtChange(Sender: TObject);
    procedure ProtoClick(Sender: TObject);
    procedure NbrReverseEdtChange(Sender: TObject);
  public
    Q:TObjectQueue;
    Nbrcoins, NbrReverse:integer;
    board:TPathToHere;
    images:array[0..9] of TLabel;
    movecount:integer;
    procedure drawcoins;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses mathslib;  {get access to IntPower function}

{******** TPathToHere.Creat **********}
Constructor TPathToHere.Create;
begin
  inherited create;
  coins:=0;
  setlength(PathToHere,0);
end;

{************ Countbits *********}
function countbits(n,maxsize:integer):integer;
{Count the nbr of bits in the binary representation of "N" up to "maxsize" bits}
var i:integer;
    mask:integer;
begin
  result:=0;
  mask:=1;
  for i:=0 to maxsize-1 do
  begin
    if n and mask>0 then inc(result);
    mask:=mask shl 1;
  end;
end;

function factorial(n:integer):integer;
var i:integer;
begin
  result:=1;
  for i:=2 to n do result:=result *i;
end;

{************** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  q:=TObjectQueue.create;
  {Create array of coin "images"}
  for i:=0 to 9 do
  begin
    images[i]:=TLabel.create(TComponent(sender));
    with images[i] do
    begin
      visible:=false;
      top:=proto.top;
      left:=proto.left + i*(proto.width+10);
      parent:=proto.parent;
      height:=proto.height;
      width:=proto.width;
      caption:=proto.caption;
      font.style:=proto.font.style;
      font.size:=proto.font.size;
      font.color:=clblack;
      OnClick:=proto.onclick;
    end;
  end;
end;

{************ SearchBtnClick ***********}
procedure TForm1.SearchBtnClick(Sender: TObject);
{Perform a breadthfirst search using a TObject queue }
var
  i,j,k,n:integer;
  patterncount:integer;
  {testpatterns is an array of integers whose bits reflect the possible coins
  that can be turned in a move}
  testpatterns:array of integer;
  nextboard:TPathToHere;
  s,move:string;
  mask:integer;
  solutioncount:integer;
  nbrarrangements, nbrcombos:integer;
  done:boolean;
begin
  resetbtnclick(sender);
  memo1.clear;
  application.processmessages;  {let the screen update}
  screen.Cursor:=crHourGlass;
  nbrarrangements:=intpower(2,nbrcoins) ;
  {nbrcombos= the number of ways to select "nbrreverse" of "nbrcoins" coins}
  nbrcombos:=factorial(nbrcoins) div (factorial(nbrreverse)*factorial(nbrcoins-nbrreverse));
  patterncount:=0;

  setlength(testpatterns,nbrcombos); {there will nbrcombos patterns}
  for i:=0 to intpower(2,nbrcoins)-1 do
  begin
    if countbits(i,nbrcoins)=nbrreverse then
    begin
      testpatterns[patterncount]:=i;
      inc(patterncount);
    end;
  end;
  board:=TPathtohere.Create;
  Q.push(board);
  solutioncount:=0;
  done:=false;
  repeat
    board:=TPathtohere(Q.pop);   {retrieve the oldest coin arrangement}
    for i:=0 to patterncount-1 do
    begin  {generate all possible next move results and add them to the queue}
      nextboard:=TPathtohere.create;
      setlength(nextboard.pathtohere,nbrreverse);
      with nextboard do
      begin
        {generate the next coin pattern if we flip the coins identified by testopatterns[i]}
        coins:=board.coins xor testpatterns[i];
        pathtohere:=board.pathtohere;
        {need to keep track of the pathtothis arrangement in case it leads to a solution}
        setlength(pathtohere,length(pathtohere)+1);
        pathtohere[high(pathtohere)]:=testpatterns[i];
        if coins=nbrarrangements-1 then
        begin  {all 1 bits = a solution!}
          memo1.Lines.add(format('Solution found in %d steps',[length(pathtohere)]));
          inc(solutioncount);
          with memo1 do
          begin  {decipher the moves to the solution for printing}
            s:='';
            for j:=0 to high(pathtohere) do
            begin
              n:=pathtohere[j];
              mask:=1;
              move:='(';
              for k:=1 to nbrcoins do
              begin
                if (n and mask) >0 then move:=move+inttostr(k)+',';
                mask:=mask shl 1;
              end;
              move[length(move)]:=')';
              s:=s+move+',';
            end;
            lines.add('Coins to flip: '+s);
          end;
          case nbrsolutionsGrp.itemindex of
            0: done:=true;
            1:if solutioncount>=10 then done :=true;
            2:if solutioncount>=100 then done :=true;
          end;
        end;
        Q.push(nextboard);
      end;
    end;
    board.Free;
    if (q.count=0) or (q.count>100000) then done:=true;
  until done;
   if solutioncount=0 then memo1.Lines.add('No solutions found in the first 100,000 arrangements');
   screen.Cursor:=crDefault;
end;

{************* ResetBtnClick ***********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  if q.count>0
  then while q.count>0  do
  begin
    board:=TPathtohere(Q.pop);
    board.Free;
  end;
  nbrcoins:=nbrcoinsEdt.value;
  nbrreverse:=nbrReverseEdt.value;
  Drawcoins;
  movecount:=0;
end;

{******** DrawCoins ********}
procedure TForm1.drawCoins;
var
  i:integer;
begin
  for i:=0 to 9 do
  with images[i] do
  begin
    if i<nbrcoins then visible:=true else visible:=false;
    caption:='H';
    font.color:=clblack;
  end;
end;

{************* NbrCoinsEdtChange **********}
procedure TForm1.NbrCoinsEdtChange(Sender: TObject);
{set new number of coins}
begin
  nbrcoins:=TSpinEdit(sender).value;
  nbrreverseEdt.MaxValue:=nbrcoins;
  resetbtnclick(sender);
end;

{************* ProtoClick *************}
procedure TForm1.protoClick(Sender: TObject);
{User clicked on a letter}
var
  i,count:integer;
begin
  with tlabel(sender) do
  begin {set the text color}
    If font.color=clblack then font.Color:=clred else font.Color:=clblack;
    update;
  end;
  count:=0;
  for i:=0 to nbrcoins-1 do if images[i].font.color=Clred  then inc(count);
  if count = nbrreverse then
  begin    {"flip" the selected coins}
    inc(movecount);
    count:=0;
    for i:=0 to nbrcoins-1 do
    with images[i] do
    begin
      if font.color=clred then
      begin
        font.Color:=clblack;
        if caption='H' then caption:='T' else caption:='H';
      end;
      if caption='T' then inc(count);
    end;
    if count=nbrcoins
    then showmessage(format('Congratulations, you solved it in %d moves!',[movecount]));
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.NbrReverseEdtChange(Sender: TObject);
begin
  nbrreverse:=nbrreverseedt.value;
  label4.caption:=format('Coins will flip when %d have been selected',[nbrreverse]);
end;

end.
