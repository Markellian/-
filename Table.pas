unit Table;

{$mode objfpc}{$H+}

interface
Var x,y: integer;           {���न����}
    i,l: integer;           {��६����}{l-����� �����, 㪠�뢥� ���-�� ���⮣� ����}

Procedure Menu;
Procedure Line_top(l: integer);          {���孨� ����� - 蠯��}
Procedure Line_mid(l: integer);          {�।���}
Procedure Line_bot(l: integer);          {������ �����}
Procedure Wall(l: integer);              {������ �⥭��}
Procedure Read_From(tex: byte);
Procedure Write_in(tex: byte);
Procedure Exit(tex: byte);

implementation
uses
  Classes, SysUtils, crt;

Procedure Line_top(l: integer);   {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
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
    x:=40;
    y:=y+1;
  end;
Procedure Line_mid(l: integer);   {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
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
    x:=40;
    y:=y+1;
  end;
Procedure Line_bot(l: integer);   {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
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
  end;
Procedure Wall(l: integer);       {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
  begin
    Gotoxy(x,y);
    Write(#186);
    x:=x+l+1;
    Gotoxy(x,y);
    Write(#186);
    x:=40;
    y:=y+1;
  end;
Procedure Read_From(tex: byte);   {������� "�⥭�� �� 䠩��" � ����}
  begin
    x:=41;
    y:=13;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('  �⥭�� �� 䠩�� ');
  end;
Procedure Write_in(tex: byte);    {������� "������ � 䠩�" � ����}
  begin
    x:=43;
    y:=15;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('������ � 䠩�');
  end;
Procedure Exit(tex: byte);        {������� "��室" � ����}
  begin
    x:=47;
    y:=17;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('��室');
  end;

Procedure Menu;
  begin
    x:=40;
    y:=8;
    Line_top(18);
    Wall(18);
    Line_bot(18);
    x:=48;
    y:=9;
    Gotoxy(x,y);
    Write('����');
    x:=40;
    y:=12;
    Line_top(18);
    Wall(18);
    Line_mid(18);
    Wall(18);
    Line_mid(18);
    Wall(18);
    Line_bot(18);
    Read_From(7);
    Write_in(7);
    Exit(7);
  end;

end.

