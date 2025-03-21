Unit UDelayedColumnGeneration;
{Copyright � 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Code adapted  to Delphi from Pascal version of

Delayed Column Generation code CUTSTOCK IN PAS  VER 2.1

   PROGRAMMED BY SUH, jeongdae
                 KIM, changgon
                 HAHN, kyuhun
                 JU, hientaek.
                 KIM, donghee

   DIRECTED BY PROF. PARK, soondal
   SEOUL NATIONAL UNIVERSITY

   PROGRAMMED   ON  JUN  24, 1986
   LAST REVISED ON  DEC  17, 1999

}

{Note - most arrays in this unit were converted from fixed to dynamic arrays
        but the 0th element is unused to avoid messing around with index ranges}

interface

uses SysUtils,StdCtrls;
  type
    TCaseRec=record
      NPart,NSource:integer; {Nbr of required parts and supply parts}
      Verbose, Fractional:Boolean;
      StockLengths:array of extended;
      StockCost:array of extended;
      StockUsed: array of integer; {Stock lengths, Stock costs, Stock Used}
      StockOrigLoc:array of integer; {Used to report usage back in the right row}
      Partlengths:array of extended;
      PartQty:array of integer;  {required part lengths and quanties}
      totparts:array of integer; {for each length, sum of parts cut from all patterns}
      StockusedByPattern: array of extended;  {required nbr of pieces for each pattern}
      IStockUsedByPattern:array of integer; {integer version}
      A: array of array of integer; {array of  columns (patterns) and rows (part
                                     lengths)}
      C1 : ARRAY OF extended;
    end;

   procedure Solvecase(var Data:TCaserec; memo:TMemo);

   var
     SLENGTH: ARRAY OF Extended; {INTEGER;}     {Stock lengths for each pattern}
     Tolerance:extended = 1e-5;
     IT:INTEGER;

