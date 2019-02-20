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
  Classes, SysUtils;
Procedure Write_info;
begin
  Assign(f, 'C:\Users\nikke\OneDrive\Рабочий стол\Учеба\2.2\Моя большая програмка\test_programm');

end;

end.

