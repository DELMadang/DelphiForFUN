unit U_Startup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Image1: TImage;
    Image2: TImage;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses U_MagicCube, umakecaption;

{$R *.DFM}

procedure TForm2.FormActivate(Sender: TObject);
{Draw a couple of "cubes" with question marks}
begin
  makecaption('Magic Cube Introduction',
              #169+' 2002 G Darby  www.delphiforfun.org', self);
  form1.drawcube(image1, -1,-1,-1);
  form1.drawcube(image2, -1,-1,-1);
end;

end.
