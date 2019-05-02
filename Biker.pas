unit Biker;

{$mode objfpc}{$H+}

  interface
  uses
      Classes, SysUtils, crt, Table, Choice;
Type Class1 = class
  protected
 type   Element = record
               El: string;
               number: byte;
               Next,Last: ^Element;
             end;
        list= ^Element;
        Draw_table= procedure;
        myproc=procedure (y,color: byte; text: list) of object;
        Const First_Line=7;
          Last_line=33;
          Number_line_on_screen=14;
          Max_lines=100;

  var Eng_big,Eng_small,Figure,Rus_big,Rus_small,symbol: set of char;   //набор переменных для фильтрации символов при заполнении полей
      proc: myproc;                        //для процедуры заполнения строк в подклассах. Это нужно для вызова родительских процедур вне зависимости от различий двух таблиц
      draw: Draw_table;                    //для процедуры рисования таблиц в подклассах. Это нужно для вызова родительских процедур вне зависимости от различий двух таблиц
      State_biker: string;                 //для заполнения полей
      First,Now,Past,Last_Now: list;       //главные указатели
      buf: array [byte] of byte;           //массив символов для записи и чтения в/из файла
       Number_Line: byte;                  //количество линий(с данными)
        f: file;                           //ФАЙЛ
        f1: text;                          //для работы с файлом, где хранятся названия файлов таблицы
        m: array [byte] of char;           //для ввода посимвольно
        a: byte;                           //счетчик элементов массива
        State: string;                     //переменная для конечного автомата в главной процедуре
        Step: char;                        //для конечного автомата управляющей процедуры
        k: string;                         //строка, в которую идет запись данных.
        misstake: boolean;                 //есть ли наличие ошибок, чтобы после их стереть
  Function Enter_char: char;
  Function Enter_symbol: char;
  Procedure Full_alfavit;
  Procedure Create_list(n:byte);
  Procedure Add_to_File(n: byte;File_: string; First1: List);
  Procedure Read_Biker(n: byte; Open_file:string);
  Procedure Full_line(last_position:string; line: myproc);
  Procedure Backspace_input;
  Procedure Was_Choosed_Up;
  Procedure Was_Choosed_Down(n:byte);
  Procedure Was_Choosed_BackSpace(n:byte;NowTable: Draw_table);
  Procedure Sort(Parameter: string);
  Procedure Was_Choosed_Esc(File_of_Files, Filik, if_not_name_of_file: string; n: byte; NowTable: Draw_table);
  Procedure Was_Choosed_Search(find: list);
  end;

Type Member_club = class (Class1)
protected
Type Info=record
              FIO: string;                     {ФОИ}
              Bike: string;                    {Название велосипеда}
              experience: string;              {стаж}
            end;
       const Spisok_of_Files='All_Files.txt';
             Standart_file='Велосипедисты';
             Cash_File='Последний файл';
             start_bike=55;
             start_exp=85;
             max_buf=93;
  Var Cash: Info;                         {для предворительного сохранения данных до полного заполнения стороки Велосипедист}
      Word: 1..3;                         {количество слов для поля ФИО и Велосипед}
  public
    Constructor Create;
    Function Input: boolean;
    Procedure Write_Biker_Line;
    Procedure Biker_line(y,color: byte; text: list);
    Procedure Write_Biker(Filik: string);
end;

Type Randonnee = class (Class1)
  protected
  Type Info=record
              Name: string;                     {ФОИ}
              Distance: string;                    {Название велосипеда}
              Date: string;              {стаж}
              Duration: string;                    {номер в списке}
            end;
       const Spisok_of_Files='All_File.txt';
             Standart_file='Покатушки';
             Cash_File='Последний_файл';
             start_name=1;
             start_distance=47;
             start_date=62;
             start_duration=77;
             max_buf=92;
  Var Cash: Info;
  public
    Constructor Create;
    Procedure Bicycle_line(y,color: byte; text: list);
    Procedure Write_Bicycle_line;
    Procedure Write_Randonnee(Filik: string);
end;

