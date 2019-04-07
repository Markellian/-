unit Biker;

{$mode objfpc}{$H+}

  interface

Procedure Write_Biker(Filik: string);                              {ГЛАВНАЯ ПРОЦЕДУРА ДЛЯ ЗАПОЛНЕНИЯ ТАБЛИЦЫ}


implementation
  uses
    Classes, SysUtils, crt, Table;


Procedure Write_Biker(Filik: string);
  Type Info=record
              FIO: string;                     {ФОИ}
              Bike: string;                    {Название велосипеда}
              experience: string;              {стаж}
              number: byte;                    {номер в списке}
            end;
       Element=record
                 El: Info;
                 Next,Last: ^Element;
                end;
       Bisycle=^Element;
       Const First_Line=7;
             Last_line=33;
             Number_line_on_screen=14;
             Max_lines=100;
             Spisok_of_Files='All_Files.txt';
             Standart_file='Велосипедисты';
             Cash_File='Cash file.txt';
             Racshirenie='.txt';
  Var First,Now,Past: Bisycle;            {главные указатели}
      Last_Now:Bisycle;                   {для создания связи между элементами списка}
      State_biker: string;                {для заполнения полей}
      Cash: Info;                         {для предворительного сохранения данных до полного заполнения стороки Велосипедист}
      f: text;                            {ФАЙЛ}
      m: array [byte] of char;            {для ввода посимвольно}
      a: byte;                            {счетчик элементов массива}
      Word: 1..3;                         {количество слов для поля ФИО и Велосипед}
      State: string;                      {переменная для конечного автомата в главной процедуре}
      Step: char;
      Number_Line: byte;                  {количество линий(с данными)}
      Eng_big,Eng_small,Figure: set of char;
  Procedure Read_Biker(Open_file:string);
  var k, n: string;
      f: text;
    Procedure From_line_to_list;
    Var a: byte;

    begin //From_line_to_list
      i:=0;
      n:='';
      Repeat begin
        n+=k[i];
        i+=1;
      end until k[i]='/';
      i+=1;
      Val(n,a,Now^.El.number);
      Repeat begin
        Now^.El.FIO+=k[i];
        i+=1;
      end until k[i]='/';
      i+=1;
      Repeat begin
        Now^.El.Bike+=k[i];
        i+=1;
      end until k[i]='/';
      Repeat begin
        i+=1;
        Now^.El.experience+=k[i];
      end until i=Length(k);
    end;
  begin //Read_Biker
    AssignFile(f,Open_file);
    Reset(f);
    Readln(f,k);
    While (Number_line<100)and(k<>'') do
      begin
        From_line_to_list;
        Number_line+=1;
        Now^.el.number:=Number_line;
        Last_Now:=Now;
        new(Now);
        Last_Now^.Next:=Now;
        Now^.Last:=Last_Now;
        Readln(f,k);
      end;
    Dispose(Now);
    Now:=Last_now;
    Now^.Next:=Nil;
    CloseFile(f);
  end;
  Procedure Full_alfavit;
    begin
      Eng_big:=['A'..'Z'];
      Eng_small:=['a'..'z'];
      Figure:=['0'..'9'];
    end;
  Function Input: boolean;
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
                  If (a>=5)and(m[a] in Figure)and(m[a-1] in Figure)and(m[a-2] in Figure)and(m[a-3] in Figure)and(m[a-4] in Figure)and(m[a-5] in Figure)
                    then Mistake:='five_identical_numbers';
                end;
      end;
    Case mistake of
      'only_russian_letters': Mistake_biker(37,'ДОПУСТИМЫ ТОЛЬКО РУССКИЕ БУКВЫ');
      'max_words': Mistake_biker(32,'КОЛИЧЕСТВО СЛОВ НЕ МОЖЕТ БЫТЬ БОЛЬШЕ ТРЕХ');
      'word_length': Mistake_biker(32,'ДЛИНА СЛОВА НЕ МОЖЕТ БЫТЬ МЕНЬШЕ ТРЕХ БУКВ');
      'two_identical_letters': Mistake_biker(34,'ВВОД ТРЕХ ОДИНАКОВЫХ БУКВ НЕДОПУСТИМ');
      'five_identical_numbers': Mistake_biker(34,'ВВОД ШЕСТИ ЦИФР ПОДРЯД НЕДОПУСТИМ');
    end;
  end;
  Procedure Backspace_input;
    begin
      a:=a-1;
      If m[a]=' ' then Word-=1;
      m[a]:=' ';
      Write(m[a]);
      a:=a-1;
    end;
  Procedure Create_list;                          {создание списка}
    begin
      Number_line:=0;
      new(First);
      First^.El.number:=1;
      Now:=First;
      First^.Next:=Nil;
      New(Last_now);
      Now^.Last:=Last_now;
      Last_now^.Next:=Now;
    end;
  Procedure Biker_line(y,color: byte; text: Bisycle);
    Procedure Space(Y_now,X_min,X_max: integer);
      Var i: byte;
      begin //Space
        For i:=X_min to X_max do
          begin
            Gotoxy(i,y_Now);
            Write(' ');
          end;
      end;
  begin //Biker_line
    Textbackground(color);
    Space(y,2,4);
    Gotoxy(2,y);
    Write(text^.El.number);
    Gotoxy(5,y);
    Write(#186);
    Gotoxy(6,y);
    If text^.el.FIO<>''
      then begin
        Write(text^.El.FIO);
        Space(y,6+Length(text^.El.FIO),59);
      end
      else Space(y,6,59);
    Gotoxy(60,y);
    Write(#186);
    Gotoxy(61,y);
    If text^.el.bike<>''
      then begin
        Write(text^.El.Bike);
        Space(y,61+Length(text^.El.Bike),90);
      end
      else Space(y,61,90);
    Gotoxy(91,y);
    Write(#186);
    Gotoxy(92,y);
    If text^.el.experience<>''
      then begin
        Write(text^.El.experience);
        Space(y,92+Length(text^.El.experience),99);
      end
      else Space(y,92,99);
  end;
  Procedure Write_Biker_Line;
    Procedure Number_Choose(y,text:byte);
      begin
        TextBackGround(0);
        Gotoxy(2,y);
        Write(text);
      end;
    Procedure FIO_change(y,color: byte; text: string);
      begin
        Textbackground(color);
        For x:=6 to 59 do
          begin
            Gotoxy(x,y);
            Write(' ');
          end;
        Gotoxy(6,y);
        Write(text);
      end;
    Procedure Bike_change(y,color: byte; text: string);
      begin
        Textbackground(color);
        For x:=61 to 90 do
          begin
            Gotoxy(x,y);
            Write(' ');
          end;
        Gotoxy(61,y);
        Write(text);
      end;
    Procedure Expirience_change(y,color: byte; text: string);
      begin
        Textbackground(color);
        For x:=92 to 99 do
          begin
            Gotoxy(x,y);
            Write(' ');
          end;
        Gotoxy(92,y);
        Write(text);
      end;
    Procedure FIO;
      Procedure Do_FIO;
        Procedure Write_Biker_FIO(y: byte);
          begin
            FIO_change(y,2,Cash.FIO);
            Bike_change(y,0,Cash.Bike);
            Expirience_change(y,0,Cash.experience);
            Full_alfavit;
            Repeat begin
              If a<55 then Gotoxy(a+6,y);
              If a<55
                then begin
                  a:=a+1;
                  Repeat
                    begin
                      m[a]:=Readkey;
                      Clear_First_line(2);               {стирание сообщения об ошибке}
                    end until Input;
                end
                else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
              If m[a]=' ' then Word+=1;;
              If m[a]=#8 then begin Gotoxy(a+4,y); Backspace_input; end;
              If (a>0)and(a<55)and(m[a]<>#27) then
                begin
                  Gotoxy(a+5,y);
                  Write(m[a]);
                end;
            end until (m[a]=#27)or(m[a]=#13);
          end;
      Var i: byte;
      begin  //Do_FIO
        Cash.Number:=Now^.El.number;
        Number_choose(y,Cash.number);
        Write_Biker_FIO(y);
        If m[a]=#13 then
          begin
            If Word<>3
              then begin
                Table.Mistake_biker(32,'НЕВЕРНЫЙ ФОРМАТ ЗАПОЛНЕНИЯ ПОЛЯ ФИО');
                State_biker:='Do FIO';
              end
              else begin
                Cash.FIO:='';
                For i:=1 to a-1 do Cash.FIO+=m[i];
                State_biker:='Do Bike';
              end;
          end;
        If m[a]=#27 then
          begin
            If Word<>3 then Not_Saved;
            State_biker:='Done';
          end;
      end;
    var i: byte;
    begin //FIO
      If Now^.El.FIO<>''
        then begin
          Cash.FIO:=Now^.El.FIO;
          cash.bike:=Now^.El.Bike;
          Cash.Experience:=Now^.El.Experience;
          For i:=1 to Length(Cash.FIO) do m[i]:=Cash.FIO[i];
          a:=Length(Cash.FIO);
          Word:=3;
        end
        else begin
          a:=0;
          Word:=1;
        end;
      Do_FIO;
    end;
    Procedure Bike;
      Procedure Do_Bike;
        Procedure Write_Biker_Bike(y: byte);
          begin
            FIO_change(y,0,Cash.FIO);
            Bike_change(y,2,Cash.Bike);
            Repeat begin
              If a<31
                then begin
                  a:=a+1;
                  Repeat m[a]:=Readkey until (Input)or(m[a] in Eng_big)or(m[a] in Eng_small)or(m[a] in Figure)or(m[a]='-')or(m[a]='_');
                  Clear_First_line(2);                          {стирание сообщения об ошибке}
                end
                else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
              If (m[a]=' ')or(m[a]='-')or(m[a]='_') then Word+=1;
              If m[a]=#8 then begin Gotoxy(a+59,y); Backspace_input; end;
              If (a>0)and(a<31) then
                begin
                  Gotoxy(a+60,y);
                  Write(m[a]);
                end;
              If a<31 then Gotoxy(a+61,y);
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
                State_biker:='Do Experience';
              end;
          end;
        If m[a]=#27 then
          begin
            If a<3 then Not_Saved;
            State_biker:='Done';
          end;
      end;
    Var i:byte;
    begin //Bike
      If Now^.El.Bike<>''
        then begin
          For i:=1 to Length(cash.bike) do m[i]:=cash.bike[i];
          a:=Length(cash.bike);
          Word:=1;
        end
        else begin
          a:=0;
          Word:=1;
        end;
      Do_Bike;
    end;
    Procedure Experience;
      Procedure Do_Experience;
        Procedure Write_Biker_Experience(y:byte);
          begin
            Bike_change(y,0,Cash.Bike);
            Expirience_change(y,2,Cash.experience);
            Repeat begin
              If a<3
                then begin
                  a:=a+1;
                  Repeat m[a]:=Readkey until ((m[a] in Figure)or((m[a]=#8)and(a>1))or(m[a]=#13)or(m[a]=#27));
                  Clear_First_line(2);                          {стирание сообщения об ошибке}
                end
                else begin Repeat  a:=4; m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);  end;
              If m[a]=#8 then begin a:=a-1; m[a]:=' '; a:=a-1; end;
              If (a<4) then
                begin
                  Expirience_change(y,2,' ');
                  Gotoxy(92,y);
                  If a=0 then Write(' мес.')
                    else If a=1 then Write(m[1],' мес.')
                      else If a=2 then Write(m[1],m[2],' мес.')
                        else Write(m[1],m[2],m[3],' мес.')
                end;
              If a<4 then Gotoxy(a+92,y);
            end until (m[a]=#27)or(m[a]=#13);
          end;
      Var i: byte;
      begin //Do_Experience
        Write_Biker_Experience(y);
        If m[a]=#13 then
          begin
            If a<1
              then Table.Mistake_biker(29,'НЕВЕРНЫЙ ФОРМАТ ЗАПОЛНЕНИЯ ПОЛЯ "СТАЖ"')
              else begin
                Gotoxy(1,y);
                TextbackGround(0);
                Write(#186);
                Cash.experience:='';
                For i:=1 to a-1 do Cash.experience+=m[i];
                Cash.experience+=' мес.';
                State_biker:='Save biker';
              end;
          end;
        If m[a]=#27 then
          begin
            If a<1 then Not_Saved;
            State_biker:='Done';
          end;
      end;
    Var i: byte;
    begin //Experience
      If Now^.El.Experience<>''
        then begin
          a:=0;
          For i:=1 to Length(cash.Experience) do m[i]:=cash.Experience[i];
          while cash.Experience[a+1]<>' ' do a:=a+1;
        end else a:=0;
      Do_Experience;
    end;
    Procedure Save_Cash;
      begin
        Now^.El.Number:=Cash.Number;
        Now^.El.FIO:=Cash.FIO;
        Now^.El.Bike:=Cash.Bike;
        Now^.El.experience:=Cash.experience;
        With Cash do
          begin
            Fio:='';
            Bike:='';
            Experience:='';
          end;
        AssignFile(f,Cash_File);
        Append(f);
        Write(f,Now^.El.number,'/');
        Write(f,Now^.El.FIO,'/');
        Write(f,Now^.El.Bike,'/');
        Writeln(f,Now^.El.experience);
        CloseFile(f);
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
  Procedure Full_line(last_position:string);
    begin
      y:=First_Line-2;
      Now:=Past^.Last;
      While (Now^.Next<>Nil)and(Now^.el.number<>Past^.El.number+Number_line_on_screen) do
        begin
          Now:=Now^.Next;
          y+=2;
          Biker_Line(y,0,Now);
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
  Procedure Was_Choosed_Up;
    begin
      If (Now<>First)and(y=First_line)
        then begin
          Past:=Past^.Last;
          Full_line('up');
        end
        else If (y>First_line)
          then begin
            Biker_Line(y,0,Now);
            y-=2;
            Now:=Now^.Last;
          end
          else If Now=First then
            begin
              While Now^.Next<>Nil do Now:=Now^.Next;
              If Now^.El.number>Number_line
                then begin
                  Past:=Now;
                  While (Past^.El.number>(Number_line-Number_line_on_screen))and(Past<>First) do Past:=Past^.Last;
                  Full_Line('down');
                end
              else begin
                Biker_line(First_Line,0,First);
                y:=(Now^.El.number-1)*2+First_line;
              end;
            end;
    end;
  Procedure Was_Choosed_Down;
    Procedure LastLine;           {последння линяя таблицы}
    Var Last_Now: Bisycle;
    begin //LastLine
     If Now^.El.number=Max_lines
       then begin
          Past:=First;
          Full_line('up');
       end
       else If (Now^.Next=Nil)and(Now^.El.FIO<>'')and(Number_Line<Max_lines)
         then begin
            Last_Now:=Now;
            New(Now);
            Last_Now^.Next:=Now;
            Now^.Last:=Last_Now;
            Now^.Next:=Nil;
            Number_line+=1;
            Now^.El.number:=Number_line;
            Past:=Past^.Next;
            Full_line('down');
         end
         else If (Now^.Next<>Nil)and(Number_Line<Max_lines)
           then begin
             Past:=Past^.Next;
             Full_line('down');
           end
           else If (Now^.Next=Nil)and(Now^.El.number<Max_lines)and(Now^.El.FIO='') then
             begin
               Past:=First;
               Full_line('up');
             end;
    end;
    Procedure NotLastLine;        {не последняя линия}
      Var Last_Now: Bisycle;
      begin //NotLastLine
       If (Now^.Next=Nil)and(Now^.El.FIO<>'')and(Number_Line<Max_lines)
         then begin
           Biker_Line(y,0,Now);
           y+=2;
           Last_Now:=Now;
           New(Now);
           Last_Now^.Next:=Now;
           Now^.Last:=Last_Now;
           Now^.Next:=Nil;
           Now^.El.number:=Now^.Last^.El.number+1;
           number_line+=1;
           If Now^.El.number>Number_line then Full_line('now');
         end
         else If (Now^.Next<>Nil)
           then begin
             Biker_Line(y,0,Now);
             y+=2;
             Now:=Now^.Next;
           end
           else If (Now^.Next=Nil)and(Now^.El.number<Max_lines)and(Now^.El.FIO='') then
             begin
               Biker_Line(y,0,Now);
               Now:=Past;
               y:=First_line;
             end;
      end;
  begin //Was_Choosed_Down
    If y=Last_Line then LastLine else NotLastLine;
  end;
  Procedure Was_Choosed_BackSpace(Now: Bisycle);
    Procedure Delete_Element_of_list(First,Now: Bisycle);
      Var Last_now: bisycle;
      begin //Delete_Element_of_list
        If First=Now
          then If First^.Next<>Nil
            then begin                         {First=Now; First^.Next<>Nil}
              First:=Now^.Next;
              First^.Last:=First^.Last^.Last;
              Dispose(First^.Last^.Next);
              First^.Last^.Next:=First;
              Past:=First;
              Now:=First;
              First^.El.number:=1;
            end else begin                         {First=Now; First^.Next=Nil}
              Dispose(First^.Last);
              Dispose(First);
              Create_list;
            end else If Now^.Next<>Nil
              then begin                         {First<>Now; Now^.Next<>Nil}
                Now^.Last^.Next:=Now^.Next;
                Now^.Next^.Last:=Now^.Last;
                Last_now:=now;
                Dispose(Last_Now);
                Now:=Now^.Last;
              end else begin                         {First<>Now; Now^.Next=Nil}
                Now:=Now^.Last;
                Dispose(Now^.Next);
                Now^.Next:=Nil;
              end;
      end;
    begin //Was_Choosed_BackSpace
      Delete_Element_of_list(First,Now);
      Number_line:=Now^.El.number;
      While Now^.Next<>Nil do
        begin
          Now:=Now^.Next;
          Number_line+=1;
          Now^.El.number:=Number_line;
        end;
      TextBackGround(0);
      clrscr;
      Table.Member;
      Full_line('up');
    end;
  Procedure Was_Choosed_Esc(Filik:string);
    const x=35;
          max_symbol=33;
    Var m: array [byte] of char;
      a: byte;
    Procedure BackSpase;
      begin
        a:=a-1;
        m[a]:=' ';
        Write(m[a]);
        a:=a-1;
      end;
    Procedure Sort;
      Var Cash: Info;
      begin //Sort
        Now:=Past^.Next;
        Repeat begin
          If (Past^.el.FIO)>(Now^.el.Fio) then
            begin
              Cash.FIO:=Past^.El.FIO;
              Cash.Bike:=Past^.El.Bike;
              Cash.experience:=Past^.El.experience;
              Past^.El.FIO:=Now^.El.FIO;
              Past^.El.Bike:=Now^.El.Bike;
              Past^.El.experience:=Now^.El.experience;
              Now^.El.FIO:=Cash.FIO;
              Now^.El.Bike:=Cash.Bike;
              Now^.El.experience:=Cash.experience;
            end;
          Now:=Now^.Next;
        end until Now=Nil;
        Past:=Past^.Next;
      end;
    Procedure Write_all_lines_in_file;
      Var i: byte;
          k: string;
      Function Proverka: boolean;
        Var m: array [byte] of string;
            num: byte;
        begin  //Proverka
          Reset(f);
          num:=0;
          While not EoF(f) do begin
             num:=num+1;
             Readln(f,m[num]);
          end;
          i:=0;
          Result:=true;
          While (Result)and(i<num) do begin
            i+=1;
            If k=m[i] then Result:=false;
          end;
        end;
      begin //Write_all_lines_in_file
        k:='';
        For i:=1 to a-1 do k+=m[i];
        If k<>'' then k:=Standart_file;
        AssignFile(f,Spisok_of_Files);
        If Proverka then begin
          Append(f);
          Writeln(f,k);
         end;
        CloseFile(f);
        k:=k+Racshirenie;
        Past:=First;
        If Number_Line>1 then Repeat Sort until Past^.Next=Nil;
        Now:=First^.Last;
        AssignFile(f,k);
        Rewrite(f);
        Repeat begin
          Now:=Now^.Next;
          Write(f,Now^.El.number,'/');
          Write(f,Now^.El.FIO,'/');
          Write(f,Now^.El.Bike,'/');
          Writeln(f,Now^.El.experience);
        end until (Now^.Next=Nil)or(Now^.El.FIO='');
        CloseFile(f);
        State:='Done';
      end;
    Procedure Write_name_of_file;
      Var y,cickl: byte;
      begin //Write_name_of_file
        TextColor(2);
        y:=17;
        If Filik<>'New'
          then begin
            For cickl:=0 to Length(Filik)-4 do m[cickl]:=Filik[cickl];
            a:=Length(Filik)-4;
            Gotoxy(x,y);
            Write(Copy(Filik,0,a));
          end else a:=0;
        Repeat begin
          If a<max_symbol then
            begin
              Gotoxy(a+x,y);
              a:=a+1;
              m[a]:=Readkey;
            end
            else Repeat m[a]:=Readkey until (m[a]=#8)or(m[a]=#13)or(m[a]=#27);
            If m[a]=#8 then
              If a=1 then a-=1
                else begin Gotoxy(a+x-2,y); Backspase; end;
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
    Save_Window;
    Write_name_of_file;
    If m[a]=#27
      then begin
        State:='Chose';
        clrscr;
        Table.Member;
        Full_line('up');
      end;
    If m[a]=#13 then Write_all_lines_in_file;
  end;
  Procedure Create_new_file;                                           {создание фалы с записанными данными}
    Var f: text;
    begin //Create_new_file
      AssignFile(f,'test_programm.txt');
      ReWrite(f);
      CloseFile(f);
      new(First);
      First^.Next:=nil;
      New(Last_now);
      Last_now^.Next:=First;
      Last_now^.el.number:=0;
      First^.Last:=Last_now;
      Number_Line:=1;
      First^.El.number:=Number_Line;
    end;

  begin //Write_Biker
    Create_list;
    If Filik<>'New' then Read_Biker(Filik);
    Full_alfavit;
    Past:=First;
    State:='Chose';
    Full_line('up');
    Now:=First;
    y:=First_line;
    Repeat case State of
      'Chose': begin Biker_line(y,2,Now);
                     Step:=ReadKey;
                     Case Step of
       {вверх}         #72: Was_Choosed_Up;
       {вниз}          #80: Was_Choosed_Down;
       {Enter}         #13: begin
                              Biker_Line(y,0,Now);
                              Write_Biker_Line;
                            end;
       {Esc}           #27: State:='Save file';
       {BackSpace}         #8:  Was_Choosed_BackSpace(Now);
                     end;
               end;
      'Save file': Was_Choosed_Esc(filik);
    end until State='Done';
  end;

end.
