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
  Procedure Exit(tex: byte);             {"��室"}

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
Procedure Save_Window;
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
    Wall(18,40,14);
    Line_mid(18,40,15);
    Wall(18,40,16);
    Line_mid(18,40,17);
    Wall(18,40,18);
    Line_bot(18,40,19);
    Insruction;
    Read_From(7);
    Write_in(7);
    Exit(7);
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
Procedure Exit(tex: byte);           {㪠�뢠���� 梥� ⥪��}
  begin
    x:=47;
    y:=17;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('��室');
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
Procedure Save_Window;
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
    TextColor(3);
    Gotoxy(36,15);
    Write('������ ��� ��࠭塞��� 䠩��');
    TextColor(7);
    Gotoxy(35,18);
    Write('Esc-�⬥��            Enter-����');
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

