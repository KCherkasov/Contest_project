//модуль классов и типов данных
unit cat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type

//<-------------------------------------------------------------------------->\\
//<----------------------------- ТИПЫ ДАННЫХ -------------------------------->\\
//<-------------------------------------------------------------------------->\\

//тип перечисления параметров описания внешности (рост, вес, цвет кожи, цвет глаз, цвет волос, 3 особые приметы)
  TOutlook = (ol_bodytype, ol_skin, ol_eyes, ol_hair, ol_perk1, ol_perk2, ol_perk3);

//тип перечисления групп действий (силовые светские скрытные следственные прочие)
  TActGroups = (ag_force, ag_court, ag_stealth, ag_investigation, ag_others);

//тип перечисления видов приказов (убить принести изучать допросить искать личное время)
  TOrdGroups = (og_kill, og_capture, og_research, og_, og_search, og_freetime);

//тип перечисления параметров DMS (Исполнительность Самосознание Хладнокровие Обучаемость Авторитетность)
  TDMSParams = (dp_diligence, dp_identity, dp_calmness, dp_educability, dp_authority);

//тип парных битовых чисел
  TBytePair = array [0..1] of Byte;

//процентный тип со знаком
  TSCent = -100..100;

//тип строк имен
  TNameString = string[60];

//тип массивов имен
  TStrArr = array [0..29] of TNameString;

//тип хранилища имен
  TDialNames = record
    prim: TStrArr;
    low: TStrArr;
    high: TStrArr;
    arch: TStrArr;
    infr: TStrArr;
  end;

//тип массива склонностей НИП
  TAddiction = array [TActGroups] of TSCent;

//тип массива параметров DMS
  TDMSArr = array [TDMSParams] of TSCent;

//тип блока модификаторов склонностей
  TAddMods = record
    clasmods: array [0..7] of TAddiction; //модификаторы класса
    factmods: array [0..9] of TAddiction; //модификаторы фракции
    origmods: array [0..3] of TAddiction; //модификаторы происхождения
  end;

//тип блока модификаторов параметров DMS
  TDMSMods = record
    clasmods: array [0..7] of TDMSArr; //модификаторы класса
    factmods: array [0..9] of TDMSArr; //модификаторы фракции
    origmods: array [0..3] of TDMSArr; //модификаторы происхождения
  end;

//<-------------------------------------------------------------------------->\\
//<------------------------------- КЛАССЫ ----------------------------------->\\
//<-------------------------------------------------------------------------->\\

//родительский класс игровых объектов
  TGameObject = class
    id: Integer; //идентификатор объекта
  end;

//класс хранилища данных
  TStorage = class (TGameObject)
     mnames: TDialNames; //мужские имена
     fnames: TDialNames; //женские имена
     cnames: array [0..7] of TNameString; //названия профессий (добавлено 01.02.2015)
     snames: array [0..8] of TNameString; //названия параметров персонажа (добавлено 01.02.2015)
     pnames: array [0..8] of TNameString; //названия психотипов (добавлено 01.02.2015)
     plnames: array [0..9] of TNameString; //порядковые номера планет (добавлено 29.05.2015)
     actnames: array [TActGroups] of TNameString; //названия групп действий (добавлено 01.07.2015)
     dmsnames: array [TDMSParams] of TNameString; //названия параметров DMS (добавлено 16.07.2015)
     sbonus: array [0..3, 0..8] of Byte; //бонусы параметров от родного мира (добавлено 01.02.2015)
     sprobs: array [0..3, 0..7] of Byte; //вероятности профессий в зависимости от происхождения (добавлено 01.02.2015)
     lprobs: array [0..3] of Byte; //вероятности субстатусов (добавлено 01.02.2015)
     factions: array [0..9] of TNameString; //названия фракций (добавлено 01.02.2015)
     fprobs: array [0..9] of Byte; //вероятности социальных статусов (добавлено 01.02.2015)
     gender: array [0..2] of TNameString; //названия полов
     hwtype: array [0..3] of TNameString; //тип родного мира
     bodytype: array [0..3, 0..4] of TNameString; //тип телосложения
     heitype: array [0..3, 0..1, 0..4] of TBytePair; //тип данных рост/вес (формат индексации: тип родного мира, пол, вариации) первое число - рост (см) второе вес(кг)
     skins: array [0..3, 0..4] of TNameString; //цвета кожи
     hairs: array [0..3, 0..4] of TNameString; //цвета волос
     eyes: array [0..3, 0..4] of TNameString;  //цвета глаз
     perks: array [0..3, 0..15] of TNameString; //массив особых примет
     addmods: TAddMods; //хранилище модификаторов психотипов (добавлено 01.07.2015)
     dmsmods: TDMSMods; //хранилище модификаторов параметров DMS (добавлено 03.07.2015)
     grexe: TNameString; //строка с расширением графических файлов (добавлено 05.02.2015)
     procedure initialize;
  end;

//класс жителей
  THuman = class(TGameObject)
    name: array [0..2] of TBytePair; //имя (индексы языковой группы и номера имени в группе)
    age: Integer; //возраст
    address: Integer; //адрес НИП
    gender: Boolean; //пол
    outlook: array [TOutlook] of Byte; //внешний вид персонажа
    origin: Byte; //тип родного мира
    factions: array [0..9] of Boolean; //массив принадлежностей к фракциям (изменения от 01.02.2015 - удалены поля isheretic и ispsyker, введено поле factions)
    ladder: array [0..9] of Byte; //положение НИП внутри фракции (рядовой, предводитель, командир, лорд. Предводитель командует 3 рядовыми, командир - 3 предводителями, лорд - 3 командирами)(добавлено 01.02.2015)
    specialty: Byte; //класс НИП (добавлено 01.02.2015)
    psychotype: Byte; //психотип (добавлено 01.02.2015)
    addictions: TAddiction; //склонности НИП (добавлено 01.07.2015)
    dmsparams: TDMSArr; //параметры DMS НИП (добавлено 03.07.2015)
    stats: array [0..8] of Byte; //массив параметров НИП (добавлено 01.02.2015)
    contacts: array [0..5] of Integer; //массив контактов НИП
    constructor create (Stock: TStorage); overload;
    destructor destroy; overload;
  end;

//добавления от 27.07.2015 - класс дома (базовая версия), класс города
//класс дома
  THouse = class(TGameObject)
    people: array [0..9] of integer; //список жителей дома
    //to-do: создать структуру адреса (улица, дом)
    constructor create; overload;
    destructor destroy; overload;
    //to-do: функционал доступа к списку жителей
  end;

//класс города
  TCity = class(TGameObject)
    houselist: array of THouse; //список домов - число зданий определяется численностью населения
    constructor create (populace: integer); overload;
    destructor destroy; overload;
    procedure settle (populace: integer); //процедура размещения жителей по домам
    function is_settled (numb: integer): integer; //поиск жителя в городе (возвращает -1 если НИП нигде не живет, в противном случае - номер дома)
    //to-do: процедура получения адреса жителя по номеру
  end;

//класс планеты (здесь должны быть список жителей, дома, рабочие места и т.д.
  TPlanet = class (TGameObject)
    kind: Byte; //идентификатор типа планеты (Добавлено 01.02.2015)
    people: array [0..1000] of THuman; //список жителей
    housing: TCity;
    factions: array [0..9] of Integer; //численность фракций н планете
    time: array [0..2] of Word; //массив времЕнных данных (год, месяц, день)
    store: TStorage; //дата-хранилище
    name: array [0..1] of TNameString; //название планеты
    constructor create; overload;
    procedure connect; //генерация сети контактов (добавлено 05.02.2015)
    procedure GetData; //сбор статистики по планете
  end;

//<-------------------------------------------------------------------------->\\
//<---------------------------- ПОДПРОГРАММЫ -------------------------------->\\
//<-------------------------------------------------------------------------->\\

  function is_between (dig,ubd,lbd: integer): Boolean; //функция проверки попадания числа в ограниченный диапазон
  procedure log_create (fname: string); //процедура создания файла лога и открытия его под запись
  procedure log_add (fname,msg: string); //процедура добавления новой записи в лог работы программы (для версии с подключаемыми БД)
  function genrnd (seed,range: Integer): Integer; //функция генерации случайного числа с номиналом seed и разбросом +/- range

implementation

//<-------------------------------------------------------------------------->\\
//<---------------------------- ПОДПРОГРАММЫ -------------------------------->\\
//<-------------------------------------------------------------------------->\\

//функция проверки, находится ли dig между lbd и ubd (удовлетворяется л неравенство lbd <= dig <= ubd)
  function is_between (dig,ubd,lbd: integer): Boolean;
  var
    buf: Integer;
  begin
  //если по ошибке входные данные введены так, что верхняя граница меньше нижней, меняем их местами
    if (ubd<lbd) then
    begin
      buf:= ubd;
      ubd:= lbd;
      lbd:= buf;
    end;
    if ((dig >= lbd)and(dig <= ubd)) then
      Result:= True
    else
      result:= False;
  end;

//процедура создания файла лога работы программы
  procedure log_create (fname: string);
  var
    f: Text;
  begin

  end;

//процедура записи строки в лог работы программы
  procedure log_add(fname,msg: string);
  var
    f: Text;
  begin
  //если предлагаемый файл лога  не был создан, создаем его и вписываем туда сообщение
    if not(FileExists(fname)) then
    begin

    end
  //если лог уже есть, просто записываем туда сообщение
    else
    begin

    end;
  end;

