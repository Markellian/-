unit Choice;                           {72-верх}   {37-влево}
                                       {80-вниз}   {39-вправо}
                                       {13-Enter}
{$mode objfpc}{$H+}                    {27-Esc}

interface
Var i: byte;

Function Cursor_first_menu: string;            {выбор пункта в таблице "Menu"}
Function Choose_open_file: string;             {выбор файла для открытия}

implementation
uses
  Classes, Table, SysUtils, crt, Biker;

Function Cursor_first_menu: String;
Type S=(Read_file,Write_file,Go_out,Done);
Var State: S;
    key: byte;
  begin
    State:=Read_file;
    Repeat case State of
      Read_file: begin
                   Table.Read_from(2);
                   key:=Ord(Readkey);
                   If key=80 then State:=Write_file;
                   If key=13 then
                     begin
                       State:=Done;
                       Result:='ReadFile';
                     end;
                   Table.Read_from(7);
                 end;
      Write_file: begin
                    Table.Write_in(2);
                    key:=Ord(Readkey);
                    If key=80 then State:=Go_out;;
                    If key=72 then State:=Read_file;
                    Table.Write_in(7);
                    If key=13 then
                      begin
                        State:=Done;
                        Result:='WriteFile';
                      end;
                  end;
      Go_out: begin
                Table.Exit(4);
                key:=Ord(Readkey);
                If key=72 then State:=Write_file;
                If key=13 then
                  begin
                    State:=Done;
                    Result:='Done';
                  end;
                Table.Exit(7);
              end;
      end until State=Done;
  end;
Function Choose_open_file: string;
  Var f: text;
      m: array [byte] of string;
      key: char;
  Procedure Choosed_file(W: char);
     begin
       TextColor(3);
       If w='u' then
         begin
           Gotoxy(34,y+1);
           Write(m[y-12]);
         end;
       If w='d' then
         begin
           Gotoxy(34,y-1);
           Write(m[y-14]);
         end;
       TextColor(2);
       Gotoxy(34,y);
       Write(m[y-13]);
     end;
  begin
    Table.Choose_open_file_Window;
    Gotoxy(42,13);
    TextColor(3);
    Write('Выберите имя файла');
    AssignFile(f,'All_Files.txt');
    Reset(f);
    i:=0;
    While not EoF(f) do
      begin
        i+=1;
        Readln(f,m[i]);
      end;
    For i:=1 to 10 do begin
      Gotoxy(34,13+i);
      Write(m[i]);
      end;
    y:=14;
    Choosed_file('n');
    Repeat
      begin
        key:=ReadKey;
        If (key=#72)and(y<>14) then
          begin
            y-=1;
            Choosed_file('u');
          end;
        If (key=#80)and(m[y-12]<>'') then
          begin
            y+=1;
            Choosed_file('d');
          end;
      end;
    until (key=#27)or(key=#13);
    If key=#27 then Result:='Cancel';
    If key=#13 then Result:=m[y-13]+'.txt';
    CloseFile(f);
    TextColor(7);
  end;

end.

