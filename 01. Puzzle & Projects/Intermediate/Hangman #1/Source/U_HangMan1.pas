unit U_HangMan1;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A human vs human version of hangman}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TKind=(circle,rectangle,Line); {kinds of elements to draw figure}
  THPiece=class(TObject)  {pieces used to draw victim}
    kind:TKind;
    start,stop: TPoint;
  end;

  TForm1 = class(TForm)
    DeadLbl: TLabel;
    PlayerPanel: TPanel;
    Label4: TLabel;
    WordLbl: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Guesseslbl: TLabel;
    HangmanPanel: TPanel;
    Label1: TLabel;
    WordEdt: TEdit;
    HideBox: TCheckBox;
    OKBtn: TBitBtn;
    GallowsImage: TImage;
    NewGameBtn: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    AboutBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure OKBtnClick(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure HideBoxClick(Sender: TObject);
    procedure NewGameBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    HangmanList:TList;
    piececount:integer;
    lastcolor:TColor;
    TheWord:string;
    GuessedLetters:set of char;
    procedure CheckALetter(ch:char);
    procedure drawAPiece(piececolor:TColor);
  end;

var
  Form1: TForm1;

implementation

uses U_About;


{$R *.DFM}

{**************** FormCreate *****************}
procedure TForm1.FormCreate(Sender: TObject);
var
  piece:THPiece;
begin
  {Define all of the hangman pieces}
  piececount:=0;
  HangManList:=TList.create;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;  {base}
    start:=point(200,350);
    stop:=point(50,350);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;   {upright}
    start:=point(50,350);
    stop:=point(50,50);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;   {crosspiece}
    start:=point(50,50);
    stop:=point(125,50);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;  {rope}
    start:=point(125,50);
    stop:=point(125,75);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=circle;  {head}
    start:=point(100,75);
    stop:=point(150,125);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;       {body}
    start:=point(125,125);
    stop:=point(125,225);
    HangmanList.add(piece);
  end;

  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;   {arm1}
    start:=point(125,150);
    stop:=point(75,175);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line; {arm2}
    start:=point(125,150);
    stop:=point(175,175);
    HangmanList.add(piece);
  end;
 piece:=THPiece.create;
  with piece do
  begin      {leg1}
    kind:=line;
    start:=point(125,225);
    stop:=point(100,300);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin      {leg2}
    kind:=line;
    start:=point(125,225);
    stop:=point(150,300);
    HangmanList.add(piece);
  end;
end;

{***************** CheckALetter ***************}
procedure TForm1.CheckaLetter(ch:char);
var
  i:integer;
  s:string;
  goodguess:boolean;
begin
  goodguess:=false;
  if not (ch in GuessedLetters)
  then
  begin
    GuessedLetters:=GuessedLetters+[ch];
    guessesLbl.caption:=guesseslbl.caption+ch+',';
    s:=Wordlbl.caption;
    for i:=1 to length(TheWord) do {see if the letter is in the word}
    begin
      if ch=Theword[i] then
      begin
        s[2*i-1]:=ch; {fill in the  letter in display}
        goodguess:=true;
      end;
    end;
    wordlbl.caption:=s;
    if not goodguess then drawAPiece(clred);
    If pos('_',WordLbl.caption)=0 then  {all underscores replaced by letters}
    showmessage('A reprieve!')
    else If piececount=Hangmanlist.count
    then
    begin
      showmessage('Oh, oh  Goodbye!'+#13 +'(The word was '+theword+')');
      deadlbl.visible:=true;
    end;
  end
  else messagebeep(mb_IconExclamation);
end;


{********************** DrawAPiece **************}
procedure TForm1.DrawAPiece(piececolor:TColor);
var
  piece:THPiece;
  w,h:integer;
begin
  inc(piececount);    {get to the next piece}
  if piececount<=HangManList.count then
  with Gallowsimage, canvas, piece do
  begin
    lastcolor:=piececolor;
    piece:=Hangmanlist[piececount-1];
    case piece.kind of
      line:
      begin
        pen.width:=4;
        pen.color:=piececolor;
        if piececolor=color {to erase face}
        then brush.color:=piececolor;
        moveto(start.x,start.y);
        lineto(stop.x,stop.y);
      end;
      circle: {The face}
      begin
        ellipse(start.x,start.y,stop.x,stop.y);
        w:=stop.x-start.x;
        h:=stop.y-start.y;
        {right eye}
        moveto(start.x+2*w div 10,
                start.y+3*h div 10);
        lineto(start.x+4*w div 10,
                start.y+3*h div 10);
        moveto(start.x+3*w div 10,
                start.y+2*h div 10);
        lineto(start.x+3*w div 10,
                start.y+4*h div 10);
        {left eye}
        {right eye}
        moveto(start.x+6*w div 10,
                start.y+3*h div 10);
        lineto(start.x+8*w div 10,
                start.y+3*h div 10);
        moveto(start.x+7*w div 10,
                start.y+2*h div 10);
        lineto(start.x+7*w div 10,
                start.y+4*h div 10);
       {mouth}
        ellipse(start.x+4*w div 10,
                start.y+7*h div 10,
                start.x+6*w div 10,
                start.y+8*h div 10);
      end;
   end; {case}
  end;
end;



{**************Edit1KeyPress ******************}
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  key:=upcase(key);
  edit1.text:='';
  If not (key in ['A'..'Z']) then
  begin
    key:=#00;
    messagebeep(mb_iconexclamation);
  end
  else  CheckALetter(key);
end;

{***************** OKBtnClick **************}
procedure TForm1.OKBtnClick(Sender: TObject);
var
  i:integer;
begin
  If length(wordedt.text)<= 1
  then showmessage('Enter a longer word please!')
  else
  begin
    Hangmanpanel.visible:=false;
    Playerpanel.visible:=true;
    Gallowsimage.visible:=true;
    newgamebtn.visible:=true;
    TheWord:=uppercase(WordEdt.text);
    wordlbl.caption:='';
    for i:=1 to length(Theword) do
           WordLbl.caption:=wordlbl.caption+'_ ';
    guessedletters:=[];
    guessesLbl.caption:='';
    with gallowsimage do canvas.rectangle(clientrect);
    {for i:=0 to HangManList.count-1 do drawapiece(color); }
    piececount:=0;
    deadlbl.visible:=false;
    edit1.SetFocus;
  end;
end;

{**************** HideBoxClick ***************}
procedure TForm1.HideBoxClick(Sender: TObject);
begin
   if Hidebox.checked then wordedt.passwordchar:='*'
   else wordedt.passwordchar:=#0;
end;

{*******************EditKeyPress ****************}
procedure TForm1.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if not (upcase(key) in ['A'..'Z',#8]) then
  begin
    messagebeep(mb_iconexclamation);
    key:=#0;
  end;
end;

{**************** NewGameBtnClick **************}
procedure TForm1.NewGameBtnClick(Sender: TObject);
{reset things for a new game}
begin
  Hangmanpanel.visible:=true;
  Playerpanel.visible:=false;
  Gallowsimage.visible:=false;
  newgamebtn.visible:=false;
  DeadLbl.visible:=false;
  wordedt.text:='';
  edit1.text:='';
  piececount:=0;
  wordedt.setfocus;
end;

procedure TForm1.AboutBtnClick(Sender: TObject);
begin
  aboutbox.showmodal;
end;


end.
