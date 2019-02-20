unit Table;

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
Procedure Top_cover(x0,y0: byte);        {������ "���誠"}
Procedure Bot_cover(x0,y0: byte);        {������ "���誠"}

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
  Procedure Member_line;
  Procedure Member_legend;

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
    Read_From(7);
    Write_in(7);
    Exit(7);
  end;

Procedure Read_From(tex: byte);      {㪠�뢠���� 梥� ⥪��}
  begin
    x:=41;
    y:=13;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('   ������ 䠩�');
  end;
Procedure Write_in(tex: byte);       {㪠�뢠���� 梥� ⥪��}
  begin
    x:=43;
    y:=15;
    Gotoxy(x,y);
    TextColor(Tex);
    Write(' ������� 䠩�');
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
    Member_top;
    Member_wall;
    Member_bot;
    Member_legend;
    Member_top;
    While y<>32 do Member_line;
    Member_wall;
    Member_bot;
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

end.

