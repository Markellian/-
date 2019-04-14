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
Procedure Insruction;                    {инструкция внизу консоли}

Procedure Menu;                          {создание меню "чтение\запись"}
{текст для Menu}
  Procedure Read_From(tex: byte);        {"Чтение из файла"}
  Procedure Write_in(tex: byte);         {"Запись в файл"}
  Procedure Delete_File(tex: byte);      {"Удалить файд"}
  Procedure Reference(tex: byte);        {"Справка"}
  Procedure Exit(tex: byte);             {"Выход"}

  Procedure Table_Reference;             {Таблица для саправки}
  Procedure Content;                     {Данные справки}

Procedure Member;                        {создание таблицы "Члены клуба"}
{таблица для Member}
  Procedure Member_top;                  {Верх таблицы}
  Procedure Member_wall;                 {Строки легенды таблицы}
  Procedure Member_bot;                  {Низ таблицы}
  Procedure Member_line;                 {Строки таблицы данных}
  Procedure Member_legend;               {легенда таблицы}

{Ошибки заполнения}
  Procedure Mistake_biker(x: byte; text: string);          {неверный формат заполнения таблицы Велосипедист}

Procedure Not_Saved;
Procedure Clear_First_line(back_color: byte);   {Очищение первой строки после информации об ошибках}
{Сохранить файл}
Procedure Window_to_Go_out;
Procedure Save_Window;
Procedure Not_Save_Window(a: byte);
Procedure Choose_open_file_Window;
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
    Write('Меню');
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

Procedure Read_From(tex: byte);      {указывается цвет текста}
  begin
    x:=44;
    y:=13;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('Открыть файл');
  end;
Procedure Write_in(tex: byte);       {указывается цвет текста}
  begin
    x:=44;
    y:=15;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('Создать файл');
  end;
Procedure Delete_File(tex: byte);
  begin
    x:=44;
    y:=17;
    Gotoxy(x,y);
    TextColor(tex);
    Write('Удалить файл');
  end;
Procedure Reference(tex: byte);
  begin
    x:=46;
    y:=19;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('Справка');
  end;
Procedure Exit(tex: byte);           {указывается цвет текста}
  begin
    x:=47;
    y:=21;
    Gotoxy(x,y);
    TextColor(Tex);
    Write('Выход');
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
    Write('ИНСТРУКЦИЯ');
  end;
Procedure Content;
    const x1=21;
          x2=24;
    Var key: char;
        page: byte;
    Procedure FirstPage;
      begin
      Gotoxy(x1,7);
      Write('1. Для выбора пункта в меню и строки в таблицах использу-');
      Gotoxy(x2,8);
      Write('ются стрелочки. Для выбора/изменения выбранного Вами');
      Gotoxy(x2,9);
      Write('поля нажмите Enter. Для выхода из текущего этапа работы');
      Gotoxy(x2,10);
      Write('с элементом программы нажмите клавишу Esc.');
      Gotoxy(x1,12);
      Write('2. При работе с таблицей для изменения поля перейдите к');
      Gotoxy(x2,13);
      Write('интересующему Вас полю и нажмите Enter. Последовательно');
      Gotoxy(x2,14);
      Write('изменяйте поля, подтверждая ввод клавишей Enter. В слу-');
      Gotoxy(x2,15);
      Write('чае неверного заполнения поля будет высвечиваться соот-');
      Gotoxy(x2,16);
      Write('ветствующее сообщение с указанием типа ошибки в верхней');
      Gotoxy(x2,17);
      Write('строке. После заполнения всех полей одной строки вы пе-');
      Gotoxy(x2,18);
      Write('рейдете обратно к выбору элеметнтов таблицы. Для преж-');
      Gotoxy(x2,19);
      Write('девременного выхода из режима роботы с полем данных,');
      Gotoxy(x2,20);
      Write('нажмите Esc. В этом случае все изменения не будут сох-');
      Gotoxy(x2,21);
      Write('ранены. Для удаления данных из таблицы перейдите к нуж-');
      Gotoxy(x2,22);
      Write('ной линии и нажмите Backspace.');
      Gotoxy(x1,24);
      Write('3. При заполнении полей таблицы Велосипедисты, в поле Ве-');
      Gotoxy(x2,25);
      Write('лосипедист имеется ограничение на количество введеных');
      Gotoxy(x2,26);
      Write('слов: не более трех (в случае отсутствия очества после');
      end;
    Procedure SecondPage;
      begin
        Gotoxy(x2,7);
        Write('ввода имени нужен пробел). Допустим ввод только русских');
        Gotoxy(x2,8);
        Write('букв, при чем заглавной может быть только первая буква');
        Gotoxy(x2,9);
        Write('каждого слова. Ввод трех одинаковых букв невозможен.');
        Gotoxy(x2,10);
        Write('Для сортировки данных по фамилии введите 1, по названию');
        Gotoxy(x2,11);
        Write('велосипеда -2, по стажу -3.');
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
    Write('Поля были заполнены не полность. Изменения НЕ были сохранены');
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
    Write('Укажите имя сохраняемого файла');
    TextColor(7);
    Gotoxy(35,18);
    Write('Esc-отмена            Enter-ввод');
  end;
Procedure Not_Save_Window(a: byte);
  begin
    Window_to_Go_out;
    TextColor(3);
    Gotoxy(38,15);
    Write('Выйти без сохранения файла?');
    Textcolor(2);
    Gotoxy(44,17);
    Write('Да');
    Textcolor(7);
    Gotoxy(52,17);
    Write('Нет');
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

