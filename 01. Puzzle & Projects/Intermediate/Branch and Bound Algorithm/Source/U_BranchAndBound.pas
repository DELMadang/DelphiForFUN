unit U_BranchAndBound;
//*******************************************************
// Example program demonstrating exhaustive and branch
// and bound searching.
//*******************************************************
// Copyright (C) 1998 John Wiley & Sons, Inc.
// All rights reserved. See additional copyright
// information in Readme.txt.
//*******************************************************
{Modifications with author's permission
 Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, Math, Grids, ComCtrls, ShellAPI;

const
    CR = #13#10;

type
  TItem = record
    Cost   : Integer;
    Profit : Integer;
  end;
  TItemArray = array of TItem;
  //PItemArray = ^TItemArray;

  TBoolArray = array of Boolean;
  //PBoolArray = ^TBoolArray;

  TBandBForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    NodesLabel: TLabel;
    VisitedLabel: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    BestCostLabel: TLabel;
    BestProfitLabel: TLabel;
    SearchtimeLbl: TLabel;
    Label14: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MinCostText: TEdit;
    MaxCostText: TEdit;
    MaxProfitText: TEdit;
    MinProfitText: TEdit;
    RandomBtn: TButton;
    GroupBox2: TGroupBox;
    OptExhaustiveSearch: TRadioButton;
    OptBranchAndBound: TRadioButton;
    GoBtn: TButton;
    ScrollBox2: TScrollBox;
    SolutionLabel: TLabel;
    ShowStepsBox: TCheckBox;
    Memo1: TMemo;
    ItemsGrid: TStringGrid;
    Memo2: TMemo;
    NumItemsText: TEdit;
    AllowedCostText: TEdit;
    NumItemsUD: TUpDown;
    AllowedCostUD: TUpDown;
    StaticText1: TStaticText;
    Memo3: TMemo;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure RandomBtnClick(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure ShowResults;
    procedure Search(b_and_b : Boolean);
    procedure BranchAndBound(item_num : Integer);
    procedure ExhaustiveSearch(item_num : Integer);
    procedure NumItemsUDChangingEx(Sender: TObject;
      var AllowChange: Boolean; NewValue: Smallint;
      Direction: TUpDownDirection);
    procedure NumItemsTextChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    NumItems         : Integer;
    Items            : TItemArray;
    AllowedCost      : Integer;

    {Search variables}
    PathsChecked     : Longint;
    UnassignedProfit : Integer;    // Total of unassigned profits.
    BestSolution     : TBoolArray; // True for items in best solution.
    BestCost         : Integer;
    BestProfit       : Integer;
    TestSolution     : TBoolArray; // True for items in test solution.
    TestCost         : Integer;    // Cost of test solution.
    TestProfit       : Integer;    // Profit of test solution.
    startTime:extended;
    procedure resetLabels;
    procedure loaddefaultcase;
  end;

var
  BandBForm: TBandBForm;

implementation

{$R *.DFM}

var
  {Data for testing }
  (*
  defaultdata:array[1..5,1..2] of integer =
    ((56,8),(12,4),(70,7),(49,7),(37,5));
  *)
  defaultdata:array[1..5,1..2] of integer =
    ((51,1),(11,5),(19,7),(27,7),(47,1));

{************* FormCreate **************}
procedure TBandBForm.FormCreate(Sender: TObject);
var i:integer;
begin
  Randomize;
  with Itemsgrid do
  begin
    cells[0,0]:='Item';
    cells[1,0]:='Cost';
    cells[2,0]:='Profit';
    for i:=1 to numitemsUD.position + 1 do cells[0,i]:=inttostr(i);
  end;
  loaddefaultCase;
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.initialdir;
end;

{************* LoadDefaultCase *********}
Procedure TBandBForm.LoadDefaultCase;
var  i:integer;
begin
  NumItemsUD.position:=high(defaultdata);
  NumItems := NumItemsUD.position;
  //NumItemsText.text:=inttostr(NumItems);
  AllowedCostUD.position:=100;
  Allowedcost:=allowedCostUD.position;
  itemsgrid.rowcount:=NumItems+1;
  {add one extra entry for dynamic array since existing code starts from 1}
  Setlength(Items, (NumItems+1) * SizeOf(TItem));
  setlength(TestSolution, (NumItems+1) * SizeOf(Boolean));
  setlength(BestSolution, (NumItems+1) * SizeOf(Boolean));

  with itemsgrid do
  for i:=1 to NumItems do
  with Items[i] do
  begin
    Cost := defaultdata[i,1];
    Profit := defaultdata[i,2];
    cells[1,i]:=Format('%6d', [Cost]);
    cells[2,i]:=Format('%6d', [Profit]);
  end;

  ResetLabels;     // Clear the previous solution.
end;

{************ ResetLabels ********}
Procedure TBandBForm.ResetLabels;
begin
  SolutionLabel.Caption := '0';
  BestCostLabel.Caption := '0';
  BestProfitLabel.Caption := '0';
  VisitedLabel.Caption := '0';
  SearchtimeLbl.Caption:='0.000 seconds';
  NodesLabel.Caption := format('%.0n',[Power(2, NumItems) - 1]);
  memo1.Clear;
  Refresh;
end;


{*********** CmdmakeDataClick ************}
procedure TBandBForm.RandomBtnClick(Sender: TObject);
{Generate some random data.}
var
  min_cost, max_cost, min_profit, max_profit : Integer;
  i, cost_range, profit_range                : Integer;
begin
  min_cost := StrToInt(MinCostText.Text);
  max_cost := StrToInt(MaxCostText.Text);
  min_profit := StrToInt(MinProfitText.Text);
  max_profit := StrToInt(MaxProfitText.Text);
  cost_range := max_cost - min_cost + 1;
  profit_range := max_profit - min_profit + 1;
  for i := 1 to NumItems do
  With itemsGrid do
  begin
    with Items[i] do
    begin
      Cost := min_cost + Random(cost_range);
      Profit := min_profit + Random(profit_range);
      cells[1,i]:=Format('%6d', [Cost]);
      cells[2,i]:=Format('%6d', [Profit]);
    end;
  end;
  ResetLabels;     {Clear the previous solution.}
  GoBtn.Enabled := True;
end;

{************ GoBtnClick ***********}
procedure TBandBForm.GoBtnClick(Sender: TObject);
{Start the search.}
begin
  if TButton(sender).caption='Stop' then
  begin
    TButton(sender).caption:='Stopping';
    tag:=1;   {Set Stop flag}
    application.processmessages;
  end
  else
  begin
    TButton(sender).Caption:='Stop';
    Screen.Cursor := crHourGlass;
    tag:=0;
    {Get ToSpend and prepare labels.}
    AllowedCost := StrToInt(AllowedCostText.Text);
    ResetLabels;
    Search(OptBranchAndBound.Checked);
    ShowResults;
    TButton(sender).caption:='Go';
    Screen.Cursor := crDefault;
  end;
end;

{************** Showresult **********}
procedure TBandBForm.ShowResults;
{Display the results of the search. }
var
  i   : Integer;
  txt : String;
begin
  txt := ' Item#   Cost   Profit' + CR + '------  ------  ------' + CR;
  for i := 1 to NumItems do
      if (BestSolution[i]) then
          txt := txt + Format('%6d  %6d  %6d',
              [i, Items[i].Cost, Items[i].Profit]) + CR;
  SolutionLabel.Caption := txt;

  BestCostLabel.Caption := IntToStr(BestCost);
  BestProfitLabel.Caption := IntToStr(BestProfit);
  VisitedLabel.Caption := IntToStr(PathsChecked);
  VisitedLabel.Caption := format('%.0n',[0.0+PathsChecked]);
  Searchtimelbl.Caption:=format('%.3f',[(now-startTime)*secsperday]);
end;

{*********** Search *************}
procedure TBandBForm.Search(b_and_b : Boolean);
{Initialize test values and start an exhaustve or branch and bound search.}
var
    i : Integer;
begin
  PathsChecked := 0;
  BestProfit := 0;
  BestCost := 0;
  TestProfit := 0;
  TestCost := 0;
  UnassignedProfit := 0;
  memo1.Clear;
  starttime:=now;
  for i := 1 to NumItems do
     UnassignedProfit := UnassignedProfit + Items[i].Profit;

  {Start the search with the first item. }
  if (b_and_b) then
  begin
    If showstepsbox.Checked
    then with memo1.lines do
    begin
      add(format('Maximize profit by selecting best set of items whose total cost does not exceed %d',
                      [allowedcost]));
      add(format('Profit if all items could be used is %d',[unassignedProfit]));
      add('');
    end;
    BranchAndBound(1)
  end
  else  ExhaustiveSearch(1);
end;

{*************** BranchAndBound *************}
procedure TBandBForm.BranchAndBound(item_num : Integer);
{Perform a branch and bound search starting with the indicated item.}
var
    i : Integer;
    s : string;
begin

  {check occasionally (every 16K nodes visited) to see whether user clicked stop button}
  if PathsChecked and $FFFF =0 then application.processmessages;
  if tag<>0 then exit;  {user clicked stop button}
  { If this is a leaf node, it must be a better solution than we have so far or
    it would have been cut off earlier in the search. }
  if (item_num > NumItems) then
  begin
    {Save the improved solution.}
    for i := 1 to NumItems do BestSolution[i] := TestSolution[i];
    BestProfit := TestProfit;
    BestCost := TestCost;
    If showstepsbox.Checked and (PathsChecked<50)
    then with  memo1.lines do
    begin
      add('Leaf reached');
      add(format('*** New best solution: Cost %d, Profit %d',[BestCost,BestProfit]));
      add('Keep checking for better paths');
      add('');
    end;
  end
  {Otherwise descend down the child branches. First
   try including this item making sure it fits within
   the cost bound. }
  else
  begin
    if (TestCost + Items[item_num].Cost <= AllowedCost) then
    begin
      {Add the item to the test solution.}
      Inc(PathsChecked);
      TestSolution[item_num] := True;
      with items[item_num] do
      begin
        TestCost := TestCost + Cost;
        TestProfit := TestProfit + Profit;
        UnassignedProfit := UnassignedProfit - Profit;
        If showstepsbox.Checked and (PathsChecked<50) then
        with memo1.lines do
        begin
          add(Format('Item %d fits, add it to knapsack.',[item_num]));
          s:='';
          for i := 1 to NumItems do if testsolution[i] then s:=s + format('%d,',[i]);
          system.delete(s,length(s),1);
          add(format('--New solution is %s',[s]));
          add(format('--New Cost: %d,  New Profit: %d, Unassigned Profit: %d ',
            [testcost, testprofit, unassignedProfit]));
          add('');
        end;
      end;

      {Recursively see what the result might be.}
      BranchAndBound(item_num + 1);

      {Remove the item from the test solution.}
      TestSolution[item_num] := False;
      with items[item_num] do
      begin
        TestCost := TestCost - Cost;
        TestProfit := TestProfit - Profit;
        UnassignedProfit := UnassignedProfit + Items[item_num].Profit;
        If showstepsbox.Checked and (PathsChecked<50) then
        with memo1.Lines do
        begin
          add(Format('Remove Item # %d from trial solution',[item_num,Unassignedprofit]));
          s:='';
          for i := 1 to NumItems do if testsolution[i] then s:=s + format('%d,',[i]);
          system.delete(s,length(s),1);
          add(format('--Trial solution is %s',[s]));
          add(format('--Trail Cost: %d,  Trial Profit: %d, Unassigned Profit: %d ',
            [testcost, testprofit, unassignedProfit]));
          add('');
        end;
      end;
    end
    else
    begin
      If showstepsbox.Checked and (PathsChecked<50)
      then with memo1.lines do
      begin
        add(format('Adding item %d would exceed allowed cost',[item_num]));
        add('');
      end;
    end;
    {
     Try excluding the item. See if the remaining items
     have enough profit to make a path down this branch
     reach our lower bound.}
    UnassignedProfit := UnassignedProfit - Items[item_num].Profit;

    if (TestProfit + UnassignedProfit > BestProfit) then BranchAndBound(item_num + 1)
    else
    If showstepsbox.Checked and (PathsChecked<50) then
    with memo1.lines do
    begin
      add(Format('Excluding item %d resticts the best possible profit to %d',[item_num,testprofit+unassignedprofit]));
      Add(format('Current best profit is %d so stop searching path through #%d ',[bestProfit, item_num]));
      add('');
    end;
    UnassignedProfit := UnassignedProfit + Items[item_num].Profit;
  end;
  If showstepsbox.Checked then
  with memo1 do
  begin  {scroll back to top}
    selstart:=0;
    sellength:=0;
  end;
end;

{*************** ExhaustiveSearch *********8888}
procedure TBandBForm.ExhaustiveSearch(item_num : Integer);
{Exhaustively search the tree for the best solution
   starting with this item.}
Var
  i : Integer;
begin
  If (PathsChecked and $FFFF) =0
  then application.processmessages;
  if tag<>0 then exit;

  if (item_num > NumItems) then
  begin
    {We have processed a leaf node, evaluate our success.}
    if ((TestCost <= AllowedCost) and
        (TestProfit > BestProfit)) then
    begin
      for i := 1 to NumItems do BestSolution[i] := TestSolution[i];
      BestProfit := TestProfit;
      BestCost := TestCost;
    end;
  end
  else
  begin
    Inc(PathsChecked);
    { Try including this item. }
    TestSolution[item_num] := True;
    TestCost := TestCost + Items[item_num].Cost;
    TestProfit := TestProfit + Items[item_num].Profit;
    ExhaustiveSearch(item_num + 1);

    { Try excluding the item.  }
    TestSolution[item_num] := False;
    TestCost := TestCost - Items[item_num].Cost;
    TestProfit := TestProfit - Items[item_num].Profit;
    if item_num<numitems then  ExhaustiveSearch(item_num + 1)
  end;
end;


{************ NumItemsUDChangingEx *************}
{Update grid when UpDown position changes}
procedure TBandBForm.NumItemsUDChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
var
  i:integer;
begin
  with itemsgrid do
  begin
    rowcount:=newvalue+1;
    allowchange:=true;
    for i:=1 to newvalue do
    begin
      cells[0,i]:=inttostr(i);
      cells[1,i]:='0';
      cells[2,i]:='0';
    end;
    {Initialize the Item and solution arrays.}
    NumItems := NumItemsUD.position;
    {add one extra entry for dynamic array since existing code starts from 1}
    Setlength(Items, (NumItems+1) * SizeOf(TItem));
    setlength(TestSolution, (NumItems+1) * SizeOf(Boolean));
    setlength(BestSolution, (NumItems+1) * SizeOf(Boolean));
    RandomBtnClick(sender);
  end;
end;

{*************** NumItemsTextChange *************}
procedure TBandBForm.NumItemsTextChange(Sender: TObject);
{Update UpDown position when  user types in the associated Tedit}
var
  r:integer;
begin
  If numitemstext.text='' then numitemstext.text:='0'
  else
  begin
    r:=strtointdef(numitemsText.text,0);
    if r >0 then NumITemsUD.position:=r;
  end;
end;

procedure TBandBForm.Button1Click(Sender: TObject);
var
  i:integer;
  f:Textfile;
begin
  with savedialog1 do
  begin
    filename:=opendialog1.filename;
    If execute then
    begin
      assignfile(f,filename);
      rewrite(f);
      Write(f,Numitems,' ',Allowedcost);
      writeln(f);
      for i:=1 to numitems do with items[i] do
      begin
        write(f,cost,' ',profit);
        writeln(f);;
      end;
    end;
    closefile(f);
  end;
end;

procedure TBandBForm.Button2Click(Sender: TObject);
var
  i:integer;
  f:Textfile;
begin
  with opendialog1 do
  begin
    If execute then
    begin
      assignfile(f,filename);
      reset(f);
      read(f,Numitems, Allowedcost);
      readln(f);
      numitemsUD.Position:=numitems;
      AllowedCostUD.position:=Allowedcost;
      resetlabels;
      itemsgrid.rowcount:=NumItems+1;
     {add one extra entry for dynamic array since existing code starts from 1}
      Setlength(Items, (NumItems+1) * SizeOf(TItem));
      setlength(TestSolution, (NumItems+1) * SizeOf(Boolean));
      setlength(BestSolution, (NumItems+1) * SizeOf(Boolean));

      with itemsgrid do
      for i:=1 to numitems do with items[i] do
      begin
        read(f,cost, profit);
        readln(f);
        cells[1,i]:=Format('%6d', [Cost]);
        cells[2,i]:=Format('%6d', [Profit]);
      end;
    end;
    closefile(f);
  end;
end;

procedure TBandBForm.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
