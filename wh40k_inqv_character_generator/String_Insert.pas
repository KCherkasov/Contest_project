unit String_Insert;

interface

uses
  Classes, SysUtils, Windows;

type

//тип парных четырехбайтовых целых
  TIntPair = array [0..1] of integer;

//класс обработчика строк со вставками
  TInsString = class
    content: String; //преобразуемая строка
    length: integer; //размер преобразуемой строки
    function SearchInsert(from: integer): TIntPair; //V функция поиска места вставки (возвращает координаты границ вставки)
    function GetInsInfo(coords: TIntPair): integer; //V функция получения данных по вставке (что и откуда вставлять - пока реализовано только что вставлять) !ДОРАБОТАТЬ!
    function Insert(ins: String; coords: TIntPair): integer; //V функция вставки по месту (возвращает новую координату конца вставки)
    function Count: integer; //V функция подсчета числа вставок в строке
    procedure TakeIn(cont: String); //V процедура получения строки для обработки
    function GiveOut: String; //V функция выдачи готовой строки вовне
    constructor create; overload; //V конструктор класса без передачи содержимого
    constructor create(cont: String); overload; //V конструктор класса с передачей содержимого
    destructor destroy; overload; //V деструктор класса с уничтожением содержимого обработчика
    destructor destroy(outro: String); overload; //V деструктор класса с выдачей содержимого обработчика вовне
  end;

const
  INS_OPEN = '{';
  INS_CLOSE = '}';

implementation

//конструктор класса обработчика строк со вставками без передачи обрабатываемой строки
  constructor TInsString.create;
  begin
    inherited create;
    Self.content:= ''; //преиницциализация обрабатываемой строки пустой строкой
    Self.length:= 0; //преинициализация размера обрабатываемой строки нулем
  end;

//конструктор класса обработчика строк со вставками с передачей обрабатываемой строки (входной параметр - непреобразованная строка со вставками)
  constructor TInsString.create(cont: String);
  begin
    inherited create;
  //получение обрабатываемой строки и запись ее размера
    Self.content:= cont;
    Self.length:= lengthS(cont);
  end;

//деструктор класса обработчика строк со вставками с уничтожением содержимого обработчика
  destructor TInsString.destroy;
  begin
    inherited destroy;
  end;

//деструктор класса обработчика строк со вставками с передачей содержимого обработчика вовне
  destructor TInsString.destroy(outro: String);
  begin
    outro:= Self.content;
    inherited destroy;
  end;

//функция поиска вставки (возвращает координаты начала и конца вставки)
  function TInsString.SearchInsert(from: integer): TIntPair;
  var
    i: integer;
  begin
  //поиск начала вставки
    for i:=1 to Self.length do
    begin
      if (Self.content[i] = INS_OPEN) then
      begin
        result[0]:= i;
        break;
      end;
    end;
  //поиск конца вставки
    for i:= (result[0] + 1) to Self.length do
    begin
      if (Self.content[i] = INS_CLOSE) then
      begin
        result[1]:= i;
        break;
      end;
    end;
  end;

//функция получения данных вставки
  function TInsString.GetInsInfo(coords: TIntPair): integer;
  var
    tmp: String;
    dif,i: integer;
  begin
    dif:= coords[1] - (coords[0] + 1);
    tmp:= copy(tmp, coords[0] + 1, dif);
    result:= strtoint(tmp);
  end;

//функция подсчета числа вставок
  function TInsString.Count: integer;
  var
    i: integer;
  begin
    result:= 0; //преинициализация возвратного занчения нулем
  //подсчет производится посимвольным перебором всей строки с поиском открывающего символа вставки
    for i:= 1 to Self.length do
    begin
      if (Self.content[i] = INS_OPEN) then
        result:= result + 1;
    end;
  end;

//процедура получения строки для обработки
  procedure TInsString.TakeIn(cont: string);
  begin
    Self.content:= cont;
    Self.length:= length(cont);
  end;

//функция выдачи преобразованной строки вовне
  function TInsString.GiveOut: String;
  begin
    result:= Self.content;
  end;

//функция замены управляющей последовательности вставкой
  function TInsString.Insert(Ins: String, coords: TIntPair): integer;
  var
    etmp: String;
    btmp: String
  begin
    btmp:= copy(Self.content, 1, coords[0] - 1); //скопировать часть строки до начаа вставки
    etmp:= copy(Self.content, coords[1] + 1, Self.length - coords[1]); //скопировать часть строки после вставки до конца
    Self.content:= btmp + Ins + etmp; //заменить управляющую последовательность строкйо вставки
    result:= pos(etmp, Self.content); //возвращаемое значение - координаты начала конечной части строки (использовать для начала поиска следующей вставки)
  end;


end.
