//модуль классов проекта "Инквизитор"
//разработано Черкасовым К.В.

unit cat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, gtl;

type

//<-------------------------------------------------------------------------->\\
//<------------------------------- КЛАССЫ ----------------------------------->\\
//<-------------------------------------------------------------------------->\\

//родительский класс игровых объектов
  TGameObject = class
    id: Integer; //идентификатор объекта
  end;

//<-------------------------------------------------------------------------->\\

//класс хранилища данных
  TStorage = class (TGameObject)
     data: TStorageData;
     procedure initialize;
     function SaveContent: TStorageData;
     procedure LoadContent (cont: TStorageData);
  end;

//<-------------------------------------------------------------------------->\\

//класс жителей
  THuman = class(TGameObject)
    props: THumanData;
    constructor create (Stock: TStorage); overload;
    constructor create (data: THumanData); overload;
    destructor destroy; overload;
  end;

//<-------------------------------------------------------------------------->\\

//добавления от 27.07.2015 - класс дома (базовая версия), класс города
//класс дома
  THouse = class(TGameObject)
    people: array [0..9] of integer; //список жителей дома
    //to-do: создать структуру адреса (улица, дом)
    constructor create; overload;
    destructor destroy; overload;
    //to-do: функционал доступа к списку жителей
  end;

//<-------------------------------------------------------------------------->\\

//класс города
  TCity = class(TGameObject)
    houselist: array of THouse; //список домов - число зданий определяется численностью населения
    constructor create (populace: integer); overload;
    destructor destroy; overload;
    procedure settle (populace: integer); //процедура размещения жителей по домам
    function is_settled (numb: integer): integer; //поиск жителя в городе (возвращает -1 если НИП нигде не живет, в противном случае - номер дома)
    //to-do: процедура получения адреса жителя по номеру
  end;

//<-------------------------------------------------------------------------->\\  

//класс планеты (здесь должны быть список жителей, дома, рабочие места и т.д.
  TPlanet = class (TGameObject)
    kind: Byte; //идентификатор типа планеты (Добавлено 01.02.2015)
    housing: TCIty; //город (Добавлено 19.08.2015)
    people: array [0..DISTRICT_SIZE] of THuman; //список жителей
    factions: array [0..FACTIONS_COUNT] of Integer; //численность фракций н планете
    time: array [0..2] of Word; //массив времЕнных данных (год, месяц, день)
    store: TStorage; //дата-хранилище
    name: array [0..1] of TNameString; //название планеты
    constructor create; overload;
    procedure connect; //генерация сети контактов (добавлено 05.02.2015)
    procedure GetData; //сбор статистики по планете
  end;

//<-------------------------------------------------------------------------->\\

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
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<--------------------------- МЕТОДЫ КЛАССОВ ------------------------------->\\
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<---------------БАЗОВЫЙ КЛАСС ИГРОВЫХ ОБЪЕКТОВ (TGameObject)--------------->\\
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<-----------------------КЛАСС ДАТА-ХРАНИЛИЩА (TStorage)-------------------->\\
//<-------------------------------------------------------------------------->\\

//
  function TStorage.SaveContent: TStorageData;
  begin
    result:= Self.data;
  end;

//
  procedure TStorage.LoadContent(cont: TStorageData);
  begin
    Self.data:= cont;
  end;

