unit U_SetpartitionTest;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A test program for the TPartitionClass class}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, shellAPI;

type
  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    GenBtn: TButton;
    ListLbl: TLabel;
    Memo1: TMemo;
    NbrSpin: TSpinEdit;
    Label2: TLabel;
    Button1: TButton;
    StaticText1: TStaticText;
    procedure GenBtnClickClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RG:array of integer;
    {Bigset:array of string;}
    partition:array of array of string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses uSetPartition;

{********************** GenBtnClick *********}
procedure TForm1.GenBtnClickClick(Sender: TObject);
{Generate sub set partitions}
var  i,j:integer;
     N:integer;  {size of set}
     s:string;
     count:integer;
     P:TPartition; {a doubly dimensioned array of set members for each subset}
begin
  listbox1.clear;
  count:=0;
  N:=spinedit1.value; {the setsize}

  with   defpartition do {the default pre-created partition class instance}
  begin
    partitioninit(N); {initialize it}
    listbox1.items.add {display the count}
            (format('Nbr of partitions= %.0n',[defpartition.partitioncount+0.0]));
    while (getnextpartition(P)) and (count<nbrspin.value) do
    begin {got a partition in NXN array P}
      s:='{';
      for i:=0 to N-1 do {for each subset}
      begin
        for j:=0 to N-1 do {for each element of this subset}
        begin {build the entry to display lower case letters as set members}
          if p[i,j]>=0 then s:=s+char(ord('a')+p[i,j])+','
          else break;
        end;
        {fix up some punctuation}
        if s[length(s)]=',' then s[length(s)]:='}';
        if s[length(s)]='}' then   s:=s+',{';
      end;
      if s[length(s)]='{' then delete(s,length(s)-1,2);
      inc(count);
      listbox1.items.add(s); {display the subset}
    end;
  end;

end;

{*************** SpinEdit1Change ************}
procedure TForm1.SpinEdit1Change(Sender: TObject);
{New set size - change the label}
begin
  listlbl.caption:='Set partitions for set size '+inttostr(spinedit1.value);
end;

{************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  spinedit1change(sender);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,N:integer;
  funcstr:string;
begin
  listbox1.clear;
  listbox1.items.add('Stirling numbers of the second kind');
  N:=spinedit1.value;
  defpartition.partitioninit(N);
  for i:= 1 to N do
  with listbox1 do
      items.add(format('S2(%d,%d)=%.0n',
               [N,i,0.0+defpartition.stirling2(N,i)]));


end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

end.