implementation
Function  Class1.Enter_char: char;            //Readkey с фильтром на ввод управляющих клавиш
  Var c: char;
  begin
    c:=Readkey;
    If c=#0 then Result:=Readkey
      else If (c=#13)or(c=#27)or(c=#8)or(c in figure) then Result:=c;
  end;
Function  Class1.Enter_symbol:char;           //Readkey с фильтром на ввод знаковых символов
  Var c: char;
  begin
    c:=Readkey;
    If c<>#0 then Result:=c else Readkey;
  end;
Procedure Class1.Full_alfavit;                //заполнение переменных буквами и цифрами
    begin
      Eng_big:=['A'..'Z'];
      Eng_small:=['a'..'z'];
      Figure:=['0'..'9'];
      Rus_big:=['А'..'Я'];
      Rus_small:=['а'..'я'];
      symbol:=[' ','!','@','"',',','.','*','/','?','\','|','#','$','%','^','&','(',')','-','_','+','='];
    end;
Procedure Class1.Create_list(n:byte);         //создание начального списка из 1 элемента. n-число байт в элементе
  begin
    Number_line:=0;
      new(First);
      If First=Nil then Mistake_biker(40,'НЕДОСТАТОЧНО ПАМЯТИ') else begin
        First^.Next:=Nil;
        First^.number:=1;;
        For i:=1 to n do First^.El+=' ';
        New(Now);
        Now^.number:=0;
        Now^.Next:=First;
        First^.Last:=Now;
        Now:=First;
      end;
  end;
Procedure Class1.Add_to_file(n: byte;File_: string; First1: List);                //сохранение данных в файл. n-число быйтов
  Var fil: file;
  begin
    AssignFile(fil,File_);
    {$I-}
    if IOResult <> 0 then begin
      gotoxy(45,15);
      TextColor(4);
      TextBackGround(7);
      writeln ('ФАЙЛ НЕ НАЙДЕН!');
      Readln();
      TextColor(7);
      TextBackGround(0);
      State:='Done';
      end
    else begin
    Rewrite(fil,n);
    While First1<> Nil do begin
      For i:=1 to n do buf[i]:=ord(First1^.El[i]);
      BlockWrite(fil,buf,1);
      First1:=First1^.Next;
      end;
    CloseFile(fil);
    end;
    {$I+}
  end;
Procedure Class1.Read_Biker(n: byte; Open_file:string);                           //чтение из файла. n-число байт
  begin //Read_Biker
    AssignFile(f,Open_file);
    {$I-}
    if IOResult <> 0 then begin
      gotoxy(45,15);
      TextColor(4);
      TextBackGround(7);
      writeln ('ФАЙЛ НЕ НАЙДЕН!');
      Readln();
      TextColor(7);
      TextBackGround(0);
      State:='Done';
      end
      else begin
    Reset(f,n);
    Repeat begin
      BlockRead(f,buf,1);
      For i:=1 to n do k+=chr(buf[i]);
      Number_line+=1;
      Now^.El:=k;
      Now^.number:=Number_line;
      Last_Now:=Now;
      new(Now);
      Last_Now^.Next:=Now;
      Now^.Last:=Last_Now;
      k:='';
    end until (Number_line=100)or(eof(f));
    Dispose(Now);
    Now:=Last_now;
    Now^.Next:=Nil;
    CloseFile(f);
      end;
      {$I+}
  end;
Procedure Class1.Full_line(last_position:string; line: myproc);                   //заполнение всех полей в таблице
  begin
    y:=First_Line-2;
    Now:=Past^.Last;
    While (Now^.Next<>Nil)and(Now^.number<>Past^.number+Number_line_on_screen-1) do
      begin
        Now:=Now^.Next;
        y+=2;
        line(y,0,Now);
      end;
    If last_position='up'
      then begin
        Now:=Past;
        y:=First_Line;
      end else If last_position='up' then
        While Now^.Next<>Nil do
          begin
            Now:=Now^.Next;
            y+=2;
          end;
  end;
Procedure Class1.Backspace_input;                                                 //введена клавиша Backspace
  begin
    a:=a-1;
    m[a]:=' ';
    Write(m[a]);
    a:=a-1;
  end;
Procedure Class1.Was_Choosed_Up;                                                  //введена стрелочка вверх
  begin
    If (Now<>First)and(y=First_line)
      then begin
        Past:=Past^.Last;
        Full_line('up',proc);
      end
      else If (y>First_line)
        then begin
          proc(y,0,Now);
          y-=2;
          Now:=Now^.Last;
        end
        else If Now=First then
          begin
            While Now^.Next<>Nil do Now:=Now^.Next;
            If Now^.number>Number_line_on_screen
              then begin
                Past:=Now;
                While (Past^.number>(Number_line-Number_line_on_screen+1))and(Past<>First) do Past:=Past^.Last;
                Full_Line('down',proc);
              end
            else begin
              proc(First_Line,0,First);
              y:=(Now^.number-1)*2+First_line;
            end;
          end;
  end;
Procedure Class1.Was_Choosed_Down(n: byte);                                       //введена стрелочка вниз.n-для заполнения нового элемента пробелами
  Procedure LastLine;           {последння линяя таблицы}
  begin //LastLine
   If Now^.number=Max_lines
     then begin
        Past:=First;
        Full_line('up',proc);
     end
     else If (Now^.Next=Nil)and(Now^.El[1]<>' ')and(Number_Line<Max_lines)
       then begin
          Last_Now:=Now;
          New(Now);
          If Now=Nil then Mistake_biker(40,'НЕДОСТАТОЧНО ПАМЯТИ') else begin
            Last_Now^.Next:=Now;
            Now^.Last:=Last_Now;
            Now^.Next:=Nil;
            Number_line+=1;
            Now^.number:=Number_line;
            For i:=1 to n do Now^.el+=' ';
            Past:=Past^.Next;
          end;
          Full_line('down',proc);
       end
       else If (Now^.Next<>Nil)and(Now^.number<Max_lines)
         then begin
           Past:=Past^.Next;
           Full_line('down',proc);
         end
         else If (Now^.Next=Nil)and(Now^.number<=Max_lines)and(Now^.El[1]=' ') then
           begin
             Past:=First;
             Full_line('up',proc);
           end;
  end;
  Procedure NotLastLine;        {не последняя линия}
    begin //NotLastLine
     If (Now^.Next=Nil)and(Now^.El[1]<>' ')and(Number_Line<Max_lines)
       then begin
         proc(y,0,Now);
         y+=2;
         Last_Now:=Now;
         New(Now);
         If Now=Nil then Mistake_biker(40,'НЕДОСТАТОЧНО ПАМЯТИ') else begin
           Last_Now^.Next:=Now;
           Now^.Last:=Last_Now;
           Now^.Next:=Nil;
           For i:=1 to n do Now^.el+=' ';
           Now^.number:=Now^.Last^.number+1;
           number_line+=1;
         end;
         If Now^.number>Number_line then Full_line('now',proc);
       end
       else If (Now^.Next<>Nil)
         then begin
           proc(y,0,Now);
           y+=2;
           Now:=Now^.Next;
         end
         else If (Now^.Next=Nil)and(Now^.number<Max_lines)and(Now^.El[1]=' ') then
           begin
             proc(y,0,Now);
             Now:=Past;
             y:=First_line;
           end;
    end;
begin //Was_Choosed_Down
  If y=Last_Line then LastLine else NotLastLine;
end;
Procedure Class1.Was_Choosed_BackSpace(n:byte; NowTable: Draw_table);             //удаление элемента из списка. n-кол-во байт, для создания списка в случае, если удален 1 элемент списка.
  Procedure Delete_Element_of_list;
    Var Last_now: list;
    begin //Delete_Element_of_list
      If First=Now
        then If First^.Next<>Nil
          then begin                         {First=Now; First^.Next<>Nil}
            First:=First^.Next;
            Dispose(Now^.Last);
            Now^.Last:=Nil;
            Past:=First;
            Now:=First;
            Now^.last^.number:=0;
          end else begin                         {First=Now; First^.Next=Nil}
            Dispose(First^.Last);
            Dispose(First);
            Create_list(n);
            Now:=Now^.Last;
          end
        else begin
          If Now=Past then Past:=Past^.Last;
          If Now^.Next<>Nil then begin                         {First<>Now; Now^.Next<>Nil}
            Now^.Last^.Next:=Now^.Next;
            Now^.Next^.Last:=Now^.Last;
            Last_now:=now;
            Now:=Now^.Last;
            Dispose(Last_now);
          end else begin                         {First<>Now; Now^.Next=Nil}
            Now:=Now^.Last;
            Dispose(Now^.Next);
            Now^.Next:=Nil;
          end;
        end;
    end;
  begin //Was_Choosed_BackSpace
    Delete_Element_of_list;
    Number_line-=1;
    While Now<>Nil do
      begin
        Now^.number:=Now^.Last^.number+1;
        Now:=Now^.Next;
      end;
    TextBackGround(0);
    clrscr;
    NowTable;
    Full_line('up',proc);
  end;
Procedure Class1.Sort(Parameter: string);                                         //сортировка данных по полям.
  Procedure Change;
    begin //Change
      k:=Now^.El;
      Now^.el:=Past^.el;
      Past^.el:=k;
    end;
    begin //Sort
      Past:=First;
      While Past^.Next<>NIL do begin
        Now:=Past^.Next;
        Repeat begin
          If (Parameter='FIO')and(Copy(Past^.el,1,54)>Copy(Now^.el,1,54))and(Now^.el[1]<>' ') then Change;
          IF (Parameter='Bike')and(Copy(Past^.el,55,30)>Copy(Now^.el,55,30))and(Now^.el[1]<>' ') then Change;
          If (Parameter='Exp')and(Copy(Past^.el,85,8)>Copy(Now^.el,85,8))and(Now^.el[1]<>' ') then Change;

          If (Parameter='Name')and(Copy(Past^.el,1,46)>Copy(Now^.el,1,46))and(Now^.el[1]<>' ') then Change;
          IF (Parameter='Dis')and(Copy(Past^.el,47,15)>Copy(Now^.el,47,15))and(Now^.el[1]<>' ') then Change;
          If (Parameter='Date')then
            If (Copy(Past^.el,72,4)>Copy(Now^.el,72,4))and(Now^.el[1]<>' ') then Change
              else If (Copy(Past^.el,72,4)=Copy(Now^.el,72,4))and (Copy(Past^.el,69,2)>Copy(Now^.el,69,2))and(Now^.el[1]<>' ') then Change
                else If (Copy(Past^.el,72,4)=Copy(Now^.el,72,4))and (Copy(Past^.el,69,2)>Copy(Now^.el,69,2))and(Copy(Past^.el,66,2)>Copy(Now^.el,66,2))and(Now^.el[1]<>' ')then Change;
          If (Parameter='Dur')and(Copy(Past^.el,77,15)>Copy(Now^.el,77,15))and(Now^.el[1]<>' ') then Change;
          Now:=Now^.Next;
        end until Now=Nil;
        Past:=Past^.Next;
      end;
      Past:=First;
      Full_Line('up',proc);
    end;
Procedure Class1.Was_Choosed_Esc(File_of_Files, Filik, if_not_name_of_file: string; n: byte; NowTable: Draw_table);
  const x=35;
        max_symbol=33;
  Procedure Write_all_lines_in_file;             //запись данных в файлы
    Var i: byte;
        k: string;
    Function Proverka: boolean;
      Var m: array [byte] of string;
          num: byte;
      begin  //Proverka
        Reset(f1);
        num:=0;
        While not EoF(f1) do begin
           num:=num+1;
           Readln(f1,m[num]);
        end;
        i:=0;
        Result:=true;
        While (Result)and(i<num) do begin
          i+=1;
          If k=m[i] then Result:=false;
        end;
        CloseFile(f1);
      end;
    begin //Write_all_lines_in_file
      k:='';
      For i:=1 to a-1 do k+=m[i];
      If k='' then k:=if_not_name_of_file;
      AssignFile(f1,File_of_Files);
      {$I-}
    if IOResult <> 0 then begin
      gotoxy(45,15);
      TextColor(4);
      TextBackGround(7);
      writeln ('ФАЙЛ НЕ НАЙДЕН!');
      Readln();
      TextColor(7);
      TextBackGround(0);
      State:='Done';
        end
        else begin
      State:='Done';
      If Proverka then begin
        Append(f1);
        Writeln(f1,k);
        CloseFile(f1);
        Add_to_file(n,k,First);
        State:='Done';
       end
       else begin
         If Filik='New' then
           If Go_out_with_out_save_file('File_is') then begin
             Add_to_file(n,k,First);
             State:='Done';
             end
             else Was_Choosed_Esc(File_of_Files, Filik, if_not_name_of_file, n, NowTable);
       end;
     end;{$I-}
    end;
  Procedure Write_name_of_file;                //ввод названия файла
    Var y: byte;
    begin //Write_name_of_file
      TextColor(2);
      y:=17;
      If Filik<>'New'
        then begin
          For i:=1 to Length(Filik) do m[i]:=Filik[i];
          a:=Length(Filik);
          Gotoxy(x,y);
          Write(Filik);
        end else a:=0;
      Repeat begin
        If a<max_symbol then
          begin
            Gotoxy(a+x,y);
            a:=a+1;
            Repeat m[a]:=Enter_symbol until (m[a] in Eng_big)or(m[a] in Eng_small)
                                     or(m[a] in Figure)or(m[a] in Rus_big)
                                     or(m[a] in Rus_small)or(m[a]=#8)or(m[a]=#13)
                                     or(m[a]=#27)or(m[a] in symbol);
          end
          else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
          If m[a]=#8 then
            If a=1 then a-=1
              else begin Gotoxy(a+x-2,y); Backspace_input; end;
          If (a>0)and(a<max_symbol) then
            begin
              Gotoxy(a+x-1,y);
              Write(m[a]);
            end;
      end until (m[a]=#27)or(m[a]=#13);
      TextColor(7);
    end;
begin //Was_Choosed_Esc
  TextBackGround(0);
  Working_Window(' Введите имя сохраняемого файла');
  Write_name_of_file;
  If m[a]=#27
    then begin
      If Choice.Go_out_with_out_save_file('Go_out') then State:='Done'
        else begin
           State:='Chose';
           clrscr;
           NowTable;
           Full_line('up',proc);
        end;
    end;
  If m[a]=#13 then Write_all_lines_in_file;
end;
//введена клавиша Esc. 1 переменная - исходный файл, в котором хранится список всех файлов. 2-сам файл, с которым идет работа, 3-имя файла, если иммя не введено пользователем
//4 - кол-во байт для записи в файл, 5-процедура рисования таблицы
Procedure Class1.Was_Choosed_Search(find: list);
  const max_symbol=33;
  Procedure Write_name_of_find;
    begin
      TextColor(2);
      y:=17;
      a:=0;
      Repeat begin
        If a<max_symbol then
          begin
            Gotoxy(a+35,y);
            a:=a+1;
            Repeat m[a]:=Enter_symbol until (m[a] in Eng_big)or(m[a] in Eng_small)
                                     or(m[a] in Figure)or(m[a] in Rus_big)
                                     or(m[a] in Rus_small)or(m[a]=#8)or(m[a]=#13)
                                     or(m[a]=#27)or(m[a] in symbol);
          end
          else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
          If misstake then begin
            Clear_First_line(2);               {стирание сообщения об ошибке}
            misstake:=false;
            TextBackGround(0);
            TextColor(2);
          end;
          If m[a]=#8 then
            If a=1 then a-=1
              else begin Gotoxy(a+33,y); Backspace_input; end;
          If (a>0)and(a<max_symbol) then
            begin
              Gotoxy(a+34,y);
              Write(m[a]);
            end;
          If (m[a]=#13)and(a=1) then begin
            misstake:=true;
            Mistake_biker(40,'НЕВЕРНЫЕ ДАННЫЕ ПОИСКА');
            a-=1;
          end;
      end until (m[a]=#27)or((m[a]=#13)and(not misstake));
      TextColor(7);
    end;
  begin
    TextBackGround(0);
    Working_Window('  Поиск данных по первому полю');
    Write_name_of_find;
    If m[a]=#27 then State:='Chose';
    If m[a]=#13 then begin
      k:='';
      For i:=1 to a-1 do k+=m[i];
      find:=find^.Last;
      Repeat begin
        find:=find^.Next;
        a:=pos(k, find^.el);
      end until (find^.Next=Nil)or(a=1);
      If (a=1)and(find^.El[1]<>' ') then past:=find;
    end;
    clrscr;
    draw;
    Full_line('up',proc);
  end;


Constructor Member_club.Create;                                    //конструктор
    begin
      Create_list(max_buf);
      Full_alfavit;
      proc:=@Biker_line;
      draw:=@Member;
    end;
Function  Member_club.Input: boolean;                              //проверка введеных символов при заполнениии ФИО
    Var mistake: string;
    Procedure Three_identical_letters;
      begin
        If (a>=3) then
          If ((m[a-2]=m[a-1])and(m[a-1]=m[a]))or((Chr(Ord(m[a-2])+32)=m[a-1])and(m[a-1]=m[a]))or((Chr(Ord(m[a-2])+80)=m[a-1])and(m[a-1]=m[a])) {фильтр на ввод трех одинаковых букв}
            then begin
              Mistake:='two_identical_letters';
              Result:=false;
            end;
      end;
    begin //Input
      Result:=false;
      Case m[a] of
      'А'..'Я': begin
                  Result:=True;
                  If (a<>1)and(m[a-1]<>' ')
                    then If Ord(m[a])<=143
                      then m[a]:=Chr(Ord(m[a])+32)
                      else m[a]:=Chr(Ord(m[a])+80);
                  Three_identical_letters;
                end;
      'а'..'я': begin
                  Result:=true;
                  If (a=1)or(m[a-1]=' ') then
                    If Ord(m[a])<200
                      then m[a]:=Chr(Ord(m[a])-32)
                      else m[a]:=Chr(Ord(m[a])-80);
                  Three_identical_letters;
                end;
      'A'..'Z','a'..'z': Mistake:='only_russian_letters';
      ' ': If ((a<>1)and(a<>2)and(a<>3)and(m[a-3]<>m[a])and(m[a-2]<>m[a])and(m[a-1]<>m[a]))     {между пробелами не меньше 3х знаков}
             then If Word<3                                                   {количество слов не больше 3}
               then Result:=true
               else Mistake:='max_words'
             else If Mistake='' then Mistake:='word_length';
      #8,#27,#13: begin
                    Result:=true;
                    If (m[a]=#8)and(a<=1) then Result:=false;
                  end;
      '0'..'9': begin
                  Result:=false;
                  Mistake:='numbers';
                end;
      end;
    Case mistake of
      'only_russian_letters': misstake:=Mistake_biker(37,'ДОПУСТИМЫ ТОЛЬКО РУССКИЕ БУКВЫ');
      'max_words': misstake:=Mistake_biker(32,'КОЛИЧЕСТВО СЛОВ НЕ МОЖЕТ БЫТЬ БОЛЬШЕ ТРЕХ');
      'word_length': misstake:=Mistake_biker(32,'ДЛИНА СЛОВА НЕ МОЖЕТ БЫТЬ МЕНЬШЕ ТРЕХ БУКВ');
      'two_identical_letters': misstake:=Mistake_biker(34,'ВВОД ТРЕХ ОДИНАКОВЫХ БУКВ НЕДОПУСТИМ');
      'numbers': misstake:=Mistake_biker(41,'ВВОД ЦИФР  НЕДОПУСТИМ')
    end;
    TextBackGround(2);
  end;
Procedure Member_club.Write_Biker_Line;                            //заполнение данных
  Procedure FIO_change(y,color: byte; text: string);               //изменение цвета поля ФИО
    begin
      Textbackground(color);
      Gotoxy(6,y);
      Write(text);
    end;
  Procedure Bike_change(y,color: byte; text: string);              //Изменение цвета поля Велосипед
    begin
      Textbackground(color);
      Gotoxy(61,y);
      Write(text);
    end;
  Procedure Expirience_change(y,color: byte; text: string);        //изменение поля Стаж
    begin
      Textbackground(color);
      Gotoxy(92,y);
      Write(text);
    end;
  Procedure FIO;                                                   //управляющая процедура заполнения ФИО
    Procedure Do_FIO;                                             //обработка правильности ввода
      Procedure Write_Biker_FIO(y: byte);                         //ввод данных
        begin
          FIO_change(y,2,Cash.FIO);
          Bike_change(y,0,Cash.Bike);
          Expirience_change(y,0,Cash.experience);
          Repeat begin
            If a<start_bike
              then begin
                Gotoxy(a+6,y);
                a:=a+1;
                Repeat
                  begin
                    m[a]:=Enter_symbol;
                    If misstake then begin
                      Clear_First_line(2);               {стирание сообщения об ошибке}
                      misstake:=false;
                    end;
                  end until Input;
              end
              else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
            If m[a]=' ' then Word+=1;;
            If m[a]=#8 then begin
              Gotoxy(a+4,y);
              If m[a-1]=' ' then Word-=1;
              Backspace_input;
              Cash.Fio[a+1]:=' ';
              end;
            If (a>0)and(a<start_bike)and(m[a]<>#27)and(m[a]<>#13) then
              begin
                Cash.Fio[a]:=m[a];
                Gotoxy(a+5,y);
                Write(m[a]);
              end;
          end until (m[a]=#27)or(m[a]=#13);
        end;
    begin  //Do_FIO
      Write_Biker_FIO(y);
      If m[a]=#13 then
        begin
          If Word<>3
            then begin
              Table.Mistake_biker(32,'НЕВЕРНЫЙ ФОРМАТ ЗАПОЛНЕНИЯ ПОЛЯ ФИО');
              State_biker:='Do FIO';
            end
            else State_biker:='Do Bike';
        end;
      If m[a]=#27 then
        begin
          If Word<>3 then Not_Saved;
          State_biker:='Done';
        end;
    end;
  begin //FIO
    Cash.FIO:=Copy(Now^.El,1,start_bike-1);
    Cash.Bike:=Copy(Now^.El,start_bike,30);
    Cash.experience:=Copy(Now^.El,start_exp,8);
    a:=0;
    For i:=1 to start_bike-1 do m[i]:=Cash.Fio[i];
    If Now^.El[1]<>' ' then begin
        Repeat a+=1 until (a=start_bike-1)or((Cash.FIO[a]=' ')and(Cash.Fio[a+1]=' '));
        a-=1;
        Word:=3;
      end
      else begin
        a:=0;
        Word:=1;
      end;
    Do_FIO;
  end;
  Procedure Bike;                                                  //Управляющая процедура заполнения Велосипед
    Procedure Do_Bike;                         //обработка ввода
      Procedure Write_Biker_Bike(y: byte);     //ввод данных
        begin
          FIO_change(y,0,Cash.FIO);
          Bike_change(y,2,Cash.Bike);
          Repeat begin
            If a<31
              then begin
                Gotoxy(a+61,y);
                a:=a+1;
                Repeat m[a]:=Enter_symbol until (m[a] in Rus_big)or(m[a] in Rus_small)or(m[a] in Eng_big)or(m[a] in Eng_small)or(m[a] in Figure)or(m[a]='-')or(m[a]='_')or((m[a]=#8)and(a>1))or((m[a]=#13)and(a>3))or(m[a]=#27);
                If misstake then begin
                      Clear_First_line(2);               {стирание сообщения об ошибке}
                      misstake:=false;
                    end;
              end
              else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
            If (m[a]=' ')or(m[a]='-')or(m[a]='_') then Word+=1;
            If (m[a]=#8)and(a>1) then begin Gotoxy(a+59,y); Backspace_input; end;
            If (a>=5)and(m[a] in Figure)and(m[a-1] in Figure)and(m[a-2] in Figure)and(m[a-3] in Figure)and(m[a-4] in Figure)and(m[a-5] in Figure)
                then begin
                  a-=1;
                  misstake:=Mistake_biker(34,'ВВОД ШЕСТИ ЦИФР ПОДРЯД НЕДОПУСТИМ');
                  TextBackGround(2);
                end;
            If (a>0)and(a<31) then
              begin
                Gotoxy(a+60,y);
                Write(m[a]);
              end;

          end until (m[a]=#27)or(m[a]=#13);
        end;
    Var i: byte;
    begin //Do_Bike
      Write_Biker_Bike(y);
      If m[a]=#13 then
        begin
          If a<=3
            then Table.Mistake_biker(29,'НЕВЕРНЫЙ ФОРМАТ ЗАПОЛНЕНИЯ ПОЛЯ "МОДЕЛЬ ВЕЛОСИПЕДА"')
            else begin
              Cash.Bike:='';
              For i:=1 to a-1 do Cash.Bike+=m[i];
              i:=a-1;
              While i<>30 do begin
                Cash.Bike+=' ';
                i+=1;
              end;
              State_biker:='Do Experience';
            end;
        end;
      If m[a]=#27 then
        begin
          If a<3 then Not_Saved;
          State_biker:='Done';
        end;
    end;
  begin //Bike
    If Now^.El[1]<>' '
      then begin
      a:=0;
        Repeat begin
          a+=1;
          m[a]:=Cash.Bike[a];
        end until (a=30)or((Cash.Bike[a]=' ')and(Cash.Bike[a+1]=' '));
        a-=1;
        Word:=1;
      end
      else begin
        a:=0;
        Word:=1;
      end;
    Do_Bike;
  end;
  Procedure Experience;                                            //Управляющая процедура заполнения Стаж
    Procedure Do_Experience;                      //обработка данных
      Procedure Write_Biker_Experience(y:byte);   //ввод данных
        begin
          Repeat begin
            Gotoxy(a+92,y);
            If a<3
              then begin
                a:=a+1;
                Repeat m[a]:=Enter_symbol until ((m[a] in Figure)or((m[a]=#8)and(a>1))or(m[a]=#13)or(m[a]=#27));
                If misstake then begin
                      Clear_First_line(2);               {стирание сообщения об ошибке}
                      misstake:=false;
                    end;
              end
              else begin
                a:=4;
                Repeat   m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
              end;
            If m[a]=#8 then begin a:=a-1; m[a]:=' '; a:=a-1; end;
            If (a<4)and(m[a]<>#13) then
              begin
                Expirience_change(y,2,'        ');
                Gotoxy(92,y);
                If a=0 then Write(' мес.')
                  else If a=1 then Write(m[1],' мес.')
                    else If a=2 then Write(m[1],m[2],' мес.')
                      else Write(m[1],m[2],m[3],' мес.')
              end;
          end until (m[a]=#27)or(m[a]=#13);
        end;
    begin //Do_Experience
      Write_Biker_Experience(y);
      If m[a]=#13 then
        begin
          TextBackGround(0);
          If m[1]=#13 then Cash.experience:='  0'
            else if m[2]=#13 then Cash.experience:='  '+m[1]
                  else If m[3]=#13 then Cash.experience:=' '+m[1]+m[2]
                    else Cash.experience:=m[1]+m[2]+m[3];
              Cash.experience+=' мес.';
              State_biker:='Save biker';
        end;
      If m[a]=#27 then
        begin
          If a<1 then Not_Saved;
          State_biker:='Done';
        end;
    end;
  Var i: byte;
  begin //Experience
    Bike_change(y,0,Cash.Bike);
    If Now^.el[1]<>' ' then
      If Cash.experience[1]<>' ' then begin
      For i:=1 to 3 do m[i]:=Cash.experience[i];
      Expirience_change(y,2,Cash.experience);
      a:=3;
      end
      else If Cash.experience[2]<>' ' then begin
        For i:=1 to 2 do m[i]:= Cash.experience[i+1];
        Expirience_change(y,2,m[1]+m[2]+' мес. ');
        a:=2;
        end
        else begin
          m[1]:=Cash.experience[3];
          Expirience_change(y,2,m[1]+' мес.  ');
          a:=1;
        end
    else begin
      a:=0;
      Expirience_change(y,2,' мес.   ');
    end;
    Do_Experience;
  end;
  Procedure Save_Cash;                                             //сохранение данных
    begin
      Now^.El:=Cash.FIO;
      Now^.El+=Cash.Bike;
      Now^.El+=Cash.experience;
      With Cash do
        begin
          Fio:='';
          Bike:='';
          Experience:='';
        end;
      Add_to_file(93,Cash_file,First);
      State_biker:='Done';
    end;
begin //Write_Biker_Line
  State_biker:='Do FIO';
  Repeat case State_biker of
    'Do FIO': FIO;
    'Do Bike': Bike;
    'Do Experience': Experience;
    'Save biker': Save_Cash;
  end until State_biker='Done';
end;
Procedure Member_club.Biker_line(y,color: byte; text: list);       //рисование линий
  begin //Biker_line
    Textbackground(color);
    For i:=2 to 4 do begin
        Gotoxy(i,y);
        Write(' ');
      end;
    Gotoxy(2,y);
    Write(text^.number);
    Gotoxy(5,y);
    Write(#186);
    Gotoxy(6,y);
    Write(Copy(text^.El,1,start_bike-1));
    Gotoxy(60,y);
    Write(#186);
    Gotoxy(61,y);
    Write(Copy(text^.El,start_bike,30));
    Gotoxy(91,y);
    Write(#186);
    Gotoxy(92,y);
    Write(Copy(text^.El,start_exp,8));
  end;
Procedure Member_club.Write_Biker(Filik: string);                  //управляющая процедура заполнерия поля
  begin //Write_Biker
    State:='Chose';
    If Filik<>'New' then Read_Biker(max_buf,Filik);
    If Filik<>Cash_File then Add_to_file(max_buf,Cash_file,First);
    Past:=First;
    If State<>'Done' then Full_line('up',proc);
    y:=First_line;
    Repeat case State of
      'Chose': begin Biker_line(y,2,Now);
                     Step:=Enter_char;
                     Case Step of
       {вверх}         #72: Was_Choosed_Up;
       {вниз}          #80: Was_Choosed_Down(max_buf);
       {Enter}         #13: begin
                              proc(y,0,Now);
                              Write_Biker_Line;
                            end;
       {Esc}           #27: State:='Save file';
       {BackSpace}     #8:  Was_Choosed_BackSpace(max_buf,draw);
                       '1': Sort('FIO');
                       '2': Sort('Bike');
                       '3': Sort('Exp');
                       #59: Was_Choosed_Search(First);
                     end;
               end;
      'Save file': Was_Choosed_Esc(Spisok_of_Files,Filik,Standart_file,max_buf,draw);
    end until State='Done';
  end;


Constructor Randonnee.Create;                                     //конструктор
  begin
    Create_list(max_buf);
    Full_alfavit;
    proc:=@Bicycle_line;
    draw:=@(Table.Randonnee);
  end;
Procedure Randonnee.Bicycle_line(y,color: byte; text: list);      //рисование линии
  begin
    Textbackground(color);
    For i:=2 to 4 do begin
        Gotoxy(i,y);
        Write(' ');
      end;
    Gotoxy(2,y);
    Write(text^.number);
    Gotoxy(5,y);
    Write(#186);
    Gotoxy(6,y);
    Write(Copy(text^.El,1,start_distance-1));
    Gotoxy(52,y);
    Write(#186);
    Gotoxy(53,y);
    Write(Copy(text^.El,start_distance,15));
    Gotoxy(68,y);
    Write(#186);
    Gotoxy(69,y);
    Write(Copy(text^.El,start_date,15));
    Gotoxy(84,y);
    Write(#186);
    Gotoxy(85,y);
    Write(Copy(text^.El,start_duration,15));
  end;
Procedure Randonnee.Write_Bicycle_line;                           //заполнение полей
  Procedure Name_change(y,color: byte; text: string);             //изменение цвета поля Название
    begin
      Textbackground(color);
      Gotoxy(6,y);
      Write(text);
    end;
  Procedure Distance_change(y,color: byte; text: string);         //изменение цвета поля Дистанция
    begin
      Textbackground(color);
      Gotoxy(53,y);
      Write(text);
    end;
  Procedure Date_change(y,color: byte; text: string);             //изменение цвета поля Дата
    begin
      Textbackground(color);
      Gotoxy(69,y);
      Write(text);
    end;
  Procedure Duration_change(y,color: byte; text: string);         //изменение цвета поля Длительность
    begin
      Textbackground(color);
      Gotoxy(85,y);
      Write(text);
    end;
  Procedure Name;                                   //управаляющая процедура
    Procedure Do_Name;                              //обработка данных
      Procedure Write_Name(y: byte);                //ввод данных
        begin
          Name_change(y,2,Cash.Name);
          Repeat begin
            If a<start_distance
              then begin
                Gotoxy(a+6,y);
                a:=a+1;
                Repeat  m[a]:=Enter_symbol until (m[a] in Rus_big)or(m[a] in Rus_small)or(m[a] in Eng_big)or(m[a] in Eng_small)or(m[a] in Figure)or(m[a]='-')or(m[a]='_')or(m[a]=' ')or((m[a]=#8)and(a>1))or((m[a]=#13)and(a>3))or(m[a]=#27);
                If misstake then begin
                  Clear_First_line(2);               {стирание сообщения об ошибке}
                  misstake:=false;
                end;
              end
              else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
            If m[a]=#8 then begin
              Gotoxy(a+4,y);
              Backspace_input; end;
            If (a>1)and(m[a]=' ')and(m[a-1]=' ') then begin
              a:=a-1;
              misstake:=true;
              Table.Mistake_biker(40,'ВВОД ДВУХ ПРОБЕЛОВ ПОДРЯД НЕДОПУСТИМ');
              TextbackGround(2);
            end;
            If (a>0)and(a<start_distance)and(m[a]<>#27)and(m[a]<>#13) then
              begin
                Gotoxy(a+5,y);
                Write(m[a]);
              end;
          end until (m[a]=#27)or(m[a]=#13);
        end;
      Var i: byte;
    begin  //Do_Name
      Write_Name(y);
      If m[a]=#13 then
        begin
          If a<3
            then begin
              Table.Mistake_biker(30,'НЕВЕРНЫЙ ФОРМАТ ЗАПОЛНЕНИЯ ПОЛЯ "ПОКАТУШКИ"');
              State_biker:='Do Name';
            end
            else begin
              Cash.Name:='';
              For i:=1 to a-1 do Cash.Name+=m[i];
              i:=a-1;
              While i<>start_distance-1 do begin
                Cash.Name+=' ';
                i+=1;
              end;
              State_biker:='Do Distance';
            end;
        end;
      If m[a]=#27 then
        begin
          Not_Saved;
          State_biker:='Done';
        end;
    end;
  begin //Name
    Cash.Name:=Copy(Now^.El,1,start_distance-1);
    Cash.Distance:=Copy(Now^.El,start_distance,15);
    Cash.Date:=Copy(Now^.El,start_date,15);
    Cash.Duration:=Copy(Now^.El,start_duration,15);
    a:=0;
    If Now^.El[1]<>' '
      then begin
        Repeat begin
          a+=1;
          m[a]:=Cash.Name[a];
        end until (a=46)or((Cash.Name[a]=' ')and(Cash.Name[a+1]=' '));
        a-=1;
      end;
    Do_Name;
  end;
  Procedure Distance;                               //управаляющая процедура
    Procedure Do_Distance;                          //обработка данных
      Procedure Write_Distance(y: byte);            //ввод данных
        begin
          Name_change(y,0,Cash.Name);
          Distance_change(y,2,Cash.Distance);
          Repeat begin
            If a<=4 then Gotoxy(54+a,y) else Gotoxy(57+a,y);
            Repeat m[a]:=Enter_char until (m[a] in figure)or(m[a]=#27)or(m[a]=#13)or(m[a]=#75)or(m[a]=#77);
            If misstake then begin
                  Clear_First_line(2);               {стирание сообщения об ошибке}
                  misstake:=false;
                  a:=4;
                  Gotoxy(54+a,y);
                end;
            Case m[a] of
              '0'..'9': begin
                          If a<=4 then Cash.Distance[a+2]:=m[a]
                            else Cash.Distance[a+5]:=m[a];
                          Write(m[a]);
                        end;
                #75: If a>1 then a-=1;
                #77: if a<7 then a+=1;
            end;
          end until (m[a]=#27)or(m[a]=#13);
        end;
    begin //Do_Distance
      Write_Distance(y);
      If m[a]=#13 then
        begin
          If (Cash.Distance[3]='0')and(Cash.Distance[4]='0')and(Cash.Distance[5]='0')and(Cash.Distance[6]='0')and
             (Cash.Distance[10]='0')and(Cash.Distance[11]='0')and(Cash.Distance[12]='0')
            then begin
              Table.Mistake_biker(29,'НЕВЕРНЫЙ ФОРМАТ ЗАПОЛНЕНИЯ ПОЛЯ "ДИСТАНЦИЯ"');
              misstake:=true;
            end else State_biker:='Do Date';
        end;
      If m[a]=#27 then
        begin
          Not_Saved;
          State_biker:='Done';
        end;
    end;
  begin //Distance
    If Now^.El[1]=' ' then Cash.Distance:='  0001км 000м  ';
    For i:=1 to 4 do m[i]:=Cash.Distance[i+2];
    For i:=5 to 7 do m[i]:=Cash.Distance[i+5];
    a:=4;
    Do_Distance;
  end;
  Procedure Date;                                   //управаляющая процедура
    Procedure Do_Date;                              //обработка дынных
      Procedure Write_Date(y:byte);                 //ввод данных
        begin
          Distance_change(y,0,Cash.Distance);
          Date_change(y,2,Cash.date);
          Repeat begin
            If a<3 then Gotoxy(71+a,y)
              else If a<5 then Gotoxy(72+a,y)
                else Gotoxy(73+a,y);
            Repeat m[a]:=Enter_char until (m[a] in figure)or(m[a]=#27)or(m[a]=#13)or(m[a]=#75)or(m[a]=#77);
            If misstake then begin
                  Clear_First_line(2);               {стирание сообщения об ошибке}
                  misstake:=false;
                  a:=2;
                  Gotoxy(71+a,y);
                end;
            Case m[a] of
              '0'..'9': begin
                          If a<3 then Cash.Date[a+3]:=m[a]
                            else If a<5 then Cash.Date[a+4]:=m[a]
                              else Cash.Date[a+5]:=m[a];
                          Write(m[a]);
                        end;
                #75: If a>1 then a-=1;
                #77: if a<8 then a+=1;
            end;
          end until (m[a]=#27)or(m[a]=#13);
        end;
    begin //Do_Date
      Write_Date(y);
      If m[a]=#13 then
        begin
          If ((Cash.Date[4]<>'0')and(Cash.Date[4]<>'1')and(Cash.Date[4]<>'2')and(Cash.Date[4]<>'3'))or
             ((Cash.Date[4]='3')and(Cash.Date[5]<>'0')and(Cash.Date[5]<>'1'))or
             ((Cash.Date[4]='0')and(Cash.Date[5]='0')) then begin
            Table.Mistake_biker(40,'Такого дня не существует');
            misstake:=true;
           end
           else If ((Cash.Date[7]<>'1')and(Cash.Date[7]<>'0'))or
                   ((Cash.Date[7]='0')and(Cash.Date[8]='0')) then begin
              Table.Mistake_biker(39,'Такого месяца не существует');
              misstake:=true;
             end
             else If (Cash.Date[10]='0')or
                     (Cash.Date[10]='1')or
                    ((Cash.Date[10]='2')and(Cash.Date[11]='0')and((Cash.Date[12]='1')or(Cash.Date[12]='0'))and(Cash.Date[13]<>'9')) then begin
                 Table.Mistake_biker(38,'Указанная дата давно прошла');
                 misstake:=true;
               end
               else If (Cash.Date[10]<>'2')or
                       (Cash.Date[11]<>'0') then begin
                   Table.Mistake_biker(35,'Указанная дата будет очень нескоро');
                   misstake:=true;
               end else State_biker:='Do Duration';
        end;
      If m[a]=#27 then
        begin
          Not_Saved;
          State_biker:='Done';
        end;
    end;
  Var i: byte;
  begin //Date
    If Now^.el[1]=' ' then Cash.Date:='   01.01.2019  ';
      a:=2;
      For i:=1 to 2 do m[i]:=cash.Date[i+3];
      For i:=3 to 4 do m[i]:=cash.Date[i+4];
      For i:=5 to 8 do m[i]:=cash.Date[i+5];
    Do_Date;
  end;
  Procedure Duration;                               //управаляющая процедура
    Procedure Do_Duration;                          //обработка данных
      Procedure Write_Duration(y: byte);            //ввод данных
        begin
          Date_change(y,0,Cash.Date);
          Duration_change(y,2,Cash.Duration);
          Repeat begin
            If a<=2 then Gotoxy(85+a,y)
              else If a<=4 then Gotoxy(87+a,y)
                else Gotoxy(89+a,y);
            Repeat m[a]:=Enter_char until (m[a] in figure)or(m[a]=#27)or(m[a]=#13)or(m[a]=#75)or(m[a]=#77);
            If misstake then begin
                  Clear_First_line(2);               {стирание сообщения об ошибке}
                  misstake:=false;
                  a:=6;
                  Gotoxy(89+a,y);
                end;
            Case m[a] of
              '0'..'9': begin
                        If a<=2 then Cash.Duration[a+1]:=m[a]
                          else If a<=4 then Cash.Duration[a+3]:=m[a]
                            else Cash.Duration[a+5]:=m[a];
                          Write(m[a]);
                        end;
                #75: If a>1 then a-=1;
                #77: if a<6 then a+=1;
            end;
          end until (m[a]=#27)or(m[a]=#13);
        end;
    begin //Do_Duration
      Write_Duration(y);
      If m[a]=#13 then
        begin
          If (Cash.Duration[2]='0')and(Cash.Duration[3]='0')and
             (Cash.Duration[6]='0')and(Cash.Duration[7]='0')and
             (Cash.Duration[10]='0')and(Cash.Duration[11]='0')then begin
            Table.Mistake_biker(30,'НЕВЕРНЫЙ ФОРМАТ ЗАПОЛНЕНИЯ ПОЛЯ "ДЛИТЕЛЬНОСТЬ"');
            misstake:=true;
          end
          else If ((Cash.Duration[6]<>'0')and(Cash.Duration[6]<>'1')and(Cash.Duration[6]<>'2'))or
                  ((Cash.Duration[6]='2')and(Cash.Duration[7]<>'0')and(Cash.Duration[7]<>'1')and(Cash.Duration[7]<>'2')and(Cash.Duration[7]<>'3')) then begin
             Table.Mistake_biker(32,'ЧАС ДОЛЖЕН БЫТЬ В ПРЕДЕЛАХ ОТ 00 ДО 23');
             misstake:=true;
            end
            else If (Cash.Duration[10]='6')or(Cash.Duration[10]='7')or(Cash.Duration[10]='8')or(Cash.Duration[10]='9') then begin
               Table.Mistake_biker(29,'МИНУТЫ ДОЛЖНЫ БЫТЬ В ПРЕДЕЛАХ ОТ 00 ДО 59');
               misstake:=true;
              end else State_biker:='Save biker';
        end;
      If m[a]=#27 then
        begin
          Not_Saved;
          State_biker:='Done';
        end;
    end;
  begin //Duration
    If Now^.el[1]=' 'then Cash.Duration:=' 00д 01ч 00мин ';
    a:=6;
    For i:=1 to 2 do m[i]:=cash.Duration[i+1];
    For i:=3 to 4 do m[i]:=cash.Duration[i+3];
    For i:=5 to 6 do m[i]:=cash.Duration[i+5];
    Do_Duration;
  end;
  Procedure Save_Cash;                              //сохранение данных
    begin
      Now^.El:=Cash.Name;
      Now^.El+=Cash.Distance;
      Now^.El+=Cash.Date;
      Now^.El+=Cash.Duration;
      With Cash do
        begin
          Name:='';
          Distance:='';
          Date:='';
          Duration:='';
        end;
      Add_to_file(92,Cash_file,First);
      State_biker:='Done';
    end;
begin //Write_Bycycle_line
  State_biker:='Do Name';
  Repeat case State_biker of
    'Do Name': Name;
    'Do Distance': Distance;
    'Do Date': Date;
    'Do Duration': Duration;
    'Save biker': Save_Cash;
  end until State_biker='Done';
end;
Procedure Randonnee.Write_Randonnee(Filik: string);               //управляющая процедура
  begin
    State:='Chose';
    If Filik<>'New' then Read_Biker(max_buf,Filik);
    If Filik<>Cash_File then Add_to_file(max_buf,Cash_file,First);
    Past:=First;
    If State<>'Done' then Full_line('up',proc);
    y:=First_line;
    Repeat case State of
      'Chose': begin proc(y,2,Now);
                     Step:=Enter_char;
                     Case Step of
       {вверх}         #72: Was_Choosed_Up;
       {вниз}          #80: Was_Choosed_Down(max_buf);
       {Enter}         #13: begin
                              proc(y,0,Now);
                              Write_Bicycle_line;
                            end;
       {Esc}           #27: State:='Save file';
       {BackSpace}     #8:  Was_Choosed_BackSpace(max_buf,draw);
                       '1': Sort('Name');
                       '2': Sort('Dis');
                       '3': Sort('Date');
                       '4': Sort('Dur');
                       #59: Was_Choosed_Search(First);
                     end;
               end;
      'Save file': Was_Choosed_Esc(Spisok_of_Files,Filik,Standart_file,max_buf,draw);
    end until State='Done';
  end;

end.
