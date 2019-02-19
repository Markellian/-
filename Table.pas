unit Table;

{$mode objfpc}{$H+}

interface
Var x,y: integer;           {координаты}
    i,l: integer;           {переменные}{l-длина линий, указывет кол-во пустого места}

Procedure Menu;
Procedure Line_top(l: integer);          {верхнии линяя - шапка}
Procedure Line_mid(l: integer);          {середина}
Procedure Line_bot(l: integer);          {нижняя линяя}
Procedure Wall(l: integer);              {боковые стенки}
Procedure Read_From(tex: byte);
Procedure Write_in(tex: byte);
Procedure Exit(tex: byte);

implementation
uses
  Classes, SysUtils, crt;

Procedure Line_top(l: integer);   {надо указать начальные координаты. конец на новой строке}
  begin
    Gotoxy(x,y);
    Write(#201);
    For i:=1 to l do               {l - длина в =, без краев}
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
Procedure Line_mid(l: integer);   {надо указать начальные координаты. конец на новой строке}
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
Procedure Line_bot(l: integer);   {надо указать начальные координаты. конец на новой строке}
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
Procedure Wall(l: integer);       {надо указать начальные координаты. конец на новой строке}
  begin
    Gotoxy(x,y);
    Write(#186);
    x:=x+l+1;
    Gotoxy(x,y);
    Write(#186);
    x:=40;
    y:=y+1;
  end;
Procedure Read_From(tex: byte);   {Надпись "Чтение из файла" в меню}
  begin
    x:=41;
    y:=13;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('  Чтение из файла ');
  end;
Procedure Write_in(tex: byte);    {Надпись "Запись в файл" в меню}
  begin
    x:=43;
    y:=15;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('Запись в файл');
  end;
Procedure Exit(tex: byte);        {Надпись "выход" в меню}
  begin
    x:=47;
    y:=17;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('Выход');
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
    Write('Меню');
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

