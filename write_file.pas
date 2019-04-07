unit Write_file;

{$mode objfpc}{$H+}

interface
Type Member=record
            Name: string;
            Bike: string;
            experience: integer;
     end;
Var f: file;
Procedure Write_info;


implementation
uses
  Classes, SysUtils, Read_file;
Procedure Write_info;
begin
  Assign(f, 'test_programm');

end;

end.

