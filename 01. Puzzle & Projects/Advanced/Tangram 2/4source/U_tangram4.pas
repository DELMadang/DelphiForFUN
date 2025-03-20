unit U_tangram4;
 {Copyright  © 2001-2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Version 3.0 - Pretty much complete}

{Concept and file structures adapted from Tangram freeware program written by
Dr Mark Overmars and available for download from http://www.cs.ruu.nl/~markov/kids/

Dr. Overmars' program is more complete than this version and is recommended
for playing Tangram.  This Delphi version is intended as a vehicle to study
the grapic and geometric processes. }

{Update - August, 2009:  The free version referenced above is no longer available.
 Version 4 posted here addresses a design problem with original version which
 causes pieces to change size when rotated an odd number of times.  Since the
 size change existed when the puzzles were defined, it is transparent to the
 user in most cases.  A viewer recently discovered a number of cases where
 rotated pieces were reduced in size enough to allow all of the pieces to be
 placed on the template with white space left over.  Thw problem cannot be
 coreected with redefining all of the affected puzzles, so as an alternative,
 a "Gremlin got your puzzle" message replaces the "Solved" message when the
 condition occurs} 


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, U_TPiece4, Menus, shellapi;

type
  TForm1 = class(TForm)
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    LoadPiecebtn: TButton;
    RestartBtn: TButton;
    StaticText1: TStaticText;
    NextBtn: TButton;
    SolveBtn: TButton;
    PrevBtn: TButton;
    ExitBtn: TButton;
    StaticText2: TStaticText;
    Memo1: TMemo;
    RoundBtn: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RestartBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure LoadPiecebtnClick(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PrevBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
  public
    Tangram:TTangram;
    figfile:string;
    procedure setcaption;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{******************* Form Methods *******************}


{***************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  Tangram:=TTangram.createTangram(self,rect(0,0,panel1.left,
                                  clientheight-statictext1.height-statictext2.height),false);
  doublebuffered:=true; {eliminate flicker}
  opendialog1.initialdir:=extractfilepath(application.exename);
  figfile:=opendialog1.InitialDir+'\OriginalSquare.tan';

  if fileexists(figfile) then
  with tangram do
  begin
    loadfigset(figfile);
    showfigure(1);
    setcaption;
    //solvebtnclick(sender);
  end
  else Open1click(self);  {get a figures file}

end;

{**************** FormClose **************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 tangram.free;
end;

{**************** RestartBtnClck **********}
procedure TForm1.RestartBtnClick(Sender: TObject);
begin
  tangram.restart;
end;

{************ NextBtnClick ********}
procedure TForm1.NextBtnClick(Sender: TObject);
begin
  with tangram do showfigure(curfig+1);
  setcaption;
end;

{********** PrevBtnClick **********8}
procedure TForm1.PrevBtnClick(Sender: TObject);
begin
  with tangram do showfigure(curfig-1);
  setcaption;
end;

{*************** Open1Click ***********}
procedure TForm1.Open1Click(Sender: TObject);
begin

    if opendialog1.execute then
    with tangram do
    begin
      loadfigset(opendialog1.filename);
      figfile:=opendialog1.filename;
      showfigure(1);
      setcaption;
    end;
end;

{************ LoadPieceBtnClick ******}
procedure TForm1.LoadPiecebtnClick(Sender: TObject);
begin
  Open1click(sender);
end;

{************ SolveBtnClick ***********}
procedure TForm1.SolveBtnClick(Sender: TObject);
begin
   tangram.showsolution;
end;

{*********** FormKeyDown *************}
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  f:string;
begin
   with tangram do
   if (dragnbr>0) and ((key=ord('F')) or (key=ord('f')))
   then
   begin
     piece[dragnbr].flip;
     invalidate;
   end
   else if ((key=ord('S')) or (key=ord('s'))) then
   begin
     {save figure as a bitmap}
     b:=tbitmap.create;
     b.width:=tangram.width;
     b.height:=tangram.height;
     tangram.painttobitmap(b);
     f:=extractfilename(figfile);
     delete(f,pos('.',f),4);

     f:=extractfilepath(application.exename)+trim(f)+'_Fig'+inttostr(curfig)+'.bmp';
     b.savetofile(f);
     b.free;
   end;
end;

{********** SetCaption *********}
procedure TForm1.setcaption;
begin
  caption:='TANGRAM - '+Uppercase(extractfilename(figfile))+',  Figure '+inttostr(tangram.curfig)
           + ' of '+ inttostr(tangram.nbrfigures);
end;

{*********** ExitBtnClick *********}
procedure TForm1.ExitBtnClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.StaticText2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

