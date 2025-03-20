unit U_Wordstuff3;

{Copyright 2001, 2018, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Wrapper unit for CrosswordHelper, Unscramble, Decrypt, and Wordladder
 - adds option to load private as well as public dictionaries }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls, Buttons, jpeg, ComCtrls, shellapi,types;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    WordFunctions1: TMenuItem;
    Unscramcle1: TMenuItem;
    WordCompletion1: TMenuItem;
    Image1: TImage;
    UnscrambleBtn: TBitBtn;
    WordCompleteBtn: TBitBtn;
    Decrypt1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Dictionary1: TMenuItem;
    Loadpublicmiandictionary1: TMenuItem;
    Loadprivatedictionary1: TMenuItem;
    decryptbtn: TBitBtn;
    Options1: TMenuItem;
    Useabbrevs: TMenuItem;
    Useforeign: TMenuItem;
    Usecaps: TMenuItem;
    About1: TMenuItem;
    WordLadderBtn: TBitBtn;
    WordLadder1: TMenuItem;
    StaticText1: TStaticText;
    ScrambledPieBtn: TBitBtn;
    ScrambledPie1: TMenuItem;
    SpellboundBtn: TBitBtn;
    Spellbound1: TMenuItem;

    procedure WordCompleteBtnClick(Sender: TObject);
    procedure UnScrambleBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LoadPrivateDictionary1Click(Sender: TObject);
    procedure LoadPublicDictionary1Click(Sender: TObject);
    procedure UnScrambleBtnEnter(Sender: TObject);
    procedure Decrypt1Click(Sender: TObject);
    procedure Optionschanged(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure WordLadderBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure ScrambledPieBtnClick(Sender: TObject);
    procedure SpellboundBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation
  uses U_CrosswordHelper2, UDict, U_Decrypt3,  U_Unscramble, U_About, U_Wordladder,
  U_ScrambledPie, U_Spellbound2;

{$R *.DFM}

procedure TForm1.WordCompleteBtnClick(Sender: TObject);
begin
  wordcompleteform.showmodal;
end;

procedure TForm1.UnScrambleBtnClick(Sender: TObject);
begin
  Unscrambleform.showmodal;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Pubdic.LoadDefaultDic;
  optionschanged(sender);
end;

procedure TForm1.UnScrambleBtnEnter(Sender: TObject);
begin
  UnScrambleBtn.Brush.Color:=clgreen;
  UnScrambleBtn.Brush.Style:=bssolid;
  UnscrambleBtn.repaint;
end;


procedure TForm1.Decrypt1Click(Sender: TObject);
{decrypt a message encrypted using a simple substitution code
  by trial and error combinations}
begin
  Decryptform.showmodal;
end;

procedure TForm1.LoadpublicDictionary1Click(Sender: TObject);
begin
  with dicform.opendialog1 do
  begin
    title:='Select a public dictionary';
    If  execute then pubdic.loaddicfromfile(filename);
  end;
end;

procedure TForm1.LoadPrivateDictionary1Click(Sender: TObject);
begin
  with dicform.opendialog1 do
  begin
    title:='Select a private dictionary';
    If  execute then privdic.loaddicfromfile(filename);
  end;
end;

procedure TForm1.OptionsChanged(Sender: TObject);
begin
   with wordcompleteform do
   begin
     useabbrevs.checked:=self.useabbrevs.checked;
     useforeign.checked:=self.useforeign.checked;
     wordcompleteform.usecaps.checked:=self.usecaps.checked;
   end;

   with unscrambleform do
   begin
     useabbrevs.checked:=self.useabbrevs.checked;
     useforeign.checked:=self.useforeign.checked;
     usecaps.checked:=self.usecaps.checked;
   end;

   with decryptform do
   begin
     useabbrevs.checked:=self.useabbrevs.checked;
     useforeign.checked:=self.useforeign.checked;
     usecaps.checked:=self.usecaps.checked;
   end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  Aboutbox.showmodal;
end;

procedure TForm1.WordLadderBtnClick(Sender: TObject);
begin
   WordladderForm.showmodal;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.ScrambledPieBtnClick(Sender: TObject);
begin
  scrambledpieform.showmodal;
end;

procedure TForm1.SpellboundBtnClick(Sender: TObject);
begin
  spellboundform.showmodal;
end;

end.
