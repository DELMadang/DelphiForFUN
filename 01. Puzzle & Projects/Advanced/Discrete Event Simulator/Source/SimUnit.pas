unit SimUnit;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{The TSIM simulation class and supporting classes}

interface

Uses classes;
type
  TDistType=(Unknown,Exponential,Uniform,Constant{,Custom});
  TEventType=(Arrival,Departure, MaxWaitExceeded, StartProcess);
  TSelectionProtocol=(ClassFirst, TimeFirst);
var
  DistStrTypes:array[low(TDistType)..high(TDistType)]
     of string=('Unknown','Exponential','Uniform','Constant'{,'Custom'});

  EventStrings:array[low(TeventType)..high(TEventType)]
           of string=('Arrival','Departure','MaxWaitExceeded','StartProcess');

  ProtocolStr:array[low(Tselectionprotocol)..high(TSelectionProtocol)]
          of string = ('Class first', 'Time first');
type
  TDistFunc=Function (v1,v2:real):real; {Given a mean interarrival time and.
                                         possibly, a second parameter,
                                         returns next arrival}



  TQueueType=(Priority, Time);   {for future expansion to include job priority}



  TCustQueueObj=class;  {forward declaration}

  TCallbackproc= procedure (Cust:TCustQueueObj) of object;

  TCustomerClass=class(TObject)  {define a job class}
    JobClassName:String;
    CustIdChar:char;  {Unique class letter}
    {Priority:Integer;} {add this later}
    NextCustNbr:integer;
    QDist:TDistType; {Class arrival distribution types}
    Qv1,Qv2:real; {Class Arrival distribution parameters}

    MaxWaitBeforeLeaving:real;  {wait time limt before "giving up"}

    NextArrivalTime:TDistFunc; {function which calculates next arrival time}

    {statistics}
    ArrivalCount,DepartureCount:integer;
    TotWait,TotProcess:real;
    MinWait,maxWait,Minprocess,Maxprocess:real;

    JobProfit:real;
    GiveUpCost:real;
    WaitCostRate:real;

    Constructor Create(newtype:char;newname:string;
                       newQDist:TDisttype;
                       NewQv1,NewQv2, NewMaxWait,
                       newjobprofit,newwaitcostrate, newgiveupcost:real);
    Function makenextCustomer(Ctime:real):TCustQueueObj; {generate a customer}
  end;

  TProcess = class(TObject)  {processing characteristics for a class}
    CustClassID:char;
    PDist:TDistType; {process distribution types}
    PV1,PV2:real; {process distribution parameters}
    Costrate:real;
    NextProcessingTime:TDistFunc;
  end;

  {Server class}
  TServer = class(TObject)
    ServerNbr:Integer;
    servername:string;
    SelectionProtocol:TSelectionProtocol;
    CustomerTypes:TStringList; {List of Classes & classinfo processed by this server}
    DefaultCostrate:real; {costrate may be assigned for each jobclass}
    Busy:boolean;
    JobsProcessed:integer;
    BusyTime:real;
    Constructor Create(NewServernbr:integer; newservername:string);
    Procedure AddClass(NewClass:char;
                       newPDist:TDistType;
                       newPV1, newPv2, newCostrate:real; newprotocol:string);
    Function CanHandleClass(custclass:char):boolean;
    Function GetProcess(c:char):TProcess;
  end;


  {Customer (Job) class}
  TCustQueueObj=class(Tobject) {To hold jobs waiting in input queue}
      CustUniqueId:string; {CustClassID + Unique number}
      Enterqueuetime:real;
      {Arrivaltime for future and completed jobs, waitime start for waiting jobs }
      Arrivaltime:real;
      Waittime:real;
      ProcessTime:real;
      eventtype:TEventtype;
      {one of the following two fields is filled in depending on eventtype}
      CustClassObj:TCustomerClass; {For eventtype=arrival}
      ServerObj:TServer;           {For eventtype=departure}
      Constructor Create(newtime:real);
      Procedure assign(const T:TCustQueueObj);
    end;

  {Qqueue class used for future events and waiting events queues}
  TQueue=class(Tlist)
   Queuetype:TQueuetype;
    Constructor create(NewQueueType:TQueueType);
    Procedure AddItem(newCust:TCustQueueObj;newtime:real);
    Procedure RemoveItem(item:TCustQueueObj);
    Function RemoveItemCopy(item:TCustQueueObj):TCustQueueObj;
    Function PopItem:TCustQueueObj;
    Procedure Clear;
  end;

  {Simulator class}
  TSim = class(TQueue) {Queue of future events}
    CustomerClasses:TList; {List of Customer classes that can exist}
    Servers:Tlist; {list of TServer Objects that exist}
    WaitQueue:TQueue; {Queue of jobs waiting to run}
    ProcessedQueue:Tqueue; {List of completed jobs - use to compute statistics}
    currenttime:real;
    runtime:real;
    firstarrival:real;
    Callback:TCallbackProc;{callback proc to let TSim user perform processing at each event}
    tag:integer;
    timefactor:integer; {multiplier to convert simulated times to seconds}
    Constructor Create;
    Destructor Free;
    Procedure AddCustomerType(NewCustClass:TCustomerClass);
    Procedure AddServer(NewServer:TServer);
    Function AvailServer(CustClass:Char):TServer; {return idle server for this class}
    Function GetNextJobForServer(Server:TServer):TCustQueueObj;
    Procedure Run(NewRuntime:real);
    Procedure clearall;
    Procedure clearQueues;
    Function FindServer(Testnbr:integer):TServer;
  end;
  {Standard Interarrival time disribution functions}
  Function DistUniform(min,max:real):real;
  Function DistExponential(mean,dummy:real):real;
  Function DistConstant(mean,dummy:real):real;

  function DistTypeToStr(t:TDisttype):string;
  function DistStrToType(s:string):TDisttype;
  function ProtocolStrToType(s:string):TSelectionProtocol;