//генерация случайного числа со средним значением seed и диапазоном +/-range
  function genrnd (seed,range: Integer): Integer;
  begin
    Randomize;
    Result:= seed + (Random(range*2)-range);
  end;

//<-------------------------------------------------------------------------->\\
//<--------------------------- МЕТОДЫ КЛАССОВ ------------------------------->\\
//<-------------------------------------------------------------------------->\\

//добавления от 27.07.2015 - конструктор класса дома
//конструктор класса дома
  constructor THouse.create;
  var
    i: byte;
  begin
    inherited create;
    //инициализация массива жителей нулями
    for i:=0 to 9 do
      Self.people[i]:= 0;
    //to-do: генерация адреса
  end;

//конструктор класса города
  constructor TCity.create(populace: integer);
  const
    HOUSE_CAPACITY = 10;
  var
    i, count: integer;
  begin
    inherited create;
  //расчет требуемого количества домов под текущее население города
  //если численность жителей делится на емкость одного дома нацело - выделить ровно столько домов сколько получается при делении
  //иначе выделить еще один дом дополнительно
    if ((populace mod HOUSE_CAPACITY) = 0) then
      count:= populace div HOUSE_CAPACITY
    else
      count:= populace div HOUSE_CAPACITY + 1;
  //выделить память под массив домов
    setlength(Self.houselist, count);
  //выполнить преинициализацию домов
    for i:= 0 to (count-1) do
      Self.houselist[i]:= THouse.create;
  end;

//процедура заселения домов
  procedure TCity.settle(populace: integer);
  var
    i,j,k: integer; //счетчики циклов
    rdig: integer; //буфер для хранения сгенерированного случайного числа
    frspc: byte; //свободное место в рассматриваемом доме
    settled: array of boolean; //массив для проверки заселенности
    isall,flg: boolean;
  begin
  //преинициализация массива заселенности жителей - по умолчанию никто не заселен
    setlength(settled, populace);
    for i:= 0 to (populace - 1) do
      settled[i]:= false;
  //цикл заселения домов - перебираем дома по порядку, вннутри дома перебираем места
  //генерируем рандомное число до тех пор, пока не найдем незаселенного жителя
  //и помещаем его на текущее место в текущем доме. Если все жители уже заселены,
  //но остались свободные места, забить их как -1
    for j:= 0 to 9 do
      for i:= 0 to (length(Self.houselist) - 1) do
      begin
        //преинициализация флага завершенности заселения (по умолчанию истина)
        isall:= true;
        //проверяем, есть ли незаселенные жители. Если есть хотя бы один, снимаем флажок завершенности заселения
        for k:= 0 to (populace - 1) do
          isall:= isall and settled[k];
        //если заселение завершено, забиваем в текущий и оставшиеся пустыми слоты -1
        if (isall) then
          Self.houselist[i].people[j]:= -1
        else
        begin
          flg:= false;
          repeat
            rdig:= random(populace); //выбираем случайного НИП
          //Если выбранный НИП еще не заселен, селим его в текущий слот, фиксируем это и переходим к следующему слоту
            if (not settled[rdig]) then
            begin
              flg:= true;
              settled[rdig]:= true;
              Self.houselist[i].people[j]:= rdig;
            end;
          until flg;
        end;
      end;
  end;