implementation
  (*
    Procedure   inisolc; {finds an initial solution}
    Procedure   btran;   {computes simplex multiplier}
    Procedure   dpknap;  {solves an knapsack problem}
    Procedure   entcol;  {finds a cutting pattern to improve current solution
                              by dynamic program algorithm }
    Procedure   ftran;   {updates newly found column}
    Procedure   chuzr;   {determines a dropping variable by ratio test}
    Procedure   upbinv;  {updates explicit form B-1 }
    Procedure   upsol;   {updates solution}
    procedure   makeInt;  {convert fractional to integer # stock parts used sol'n}
    Procedure   optsolc;
    procedure   ERROR_HANDLE;
  *)
(*
   features :
    (1) global static entcol data used.
    (2) LPRESE25.C  subroutines are used.
        btran(), ftran(), chuzr(), upbinv(), upsol()
*)



VAR
(*
NROW  :

PI(I) : simplex multiplier
AR(I) : updated entering column
NR : pivot row
SLENGTH(I) : length of stock at i-th cutting pattern
NSTAGE  : number of stages
RESOURCE : initial available resource
STATE(I) : number of states of the i-th stage
NODE(I,J) : j-th node of the i-th stage
VAR(I)  :  number of decisions in the i-th stage
DEMAND(I,J) : resource contribution of a decision
INV(I,J) : former stage's unused resource which corresponds to the current decision
F(I,J)  : optimal objective value of the node (i,j)
D(I,J)  : decision value of the node (i,j)
C(I)    : cost coefficients of an knapsack problem
KA(I)   : constraint vector of an knapsack problem
XS(I)   : entering column generated by knapsack problem
IPR : display option
     = 1, display the optimal solution
     = 2, display the optimal solution and intermediate results
*)

  Memo2:TMemo;
{*--------------------<  INPUT DATA  >------------------------*}
   SL,SC : ARRAY of Extended; {INTEGER;} {lengths  and costs of stock piece types}

   //NSOURCE, NPART : INTEGER;  {# of stock types, # of required parts types}


{*--------------------<  SIMPLEX DATA  >------------------------*}
   BI : ARRAY of array of extended; {Inverse of B}
   //BBAR: ARRAY  OF extended; {required amount of ith length}
   B : ARRAY  OF extended;   {Right hand side}
   AR : ARRAY  OF extended;  {updated entering column}
   ARINV : ARRAY  OF extended; {Inverse of AR}
   PI : ARRAY OF extended;  {Simplex multiplier}

   ZB:extended;  {Total cost}
   RMAX : extended; {minimum ratio of ratio test}
   CMIN : extended; {minimum value of j-th reduced cost}
   //A : ARRAY of array of INTEGER;  {the A matrix of LP, patterns}
   NR, NROW : INTEGER;  {number of constraints}

{*--------------------<  ENTCOL DATA  >------------------------*}
   SCOST : extended;
   SSOURCE : INTEGER;

{*--------------------<  KNAPSACK DATA  >------------------------*}
   KA:array of extended;  {Array of Integer;}
   STATE, VARS, XS : ARRAY OF INTEGER;
   NODE, D : ARRAY of array OF INTEGER;
   Demand,Inv: array of array of extended; {Array of Integer}
   RESOURCE:INTEGER;
   NCOL, NSTAGE, OPTN  : INTEGER;
   C : ARRAY OF extended;
   COST:array of array of extended;
   F : ARRAY of array  OF extended;
   OPTD:integer;
   OPTF : extended;

{*--------------------<  control variables  >--------------------*}
   SW : CHAR;
   fp : TEXT;
   IERROR : integer;
   ERR_MSG : String;



Procedure Solvecase(Var Data:TCaserec; Memo:TMemo);

      {*---------------------------
                 INISOLC
       ---------------------------*}
      Procedure   inisolc;
      {INISOLC  : find an initial solution.}
      var
         i,j : integer;
      begin
        with data do
        begin
          for i:=1 to NPART do
          begin
             for j:=1 to NPART do
             begin
               if (i <> j) then data.A[i,j] := 0
               else     data.A[i,j] := trunc(SL[1] / PartLengths[I]);  {* use first source *}
            end;
          end;

          for i:=1 to NPART do
          for j:=1 to NPART do
          begin
            if (i=j) and (data.A[j,i]>0) then BI[j,i] := 1.0/data.A[j,i]
            else  BI[j,i] := 0;
            end;
          for i:=1 to NPART do
          begin

            StockUsedByPattern[i]:=0;

    {gdd}   for j:=1 to NPART do StockUsedByPattern[i]
                  :=StockUsedByPattern[i] + BI[j,i] * PartQty[j];

            //stockusedbypattern[i]:=trunc(stockusedbypattern[i]+0.999);
          end;


          for i:=1 to NPART do
          begin
            C1[i] := SC[1];
            SLENGTH[i] := SL[1];
          end;

          ZB:=0;
          for i:=1 to NPART do ZB :=ZB + C1[i]*StockUsedByPattern[i] ;

          if Verbose then
          with memo2.lines do
          begin
            add(' --- Initial Solution Cutting Patterns ---');
            for i:=1 to NPART do
            begin
               add(format(' PATTERN(%4d)',[i]));
               add(format(' Stock Length=%6.2f  Qunatity used=%10.4f',
                                           [SLength[i], StockUsedByPattern[i]]));
               for j:=1 to NPART do
               begin
                  if (A[i,j] > 0) then
                  add(format(' Order length=%6.2f, Number to cut from each=%d, Total cut=%f',
                           [Partlengths[j],A[i,j], stockusedbypattern[i]*A[i,j]]));

               end;
            end;
            add(format(' COST OF USED STOCK = %10.4f',[ ZB]));
          end;
          Exit;
        end;
      end;

      {*---------------------------
                  BTRAN
        : subroutine in LPRESE25.C
       ---------------------------*}
      Procedure   Btran;
      {BTRAN  : computes simplex multiplier}
      var
         i, j : integer;
      begin
        with data do
        begin
          for i:=1 to  NPART do
          begin
            PI[i] := 0;
            for j:=1 to NPART do  PI[i] :=PI[i] + C1[j] * BI[j][i] ;
          end;
          if Verbose then
          begin
            memo2.lines.add('');
            memo2.lines.add('********** Iteration # '+inttostr(IT)+' ***********');
            memo2.lines.add(' --- BTRAN : Calculate Dual variables (incremental costs) ---' );
            for i:=1 to  NPART do memo2.lines.add(format('For length %f Dual cost=%10.5f',
                      [ data.partlengths[i],PI[i]]));
          end;
        end;
      end;

      {*---------------------------
                 DPKNAP
          Solve Knapsack problem by DP
       ----------------------------*}

      Procedure dpknap;
      {DPKNAP : solves a knapsack problem using dynamic programming}
      var
         i,j,k,nvar,nstate,nstate1,stage,stage1{,invent},tempn : integer;
         invent, temp : extended;
         s:string;
      begin
        with data do
        begin
          {* formulation *}
           NSTAGE := NCOL;
           STATE[1] := 1;
           if resource>=high(node[1]) then
           begin  {increase NState array sizes}
             setlength(Node,NPart+1,Resource+2);
             setlength(DEMAND ,NPart+1, Resource+2 {max nbr of shortest piece from longest stock});
             setlength(INV ,NPart+1, Resource+2);
             setlength(Cost,NPart+1, Resource+2);
             setlength(F, NPart+1, Resource+2);
             setlength(D, NPart+1, Resource+2);
           end;
          for i:=1 to NSTAGE do VARS[i] := Trunc(RESOURCE/KA[i]{)}+1);
           for i:=2 to NCOL do  STATE[i] := RESOURCE + 1;
           for i:=1 to NSTAGE do
           begin
              nstate:=VARS[i];
              for j:=1 to nstate do NODE[i][j] := j;
           end;
           for i:=1 to NCOL do
           begin
             nstate := VARS[i];
             for j:=2 to nstate do DEMAND[i][j] := (j-1)*KA[i];
             DEMAND[i][1] := 0;
           end;
           for i:=1 to NCOL do
           begin
             nstate := VARS[i];
             for j:=2 to nstate do COST[i][j] := (j-1)*C[i];
             COST[i][1] := 0;
           end;
           {* initialization  *}
           stage := NSTAGE;
           nstate:=STATE[NSTAGE];
           nstate1 := VARS[stage];

           for j:=1 to nstate do
           begin
             F[stage][j] := 0;
             D[stage][j] := 0;
           end;
           for j:=1 to nstate do
           begin
             for  k:=1 to nstate1 do
             begin
               invent := RESOURCE - (j-1);
               if (invent >= DEMAND[stage][k]) then
               begin
                  temp := COST[stage][k];
                  if (F[stage][j] < temp) then
                  begin
                     F[stage][j] := temp;
                     D[stage][j] := k;
                     INV[stage][j] := invent - DEMAND[stage][k];
                  end;
               end;
             end;
           end;
           {*  DP loop  *}
           for i:=2 to NSTAGE do
           begin
             stage:=NSTAGE-i+1;
             stage1 := stage + 1; {* backward *}
             nvar := VARS[stage];
             nstate := STATE[stage];

             for j:=1 to nstate do
             begin
               F[stage][j] := 0;
               NODE[stage][j] := 0;
               D[stage][j] := 0;
             end;
             for j:=1 to nstate do
             begin
               invent:=0;
               for  k:=1 to nvar do
               begin
                  invent := RESOURCE - (j-1);
                  if (invent >= DEMAND[stage][k]) then
                  begin;
                     invent :=invent - DEMAND[stage][k];
                     tempn := round(RESOURCE - invent + 1) ; {GDD}
                     temp := COST[stage][k] + F[stage1][tempn];
                     if (F[stage][j] < temp) then
                     begin
                        F[stage][j] := temp;
                        D[stage][j] := k;
                        NODE[stage][j] := tempn;
                        invent := INV[stage1][tempn];
                     end;
                  end;
               end;
               INV[stage][j] := invent;
             end;
           end;

           OPTF := F[1][1];
           OPTN := 1;
           OPTD := D[1][1];
           XS[1] := OPTD;
           nstate := NODE[1][OPTN];

           //memo2.lines.add(format('OPTF=%5.2f, OPTD=%d, XS[1]=%d, nstate=%d',
           //                      [OPTF,OPTD,XS[1],NState]));
           for i:=2 to NSTAGE do
           begin
             XS[i] := D[i][nstate];
             nstate := NODE[i][nstate];
           end;
           for i:=1 to NSTAGE do
           begin
             if (XS[i] <=1 ) then XS[i] := 0 else XS[i] :=XS[i] - 1;
           end;
           if Verbose then
           with memo2.lines do
           begin
             add('');
             add(' ---  DPKNAP : Solve Knapsack Problem  ---');
             add('     Optimal pattern to add ');
             s:='';
             for j:=1 to NPART do
             if (xs[j]>0) then  
             begin
               for i:=1 to xs[j] do s:=s+format('%6.1f, ',[data.partlengths[j]]);
             end;
             add(s);
             add('');
           end;
         end;
       end;

      {*---------------------------
                 ENTCOL
         column generation function
       ---------------------------*}

      Procedure  entcol;
      {ENTCOL : finds a cutting pattern to improve current solution
              by dynamic program algorithm}
      var
         i, j, k : integer;
         tempx : array of integer;
         val, maxval : extended;
         s:string;
      begin
        with data do
        begin
          setlength(tempx,NPART+1);
          for i:=1 to  NPART do  XS[i] := 0;
          {*  Check Pi_value before column generation *}
          {*           not implimented yet.           *}

          {* SLACK ENTERING *}
          for i:=1 to NPART do
          begin
            if (PI[i] < -Tolerance) then
            begin
               XS[i] := -1;
               SCOST := 0.0;
               for j:=1 to NSOURCE do if ( Partlengths[i] <= SL[j]) then SSOURCE := j;
               if Data.Verbose then
               with memo2.lines do
               begin
                  add('');
                  add('---  ENTCOL : Generate Entering Pattern  ---');
                  //for j:=1 to NPART do add(format('     %3d',[ XS[j]]));
                  for j:=1 to NPART do
                 if xs[j]>0
                 then for k:=1 to xs[j] do s:=s+format('%6.1f, ',[data.partlengths[j]]);
                 add(s);
                 add('');
               end;
               Exit;
            end;
          end;

          {*  Find integer solution  by dynamic programming *}

          maxval:=0.0;
          {*     for NSOURCE type of source length         *}
          for k:=1 to NSOURCE do
          begin
            {* DP data formation *}
            NCOL := NPART;
            RESOURCE:=trunc(SL[k]);  {GDD}
            for i:=1 to NPART do  KA[i] := Partlengths[i];
            for i:=1 to NPART do  C[i] := PI[i];

            {* Call dynamic program *}
            dpknap;

            {*  Check optimal condition  Zj -Cj <= 0  *}
            {* Select source type by maxval          *}
            val:=0.0;
            for i:=1 to  NPART do  val :=val + XS[i] * PI[i];
            if ((val - SC[k]) > maxval) then
            begin
               maxval :=val - SC[k];
               SSOURCE := k;
               SCOST := SC[k];
               {* Return a generated entering column *}
               for j:=1 to NPART do  tempx[j]:=XS[j];
            end;
         end; {* End of Selection loop *}
         for j:=1 to NPART do  XS[j]:=tempx[j];

         CMIN := -maxval;

         if Data.Verbose then
         with memo2.lines do
         begin
            add('');
            add('---  ENTCOL : Generate Entering Column  ---');
            //for j:=1 to NPART do add(format('     %3d',[ XS[j]]));
            s:='';
            for j:=1 to NPART do
            if xs[j]>0
            then for i:=1 to xs[j] do s:=s+format('%6.1f, ',[data.partlengths[j]]);
                 add(s);
            add(format(' Selected source length  =  %6.2f',[ SL[SSOURCE]]));
            add(format(' Reduced  cost           =  %10.4f',[ maxval]));
            add('');
         end;
       end;
     end;

      {*---------------------------
                 FTRAN
        : subroutine in LPRESE25.C
            < conversion table >
             XS[.] <-- A[.][JP]
       ---------------------------*}

      Procedure  ftran;
       {FTRAN : updates newly found column}
      var
         i, j : integer;
      begin
      {*  Note :
        no index variable is needed such that JP, NCOL, N1.
      *}
        with data do
        begin
          for i:=1 to NPART do
          begin
            AR[i] := 0;
            for j:=1 to NPART do AR[i] :=AR[i] + BI[i][j] * XS[j] ;
          end;
          if Data.Verbose then
          begin
            memo2.lines.add(' --- FTRAN : Update Column --- ');
            for i:=1 to  NPART do  memo2.lines.add(format('%10.4f',[ AR[i]]));
          end;
        end;
      end;

      {*---------------------------
                  CHUZR
        : subroutine in LPRESE25.C
       ---------------------------*}

      Procedure   chuzr;
      {CHUZR : determines a dropping variable by ratio test}
      var
         i : integer;
         temp : extended;
      begin
        with data do
        begin
          NR := 0;
          RMAX := 1.0E+30;
          for i:=1 to NPART do
          begin
            temp  := 1.0E+30;
            if (AR[i] > 0) then temp := Data.StockUsedByPattern[i] / AR[i];
            if (RMAX > temp) then
            begin
               RMAX := temp;
               NR := i;
            end;
          end;

          if Verbose then
          with memo2.lines do
          begin
            add('');
            add(' ---  CHUZR : Choose pattern to drop  {PIVOT ROW} --- ');
            add(format('%d-th pattern  is leaving, at min ratio  %10.4f',[NR,RMAX])) ;
          end;
        end;
      end;

      {*---------------------------
                 UPBINV
        : subroutine in LPRESE25.C
       ---------------------------*}

      Procedure   upbinv;
      {Update B Inverse}
      var
         i, j : integer ;
      begin
        with data do
        begin
          for i:=1 to NPART do  ARINV[i] := - AR[i] / AR[NR];
          ARINV[NR] := 1 / AR[NR];

          for i:=1 to  NPART do
          begin
            if (i <> NR) then
            begin
               for j:=1 to NPART do BI[i][j] :=BI[i][j] + ARINV[i] * BI[NR][j];
            end;
          end;
          for j:=1 to NPART do BI[NR][j] := ARINV[NR] * BI[NR][j];
          if Verbose then
          with memo2.lines do
          begin
            add('');
            add(' --- UPBINV: Update B Invers ---');
            add('(BI(i,j),i=1,NPART),j=1,NPART (only non-zero displayed)');
            for i:=1 to NPART do
            for j:=1 to NPART do if BI[i,j]<>0 then add(format('b(%d,%d)=%10.4f',[i,j, BI[i][j]]));
          end;
        end;
      end;

      {*---------------------------
                  UPSOL
        : subroutine in LPRESE25.C
       ---------------------------*}

      Procedure   upsol;
      {UPSOL   : updates solution}
      var
         i : integer ;
      begin
        with data do
        begin
          for i:=1 to NPART do Data.StockUsedByPattern[i] := Data.StockUsedByPattern[i]  -AR[i]*RMAX ;
          Data.StockUsedByPattern[NR] := RMAX ;

          ZB :=ZB + CMIN*RMAX ;

          if Data.Verbose then
          with memo2.lines do
          begin
            add('');
            add(' --- UPSOL: Update Solution ---');
            add('index, basic variable solution');
            for i:=1 to NPART do
               add(format('%4d %10.4f',[ i, Data.StockUsedByPattern[i]]));
            add(format('The new cost is = %10.4f',[ZB]));
          end;
        end;
      end;





      (******************
         ERROR_HANDLE
      *******************)
      procedure ERROR_HANDLE;
      begin
         (**************************************
            Error Code
          **************************************
            IERROR:=0  No Error
            IERROR:=1  Normal Exit
            IERROR:=2  File Open Error
          **************************************)
          if (IERROR = 0) then
          begin
             exit
          end
          else
          begin
             memo2.lines.add('');
             memo2.lines.add(ERR_MSG);
          end;
      end;

      {*------------  OPTSOLC ----------*}
      Procedure   optsolc;
      var
         i, j : integer ;
         used:extended;
      begin
        with data, memo2.lines do
        begin

          for i:=1 to data.NSOURCE do data.StockUsed[i]:=0;
          for i:=1 to NPART do
          begin
            if (StockUsedByPattern[i] > Tolerance) then
            begin
              {find this length in the OSL array, and add StockUsedByPattern[i] to the StockUsed array}
              for j:=1 to NSOURCE do
              begin
                if StockLengths[j]=Slength[i] then
                begin
                  inc(StockUsed[j],trunc(StockUsedByPattern[i]+0.999));
                  break;
                end;
              end;
            end;
          end;
        end;
      end;


 var i:integer;
 begin {solvecase}
   IERROR:=0;
   memo2:=memo;
   with Data do
   begin
     setlength(SL,NSource+1);
     setlength(SC,NSource+1);
     setlength(Partlengths,NPart+1);
     setlength(PartQty,NPart+1);
     setlength(StockUsed,NSource+1);
     for i:= 1 to NSource do
     begin
       sl[i]:=StockLengths[i];
       sc[i]:=StockCost[i];
     end;
     setlength(BI, NPart+1, NPart+10);
     setlength(B , Npart+1);
     setlength(AR , Npart+1);
     setlength(ARINV , Npart+1);
     setlength(PI, NPart+1);
     setlength(C1, NPart+1);
     setlength(SLength, NPart+1);
     setlength(KA ,NPart+1);
     setlength(State ,NPart+1);
     setlength(VARS ,NPart+1);
     setlength(XS ,NPart+1);

     setlength(NODE ,NPart+1, 0);
     setlength(DEMAND ,NPart+1, 0 {max nbr of shortest piece from longest stock});
     setlength(D ,NPart+1, 00);
     setlength(INV ,NPart+1, 00);
     setlength(C, NPart+1);
     setlength(Cost,NPart+1, 00);
     setlength(F, NPart+1, 00);

     ERROR_HANDLE;
     NROW :=NPART;
     IT:=1;
     inisolc;
     btran;
     entcol;
     while (CMIN <= -Tolerance) do
     begin
       ftran;
       chuzr;
       upbinv;
       upsol;
       IT:=IT+1;
       {* a column change *}
       for i:=1 to data.NPART do  data.A[NR,i] := XS[i];
       {* a cost endowing *}
       C1[NR] := SCOST;
       SLENGTH[NR] := SL[SSOURCE];
       btran;
       entcol;
     end;
     optsolc; {display solution}
     {$I+}
     ERR_MSG:='';
     IERROR:=1;
     ERROR_HANDLE;
   end;
 end;

end.
