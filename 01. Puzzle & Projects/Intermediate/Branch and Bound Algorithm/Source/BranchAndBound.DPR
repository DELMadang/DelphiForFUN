program BranchAndBound;
//*******************************************************
// Example program demonstrating exhaustive and branch
// and bound searching.
//*******************************************************
// Copyright (C) 1998 John Wiley & Sons, Inc.
// All rights reserved. See additional copyright
// information in Readme.txt.
//*******************************************************
 {Modifications Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_BranchAndBound in 'U_BranchAndBound.pas' {BandBForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TBandBForm, BandBForm);
  Application.Run;
end.
