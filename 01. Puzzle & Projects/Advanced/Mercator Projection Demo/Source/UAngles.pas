unit UAngles;



interface

Uses Sysutils, Dialogs;

{*************************************************}
{*          Angle Conversion Routines            *}
{*************************************************}


function deg2rad(deg:extended):extended; {Degrees to Radians}

function rad2deg(rad:extended):extended; {radians to degrees}

function StrtoAngle(const s:string; var angle:extended):boolean;
{Convert string representation of an angle to a numeric value}

 function AngleToStr(angle:extended):string; {make string representation  of an angle}


function GetLongToMercProjection(const long:extended):extended;

function GetLatToMercProjection(const Lat:Extended):Extended;

function GetMercProjectionToLong(const ProjLong:extended):extended;

function GetMercProjectionToLat(const ProjLat:extended):extended;


var
  {angle string delimiters}
  angledelims:set of char=[' ',chr(176){degree symbol}, chr(180){minutmark},
                           ',',':','"',''''];

implementation

Uses math;


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
 var
   n,fn, sign:integer;
   w,ds,ms,ss:string;
   dv,mv,sv:extended;
 begin
   ds:='0';
   ms:='0';
   ss:='0.0';
   w:=trim(s);  {add a stopper}
   sign:=+1;  {default sign}
   n:=0;
   if w='' then
   begin
     result:=false;
     exit;
   end;
   if upcase(w[1]) in ['N','S','E','W','-'] then n:=1
   else if upcase(w[length(w)]) in ['N','S','E','W','-'] then n:=length(w);
   if n>0 then
   begin
     if  (upcase(w[n]) in ['W','S','-']) then sign:=-1;
     delete(w,n,1);
     w:=trimLeft(w);
   end;
   n:=0;
   fn:=0;
   w:=w+','; {add a "stopper"}
   while n<length(w) do
   begin
     inc(n);
     if (fn=0) and (w[n] in angledelims)
     then
     begin
       ds:=copy(w,1,n-1);
       delete(w,1,n);
       n:=0;
       while (length(w)>0) and (w[1] in angledelims {[' ',deg,minmark,',',':','"']})
       do delete(w,1,1);
       inc(fn);
     end
     else if  w[n] in angledelims {[' ',minmark,',','''',':']} then
     begin
       if fn=1 then ms:=copy(w,1,n-1)
       else if fn=2 then ss:=copy(w,1,n-1);
       delete(w,1,n);
       n:=0;
       while (length(w)>0) and (w[1] in angledelims {[' ',minmark,',','''',':']})
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
 function AngleToStr(angle:extended):string;
 {make string representation  of an angle}
       var
         D:integer;
         M,S:extended;
       begin
         d:=Trunc(angle);
         m:=abs(frac(angle)*60);
         s:=frac(M)*60;
         m:=int(M);
         if s>=59.99 then
         begin
           s:=0;
           m:=m+1;
         end;
         if (angle<0) and (d=0) then
         (*
         result:=format('-%3d° %2d´ %2.0f´´',[d,trunc(m),s])
         else result:=format('%3d° %2d´ %2.0f´´',[d,trunc(m),s]);
         *)
         {simpler formating for now }
         result:=     format('-%3d %2d %2.0f ',[d,trunc(m),s])
         else result:=format(' %3d %2d %2.0f ',[d,trunc(m),s]);

       end;

function GetLongToMercProjection(const long:extended):extended;
    begin
      result:=long;
    end;

function GetLatToMercProjection(const Lat:Extended):Extended;
  begin
    result:=rad2deg(ln(abs(tan(deg2rad(lat))+1/cos(deg2rad(Lat)))));
  end;

function GetMercProjectionToLong(const ProjLong:extended):extended;
  begin
    result:=Projlong;
  end;

function GetMercProjectionToLat(const ProjLat:extended):extended;
  begin
    result:=rad2deg(arctan(sinh(deg2rad(ProjLat))));
  end;


end.