//инициализация дата-хранилища
  procedure TStorage.initialize;
  var
    i: Byte;
    rn1: Integer;
  begin
    //инициализация названий полов
    Self.gender[0]:= 'мужской';
    Self.gender[1]:= 'женский';
    Self.gender[2]:= 'бесполый / не установлен';

    //инициализация типов родных миров
    Self.hwtype[0]:= 'Дикий мир';
    Self.hwtype[1]:= 'Мир-улей';
    Self.hwtype[2]:= 'Имперский мир';
    Self.hwtype[3]:= 'Рожденный в пустоте';

    //генерация описания внешнего вида

    //телосложение
    //Дикий мир
    Self.bodytype[0,0]:= 'Поджарый';
    Self.bodytype[0,1]:= 'Тощий';
    Self.bodytype[0,2]:= 'Мускулистый';
    Self.bodytype[0,3]:= 'Коренастый';
    Self.bodytype[0,4]:= 'Здоровенный';
    //Мир-улей
    Self.bodytype[1,0]:= 'Коротышка';
    Self.bodytype[1,1]:= 'Сухопарый';
    Self.bodytype[1,2]:= 'Жилистый';
    Self.bodytype[1,3]:= 'Длинный';
    Self.bodytype[1,4]:= 'Сильный';
    //Имперский мир
    Self.bodytype[2,0]:= 'Худощавый';
    Self.bodytype[2,1]:= 'Стройный';
    Self.bodytype[2,2]:= 'Подтянутый';
    Self.bodytype[2,3]:= 'Крепкий';
    Self.bodytype[2,4]:= 'Кряжистый';
    //Рожденный в пустоте
    Self.bodytype[3,0]:= 'Скелет';
    Self.bodytype[3,1]:= 'Чахлый';
    Self.bodytype[3,2]:= 'Костлявый';
    Self.bodytype[3,3]:= 'Сухопарый';
    Self.bodytype[3,4]:= 'Долговязый';

    //цвет кожи
    //Дикий мир
    Self.skins[0,0]:= 'Темная';
    Self.skins[0,1]:= 'Загорелая';
    Self.skins[0,2]:= 'Светлая';
    Self.skins[0,3]:= 'Красная';
    Self.skins[0,4]:= 'Бронзовая';
    //Мир-улей
    Self.skins[1,0]:= 'Темная';
    Self.skins[1,1]:= 'Загорелая';
    Self.skins[1,2]:= 'Светлая';
    Self.skins[1,3]:= 'Красная';
    Self.skins[1,4]:= 'Крашеная';
    //Имперский мир
    Self.skins[2,0]:= 'Темная';
    Self.skins[2,1]:= 'Загорелая';
    Self.skins[2,2]:= 'Светлая';
    Self.skins[2,3]:= 'Красная';
    Self.skins[2,4]:= 'Крашеная';
    //Рожденный в пустоте
    Self.skins[3,0]:= 'Фарфоровая';
    Self.skins[3,1]:= 'Светлая';
    Self.skins[3,2]:= 'Голубоватая';
    Self.skins[3,3]:= 'Сероватая';
    Self.skins[3,4]:= 'Молочная';

    //цвета волос
    //Дикий мир
    Self.hairs[0,0]:= 'Рыжие';
    Self.hairs[0,1]:= 'Светлые';
    Self.hairs[0,2]:= 'Русые';
    Self.hairs[0,3]:= 'Черные';
    Self.hairs[0,4]:= 'Седые';
    //Мир-улей
    Self.hairs[1,0]:= 'Русые';
    Self.hairs[1,1]:= 'Серые';
    Self.hairs[1,2]:= 'Крашеные';
    Self.hairs[1,3]:= 'Седые';
    Self.hairs[1,4]:= 'Черные';
    //Имперский мир
    Self.hairs[2,0]:= 'Крашеные';
    Self.hairs[2,1]:= 'Светлые';
    Self.hairs[2,2]:= 'Русые';
    Self.hairs[2,3]:= 'Черные';
    Self.hairs[2,4]:= 'Седые';
    //Рожденный в пустоте
    Self.hairs[3,0]:= 'Рыжеватые';
    Self.hairs[3,1]:= 'Светлые';
    Self.hairs[3,2]:= 'Медные';
    Self.hairs[3,3]:= 'Черные';
    Self.hairs[3,4]:= 'Золотистые';

    //цвета глаз
    // Дикий мир
    Self.eyes[0,0]:= 'Голубые';
    Self.eyes[0,1]:= 'Серые';
    Self.eyes[0,2]:= 'Карие';
    Self.eyes[0,3]:= 'Зеленые';
    Self.eyes[0,4]:= 'Желтые';
    //Мир-улей
    Self.eyes[1,0]:= 'Синие';
    Self.eyes[1,1]:= 'Серые';
    Self.eyes[1,2]:= 'Карие';
    Self.eyes[1,3]:= 'Зеленые';
    Self.eyes[1,4]:= 'Линзы';
    //Имперский мир
    Self.eyes[2,0]:= 'Голубые';
    Self.eyes[2,1]:= 'Серые';
    Self.eyes[2,2]:= 'Карие';
    Self.eyes[2,3]:= 'Зеленые';
    Self.eyes[2,4]:= 'Линзы';
    //Рожденный в пустоте
    Self.eyes[3,0]:= 'Светло-голубые';
    Self.eyes[3,1]:= 'Серые';
    Self.eyes[3,2]:= 'Черные';
    Self.eyes[3,3]:= 'Зеленые';
    Self.eyes[3,4]:= 'Фиолетовые';

    //генерация массива рост/вес
    //дикий мир
    Self.heitype[0,0,0][0]:= 190; Self.heitype[0,0,0][1]:= 65;
    Self.heitype[0,1,0][0]:= 180; Self.heitype[0,1,0][1]:= 60;

    Self.heitype[0,0,1][0]:= 175; Self.heitype[0,0,1][1]:= 60;
    Self.heitype[0,1,1][0]:= 165; Self.heitype[0,1,1][1]:= 55;

    Self.heitype[0,0,2][0]:= 185; Self.heitype[0,0,2][1]:= 85;
    Self.heitype[0,1,2][0]:= 170; Self.heitype[0,1,2][1]:= 70;

    Self.heitype[0,0,3][0]:= 165; Self.heitype[0,0,3][1]:= 80;
    Self.heitype[0,1,3][0]:= 155; Self.heitype[0,1,3][1]:= 70;

    Self.heitype[0,0,4][0]:= 210; Self.heitype[0,0,4][1]:= 200;
    Self.heitype[0,1,4][0]:= 120; Self.heitype[0,1,4][1]:= 100;
    //мир-улей
    Self.heitype[1,0,0][0]:= 165; Self.heitype[1,0,0][1]:= 45;
    Self.heitype[1,1,0][0]:= 155; Self.heitype[1,1,0][1]:= 40;

    Self.heitype[1,0,1][0]:= 170; Self.heitype[1,0,1][1]:= 55;
    Self.heitype[1,1,1][0]:= 160; Self.heitype[1,1,1][1]:= 50;

    Self.heitype[1,0,2][0]:= 175; Self.heitype[1,0,2][1]:= 65;
    Self.heitype[1,1,2][0]:= 165; Self.heitype[1,1,2][1]:= 55;

    Self.heitype[1,0,3][0]:= 180; Self.heitype[1,0,3][1]:= 65;
    Self.heitype[1,1,3][0]:= 170; Self.heitype[1,1,3][1]:= 60;

    Self.heitype[1,0,4][0]:= 175; Self.heitype[1,0,4][1]:= 80;
    Self.heitype[1,1,4][0]:= 165; Self.heitype[1,1,4][1]:= 75;
    //имперский мир
    Self.heitype[2,0,0][0]:= 175; Self.heitype[2,0,0][1]:= 65;
    Self.heitype[2,1,0][0]:= 165; Self.heitype[2,1,0][1]:= 60;

    Self.heitype[2,0,1][0]:= 185; Self.heitype[2,0,1][1]:= 70;
    Self.heitype[2,1,1][0]:= 175; Self.heitype[2,1,1][1]:= 65;

    Self.heitype[2,0,2][0]:= 175; Self.heitype[2,0,2][1]:= 70;
    Self.heitype[2,1,2][0]:= 165; Self.heitype[2,1,2][1]:= 60;

    Self.heitype[2,0,3][0]:= 190; Self.heitype[2,0,3][1]:= 90;
    Self.heitype[2,1,3][0]:= 180; Self.heitype[2,1,3][1]:= 80;

    Self.heitype[2,0,4][0]:= 180; Self.heitype[2,0,4][1]:= 100;
    Self.heitype[2,1,4][0]:= 170; Self.heitype[2,1,4][1]:= 90;
    //рожденный в пустоте
    Self.heitype[3,0,0][0]:= 175; Self.heitype[3,0,0][1]:= 55;
    Self.heitype[3,1,0][0]:= 170; Self.heitype[3,1,0][1]:= 50;

    Self.heitype[3,0,1][0]:= 165; Self.heitype[3,0,1][1]:= 55;
    Self.heitype[3,1,1][0]:= 155; Self.heitype[3,1,1][1]:= 45;

    Self.heitype[3,0,2][0]:= 185; Self.heitype[3,0,2][1]:= 60;
    Self.heitype[3,1,2][0]:= 175; Self.heitype[3,1,2][1]:= 60;

    Self.heitype[3,0,3][0]:= 200; Self.heitype[3,0,3][1]:= 80;
    Self.heitype[3,1,3][0]:= 185; Self.heitype[3,1,3][1]:= 70;

    Self.heitype[3,0,4][0]:= 210; Self.heitype[3,0,4][1]:= 75;
    Self.heitype[3,1,4][0]:= 195; Self.heitype[3,1,4][1]:= 70;

    //генерация массива особых примет
    Self.perks[0,0]:=  'Волосатые костяшки';   Self.perks[1,0]:=  'Бледный';              Self.perks[2,0]:=  'Отсутствует палец';    Self.perks[3,0]:=  'Бледный';
    Self.perks[0,1]:=  'Сросшиеся брови';      Self.perks[1,1]:=  'Чумазый';              Self.perks[2,1]:=  'Орлиный нос';          Self.perks[3,1]:=  'Лысый';
    Self.perks[0,2]:=  'Боевая раскраска';     Self.perks[1,2]:=  'Дикая прическа';       Self.perks[2,2]:=  'Бородавки';            Self.perks[3,2]:=  'Длинные пальцы';
    Self.perks[0,3]:=  'Ладони-лопаты';        Self.perks[1,3]:=  'Гнилые зубы';          Self.perks[2,3]:=  'Дуэльный шрам';        Self.perks[3,3]:=  'Крохотные уши';
    Self.perks[0,4]:=  'Редкие зубы';          Self.perks[1,4]:=  'Электротатуировка';    Self.perks[2,4]:=  'Пирсинг в носу';       Self.perks[3,4]:=  'Худые конечности';
    Self.perks[0,5]:=  'Кустистые брови';      Self.perks[1,5]:=  'Пирсинг';              Self.perks[2,5]:=  'Нервный тик';          Self.perks[3,5]:=  'Желтые ногти';
    Self.perks[0,6]:=  'Мускусный запах';      Self.perks[1,6]:=  'Повсеместный пирсинг'; Self.perks[2,6]:=  'Татуировка с аквилой'; Self.perks[3,6]:=  'Мелкие зубы';
    Self.perks[0,7]:=  'Волосатый';            Self.perks[1,7]:=  'Сухой кашель';         Self.perks[2,7]:=  'Тяжелый запах';        Self.perks[3,7]:=  'Широко расставленные глаза';
    Self.perks[0,8]:=  'Рваные уши';           Self.perks[1,8]:=  'Татуировки';           Self.perks[2,8]:=  'Оспины';               Self.perks[3,8]:=  'Большая голова';
    Self.perks[0,9]:=  'Длинные ногти';        Self.perks[1,9]:=  'Пулевой шрам';         Self.perks[2,9]:=  'Молитвенный шрам';     Self.perks[3,9]:=  'Искривленый позвоночник';
    Self.perks[0,10]:= 'Племенные татуировки'; Self.perks[1,10]:= 'Нервный тик';          Self.perks[2,10]:= 'Электротатуировка';    Self.perks[3,10]:= 'Безволосый';
    Self.perks[0,11]:= 'Шрамирование';         Self.perks[1,11]:= 'Родимое пятно';        Self.perks[2,11]:= 'Дрожь в пальцах';      Self.perks[3,11]:= 'Элегантные руки';
    Self.perks[0,12]:= 'Пирсинг';              Self.perks[1,12]:= 'Химические ожоги';     Self.perks[2,12]:= 'Проколотые уши';       Self.perks[3,12]:= 'Волнистые волосы';
    Self.perks[0,13]:= 'Кошачие глаза';        Self.perks[1,13]:= 'Горб';                 Self.perks[2,13]:= 'Жуткий чирей';         Self.perks[3,13]:= 'Альбинос';
    Self.perks[0,14]:= 'Маленькая голова';     Self.perks[1,14]:= 'Маленькие руки';       Self.perks[2,14]:= 'Макияж';               Self.perks[3,14]:= 'Хромая походка';
    Self.perks[0,15]:= 'Массивная челюсть';    Self.perks[1,15]:= 'Химический запах';     Self.perks[2,15]:= 'Шаркающая походка';    Self.perks[3,15]:= 'Сутулый';

    //инициализация списка мужских имен
    with Self.mnames do
    begin
      prim[0]:=  'Арл';    low[0]:= 'Барак';     high[0]:=  'Ателлус';   arch[0]:=  'Аларик';     infr[0]:=  'Эйбл';
      prim[1]:=  'Бруул';  low[1]:= 'Каин';      high[1]:=  'Брутус';    arch[1]:=  'Аттила';     infr[1]:=  'Кости';
      prim[2]:=  'Дар';    low[2]:= 'Дариэль';   high[2]:=  'Каллидон';  arch[2]:=  'Барбоса';    infr[2]:=  'Кризис';
      prim[3]:=  'Фрак';   low[3]:= 'Илай';      high[3]:=  'Кастус';    arch[3]:=  'Кортез';     infr[3]:=  'Каттер';
      prim[4]:=  'Фрал';   low[4]:= 'Енох';      high[4]:=  'Друстос';   arch[4]:=  'Константин'; infr[4]:=  'Декко';
      prim[5]:=  'Гарм';   low[5]:= 'Фраст';     high[5]:=  'Флавион';   arch[5]:=  'Кромвель';   infr[5]:=  'Дакка';
      prim[6]:=  'Грыш';   low[6]:= 'Гай';       high[6]:=  'Галлус';    arch[6]:=  'Дорн';       infr[6]:=  'Фраг';
      prim[7]:=  'Грак';   low[7]:= 'Гарвель';   high[7]:=  'Гакстес';   arch[7]:=  'Дрейк';      infr[7]:=  'Флэйр';
      prim[8]:=  'Хак';    low[8]:= 'Гаст';      high[8]:=  'Интиос';    arch[8]:=  'Айзен';      infr[8]:=  'Финиаль';
      prim[9]:=  'Джарр';  low[9]:= 'Игнат';     high[9]:=  'Джастилус'; arch[9]:=  'Феррус';     infr[9]:=  'Грим';
      prim[10]:= 'Кар';    low[10]:= 'Ишмаэль';  high[10]:= 'Кальтос';   arch[10]:= 'Грендель';   infr[10]:= 'Гоб';
      prim[11]:= 'Каарл';  low[11]:= 'Иерихон';  high[11]:= 'Лицилус';   arch[11]:= 'Жиллиман';   infr[11]:= 'Стрелок';
      prim[12]:= 'Крелл';  low[12]:= 'Клайт';    high[12]:= 'Люпус';     arch[12]:= 'Хэвлок';     infr[12]:= 'Хакер';
      prim[13]:= 'Лек';    low[13]:= 'Лазарь';   high[13]:= 'Маллеар';   arch[13]:= 'Иактон';     infr[13]:= 'Джейкс';
      prim[14]:= 'Мар';    low[14]:= 'Мордехай'; high[14]:= 'Металус';   arch[14]:= 'Джагатай';   infr[14]:= 'Крак';
      prim[15]:= 'Мир';    low[15]:= 'Митра';    high[15]:= 'Нигилус';   arch[15]:= 'Хан';        infr[15]:= 'Лаг';
      prim[16]:= 'Нарл';   low[16]:= 'Никодим';  high[16]:= 'Новус';     arch[16]:= 'Леман';      infr[16]:= 'Монгрель';
      prim[17]:= 'Орл';    low[17]:= 'Понтий';   high[17]:= 'Октус';     arch[17]:= 'Лев';        infr[17]:= 'Плекс';
      prim[18]:= 'Френц';  low[18]:= 'Квинт';    high[18]:= 'Претус';    arch[18]:= 'Магнус';     infr[18]:= 'Красный';
      prim[19]:= 'Кварл';  low[19]:= 'Рабалий';  high[19]:= 'Квинтос';   arch[19]:= 'Меркуцио';   infr[19]:= 'Крыса';
      prim[20]:= 'Рот';    low[20]:= 'Ристий';   high[20]:= 'Ральтус';   arch[20]:= 'Никсиос';    infr[20]:= 'Соуни';
      prim[21]:= 'Рага';   low[21]:= 'Сильван';  high[21]:= 'Рэвион';    arch[21]:= 'Рамирес';    infr[21]:= 'Скэб';
      prim[22]:= 'Стиг';   low[22]:= 'Соломон';  high[22]:= 'Регис';     arch[22]:= 'Сергар';     infr[22]:= 'Скэммер';
      prim[23]:= 'Стрэнг'; low[23]:= 'Таддий';   high[23]:= 'Северус';   arch[23]:= 'Сигизмунд';  infr[23]:= 'Скайв';
      prim[24]:= 'Так';    low[24]:= 'Тит';      high[24]:= 'Силон';     arch[24]:= 'Тибальд';    infr[24]:= 'Шенк';
      prim[25]:= 'Ульт';   low[25]:= 'Уриан';    high[25]:= 'Таурон';    arch[25]:= 'Верн';       infr[25]:= 'Шив';
      prim[26]:= 'Варн';   low[26]:= 'Варний';   high[26]:= 'Трэнтор';   arch[26]:= 'Вольф';      infr[26]:= 'Шэм';
      prim[27]:= 'Вракс';  low[27]:= 'Ксеркс';   high[27]:= 'Венрис';    arch[27]:= 'Уолси';      infr[27]:= 'Штерн';
      prim[28]:= 'Ярн';    low[28]:= 'Зэддион';  high[28]:= 'Виктус';    arch[28]:= 'Зэйн';       infr[28]:= 'Стаббер';
      prim[29]:= 'Зэк';    low[29]:= 'Зариэль';  high[29]:= 'Ксантис';   arch[29]:= 'Жарков';     infr[29]:= 'Вербал';
    end;

    //инициализация списка женских имен
    with Self.fnames do
    begin
      prim[0]:=  'Арла';    low[0]:=  'Акадия';    high[0]:=  'Ателла';    arch[0]:=  'Энид';       infr[0]:=  'Альфа';
      prim[1]:=  'Брулла';  low[1]:=  'Хальдия';   high[1]:=  'Брутилла';  arch[1]:=  'Альбия';     infr[1]:=  'Вспышка';
      prim[2]:=  'Дарла';   low[2]:=  'Сайрин';    high[2]:=  'Каллидия';  arch[2]:=  'Борджиа';    infr[2]:=  'Синяя';
      prim[3]:=  'Фрака';   low[3]:=  'Диона';     high[3]:=  'Кастилла';  arch[3]:=  'Кимбрия';    infr[3]:=  'Кошка';
      prim[4]:=  'Фраал';   low[4]:=  'Деатрис';   high[4]:=  'Друстилл';  arch[4]:=  'Дэви';       infr[4]:=  'Каламити';
      prim[5]:=  'Гарма';   low[5]:=  'Эфина';     high[5]:=  'Флавия';    arch[5]:=  'Эфес';       infr[5]:=  'Дама';
      prim[6]:=  'Грыша';   low[6]:=  'Эфраэль';   high[6]:=  'Галлия';    arch[6]:=  'Эфрати';     infr[6]:=  'Дайс';
      prim[7]:=  'Граки';   low[7]:=  'Фенрия';    high[7]:=  'Гакста';    arch[7]:=  'Инес';       infr[7]:=  'Флэйр';
      prim[8]:=  'Хака';    low[8]:=  'Гайя';      high[8]:=  'Интиас';    arch[8]:=  'Императрис'; infr[8]:=  'Золото';
      prim[9]:=  'Джарра';  low[9]:=  'Галатея';   high[9]:=  'Джастилла'; arch[9]:=  'Джемдар';    infr[9]:=  'Стрелок';
      prim[10]:= 'Карна';   low[10]:= 'Хазаэль';   high[10]:= 'Кальта';    arch[10]:= 'Джезаиль';   infr[10]:= 'Хак';
      prim[11]:= 'Каарли';  low[11]:= 'Иша';       high[11]:= 'Лицилла';   arch[11]:= 'Джосс';      infr[11]:= 'Гало';
      prim[12]:= 'Крелла';  low[12]:= 'Ишта';      high[12]:= 'Лупа';      arch[12]:= 'Кадис';      infr[12]:= 'Леди';
      prim[13]:= 'Лекка';   low[13]:= 'Джедия';    high[13]:= 'Маллия';    arch[13]:= 'Кали';       infr[13]:= 'Удача';
      prim[14]:= 'Марла';   low[14]:= 'Юдекка';    high[14]:= 'Мета';      arch[14]:= 'Лета';       infr[14]:= 'Скромность';
      prim[15]:= 'Мира';    low[15]:= 'Лира';      high[15]:= 'Нигилла';   arch[15]:= 'Маэ';        infr[15]:= 'Молл';
      prim[16]:= 'Нарла';   low[16]:= 'Магдалина'; high[16]:= 'Новиа';     arch[16]:= 'Милисента';  infr[16]:= 'Пистоль';
      prim[17]:= 'Орла';    low[17]:= 'Нарция';    high[17]:= 'Октия';     arch[17]:= 'Мерика';     infr[17]:= 'Плекс';
      prim[18]:= 'Фрикс';   low[18]:= 'Офелия';    high[18]:= 'Претия';    arch[18]:= 'Мидкифф';    infr[18]:= 'Прис';
      prim[19]:= 'Квали';   low[19]:= 'Фебия';     high[19]:= 'Квинтилла'; arch[19]:= 'Мегера';     infr[19]:= 'Крыса';
      prim[20]:= 'Рота';    low[20]:= 'Квалия';    high[20]:= 'Ральтия';   arch[20]:= 'Одесса';     infr[20]:= 'Рыжая';
      prim[21]:= 'Рагана';  low[21]:= 'Риа';       high[21]:= 'Рэвия';     arch[21]:= 'Орлеан';     infr[21]:= 'Руби';
      prim[22]:= 'Стигга';  low[22]:= 'Саломея';   high[22]:= 'Регия';     arch[22]:= 'Плато';      infr[22]:= 'Скарлет';
      prim[23]:= 'Стрэнга'; low[23]:= 'Солария';   high[23]:= 'Северина';  arch[23]:= 'Скифия';     infr[23]:= 'Шип';
      prim[24]:= 'Такка';   low[24]:= 'Тиратия';   high[24]:= 'Сила';      arch[24]:= 'Фиопия';     infr[24]:= 'Сталь';
      prim[25]:= 'Ульта';   low[25]:= 'Феба';      high[25]:= 'Таура';     arch[25]:= 'Трэйс';      infr[25]:= 'Старр';
      prim[26]:= 'Варна';   low[26]:= 'Уриэль';    high[26]:= 'Трэнтия';   arch[26]:= 'Царина';     infr[26]:= 'Травма';
      prim[27]:= 'Вракса';  low[27]:= 'Вейда';     high[27]:= 'Венрия';    arch[27]:= 'Венера';     infr[27]:= 'Трик';
      prim[28]:= 'Ярни';    low[28]:= 'Ксантиппа'; high[28]:= 'Виктия';    arch[28]:= 'Вальпурга';  infr[28]:= 'Трикси';
      prim[29]:= 'Зэкка';   low[29]:= 'Зипатра';   high[29]:= 'Ксантия';   arch[29]:= 'Жеткин';     infr[29]:= 'Зи';
    end;

    //добавления от 01.02.2015

    //названия классов
    Self.cnames[0]:= 'Адепт';    Self.cnames[1]:= 'Арбитр';
    Self.cnames[2]:= 'Убийца';   Self.cnames[3]:= 'Клирик';
    Self.cnames[4]:= 'Гвардеец'; Self.cnames[5]:= 'Псайкер';
    Self.cnames[6]:= 'Подонок';  Self.cnames[7]:= 'Техножрец';

    //названия параметров
    Self.snames[0]:= 'Ближний бой';  Self.snames[1]:= 'Стрельба';
    Self.snames[2]:= 'Сила';         Self.snames[3]:= 'Выносливость';
    Self.snames[4]:= 'Ловкость';     Self.snames[5]:= 'Интеллект';
    Self.snames[6]:= 'Восприятие';   Self.snames[7]:= 'Сила воли';
    Self.snames[8]:= 'Товарищество';

    //бонусы к параметрам от происхождения НИП
    //дикий мир
    Self.sbonus[0,0]:= 20; Self.sbonus[0,1]:= 20;
    Self.sbonus[0,2]:= 25; Self.sbonus[0,3]:= 25;
    Self.sbonus[0,4]:= 20; Self.sbonus[0,5]:= 20;
    Self.sbonus[0,6]:= 20; Self.sbonus[0,7]:= 15;
    Self.sbonus[0,8]:= 15;
    //мир-улей
    Self.sbonus[1,0]:= 20; Self.sbonus[1,1]:= 20;
    Self.sbonus[1,2]:= 20; Self.sbonus[1,3]:= 15;
    Self.sbonus[1,4]:= 20; Self.sbonus[1,5]:= 20;
    Self.sbonus[1,6]:= 20; Self.sbonus[1,7]:= 20;
    Self.sbonus[1,8]:= 25;
    //имперский мир
    Self.sbonus[2,0]:= 20; Self.sbonus[2,1]:= 20;
    Self.sbonus[2,2]:= 20; Self.sbonus[2,3]:= 20;
    Self.sbonus[2,4]:= 20; Self.sbonus[2,5]:= 20;
    Self.sbonus[2,6]:= 20; Self.sbonus[2,7]:= 20;
    Self.sbonus[2,8]:= 20;
    //рождённый в Пустоте
    Self.sbonus[3,0]:= 20; Self.sbonus[3,1]:= 20;
    Self.sbonus[3,2]:= 15; Self.sbonus[3,3]:= 20;
    Self.sbonus[3,4]:= 20; Self.sbonus[3,5]:= 20;
    Self.sbonus[3,6]:= 20; Self.sbonus[3,7]:= 25;
    Self.sbonus[3,8]:= 20;

    //вероятности специальностей от происхождения
    //дикий мир
    Self.sprobs[0,0]:= 0;  Self.sprobs[0,1]:= 0;  Self.sprobs[0,2]:= 30; Self.sprobs[0,3]:= 0;
    Self.sprobs[0,4]:= 50; Self.sprobs[0,5]:= 10; Self.sprobs[0,6]:= 10; Self.sprobs[0,7]:= 0;
    //мир-улей
    Self.sprobs[1,0]:= 0;  Self.sprobs[1,1]:= 17; Self.sprobs[1,2]:= 3;  Self.sprobs[1,3]:= 5;
    Self.sprobs[1,4]:= 10; Self.sprobs[1,5]:= 4;  Self.sprobs[1,6]:= 50; Self.sprobs[1,7]:= 11;
    //имперский мир
    Self.sprobs[2,0]:= 12; Self.sprobs[2,1]:= 13; Self.sprobs[2,2]:= 13; Self.sprobs[2,3]:= 14;
    Self.sprobs[2,4]:= 13; Self.sprobs[2,5]:= 14; Self.sprobs[2,6]:= 11; Self.sprobs[2,7]:= 10;
    //рожденный в Пустоте
    Self.sprobs[3,0]:= 10; Self.sprobs[3,1]:= 10; Self.sprobs[3,2]:= 5;  Self.sprobs[3,3]:= 10;
    Self.sprobs[3,4]:= 0;  Self.sprobs[3,5]:= 40; Self.sprobs[3,6]:= 10; Self.sprobs[3,7]:= 15;

    //названия фракций
    Self.factions[0]:= 'Горожанин';     Self.factions[1]:= 'Бандит';
    Self.factions[2]:= 'Арбитрес';      Self.factions[3]:= 'Имперская Гвардия';
    Self.factions[4]:= 'Еретики';       Self.factions[5]:= 'Экклезиархия';
    Self.factions[6]:= 'Механикум';     Self.factions[7]:= 'Ордо Ксенос';
    Self.factions[8]:= 'Ордо Еретикус'; Self.factions[9]:= 'Ордо Маллеус';

    //названия психотипов
    Self.pnames[0]:= 'Желчный';   Self.pnames[1]:= 'Кардинал';   Self.pnames[2]:= 'Холерик';
    Self.pnames[3]:= 'Стоик';     Self.pnames[4]:= 'Меланхолик'; Self.pnames[5]:= 'Переменчивый';
    Self.pnames[6]:= 'Флегматик'; Self.pnames[7]:= 'Сангвиник';  Self.pnames[8]:= 'Пассивный';

    //вероятности получения социальных статусов
    Self.fprobs[0]:= 80; Self.fprobs[1]:= 25;
    Self.fprobs[2]:= 18; Self.fprobs[3]:= 30;
    Self.fprobs[4]:= 5;  Self.fprobs[5]:= 15;
    Self.fprobs[6]:= 10; Self.fprobs[7]:= 2;
    Self.fprobs[8]:= 2;  Self.fprobs[9]:= 2;

    //вероятности получения субстатусов (званий)
    Self.lprobs[0]:= 67; Self.lprobs[1]:= 7;
    Self.lprobs[2]:= 23; Self.lprobs[3]:= 3;

    //Добавления от 04.02.2015-05.02.2015
    //строка расширения графических файлов (const, использовать при генерации ссылки на картинку)
    Self.grexe:= '.png';

    //Добавления от 29.05.2015
    //массив названий порядковых номеров планет
    Self.plnames[0]:= 'Примус';   Self.plnames[1]:= 'Секундус';
    Self.plnames[2]:= 'Терциус';  Self.plnames[3]:= 'Кварта';
    Self.plnames[4]:= 'Пинтус';   Self.plnames[5]:= 'Секстус';
    Self.plnames[6]:= 'Септимус'; Self.plnames[7]:= 'Октус';
    Self.plnames[8]:= 'Нонус';    Self.plnames[9]:= 'Децимус';

    //Добавления от 01.07.2015
    //массив модификаторов склонностей

    //модификаторы класса
    //класс Адепт
    Self.addmods.clasmods[0][ag_force]:= -20;   Self.addmods.clasmods[0][ag_court]:= 15;
    Self.addmods.clasmods[0][ag_stealth]:= -15; Self.addmods.clasmods[0][ag_investigation]:= 20;
    Self.addmods.clasmods[0][ag_others]:= 0;

    //класс Арбитр
    Self.addmods.clasmods[1][ag_force]:= 15;    Self.addmods.clasmods[1][ag_court]:= -15;
    Self.addmods.clasmods[1][ag_stealth]:= -20; Self.addmods.clasmods[1][ag_investigation]:= 20;
    Self.addmods.clasmods[1][ag_others]:= 0;

    //класс Убийца
    Self.addmods.clasmods[2][ag_force]:= -15;   Self.addmods.clasmods[2][ag_court]:= -20;
    Self.addmods.clasmods[2][ag_stealth]:= 20;  Self.addmods.clasmods[2][ag_investigation]:= 15;
    Self.addmods.clasmods[2][ag_others]:= 0;

    //класс Клирик
    Self.addmods.clasmods[3][ag_force]:= -10;   Self.addmods.clasmods[3][ag_court]:= 15;
    Self.addmods.clasmods[3][ag_stealth]:= -15; Self.addmods.clasmods[3][ag_investigation]:= 10;
    Self.addmods.clasmods[3][ag_others]:= 0;

    //класс Гвардеец
    Self.addmods.clasmods[4][ag_force]:= 20;    Self.addmods.clasmods[4][ag_court]:= -20;
    Self.addmods.clasmods[4][ag_stealth]:= 15;  Self.addmods.clasmods[4][ag_investigation]:= -15;
    Self.addmods.clasmods[4][ag_others]:= 0;

    //класс Псайкер
    Self.addmods.clasmods[5][ag_force]:= -20;   Self.addmods.clasmods[5][ag_court]:= -15;
    Self.addmods.clasmods[5][ag_stealth]:= 15;  Self.addmods.clasmods[5][ag_investigation]:= 20;
    Self.addmods.clasmods[5][ag_others]:= 0;

    //класс Подонок
    Self.addmods.clasmods[6][ag_force]:= 15;    Self.addmods.clasmods[6][ag_court]:= -15;
    Self.addmods.clasmods[6][ag_stealth]:= 20;  Self.addmods.clasmods[6][ag_investigation]:= -20;
    Self.addmods.clasmods[6][ag_others]:= 0;

    //класс Техножрец
    Self.addmods.clasmods[7][ag_force]:= 15;    Self.addmods.clasmods[7][ag_court]:= -15;
    Self.addmods.clasmods[7][ag_stealth]:= -20; Self.addmods.clasmods[7][ag_investigation]:= 20;
    Self.addmods.clasmods[7][ag_others]:= 0;

    //модификаторы происхождения
    //происхождение Дикий мир
    Self.addmods.origmods[0][ag_force]:= 20;    Self.addmods.origmods[0][ag_court]:= -20;
    Self.addmods.origmods[0][ag_stealth]:= 10;  Self.addmods.origmods[0][ag_investigation]:= -10;
    Self.addmods.origmods[0][ag_others]:= 0;

    //происхождение Мир-улей
    Self.addmods.origmods[1][ag_force]:= -10;   Self.addmods.origmods[1][ag_court]:= 15;
    Self.addmods.origmods[1][ag_stealth]:= 15;  Self.addmods.origmods[1][ag_investigation]:= 10;
    Self.addmods.origmods[1][ag_others]:= 0;

    //происхождение Имперский мир
    Self.addmods.origmods[2][ag_force]:= 10;    Self.addmods.origmods[2][ag_court]:= 20;
    Self.addmods.origmods[2][ag_stealth]:= -20; Self.addmods.origmods[2][ag_investigation]:= -10;
    Self.addmods.origmods[2][ag_others]:= 0;

    //происхождение Пустота
    Self.addmods.origmods[3][ag_force]:= -20;   Self.addmods.origmods[3][ag_court]:= -10;
    Self.addmods.origmods[3][ag_stealth]:= 10;  Self.addmods.origmods[3][ag_investigation]:= 20;
    Self.addmods.origmods[3][ag_others]:= 0;

    //модификаторы фракции
    //фракция Горожане
    Self.addmods.factmods[0][ag_force]:= -10;   Self.addmods.factmods[0][ag_court]:= 10;
    Self.addmods.factmods[0][ag_stealth]:= 10;  Self.addmods.factmods[0][ag_investigation]:= -10;
    Self.addmods.factmods[0][ag_others]:= 0;

    //фракция Бандиты
    Self.addmods.factmods[1][ag_force]:= 15;    Self.addmods.factmods[1][ag_court]:= -15;
    Self.addmods.factmods[1][ag_stealth]:= 15;  Self.addmods.factmods[1][ag_investigation]:= -15;
    Self.addmods.factmods[1][ag_others]:= 0;

    //фракция Арбитрес
    Self.addmods.factmods[2][ag_force]:= 15;    Self.addmods.factmods[2][ag_court]:= -15;
    Self.addmods.factmods[2][ag_stealth]:= -20; Self.addmods.factmods[2][ag_investigation]:= 20;
    Self.addmods.factmods[2][ag_others]:= 0;

    //фракция Имперская Гвардия
    Self.addmods.factmods[3][ag_force]:= 20;    Self.addmods.factmods[3][ag_court]:= -20;
    Self.addmods.factmods[3][ag_stealth]:= 10;  Self.addmods.factmods[3][ag_investigation]:= -10;
    Self.addmods.factmods[3][ag_others]:= 0;

    //фракция Еретики
    Self.addmods.factmods[4][ag_force]:= 0;     Self.addmods.factmods[4][ag_court]:= 0;
    Self.addmods.factmods[4][ag_stealth]:= 0;   Self.addmods.factmods[4][ag_investigation]:= 0;
    Self.addmods.factmods[4][ag_others]:= 0;

    //фракция Экклезиархия
    Self.addmods.factmods[5][ag_force]:= -10;   Self.addmods.factmods[5][ag_court]:= 20;
    Self.addmods.factmods[5][ag_stealth]:= -20; Self.addmods.factmods[5][ag_investigation]:= 10;
    Self.addmods.factmods[5][ag_others]:= 0;

    //фракция Механикум
    Self.addmods.factmods[6][ag_force]:= 15;    Self.addmods.factmods[6][ag_court]:= -15;
    Self.addmods.factmods[6][ag_stealth]:= -20; Self.addmods.factmods[6][ag_investigation]:= 20;
    Self.addmods.factmods[6][ag_others]:= 0;

    //фракция Ордо Ксенос
    Self.addmods.factmods[7][ag_force]:= 0;     Self.addmods.factmods[7][ag_court]:= 0;
    Self.addmods.factmods[7][ag_stealth]:= 0;   Self.addmods.factmods[7][ag_investigation]:= 0;
    Self.addmods.factmods[7][ag_others]:= 0;

    //фракция Ордо Еретикус
    Self.addmods.factmods[8][ag_force]:= 0;     Self.addmods.factmods[8][ag_court]:= 0;
    Self.addmods.factmods[8][ag_stealth]:= 0;   Self.addmods.factmods[8][ag_investigation]:= 0;
    Self.addmods.factmods[8][ag_others]:= 0;

    //фракция Ордо Маллеус
    Self.addmods.factmods[9][ag_force]:= 0;     Self.addmods.factmods[9][ag_court]:= 0;
    Self.addmods.factmods[9][ag_stealth]:= 0;   Self.addmods.factmods[9][ag_investigation]:= 0;
    Self.addmods.factmods[9][ag_others]:= 0;

    //добавления от 03.07.2015
    //модификаторы параметров DMS

    //модификаторы класса
    //класс Адепт
    Self.dmsmods.clasmods[0][dp_diligence]:= 20; Self.dmsmods.clasmods[0][dp_identity]:= 20;
    Self.dmsmods.clasmods[0][dp_calmness]:= 0;  Self.dmsmods.clasmods[0][dp_educability]:= 20;
    Self.dmsmods.clasmods[0][dp_authority]:= 10;

    //класс Арбитр
    Self.dmsmods.clasmods[1][dp_diligence]:= 20; Self.dmsmods.clasmods[1][dp_identity]:= 10;
    Self.dmsmods.clasmods[1][dp_calmness]:= 20;  Self.dmsmods.clasmods[1][dp_educability]:= 0;
    Self.dmsmods.clasmods[1][dp_authority]:= 15;

    //класс Убийца
    Self.dmsmods.clasmods[2][dp_diligence]:= 5; Self.dmsmods.clasmods[2][dp_identity]:= 20;
    Self.dmsmods.clasmods[2][dp_calmness]:= 20;  Self.dmsmods.clasmods[2][dp_educability]:= 0;
    Self.dmsmods.clasmods[2][dp_authority]:= -10;

    //класс Клирик
    Self.dmsmods.clasmods[3][dp_diligence]:= 20; Self.dmsmods.clasmods[3][dp_identity]:= -10;
    Self.dmsmods.clasmods[3][dp_calmness]:= 10;  Self.dmsmods.clasmods[3][dp_educability]:= -10;
    Self.dmsmods.clasmods[3][dp_authority]:= 20;

    //класс Гвардеец
    Self.dmsmods.clasmods[4][dp_diligence]:= 20; Self.dmsmods.clasmods[4][dp_identity]:= 10;
    Self.dmsmods.clasmods[4][dp_calmness]:= 20;  Self.dmsmods.clasmods[4][dp_educability]:= 0;
    Self.dmsmods.clasmods[4][dp_authority]:= 0;

    //класс Псайкер
    Self.dmsmods.clasmods[5][dp_diligence]:= 10; Self.dmsmods.clasmods[5][dp_identity]:= 15;
    Self.dmsmods.clasmods[5][dp_calmness]:= 10;  Self.dmsmods.clasmods[5][dp_educability]:= 15;
    Self.dmsmods.clasmods[5][dp_authority]:= -20;

    //класс Подонок
    Self.dmsmods.clasmods[6][dp_diligence]:= -20; Self.dmsmods.clasmods[6][dp_identity]:= -15;
    Self.dmsmods.clasmods[6][dp_calmness]:= 10;  Self.dmsmods.clasmods[6][dp_educability]:= -10;
    Self.dmsmods.clasmods[6][dp_authority]:= 0;

    //класс Техножрец
    Self.dmsmods.clasmods[7][dp_diligence]:= 10; Self.dmsmods.clasmods[7][dp_identity]:= 20;
    Self.dmsmods.clasmods[7][dp_calmness]:= 20;  Self.dmsmods.clasmods[7][dp_educability]:= 20;
    Self.dmsmods.clasmods[7][dp_authority]:= 10;

    //модификаторы происхождения
    //происхождение Дикий мир
    Self.dmsmods.origmods[0][dp_diligence]:= 20; Self.dmsmods.origmods[0][dp_identity]:= 10;
    Self.dmsmods.origmods[0][dp_calmness]:= 10;  Self.dmsmods.origmods[0][dp_educability]:= -10;
    Self.dmsmods.origmods[0][dp_authority]:= -10;

    //происхождение Мир-улей
    Self.dmsmods.origmods[1][dp_diligence]:= -15; Self.dmsmods.origmods[1][dp_identity]:= -10;
    Self.dmsmods.origmods[1][dp_calmness]:= 10;  Self.dmsmods.origmods[1][dp_educability]:= 15;
    Self.dmsmods.origmods[1][dp_authority]:= 10;

    //происхождение Имперский мир
    Self.dmsmods.origmods[2][dp_diligence]:= 10; Self.dmsmods.origmods[2][dp_identity]:= -5;
    Self.dmsmods.origmods[2][dp_calmness]:= 5;  Self.dmsmods.origmods[2][dp_educability]:= 5;
    Self.dmsmods.origmods[2][dp_authority]:= 15;

    //происхождение Пустота
    Self.dmsmods.origmods[3][dp_diligence]:= -5; Self.dmsmods.origmods[3][dp_identity]:= 20;
    Self.dmsmods.origmods[3][dp_calmness]:= 15;  Self.dmsmods.origmods[3][dp_educability]:= 20;
    Self.dmsmods.origmods[3][dp_authority]:= -15;

    //модификаторы фракции
    //фракция Горожане
    Self.dmsmods.factmods[0][dp_diligence]:= 10; Self.dmsmods.factmods[0][dp_identity]:= -20;
    Self.dmsmods.factmods[0][dp_calmness]:= -20;  Self.dmsmods.factmods[0][dp_educability]:= 0;
    Self.dmsmods.factmods[0][dp_authority]:= 0;

    //фракция Бандиты
    Self.dmsmods.factmods[1][dp_diligence]:= -20; Self.dmsmods.factmods[1][dp_identity]:= -15;
    Self.dmsmods.factmods[1][dp_calmness]:= 5;  Self.dmsmods.factmods[1][dp_educability]:= -5;
    Self.dmsmods.factmods[1][dp_authority]:= -5;

    //фракция Арбитрес
    Self.dmsmods.factmods[2][dp_diligence]:= 20; Self.dmsmods.factmods[2][dp_identity]:= 10;
    Self.dmsmods.factmods[2][dp_calmness]:= 10;  Self.dmsmods.factmods[2][dp_educability]:= 5;
    Self.dmsmods.factmods[2][dp_authority]:= 15;

    //фракция Имперская Гвардия
    Self.dmsmods.factmods[3][dp_diligence]:= 20; Self.dmsmods.factmods[3][dp_identity]:= 10;
    Self.dmsmods.factmods[3][dp_calmness]:= 15;  Self.dmsmods.factmods[3][dp_educability]:= 5;
    Self.dmsmods.factmods[3][dp_authority]:= 10;

    //фракция Еретики
    Self.dmsmods.factmods[4][dp_diligence]:= 0; Self.dmsmods.factmods[4][dp_identity]:= 0;
    Self.dmsmods.factmods[4][dp_calmness]:= 0;  Self.dmsmods.factmods[4][dp_educability]:= 0;
    Self.dmsmods.factmods[4][dp_authority]:= 0;

    //фракция Экклезиархия
    Self.dmsmods.factmods[5][dp_diligence]:= 20; Self.dmsmods.factmods[5][dp_identity]:= -10;
    Self.dmsmods.factmods[5][dp_calmness]:= -5;  Self.dmsmods.factmods[5][dp_educability]:= -10;
    Self.dmsmods.factmods[5][dp_authority]:= 20;

    //фракция Механикум
    Self.dmsmods.factmods[6][dp_diligence]:= 5; Self.dmsmods.factmods[6][dp_identity]:= 20;
    Self.dmsmods.factmods[6][dp_calmness]:= 20;  Self.dmsmods.factmods[6][dp_educability]:= 20;
    Self.dmsmods.factmods[6][dp_authority]:= 15;

    //фракция Ордо Ксенос
    Self.dmsmods.factmods[7][dp_diligence]:= 20; Self.dmsmods.factmods[7][dp_identity]:= 15;
    Self.dmsmods.factmods[7][dp_calmness]:= 20;  Self.dmsmods.factmods[7][dp_educability]:= 15;
    Self.dmsmods.factmods[7][dp_authority]:= 20;

    //фракция Ордо Еретикус
    Self.dmsmods.factmods[8][dp_diligence]:= 20; Self.dmsmods.factmods[8][dp_identity]:= 15;
    Self.dmsmods.factmods[8][dp_calmness]:= 20;  Self.dmsmods.factmods[8][dp_educability]:= 15;
    Self.dmsmods.factmods[8][dp_authority]:= 20;

    //фракция Ордо Маллеус
    Self.dmsmods.factmods[9][dp_diligence]:= 20; Self.dmsmods.factmods[9][dp_identity]:= 15;
    Self.dmsmods.factmods[9][dp_calmness]:= 20;  Self.dmsmods.factmods[9][dp_educability]:= 15;
    Self.dmsmods.factmods[9][dp_authority]:= 20;

    //массив названий групп действий
    Self.actnames[ag_force]:='Силовые';    Self.actnames[ag_court]:='Светские';
    Self.actnames[ag_stealth]:='Скрытные'; Self.actnames[ag_investigation]:='Следственные';
    Self.actnames[ag_others]:='Прочие';

    //добавления от 16.07.2015
    //массив названий параметров DMS
    Self.dmsnames[dp_diligence]:= 'Исполнительность'; Self.dmsnames[dp_identity]:= 'Самосознание';
    Self.dmsnames[dp_calmness]:= 'Хладнокровие';      Self.dmsnames[dp_educability]:= 'Обучаемость';
    Self.dmsnames[dp_authority]:= 'Авторитетность';
  end;

