unit U_AniResDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,FileCtrl;

type
  TForm1 = class(TForm)
    GlobeBtn: TButton;
    CoffeeBtn: TButton;
    DefaultBtn: TButton;
    procedure GlobeBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CoffeeBtnClick(Sender: TObject);
    procedure DefaultBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R MyAniCursors.res}

const AniGlobe = 1;
      AniCoffee= 2;

{Adapted from  http://www.howtodothings.com/showarticle.asp?article=288}

function SaveResourceAsTempFile(const ResName: string; ResType: pchar): string;
var
  TempFileName: array [0..MAX_PATH-1] of char;
  TempDir: array [0..MAX_PATH-1] of char;
begin
  GetTempPath(MAX_PATH, TempDir);
  if GetTempFileName(TempDir, '~', 0, TempFileName) = 0 then
    raise Exception.Create(SysErrorMessage(GetLastError));
  Result := TempFileName;
  with TResourceStream.Create(hInstance, ResName, ResType) do
   try        SaveToFile(result);
   finally
     Free;
   end;
end;

function GetResourceAsAniCursor(const ResName: string): HCursor;
var CursorFile: string;
begin
  CursorFile := SaveResourceAsTempFile(ResName, 'ANICURSOR');
  Result := LoadImage(0, PChar(CursorFile), IMAGE_CURSOR, 0, 0,
                           LR_DEFAULTSIZE or LR_LOADFROMFILE);
  DeleteFile(CursorFile);
  if Result = 0 then  raise Exception.Create(SysErrorMessage(GetLastError));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Screen.Cursors[AniGlobe] := GetResourceAsAniCursor('GLOBE');
  Screen.Cursors[AniCoffee] := GetResourceAsAniCursor('COFFEE');
end;

procedure TForm1.GlobeBtnClick(Sender: TObject);
begin
  Cursor := AniGlobe;
end;


procedure TForm1.CoffeeBtnClick(Sender: TObject);
begin
  Cursor := AniCoffee;
end;

procedure TForm1.DefaultBtnClick(Sender: TObject);
begin
  Cursor:=crDefault;
end;

end.