Var
  Sim:TSim;

implementation

  Uses sysutils;
  {*******************************************************}
  { ************** Tqueue Methods ************************}
  {*******************************************************}

  {****************** TQueue.Create ***********}
  Constructor Tqueue.create(NewQueueType:TQueueType);
  Begin
    inherited create;
    Queuetype:=NewQueueType;
  end;

  {**************** Tqueue.AddItem ************}
  Procedure Tqueue.AddItem(newCust:TCustQueueObj; newtime:real);
  {Add a cutomer to the queue in time sequence}
  var
    {newtime:real;}
    i:integer;
  Begin
    newcust.enterqueuetime:=newtime;
    i:=0;
    while (i<count) and (newtime>TCustQueueObj(list[i]).EnterQueueTime) do inc(i);
    If i=count then add(newcust) else insert(i,newcust);
  end;

  {************** TQueue.Removeitem ***********}
  Procedure Tqueue.RemoveItem(item:TCustQueueObj);
  var
    i:integer;
  Begin
    i:=indexof(item);
    If i>=0 then Delete(i);
  End;

  {****************** Tqueue.RemoveItemCopy **********}
  Function Tqueue.RemoveItemCopy(item:TCustQueueObj):TCustQueueObj;
  {remove an item with the same job id - even if it is not the same item}
  var
    i:integer;
  Begin
    result:=nil;
    i:=0;
    while (i<count) and (item.CustUniqueId<>TCustQueueObj(list[i]).CustUniqueId) do inc(i);
    If i<count then
    begin
      result:=TCustQueueObj(list[i]);
      Delete(i);
    end;
  End;

  {**************** Tqueue.PopItem **********}
  Function Tqueue.PopItem:TCustQueueObj;
  {return top item from the queue and remove from queue}
  Begin
    If count>0 then
    Begin
      Result:=list[0];
      delete(0);
    end
    else result:=nil;
  End;

  {**************** TQueue.Clear ************}
  procedure Tqueue.clear;
  {Empty queue and delete removed objects}
  var i:integer;
  Begin

    If count>0 then
    for i:= 0 to count-1 do TCustQueueObj(list[i]).free;

    inherited clear;
  End;

 {**********************************************************}
 {*************** TCustomerClass Methods *******************}
 {**********************************************************}

 {******************* TCustomerClass.Create *****************}
 Constructor TCustomerClass.Create(newtype:char;newname:string;
                       newQDist:TDisttype;
                       NewQv1,NewQv2,NewMaxWait,newjobprofit,
                       newwaitcostrate,newgiveupcost:real);
   Begin
     inherited create;
     NextCustNbr:=0;
     CustIdChar:=newtype;
     JobClassName:=newname;
     QDist:=NewQDist;
     Qv1:=newQv1;
     Qv2:=newQv2;
     MaxWaitBeforeLeaving:=NewMaxWait;
     JobProfit:=newJobProfit;
     GiveUpCost:=newGiveUpCost;
     WaitCostRate:=newWaitCostRate;
     Case QDist of
      Constant: NextArrivalTime:=DistConstant;
      Uniform:  NextArrivalTime:=DistUniform;
      Exponential: NextArrivalTime:=DistExponential;
     End;
   end;

  {****************** TCustomerClass.makenextCustomer ****************}
  Function TCustomerClass.makenextCustomer(ctime:real):TCustQueueObj; {generate a customer}
  var  nexttime:real;
  Begin
      nexttime:=ctime+nextArrivalTime(QV1,QV2);
      result:=TCustQueueObj.create(nexttime);
      Inc(NextCustNbr);
      with result do
      Begin
        CustUniqueId:=CustIdChar;
        CustUniqueId:=CustUniqueId+format('%5d',[NextCustNbr]);
        CustclassObj:=self;
        eventtype:=arrival;
      end;
  End;

  {**********************************************}
  {*************** TCustQueueObj Methods ****************}
  {**********************************************}

  {****************** TCustQueueObj.Create ************}
  Constructor TCustQueueObj.Create(NewTime:real);
  Begin
    inherited create;
    ArrivalTime:=NewTime;
  End;


 {************* TCustQueueObj.assign **************}
 Procedure TCustQueueObj.assign(Const T:TCustQueueObj);
 Begin
    CustUniqueId:=T.CustUniqueId;
    Enterqueuetime:=T.EnterQueueTime;
    Arrivaltime:=t.arrivaltime;
    Waittime:=t.waittime;
    ProcessTime:=t.processtime;
    eventtype:=T.eventtype;
    CustClassObj:=T.custclassobj;
    ServerObj:=T.ServerObj;
  end;

