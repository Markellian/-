unit Choice;                           {72-верх}
                                       {80-вниз}
                                       {13-Enter}
{$mode objfpc}{$H+}                    {27-Esc}

interface
Var i: integer;

Procedure Cursor_first_menu;

implementation
uses
  Classes, Table, SysUtils, crt;

Procedure Cursor_first_menu;
Type S=(Read_file,Write_file,Go_out,Done);
Var State: S;
    key: byte;
  begin
    State:=Read_file;
    Repeat case State of
      Read_file: begin
                   Table.Read_from(2);
                   Repeat key:=Ord(Readkey) until (key=80)or(key=13);    {верх, ввод}
                   If key=80 then State:=Write_file;
                   If key=13 then State:=Done;
                   Table.Read_from(7);
                 end;
      Write_file: begin
                    Table.Write_in(2);
                    Repeat key:=Ord(Readkey) until (key=80)or(key=72)or(key=13);
                    If key=80 then State:=Go_out;;
                    If key=72 then State:=Read_file;
                    If key=13 then State:=Done;
                    Table.Write_in(7);
                  end;
      Go_out: begin
                Table.Exit(4);
                Repeat key:=Ord(Readkey) until (key=72)or(key=13);
                If key=72 then State:=Write_file;
                If key=13 then State:=Done;
                Table.Exit(7);
              end;
      end until State=Done;
  end;

end.

