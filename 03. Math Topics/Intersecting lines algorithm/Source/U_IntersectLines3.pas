unit U_IntersectLines3;
{Copyright  © 2001-2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, shellApi, UGeometry;

type
  Tdrawmode=(startingline, endingline , resetmode );

  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    X11UD: TUpDown;
    Edit1: TEdit;
    Edit2: TEdit;
    Y11UD: TUpDown;
    Edit3: TEdit;
    X12UD: TUpDown;
    Edit4: TEdit;
    Y12UD: TUpDown;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    X21Ud: TUpDown;
    Label10: TLabel;
    Edit6: TEdit;
    Y21UD: TUpDown;
    Label11: TLabel;
    Edit7: TEdit;
    X22UD: TUpDown;
    Label12: TLabel;
    Edit8: TEdit;
    Y22UD: TUpDown;
    StaticText1: TStaticText;
    CheckBtn: TButton;
    Label13: TLabel;
    RandomTestBtn: TButton;
    Label14: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    Label15: TLabel;
    Button2: TButton;
    procedure Image1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StaticText1Click(Sender: TObject);
    procedure CheckBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Memo1DblClick(Sender: TObject);
    procedure RandomTestBtnClick(Sender: TObject);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    drawmode:TDrawmode;
    linecount:integer;
    lines:array [1..2] of Tline;
    filename:string; {name of text file of lines checked}
    startpoint, prevpoint:TPoint;
    procedure reset;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;  {to get access to max and min functions}

procedure TForm1.reset;
  begin
    image1.canvas.brush.color:=clwhite;
    with image1, canvas do Rectangle(rect(0,0,width,height));
    image1.canvas.brush.color:=clBlack;
    linecount:=0;
    label14.caption:='Click to start line 1';
    drawmode:=startingline;
  end;


{***************** Image1Click *******************}
procedure TForm1.Image1Click(Sender: TObject);
{Define a point or draw a line}
  {local procedure : drawdot, draws the line segment ends}
   procedure drawdot(p:TPoint);
   begin
     with image1.canvas do ellipse(rect(p.x-2,p.y-2,p.x+2,p.y+2));
   end;

var
  p:TPoint;
  IP:TPoint;
  //IPReal:TrealPoint;
  OnBorder:boolean;
  s:string;
  msg1,msg2:string;
begin
 if (drawmode=resetmode) then reset;
  case  drawmode of
    startingline:
    begin
      if (drawmode=resetmode) and (linecount=2) then reset;
      inc(linecount);
      p:=image1.screentoclient(mouse.cursorpos);
      lines[linecount].p1:=p;
      drawdot(p);
      drawmode:=endingline;
      startpoint:=p;
      prevpoint:=p;
      label14.caption:='Click to end line '+inttostr(linecount);
      if linecount=1 then
      begin
        X11UD.position:=p.x;
        Y11UD.position:=P.y;
        x11UD.update;
        y11UD.update;
      end
      else
      begin
        X21UD.position:=p.x;
        Y21UD.position:=P.y;
        x21UD.update;
        y21UD.update;

      end
    end;
    endingline:
    begin
      p:=image1.screentoclient(mouse.cursorpos);
      lines[linecount].p2:=p;
      drawdot(p);
      with lines[linecount].p1 do image1.canvas.moveto(x,y);
      with p do image1.canvas.lineto(x,y);
      if linecount=1 then
      begin
        drawmode:=startingline;
        label14.caption:='Click to start line 2';
        X12UD.position:=p.x;
        Y12UD.position:=P.y;
        x12UD.update;
        y12UD.update;
      end
      else
      begin
        X22UD.position:=p.x;
        Y22UD.position:=P.y;
        x22UD.update;
        y22UD.update;
        drawmode:=resetmode;
        application.processmessages;
        s:=format('L1:(%3d,%3d)=>(%3d,%3d) L2: (%3d,%3d)=>(%3d,%3d)',
                      [lines[1].p1.x,lines[1].p1.y,lines[1].p2.x,lines[1].p2.y,
                       lines[2].p1.x,lines[2].p1.y,lines[2].p2.x,lines[2].p2.y]);

        If listbox1.items.indexof(s)<0 then listbox1.items.add(s);
        //if Intersect(lines[1],lines[2],OnBorder, IP )
        {"Intersect" has a bug fixed by replacement "LinesIntersect"}
        if tag=0 then
        begin
          if linesintersect(lines[1],lines[2]) then msg1:=' ' else msg1:=' NOT ';
          Label14.caption:='These lines DO'+msg1+'intersect.  Click a location to start a new case';
          (*
          then MessageDlgPos('These lines DO intersect!',mtinformation,[mbOK],0,left,top)
          else MessageDlgPos('These lines DO NOT intersect!',mtinformation,[mbOK],0,left,top);
          *)
        end
        else
        begin {test mode to compare results}
          if linesintersect(lines[1],lines[2]) then msg1:='Yes' else msg1:='No';
          (*
          if FastGeointersect(lines[1].p1.x,lines[1].p1.y, lines[1].p2.x, lines[1].p2.y,
                        lines[2].p1.x,lines[2].p1.y, lines[2].p2.x, lines[2].p2.y,
                        ipreal.x,ipreal.y) then msg2:='Yes' else msg2:='No';
           *)
          if intersect(lines[1],lines[2],Onborder,IP)then msg2:='Yes' else msg2:='No';

          messagedlg(format('"LinesIntersect": %s, "Intersect": %s',[msg1,msg2]),
                      mtinformation,[mbOK],0);
        end;
      end;
    end;
  end;
end;


{**************** FormActivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  doublebuffered:=true;
  filename:=extractfilepath(application.exename)+'Checked.txt';
  if fileexists(filename) then listbox1.items.loadfromfile(filename);
  x11ud.Max:=image1.Width;
  x12ud.Max:=image1.Width;
  x21ud.Max:=image1.Width;
  x22ud.Max:=image1.Width;
  y11ud.Max:=image1.height;
  y12ud.Max:=image1.height;
  y21ud.Max:=image1.height;
  y22ud.Max:=image1.height;

  reset;
end;

{******************** Image1MouseMove **********************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{display current mouse coordinates}
var
  p:TPoint;
begin
  p:=point(x,y);
  if drawmode=endingline then
  with image1.canvas do
  begin
    moveto(prevpoint.x,prevpoint.y);
    Pen.color:=clwhite;
    lineto(startpoint.x, startpoint.y);
    prevpoint:=p;
    Pen.color:=clgray;
    lineto(p.x,p.y);
    if linecount=1 then
    begin
      X12UD.position:=p.x;
      Y12UD.position:=P.y;
      x12UD.update;
      y12UD.update;
    end
    else {if linecount=2 then }
    begin
     {redraw any part of line 1 which might mhave been erased by the mousemove}
      pen.color:=clblack;
      moveto(x11UD.position,Y11UD.position);
      lineto(x12UD.position,Y12UD.position);
      X22UD.position:=p.x;
      Y22UD.position:=P.y;
      x22UD.update;
      y22UD.update;
    end;
  end;
  label2.caption:='X:'+inttostr(p.x)+'  Y:'+inttostr(p.y);
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{***************** RandomTestBtnClick ***********}
procedure TForm1.RandomTestBtnClick(Sender: TObject);
{compares two versions of intersect routines}
var
  i:integer;
  maxx,maxy:integer;
  //ipReal:TrealPoint;
  IP:TPoint;
  OnBorder:boolean;
  line1,line2:TLine;
  mr:integer;
  r1,r2:boolean;
  intersectcount, nointersectcount:integer;
  PointsOnborders:integer;
  nbrcases:integer;
begin
  randomize;
  intersectcount:=0;
  nointersectcount:=0;
  PointsOnBorders:=0;
  maxx:= image1.width;
  maxy:=image1.height;
  cursor:=crhourglass;
  nbrcases:=1000000;
  for i:=1 to nbrcases do
  begin
    line1:=line(point(random(maxx),random(maxy)),point(random(maxx),random(maxy)));
    line2:=line(point(random(maxx),random(maxy)),point(random(maxx),random(maxy)));
    r1:=intersect(line1,line2,onborder,ip);
    (*
    r1:= FastGeointersect(line1.p1.x,line1.p1.y, line1.p2.x, line1.p2.y,
                        line2.p1.x,line2.p1.y, line2.p2.x, line2.p2.y,
                        ip.x,ip.y);
     *)
    r2:=linesintersect(line1,line2);
    if r1<>r2 then
    begin
      X11UD.position:=line1.p1.x;
      Y11UD.position:=line1.p1.y;
      X12UD.position:=line1.p2.x;
      Y12UD.position:=line1.p2.y;
      X21UD.position:=line2.p1.x;
      Y21UD.position:=line2.p1.y;
      X22UD.position:=line2.p2.x;
      Y22UD.position:=line2.p2.y;
      application.processmessages;
      tag:=1;

      mr:=messagedlg('Results differ after '+inttostr(i-1)+ ' matches',mtinformation,[mbOK,mbcancel],0);
      if mr=mrcancel then break else  checkbtnclick(sender);;
    end
    else
      if r1 then
      begin
        inc(intersectcount);
        if onborder then inc(PointsOnBorders);
      end
      else inc(nointersectcount);

  end;

  ShowMessage(format('Comparing "Intersect" and "LinesIntersect" function results'+#13+
             '%.0n random cases'+#13+
             '%.0n results agreed,'+#13+
             '%.0n Intersected, '+#13+
             '%.0n Points on Borders '+#13+
             '%.0n  No intersect,',[nbrcases+0.0, intersectcount+nointersectcount+0.0,
             intersectcount+0.0, pointsOnBorders+0.0, nointersectcount+0.0]));
  cursor:=crdefault;
  tag:=0;
end;

{*************** CheckBtnClick ***************}
procedure TForm1.CheckBtnClick(Sender: TObject);
begin
  reset;
  //drawmode:=startingline;
  //linecount:=0;
  mouse.cursorpos:=image1.clienttoscreen(point(x11UD.position,Y11UD.position));
  image1click(sender); image1.update; sleep(500);
  mouse.cursorpos:=image1.clienttoscreen(point(x12UD.position,Y12UD.position));
  image1click(sender); image1.update; sleep(500);
  mouse.cursorpos:=image1.clienttoscreen(point(x21UD.position,Y21UD.position));
  image1click(sender); image1.update; sleep(500);
  mouse.cursorpos:=image1.clienttoscreen(point(x22UD.position,Y22UD.position));
  image1click(sender); image1.update; sleep(500);
end;

procedure TForm1.Memo1DblClick(Sender: TObject);
{Replay the clicked row}
var
  s:string;
begin
  reset;
  with listbox1 do
  begin
    s:=items{lines}[itemindex];
    {Extract the point values from the line}
    If length(s)>=47 then
    begin
      X11UD.position{edit1.text}:=strtoint(copy(s,5,3));
      Y11UD.position{edit2.text}:=strtoint(copy(s,9,3));
      X12UD.position{edit3.text}:=strtoint(copy(s,16,3));
      Y12UD.position{edit4.text}:=strtoint(copy(s,20,3));
      X21UD.position{edit5.text}:=strtoint(copy(s,30,3));
      Y21UD.position{edit6.text}:=strtoint(copy(s,34,3));
      X22UD.position{edit7.text}:=strtoint(copy(s,41,3));
      Y22UD.position{edit8.text}:=strtoint(copy(s,45,3));
      {and then replay it}
      checkbtnclick(sender);
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
{Save clicked points at close time}
begin
  listbox1.items.savetofile(filename);
  action:=cafree;
end;



{************** Listbox1keyup *************}
procedure TForm1.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Let the user delete a line}
var
  saveindex:integer; begin
  If key=vk_Delete then with listbox1 do
  begin
    saveindex:=itemindex;
    items.delete(itemindex);
    {delete set itemindex to -1, but we want to keep the next item selected
     for multiple deletes, so we'll save and restore the index}
    if saveindex>items.count-1 then itemindex:=items.count-1
    else itemindex:=saveindex;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  tag:=-1;
  checkbtnclick(sender);
  tag:=0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  listbox1.clear;
end;

end.


