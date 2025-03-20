program SlidingCoins3;

uses
  Forms,
  U_SlidingCoins3 in 'U_SlidingCoins3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
