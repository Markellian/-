unit Choice;                           {72-верх}
                                       {80-вниз}
                                       {13-Enter}
{$mode objfpc}{$H+}                    {27-Esc}

interface
Var i: integer;

Function Cursor_first_menu: string;            {выбор пункта в таблице "Menu"}

Function Cursor_Biker: string;                 {указатель выбранной строки в таблице "Member"}
Procedure Cursor_Biker_line(y,color: byte);    {подсветка строк}


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
                   Table.Read_from(7);
                   If key=13 then
                     begin
                       State:=Done;
                       Result:='ReadFile';
                     end;
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
                        Result:='Write_file';
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
              end;
      end until State=Done;
  end;
Procedure Cursor_Biker_line(y,color: byte);
  begin
    For i:=2 to 99 do
      begin
        Gotoxy(i,y);
        Textbackground(color);
        Write(' ');
      end;
    Gotoxy(5,y);
    Write(#186);
    Gotoxy(60,y);
    Write(#186);
    Gotoxy(91,y);
    Write(#186);
  end;
Function Cursor_Biker: string;
Var Step: byte;
  begin
    y:=7;
    Repeat
      begin
        Cursor_Biker_line(y,2);
        Step:=Ord(ReadKey);
        If (Step=72)and(y<> 7) then
          begin
            Cursor_Biker_line(y,0);
            y-=2;
          end;
        If (Step=80)and(y<>33) then
          begin
            Cursor_Biker_line(y,0);
            y+=2;
          end;
        If Step=13 then
          begin
            Cursor_Biker_line(y,0);
            Biker.Write_Biker(y);
          end;
        If Step=27 then Result:='First_Menu';
      end
    until (Step=27);
  end;

end.

