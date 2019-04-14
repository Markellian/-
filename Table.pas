unit Table;                      {ࠧ��� ���᮫�: 100*35} {���� ��������}
                                 {����஢�� CP-866}
{$mode objfpc}{$H+}

interface
Var x,y: integer;           {���न����}
    i,l,x0,y0: integer;     {��६����}{l-����� �����, 㪠�뢥� ���-�� ���⮣� ����}
                                        {x0-������ x ��᫥ ��楤���}
                                        {y0-������ y ��᫥ ��楤���}
{��楤��� ᮧ����� ⠡��� �� �ᥢ����䨪�}
Procedure Line_top(l,x0,y0: byte);       {���孨� ����� - 蠯��}
Procedure Line_mid(l,x0,y0: byte);       {�।���}
Procedure Line_bot(l,x0,y0: byte);       {������ �����}
Procedure Wall(l,x0,y0: byte);           {������ �⥭��}
Procedure Intersection(x0,y0: byte);     {����祭��}
Procedure Insruction;                    {�������� ����� ���᮫�}

Procedure Menu;                          {ᮧ����� ���� "�⥭��\������"}
{⥪�� ��� Menu}
  Procedure Read_From(tex: byte);        {"�⥭�� �� 䠩��"}
  Procedure Write_in(tex: byte);         {"������ � 䠩�"}
  Procedure Delete_File(tex: byte);      {"������� 䠩�"}
  Procedure Reference(tex: byte);        {"��ࠢ��"}
  Procedure Exit(tex: byte);             {"��室"}

  Procedure Table_Reference;             {������ ��� ᠯࠢ��}
  Procedure Content;                     {����� �ࠢ��}

Procedure Member;                        {ᮧ����� ⠡���� "����� ��㡠"}
{⠡��� ��� Member}
  Procedure Member_top;                  {���� ⠡����}
  Procedure Member_wall;                 {��ப� ������� ⠡����}
  Procedure Member_bot;                  {��� ⠡����}
  Procedure Member_line;                 {��ப� ⠡���� ������}
  Procedure Member_legend;               {������� ⠡����}

{�訡�� ����������}
  Procedure Mistake_biker(x: byte; text: string);          {������ �ଠ� ���������� ⠡���� ����ᨯ�����}

Procedure Not_Saved;
Procedure Clear_First_line(back_color: byte);   {��饭�� ��ࢮ� ��ப� ��᫥ ���ଠ樨 �� �訡���}
{���࠭��� 䠩�}
Procedure Window_to_Go_out;
Procedure Save_Window;
Procedure Not_Save_Window(a: byte);
Procedure Choose_open_file_Window;
implementation
uses
  Classes, SysUtils, crt;

