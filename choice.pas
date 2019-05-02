unit Choice;                           {72-����}   {75-�����}
                                       {80-����}   {77-��ࠢ�}
                                       {13-Enter}
{$mode objfpc}{$H+}                    {27-Esc}

interface
Var i,max: byte;
Function Enter_char: char;                     //䨫��� �� ���� �������� ������ ��५�窨 � �.�.
Function Cursor_main_menu: string;             //�롮� �㭪⮢ ��ࢮ�� ����
Function Cursor_first_menu: string;            //�롮� �㭪� ��ண� ����
Function Choose_open_file(make,File_: string): string;             //�롮� 䠩�� ��� ������
Function Go_out_with_out_save_file(File_is_or_Go_out: string): boolean;  //��室 ��� ��࠭���� 䠩��. �롮� �� ��� ���

implementation
uses
  Classes, Table, SysUtils, crt;
Function Enter_char: char;
  Var c: char;
  begin
    c:=Readkey;
    If c=#0 then Result:=Readkey
      else If (c=#13)or(c=#27)or(c=#8) then Result:=c;
  end;
Function Cursor_main_menu: string;
Type S=(Member_club,Arrivals,Reference,Go_out,Done);
Var State: S;
    key: byte;
  begin
    State:=Member_club;
    Repeat case State of
      Member_club: begin
                     Table.Member_club(2);
                     key:=Ord(Enter_char);
                     If key=80 then State:=Arrivals;
                     If key=13 then
                       begin
                         State:=Done;
                         Result:='First_Menu';
                       end;
                     Table.Member_club(7);
                   end;
      Arrivals: begin
                  Ride(2);
                  key:=Ord(Enter_char);
                  If key=80 then State:=Reference;
                  If key=72 then State:=Member_club;
                  If key=13 then
                    begin
                      State:=Done;
                      Result:='Second_Menu';
                    end;
                  Ride(7);
                   end;
      Reference: begin
                   Table.Reference(2);
                   key:=ord(Enter_char);
                   If key=80 then State:=Go_out;
                   If key=72 then State:=Arrivals;
                   Table.Reference(7);
                   If key=13 then
                     begin
                       State:=Done;
                       Result:='Reference';
                     end;
                 end;
      Go_out: begin
                Table.Exit(4);
                key:=Ord(Enter_char);
                If key=72 then State:=Reference;
                If key=13 then
                  begin
                    State:=Done;
                    Result:='Done';
                  end;
                Table.Exit(7);
              end;
    end until State=Done;
  end;
Function Cursor_first_menu: String;
Type S=(Read_file,Write_file,Delete_file,Reference,Go_out,Done);
Var State: S;
    key: byte;
  begin
    State:=Read_file;
    Repeat case State of
      Read_file: begin
                   Table.Read_from(2);
                   key:=Ord(Enter_char);
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
                    key:=Ord(Enter_char);
                    If key=80 then State:=Delete_file;;
                    If key=72 then State:=Read_file;
                    Table.Write_in(7);
                    If key=13 then
                      begin
                        State:=Done;
                        Result:='WriteFile';
                      end;
                  end;
      Delete_file: begin
                     Table.Delete_File(2);
                     key:=Ord(Enter_char);
                     If key=80 then State:=Go_out;
                     If key=72 then State:=Write_file;
                     Table.Delete_file(7);
                     If key=13 then
                       begin
                         State:=Done;
                         Result:='DeleteFile';
                       end;
                    end;
      Go_out: begin
                Table.Exit(4);
                key:=Ord(Enter_char);
                If key=72 then State:=Delete_file;
                If key=13 then
                  begin
                    State:=Done;
                    Result:='Main_Menu';
                  end;
                Table.Exit(7);
              end;
      end until State=Done;
  end;
Function Choose_open_file(make, File_:string): string;
  Var f: text;
      f1:file;
      m: array [byte] of string;
      key: char;
  Procedure Choosed_file(W: char);     //�롮� �������� 䠩��
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
  begin //Choose_open_file
    Table.Choose_open_file_Window;
    Gotoxy(42,13);
    TextColor(3);
    Write('�롥�� ��� 䠩��');
    AssignFile(f,File_);
    if IOResult <> 0 then begin
      writeln ('��室�� 䠩� �� ������!');
      Result:='Cancel';
      end
      else begin
        Reset(f);
    i:=0;
    While not EoF(f) do
      begin
        i+=1;
        Readln(f,m[i]);
      end;
    max:=i;
    CloseFile(f);
    For i:=1 to 10 do begin
      Gotoxy(34,13+i);
      Write(m[i]);
      end;
    y:=14;
    Choosed_file('n');
    Repeat
      begin
        key:=Enter_char;
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
    If key=#13 then
      begin
        If (make='Del')and
           (((m[y-13]<>'��᫥���� 䠩�')and(File_='All_Files.txt'))or
           ((m[y-13]<>'��᫥����_䠩�')and(File_='All_File.txt')))then
          begin
            Rewrite(f);
            While max<>0 do begin
              If m[max]<>m[y-13] then Writeln(f,m[max]);
              max-=1;
            end;
            CloseFile(f);
            AssignFile(f1,m[y-13]);
            {$I-}
            if IOResult <> 0 then Erase(f1);
            {$I+}
          end
          else Result:=m[y-13];
      end;
    TextColor(7);
      end;
  end;
Function Go_out_with_out_save_file(File_is_or_Go_out: string): boolean;
  var key: char;
      left: boolean;
  begin
    If File_is_or_Go_out='Go_out' then Not_Save_Window('   ��� ��� ��࠭���� 䠩��?');
    If File_is_or_Go_out='File_is' then Not_Save_Window('����� 䠩� �������. ��������?');
    left:=true;
    Repeat begin
      key:=Enter_char;
      If (key=#77)and(left) then begin
          Textcolor(7);
          Gotoxy(44,17);
          Write('��');
          Textcolor(2);
          Gotoxy(52,17);
          Write('���');
          left:=false;
          Gotoxy(100,35);
        end
        else If (key=#75)and(not left) then begin
          Textcolor(2);
          Gotoxy(44,17);
          Write('��');
          Textcolor(7);
          Gotoxy(52,17);
          Write('���');
          left:=true;
          Gotoxy(100,35)
        end;
    end until key=#13;
    TextColor(7);
    If left then Result:=true else Result:=false;
  end;

end.

