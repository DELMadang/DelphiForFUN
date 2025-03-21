unit U_CopyTruncateStrings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    procedure FormActivate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var LinesIn:integer =0;
    LinesOut:integer=0;
    Linesdeleted:integer =0;



procedure TForm1.FormActivate(Sender: TObject);
var
  InFile, outFile: textfile;
  Line:string;

Begin
  Assignfile(InFile, 'My Input file.txt');
  Assignfile(OutFile, 'My Output file.txt');
  Reset(inFile);
  Rewrite(outFile);
  While not eof(inFile) do
  begin
    Readln(infile, line);
    inc(linesIn);
    If length(line)>=40 then
    begin
      writeln(outfile, copy(line,1,40));
      inc(linesout);
    end
    else Inc(linesdeleted);
  end;
  CloseFile(infile);
  closefile(outfile);
  memo2.Lines.Add(format('%d lines read, %d lines written, %d short lines deleted',
                         [linesin, linesout, linesdeleted]));
end;

end.
