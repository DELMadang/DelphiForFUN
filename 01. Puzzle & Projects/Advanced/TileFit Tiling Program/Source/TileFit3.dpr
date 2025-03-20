program TileFit3;
     {Copyright  © 2001, 2005, Gary Darby,  www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Fits a random subset of a given set of tiles to fill a given rectangle}

uses
  Forms,
  U_ChangeTile in 'U_ChangeTile.pas' {TileForm},
  U_Runtime in 'U_Runtime.pas' {MaxRunForm},
  U_PrintLayout in 'U_PrintLayout.pas' {PrintLayoutForm},
  U_PreView in 'U_PreView.pas' {PreviewForm},
  U_TileFit3 in 'U_TileFit3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTileForm, TileForm);
  Application.CreateForm(TMaxRunForm, MaxRunForm);
  Application.CreateForm(TPrintLayoutForm, PrintLayoutForm);
  Application.CreateForm(TPreviewForm, PreviewForm);
  Application.Run;
end.