Procedure Line_top(l,x0,y0: byte);   {���� ��࠭�� 㪠���� ��砫�� ���न����. ����� �������� 2 � 3-� ��६���묨}
  begin
    Gotoxy(x,y);
    Write(#201);
    For i:=1 to l do               {l - ����� � =, ��� �ࠥ�}
      begin
        x:=x+1;
        Gotoxy(x,y);
        Write(#205);
      end;
    Gotoxy(x+1,y);
    Write(#187);
    x:=x0;
    y:=y0;
  end;
Procedure Line_mid(l,x0,y0: byte);   {���� ��࠭�� 㪠���� ��砫�� ���न����. ����� �������� 2 � 3-� ��६���묨}
  begin
    Gotoxy(x,y);
    Write(#204);
    For i:=1 to l do
      begin
        x:=x+1;
        Gotoxy(x,y);
        Write(#205);
      end;
    Gotoxy(x+1,y);
    Write(#185);
    x:=x0;
    y:=y0;
  end;
Procedure Line_bot(l,x0,y0: byte);   {���� ��࠭�� 㪠���� ��砫�� ���न����. ����� �������� 2 � 3-� ��६���묨}
  begin
    Gotoxy(x,y);
    Write(#200);
    For i:=1 to l do
      begin
        x:=x+1;
        Gotoxy(x,y);
        Write(#205);
      end;
    Gotoxy(x+1,y);
    Write(#188);
    x:=x0;
    y:=y0;
  end;
Procedure Wall(l,x0,y0: byte);       {���� ��࠭�� 㪠���� ��砫�� ���न����. ����� �������� 2 � 3-� ��६���묨}
  begin
    Gotoxy(x,y);
    Write(#186);
    x:=x+l+1;
    Gotoxy(x,y);
    Write(#186);
    x:=x0;
    y:=y0;
  end;
Procedure Intersection(x0,y0: byte); {㪠�뢠���� ������ ���न����}
  begin
    Gotoxy(x,y);
    Write(#206);
    x:=x0;
    y:=y0;
  end;
Procedure Top_cover(x0,y0: byte);    {㪠�뢠���� ������ ���न����}
  begin
    Gotoxy(x,y);
    Write(#203);
    x:=x0;
    y:=y0;
  end;
Procedure Bot_cover(x0,y0: byte);    {㪠�뢠���� ������ ���न����}
  begin
    Gotoxy(x,y);
    Write(#202);
    x:=x0;
    y:=y0;
  end;
Procedure Insruction;
  begin
    Gotoxy(1,35);
    Write('��ࠢ����� - ��५�窨');
    Gotoxy(44,35);
    Write('�롮� - Enter');
    Gotoxy(91,35);
    Write('�����-Esc');
  end;

{========================}
Procedure Menu;
  Procedure Legend;
    begin
      Read_From(7);
      Write_in(7);
      Delete_File(7);
      Reference(7);
      Exit(7);
    end;
  var i: byte;
  begin
    x:=40;
    y:=8;
    Line_top(18,40,9);
    Wall(18,40,10);
    Line_bot(18,40,11);
    x:=48;
    y:=9;
    Gotoxy(x,y);
    Write('����');
    x:=40;
    y:=12;
    Line_top(18,40,13);
    i:=14;
    Repeat begin
      Wall(18,40,i);
      i+=1;
      Line_mid(18,40,i);
      i+=1;
    end until i=22;
    Wall(18,40,22);
    Line_bot(18,40,23);
    Insruction;
    Legend;
  end;

Procedure Read_From(tex: byte);      {㪠�뢠���� 梥� ⥪��}
  begin
    x:=44;
    y:=13;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('������ 䠩�');
  end;
Procedure Write_in(tex: byte);       {㪠�뢠���� 梥� ⥪��}
  begin
    x:=44;
    y:=15;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('������� 䠩�');
  end;
Procedure Delete_File(tex: byte);
  begin
    x:=44;
    y:=17;
    Gotoxy(x,y);
    TextColor(tex);
    Write('������� 䠩�');
  end;
Procedure Reference(tex: byte);
  begin
    x:=46;
    y:=19;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('��ࠢ��');
  end;
Procedure Exit(tex: byte);           {㪠�뢠���� 梥� ⥪��}
  begin
    x:=47;
    y:=21;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('��室');
  end;

Procedure Table_Reference;
  begin //Table_Reference
    clrscr;
    x:=20;
    y:=5;
    Line_top(58,20,6);
    For i:=7 to 29 do Wall(58,20,i);
    Line_bot(58,20,21);
    Insruction;
    Gotoxy(45,6);
    Write('����������');
  end;
Procedure Content;
    const x1=21;
          x2=24;
    Var key: char;
        page: byte;
    Procedure FirstPage;
      begin
      Gotoxy(x1,7);
      Write('1. ��� �롮� �㭪� � ���� � ��ப� � ⠡���� �ᯮ���-');
      Gotoxy(x2,8);
      Write('���� ��५�窨. ��� �롮�/��������� ��࠭���� ����');
      Gotoxy(x2,9);
      Write('���� ������ Enter. ��� ��室� �� ⥪�饣� �⠯� ࠡ���');
      Gotoxy(x2,10);
      Write('� ����⮬ �ணࠬ�� ������ ������� Esc.');
      Gotoxy(x1,12);
      Write('2. �� ࠡ�� � ⠡��楩 ��� ��������� ���� ��३��� �');
      Gotoxy(x2,13);
      Write('�������饬� ��� ���� � ������ Enter. ��᫥����⥫쭮');
      Gotoxy(x2,14);
      Write('������� ����, ���⢥ত�� ���� �����襩 Enter. � ��-');
      Gotoxy(x2,15);
      Write('砥 ����୮�� ���������� ���� �㤥� ��ᢥ稢����� ᮮ�-');
      Gotoxy(x2,16);
      Write('�������饥 ᮮ�饭�� � 㪠������ ⨯� �訡�� � ���孥�');
      Gotoxy(x2,17);
      Write('��ப�. ��᫥ ���������� ��� ����� ����� ��ப� �� ��-');
      Gotoxy(x2,18);
      Write('३��� ���⭮ � �롮�� ����⮢ ⠡����. ��� �०-');
      Gotoxy(x2,19);
      Write('���६������ ��室� �� ०��� ஡��� � ����� ������,');
      Gotoxy(x2,20);
      Write('������ Esc. � �⮬ ��砥 �� ��������� �� ���� ��-');
      Gotoxy(x2,21);
      Write('࠭���. ��� 㤠����� ������ �� ⠡���� ��३��� � ��-');
      Gotoxy(x2,22);
      Write('��� ����� � ������ Backspace.');
      Gotoxy(x1,24);
      Write('3. �� ���������� ����� ⠡���� ����ᨯ������, � ���� ��-');
      Gotoxy(x2,25);
      Write('��ᨯ����� ������� ��࠭�祭�� �� ������⢮ ��������');
      Gotoxy(x2,26);
      Write('᫮�: �� ����� ��� (� ��砥 ������⢨� ���⢠ ��᫥');
      end;
    Procedure SecondPage;
      begin
        Gotoxy(x2,7);
        Write('����� ����� �㦥� �஡��). �����⨬ ���� ⮫쪮 ���᪨�');
        Gotoxy(x2,8);
        Write('�㪢, �� 祬 ��������� ����� ���� ⮫쪮 ��ࢠ� �㪢�');
        Gotoxy(x2,9);
        Write('������� ᫮��. ���� ��� ���������� �㪢 ����������.');
        Gotoxy(x2,10);
        Write('��� ���஢�� ������ �� 䠬���� ������ 1, �� ��������');
        Gotoxy(x2,11);
        Write('����ᨯ��� -2, �� �⠦� -3.');
      end;
    Procedure PrintPage(n:byte);
      begin
        clrscr;
        Table_Reference;
        Case n of
          1: FirstPage;
          2: SecondPage;
          end;
      end;
    begin //Content
      FirstPage;
      Page:=1;
      Gotoxy(48,28);
      Write('->',page);
      Repeat begin
        key:=Readkey;
        Case key of
        #75: If page>1 then begin
               page-=1;
               PrintPage(page);
               Gotoxy(48,28);
               Write('->',page);
             end;
        #77: If page<2 then begin
               page+=1;
               PrintPage(page);
               Gotoxy(48,28);
               Write('<-',page);
             end;
        end;
      end until key=#27;
    end;

{========================}
Procedure Member;
  begin
    y:=2;
    Gotoxy(38,2);
    Write('���������� � ��������������');
    x:=1;
    Member_top;                        {������ ��ப� ��� �������}
    Member_wall;
    Member_bot;
    Member_legend;
    Member_top;                        {⠡��� ��� ������}
    While y<>32 do Member_line;
    Member_wall;
    Member_bot;
    Insruction;
  end;

Procedure Member_top;
  begin
    y:=y+1;
    Line_top(98,5,y);
    Top_cover(60,y);
    Top_cover(91,y);
    Top_cover(1,y);
  end;
Procedure Member_wall;
  begin
    y:=y+1;;
    Wall(3,60,y);
    Wall(30,91,y);
    Wall(8,1,y);
  end;
Procedure Member_bot;
  begin
    y:=y+1;
    Line_bot(98,5,y);
    Bot_cover(60,y);
    Bot_cover(91,y);
    Bot_cover(1,y);
  end;
Procedure Member_line;
  begin
    Member_wall;
    y:=y+1;
    Line_mid(98,5,y);
    Intersection(60,y);
    Intersection(91,y);
    Intersection(1,y);
  end;
Procedure Member_legend;
  begin
    Gotoxy(3,4);
    Write('�');
    Gotoxy(23,4);
    Write('������� ��� ����⢮');
    Gotoxy(69,4);
    Write('������ ����ᨯ���');
    Gotoxy(94,4);
    Write('�⠦');
  end;
{========================}
Procedure Mistake_biker(x: byte; text: string);
  begin
    TextColor(4);
    TextBackGround(0);
    Gotoxy(x,1);
    Write(text);
    TextColor(7);
    TextBackGround(2);
  end;

Procedure Not_Saved;
  begin
    Clear_First_line(0);
    TextColor(4);
    Gotoxy(24,1);
    Write('���� �뫨 ��������� �� ��������. ��������� �� �뫨 ��࠭���');
    TextColor(7);
  end;
Procedure Clear_First_line(back_color: byte);
  begin
    TextBackGround(0);
    For i:=1 to 100 do
      begin
        Gotoxy(i,1);
        Write(' ');
      end;
    Textbackground(back_color);
  end;
{========================}
Procedure Window_to_Go_out;
  begin
    x:=34;
    y:=14;
    Line_Top(32,34,15);
    For i:=15 to 19 do Wall(32,34,i);
    Line_Bot(32,100,25);
    For y:=15 to 18 do
      For x:=35 to 66 do
        begin
          Gotoxy(x,y);
          Write(' ');
        end;
  end;
Procedure Save_Window;
  begin
    Window_to_Go_out;
    TextColor(3);
    Gotoxy(36,15);
    Write('������ ��� ��࠭塞��� 䠩��');
    TextColor(7);
    Gotoxy(35,18);
    Write('Esc-�⬥��            Enter-����');
  end;
Procedure Not_Save_Window(a: byte);
  begin
    Window_to_Go_out;
    TextColor(3);
    Gotoxy(38,15);
    Write('��� ��� ��࠭���� 䠩��?');
    Textcolor(2);
    Gotoxy(44,17);
    Write('��');
    Textcolor(7);
    Gotoxy(52,17);
    Write('���');
    Gotoxy(100,35);
  end;
Procedure Choose_open_file_Window;              {33-66,12}
  begin
    x:=33;
    y:=12;
    Line_Top(33,33,13);
    For y:=13 to 25 do Wall(33,33,y);
    Line_bot(33,33,26);
    For y:=13 to 24 do
      For x:=34 to 65 do
        begin
          Gotoxy(x,y);
          Write(' ');
        end;
  end;

end.

