unit U_MakeCityLocations2;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{free-zipcode-database-abbreviated.csv  contains 1st five fields from
 http://federalgovernmentzipcodes.us/}

 {Program adds latitude and logitude data from a government zip code file to
 city/state reords input by the user.  Multiple sets of coordinates for the
 same city are averaged in the output file. }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Inifiles, ComCtrls;

type
  (*
  TZipObj=class(TCitObj)
    zip,stateID,City:string;
    Lat, Long:extended;
    constructor create;
  end;
 *)

 
  TCityObj=class(TObject)
    stateID,City:string;
    Lat, Long:extended;
    constructor create;
  end;

TZipObj=class(TCityObj)
    zip:string;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    InListBox: TListBox;
    CityLocListBox: TListBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Memo2Click(Sender: TObject);
    procedure CityLocListBoxClick(Sender: TObject);
    procedure InListBoxClick(Sender: TObject);
  public
    ziplist:TStringlist;
    worklist:TStringlist;
    function validZiprec(s:string; var z:TZipobj):boolean;
    function validCityrec(s:string; var z:TCityobj):boolean;
    procedure AddToCityList(cityobj:TCityobj);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



constructor TCityObj.create;
begin
  inherited;
  lat:=0;
  long:=0;
end;

(*
constructor TZipObj.create;
begin
  inherited;
  lat:=0;
  long:=0;
end;
*)
{*************** FormActivate *****************}
procedure TForm1.FormActivate(Sender: TObject);
var
  i,k:integer;
  ini:TInifile;
  inputfile:string;
  f:textfile;
  key:string;
  list:TStringlist;
  line:string;
  zipobj, sumobj:TZipobj;
  prevkey:string;
  pct:integer;
begin
  Ini := TIniFile.Create(extractfilepath(application.exename)+'MakeCityLocation.INI' );
  list:=TStringlist.create;
  list.Sorted:=true;
  list.duplicates:=dupAccept;
  ziplist:=TStringlist.create;

  worklist:=TStringlist.Create;
  try
    inputfile:=ini.readstring('Files','InFile','free-zipcode-database-abbreviated.csv');
    if not fileexists(inputfile) then
    begin
      opendialog1.Title:='Select Zipcode Database file';
      if opendialog1.execute
      then inputfile:=opendialog1.filename;
    end;
    if fileexists(inputfile) then
    begin
      Panel2.bringtofront;
      panel2.Visible:=true;
      ini.writestring('Files', 'InFile', inputfile);
      assignfile(f,inputfile);
      reset(f);
      progressbar1.Max:=100;
      application.processmessages;
      while not eof(f) do
      begin
        readln(f,line);
        zipobj:=TZipObj.create;
        if validZipRec(line,zipobj) then
        begin
          with zipobj do
          key:=format('%-32s%2s',[city,stateId]);
          list.addobject(key,zipobj);
        end;
      end;
      sumobj:=nil;
      prevkey:='';
      k:=0;
      for i:=0 to list.count do
      begin
        if i<list.count then
        begin
          key:=list[i];
          zipobj:=TZipobj(list.objects[i]);
        end
        else
        begin
          key:=stringofchar('Z',34);  {stopper}
        end;
        if (key <> prevkey)  then
        with sumobj do
        begin {1st time or when city changes}
          if k>0 then
          begin
            {save average lat and long value for zips in this city}
            lat:=lat/k;
            long:=long/k;
            ziplist.Addobject(prevkey,sumobj);
            InListBox.items.addobject(format('%s, %2s (%6.3f,%6.3f)',
                    [trim(copy(prevkey,1,32)), copy(prevkey,33,2),lat,long]),sumobj);
            k:=0;
          end;
          sumobj:=TZipobj.create;
          sumobj.city:=zipobj.city;
          sumobj.stateid:=zipobj.stateid;
          prevkey:=key;
        end;
        pct:=(100*i) div list.count;
        with progressbar1 do if pct>Position then stepby(pct-position);
        if   (sumobj<>nil) and (i<list.count) then {don't [process the last "stopper" pass }
        begin
          {Whether we wrote the prevkey record or not, accumulate lat and long sum for current key}
          sumobj.lat:=sumobj.lat+zipobj.lat;
          sumobj.long:=sumobj.long+zipobj.long;
          inc(k);
        end;
      end;
    end;
  finally
    Ini.Free;
    label2.caption:=format('Zip code list contains %d cities.',[inlistbox.items.count]);
    list.free;
    panel2.visible:=false;
  end;
end;

{************ ValidZiprec **********}
function TForm1.validZiprec(s:string; var z:TZipobj):boolean;
{Validate a zip code record and return TZipobj with data if it is OK}
var
  w:string;
  x,y:extended;
  errcode,count:integer;
  i:integer;
begin
  result:=false;
  worklist.clear;
  count:=ExtractStrings([','],[' ',#9],pchar(s),worklist);
  if count<7 then exit;

  for i:=0 to worklist.count-1 do
  begin {remove double quotes if they are present}
    w:=worklist[i];
    if w[1]='"' then delete(w,1,1);
    If w[length(w)]='"' then delete (w,length(w),1);
    worklist[i]:=w;
  end;
  {only keep zip code records flagged as "Standard"}
  if worklist[6]='STANDARD' then
  begin
    if (length({city}worklist[3])=0) or ({stateId}length(worklist[4])=0) then exit;
    val(worklist[1], y,errcode);
    if errcode=0 then val(worklist[2],x,errcode);
    if errcode<> 0 then exit;
    with z do
    begin
      zip:=worklist[0];
      city:=worklist[3];
      stateID:=worklist[4];
      lat:=y;
      long:=x;
      result:=true;
    end;
  end;
end;

{************ ValidCityrec **********}
function TForm1.validCityrec(s:string; var z:TCityobj):boolean;
{Validate the city and stateid fields from input city records}
var
  w:string;
  count:integer;
  i:integer;
begin
  result:=false;
  worklist.clear;
  count:=ExtractStrings([','],[' ',#9],pchar(s),worklist);
  if count<2 then exit;

  for i:=0 to worklist.count-1 do
  begin  {remove double quotes if present}
    w:=worklist[i];
    if w[1]='"' then delete(w,1,1);
    If w[length(w)]='"' then delete (w,length(w),1);
    worklist[i]:=w;
  end;
  with z do
  begin
    city:=worklist[0];
    stateID:=worklist[1];
    result:=true;
  end;
end;

{*************** Memo1Click *************}
procedure TForm1.Memo1Click(Sender: TObject);
{A Tmemo "button" to load a file of city names and state Ids to have lat,long added}
var
  ini:TInifile;
  index:integer;
  cityfile:string;
  f2:textfile;
  line:string;
  key:string;
  cityobj:TCityobj;
begin
  Ini := TIniFile.Create(extractfilepath(application.exename)+'MakeCityLocation.INI' );
  worklist:=TStringlist.Create;
  try
    cityfile:=ini.readstring('Files','InCityFile','CityList.txt');
    begin
      opendialog1.FileName:=cityfile;
      Opendialog1.Title:='Select a file of city/state-id records to have coordinates added';
      if opendialog1.execute then  cityfile:=opendialog1.filename;
    end;
    if fileexists(cityfile) then
    begin
      ini.writestring('Files', 'CityFile', Cityfile);
      assignfile(f2,Cityfile);
      reset(f2);
      while not eof(f2) do
      begin
        readln(f2,line);
        line:=trim(line);
        cityobj:=TCityObj.create;
        if validcityRec(line,cityobj) then
        begin
          with cityobj do
          begin
            key:=format('%-32s%2s',[city,stateId]);
            if ziplist.find(key,index) then
            with TZipObj(ziplist.objects[index]) do
            begin
              cityobj.lat:=lat;
              cityobj.long:=long;
            end;
            addtocitylist(cityobj);
          end;
        end;
      end;
      closefile(f2);
    end;
  finally
  end;
  ini.Free;
end;

{*********** AddToCityList ***********}
procedure TForm1.addtocitylist(cityobj:TCityobj);
var key:string;
begin
  with cityobj do
  key:=format('%s %2s Lat:%7.3f, Long:%7.3f',[city,stateId, lat, long]);
  CityLocListbox.items.addobject(key,cityobj);
end;

{************* SaveCityFileClick ****************}
procedure TForm1.Memo2Click(Sender: TObject);
var
  i:integer;
  f2:Textfile;
  line:string;
begin
  savedialog1.initialdir:=extractfilepath(opendialog1.filename);
  Savedialog1.FileName:=opendialog1.FileName;
  if savedialog1.Execute then
  begin
    assignfile(f2,savedialog1.FileName);
    rewrite(f2);
    with CityLocListbox.Items do
    for i:=0 to count-1 do
    with TCityobj(objects[i]) do
    begin
      line:=format('%s,%2s,%7.3f,%7.3f',[city,stateId,lat,long]);
      writeln(f2,line);
    end;
    closefile(f2);
  end;
end;

{************* InListBoxDblCLick **************}
procedure TForm1.InListBoxClick(Sender: TObject);

  procedure fillcity(c:TCityObj; z:TZipObj);
    begin
      c.city:=z.city;
      c.stateid:=z.stateid;
      c.lat:=z.lat;
      c.long:=z.long;
    end;
var
  c:TCityobj;
  z:TZipObj;
  i:integer;
  found:boolean;
begin
  With InListBox do
  begin
    z:=TZipObj(items.objects[itemindex]);
    {scan city list box to see if this city already exists}
    with cityloclistbox do
    begin
      found:=false;
      for i:=0 to items.count-1 do
      begin
        c:=TCityobj(items.Objects[i]);
        if (c.city=z.city) and (c.stateid=z.stateID) then
        begin
          fillcity(c,z);
          found:=true;
          break;
        end;
      end;
      if not found then {new entry}
      begin
        c:=TCityobj.create;
        fillcity(c,z);
        addtocitylist(c);
      end;
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.CityLocListBoxClick(Sender: TObject);
begin
  with cityloclistbox do
  with TCityobj(items.objects[itemindex]) do
  if messagedlg(format('Delete %s %s?',[city,stateId]),
                mtconfirmation,[mbyes, mbno],0)=mryes
  then items.Delete(itemindex);
end;

end.
