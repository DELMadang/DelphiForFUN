// 3D Lab -- Show selected object from specified eye coordinates.
//
// Copyright (C) 1997-1998 Earl F. Glynn, Overland Park, KS.
// All Rights Reserved.  E-Mail Address:  EarlGlynn@att.net

program ThreeDLab2;

uses
  Forms,
  U_ThreeDLab2 in 'U_ThreeDLab2.pas' {FormLab3D},
  DrawFigures in 'DrawFigures.pas',
  GraphicsMathLibrary in 'GraphicsMathLibrary.PAS',
  GraphicsPrimitivesLibrary in 'GraphicsPrimitivesLibrary.PAS';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormLab3D, FormLab3D);
  Application.Run;
end.
