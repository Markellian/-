unit Table;                      {размер консоли: 100*35} {шрифт ТОЧЕЧНЫЙ}
                                 {кодировка CP-866}
{$mode objfpc}{$H+}

interface
Var x,y: integer;           {координаты}
    i,l,x0,y0: integer;     {переменные}{l-длина линий, указывет кол-во пустого места}
                                        {x0-позиция x после процедуры}
                                        {y0-позиция y после процедуры}
{процедуры создания таблиц из псевдографики}
Procedure Line_top(l,x0,y0: byte);       {верхнии линяя - шапка}
Procedure Line_mid(l,x0,y0: byte);       {середина}
Procedure Line_bot(l,x0,y0: byte);       {нижняя линяя}
Procedure Wall(l,x0,y0: byte);           {боковые стенки}
Procedure Intersection(x0,y0: byte);     {пересечение}
Procedure Top_cover(x0,y0: byte);        {верхняя "крышка"}
Procedure Bot_cover(x0,y0: byte);        {нижняя "крышка"}
Procedure Insruction;                    {инструкция внизу консоли}

Procedure Menu;                          {создание меню "чтение\запись"}
{текст для Menu}
  Procedure Read_From(tex: byte);        {"Чтение из файла"}
  Procedure Write_in(tex: byte);         {"Запись в файл"}
  Procedure Exit(tex: byte);             {"Выход"}

Procedure Member;                        {создание таблицы "Члены клуба"}
{таблица для Member}
  Procedure Member_top;                  {Верх таблицы}
  Procedure Member_wall;                 {Строки легенды таблицы}
  Procedure Member_bot;                  {Низ таблицы}
  Procedure Member_line;                 {Строки таблицы данных}
  Procedure Member_legend;               {легенда таблицы}

implementation
uses
  Classes, SysUtils, crt;

Procedure Line_top(l,x0,y0: byte);   {надо заранее указать начальные координаты. конец задается 2 и 3-й переменными}
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
    x:=x0;
    y:=y0;
  end;
Procedure Line_mid(l,x0,y0: byte);   {надо заранее указать начальные координаты. конец задается 2 и 3-й переменными}
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
Procedure Line_bot(l,x0,y0: byte);   {надо заранее указать начальные координаты. конец задается 2 и 3-й переменными}
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
Procedure Wall(l,x0,y0: byte);       {надо заранее указать начальные координаты. конец задается 2 и 3-й переменными}
  begin
    Gotoxy(x,y);
    Write(#186);
    x:=x+l+1;
    Gotoxy(x,y);
    Write(#186);
    x:=x0;
    y:=y0;
  end;
Procedure Intersection(x0,y0: byte); {указываются конечные координаты}
  begin
    Gotoxy(x,y);
    Write(#206);
    x:=x0;
    y:=y0;
  end;
Procedure Top_cover(x0,y0: byte);    {указываются конечные координаты}
  begin
    Gotoxy(x,y);
    Write(#203);
    x:=x0;
    y:=y0;
  end;
Procedure Bot_cover(x0,y0: byte);    {указываются конечные координаты}
  begin
    Gotoxy(x,y);
    Write(#202);
    x:=x0;
    y:=y0;
  end;
Procedure Insruction;
  begin
    Gotoxy(1,35);
    Write('Управление - стрелочки');
    Gotoxy(44,35);
    Write('Выбор - Enter');
    Gotoxy(91,35);
    Write('Назад-Esc');
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
    Write('Меню');
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

Procedure Read_From(tex: byte);      {указывается цвет текста}
  begin
    x:=41;
    y:=13;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('   Открыть файл');
  end;
Procedure Write_in(tex: byte);       {указывается цвет текста}
  begin
    x:=43;
    y:=15;
    Gotoxy(x,y);
    TextColor(Tex);
    Write(' Создать файл');
  end;
Procedure Exit(tex: byte);           {указывается цвет текста}
  begin
    x:=47;
    y:=17;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('Выход');
  end;
{========================}
Procedure Member;
  begin
    y:=2;
    Gotoxy(38,2);
    Write('ИНФОРМАЦИЯ О ВЕЛОСИПЕДИСТАХ');
    x:=1;
    Member_top;                        {верхняя строка для легенды}
    Member_wall;
    Member_bot;
    Member_legend;
    Member_top;                        {таблица для данных}
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
    Write('№');
    Gotoxy(23,4);
    Write('Фамилия Имя Отчество');
    Gotoxy(69,4);
    Write('Модель велосипеда');
    Gotoxy(94,4);
    Write('Стаж');
  end;

end.

