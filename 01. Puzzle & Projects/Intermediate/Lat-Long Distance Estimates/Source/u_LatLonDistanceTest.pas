Unit u_LatLonDistanceTest;
 {Copyright  © 2004, 2008, 2017 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Estimate distance between two points on the earth's surface defined
by Latitude and Longitude.  Two methods implemented, spherical earth assumption
and estimate considering elliptical earth}

{Version 2 adds T. Vincenty's algorithm and equations for very accurate distance
 calculations and to calculate an end point given a starting point and
 direction/distance info.  The Vincenty equations were implemented
 using the notations used in the "Geocentric Datum of Australia Technical Manual"
 located at www.icsm.gov.au/gda/gdatm/gdav2.3.pdf.   Vic Fraenckel's Geocalc
 program downloadabke from www.windreader.com/geodesy/ was used verify results.}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, shellapi, Buttons, ComCtrls, LatLonDist;

type
  TCharSet=set of char;
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Loc1Lat: TEdit;
    Memo1: TMemo;
    UnitsGrp: TRadioGroup;
    SphereBtn: TButton;
    Loc1Lon: TEdit;
    Loc2lat: TEdit;
    Loc2Lon: TEdit;
    EllispeBtn: TBitBtn;
    VInverseBtn: TButton;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    VDLat1: TEdit;
    VDUnits: TRadioGroup;
    VDLon1: TEdit;
    VDirectBtn: TButton;
    Label15: TLabel;
    Az12edt: TEdit;
    Label16: TLabel;
    Distedt: TEdit;
    StaticText1: TStaticText;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    VDLat2: TEdit;
    VDLon2: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    VDAZFinal: TEdit;
    VDAZBack: TEdit;
    VIResults: TGroupBox;
    Panel1: TPanel;
    Label17: TLabel;
    B12I: TEdit;
    Label18: TLabel;
    B12F: TEdit;
    Label19: TLabel;
    B21I: TEdit;
    Label20: TLabel;
    VIDist: TEdit;
    Memo2: TMemo;
    NGISDirectBtn: TButton;
    StepsGrp: TRadioGroup;
    StepGrp: TGroupBox;
    Memo3: TMemo;
    Label21: TLabel;
    NavModeGrp: TRadioGroup;
    Button1: TButton;
    procedure SphereBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure EllispeBtnClick(Sender: TObject);
    procedure VInverseBtnClick(Sender: TObject);
    procedure VDirectBtnClick(Sender: TObject);
    procedure VDInputChange(Sender: TObject);
    procedure VIInputChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation
uses math, mathslib;


{$R *.DFM}

