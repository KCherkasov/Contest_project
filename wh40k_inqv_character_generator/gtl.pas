//модуль констант и глобальных типов данных прокета "Инквизитор"
//разработано Черкасовым К.В.

unit gtl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

//<-------------------------------------------------------------------------->\\
//<------------------------------КОНСТАНТЫ----------------------------------->\\
//<-------------------------------------------------------------------------->\\

const

//константа пустого индекса
  FREE_INDEX = -1;

//константы для работы со  степенями успеха/провала
  SUCCESS_GRADE = 10; //размер степени успеха (константа для конверсии)
  MIN_SUCCESS_GRADE = -3; //нижний предел степеней успеха/провала
  MAX_SUCCESS_GRADE = 3; //верхний предел степеней успеха/провала


//константы для генерации случайного числа "броском кубика"
  DICE_D20 = 20;
  DICE_D100 = 100;

//константы для работы с возрастом персонажей
  AGE_BASE = 25; //база - число, вокруг которого строим разброс
  AGE_SEED = 30; //семя - число, по которому генерируется прибавка к базе (модулятор)
  AGE_DIFF = 30; //разброс - число, по которому генерируется разброс в точке модулированной базы

  FACT_MOD_LIM = 20; //предельно допустимое абсолютное значение суммарного модификатора фракции

  MAX_PARTY_SIZE = 5; //максимально возможный размер группы

  HERESY_ORD_CHANCE = 25; //константа вероятности получения НИП приказа "ересь"

//константы размеров контейнеров персонажей (верхние значения индексов массивов)
  DISTRICT_SIZE = 999; //константа размера округа (либо города, если в нем всего один округ)
  HOUSE_CAPACITY = 9; //константа размера дома (сколько жителей в нем помещается - 1)

//верхние значения индексов массивов
  FACTIONS_COUNT = 9; //константа верхнего индекса числа фракций
  ORIGINS_COUNT = 3; //константа верхнего индекса числа родных миров
  CLASS_COUNT = 7; //константа числа классов
  NAMES_COUNT = 29; //константа числа имен в языковой группе
  STATS_COUNT = 8; //константа числа характеристик персонажа
  CONTACTS_COUNT = 5; //константа предельного числа контактов персонажа
  FEATS_COUNT = 4; //константа числа вариаций описания внешности
  PERKS_COUNT = 15; //константа числа особых примет на родной мир
  PSYCHOTYPES_COUNT = 8; //константа числа психотипов
  ACTIONS_COUNT = 4; //константа числа действий в группе

//константы временных диапазонов
  START_YEAR = 40000; //минимальный стартовый год
  MONTHS_COUNT = 12; //число месяцев
  WEEK_DAYS_COUNT = 7; //число дней недели

//константны для работы с "фантомами"
//"фантом" - массив данных персонажа, которые известны пользователю. Эти данные чаще всего недостоверны, либо попросту отсутствуют.
//нахождение новых сведений и улик позволяет узнать реальные данные и видеть их вместо данных "фантома"

//дисперсионные константы для "фантомов"
  PH_STAT_DISPERSION = 5; //константа дисперсии фантомных характеристик персонажа - максимальный по абсолютному значению разброс относительно реального значения характеристики персонажа
  PH_DMS_DISPERSION = 20; //константа дисперсии фантомных параметров DMS персонажа
  PH_ADD_DISPERSION = 20; //константа дисперсии фантомных параметров склонностей персонажа

//вероятностные константы для работы с "фантомами"
  PH_FACT_VISIBILTY_PROB = 50; //константа вероятности видимости фракции (базовая - для конкретных фракций высчитывается в долях от базовой)
  PH_CLASS_VISIBILTY_PROB = 50; //константа вероятности видимости класса персонажа (базовая - см. выше)
  PH_ORIGIN_VISIBILITY_PROB = 50; //константа вероятности видимости происхождения (базовая)
  PH_START_REAL_PROB = 10; //константа вероятности установки значения поля визуализатора в "реальное значение"
  PH_START_NODATA_PROB = 45; //константа вероятности установки значения поля визуализатора в "нет данных"
  PH_START_PHANTOM_PROB = 45; //константак вероятности установки значения поля визуализатора в "данные фантома"

//строковые и символьные константы для работы с "фантомами"
  PH_NONDEF_PROP = 'нет данных'; //константа, выводимая при недоступности сведения (если параметр "фантома" числовой, для указание на отсутствие сведений сообщить туда константу FREE_INDEX)

//строковые и символьные константы

//единицы измерение
  SANTIMETER_NAME = 'см'; //
  KILOGRAMM_NAME = 'кг'; //


//<-------------------------------------------------------------------------->\\

type

//<-------------------------------------------------------------------------->\\
//<----------------------------- ТИПЫ ДАННЫХ -------------------------------->\\
//<-------------------------------------------------------------------------->\\

