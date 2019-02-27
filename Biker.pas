unit Biker;

{$mode objfpc}{$H+}

interface
Procedure Read_Biker;
Procedure Write_Biker(y: byte);
Procedure FIO_change(y,color: byte; text: string);
Procedure Full_alfavit;

Function Input: boolean;
Procedure Letter_input;
Procedure space_input;
Procedure Backspace_input;
implementation
uses
  Classes, SysUtils, crt;

Type ABC1=set of 'A'..'Z';                  {Заглавные латинские буквы}
     ABC2=set of 'a'..'z';                  {Строчные латинские буквы}
     Alf1=set of 'А'..'Я';                  {Заглавные русские буквы}
     Alf2=set of 'а'..'я';                  {Строчные русские буквы}
     Info=record
            FIO: string;                     {ФОИ}
            Bike: string;                    {Название велосипеда}
            experience: string;              {стаж}
          end;
     Element=record
               El: Info;
               Next,Last: ^Element;
              end;
     Bike=^Element;
Var First,Now,Past: Bike;
    f: text;
    k: string;
    x,y: integer;
    m: array [byte] of char;            {для ввода}
    a: byte;                            {счетчик элементов массива}
    Word: 1..3;
    Eng_big: ABC1;
    Eng_small: ABC2;
    Rus_big: Alf1;
    Rus_small: Alf2;

Procedure Full_alfavit;
Var i: integer;
  begin
    For i:=65 to 90 do Eng_big:=Eng_big+[Chr(i)];
    For i:=97 to 122 do Eng_small:=Eng_small+[Chr(i)];
    For i:=128 to 159 do Rus_big:=Rus_big+[Chr(i)];
    For i:=160 to 175 do Rus_small:=Rus_small+[Chr(i)];
    For i:=224 to 239 do Rus_small:=Rus_small+[Chr(i)];
  end;

Function Input: boolean;
  begin
    If   ((m[a] in Rus_small)or(m[a] in Eng_small))
      or (((m[a] in Rus_big)or(m[a] in Eng_big))and((a=1)or(m[a-1]=' ')))
      or ((m[a]=' ')and(a>2)and(Word<3))
      or ((m[a]=#8)and(a>1))
      or  (m[a]=#27)
        then Result:=true
        else Result:=false;
  end;

Procedure letter_input;                               {фильтр ввода букв}
  begin
    If (a=1)or(m[a-1]=' ') then
      If m[a] in Eng_small                             {введена первая буква англ маленькая -> выводится большая}
        then m[a]:=Chr(Ord(m[a])-32);
      If m[a] in Rus_small then                        {введена первая буква рус маленькая -> выводится большая}
        If Ord(m[a])<200
          then m[a]:=Chr(Ord(m[a])-32)
          else m[a]:=Chr(Ord(m[a])-80);
    If a>=3 then
      If ((m[a-2]=m[a-1])and(m[a-1]=m[a]))             {фильтр на ввод трех одинаковых букв}
        or((Chr(Ord(m[a-2])+32)=m[a-1])and(m[a-1]=m[a]))
        or((Chr(Ord(m[a-2])+80)=m[a-1])and(m[a-1]=m[a]))
          then a:=a-1;
  end;
Procedure space_input;                                {фильтр ввода пробелов}
  begin
    If(  (m[a-3]=m[a])                                {между пробелами меньше 3х знаков -> вывода не будет}
       or(m[a-2]=m[a])
       or(m[a-1]=m[a]) )and(m[a]=' ') then a:=a-1;
    If m[a]=' ' then Word+=1;
  end;
Procedure Backspace_input;
  begin
    a:=a-1;
    If m[a]=' ' then Word-=1;
    m[a]:=' ';
    Gotoxy(a+5,y);
    Write(m[a]);
    If a<>1 then a:=a-1;
  end;

Procedure FIO_change(y,color: byte; text: string);
  begin
    For x:=6 to 59 do
      begin
        Gotoxy(x,y);
        Textbackground(color);
        Write(text);
      end;

  end;

Procedure Write_Biker(y: byte);
  begin
    FIO_change(y,2,' ');
    Full_alfavit;
    Word:=1;
    a:=0;
    Repeat
      begin
        a:=a+1;
        Repeat m[a]:=Readkey until Input;
        letter_input;
        space_input;
        Backspace_input;
        If a<55 then
          begin
            Gotoxy(a+5,y);
            Write(m[a]);
          end;

        Gotoxy(a+6,y);
      end;
    until m[a]=#27;
  end;

Procedure Read_Biker;
  begin
    Assign(f,'C:\Users\Nikke.tv\Desktop\"з?Ў \2.2\?Rп ЎR<ми п ЇаR?а ┐Є \test_programm.txt');
    New(First);
    Now:=First;
    Reset(f);
    While EoF(f) do
      begin;
        While EoLn(f) do
          begin
            k:='';
            Repeat
              begin
                Now^.El.FIO+=k;
                Read(f,k);
              end until k='/';
            k:='';
            Repeat
              begin
                Now^.El.Bike+=k;
                Read(f,k);
              end until k='/';
            k:='';
            Repeat
              begin
                Now^.El.experience+=k;
                Read(f,k);
              end
             until (k='/')or(k='|');
          end;
        IF k<>'|' then
          begin
            Past:=Now;
            Now^.Next:=Now;
            New(Now);
            Now^.Last:=Past;
          end;
        Readln(f);
      end;
    Close(f);
    First:=now;
    y:=7;
    Repeat
      begin
        Gotoxy(6,y);
        Write(Now^.El.FIO);
        Gotoxy(61,y);
        Write(Now^.El.Bike);
        Gotoxy(92,y);
        Write(Now^.El.experience);
        y+=2;
        Now:=Now^.Next;
      end
    until Now=NIL;
  Readln();
  end;
end.

