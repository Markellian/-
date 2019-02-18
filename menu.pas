unit Menu;

{$mode objfpc}{$H+}

interface
Var x,y: integer;           {���न����}
    i: integer;             {��६����}
Procedure Table;
Procedure Line_top;          {���孨� ����� - 蠯��}
Procedure Line_mid;          {�।���}
Procedure Line_bot;          {������ �����}
Procedure Wall;              {������ �⥭��}
implementation
uses
  Classes, SysUtils, crt;

Procedure Line_top;   {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
  begin
    Gotoxy(x,y);
    Write(#201);
    For i:=1 to 19 do
      begin
        x:=x+1;
        Gotoxy(x,y);
        Write(#205);
      end;
    Gotoxy(x+1,y);
    Write(#187);
    x:=50;
    y:=y+1;
  end;
Procedure Line_mid;   {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
  begin
    Gotoxy(x,y);
    Write(#204);
    For i:=1 to 19 do
      begin
        x:=x+1;
        Gotoxy(x,y);
        Write(#205);
      end;
    Gotoxy(x+1,y);
    Write(#185);
    x:=50;
    y:=y+1;
  end;
Procedure Line_bot;   {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
  begin
    Gotoxy(x,y);
    Write(#200);
    For i:=1 to 19 do
      begin
        x:=x+1;
        Gotoxy(x,y);
        Write(#205);
      end;
    Gotoxy(x+1,y);
    Write(#188);
  end;
Procedure Wall;       {���� 㪠���� ��砫�� ���न����. ����� �� ����� ��ப�}
  begin
    Gotoxy(x,y);
    Write(#186);
    x:=70;
    Gotoxy(x,y);
    Write(#186);
    x:=50;
    y:=y+1;
  end;

Procedure Table;
  begin
    x:=50;
    y:=5;
    Line_top;
    Wall;
    Line_bot;


  end;

end.