//инициализация дата-хранилища
  procedure TStorage.initialize;
  var
    i: Byte;
    rn1: Integer;
  begin
    //инициализация названий полов
    Self.data.gender[0]:= 'мужской';
    Self.data.gender[1]:= 'женский';
    Self.data.gender[2]:= 'бесполый / не установлен';

    //инициализация типов родных миров
    Self.data.hwtype[0]:= 'Дикий мир';
    Self.data.hwtype[1]:= 'Мир-улей';
    Self.data.hwtype[2]:= 'Имперский мир';
    Self.data.hwtype[3]:= 'Рожденный в пустоте';

    //генерация описания внешнего вида

    //телосложение
    //Дикий мир
    Self.data.bodytype[0,0]:= 'Поджарый';
    Self.data.bodytype[0,1]:= 'Тощий';
    Self.data.bodytype[0,2]:= 'Мускулистый';
    Self.data.bodytype[0,3]:= 'Коренастый';
    Self.data.bodytype[0,4]:= 'Здоровенный';
    //Мир-улей
    Self.data.bodytype[1,0]:= 'Коротышка';
    Self.data.bodytype[1,1]:= 'Сухопарый';
    Self.data.bodytype[1,2]:= 'Жилистый';
    Self.data.bodytype[1,3]:= 'Длинный';
    Self.data.bodytype[1,4]:= 'Сильный';
    //Имперский мир
    Self.data.bodytype[2,0]:= 'Худощавый';
    Self.data.bodytype[2,1]:= 'Стройный';
    Self.data.bodytype[2,2]:= 'Подтянутый';
    Self.data.bodytype[2,3]:= 'Крепкий';
    Self.data.bodytype[2,4]:= 'Кряжистый';
    //Рожденный в пустоте
    Self.data.bodytype[3,0]:= 'Скелет';
    Self.data.bodytype[3,1]:= 'Чахлый';
    Self.data.bodytype[3,2]:= 'Костлявый';
    Self.data.bodytype[3,3]:= 'Сухопарый';
    Self.data.bodytype[3,4]:= 'Долговязый';

    //цвет кожи
    //Дикий мир
    Self.data.skins[0,0]:= 'Темная';
    Self.data.skins[0,1]:= 'Загорелая';
    Self.data.skins[0,2]:= 'Светлая';
    Self.data.skins[0,3]:= 'Красная';
    Self.data.skins[0,4]:= 'Бронзовая';
    //Мир-улей
    Self.data.skins[1,0]:= 'Темная';
    Self.data.skins[1,1]:= 'Загорелая';
    Self.data.skins[1,2]:= 'Светлая';
    Self.data.skins[1,3]:= 'Красная';
    Self.data.skins[1,4]:= 'Крашеная';
    //Имперский мир
    Self.data.skins[2,0]:= 'Темная';
    Self.data.skins[2,1]:= 'Загорелая';
    Self.data.skins[2,2]:= 'Светлая';
    Self.data.skins[2,3]:= 'Красная';
    Self.data.skins[2,4]:= 'Крашеная';
    //Рожденный в пустоте
    Self.data.skins[3,0]:= 'Фарфоровая';
    Self.data.skins[3,1]:= 'Светлая';
    Self.data.skins[3,2]:= 'Голубоватая';
    Self.data.skins[3,3]:= 'Сероватая';
    Self.data.skins[3,4]:= 'Молочная';

    //цвета волос
    //Дикий мир
    Self.data.hairs[0,0]:= 'Рыжие';
    Self.data.hairs[0,1]:= 'Светлые';
    Self.data.hairs[0,2]:= 'Русые';
    Self.data.hairs[0,3]:= 'Черные';
    Self.data.hairs[0,4]:= 'Седые';
    //Мир-улей
    Self.data.hairs[1,0]:= 'Русые';
    Self.data.hairs[1,1]:= 'Серые';
    Self.data.hairs[1,2]:= 'Крашеные';
    Self.data.hairs[1,3]:= 'Седые';
    Self.data.hairs[1,4]:= 'Черные';
    //Имперский мир
    Self.data.hairs[2,0]:= 'Крашеные';
    Self.data.hairs[2,1]:= 'Светлые';
    Self.data.hairs[2,2]:= 'Русые';
    Self.data.hairs[2,3]:= 'Черные';
    Self.data.hairs[2,4]:= 'Седые';
    //Рожденный в пустоте
    Self.data.hairs[3,0]:= 'Рыжеватые';
    Self.data.hairs[3,1]:= 'Светлые';
    Self.data.hairs[3,2]:= 'Медные';
    Self.data.hairs[3,3]:= 'Черные';
    Self.data.hairs[3,4]:= 'Золотистые';

    //цвета глаз
    // Дикий мир
    Self.data.eyes[0,0]:= 'Голубые';
    Self.data.eyes[0,1]:= 'Серые';
    Self.data.eyes[0,2]:= 'Карие';
    Self.data.eyes[0,3]:= 'Зеленые';
    Self.data.eyes[0,4]:= 'Желтые';
    //Мир-улей
    Self.data.eyes[1,0]:= 'Синие';
    Self.data.eyes[1,1]:= 'Серые';
    Self.data.eyes[1,2]:= 'Карие';
    Self.data.eyes[1,3]:= 'Зеленые';
    Self.data.eyes[1,4]:= 'Линзы';
    //Имперский мир
    Self.data.eyes[2,0]:= 'Голубые';
    Self.data.eyes[2,1]:= 'Серые';
    Self.data.eyes[2,2]:= 'Карие';
    Self.data.eyes[2,3]:= 'Зеленые';
    Self.data.eyes[2,4]:= 'Линзы';
    //Рожденный в пустоте
    Self.data.eyes[3,0]:= 'Светло-голубые';
    Self.data.eyes[3,1]:= 'Серые';
    Self.data.eyes[3,2]:= 'Черные';
    Self.data.eyes[3,3]:= 'Зеленые';
    Self.data.eyes[3,4]:= 'Фиолетовые';

    //генерация массива рост/вес
    //дикий мир
    Self.data.heitype[0,0,0][0]:= 190; Self.data.heitype[0,0,0][1]:= 65;
    Self.data.heitype[0,1,0][0]:= 180; Self.data.heitype[0,1,0][1]:= 60;

    Self.data.heitype[0,0,1][0]:= 175; Self.data.heitype[0,0,1][1]:= 60;
    Self.data.heitype[0,1,1][0]:= 165; Self.data.heitype[0,1,1][1]:= 55;

    Self.data.heitype[0,0,2][0]:= 185; Self.data.heitype[0,0,2][1]:= 85;
    Self.data.heitype[0,1,2][0]:= 170; Self.data.heitype[0,1,2][1]:= 70;

    Self.data.heitype[0,0,3][0]:= 165; Self.data.heitype[0,0,3][1]:= 80;
    Self.data.heitype[0,1,3][0]:= 155; Self.data.heitype[0,1,3][1]:= 70;

    Self.data.heitype[0,0,4][0]:= 210; Self.data.heitype[0,0,4][1]:= 200;
    Self.data.heitype[0,1,4][0]:= 120; Self.data.heitype[0,1,4][1]:= 100;
    //мир-улей
    Self.data.heitype[1,0,0][0]:= 165; Self.data.heitype[1,0,0][1]:= 45;
    Self.data.heitype[1,1,0][0]:= 155; Self.data.heitype[1,1,0][1]:= 40;

    Self.data.heitype[1,0,1][0]:= 170; Self.data.heitype[1,0,1][1]:= 55;
    Self.data.heitype[1,1,1][0]:= 160; Self.data.heitype[1,1,1][1]:= 50;

    Self.data.heitype[1,0,2][0]:= 175; Self.data.heitype[1,0,2][1]:= 65;
    Self.data.heitype[1,1,2][0]:= 165; Self.data.heitype[1,1,2][1]:= 55;

    Self.data.heitype[1,0,3][0]:= 180; Self.data.heitype[1,0,3][1]:= 65;
    Self.data.heitype[1,1,3][0]:= 170; Self.data.heitype[1,1,3][1]:= 60;

    Self.data.heitype[1,0,4][0]:= 175; Self.data.heitype[1,0,4][1]:= 80;
    Self.data.heitype[1,1,4][0]:= 165; Self.data.heitype[1,1,4][1]:= 75;
    //имперский мир
    Self.data.heitype[2,0,0][0]:= 175; Self.data.heitype[2,0,0][1]:= 65;
    Self.data.heitype[2,1,0][0]:= 165; Self.data.heitype[2,1,0][1]:= 60;

    Self.data.heitype[2,0,1][0]:= 185; Self.data.heitype[2,0,1][1]:= 70;
    Self.data.heitype[2,1,1][0]:= 175; Self.data.heitype[2,1,1][1]:= 65;

    Self.data.heitype[2,0,2][0]:= 175; Self.data.heitype[2,0,2][1]:= 70;
    Self.data.heitype[2,1,2][0]:= 165; Self.data.heitype[2,1,2][1]:= 60;

    Self.data.heitype[2,0,3][0]:= 190; Self.data.heitype[2,0,3][1]:= 90;
    Self.data.heitype[2,1,3][0]:= 180; Self.data.heitype[2,1,3][1]:= 80;

    Self.data.heitype[2,0,4][0]:= 180; Self.data.heitype[2,0,4][1]:= 100;
    Self.data.heitype[2,1,4][0]:= 170; Self.data.heitype[2,1,4][1]:= 90;
    //рожденный в пустоте
    Self.data.heitype[3,0,0][0]:= 175; Self.data.heitype[3,0,0][1]:= 55;
    Self.data.heitype[3,1,0][0]:= 170; Self.data.heitype[3,1,0][1]:= 50;

    Self.data.heitype[3,0,1][0]:= 165; Self.data.heitype[3,0,1][1]:= 55;
    Self.data.heitype[3,1,1][0]:= 155; Self.data.heitype[3,1,1][1]:= 45;

    Self.data.heitype[3,0,2][0]:= 185; Self.data.heitype[3,0,2][1]:= 60;
    Self.data.heitype[3,1,2][0]:= 175; Self.data.heitype[3,1,2][1]:= 60;

    Self.data.heitype[3,0,3][0]:= 200; Self.data.heitype[3,0,3][1]:= 80;
    Self.data.heitype[3,1,3][0]:= 185; Self.data.heitype[3,1,3][1]:= 70;

    Self.data.heitype[3,0,4][0]:= 210; Self.data.heitype[3,0,4][1]:= 75;
    Self.data.heitype[3,1,4][0]:= 195; Self.data.heitype[3,1,4][1]:= 70;

    //генерация массива особых примет
    Self.data.perks[0,0]:=  'Волосатые костяшки';   Self.data.perks[1,0]:=  'Бледный';              Self.data.perks[2,0]:=  'Отсутствует палец';    Self.data.perks[3,0]:=  'Бледный';
    Self.data.perks[0,1]:=  'Сросшиеся брови';      Self.data.perks[1,1]:=  'Чумазый';              Self.data.perks[2,1]:=  'Орлиный нос';          Self.data.perks[3,1]:=  'Лысый';
    Self.data.perks[0,2]:=  'Боевая раскраска';     Self.data.perks[1,2]:=  'Дикая прическа';       Self.data.perks[2,2]:=  'Бородавки';            Self.data.perks[3,2]:=  'Длинные пальцы';
    Self.data.perks[0,3]:=  'Ладони-лопаты';        Self.data.perks[1,3]:=  'Гнилые зубы';          Self.data.perks[2,3]:=  'Дуэльный шрам';        Self.data.perks[3,3]:=  'Крохотные уши';
    Self.data.perks[0,4]:=  'Редкие зубы';          Self.data.perks[1,4]:=  'Электротатуировка';    Self.data.perks[2,4]:=  'Пирсинг в носу';       Self.data.perks[3,4]:=  'Худые конечности';
    Self.data.perks[0,5]:=  'Кустистые брови';      Self.data.perks[1,5]:=  'Пирсинг';              Self.data.perks[2,5]:=  'Нервный тик';          Self.data.perks[3,5]:=  'Желтые ногти';
    Self.data.perks[0,6]:=  'Мускусный запах';      Self.data.perks[1,6]:=  'Повсеместный пирсинг'; Self.data.perks[2,6]:=  'Татуировка с аквилой'; Self.data.perks[3,6]:=  'Мелкие зубы';
    Self.data.perks[0,7]:=  'Волосатый';            Self.data.perks[1,7]:=  'Сухой кашель';         Self.data.perks[2,7]:=  'Тяжелый запах';        Self.data.perks[3,7]:=  'Широко расставленные глаза';
    Self.data.perks[0,8]:=  'Рваные уши';           Self.data.perks[1,8]:=  'Татуировки';           Self.data.perks[2,8]:=  'Оспины';               Self.data.perks[3,8]:=  'Большая голова';
    Self.data.perks[0,9]:=  'Длинные ногти';        Self.data.perks[1,9]:=  'Пулевой шрам';         Self.data.perks[2,9]:=  'Молитвенный шрам';     Self.data.perks[3,9]:=  'Искривленый позвоночник';
    Self.data.perks[0,10]:= 'Племенные татуировки'; Self.data.perks[1,10]:= 'Нервный тик';          Self.data.perks[2,10]:= 'Электротатуировка';    Self.data.perks[3,10]:= 'Безволосый';
    Self.data.perks[0,11]:= 'Шрамирование';         Self.data.perks[1,11]:= 'Родимое пятно';        Self.data.perks[2,11]:= 'Дрожь в пальцах';      Self.data.perks[3,11]:= 'Элегантные руки';
    Self.data.perks[0,12]:= 'Пирсинг';              Self.data.perks[1,12]:= 'Химические ожоги';     Self.data.perks[2,12]:= 'Проколотые уши';       Self.data.perks[3,12]:= 'Волнистые волосы';
    Self.data.perks[0,13]:= 'Кошачие глаза';        Self.data.perks[1,13]:= 'Горб';                 Self.data.perks[2,13]:= 'Жуткий чирей';         Self.data.perks[3,13]:= 'Альбинос';
    Self.data.perks[0,14]:= 'Маленькая голова';     Self.data.perks[1,14]:= 'Маленькие руки';       Self.data.perks[2,14]:= 'Макияж';               Self.data.perks[3,14]:= 'Хромая походка';
    Self.data.perks[0,15]:= 'Массивная челюсть';    Self.data.perks[1,15]:= 'Химический запах';     Self.data.perks[2,15]:= 'Шаркающая походка';    Self.data.perks[3,15]:= 'Сутулый';

    //инициализация списка мужских имен
    with Self.data.mnames do
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
    with Self.data.fnames do
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
    Self.data.cnames[0]:= 'Адепт';    Self.data.cnames[1]:= 'Арбитр';
    Self.data.cnames[2]:= 'Убийца';   Self.data.cnames[3]:= 'Клирик';
    Self.data.cnames[4]:= 'Гвардеец'; Self.data.cnames[5]:= 'Псайкер';
    Self.data.cnames[6]:= 'Подонок';  Self.data.cnames[7]:= 'Техножрец';

    //названия параметров
    Self.data.snames[0]:= 'Ближний бой';  Self.data.snames[1]:= 'Стрельба';
    Self.data.snames[2]:= 'Сила';         Self.data.snames[3]:= 'Выносливость';
    Self.data.snames[4]:= 'Ловкость';     Self.data.snames[5]:= 'Интеллект';
    Self.data.snames[6]:= 'Восприятие';   Self.data.snames[7]:= 'Сила воли';
    Self.data.snames[8]:= 'Товарищество';

    //бонусы к параметрам от происхождения НИП
    //дикий мир
    Self.data.sbonus[0,0]:= 20; Self.data.sbonus[0,1]:= 20;
    Self.data.sbonus[0,2]:= 25; Self.data.sbonus[0,3]:= 25;
    Self.data.sbonus[0,4]:= 20; Self.data.sbonus[0,5]:= 20;
    Self.data.sbonus[0,6]:= 20; Self.data.sbonus[0,7]:= 15;
    Self.data.sbonus[0,8]:= 15;
    //мир-улей
    Self.data.sbonus[1,0]:= 20; Self.data.sbonus[1,1]:= 20;
    Self.data.sbonus[1,2]:= 20; Self.data.sbonus[1,3]:= 15;
    Self.data.sbonus[1,4]:= 20; Self.data.sbonus[1,5]:= 20;
    Self.data.sbonus[1,6]:= 20; Self.data.sbonus[1,7]:= 20;
    Self.data.sbonus[1,8]:= 25;
    //имперский мир
    Self.data.sbonus[2,0]:= 20; Self.data.sbonus[2,1]:= 20;
    Self.data.sbonus[2,2]:= 20; Self.data.sbonus[2,3]:= 20;
    Self.data.sbonus[2,4]:= 20; Self.data.sbonus[2,5]:= 20;
    Self.data.sbonus[2,6]:= 20; Self.data.sbonus[2,7]:= 20;
    Self.data.sbonus[2,8]:= 20;
    //рождённый в Пустоте
    Self.data.sbonus[3,0]:= 20; Self.data.sbonus[3,1]:= 20;
    Self.data.sbonus[3,2]:= 15; Self.data.sbonus[3,3]:= 20;
    Self.data.sbonus[3,4]:= 20; Self.data.sbonus[3,5]:= 20;
    Self.data.sbonus[3,6]:= 20; Self.data.sbonus[3,7]:= 25;
    Self.data.sbonus[3,8]:= 20;

    //вероятности специальностей от происхождения
    //дикий мир
    Self.data.sprobs[0,0]:= 0;  Self.data.sprobs[0,1]:= 0;  Self.data.sprobs[0,2]:= 30; Self.data.sprobs[0,3]:= 0;
    Self.data.sprobs[0,4]:= 50; Self.data.sprobs[0,5]:= 10; Self.data.sprobs[0,6]:= 10; Self.data.sprobs[0,7]:= 0;
    //мир-улей
    Self.data.sprobs[1,0]:= 0;  Self.data.sprobs[1,1]:= 17; Self.data.sprobs[1,2]:= 3;  Self.data.sprobs[1,3]:= 5;
    Self.data.sprobs[1,4]:= 10; Self.data.sprobs[1,5]:= 4;  Self.data.sprobs[1,6]:= 50; Self.data.sprobs[1,7]:= 11;
    //имперский мир
    Self.data.sprobs[2,0]:= 12; Self.data.sprobs[2,1]:= 13; Self.data.sprobs[2,2]:= 13; Self.data.sprobs[2,3]:= 14;
    Self.data.sprobs[2,4]:= 13; Self.data.sprobs[2,5]:= 14; Self.data.sprobs[2,6]:= 11; Self.data.sprobs[2,7]:= 10;
    //рожденный в Пустоте
    Self.data.sprobs[3,0]:= 10; Self.data.sprobs[3,1]:= 10; Self.data.sprobs[3,2]:= 5;  Self.data.sprobs[3,3]:= 10;
    Self.data.sprobs[3,4]:= 0;  Self.data.sprobs[3,5]:= 40; Self.data.sprobs[3,6]:= 10; Self.data.sprobs[3,7]:= 15;

    //названия фракций
    Self.data.factions[0]:= 'Горожанин';     Self.data.factions[1]:= 'Бандит';
    Self.data.factions[2]:= 'Арбитрес';      Self.data.factions[3]:= 'Имперская Гвардия';
    Self.data.factions[4]:= 'Еретики';       Self.data.factions[5]:= 'Экклезиархия';
    Self.data.factions[6]:= 'Механикум';     Self.data.factions[7]:= 'Ордо Ксенос';
    Self.data.factions[8]:= 'Ордо Еретикус'; Self.data.factions[9]:= 'Ордо Маллеус';

    //названия психотипов
    Self.data.pnames[0]:= 'Желчный';   Self.data.pnames[1]:= 'Кардинал';   Self.data.pnames[2]:= 'Холерик';
    Self.data.pnames[3]:= 'Стоик';     Self.data.pnames[4]:= 'Меланхолик'; Self.data.pnames[5]:= 'Переменчивый';
    Self.data.pnames[6]:= 'Флегматик'; Self.data.pnames[7]:= 'Сангвиник';  Self.data.pnames[8]:= 'Пассивный';

    //вероятности получения социальных статусов
    Self.data.fprobs[0]:= 80; Self.data.fprobs[1]:= 25;
    Self.data.fprobs[2]:= 18; Self.data.fprobs[3]:= 30;
    Self.data.fprobs[4]:= 5;  Self.data.fprobs[5]:= 15;
    Self.data.fprobs[6]:= 10; Self.data.fprobs[7]:= 2;
    Self.data.fprobs[8]:= 2;  Self.data.fprobs[9]:= 2;

    //вероятности получения субстатусов (званий)
    Self.data.lprobs[0]:= 67; Self.data.lprobs[1]:= 7;
    Self.data.lprobs[2]:= 23; Self.data.lprobs[3]:= 3;

    //Добавления от 04.02.2015-05.02.2015
    //строка расширения графических файлов (const, использовать при генерации ссылки на картинку)
    Self.data.grexe:= '.png';

    //Добавления от 29.05.2015
    //массив названий порядковых номеров планет
    Self.data.plnames[0]:= 'Примус';   Self.data.plnames[1]:= 'Секундус';
    Self.data.plnames[2]:= 'Терциус';  Self.data.plnames[3]:= 'Кварта';
    Self.data.plnames[4]:= 'Пинтус';   Self.data.plnames[5]:= 'Секстус';
    Self.data.plnames[6]:= 'Септимус'; Self.data.plnames[7]:= 'Октус';
    Self.data.plnames[8]:= 'Нонус';    Self.data.plnames[9]:= 'Децимус';

    //Добавления от 01.07.2015
    //массив модификаторов склонностей

    //модификаторы класса
    //класс Адепт
    Self.data.addmods.clasmods[0][ag_force]:= -20;   Self.data.addmods.clasmods[0][ag_court]:= 15;
    Self.data.addmods.clasmods[0][ag_stealth]:= -15; Self.data.addmods.clasmods[0][ag_investigation]:= 20;
    Self.data.addmods.clasmods[0][ag_others]:= 0;

    //класс Арбитр
    Self.data.addmods.clasmods[1][ag_force]:= 15;    Self.data.addmods.clasmods[1][ag_court]:= -15;
    Self.data.addmods.clasmods[1][ag_stealth]:= -20; Self.data.addmods.clasmods[1][ag_investigation]:= 20;
    Self.data.addmods.clasmods[1][ag_others]:= 0;

    //класс Убийца
    Self.data.addmods.clasmods[2][ag_force]:= -15;   Self.data.addmods.clasmods[2][ag_court]:= -20;
    Self.data.addmods.clasmods[2][ag_stealth]:= 20;  Self.data.addmods.clasmods[2][ag_investigation]:= 15;
    Self.data.addmods.clasmods[2][ag_others]:= 0;

    //класс Клирик
    Self.data.addmods.clasmods[3][ag_force]:= -10;   Self.data.addmods.clasmods[3][ag_court]:= 15;
    Self.data.addmods.clasmods[3][ag_stealth]:= -15; Self.data.addmods.clasmods[3][ag_investigation]:= 10;
    Self.data.addmods.clasmods[3][ag_others]:= 0;

    //класс Гвардеец
    Self.data.addmods.clasmods[4][ag_force]:= 20;    Self.data.addmods.clasmods[4][ag_court]:= -20;
    Self.data.addmods.clasmods[4][ag_stealth]:= 15;  Self.data.addmods.clasmods[4][ag_investigation]:= -15;
    Self.data.addmods.clasmods[4][ag_others]:= 0;

    //класс Псайкер
    Self.data.addmods.clasmods[5][ag_force]:= -20;   Self.data.addmods.clasmods[5][ag_court]:= -15;
    Self.data.addmods.clasmods[5][ag_stealth]:= 15;  Self.data.addmods.clasmods[5][ag_investigation]:= 20;
    Self.data.addmods.clasmods[5][ag_others]:= 0;

    //класс Подонок
    Self.data.addmods.clasmods[6][ag_force]:= 15;    Self.data.addmods.clasmods[6][ag_court]:= -15;
    Self.data.addmods.clasmods[6][ag_stealth]:= 20;  Self.data.addmods.clasmods[6][ag_investigation]:= -20;
    Self.data.addmods.clasmods[6][ag_others]:= 0;

    //класс Техножрец
    Self.data.addmods.clasmods[7][ag_force]:= 15;    Self.data.addmods.clasmods[7][ag_court]:= -15;
    Self.data.addmods.clasmods[7][ag_stealth]:= -20; Self.data.addmods.clasmods[7][ag_investigation]:= 20;
    Self.data.addmods.clasmods[7][ag_others]:= 0;

    //модификаторы происхождения
    //происхождение Дикий мир
    Self.data.addmods.origmods[0][ag_force]:= 20;    Self.data.addmods.origmods[0][ag_court]:= -20;
    Self.data.addmods.origmods[0][ag_stealth]:= 10;  Self.data.addmods.origmods[0][ag_investigation]:= -10;
    Self.data.addmods.origmods[0][ag_others]:= 0;

    //происхождение Мир-улей
    Self.data.addmods.origmods[1][ag_force]:= -10;   Self.data.addmods.origmods[1][ag_court]:= 15;
    Self.data.addmods.origmods[1][ag_stealth]:= 15;  Self.data.addmods.origmods[1][ag_investigation]:= 10;
    Self.data.addmods.origmods[1][ag_others]:= 0;

    //происхождение Имперский мир
    Self.data.addmods.origmods[2][ag_force]:= 10;    Self.data.addmods.origmods[2][ag_court]:= 20;
    Self.data.addmods.origmods[2][ag_stealth]:= -20; Self.data.addmods.origmods[2][ag_investigation]:= -10;
    Self.data.addmods.origmods[2][ag_others]:= 0;

    //происхождение Пустота
    Self.data.addmods.origmods[3][ag_force]:= -20;   Self.data.addmods.origmods[3][ag_court]:= -10;
    Self.data.addmods.origmods[3][ag_stealth]:= 10;  Self.data.addmods.origmods[3][ag_investigation]:= 20;
    Self.data.addmods.origmods[3][ag_others]:= 0;

    //модификаторы фракции
    //фракция Горожане
    Self.data.addmods.factmods[0][ag_force]:= -10;   Self.data.addmods.factmods[0][ag_court]:= 10;
    Self.data.addmods.factmods[0][ag_stealth]:= 10;  Self.data.addmods.factmods[0][ag_investigation]:= -10;
    Self.data.addmods.factmods[0][ag_others]:= 0;

    //фракция Бандиты
    Self.data.addmods.factmods[1][ag_force]:= 15;    Self.data.addmods.factmods[1][ag_court]:= -15;
    Self.data.addmods.factmods[1][ag_stealth]:= 15;  Self.data.addmods.factmods[1][ag_investigation]:= -15;
    Self.data.addmods.factmods[1][ag_others]:= 0;

    //фракция Арбитрес
    Self.data.addmods.factmods[2][ag_force]:= 15;    Self.data.addmods.factmods[2][ag_court]:= -15;
    Self.data.addmods.factmods[2][ag_stealth]:= -20; Self.data.addmods.factmods[2][ag_investigation]:= 20;
    Self.data.addmods.factmods[2][ag_others]:= 0;

    //фракция Имперская Гвардия
    Self.data.addmods.factmods[3][ag_force]:= 20;    Self.data.addmods.factmods[3][ag_court]:= -20;
    Self.data.addmods.factmods[3][ag_stealth]:= 10;  Self.data.addmods.factmods[3][ag_investigation]:= -10;
    Self.data.addmods.factmods[3][ag_others]:= 0;

    //фракция Еретики
    Self.data.addmods.factmods[4][ag_force]:= 0;     Self.data.addmods.factmods[4][ag_court]:= 0;
    Self.data.addmods.factmods[4][ag_stealth]:= 0;   Self.data.addmods.factmods[4][ag_investigation]:= 0;
    Self.data.addmods.factmods[4][ag_others]:= 0;

    //фракция Экклезиархия
    Self.data.addmods.factmods[5][ag_force]:= -10;   Self.data.addmods.factmods[5][ag_court]:= 20;
    Self.data.addmods.factmods[5][ag_stealth]:= -20; Self.data.addmods.factmods[5][ag_investigation]:= 10;
    Self.data.addmods.factmods[5][ag_others]:= 0;

    //фракция Механикум
    Self.data.addmods.factmods[6][ag_force]:= 15;    Self.data.addmods.factmods[6][ag_court]:= -15;
    Self.data.addmods.factmods[6][ag_stealth]:= -20; Self.data.addmods.factmods[6][ag_investigation]:= 20;
    Self.data.addmods.factmods[6][ag_others]:= 0;

    //фракция Ордо Ксенос
    Self.data.addmods.factmods[7][ag_force]:= 0;     Self.data.addmods.factmods[7][ag_court]:= 0;
    Self.data.addmods.factmods[7][ag_stealth]:= 0;   Self.data.addmods.factmods[7][ag_investigation]:= 0;
    Self.data.addmods.factmods[7][ag_others]:= 0;

    //фракция Ордо Еретикус
    Self.data.addmods.factmods[8][ag_force]:= 0;     Self.data.addmods.factmods[8][ag_court]:= 0;
    Self.data.addmods.factmods[8][ag_stealth]:= 0;   Self.data.addmods.factmods[8][ag_investigation]:= 0;
    Self.data.addmods.factmods[8][ag_others]:= 0;

    //фракция Ордо Маллеус
    Self.data.addmods.factmods[9][ag_force]:= 0;     Self.data.addmods.factmods[9][ag_court]:= 0;
    Self.data.addmods.factmods[9][ag_stealth]:= 0;   Self.data.addmods.factmods[9][ag_investigation]:= 0;
    Self.data.addmods.factmods[9][ag_others]:= 0;

    //добавления от 03.07.2015
    //модификаторы параметров DMS

    //модификаторы класса
    //класс Адепт
    Self.data.dmsmods.clasmods[0][dp_diligence]:= 20; Self.data.dmsmods.clasmods[0][dp_identity]:= 20;
    Self.data.dmsmods.clasmods[0][dp_calmness]:= 0;  Self.data.dmsmods.clasmods[0][dp_educability]:= 20;
    Self.data.dmsmods.clasmods[0][dp_authority]:= 10;

    //класс Арбитр
    Self.data.dmsmods.clasmods[1][dp_diligence]:= 20; Self.data.dmsmods.clasmods[1][dp_identity]:= 10;
    Self.data.dmsmods.clasmods[1][dp_calmness]:= 20;  Self.data.dmsmods.clasmods[1][dp_educability]:= 0;
    Self.data.dmsmods.clasmods[1][dp_authority]:= 15;

    //класс Убийца
    Self.data.dmsmods.clasmods[2][dp_diligence]:= 5; Self.data.dmsmods.clasmods[2][dp_identity]:= 20;
    Self.data.dmsmods.clasmods[2][dp_calmness]:= 20;  Self.data.dmsmods.clasmods[2][dp_educability]:= 0;
    Self.data.dmsmods.clasmods[2][dp_authority]:= -10;

    //класс Клирик
    Self.data.dmsmods.clasmods[3][dp_diligence]:= 20; Self.data.dmsmods.clasmods[3][dp_identity]:= -10;
    Self.data.dmsmods.clasmods[3][dp_calmness]:= 10;  Self.data.dmsmods.clasmods[3][dp_educability]:= -10;
    Self.data.dmsmods.clasmods[3][dp_authority]:= 20;

    //класс Гвардеец
    Self.data.dmsmods.clasmods[4][dp_diligence]:= 20; Self.data.dmsmods.clasmods[4][dp_identity]:= 10;
    Self.data.dmsmods.clasmods[4][dp_calmness]:= 20;  Self.data.dmsmods.clasmods[4][dp_educability]:= 0;
    Self.data.dmsmods.clasmods[4][dp_authority]:= 0;

    //класс Псайкер
    Self.data.dmsmods.clasmods[5][dp_diligence]:= 10; Self.data.dmsmods.clasmods[5][dp_identity]:= 15;
    Self.data.dmsmods.clasmods[5][dp_calmness]:= 10;  Self.data.dmsmods.clasmods[5][dp_educability]:= 15;
    Self.data.dmsmods.clasmods[5][dp_authority]:= -20;

    //класс Подонок
    Self.data.dmsmods.clasmods[6][dp_diligence]:= -20; Self.data.dmsmods.clasmods[6][dp_identity]:= -15;
    Self.data.dmsmods.clasmods[6][dp_calmness]:= 10;  Self.data.dmsmods.clasmods[6][dp_educability]:= -10;
    Self.data.dmsmods.clasmods[6][dp_authority]:= 0;

    //класс Техножрец
    Self.data.dmsmods.clasmods[7][dp_diligence]:= 10; Self.data.dmsmods.clasmods[7][dp_identity]:= 20;
    Self.data.dmsmods.clasmods[7][dp_calmness]:= 20;  Self.data.dmsmods.clasmods[7][dp_educability]:= 20;
    Self.data.dmsmods.clasmods[7][dp_authority]:= 10;

    //модификаторы происхождения
    //происхождение Дикий мир
    Self.data.dmsmods.origmods[0][dp_diligence]:= 20; Self.data.dmsmods.origmods[0][dp_identity]:= 10;
    Self.data.dmsmods.origmods[0][dp_calmness]:= 10;  Self.data.dmsmods.origmods[0][dp_educability]:= -10;
    Self.data.dmsmods.origmods[0][dp_authority]:= -10;

    //происхождение Мир-улей
    Self.data.dmsmods.origmods[1][dp_diligence]:= -15; Self.data.dmsmods.origmods[1][dp_identity]:= -10;
    Self.data.dmsmods.origmods[1][dp_calmness]:= 10;  Self.data.dmsmods.origmods[1][dp_educability]:= 15;
    Self.data.dmsmods.origmods[1][dp_authority]:= 10;

    //происхождение Имперский мир
    Self.data.dmsmods.origmods[2][dp_diligence]:= 10; Self.data.dmsmods.origmods[2][dp_identity]:= -5;
    Self.data.dmsmods.origmods[2][dp_calmness]:= 5;  Self.data.dmsmods.origmods[2][dp_educability]:= 5;
    Self.data.dmsmods.origmods[2][dp_authority]:= 15;

    //происхождение Пустота
    Self.data.dmsmods.origmods[3][dp_diligence]:= -5; Self.data.dmsmods.origmods[3][dp_identity]:= 20;
    Self.data.dmsmods.origmods[3][dp_calmness]:= 15;  Self.data.dmsmods.origmods[3][dp_educability]:= 20;
    Self.data.dmsmods.origmods[3][dp_authority]:= -15;

    //модификаторы фракции
    //фракция Горожане
    Self.data.dmsmods.factmods[0][dp_diligence]:= 10; Self.data.dmsmods.factmods[0][dp_identity]:= -20;
    Self.data.dmsmods.factmods[0][dp_calmness]:= -20;  Self.data.dmsmods.factmods[0][dp_educability]:= 0;
    Self.data.dmsmods.factmods[0][dp_authority]:= 0;

    //фракция Бандиты
    Self.data.dmsmods.factmods[1][dp_diligence]:= -20; Self.data.dmsmods.factmods[1][dp_identity]:= -15;
    Self.data.dmsmods.factmods[1][dp_calmness]:= 5;  Self.data.dmsmods.factmods[1][dp_educability]:= -5;
    Self.data.dmsmods.factmods[1][dp_authority]:= -5;

    //фракция Арбитрес
    Self.data.dmsmods.factmods[2][dp_diligence]:= 20; Self.data.dmsmods.factmods[2][dp_identity]:= 10;
    Self.data.dmsmods.factmods[2][dp_calmness]:= 10;  Self.data.dmsmods.factmods[2][dp_educability]:= 5;
    Self.data.dmsmods.factmods[2][dp_authority]:= 15;

    //фракция Имперская Гвардия
    Self.data.dmsmods.factmods[3][dp_diligence]:= 20; Self.data.dmsmods.factmods[3][dp_identity]:= 10;
    Self.data.dmsmods.factmods[3][dp_calmness]:= 15;  Self.data.dmsmods.factmods[3][dp_educability]:= 5;
    Self.data.dmsmods.factmods[3][dp_authority]:= 10;

    //фракция Еретики
    Self.data.dmsmods.factmods[4][dp_diligence]:= 0; Self.data.dmsmods.factmods[4][dp_identity]:= 0;
    Self.data.dmsmods.factmods[4][dp_calmness]:= 0;  Self.data.dmsmods.factmods[4][dp_educability]:= 0;
    Self.data.dmsmods.factmods[4][dp_authority]:= 0;

    //фракция Экклезиархия
    Self.data.dmsmods.factmods[5][dp_diligence]:= 20; Self.data.dmsmods.factmods[5][dp_identity]:= -10;
    Self.data.dmsmods.factmods[5][dp_calmness]:= -5;  Self.data.dmsmods.factmods[5][dp_educability]:= -10;
    Self.data.dmsmods.factmods[5][dp_authority]:= 20;

    //фракция Механикум
    Self.data.dmsmods.factmods[6][dp_diligence]:= 5; Self.data.dmsmods.factmods[6][dp_identity]:= 20;
    Self.data.dmsmods.factmods[6][dp_calmness]:= 20;  Self.data.dmsmods.factmods[6][dp_educability]:= 20;
    Self.data.dmsmods.factmods[6][dp_authority]:= 15;

    //фракция Ордо Ксенос
    Self.data.dmsmods.factmods[7][dp_diligence]:= 20; Self.data.dmsmods.factmods[7][dp_identity]:= 15;
    Self.data.dmsmods.factmods[7][dp_calmness]:= 20;  Self.data.dmsmods.factmods[7][dp_educability]:= 15;
    Self.data.dmsmods.factmods[7][dp_authority]:= 20;

    //фракция Ордо Еретикус
    Self.data.dmsmods.factmods[8][dp_diligence]:= 20; Self.data.dmsmods.factmods[8][dp_identity]:= 15;
    Self.data.dmsmods.factmods[8][dp_calmness]:= 20;  Self.data.dmsmods.factmods[8][dp_educability]:= 15;
    Self.data.dmsmods.factmods[8][dp_authority]:= 20;

    //фракция Ордо Маллеус
    Self.data.dmsmods.factmods[9][dp_diligence]:= 20; Self.data.dmsmods.factmods[9][dp_identity]:= 15;
    Self.data.dmsmods.factmods[9][dp_calmness]:= 20;  Self.data.dmsmods.factmods[9][dp_educability]:= 15;
    Self.data.dmsmods.factmods[9][dp_authority]:= 20;

    //массив названий групп действий
    Self.data.actnames[ag_force]:='Силовые';    Self.data.actnames[ag_court]:='Светские';
    Self.data.actnames[ag_stealth]:='Скрытные'; Self.data.actnames[ag_investigation]:='Следственные';
    Self.data.actnames[ag_others]:='Прочие';

    //добавления от 12.09.2015
    //названия приказов
    Self.data.ordnames[og_kill]:= 'Уничтожить';       Self.data.ordnames[og_capture]:= 'Доставить';
    Self.data.ordnames[og_interrogate]:= 'Изучить';   Self.data.ordnames[og_search]:= 'Допросить';
    Self.data.ordnames[og_freetime]:= 'Личное время'; Self.data.ordnames[og_heresy]:= 'Ересь';

    //добавления от 16.07.2015
    //массив названий параметров DMS
    Self.data.dmsnames[dp_diligence]:= 'Исполнительность'; Self.data.dmsnames[dp_identity]:= 'Самосознание';
    Self.data.dmsnames[dp_calmness]:= 'Хладнокровие';      Self.data.dmsnames[dp_educability]:= 'Обучаемость';
    Self.data.dmsnames[dp_authority]:= 'Авторитетность';

    //добавления от 08.09.2015
    //массив информации о действиях

    //названия действий

    //силовые
    Self.data.actions[ag_force][0].name:= 'Уничтожение'; Self.data.actions[ag_force][1].name:= 'Штурм';
    Self.data.actions[ag_force][2].name:= 'Захват'; Self.data.actions[ag_force][3].name:= 'Конфискация';
    Self.data.actions[ag_force][4].name:= 'Казнь';

    //светские
    Self.data.actions[ag_court][0].name:= 'Встреча'; Self.data.actions[ag_court][1].name:= 'Торговля';
    Self.data.actions[ag_court][2].name:= 'Посещение церкви'; Self.data.actions[ag_court][3].name:= 'Архив';
    Self.data.actions[ag_court][4].name:= 'Контакт с полицией';

    //скрытные
    Self.data.actions[ag_stealth][0].name:= 'Проникновение'; Self.data.actions[ag_stealth][1].name:= 'Убийство';
    Self.data.actions[ag_stealth][2].name:= 'Изъятие'; Self.data.actions[ag_stealth][3].name:= 'Установк прослушки';
    Self.data.actions[ag_stealth][4].name:= 'Слежка';

    //следственные
    Self.data.actions[ag_investigation][0].name:= 'Осмотр места'; Self.data.actions[ag_investigation][1].name:= 'Анализ улик';
    Self.data.actions[ag_investigation][2].name:= 'Расшифровка'; Self.data.actions[ag_investigation][3].name:= 'Допрос';
    Self.data.actions[ag_investigation][4].name:= 'Поиск сведений';

    //прочие
    Self.data.actions[ag_others][0].name:= 'Вербовка'; Self.data.actions[ag_others][1].name:= 'Взлом сети';
    Self.data.actions[ag_others][2].name:= 'Тренировка'; Self.data.actions[ag_others][3].name:= 'Лечение';
    Self.data.actions[ag_others][4].name:= 'Отдых';

    //Описания действий (временно оставлены пустыми)

    //силовые
    Self.data.actions[ag_force][0].description:= ''; Self.data.actions[ag_force][1].description:= '';
    Self.data.actions[ag_force][2].description:= ''; Self.data.actions[ag_force][3].description:= '';
    Self.data.actions[ag_force][4].description:= '';

    //светские
    Self.data.actions[ag_court][0].description:= ''; Self.data.actions[ag_court][1].description:= '';
    Self.data.actions[ag_court][2].description:= ''; Self.data.actions[ag_court][3].description:= '';
    Self.data.actions[ag_court][4].description:= '';

    //скрытные
    Self.data.actions[ag_stealth][0].description:= ''; Self.data.actions[ag_stealth][1].description:= '';
    Self.data.actions[ag_stealth][2].description:= ''; Self.data.actions[ag_stealth][3].description:= '';
    Self.data.actions[ag_stealth][4].description:= '';

    //следственные
    Self.data.actions[ag_investigation][0].description:= ''; Self.data.actions[ag_investigation][1].description:= '';
    Self.data.actions[ag_investigation][2].description:= ''; Self.data.actions[ag_investigation][3].description:= '';
    Self.data.actions[ag_investigation][4].description:= '';

    //прочие
    Self.data.actions[ag_others][0].description:= ''; Self.data.actions[ag_others][1].description:= '';
    Self.data.actions[ag_others][2].description:= ''; Self.data.actions[ag_others][3].description:= '';
    Self.data.actions[ag_others][4].description:= '';

    //Доступность разных видов целей для различных действий

    //Силовые
    //Уничтожение
    Self.data.actions[ag_force][0].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_force][0].targets[tk_place].Availible:= True;
    Self.data.actions[ag_force][0].targets[tk_person].Availible:= True;
    Self.data.actions[ag_force][0].targets[tk_item].Availible:= True;
    Self.data.actions[ag_force][0].targets[tk_self].Availible:= True;

    //Штурм
    Self.data.actions[ag_force][1].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_force][1].targets[tk_place].Availible:= True;
    Self.data.actions[ag_force][1].targets[tk_person].Availible:= False;
    Self.data.actions[ag_force][1].targets[tk_item].Availible:= False;
    Self.data.actions[ag_force][1].targets[tk_self].Availible:= False;

    //Захват
    Self.data.actions[ag_force][2].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_force][2].targets[tk_place].Availible:= True;
    Self.data.actions[ag_force][2].targets[tk_person].Availible:= True;
    Self.data.actions[ag_force][2].targets[tk_item].Availible:= True;
    Self.data.actions[ag_force][2].targets[tk_self].Availible:= False;

    //Конфискация
    Self.data.actions[ag_force][3].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_force][3].targets[tk_place].Availible:= False;
    Self.data.actions[ag_force][3].targets[tk_person].Availible:= False;
    Self.data.actions[ag_force][3].targets[tk_item].Availible:= True;
    Self.data.actions[ag_force][3].targets[tk_self].Availible:= False;

    //Казнь
    Self.data.actions[ag_force][4].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_force][4].targets[tk_place].Availible:= False;
    Self.data.actions[ag_force][4].targets[tk_person].Availible:= True;
    Self.data.actions[ag_force][4].targets[tk_item].Availible:= False;
    Self.data.actions[ag_force][4].targets[tk_self].Availible:= False;

    //Светские
    //Встреча
    Self.data.actions[ag_court][0].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_court][0].targets[tk_place].Availible:= True;
    Self.data.actions[ag_court][0].targets[tk_person].Availible:= True;
    Self.data.actions[ag_court][0].targets[tk_item].Availible:= False;
    Self.data.actions[ag_court][0].targets[tk_self].Availible:= False;

    //Торговля
    Self.data.actions[ag_court][1].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_court][1].targets[tk_place].Availible:= True;
    Self.data.actions[ag_court][1].targets[tk_person].Availible:= True;
    Self.data.actions[ag_court][1].targets[tk_item].Availible:= True;
    Self.data.actions[ag_court][1].targets[tk_self].Availible:= False;

    //Посещение церкви
    Self.data.actions[ag_court][2].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_court][2].targets[tk_place].Availible:= True;
    Self.data.actions[ag_court][2].targets[tk_person].Availible:= False;
    Self.data.actions[ag_court][2].targets[tk_item].Availible:= False;
    Self.data.actions[ag_court][2].targets[tk_self].Availible:= False;

    //Архив
    Self.data.actions[ag_court][3].targets[tk_nondef].Availible:= True;
    Self.data.actions[ag_court][3].targets[tk_place].Availible:= True;
    Self.data.actions[ag_court][3].targets[tk_person].Availible:= True;
    Self.data.actions[ag_court][3].targets[tk_item].Availible:= True;
    Self.data.actions[ag_court][3].targets[tk_self].Availible:= False;

    //Контакт с полицией
    Self.data.actions[ag_court][4].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_court][4].targets[tk_place].Availible:= True;
    Self.data.actions[ag_court][4].targets[tk_person].Availible:= True;
    Self.data.actions[ag_court][4].targets[tk_item].Availible:= False;
    Self.data.actions[ag_court][4].targets[tk_self].Availible:= False;

    //Скрытные
    //Проникновение
    Self.data.actions[ag_stealth][0].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_stealth][0].targets[tk_place].Availible:= True;
    Self.data.actions[ag_stealth][0].targets[tk_person].Availible:= False;
    Self.data.actions[ag_stealth][0].targets[tk_item].Availible:= False;
    Self.data.actions[ag_stealth][0].targets[tk_self].Availible:= False;

    //Убийство
    Self.data.actions[ag_stealth][1].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_stealth][1].targets[tk_place].Availible:= False;
    Self.data.actions[ag_stealth][1].targets[tk_person].Availible:= True;
    Self.data.actions[ag_stealth][1].targets[tk_item].Availible:= False;
    Self.data.actions[ag_stealth][1].targets[tk_self].Availible:= False;

    //Изъятие
    Self.data.actions[ag_stealth][2].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_stealth][2].targets[tk_place].Availible:= False;
    Self.data.actions[ag_stealth][2].targets[tk_person].Availible:= True;
    Self.data.actions[ag_stealth][2].targets[tk_item].Availible:= True;
    Self.data.actions[ag_stealth][2].targets[tk_self].Availible:= False;

    //Установка прослушки
    Self.data.actions[ag_stealth][3].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_stealth][3].targets[tk_place].Availible:= True;
    Self.data.actions[ag_stealth][3].targets[tk_person].Availible:= False;
    Self.data.actions[ag_stealth][3].targets[tk_item].Availible:= True;
    Self.data.actions[ag_stealth][3].targets[tk_self].Availible:= True;

    //Слежка
    Self.data.actions[ag_stealth][4].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_stealth][4].targets[tk_place].Availible:= True;
    Self.data.actions[ag_stealth][4].targets[tk_person].Availible:= True;
    Self.data.actions[ag_stealth][4].targets[tk_item].Availible:= False;
    Self.data.actions[ag_stealth][4].targets[tk_self].Availible:= False;

    //Следственные
    //Осмотр места
    Self.data.actions[ag_investigation][0].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_investigation][0].targets[tk_place].Availible:= True;
    Self.data.actions[ag_investigation][0].targets[tk_person].Availible:= False;
    Self.data.actions[ag_investigation][0].targets[tk_item].Availible:= False;
    Self.data.actions[ag_investigation][0].targets[tk_self].Availible:= False;

    //Анализ улик
    Self.data.actions[ag_investigation][1].targets[tk_nondef].Availible:= True;
    Self.data.actions[ag_investigation][1].targets[tk_place].Availible:= False;
    Self.data.actions[ag_investigation][1].targets[tk_person].Availible:= False;
    Self.data.actions[ag_investigation][1].targets[tk_item].Availible:= False;
    Self.data.actions[ag_investigation][1].targets[tk_self].Availible:= False;

    //Расшифровка
    Self.data.actions[ag_investigation][2].targets[tk_nondef].Availible:= True;
    Self.data.actions[ag_investigation][2].targets[tk_place].Availible:= False;
    Self.data.actions[ag_investigation][2].targets[tk_person].Availible:= False;
    Self.data.actions[ag_investigation][2].targets[tk_item].Availible:= True;
    Self.data.actions[ag_investigation][2].targets[tk_self].Availible:= False;

    //Допрос
    Self.data.actions[ag_investigation][3].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_investigation][3].targets[tk_place].Availible:= False;
    Self.data.actions[ag_investigation][3].targets[tk_person].Availible:= True;
    Self.data.actions[ag_investigation][3].targets[tk_item].Availible:= False;
    Self.data.actions[ag_investigation][3].targets[tk_self].Availible:= False;

    //Поиск свидетелей
    Self.data.actions[ag_investigation][4].targets[tk_nondef].Availible:= True;
    Self.data.actions[ag_investigation][4].targets[tk_place].Availible:= True;
    Self.data.actions[ag_investigation][4].targets[tk_person].Availible:= False;
    Self.data.actions[ag_investigation][4].targets[tk_item].Availible:= False;
    Self.data.actions[ag_investigation][4].targets[tk_self].Availible:= False;

    //Прочие
    //Вербовка
    Self.data.actions[ag_others][0].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_others][0].targets[tk_place].Availible:= True;
    Self.data.actions[ag_others][0].targets[tk_person].Availible:= True;
    Self.data.actions[ag_others][0].targets[tk_item].Availible:= False;
    Self.data.actions[ag_others][0].targets[tk_self].Availible:= False;

    //Взлом сети
    Self.data.actions[ag_others][1].targets[tk_nondef].Availible:= True;
    Self.data.actions[ag_others][1].targets[tk_place].Availible:= True;
    Self.data.actions[ag_others][1].targets[tk_person].Availible:= True;
    Self.data.actions[ag_others][1].targets[tk_item].Availible:= False;
    Self.data.actions[ag_others][1].targets[tk_self].Availible:= False;

    //Тренировка
    Self.data.actions[ag_others][2].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_others][2].targets[tk_place].Availible:= False;
    Self.data.actions[ag_others][2].targets[tk_person].Availible:= True;
    Self.data.actions[ag_others][2].targets[tk_item].Availible:= False;
    Self.data.actions[ag_others][2].targets[tk_self].Availible:= True;

    //Лечение
    Self.data.actions[ag_others][3].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_others][3].targets[tk_place].Availible:= False;
    Self.data.actions[ag_others][3].targets[tk_person].Availible:= True;
    Self.data.actions[ag_others][3].targets[tk_item].Availible:= False;
    Self.data.actions[ag_others][3].targets[tk_self].Availible:= True;

    //Отдых
    Self.data.actions[ag_others][4].targets[tk_nondef].Availible:= False;
    Self.data.actions[ag_others][4].targets[tk_place].Availible:= False;
    Self.data.actions[ag_others][4].targets[tk_person].Availible:= False;
    Self.data.actions[ag_others][4].targets[tk_item].Availible:= False;
    Self.data.actions[ag_others][4].targets[tk_self].Availible:= True;

    //Число целей (максимальное)

    //Силовые
    //Уничтожение
    Self.data.actions[ag_force][0].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_force][0].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_force][0].targets[tk_person].MaxAmount:= MAX_PARTY_SIZE + 1;
    Self.data.actions[ag_force][0].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_force][0].targets[tk_self].MaxAmount:= 1;

    //Штурм
    Self.data.actions[ag_force][1].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_force][1].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_force][1].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_force][1].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_force][1].targets[tk_self].MaxAmount:= -1;

    //Захват
    Self.data.actions[ag_force][2].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_force][2].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_force][2].targets[tk_person].MaxAmount:= MAX_PARTY_SIZE + 1;
    Self.data.actions[ag_force][2].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_force][2].targets[tk_self].MaxAmount:= -1;

    //Конфискация
    Self.data.actions[ag_force][3].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_force][3].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_force][3].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_force][3].targets[tk_item].MaxAmount:= 3;
    Self.data.actions[ag_force][3].targets[tk_self].MaxAmount:= -1;

    //Казнь
    Self.data.actions[ag_force][4].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_force][4].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_force][4].targets[tk_person].MaxAmount:= MAX_PARTY_SIZE + 1;
    Self.data.actions[ag_force][4].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_force][4].targets[tk_self].MaxAmount:= -1;

    //Светские
    //Встреча
    Self.data.actions[ag_court][0].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_court][0].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_court][0].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_court][0].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_court][0].targets[tk_self].MaxAmount:= -1;

    //Тороговля
    Self.data.actions[ag_court][1].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_court][1].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_court][1].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_court][1].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_court][1].targets[tk_self].MaxAmount:= -1;

    //Посещение церкви
    Self.data.actions[ag_court][2].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_court][2].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_court][2].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_court][2].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_court][2].targets[tk_self].MaxAmount:= -1;

    //Архив
    Self.data.actions[ag_court][3].targets[tk_nondef].MaxAmount:= 1;
    Self.data.actions[ag_court][3].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_court][3].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_court][3].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_court][3].targets[tk_self].MaxAmount:= -1;

    //Контакт с полицией
    Self.data.actions[ag_court][4].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_court][4].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_court][4].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_court][4].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_court][4].targets[tk_self].MaxAmount:= -1;

    //Скрытные
    //Проникновение
    Self.data.actions[ag_stealth][0].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_stealth][0].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_stealth][0].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_stealth][0].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_stealth][0].targets[tk_self].MaxAmount:= 1;

    //Убийство
    Self.data.actions[ag_stealth][1].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_stealth][1].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_stealth][1].targets[tk_person].MaxAmount:= MAX_PARTY_SIZE + 1;
    Self.data.actions[ag_stealth][1].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_stealth][1].targets[tk_self].MaxAmount:= -1;

    //Изъятие
    Self.data.actions[ag_stealth][2].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_stealth][2].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_stealth][2].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_stealth][2].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_stealth][2].targets[tk_self].MaxAmount:= -1;

    //Установка прослушки
    Self.data.actions[ag_stealth][3].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_stealth][3].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_stealth][3].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_stealth][3].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_stealth][3].targets[tk_self].MaxAmount:= 1;

    //Слежка
    Self.data.actions[ag_stealth][4].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_stealth][4].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_stealth][4].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_stealth][4].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_stealth][4].targets[tk_self].MaxAmount:= -1;

    //Следственные
    //Осмотр места
    Self.data.actions[ag_investigation][0].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_investigation][0].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_investigation][0].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_investigation][0].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_investigation][0].targets[tk_self].MaxAmount:= -1;

    //Анализ улик
    Self.data.actions[ag_investigation][1].targets[tk_nondef].MaxAmount:= 1;
    Self.data.actions[ag_investigation][1].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_investigation][1].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_investigation][1].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_investigation][1].targets[tk_self].MaxAmount:= -1;

    //Расшифровка
    Self.data.actions[ag_investigation][2].targets[tk_nondef].MaxAmount:= 1;
    Self.data.actions[ag_investigation][2].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_investigation][2].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_investigation][2].targets[tk_item].MaxAmount:= 1;
    Self.data.actions[ag_investigation][2].targets[tk_self].MaxAmount:= -1;

    //Допрос
    Self.data.actions[ag_investigation][3].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_investigation][3].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_investigation][3].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_investigation][3].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_investigation][3].targets[tk_self].MaxAmount:= -1;

    //Поиск свидетелей
    Self.data.actions[ag_investigation][4].targets[tk_nondef].MaxAmount:= 1;
    Self.data.actions[ag_investigation][4].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_investigation][4].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_investigation][4].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_investigation][4].targets[tk_self].MaxAmount:= -1;

    //Прочие
    //Вербовка
    Self.data.actions[ag_others][0].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_others][0].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_others][0].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_others][0].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_others][0].targets[tk_self].MaxAmount:= -1;

    //Взлом сети
    Self.data.actions[ag_others][1].targets[tk_nondef].MaxAmount:= 1;
    Self.data.actions[ag_others][1].targets[tk_place].MaxAmount:= 1;
    Self.data.actions[ag_others][1].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_others][1].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_others][1].targets[tk_self].MaxAmount:= -1;

    //Тренировка
    Self.data.actions[ag_others][2].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_others][2].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_others][2].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_others][2].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_others][2].targets[tk_self].MaxAmount:= 1;

    //Лечение
    Self.data.actions[ag_others][3].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_others][3].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_others][3].targets[tk_person].MaxAmount:= 1;
    Self.data.actions[ag_others][3].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_others][3].targets[tk_self].MaxAmount:= 1;

    //Отдых
    Self.data.actions[ag_others][4].targets[tk_nondef].MaxAmount:= -1;
    Self.data.actions[ag_others][4].targets[tk_place].MaxAmount:= -1;
    Self.data.actions[ag_others][4].targets[tk_person].MaxAmount:= -1;
    Self.data.actions[ag_others][4].targets[tk_item].MaxAmount:= -1;
    Self.data.actions[ag_others][4].targets[tk_self].MaxAmount:= 1;

    //Число исполнителей (требуемое и максимальное)

    //Силовые
    Self.data.actions[ag_force][0].actors[0]:= 1; Self.data.actions[ag_force][0].actors[1]:= MAX_PARTY_SIZE + 1; //Уничтожение
    Self.data.actions[ag_force][1].actors[0]:= 1; Self.data.actions[ag_force][1].actors[1]:= MAX_PARTY_SIZE + 1; //Штурм
    Self.data.actions[ag_force][2].actors[0]:= 1; Self.data.actions[ag_force][2].actors[1]:= MAX_PARTY_SIZE + 1; //Захват
    Self.data.actions[ag_force][3].actors[0]:= 1; Self.data.actions[ag_force][3].actors[1]:= MAX_PARTY_SIZE + 1; //Конфискация
    Self.data.actions[ag_force][4].actors[0]:= 1; Self.data.actions[ag_force][4].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Казнь

    //Светские
    Self.data.actions[ag_court][0].actors[0]:= 1; Self.data.actions[ag_court][0].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Встреча
    Self.data.actions[ag_court][1].actors[0]:= 1; Self.data.actions[ag_court][1].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Торговля
    Self.data.actions[ag_court][2].actors[0]:= 1; Self.data.actions[ag_court][2].actors[1]:= MAX_PARTY_SIZE + 1; //Посещене церкви
    Self.data.actions[ag_court][3].actors[0]:= 1; Self.data.actions[ag_court][3].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Архив
    Self.data.actions[ag_court][4].actors[0]:= 1; Self.data.actions[ag_court][4].actors[1]:= 1; //Контакт с полицией

    //Скрытные
    Self.data.actions[ag_stealth][0].actors[0]:= 1; Self.data.actions[ag_stealth][0].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Проникновение
    Self.data.actions[ag_stealth][1].actors[0]:= 1; Self.data.actions[ag_stealth][1].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Убийство
    Self.data.actions[ag_stealth][2].actors[0]:= 1; Self.data.actions[ag_stealth][2].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Изъятие
    Self.data.actions[ag_stealth][3].actors[0]:= 1; Self.data.actions[ag_stealth][3].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Установка прослушки
    Self.data.actions[ag_stealth][4].actors[0]:= 1; Self.data.actions[ag_stealth][4].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Слежка

    //Следственные
    Self.data.actions[ag_investigation][0].actors[0]:= 1; Self.data.actions[ag_investigation][0].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Осмотр места
    Self.data.actions[ag_investigation][1].actors[0]:= 1; Self.data.actions[ag_investigation][1].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Анализ улик
    Self.data.actions[ag_investigation][2].actors[0]:= 1; Self.data.actions[ag_investigation][2].actors[1]:= 1; //Расшифровка
    Self.data.actions[ag_investigation][3].actors[0]:= 1; Self.data.actions[ag_investigation][3].actors[1]:= 2; //Допрос
    Self.data.actions[ag_investigation][4].actors[0]:= 1; Self.data.actions[ag_investigation][4].actors[1]:= MAX_PARTY_SIZE + 1; //Поиск свидетелей

    //Прочие
    Self.data.actions[ag_others][0].actors[0]:= 1; Self.data.actions[ag_others][0].actors[1]:= (MAX_PARTY_SIZE + 1) div 2; //Вербовка
    Self.data.actions[ag_others][1].actors[0]:= 1; Self.data.actions[ag_others][1].actors[1]:= 1; //Взлом сети
    Self.data.actions[ag_others][2].actors[0]:= 1; Self.data.actions[ag_others][2].actors[1]:= 1; //Тренировка
    Self.data.actions[ag_others][3].actors[0]:= 1; Self.data.actions[ag_others][3].actors[1]:= 1; //Лечение
    Self.data.actions[ag_others][4].actors[0]:= 1; Self.data.actions[ag_others][4].actors[1]:= 1; //Отдых

  end;