//тип перечисления параметров описания внешности (рост, вес, цвет кожи, цвет глаз, цвет волос, 3 особые приметы)
  TOutlook = (ol_bodytype, ol_skin, ol_eyes, ol_hair, ol_perk1, ol_perk2, ol_perk3);

//тип перечисления видов целей (не определено, место, персонаж, предмет, сам)
  TTargetKind = (tk_nondef, tk_place, tk_person, tk_item, tk_self);

//
  TClueKind = (ck_);

//тип перечисления групп действий (силовые светские скрытные следственные прочие)
  TActGroups = (ag_force, ag_court, ag_stealth, ag_investigation, ag_others);

//тип перечисления видов приказов (убить принести изучать допросить искать личное время, ересь)
  TOrdGroups = (og_kill, og_capture, og_research, og_interrogate, og_search, og_freetime, og_heresy);

//тип перечисления параметров DMS (Исполнительность Самосознание Хладнокровие Обучаемость Авторитетность)
  TDMSParams = (dp_diligence, dp_identity, dp_calmness, dp_educability, dp_authority);

//тип парных битовых чисел
  TBytePair = array [0..1] of Byte;

//процентный тип со знаком
  TSCent = -100..100;

//тип строк имен
  TNameString = string[60];

//тип состояния поля визуализатора
//vs_nodata-данные неизвестны, vs_real-реальные данные, vs_phantom-данные из "фантома"
  TVisualiserSrc = (vs_nodata, vs_real, vs_phantom);

//тип перечисления результатов действия
//ar_grdeath_all, ar_grdeath_half, ar_grwound_all, ar_grwound_half,
//ar_tgt_destroy, ar_tgt_capture, ar_act_unavailible,
//ar_new_recruits, ar_extra_exp, ar_new_info, ar_stat_up,
//ar_std_fail, ar_new_witness, ar_hpchange, ar_new_item
  TActionResult = (ar_grdeath_all, ar_grdeath_half, ar_grwound_all, ar_grwound_half, ar_tgt_destroy, ar_tgt_capture, ar_act_unavailible, ar_new_recruits, ar_extra_exp, ar_new_info, ar_stat_up, ar_std_fail, ar_new_witness, ar_hpchange, ar_new_item);

//тип массивов имен
  TStrArr = array [0..NAMES_COUNT] of TNameString;

//тип данных о доступности цели
  TTarget = record
    Availible: Boolean; //флажок доступности
    MaxAmount: Integer; //максимально возможное число целей данного типа
  end;

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
    clasmods: array [0..CLASS_COUNT] of TAddiction; //модификаторы класса
    factmods: array [0..FACTIONS_COUNT] of TAddiction; //модификаторы фракции
    origmods: array [0..ORIGINS_COUNT] of TAddiction; //модификаторы происхождения
  end;

//тип блока модификаторов параметров DMS
  TDMSMods = record
    clasmods: array [0..CLASS_COUNT] of TDMSArr; //модификаторы класса
    factmods: array [0..FACTIONS_COUNT] of TDMSArr; //модификаторы фракции
    origmods: array [0..ORIGINS_COUNT] of TDMSArr; //модификаторы происхождения
  end;

//тип хранилища вероятных исходов действия
  TSuccessGrades = array [MIN_SUCCESS_GRADE..MAX_SUCCESS_GRADE] of TActionResult;

//запись данных игрового действия
  TGameActionData =record
    name: TNameString; //индекс названия действия в дата-хранилище
    description: String; //индекс описания действия в дата-хранилище
    targets: array [TTargetKind] of TTarget; //массив доступных целей и их количество
    actors: TBytePair; //число исполнителей: требуемое и максимальное
    results: TSuccessGrades; //вероятные исходы действия
  end;

//тип подгрупп действий
  TActSubGroup = array [0..ACTIONS_COUNT] of TGameActionData;

//тип списка действий
  TActDataList = array [TActGroups] of TActSubGroup;

//тип записи фактически обрабатываемого действия
  TFactActionData = record
    Name: TNameString; //название
    Description: String; //описание
    TgtKind: TTargetKind; //тип цели
    TgtId: array [0..MAX_PARTY_SIZE] of Integer; //число целей
    StatsUsed: array [0..STATS_COUNT] of Boolean; //используемые параметры
    results: TSuccessGrades; //список возможных исходов
    difficulty: Byte; //сложность действия
  end;

//тип записи
  TActResultData = record
    parent: TNameString; //название
    kind: TActionResult; //тип результата
    TgtKind: TTargetKind; //тип цели, к которой применяется воздействие результата
    TgtId: array [0..MAX_PARTY_SIZE] of Integer; //индексы целей, к которым применяется результат (если целей менне макс кол-ва, в незанятые ячейки вписать -1)
  end;

