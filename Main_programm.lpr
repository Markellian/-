program Main_programm;
 //�ࠪ��᪠� ࠡ�� �� �祡��� �ࠪ⨪�
 //��㤥�� 2 ���� 206 ��㯯� ��१ �����
 //��ਠ�� 5: "����� ������㡠"
 //�९�����⥫�: ������� �.�.
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, crt, Table, Choice, Biker;
  { you can add units after this }

Var Main_state: String;
    Filik: string;
    Which_table: boolean;
    Biker1: Biker.Member_club;
    Biker2: Biker.Randonnee;
Procedure do_write;
  begin
    If Which_table then begin
      clrscr;
         Table.Member;
         Biker1:= Member_club.Create;
         Biker1.Write_Biker(Filik);
         Main_State:='First_Menu';

      end else begin
         clrscr;
      Table.Randonnee;
      Biker2:= Randonnee.Create;
      Biker2.Write_Randonnee(Filik);
      Main_State:='First_Menu';
      end;
  end;

begin
  Main_State:='Main_Menu';
  Repeat case Main_State of
    'Main_Menu': begin
                    textbackground(0);
                    clrscr;
                    Table.Main_menu;
                    Main_State:=Cursor_main_menu;
                  end;
    'ReadFile': begin
                  If Which_table then begin
                    Filik:=Choose_open_file('Open','All_Files.txt');
                    If Filik<>'Cancel' then do_write;
                    Main_State:='First_Menu';
                    end else begin
                      Filik:=Choose_open_file('Open','All_File.txt');
                      If Filik<>'Cancel' then do_write;
                      Main_State:='Second_Menu';
                      end;
                end;
    'DeleteFile': begin
                    If Which_table then begin
                    Filik:=Choose_open_file('Del','All_Files.txt');
                    Main_State:='First_Menu';
                    end else begin
                      Filik:=Choose_open_file('Del','All_File.txt');
                      Main_State:='Second_Menu';
                      end;
                  end;
    'WriteFile': begin
                   Filik:='New';
                   do_write;
                   if Which_table then Main_State:='First_Menu' else Main_State:='Second_Menu'
                 end;
    'First_Menu': begin
                    textbackground(0);
                    clrscr;
                    Table.Menu('Member');
                    Which_table:=true;
                    Main_State:=Cursor_first_menu;
                  end;
    'Second_Menu': begin
                    textbackground(0);
                    clrscr;
                    Table.Menu('������誨');
                    Which_table:=false;
                    Main_State:=Cursor_first_menu;
                   end;
    'Reference': begin
                   Table_Reference;
                   Content;
                   Main_State:='First_Menu';
                 end;
    end until Main_State='Done';
end.