//<-------------------------------------------------------------------------->\\
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<------------------------КЛАСС ПЕРСОНАЖЕЙ (TCharacter)--------------------->\\
//<-------------------------------------------------------------------------->\\

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
    Self.props.gender:= (((Random(2)+1) div 2) = 0);
    Self.props.isfree:= True;
    //добавление от 20.08.2015
    //поле адреса НИП
    Self.props.address:= -1; //По умолчанию НИП никуда не заселяется
    //генерация типа родного мира
    Self.props.origin:= Random(ORIGINS_COUNT + 1);
    //определение имени из 3 слов (индексов, указывающих на языковую группу и номер имени внутри группы)
    for i:=0 to 2 do
    begin
      Self.props.name[i][0]:= Random(4); //определение языковой группы, к которой относится часть имени (группа infr не используется, т.к. отвечает за ники)
      Self.props.name[i][1]:= Random(NAMES_COUNT + 1); //определение номера имени внутри языковой группы
    end;
    //генерация внешности
    //телосложение
    Self.props.outlook[ol_bodytype]:= Random(FEATS_COUNT + 1);
    //цвет кожи
    Self.props.outlook[ol_skin]:= Random(FEATS_COUNT + 1);
    //цвет глаз
    Self.props.outlook[ol_eyes]:= Random(FEATS_COUNT + 1);
    //цвет волос
    Self.props.outlook[ol_hair]:= Random(FEATS_COUNT + 1);
    //особые приметы
    Self.props.outlook[ol_perk1]:= Random(PERKS_COUNT + 1);
    repeat
      Self.props.outlook[ol_perk2]:= Random(PERKS_COUNT + 1);
    until (Self.props.outlook[ol_perk2] <> Self.props.outlook[ol_perk1]);
    repeat
      Self.props.outlook[ol_perk3]:= Random(PERKS_COUNT + 1);
    until ((Self.props.outlook[ol_perk3] <> Self.props.outlook[ol_perk1]) and (Self.props.outlook[ol_perk3] <> Self.props.outlook[ol_perk2]));
    //генерация возраста
    Self.props.age:= genrnd(AGE_BASE + Random(AGE_SEED), AGE_DIFF + Random(AGE_DIFF));
    //дополнения и изменения от 01.02.2015
    //убрана генерация флажков еретика и псайкера, добавлена генерация принадлежности к социальным группам
    //порядок проверки: 1-3)проверка Ксенос-Еретикус-Маллеус (т.к. имеют минимальную вероятность)
    //4)Еретики 5)Механикус 6)Экклезиархия 7)Арбитрес 8)Бандиты 9)Гвардия 10)Горожанин
    //логика проверки следующая - проверка идет по восходящей вероятности для отсечения лишних проверок (гарнтированно несовместных статусов)
    //преинициализация социальных статусов (начальное значение - ложь)ъ
    for i:= 0 to FACTIONS_COUNT do
      Self.props.factions[i]:= False;
    //Проверка на принадлежность к Ордо Маллеус (НИП не должен принадлежать к еретикам, Ордо Ксенос и Ордо Еретикус)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[9]) then
      Self.props.factions[9]:= True;
    //Проверка на принадлежность к Ордо Еретикус (НИП не должен принадлежать к Ордо Маллеус)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[8]) and (Self.props.factions[9] = False) then
      Self.props.factions[8]:= True;
    //Проверка на принадлежность к Ордо Ксенос (НИП не должен принадлежать к Ордо Маллеус и Ордо Еретикус)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[7]) and (Self.props.factions[9] = False) and (Self.props.factions[8] = False) then
      Self.props.factions[7]:= True;
    //Проверка на принадлежность к еретикам (НИП не должен принадлежать к Ордо Ксенос, Ордо Еретикус, Ордо Маллеус)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[4]) and (Self.props.factions[9] = False) and (Self.props.factions[8] = False) and (Self.props.factions[7] = False) then
      Self.props.factions[4]:= True;
    //проверка на принадлежность к Механикус
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[6]) then
      Self.props.factions[6]:= True;
    //проверка на принадлежность к Экклезиархии (НИП не должен принадлежать к Механикус)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[5]) and (Self.props.factions[6] = False) then
      Self.props.factions[5]:= True;
    //проверка на принадлежность к Арбитрес (НИП не должен принадлежать к Экклезиархии и Механикус)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[2]) and (Self.props.factions[6] = False) and (Self.props.factions[5] = False) then
      Self.props.factions[2]:= True;
    //проверка на принадлежность к бандитам (НИП не должен принадлежать к Арбитрес, Экклезиархии и Механикус)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[1]) and (Self.props.factions[6] = False) and (Self.props.factions[5] = False) and (Self.props.factions[2] = False) then
      Self.props.factions[1]:= True;
    //проверка на принадлежность к Гвардии (НИП не должен принадлежать к бандитам и Арбитрес)
    if (Random(DICE_D100 + 1) <= Stock.data.fprobs[3]) and (Self.props.factions[1] = False) and (Self.props.factions[2] = False) then
      Self.props.factions[3]:= True;
    //проверка на принадлежность к горожанам (НИП не должен принадлежать к Арбитрес, Гвардии, Экклезиархии и Механикус)
    if (Self.props.factions[2] = False) and (Self.props.factions[3] = False) and (Self.props.factions[5] = False) and (Self.props.factions[6] = False) then
      Self.props.factions[0]:= True;
    //генерация параметров персонажа по уравнению Пар = СлЧ(20) + ПрБ, где: Пар - итоговое значение параметра, СлЧ - функция генерации случайного числа от 1 до 20, ПрБ - бонус родного мира
    for i:=0 to STATS_COUNT do
      Self.props.stats[i]:= (Random(DICE_D20) + 2) + Stock.data.sbonus[Self.props.origin, i];
    //психотип
    Self.props.psychotype:= Random(89) div 10; // определение психотипа НИП
    //определение специальности НИП
    Self.props.specialty:= CLASS_COUNT + 1; //преинициализация идентификатора специальности (идентификатор устанавливается вне пределов действующего диапазона - 0..7)
    i:= 0; //инициализация счетчика для перебора специальностей
    k:= 0;
    repeat
      if (i > CLASS_COUNT) then i:= 0; //если превышен диапазон перебора (0..7) то вернуть счетчик в начало
      //если случайное число укладывается в диапазон (0..Р), где Р - вероятность специальности для данного типа родного мира, присвоить персонажу эту специальность
      if((Random(DICE_D100 + 1)+1) <= Stock.data.sprobs[Self.props.origin,i]) then
        Self.props.specialty:= i;
      i:= i+1; //сместить счетчик на одну позицию
      k:= k+1; //подсчет проходов (для аварийного выхода
    until (Self.props.specialty < (CLASS_COUNT + 1)) or (k >= 100); //условие выхода из цикла - попадание идентификатора специальности в диапазон 0..7 либо сделано 100 безрезультатных проходов
    //получение звания в группах, в которых он состоит
    for i:=0 to FACTIONS_COUNT do
    //если НИП принадлежит к фракции, начать генерацию звания
      if (Self.props.factions[i]) then
      begin
        Self.props.ladder[i]:=4; //преинициализация звания вне рабочего деиапазона (0..3)
        j:= 0; //установка счетчика на ноль
        k:= 0;
        repeat
          if (j > 3) then j:= 0; //если счетчик вышел из рабочего диапазона, вернуть его в начало
          //если случайное число от 0 до 100 лежит в диапазоне 0..Р, где Р - вероятность звания, установить значение поля равным текущему значению счетчика
          if (Random(101) <= Stock.data.lprobs[j]) then
            Self.props.ladder[i]:= j;
          j:= j + 1;
          k:= k + 1;
        until (Self.props.ladder[i] < 4) or (k >= 100);
      end;
    //дополнения от 14.07.2015
    //инициализация массивов параметров DMS и склонностей
    //массив склонностей
    //преинициализация массива склонностей
      for ag:= ag_force to ag_others do
      begin
        Self.props.addictions[ag]:= Random(81) - 40; //каждый параметр массива склонностей инициализируется случайным числом -40..40
      end;
    //применение модификаторов к массиву склонностей
      for ag:= ag_force to ag_others do
      begin
      //модификатор класса
        Self.props.addictions[ag]:= Self.props.addictions[ag] + Stock.data.addmods.clasmods[Self.props.specialty][ag];
      //модификатор происхождения
        Self.props.addictions[ag]:= Self.props.addictions[ag] + Stock.data.addmods.origmods[Self.props.origin][ag];
      //модификаторы фракций
      //преинициализация
        factsum:= 0;
      //расчет суммарного модификатора по текущему параметру DMS
        for i:= 0 to FACTIONS_COUNT do
        begin
        //применяются только модификаторы фракций, к которым принадлежит НИП
          if Self.props.factions[i] then
          begin
            factsum:= factsum + Stock.data.addmods.factmods[i][ag];
          //если сумма вышла за границы, вернуть в предельное значение
            if (factsum < -FACT_MOD_LIM) then
              factsum:= -FACT_MOD_LIM;
            if (factsum > FACT_MOD_LIM) then
              factsum:= FACT_MOD_LIM;
          end;
        end;
      //применение суммарного модификатора фракций
        Self.props.addictions[ag]:= Self.props.addictions[ag] + factsum;
      end;
    //массив параметров DMS
    //преинициализация массива параметров DMS НИП
      for dp:= dp_diligence to dp_authority do
      begin
        Self.props.dmsparams[dp]:= Random(81) - 40; //каждый параметр DMS НИП инициализируется как случайное число -40..40
      end;
    //применение модификаторов параметров DMS
      for dp:= dp_diligence to dp_authority do
      begin
      //модификатор класса
        Self.props.dmsparams[dp]:= Self.props.dmsparams[dp] + Stock.data.dmsmods.clasmods[Self.props.specialty][dp];
      //модификаторы происхождения
        Self.props.dmsparams[dp]:= Self.props.dmsparams[dp] + Stock.data.dmsmods.origmods[Self.props.origin][dp];
      //модификаторы фракций
      //преинициализация
        factsum:= 0;
      //расчет суммарного модификатора по текущему параметру DMS
        for i:= 0 to FACTIONS_COUNT do
        begin
        //применяются только модификаторы фракций, к которым принадлежит НИП
          if Self.props.factions[i] then
          begin
            factsum:= factsum + Stock.data.dmsmods.factmods[i][dp];
          //если сумма вышла за границы, вернуть в предельное значение
            if (factsum < -FACT_MOD_LIM) then
              factsum:= -FACT_MOD_LIM;
            if (factsum > FACT_MOD_LIM) then
              factsum:= FACT_MOD_LIM;
          end;
        end;
      //применение суммарного модификатора DMS
        Self.props.dmsparams[dp]:= Self.props.dmsparams[dp] + factsum;
      end;
    //дополнения от 04.02.2015-05.02.2015
    //преинициализация массива контактов
    for i:=0 to CONTACTS_COUNT do
      Self.props.contacts[i]:= -1; //все индексы устанавливаются в -1 (вне рабочего диапазона)
    //принудительная задержка в 1 мс для корректной работы генератора случайных чисел
    Sleep(1);
  end;

