unit U_Info;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls;

type
  TInfo = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    RichEdit1: TRichEdit;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Info: TInfo;

implementation

{$R *.DFM}
Uses U_Pendulum;

procedure TInfo.FormShow(Sender: TObject);
var rs: TResourceStream;
begin

  Richedit1.PlainText := False;
  with form1.pagecontrol1 do
  if activepage=form1.SimpleSheet then
  begin
     caption:='Simple Pendulum Info';
     try
       rs := TResourceStream.Create( hinstance, 'Simple', RT_RCDATA );
       rs.Position := 0;
       Richedit1.Lines.LoadFromStream(rs);
     finally
      rs.free;
  end;
  end
  else if activepage=form1.DoubleSheet then
  begin
    caption:= 'Double Pendulum Info';
     try
       rs := TResourceStream.Create( hinstance, 'Double', RT_RCDATA );
       rs.Position := 0;
       Richedit1.Lines.LoadFromStream(rs);
     finally
      rs.free;
     end;
  end
  else if activepage=form1.ForcedSheet then
  begin
    caption:= 'Damped Forced Pendulum Info';
     try
        rs := TResourceStream.Create( hinstance, 'Forced', RT_RCDATA );
       rs.Position := 0;
       Richedit1.Lines.LoadFromStream(rs);
     finally
      rs.free;
     end;
  end;
end;

end.