//Тип содержимого дата-хранилизща
  TStorageData = record
    mnames: TDialNames; //мужские имена
    fnames: TDialNames; //женские имена
    cnames: array [0..CLASS_COUNT] of TNameString; //названия профессий (добавлено 01.02.2015)
    snames: array [0..STATS_COUNT] of TNameString; //названия параметров персонажа (добавлено 01.02.2015)
    pnames: array [0..PSYCHOTYPES_COUNT] of TNameString; //названия психотипов (добавлено 01.02.2015)
    plnames: array [0..9] of TNameString; //порядковые номера планет (добавлено 29.05.2015)
    dmsnames: array [TDMSParams] of TNameString; //названия параметров DMS (добавлено 16.07.2015)
    actnames: array [TActGroups] of TNameString; //названия групп действий
    ordnames: array [TOrdGroups] of TNameString; //названия приказов
    sbonus: array [0..ORIGINS_COUNT, 0..STATS_COUNT] of Byte; //бонусы параметров от родного мира (добавлено 01.02.2015)
    sprobs: array [0..ORIGINS_COUNT, 0..CLASS_COUNT] of Byte; //вероятности профессий в зависимости от происхождения (добавлено 01.02.2015)
    lprobs: array [0..3] of Byte; //вероятности субстатусов (добавлено 01.02.2015)
    factions: array [0..FACTIONS_COUNT] of TNameString; //названия фракций (добавлено 01.02.2015)
    fprobs: array [0..FACTIONS_COUNT] of Byte; //вероятности социальных статусов (добавлено 01.02.2015)
    gender: array [0..2] of TNameString; //названия полов
    hwtype: array [0..ORIGINS_COUNT] of TNameString; //тип родного мира
    bodytype: array [0..ORIGINS_COUNT, 0..FEATS_COUNT] of TNameString; //тип телосложения
    heitype: array [0..ORIGINS_COUNT, 0..1, 0..FEATS_COUNT] of TBytePair; //тип данных рост/вес (формат индексации: тип родного мира, пол, вариации) первое число - рост (см) второе вес(кг)
    skins: array [0..ORIGINS_COUNT, 0..FEATS_COUNT] of TNameString; //цвета кожи
    hairs: array [0..ORIGINS_COUNT, 0..FEATS_COUNT] of TNameString; //цвета волос
    eyes: array [0..ORIGINS_COUNT, 0..FEATS_COUNT] of TNameString;  //цвета глаз
    perks: array [0..ORIGINS_COUNT, 0..PERKS_COUNT] of TNameString; //массив особых примет
    addmods: TAddMods; //хранилище модификаторов психотипов (добавлено 01.07.2015)
    dmsmods: TDMSMods; //хранилище модификаторов параметров DMS (добавлено 03.07.2015)
    actions: TActDataList; //хранилище данных о действиях
    grexe: TNameString; //строка с расширением графических файлов (добавлено 05.02.2015)
  end;

//тип данных НИП
  THumanData = record
    name: array [0..2] of TBytePair; //имя (индексы языковой группы и номера имени в группе)
    address: integer; //номер дома, в котором живет НИП
    age: Integer; //возраст
    gender: Boolean; //пол
    outlook: array [TOutlook] of Byte; //внешний вид персонажа
    origin: Byte; //тип родного мира
    factions: array [0..FACTIONS_COUNT] of Boolean; //массив принадлежностей к фракциям (изменения от 01.02.2015 - удалены поля isheretic и ispsyker, введено поле factions)
    ladder: array [0..FACTIONS_COUNT] of Byte; //положение НИП внутри фракции (рядовой, предводитель, командир, лорд. Предводитель командует 3 рядовыми, командир - 3 предводителями, лорд - 3 командирами)(добавлено 01.02.2015)
    specialty: Byte; //класс НИП (добавлено 01.02.2015)
    psychotype: Byte; //психотип (добавлено 01.02.2015)
    addictions: TAddiction; //склонности НИП (добавлено 01.07.2015)
    dmsparams: TDMSArr; //параметры DMS НИП (добавлено 03.07.2015)
    stats: array [0..STATS_COUNT] of Byte; //массив параметров НИП (добавлено 01.02.2015)
    contacts: array [0..CONTACTS_COUNT] of Integer; //массив контактов НИП
    isfree: Boolean; //
  end;

//Тип данных визуализатора для "фантома"
  TVisualiserData = record
    name: array [0..2] of TVisualiserSrc;
    address: TVisualiserSrc;
    age: TVisualiserSrc;
    gender: TVisualiserSrc;
    origin: TVisualiserSrc;
    factions: array[0..FACTIONS_COUNT] of TVisualiserSrc;
    ladder: array [0..FACTIONS_COUNT] of TVisualiserSrc;
    specialty: TVisualiserSrc;
    psychotype: TVisualiserSrc;
    stats: array [0..STATS_COUNT] of TVisualiserSrc;
    contacts: array [0..CONTACTS_COUNT] of TVisualiserSrc;
  end;

implementation

end.