//конструктор класса НИП с загрузкой данных извне
  constructor THuman.create(data: THumanData);
  begin
    inherited create;
    Self.props:= data;
  end;

//деструктор НИП
  destructor THuman.destroy;
  begin
    inherited destroy;
  end;

//<-------------------------------------------------------------------------->\\
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<-----------------------------КЛАСС ДОМОВ (THouse)------------------------->\\
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

//добавление от 11.08.2015 - деструктор класса дома
//деструктор класса дома
  destructor THouse.destroy;
  begin
    inherited destroy;
  end;

//<-------------------------------------------------------------------------->\\
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<-----------------------------КЛАСС ГОРОДА (TCity)------------------------->\\
//<-------------------------------------------------------------------------->\\

//конструктор класса города
  constructor TCity.create(populace: integer);
  var
    i, count: integer;
  begin
    inherited create;
  //расчет требуемого количества домов под текущее население города
  //если численность жителей делится на емкость одного дома нацело - выделить ровно столько домов сколько получается при делении
  //иначе выделить еще один дом дополнительно
    if ((populace mod HOUSE_CAPACITY) = 0) then
      count:= populace div (HOUSE_CAPACITY + 1)
    else
      count:= populace div (HOUSE_CAPACITY + 1) + 1;
  //выделить память под массив домов
    setlength(Self.houselist, count);
  //выполнить преинициализацию домов
    for i:= 0 to (count-1) do
      Self.houselist[i]:= THouse.create;
  end;