{*************************************************}
{************** TServer Methods ******************}
{*************************************************}

{***************   Tserver.Create ***************}
 Constructor Tserver.Create(NewServernbr:integer; newservername:string);
   Begin
     inherited create;
     Servernbr:=NewServernbr;
     Servername:=newservername;
     CustomerTypes:=TStringList.create; {Classes processed by this Server}
     DefaultCostrate:=0;
     Busy:=false;
     selectionprotocol:=Classfirst;{if multiple job classes, select by job, then wait time}
   end;


 {***************  TServer.AddClass *****************}
  Procedure TServer.AddClass(NewClass:char;
                             newPDist:TDistType;
                             newPV1,newPv2, newCostRate:real; newprotocol:string);
  var
    process:TProcess;
  Begin
    Process:=TProcess.Create;
    with process do
    Begin
      CustClassID:=newclass;
      PDist:=newPDist;
      Pv1:=newPV1;
      PV2:=newPv2;
      CostRate:=newCostRate;
      DefaultCostRate:=NewCostRate;
      if uppercase(newprotocol)=uppercase(Protocolstr[Classfirst])
      then selectionprotocol:=Classfirst
      else selectionprotocol:=Timefirst;

      Case PDist of
        Constant: NextProcessingTime:=DistConstant;
        Uniform:  NextProcessingTime:=DistUniform;
        Exponential: NextProcessingTime:=DistExponential;
      end;
     end;
     CustomerTypes.addobject(newclass,process);

  end;

  {****************** TServer.CanHandleClass ************}
  Function TServer.CanHandleClass(custclass:char):boolean;
  var
    index:integer;
  Begin
     index:=Customertypes.indexof(custclass);
     result:=index>=0;
  End;

 {****************** TServer.GetProcess **********}
 Function TServer.GetProcess(c:char):TProcess;
 var
   i:integer;
 begin
   i:=0;
   while (i<customertypes.count) and (customertypes[i][1]<>c) do inc(i);
   If i<=customertypes.count then result:=TProcess(customertypes.objects[i])
   else result:=nil;
 end;

 {********************************************************}
 {******************* TSim methods ***********************}
 {********************************************************}

 {************ TSim,.create **********}
 Constructor TSim.create;
 Begin
   inherited create(Time);
   CustomerClasses:=Tlist.create;
   Servers:=TList.create;
   Waitqueue:=Tqueue.create(Time);
   ProcessedQueue:=TQueue.create(Time);
   Callback:=nil;
   timefactor:=1;  {make seconds the default time unit}
 End;

{******************* TSim.AddCustomerType *********}
 Procedure Tsim.AddCustomerType(NewCustClass:TCustomerClass);
    Begin CustomerClasses.add(NewCustClass);  End;