//конструктор НИП
  constructor THuman.create (Stock: TStorage);
  //изменения от 01.02.2015 - убраны константы вероятностных диапазонов
  //изменения от 04.02.2015-05.02.2015 - добавлена преинициализация массива контактов
  //изменения от 14.07.2015 - добавлена инициализация параметров психотипа и DMS
  var
    i,j,k: Byte;     //однобайтовые счетчики циклов
    ag: TActGroups;  //счетчик для перебора групп действий
    dp: TDMSParams;  //счетчик для перебора параметров DMS
    factsum: TSCent; //временная переменная для модификатора фракции (-20..20)
  begin
    //генерация пола
    Randomize;
    //если случайное число от 0 до 1000 - четное, пол мужской, иначе женский
    Self.gender:= (((Random(2)+1) div 2) = 0);
    //инициализация адреса НИП как пустого (НИП еще никуда не поселен)
    Self.address:= -1;
    //генерация типа родного мира
    Self.origin:= Random(4);
    //определение имени из 3 слов (индексов, указывающих на языковую группу и номер имени внутри группы)
    for i:=0 to 2 do
    begin
      Self.name[i][0]:= Random(4); //определение языковой группы, к которой относится часть имени (группа infr не используется, т.к. отвечает за ники)
      Self.name[i][1]:= Random(30); //определение номера имени внутри языковой группы
    end;
    //генерация внешности
    //телосложение
    Self.outlook[ol_bodytype]:= Random(5);
    //цвет кожи
    Self.outlook[ol_skin]:= Random(5);
    //цвет глаз
    Self.outlook[ol_eyes]:= Random(5);
    //цвет волос
    Self.outlook[ol_hair]:= Random(5);
    //особые приметы
    Self.outlook[ol_perk1]:= Random(16);
    repeat
      Self.outlook[ol_perk2]:= Random(16);
    until (Self.outlook[ol_perk2]<>Self.outlook[ol_perk1]);
    repeat
      Self.outlook[ol_perk3]:= Random(16);
    until ((Self.outlook[ol_perk3]<>Self.outlook[ol_perk1])and(Self.outlook[ol_perk3]<>Self.outlook[ol_perk2]));
    //генерация возраста
    Self.age:= genrnd(25+Random(30), 20+Random(20));
    //дополнения и изменения от 01.02.2015
    //убрана генерация флажков еретика и псайкера, добавлена генерация принадлежности к социальным группам
    //порядок проверки: 1-3)проверка Ксенос-Еретикус-Маллеус (т.к. имеют минимальную вероятность)
    //4)Еретики 5)Механикус 6)Экклезиархия 7)Арбитрес 8)Бандиты 9)Гвардия 10)Горожанин
    //логика проверки следующая - проверка идет по восходящей вероятности для отсечения лишних проверок (гарнтированно несовместных статусов)
    //преинициализация социальных статусов (начальное значение - ложь)ъ
    for i:= 0 to 9 do
      Self.factions[i]:= False;
    //Проверка на принадлежность к Ордо Маллеус (НИП не должен принадлежать к еретикам, Ордо Ксенос и Ордо Еретикус)
    if (Random(101) <= Stock.fprobs[9]) then
      Self.factions[9]:= True;
    //Проверка на принадлежность к Ордо Еретикус (НИП не должен принадлежать к Ордо Маллеус)
    if (Random(101) <= Stock.fprobs[8]) and (Self.factions[9] = False) then
      Self.factions[8]:= True;
    //Проверка на принадлежность к Ордо Ксенос (НИП не должен принадлежать к Ордо Маллеус и Ордо Еретикус)
    if (Random(101) <= Stock.fprobs[7]) and (Self.factions[9] = False) and (Self.factions[8] = False) then
      Self.factions[7]:= True;
    //Проверка на принадлежность к еретикам (НИП не должен принадлежать к Ордо Ксенос, Ордо Еретикус, Ордо Маллеус)
    if (Random(101) <= Stock.fprobs[4]) and (Self.factions[9] = False) and (Self.factions[8] = False) and (Self.factions[7] = False) then
      Self.factions[4]:= True;
    //проверка на принадлежность к Механикус
    if (Random(101) <= Stock.fprobs[6]) then
      Self.factions[6]:= True;
    //проверка на принадлежность к Экклезиархии (НИП не должен принадлежать к Механикус)
    if (Random(101) <= Stock.fprobs[5]) and (Self.factions[6] = False) then
      Self.factions[5]:= True;
    //проверка на принадлежность к Арбитрес (НИП не должен принадлежать к Экклезиархии и Механикус)
    if (Random(101) <= Stock.fprobs[2]) and (Self.factions[6] = False) and (Self.factions[5] = False) then
      Self.factions[2]:= True;
    //проверка на принадлежность к бандитам (НИП не должен принадлежать к Арбитрес, Экклезиархии и Механикус)
    if (Random(101) <= Stock.fprobs[1]) and (Self.factions[6] = False) and (Self.factions[5] = False) and (Self.factions[2] = False) then
      Self.factions[1]:= True;
    //проверка на принадлежность к Гвардии (НИП не должен принадлежать к бандитам и Арбитрес)
    if (Random(101) <= Stock.fprobs[3]) and (Self.factions[1] = False) and (Self.factions[2] = False) then
      Self.factions[3]:= True;
    //проверка на принадлежность к горожанам (НИП не должен принадлежать к Арбитрес, Гвардии, Экклезиархии и Механикус)
    if (Self.factions[2] = False) and (Self.factions[3] = False) and (Self.factions[5] = False) and (Self.factions[6] = False) then
      Self.factions[0]:= True;
    //генерация параметров персонажа по уравнению Пар = СлЧ(20) + ПрБ, где: Пар - итоговое значение параметра, СлЧ - функция генерации случайного числа от 1 до 20, ПрБ - бонус родного мира
    for i:=0 to 8 do
      Self.stats[i]:= (Random(20) + 2) + Stock.sbonus[Self.origin, i];
    //психотип
    Self.psychotype:= Random(89) div 10; // определение психотипа НИП
    //определение специальности НИП
    Self.specialty:= 8; //преинициализация идентификатора специальности (идентификатор устанавливается вне пределов действующего диапазона - 0..7)
    i:= 0; //инициализация счетчика для перебора специальностей
    k:= 0;
    repeat
      if (i>7) then i:= 0; //если превышен диапазон перебора (0..7) то вернуть счетчик в начало
      //если случайное число укладывается в диапазон (0..Р), где Р - вероятность специальности для данного типа родного мира, присвоить персонажу эту специальность
      if((Random(100)+1) <= Stock.sprobs[Self.origin,i]) then
        Self.specialty:= i;
      i:= i+1; //сместить счетчик на одну позицию
      k:= k+1; //подсчет проходов (для аварийного выхода
    until (Self.specialty < 8) or (k >= 100); //условие выхода из цикла - попадание идентификатора специальности в диапазон 0..7 либо сделано 100 безрезультатных проходов
    //получение звания в группах, в которых он состоит
    for i:=0 to 9 do
    //если НИП принадлежит к фракции, начать генерацию звания
      if (Self.factions[i]) then
      begin
        Self.ladder[i]:=4; //преинициализация звания вне рабочего деиапазона (0..3)
        j:= 0; //установка счетчика на ноль
        k:= 0;
        repeat
          if (j > 3) then j:= 0; //если счетчик вышел из рабочего диапазона, вернуть его в начало
          //если случайное число от 0 до 100 лежит в диапазоне 0..Р, где Р - вероятность звания, установить значение поля равным текущему значению счетчика
          if (Random(101) <= Stock.lprobs[j]) then
            Self.ladder[i]:= j;
          j:= j + 1;
          k:= k + 1;
        until (Self.ladder[i] < 4) or (k >= 100);
      end;
    //дополнения от 14.07.2015
    //инициализация массивов параметров DMS и склонностей
    //массив склонностей
    //преинициализация массива склонностей
      for ag:= ag_force to ag_others do
      begin
        Self.addictions[ag]:= Random(81) - 40; //каждый параметр массива склонностей инициализируется случайным числом -40..40
      end;
    //применение модификаторов к массиву склонностей
      for ag:= ag_force to ag_others do
      begin
      //модификатор класса
        Self.addictions[ag]:= Self.addictions[ag] + Stock.addmods.clasmods[Self.specialty][ag];
      //модификатор происхождения
        Self.addictions[ag]:= Self.addictions[ag] + Stock.addmods.origmods[Self.origin][ag];
      //модификаторы фракций
      //преинициализация
        factsum:= 0;
      //расчет суммарного модификатора по текущему параметру DMS
        for i:= 0 to 9 do
        begin
        //применяются только модификаторы фракций, к которым принадлежит НИП
          if Self.factions[i] then
          begin
            factsum:= factsum + Stock.addmods.factmods[i][ag];
          //если сумма вышла за границы, вернуть в предельное значение
            if (factsum < -20) then
              factsum:= -20;
            if (factsum > 20) then
              factsum:= 20;
          end;
        end;
      //применение суммарного модификатора фракций
        Self.addictions[ag]:= Self.addictions[ag] + factsum;
      end;
    //массив параметров DMS
    //преинициализация массива параметров DMS НИП
      for dp:= dp_diligence to dp_authority do
      begin
        Self.dmsparams[dp]:= Random(81) - 40; //каждый параметр DMS НИП инициализируется как случайное число -40..40
      end;
    //применение модификаторов параметров DMS
      for dp:= dp_diligence to dp_authority do
      begin
      //модификатор класса
        Self.dmsparams[dp]:= Self.dmsparams[dp] + Stock.dmsmods.clasmods[Self.specialty][dp];
      //модификаторы происхождения
        Self.dmsparams[dp]:= Self.dmsparams[dp] + Stock.dmsmods.origmods[Self.origin][dp];
      //модификаторы фракций
      //преинициализация
        factsum:= 0;
      //расчет суммарного модификатора по текущему параметру DMS
        for i:= 0 to 9 do
        begin
        //применяются только модификаторы фракций, к которым принадлежит НИП
          if Self.factions[i] then
          begin
            factsum:= factsum + Stock.dmsmods.factmods[i][dp];
          //если сумма вышла за границы, вернуть в предельное значение
            if (factsum < -20) then
              factsum:= -20;
            if (factsum > 20) then
              factsum:= 20;
          end;
        end;
      //применение суммарного модификатора DMS
        Self.dmsparams[dp]:= Self.dmsparams[dp] + factsum;
      end;
    //дополнения от 04.02.2015-05.02.2015
    //преинициализация массива контактов
    for i:=0 to 5 do
      Self.contacts[i]:= -1; //все индексы устанавливаются в -1 (вне рабочего диапазона)
    //принудительная задержка в 1 мс для корректной работы генератора случайных чисел
    Sleep(1);
  end;