var deg:char=chr(176); {'°'}
    minmark:char=chr(180);
    ERAD:extended = 6378.135; {Earth's radius in km a equator}
    FLATTENING:extended = 1.0/298.257223563; {Fractional reduction of radius to poles}
    unitslbl:array[0..2] of string=('Miles','Kilometers','Nautical miles');
    {delimiter used in lat/long input}
    degdelim,minsecdelim,delDextra:TCharset;

(*
{********* Deg2rad ***********}
function deg2rad(deg:extended):extended;
{Degrees to Radians}
begin result:=deg * PI / 180.0; end;


{*********** Rad2Deg **********}
function rad2deg(rad:extended):extended;
{radians to degrees}
begin result:=rad / PI * 180.0;  end;



{**************** StrToAngle ************}
function StrtoAngle(const s:string; var angle:extended):boolean;
{Convert string representation of an angle to a numeric value}

           function convertfield(xs:string;var v:extended; msg:string):boolean;
           var errcode:integer;
           begin
             val(xs,v,errcode);
             if errcode<>0 then
             begin
               showmessage('Invalid character in '+msg+' field in string '+ s);
               result:=false;
             end
             else result:=true;
           end;

           procedure removecomma(var chars:Tcharset);
           begin
             chars:=chars-[','];
           end;


 var
   n,fn, sign:integer;
   w,ds,ms,ss:string;
   dv,mv,sv:extended;

 begin
   degdelim:=[' ',',',deg,':',';'];
   delDExtra:=[' ',deg,minmark,',',':','"',';'];
   minsecdelim:=[' ',minmark,',','''',':','"',';'];
   if decimalseparator=',' then
   begin
     removecomma(degdelim);
     removecomma(minsecdelim);
     removecomma(delDExtra);
   end;

   ds:='0';
   ms:='0';
   ss:='0.0';
   w:=trim(s);  {add a stopper}
   sign:=+1;  {default sign}
   n:=0;
   if upcase(w[1]) in ['N','S','E','W','-'] then n:=1
   else if upcase(w[length(w)]) in ['N','S','E','W','-'] then n:=length(w);
   if n>0 then
   begin  {check for negative value}
     if  (upcase(w[n]) in ['W','S','-']) then sign:=-1;
     delete(w,n,1); {delete the character}
   end;
   n:=0;
   fn:=0;
   w:=w+':'; {add a "stopper"}
   while n<length(w) do
   begin
     inc(n);
     if (fn=0) and (w[n] in degdelim)
     then
     begin
       ds:=copy(w,1,n-1); {the degree string}
       delete(w,1,n);
       n:=0;
       {drop any extra characters before the minutes value}
       while (length(w)>0) and (w[1] in DelDExtra)

       do delete(w,1,1);
       inc(fn); {to look for minutes next}
     end
     else if  w[n] in minsecdelim then
     begin
       if fn=1 then ms:=copy(w,1,n-1)
       else if fn=2 then ss:=copy(w,1,n-1);
       delete(w,1,n);
       n:=0;
       while (length(w)>0) and (w[1] in minsecdelim)
       do delete(w,1,1);
       inc(fn);
     end;
   end;
   result:=convertfield(ds,dv,'degrees');
   if result then result:=convertfield(ms,mv,'minutes');
   if result then result:=convertfield(ss,sv,'seconds');
   if result
   then angle:=sign*(dv+mv/60+sv/3600)
   else angle:=0;
 end;


{********* AngleToStr ************}
 function AngleToStr(angle:extended;decimals:integer):string;
 {make string representation  of an angle}
       var
         D:integer;
         F, M,S:extended;
         sign:integer;
       begin
         d:=Trunc(angle);
         If angle<0 then sign:=-1 else sign:=+1;
         F:=abs(frac(angle));
         If F > 0.9997222 then
         begin
           m:=0.0;
           d:=d+sign;
         end
         else  m:=F*60;

         s:=frac(M)*60;
         m:=int(M);
         if s>=59.99 then
         begin
           s:=0;
           m:=m+1;
         end;
         if (angle<0) and (d=0) then
         result:=format('-%3d° %2d´ %5.*f´´',[d,trunc(m),decimals,s])
         else result:=format('%3d° %2d´ %5.*f´´',[d,trunc(m),decimals,s]);
       end;
*)       

(*
{************* Distance ****************}
function distance(lat1,lon1,lat2,lon2:extended; Units:integer):extended;
{Distance between to points assuming spherical earth}
 var
   theta:extended;
 begin
   theta := lon1 - lon2;
   result:= Sin(deg2rad(lat1)) * Sin(deg2rad(lat2))
   + Cos(deg2rad(lat1)) * Cos(deg2rad(lat2)) * Cos(deg2rad(theta));
   result := rad2deg(Arccos(result))*60*1.1515; {miles per degree (24872 mile circumference)}
   if units=1 then result := result * 1.609344 {miles to kilometers}
   else if units=2 then result := result * 0.8684; {miles to nautical miles}
 end;
*)
 (*
{*************** ApproxEllipticalDistance ************}
function ApproxEllipticalDistance(llat1, llon1, llat2, llon2:extended; units:integer):extended;
var lat1,lat2,lon1,lon2:extended;
    f,g,l:extended;
    sing,cosl,cosf,sinl,sinf,cosg:extended;
    S,C,W,R,H1,H2,D:extended;
begin

   lat1 := DEg2RAd(llat1);
   lon1 := -DEg2RAd(llon1);
   lat2 := DEg2RAd(llat2);
   lon2 := -DEg2RAd(llon2);

   F := (lat1 + lat2) / 2.0;
   G := (lat1 - lat2) / 2.0;
   L := (lon1 - lon2) / 2.0;

   sing := sin(G);
   cosl := cos(L);
   cosf := cos(F);
   sinl := sin(L);
   sinf := sin(F);
   cosg := cos(G);

   S  := sing*sing*cosl*cosl + cosf*cosf*sinl*sinl;
   C  := cosg*cosg*cosl*cosl + sinf*sinf*sinl*sinl;
   W  := arctan2(sqrt(S),sqrt(C));
   R  := sqrt((S*C))/W;
   H1 := (3 * R - 1.0) / (2.0 * C);
   H2 := (3 * R + 1.0) / (2.0 * S);
   D  := 2 * W * ERAD;
   result:=(D * (1 + FLATTENING * H1 * sinf*sinf*cosg*cosg -
                 FLATTENING*H2*cosf*cosf*sing*sing))/1.609344;
   if units=1 then result := result * 1.609344 {miles back to kilometers}
   else if units=2 then result := result * 0.8684; {miles to nautical miles}
end;
*)

{****** SphereBtnClick ************}
procedure TForm1.SphereBtnClick(Sender: TObject);
var
  lat1,lon1,lat2,lon2,dist:extended;
begin
  if not strToAngle(Loc1Lat.text, lat1) then showmessage('Format error in Latitude #1')
  else if not strtoangle(Loc1Lon.text,lon1)then showmessage('Format error in Longitude #1')
    else if not strtoangle(Loc2lat.text,lat2)then showmessage('Format error in Latitude #2')
  else if not strtoangle(Loc2Lon.text,lon2) then showmessage('Format error in Longitude #2')
  else
  begin
    panel1.visible:=false;
    dist:=distance(lat1,lon1,lat2,lon2,unitsgrp.itemindex);
    vIdist.text:=format('%.1f %s',[dist,unitslbl[unitsgrp.itemindex]])
    (*
    resultslbl.caption:=format('From Lat %s Long %s to Lat %s, Long %s distance is %6.3f %s',
            [angletostr(lat1,2),angletostr(lon1,2),angletostr(lat2,2),
            angletostr(lon2,2),dist,unitslbl[unitsgrp.itemindex]]);
    *)

  end;

end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Button1Click(Sender: TObject);
  var
  lat1,lon1,lat2,lon2,azimuth, az2,dist:extended;
begin
  if not strToAngle(Loc1Lat.text, lat1) then showmessage('Format error in Latitude #1')
  else if not strtoangle(Loc1Lon.text,lon1)then showmessage('Format error in Longitude #1')
    else if not strtoangle(Loc2lat.text,lat2)then showmessage('Format error in Latitude #2')
  else if not strtoangle(Loc2Lon.text,lon2) then showmessage('Format error in Longitude #2')
  else
  begin
    panel1.Visible:=true;
    dist:=RhumbDistance(lat1,lon1,lat2,lon2,unitsgrp.itemindex, azimuth);

     vIdist.text:=format('%.1f %s',[dist,unitslbl[unitsgrp.itemindex]]) ;

      B12I.Text:=format('%.2f',[azimuth]);
      B12F.Text:=format('%.2f',[azimuth]);
      az2:=azimuth+180;
      if az2>360 then az2:=az2-360;
      B21I.Text:=format('%.2f',[azimuth+180]);

  end;
end;

procedure TForm1.EllispeBtnClick(Sender: TObject);
 {http://www.codeguru.com/Cpp/Cpp/algorithms/general/article.php/c5115/}
  var
  lat1,lon1,lat2,lon2,dist:extended;
begin
  if not strToAngle(Loc1Lat.text, lat1) then showmessage('Format error in Latitude #1')
  else if not strtoangle(Loc1Lon.text,lon1)then showmessage('Format error in Longitude #1')
    else if not strtoangle(Loc2lat.text,lat2)then showmessage('Format error in Latitude #2')
  else if not strtoangle(Loc2Lon.text,lon2) then showmessage('Format error in Longitude #2')
  else
  begin
    panel1.Visible:=false;
    dist:=ApproxEllipticalDistance(lat1,lon1,lat2,lon2,unitsgrp.itemindex);
    vIdist.text:=format('%.1f %s',[dist,unitslbl[unitsgrp.itemindex]])
    (*
    resultslbl.caption:=format('From Lat %s Long %s to Lat %s, Long %s distance is %6.3f %s',
            [angletostr(lat1,2),angletostr(lon1,2),angletostr(lat2,2),
            angletostr(lon2,2),dist,unitslbl[unitsgrp.itemindex]]);
    *)
  end;
end;


{********** VInverseBtn ************8}
procedure TForm1.VInverseBtnClick(Sender: TObject);
var
  lat1,lat2,Lon1,lon2:extended;
  dist,azimuth12,azimuth21,azimuthfinal:extended;
begin
  if not strToAngle(Loc1Lat.text, lat1) then showmessage('Format error in Latitude #1')
  else if not strtoangle(Loc1Lon.text,lon1)then showmessage('Format error in Longitude #1')
    else if not strtoangle(Loc2lat.text,lat2)then showmessage('Format error in Latitude #2')
  else if not strtoangle(Loc2Lon.text,lon2) then showmessage('Format error in Longitude #2')
  else
  begin
    panel1.visible:=true;
    dist:=VInverseDistance(lat1,lon1,lat2,lon2,
                Azimuth12, AzimuthFinal,unitsgrp.itemindex);
    azimuth21:=azimuthfinal+180;

      vIdist.text:=format('%.1f %s',[dist,unitslbl[unitsgrp.itemindex]]);
      B12I.Text:=format('%.1f',[azimuth12]);
      B12F.Text:=format('%.1f',[azimuthFinal]);
      B21I.Text:=format('%.1f',[azimuth21]);
    end;                                    end;


Procedure WikiDirect1(LAT1,LON1, Azimuth1, Dist:EXTENDED; VAR LAT2, LON2, azimuth2:EXTENDED);
var
  dlat1,dlat2,dLon1,dlon2,daz12:EXTENDED;
  f:extended;
  a,b,TanU1,U1,tanU2,U2, Usq:extended;
  L,Lambda:extended;
  count:integer;
  sigma,oldsigma,sinSigma,cosSigma,TanSigma:extended;
  sigma1, tansigma1:extended;
  cos2sigmam:extended;
  sinu1,cosu1, tanlat2,tanlambda:extended;
  sinAlpha, cosSqAlpha,C:extended;
  AA,BB:extended;
  dsigma,tanaz2:EXTENDED;

begin      {Vincenty's Direct equations and algorithm}
  {WGA84 paramaterss}
      a:=6378137.0;  {earth major axis meters}
      b:=6356752.314; {minor axis}
      f:=(a-b)/a; {flattening}
      TanU1:=(1-f)*tan(Lat1);
      U1:=arctan(Tanu1);
      //TanSigma1:=tanU1/cos(azimuth1);
      {or}
      Tansigma1:=tan(U1)/cos(azimuth1);
      sinU1:=sin(u1); {OK}
      cosu1:=cos(U1); {OK}
      sinalpha:=cosu1*sin(azimuth1);
      cosSqAlpha := 1.0 - sqr(sinalpha);
      usq:=sqr(cos(arcsin(sinalpha)))*(a*a-b*b)/(b*b);
      AA:=1+(usq/16384*(4096+usq*(-768+usq*(320-175*usq))));
      BB:=(usq/1024)*(256+usq*(-128+usq*(74-47*usq)));
      sigma1:=arctan(tansigma1);
      sigma:=dist/(b*AA);
      count:=0;
      repeat
        inc(count);
        Cos2Sigmam:=cos(2*sigma1+sigma);
        sinSigma:=sin(sigma);
        cossigma:=cos(sigma);
        dSigma:=BB*sinsigma*(cos2sigmam+BB/4*(cossigma*(2*sqr(cos2sigmam)-1)-
                BB/6*cos2Sigmam*(4*sqr(sinSigma)-3)*(4*sqr(cos2sigmam)-3)));
        oldsigma:=sigma;
        sigma:=dist/(b*AA)+dSigma;
      until (abs(sigma-oldsigma)<10e-14) or (count>100);
      if count>100 then showmessage('No convergence')
      else
      begin
        Lat2:=arctan2(sinU1*cosSigma+CosU1*sinsigma*cos(azimuth1),
         (1-f)*sqrt(sqr(sinalpha)+sqr(sinu1*sinsigma-cosU1*cossigma*cos(azimuth1) )) );
        TanLambda:=sinsigma*sin(azimuth1)/(cos(U1)*cossigma-sinU1*sinSigma*cos(azimuth1));
        Lambda:=arctan(Tanlambda);
        c:=(f/16)*cosSqAlpha*(4+f*(4-3*cosSqAlpha));
        L:=lambda-(1-C)*f*sinalpha*(sigma+C*sinsigma*(cos2sigmam+C*cossigma*(-1+2*sqr(cos2sigmam))));
        lon2:=Lon1+L;
        tanaz2:=sinalpha/(-sinU1*SinSigma+cosU1*cossigma*cos(azimuth1));
        azimuth2:=arctan(tanaz2);
      end;
    end;

(*
 Procedure Rhumb1(LAT1,LON1, Azimuth1, Dist:EXTENDED; VAR LAT2, LON2:EXTENDED);
 var
   sig, DLat, PDLat, q, DLon:extended;
 begin
   //showmessage('Not yet');
   sig:=Dist/(1000*ERad);
   DLat:=sig*cos(azimuth1);
   Lat2:=Lat1+DLat;
   PDLat:=ln( tan(Pi/4+Lat2/2)/tan(Pi/4+Lat1/2));
   if PDLat>1e-12 then Q:=DLat /PDLat else Q:=cos(lat1);
   DLon:=sig*sin(Azimuth1)/Q;
   Lon2:=Lon1+DLon;
 end;
*)

{**************** VDirectbtnClick *******}
procedure TForm1.VDirectBtnClick(Sender: TObject);
var
  dlat1,dlat2,dLon1,dlon2,az12:EXTENDED;
  lat1,lat2,Lon1,lon2:EXTENDED;
  dist,udist,azimuth1,azimuth2,azimuthfinal:EXTENDED;
  nbrsteps, step:integer;
  StepDistSize, StepDist:extended;
begin
  Udist:=strtofloatdef(distedt.text,-1);
  if not strToAngle(VDLat1.text, lat1) then showmessage('Format error in Latitude #1')
  else if not strtoangle(VDLon1.text,lon1)then showmessage('Format error in Longitude #1')
    else if not strtoangle(az12edt.text,azimuth1)then showmessage('Format error in Bearing')
    else if udist<0 then showmessage('Distance must be a valid number greater than 0')
  else
  begin
     //Now done in VDirectLarLon procedure
    //Lat1:=deg2rad(dlat1);  {angles to radians}
    //Lon1:=deg2rad(dlon1);
    //Azimuth1:=deg2rad(daz12);  {the bearing}

    StepGrp.sendtoback;
    (* {Buttom is hidden - no need for the code excpt for debugging}
    if sender = NGISDirectBtn then
    begin
      {Forward Vincenty version converted from NGIS forward.for}
      VDirectLatLon(LAT1,LON1,AZIMUTH1,Udist, VDUnits.itemindex, LAT2,LON2,AZIMUTH2);
      //dlat2:=rad2deg(lat2); {degree conversions noe in VDirectLatLon}
      //dlon2:=rad2deg(lon2);
      azimuthfinal:=azimuth2-180;
      while azimuth2<0 do azimuth2:=azimuth2+360;
      while azimuthfinal<0 do azimuthfinal:=azimuthfinal+360;
      vdLat2.text:=angletostr(lat2,2);
      vdlon2.text:=angletostr(lon2,2);
      vdazFinal.text:=format('%.2f',[azimuthfinal]);
      vdazBack.text:=format('%.2f',[azimuth2]);
    end
    else
    *)
    begin
      nbrsteps:=1;
      case stepsgrp.itemindex of
        0:nbrsteps:=1;
        1:nbrsteps:=2;
        2:nbrsteps:=10;
        3:nbrsteps:=100;
      end;
      StepDistSize:=Udist/nbrsteps;
      //azimuth2:=azimuth1;
      if nbrsteps>1 then
      begin
        StepGrp.BringToFront;
        memo3.Clear;
        If NavModeGrp.itemindex=0
        then label21.caption:= 'Great Circle Route steps: Dist, Lat, Long, Bearing'
        else label21.caption:= 'Rhumb Line Route: Dist, Lat, Long, Bearing';
      end;
      for step:=1 to nbrsteps do
      begin
        stepdist:=step*StepDistSize;
        If NavModeGrp.itemindex=0
        then
        begin
          VDIRECTLatLon(LAT1,LON1,AZIMUTH1,stepDIST, VDUnits.itemindex,
                        LAT2,LON2,AZIMUTH2); {Fotran version}
          azimuthfinal:=azimuth2-180;
        end
        else
        begin
          ApproxRhumbLatLon(LAT1,LON1,AZIMUTH1,stepdist, VdUnits.itemindex, LAT2,LON2);
          azimuth2:=azimuth1-180;
          azimuthfinal:=azimuth1; {Constant bearing case}
        end;

        if nbrsteps>1 then
        with memo3,Lines do
        begin
          dist:=stepdist;
          add(format('%1f, %.1f, %.1f, %.1f',
                      [dist, lat2, lon2, azimuthfinal]));
        end;
      end;

      vdLat2.text:=angletostr(lat2,1);
      vdlon2.text:=angletostr(lon2,1);

      while azimuth2<0 do azimuth2:=azimuth2+360;
      vdazFinal.text:=format('%.1f',[azimuthfinal]);
      vdazBack.text:=format('%.1f',[azimuth2]);
    end;
  end;
end;

{************ VDInputChange *********}
procedure TForm1.VDInputChange(Sender: TObject);
{Clear result fields when VDirect input fields change}
begin
  vdLat2.text:='';
  vdlon2.text:='';
  VDazBack.text:='';
  VDazFinal.text:=''
end;

{************ VIInputChange ***********}
procedure TForm1.VIInputChange(Sender: TObject);
{Clear result fields when VInverse input fields change}
begin
  VIDist.text:='';
  B12I.text:='';
  B12F.Text:='';
  B21I.Text:='';
end;


end.
