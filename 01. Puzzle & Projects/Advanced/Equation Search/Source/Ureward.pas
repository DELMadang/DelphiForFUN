unit Ureward;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MPlayer, ExtCtrls, Buttons, Jpeg;

type
  Trewarddlg = class(TForm)
    Memo1: TMemo;
    MediaPlayer1: TMediaPlayer;
    BitBtn1: TBitBtn;
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RewardWavList,RewardPicList:TStringList;
  end;

var
  rewarddlg: Trewarddlg;

implementation

  {Uses Upicture;}

{$R *.DFM}

procedure Trewarddlg.FormActivate(Sender: TObject);
begin
  visible:=false;
  with mediaplayer1 do
  Begin
    If (RewardWavList.count>0) then
    Begin
      filename:=RewardWavList[trunc(random(RewardWavList.count))];
      open;
      play;
    end;
  end;
  If RewardPicList.count>0 then
  Begin
    Image1.picture.loadfromfile(RewardPicList[trunc(random(RewardPicList.count))]);
    Image1.visible:=true;
    memo1.visible:=false;
  end
  else
  Begin
    image1.visible:=false;
    memo1.visible:=true;
  end;
  visible:=true;
end;

procedure Trewarddlg.FormCreate(Sender: TObject);

   procedure Loadlist(filemask:string; List:TstringList);
   var
     s:string;
     sr:TSearchRec;
   begin
     List.clear;
     s:=extractfilepath(application.exename)+filemask;
     if FindFirst(s, faAnyFile, sr) = 0 then
     repeat
        list.add(sr.Name);
     until FindNext(sr) <> 0;
     FindClose(sr);
   end;


begin
   RewardWavlist:=TStringList.create;
   Loadlist('*.wav', RewardWavList);
   RewardPicList:=TStringlist.create;
   LoadList('*.jpg', RewardPicList);
end;

end.
