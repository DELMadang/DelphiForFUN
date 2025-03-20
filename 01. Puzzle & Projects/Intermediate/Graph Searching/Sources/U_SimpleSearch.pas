unit U_SimpleSearch;
{Copyright  © 2000, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    UTGraphSearch, StdCtrls, ShellAPI, ExtCtrls;

type
  TForm1 = class(TForm)
    GenerateBtn: TButton;
    DFBtn: TButton;
    BFBtn: TButton;
    Memo1: TMemo;
    Image1: TImage;
    StaticText1: TStaticText;
    procedure GenerateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DFBtnClick(Sender: TObject);
    procedure BFBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GraphList:TGraphList;
    procedure ShowSolution;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.GenerateBtnClick(Sender: TObject);
{make the graph list}
var
  key:string;
  i,j:integer;
begin
  graphlist.clear;
  with graphlist do
  begin
    {add 10 nodes}
    for i:=1 to 10 do
    begin
      key:=format('%2.2d',[i]);
      addnode(key) ;
    end;
    finalize;   {sort it}
    {Add edges}
    addedge('01','02');
    addedge('01','03');
    addedge('02','04');
    addedge('02','05');
    addedge('03','06');
    addedge('03','07');
    addedge('03','10');
    addedge('05','08');
    addedge('05','09');
    addedge('05','10');
    addedge('04','10');
    addedge('07','10');
    addedge('09','10');


  end;

  {now display nodes and edges}
  with memo1, lines do
  begin
    clear;
    add('Graph built with '+inttostr(Graphlist.count)
        +' nodes');
    for i:= 0 to Graphlist.count-1 do
    begin
      add(graphlist[i]);
      with TNode(graphlist.objects[i]) do
      for j:=0 to nbradjacents-1 do
        add('   Edge to: '+ graphlist[adjacents[j].ToNodeIndex]);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   GraphList:=TGraphlist.create;
end;

procedure TForm1.DFBtnClick(Sender: TObject);
{Depth first search}
begin
  memo1.Clear;
  memo1.lines.add('Searching depth first paths from ''01'' to node ''10''');
  graphlist.MakePathsToDF('01','10', 5, showsolution);
end;

procedure TForm1.showsolution;
{Callback method from search routines}
var
  i:integer;
begin
  memo1.lines.add('');
  with graphlist do
  for i:=0 to q.count-1 do
  begin
    memo1.lines.add(strings[tnode(q[i]).index]);
  end;
end;

procedure TForm1.BFBtnClick(Sender: TObject);
{Breadth first search}
begin
  memo1.clear;
  memo1.lines.add('Searching breadth first paths from ''01'' to node ''10''');
  graphlist.MakePathsToBF('01','10', 5, showsolution);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