//добавление от 11.08.2015 - деструктор класса города
//деструктор класса города
  destructor TCity.destroy;
  var
    i: integer;
  begin
  //перед уничтожением города высвободить память из-под каждого дома
    for i:=0 to high(Self.houselist) do
      Self.houselist[i].destroy;
    setlength(Self.houselist,0);
    inherited destroy;
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
    for j:= 0 to (HOUSE_CAPACITY - 1) do
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

//процедура поиска жителя в городе по идентификатору (возвращает номер дома где он живет, либо -1, если не заселен)
  function TCity.is_settled(numb: integer): integer;
  var
    i,j: integer;
  begin
    result:= -1; //преинициализация резульатата как "не заселен" (в случае если житель не найден, функция это и выдаст)
    for i:= 0 to high(Self.houselist) do
      for j:= 0 to (HOUSE_CAPACITY - 1) do
      begin
      //если житель найден, записать в вывод номер дома и прекратить поиск в доме
        if (Self.houselist[i].people[j] = numb) then
        begin
          result:= i;
          break;
        end;
      //если житель найден, прекратить дальнейший поиск
        if (result <> -1) then
          break;
      end;
  end;
//<-------------------------------------------------------------------------->\\
//<-------------------------------------------------------------------------->\\

//<-------------------------------------------------------------------------->\\
//<----------------------------КЛАСС ПЛАНЕТЫ (TPlanet)----------------------->\\
//<-------------------------------------------------------------------------->\\

