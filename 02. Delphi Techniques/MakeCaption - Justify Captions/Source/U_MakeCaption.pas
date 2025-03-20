unit U_MakeCaption;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    LeftEdt: TEdit;
    RightEdt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    
    procedure makecaption(leftSide, Rightside:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.makecaption(leftSide, Rightside:string);
var
  Metrics:NonClientMetrics;
  captionarea,spacewidth,nbrspaces:integer;
  b:TBitmap;
begin
  b:=TBitmap.create;  {to get a canvas}
  metrics.cbsize:=sizeof(Metrics);
  if SystemParametersInfo(SPI_GetNonCLientMetrics, sizeof(Metrics),@metrics,0)
  then  with metrics   do
  begin
    b.canvas.font.name:=Pchar(@metrics.LFCaptionFont.LfFaceName);
    with metrics.LFCaptionFont, b.canvas.font do
    begin
      height:=LFHeight;
      if lfweight=700 then style:=[fsbold];
      if lfitalic<>0 then style:=style+[fsitalic];
    end;
    {subtract 3 buttons + Icon + some border space}
    captionarea:=clientwidth-4*iCaptionwidth-4*iBorderWidth;;
    {n = # of spaces to insert}
    spacewidth:=b.canvas.textwidth(' ');
    nbrspaces:=(captionarea-b.canvas.textwidth(Leftside + Rightside)) div spacewidth;
    if nbrspaces>3 then caption:=LeftSide+stringofchar(' ',nbrspaces)+RightSide
    else caption:=LeftSide+' '+RightSide;
  end;
  b.free;
end;

procedure TForm1.FormResize(Sender: TObject);
{Draw a right and left justifies captions}
begin
  makecaption(LeftEdt.text, RightEdt.text {#169+ ' G Darby, www.delphiforfun.org'});
end;


procedure TForm1.FormActivate(Sender: TObject);
{ Show non client metrics}
var
  Metrics:NonClientMetrics;
  r:boolean;
  s:string;
begin
  metrics.cbsize:=sizeof(Metrics);
  r:=SystemParametersInfo(SPI_GetNonCLientMetrics, sizeof(Metrics),@metrics,0);
  if r then
  with memo1.lines, metrics   do
  begin
    add('PARTIAL NON-CLIENT AREA STATISTICS');
    add('----------------------------------');
    add('BorderWidth:'+inttostr(iBorderwidth));
    add('Scrollwidth:'+inttostr(iScrollWidth));
    Add('Caption Info');
    add('     Caption Button Width:'+inttostr(iCaptionWidth));
    add('     Caption Button Height:'+inttostr(iCaptionHeight));
    add('     Large Font Height:'+inttostr(LfCaptionFont.Lfheight));
    add('     Large Font Width:'+inttostr(LfCaptionFont.Lfwidth));
    add('     Large Font Name:'+ Pchar(@LfCaptionFont.LfFaceName));
    s:='';
    if LfCaptionFont.LfWeight=700 then s:='FsBold';
    if LfCaptionFont.LfItalic<>0 then s:=s+',FsItalic';
    if (length(s)>0) and (s[1]=',') then system.delete(s,1,1);
    add('     Large Font Style: ['+s+']');
    (*
    add('     Small Font Height:'+inttostr(LfsmCaptionFont.Lfheight));
    add('     Small Font Width:'+inttostr(LfsmCaptionFont.Lfwidth));
    add('     Small Font Name:'+ PChar(@LfSmCaptionFont.LfFaceName));
    *)
    add('SYSTEM METRICS----------');
    add('    TitleBar Width: '+inttostr(Getsystemmetrics(SM_CXSIZE)));
    add('    Small Icon Width:'+inttostr(Getsystemmetrics(SM_CXSMICON)));
  end;
end;

end.