//конструктор класса планеты
  constructor TPlanet.create;
  var
    i,j: Integer;
  begin
  //инициализация и заполнение дата-хранилища
    if (Self.store = nil) then
      Self.store:= TStorage.create;
    Self.store.initialize;
  //добавления от 17.08.2015
  //инициализация города и расселение НИП по домам
    if (Self.housing = nil) then
      Self.housing:= TCity.create(1001);
    Self.housing.settle(1001);
  //генерация населения
    for i:=0 to 1000 do
      Self.people[i]:= THuman.create(Self.store);
  //добавления от 17.08.2015
  //раздача НИП адресов в городе
    for i:= 0 to high(Self.housing.houselist) do
      for j:= 0 to (HOUSE_CAPACITY - 1) do
      begin
        Self.people[Self.housing.houselist[i].people[j]]:= i;
      end;
  //добавления от 01.02.2015
  //определение типа планеты
    Randomize;
    Self.kind:= Random(4);
  //преинициадизация статистики по фракциям (предварительное обнуление)
    for i:=0 to 9 do
      Self.factions[i]:=0;
  //Инициализация точки отсчета
    for i:=0 to 2 do
    begin
      if (i = 0) then
        Self.time[i]:= 40000 + Random(500); //год
      if (i = 1) then
        Self.time[i]:= Random(12)+1; //месяц
      if (i = 2) then
        Self.time[i]:= Random(30) + 1; //день
    end;
  //инициализация названия планеты
    Randomize;
    Self.name[1]:= Self.store.plnames[Random(10)]; //иницализация порядкового номера планеты
    //
    i:= Random(4); //определение языковой группы, к которой относится часть имени (группа infr не используется, т.к. отвечает за ники)
    j:= Random(30); //определение номера имени внутри языковой группы
    //
    case i of
    0: begin
         if ((random(1001) mod 101) <= 50) then
            Self.name[0]:= Self.store.mnames.prim[j]
         else
            Self.name[0]:= Self.store.fnames.prim[j];
       end;
    1: begin
         if ((random(1001) mod 101) <= 50) then
            Self.name[0]:= Self.store.mnames.low[j]
         else
            Self.name[0]:= Self.store.fnames.low[j];
       end;
    2: begin
         if ((random(1001) mod 101) <= 50) then
            Self.name[0]:= Self.store.mnames.high[j]
         else
            Self.name[0]:= Self.store.fnames.high[j];
       end;
    3: begin
         if ((random(1001) mod 101) <= 50) then
            Self.name[0]:= Self.store.mnames.arch[j]
         else
            Self.name[0]:= Self.store.fnames.arch[j];
       end;
    end;
  end;