{************** Tsim.AddServer ***************}
 Procedure Tsim.AddServer(NewServer:TServer);
    Begin  Servers.add(NewServer);  End;

{************* TSim.AvailServer *****************}
 Function TSim.AvailServer(CustClass:Char):TServer;
 {Return nil or available idle server for this class}
 var
 i:integer;
 found:boolean;
 server:Tserver;
 Begin
   result:=nil;
   found:=false;
   If servers.count>0 then
   Begin
     i:=0;
     server:=nil;
     While (i<servers.count) and not found do
     Begin
       server:=Servers[i];
       if (not server.busy) and server.canhandleclass(Custclass)
       then found:=true
       else inc(i);
     end;
     if found then result:=server;
   End;
 end;

{********************** TSim.GetNextJobForServer ************}
 Function TSim.GetNextJobForServer(Server:TServer):TCustQueueObj;
 {Check waiting job queue for the first job which can be handled by this server}
 var
   i,j:integer;
   found:boolean;
   event:TCustQueueObj;
   searchclass:char;
 Begin
   event:=nil;
   i:=0;
   found:=false;
   If waitqueue.count>0 then
   Begin
     if server.selectionprotocol=timefirst then
     begin
       while (i<waitqueue.count) and  (not found) do
       begin
         event:=waitqueue[i];
         If server.canhandleclass(event.custClassObj.CustIdChar) then
         Begin
           found:=true;
           event.serverobj:=server;
         end
         else inc(i);
       end;
     end
     else {jobclass first}
     begin
       i:=0;
       while (not found) and (i<server.customertypes.count) do
       begin
         searchclass:=server.customertypes[i][1]; {job class to look for}
         j:=0;
         while (j<waitqueue.count) and  (not found) do
         begin
           event:=waitqueue[j];
           If (event.custClassObj.CustIdChar=searchclass) then
           Begin
             found:=true;
             event.serverobj:=server;
           end
           else inc(j);
         end;
         inc(i); {get next job class which this server can process}
       end;
     end;
   end;
   {if found then} result:=event;
 End;

 {**************** TSim.Run **************}
 Procedure TSim.run(newRuntime:real);

 var
   nextevent:TCustQueueObj;
   Customer:TCustQueueObj;
   Server:TServer;
   i, index:integer;
   nexttime:real;
 Begin
   randomize;
   currenttime:=0;
   clearqueues;
   runtime:=newruntime;
   firstarrival:=1e30;

   {loop through customer types and generate first arrival times -  queue}
   For i:= 0 to customerclasses.count -1 do
   Begin
      customer:=TCustomerclass(customerclasses[i]).makenextcustomer(currenttime);
      If firstarrival>customer.arrivaltime then firstarrival:=customer.arrivaltime;
      addItem(Customer,customer.arrivaltime);
   End;

   tag:=0;

   {now start processing the future events queue}
   while (tag=0) and (currenttime<runtime) do
   Begin
     {get top stack entry}
     nextevent:=PopItem;
     if assigned(nextevent) then
     with nextevent do
     Begin
       currenttime:=enterqueuetime;
       if (tag=0) and (@callback<>nil) then callback(nextevent);
       Case eventtype of
         arrival:
           Begin
             {generate next arrival future event}
             customer:=CustClassObj.makenextcustomer(currenttime);
             addItem(customer,customer.arrivaltime);
             {check for idle server}
             server:=Availserver(custclassobj.CustIdChar);

             If server<>nil then
             with server do
             Begin
               busy:=true;

               Customertypes.find(custUniqueId[1],index);
               with TProcess(Customertypes.objects[index])
               do nextevent.processtime:=NextProcessingtime(pv1,pv2);
               {generate future event departure record}
               eventtype:=startprocess;
               ServerObj:=server;
               if @callback<>nil then callback(nextevent);
               nexttime:= currenttime+processtime;
               eventtype:=departure;
               addItem(nextevent,nexttime);
             end
             else
             Begin {no available server, put it in the wait queue}
               waitqueue.additem(nextevent,currenttime);
               Customer:=TCustQueueObj.create(nextevent.arrivaltime);
               Customer.assign(nextevent);
               Customer.eventtype:=maxwaitExceeded;
               additem(Customer, currenttime+Customer.CustClassObj.maxwaitBeforeLeaving);
             end;
            End;
         departure:
             Begin
               ProcessedQueue.addItem(nextevent,nextevent.arrivaltime);
               with serverobj do
               Begin
                 inc(jobsprocessed);
                 busytime:=busytime+processtime;
                 busy:=false;
               end;
               {start the next job}
               nextevent:=GetNextJobForServer(Serverobj);
               If (nextevent<>nil)  then
               Begin
                 {remove job from future event queue - maxwaittime if rec exists}
                 removeitemCopy(nextevent);
                 {move job from wait queue to future event queue as departure type}
                 with serverobj do
                 Begin
                   busy:=true;
                   Customertypes.find(custUniqueId[1],index);
                   with TProcess(Customertypes.objects[index])
                   do processtime:=NextProcessingtime(pv1,pv2);
                 end;
                 waittime:=currenttime-arrivaltime;
                 eventtype:=startprocess;
                 if @callback<>nil then callback(nextevent);
                 {nextevent.}EventType:=departure;
                 WaitQueue.removeItemCopy(nextevent);
                 Additem(nextevent,currenttime+ProcessTime);
               End;
             end;
         MaxWaitExceeded:
             Begin
               {record departure - unserviced}
                nextevent.processtime:=0;
                waittime:=currenttime-arrivaltime;
                ProcessedQueue.addItem(nextevent,nextevent.arrivaltime);
               {remove item from waitqueue}
               customer:=waitqueue.removeitemCopy(nextevent);
               If customer<>nil then customer.free;

             end;
       end;
     end
     else
     Begin
      {showmessage('No jobs or servers');}
      currenttime:=runtime;
     end;
   end;
 end;

 {************** TSim.free *********}
  Destructor Tsim.free;
  Begin
    CustomerClasses.free;
    Servers.free;
    inherited free;
  End;

 {***********  TSim.ClearQueues *********}
 Procedure TSim.ClearQueues;
 Begin
   inherited clear;
   waitqueue.clear;
   processedqueue.clear;
   currenttime:=0;
 end;

 {*******************TSim.FindServer **************}
 Function TSim.FindServer(Testnbr:integer):TServer;
 var i:integer;
 Begin
   i:=0;
   while (i<Servers.count) and (TServer(servers[i]).servernbr<>TestNbr) do inc(i);
   If i<servers.count then result:=servers[i]
   else result:=nil;
 End;

 {**************** TSim.Clearall ************}
  Procedure TSim.clearall;
 var i:integer;
 Begin
   clearqueues;
   If (customerclasses.count>0) then
   for i:= 0 to customerclasses.count-1
   do tcustomerclass(customerclasses.items[i]).free;
   If servers.count>0 then
   for i:= 0 to Servers.count-1  do tServer(Servers.items[i]).free;
   CustomerClasses.clear;
   Servers.clear;
 end;

 {***********************************************************}
 {************** Distribution Type Procedures ***************}
 {***********************************************************}

 {**************** DistUniform *********}
 Function DistUniform(min,max:real):real;
 Begin
   result:=random*(max-min)+min;
 end;

 {************ DistExponential *********}
 Function DistExponential(mean,dummy:real):real;
 {Return Exponential distribution value}
 Begin  result:=-ln(random)*mean;  End;

{************* DistConstant ************}
 Function DistConstant(mean,dummy:real):real;
 {Return constant=mean }
 Begin result:=mean; End;

 {*************** DistTypeToStr **************}
 function disttypetostr(t:TDisttype):string;
  Begin  result:=DistStrTypes[t]; End;


{************** DirstStrToType *************}
function DistStrToType(s:string):TDisttype;
{convert a distribution name string to a type}
var
  i:TDistType;
  Begin
    i:=low(TDistType);
    while (i<=high(TDistType)) and (Comparetext(DistStrTypes[i],s)<>0) do i:=succ(i);
    If i<=high(TDistType) then result:=i
    else result :=low(TDistType);
  end;

{***************** ProtocolStrToType **************}
function ProtocolStrToType(s:string):TSelectionProtocol;
{COnvert a job selection protocol name to a type}
var
  i:TSelectionProtocol;
  Begin
    i:=low(TSelectionProtocol);
    while (i<=high(TSelectionProtocol)) and (Comparetext(ProtocolStr[i],s)<>0) do i:=succ(i);
    If i<=high(TSelectionProtocol) then result:=i
    else result :=low(TSelectionProtocol);
  end;

 Initialization
   Sim:=TSim.create;

end.
