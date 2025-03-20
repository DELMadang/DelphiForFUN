program ChickenCrossing;
{$APPTYPE CONSOLE}
{Time to code and test 1 hour, 6 minutes}
{bugs fixed:
  1. Error 104 - forgot reset(f);
  2. Hang - forgot f in readln(f,width,length,  etc. statement
  3. Incorrect output - toca and tocd multiplied by chickenspeed instead of divide
  4. Incorrect output - tod field incorrect, same error,  multiply by speed
                        instead of divide
  5. Incorrect output - forgot to add start time (i+ ...) in toca, tocd calc
  6. Incorrect output - read variables in wrong order readln(f, length, width...);
                         instead of readln(f,width length...);
                         
}

uses
  SysUtils;

{Problem Description

Why did the chicken cross the road? Well, that is not our concern. We only seek
to make sure that it gets across safely.

The chicken will cross several roads (anything from Farm-to-Market roads to interstate
highways including access roads). For each road to cross, the chicken looks
to see how many lanes there are to cross and what traffic there is on each lane.
The chicken then starts waiting for traffic to clear so it can cross safely. In order to
maintain the timing between steps and his head-bobbing, the chicken will only start
walking on 1 second intervals. However, this chicken is particularly impatient and
will start walking whether it is safe or not after waiting only 60 seconds and it
may be time to break out the barbeque sauce.

When the chicken does cross the road, it will start walking on a path perpendicular
to the lanes (all lanes are parallel) at a constant rate of 10 feet/second and will not
stop until reaching the other side. All lanes are 15 feet wide and there is no room
between the lanes. Each vehicle description includes a width in feet of the vehicle
(0<W<=15 feet), the length of the vehicle (0<L<=40 feet), a constant speed of the
vehicle in feet/second (0<S<=100 feet/second), and the time (in seconds) which
the vehicle will cross the line which the chicken will attempt to walk along.
Second zero is the first opportunity for the chicken to start across the road. Vehicles
always drive down the exact center of the lane they occupy (no drunk drivers here!).

Information for each crossing will be formatted in the input file as follows.
The first line for each crossing will contain the number of lanes (1<=L<=20) to be crossed
(direction does not matter here). The second line contains the number of vehicles
(0<=N<=100) involved in the crossing. Each of the subsequent N lines contains the
description of the vehicles in no particular order. The first value of the line
is an integer which identifies the lane number (1 to L) the vehicle occupies
(lane 1 is closest to the chicken). The second through fifth values are floating
point numbers which identify the width, length and speed of the vehicle and the
time (in seconds) that the vehicle will cross the line the chicken will walk
along. You must read to the end-of-file.

You may assume that there are no lane changes; collisions between vehicles are
irrelevant; and sufficient safety margin has been included in the dimensions of the
vehicle to treat the chicken as a single point. It is time to get the barbeque
sauce if at any time any part of the vehicle and the single point of the chicken intersect.

For each road to cross, you must output the crossing number (start counting at
one) and an integer representing the earliest second (0 to 60) the chicken should start
to cross such that it can cross safely. If the chicken cannot cross safely, you
must print the message "Bar-B-Q time!" instead of the crossing start time. Your output
should be formatted similar to that in the examples below.

Sample Input:
2
8
2       5.0     6.3     12.0    47.7
1       14.5    39.6    66.0    29.3
2       14.8    40.0    9.0     4.8
1       11.1    40.0    100.0   24.3
1       9.0     14.2    83.6    2.1
1       9.0     15.0    88.0    1.1
2       12.6    29.9    80.67   19.25
1       3.0     6.0     40.0    10.6
6
1
4       15.0    40.0    0.1     4.4
6
1
2       15.0    40.0    0.1     4.4

Sample Output:

Crossing 1 should start at 8.
Crossing 2 Bar-B-Q time!
Crossing 3 should start at 0.
}

type
  TTruck=class
    length,width,speed,toa,tod:single;
    lane:integer;
  end;

var
  chickspeed:integer=10;
  lanewidth:integer=15;
  f:text;
  i:integer;
  nbrlanes:integer;
  nbrtrucks:integer;
  trucks:array[1..100] of TTruck;
  casenbr:integer=0;

procedure computeanswer;
var
  i,j:integer;
  toca,tocd:single;  {time of chicked arrival & departure from a truck wide space}
  ok1,ok2,solved:boolean;
begin
  solved:=false;
  for i:= 0 to 60 do
  begin
    ok2:=true;
    for j:=1 to nbrtrucks do
    with trucks[j] do
    begin
      ok1:=false;
      toca:=i+((lane-1)*lanewidth+lanewidth/2-width/2)/chickspeed;
      tocd:=i+((lane-1)*lanewidth+lanewidth/2+width/2)/chickspeed;
      if tocd<toa then OK1 :=true;
      If toca>tod then OK1 :=true;
      if not OK1 then
      begin
        ok2:=false;
        break;
      end;
    end;
    if ok2 then {solution found}
    begin
      writeln('Crossing '+inttostr(casenbr)+' should start at '+inttostr(i));
      solved:=true;
      break;
    end;
  end;
  if not solved then writeln('Crossing '+inttostr(casenbr)+' Bar-B-Q time!');
end;



begin
  assignfile(f,'Data.txt');
  reset(f);
  while not eof(f) do
  begin
    readln(f,nbrlanes);
    readln(f,nbrtrucks);
    for i:= 1 to nbrtrucks do
    begin
      trucks[i]:=TTRuck.create;
      with trucks[i] do
      begin
        readln(f,lane,width,length,speed,toa);
        tod:=toa+length/speed;
      end;
    end;
    inc(casenbr);
    computeanswer;
  end;
readln;
end.