//конструктор класса планеты
  constructor TPlanet.create;
  var
    i,j: Integer;
  begin
    if (Self.store = nil) then
      Self.store:= TStorage.create;
    Self.store.initialize;
  //генерация населения
    for i:=0 to DISTRICT_SIZE do
      Self.people[i]:= THuman.create(Self.store);
  //добавление от 19.08.2015
  //инициализация города и расселение жителей
    Self.housing:= TCity.create(DISTRICT_SIZE + 1); //инициализация города
    Self.housing.settle(DISTRICT_SIZE + 1); //предварительное расселение НИП
  //Передача объектам НИП информации о месте проживания
    for i:= 0 to (length(Self.housing.houselist) - 1) do
      for j:= 0 to (HOUSE_CAPACITY - 1) do
      begin
        Self.people[Self.housing.houselist[i].people[j]].props.address:= i;
      end;
  //добавления от 01.02.2015
  //определение типа планеты
    Randomize;
    Self.kind:= Random(ORIGINS_COUNT + 1);
  //преинициадизация статистики по фракциям (предварительное обнуление)
    for i:=0 to FACTIONS_COUNT do
      Self.factions[i]:=0;
  //Инициализация точки отсчета
    for i:=0 to 2 do
    begin
      if (i = 0) then
        Self.time[i]:= START_YEAR + Random(500); //год
      if (i = 1) then
        Self.time[i]:= Random(12)+1; //месяц
      if (i = 2) then
        Self.time[i]:= Random(30) + 1; //день
    end;
  //инициализация названия планеты
    Randomize;
    Self.name[1]:= Self.store.data.plnames[Random(10)]; //иницализация порядкового номера планеты
    //
    i:= Random(4); //определение языковой группы, к которой относится часть имени (группа infr не используется, т.к. отвечает за ники)
    j:= Random(NAMES_COUNT); //определение номера имени внутри языковой группы
    //
    case i of
    0: begin
         if ((random(1001) mod (DICE_D100 + 1)) <= 50) then
            Self.name[0]:= Self.store.data.mnames.prim[j]
         else
            Self.name[0]:= Self.store.data.fnames.prim[j];
       end;
    1: begin
         if ((random(1001) mod (DICE_D100 + 1)) <= 50) then
            Self.name[0]:= Self.store.data.mnames.low[j]
         else
            Self.name[0]:= Self.store.data.fnames.low[j];
       end;
    2: begin
         if ((random(1001) mod (DICE_D100 + 1)) <= 50) then
            Self.name[0]:= Self.store.data.mnames.high[j]
         else
            Self.name[0]:= Self.store.data.fnames.high[j];
       end;
    3: begin
         if ((random(1001) mod (DICE_D100 + 1)) <= 50) then
            Self.name[0]:= Self.store.data.mnames.arch[j]
         else
            Self.name[0]:= Self.store.data.fnames.arch[j];
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
  //перебор всех жителей
    for i:=0 to DISTRICT_SIZE do
    begin
    //просмотр каждого из доступных 6 контактов жителя
      for j:=0 to CONTACTS_COUNT do
      begin
      //если контакт пуст начинаем случайно выбирать НИП из списка населения
        if (Self.people[i].props.contacts[j] = -1) then
        begin
          repeat
            rndig:= Random(DISTRICT_SIZE); //выбираем случайного НИП
            frees:= 0; //считаем что у него уже заполнены все ячейки контактов
          //перебираем эти ячейки в поисках свободной
            for k:= 0 to CONTACTS_COUNT do
            //подсчитываем число свободных ячеек у этого НИП
              if (Self.people[rndig].props.contacts[k] = -1) then
                frees:= frees + 1;
            //если нашли свободную ячейку, вписываем в нее подобраного НИП
            if (frees > 0) then
              Self.people[i].props.contacts[j]:= rndig;
            k:=-1;
            repeat
              k:= k+1;
              //ShowMessage(IntToStr(k));
              if (Self.people[rndig].props.contacts[k] = -1) then
                Self.people[rndig].props.contacts[k]:= i;
            until (Self.people[rndig].props.contacts[k] = i) or (k >= 5);
          until (Self.people[i].props.contacts[j] <> i);
        end;
      end;
    end;
  end;


//процедура генерации статистики
  procedure TPlanet.GetData;
  var
    i,j: integer;
  begin
  //формирование статистики - прочесывание базы населения со сканированием по фракциям и увеличение значения того поля массива численности, индекс которого находится в поле фракции текущего НИП
    for i:=0 to DISTRICT_SIZE do
      for j:=0 to FACTIONS_COUNT do
        if (Self.people[i].props.factions[j]) then
          Self.factions[j]:= Self.factions[j] + 1;
  end;

//<-------------------------------------------------------------------------->\\
//<-------------------------------------------------------------------------->\\

end.