//генерация сети контактов
  procedure TPlanet.connect;
  var
    i, k, rndig: Integer;
    j, frees: Byte;
  begin
    Randomize;
    for i:=0 to 1000 do
    begin
      for j:=0 to 5 do
      begin
        if (Self.people[i].contacts[j] = -1) then
        begin
          repeat
            rndig:= Random(1001);
            frees:= 0;
            for k:= 0 to 5 do
              if (Self.people[rndig].contacts[k] = -1) then
                frees:= frees + 1;
            if (frees > 0) then
              Self.people[i].contacts[j]:= rndig;
            k:=-1;
            repeat
              k:= k+1;
              //ShowMessage(IntToStr(k));
              if (Self.people[rndig].contacts[k] = -1) then
                Self.people[rndig].contacts[k]:= i;
            until (Self.people[rndig].contacts[k] = i) or (k >= 5);
          until (Self.people[i].contacts[j] <> i);
        end;
      end;
    end;
  end;


//деструктор НИП
  destructor THuman.destroy;
  begin
    inherited destroy;
  end;

//процедура генерации статистики
  procedure TPlanet.GetData;
  var
    i,j: integer;
  begin
  //формирование статистики - прочесывание базы населения со сканированием по фракциям и увеличение значения того поля массива численности, индекс которого находится в поле фракции текущего НИП
    for i:=0 to 1000 do
      for j:=0 to 9 do
        if (Self.people[i].factions[j]) then
          Self.factions[j]:= Self.factions[j] + 1;
  end;


end.
