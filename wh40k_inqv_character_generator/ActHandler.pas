//модуль класса обработчика действий для проекта "Инквизитор"
//написано Черкасовым К.В., 2015

unit ActHandler;

interface

uses
  Windows, SysUtils, Math, Classes, gtl;

type

//класс обработчика действий
  TActHandler = class
    private
      data: TFactActionData; //поле данных действия
    public
      function IsEmpty: Boolean; //
      function SaveData: TFactActionData; //метод экспортирования данных действия
      procedure LoadData(data: TFactActionData); //метод импортирования данных действия
      constructor NewHandler; overload; //
      constructor NewHandler(data: TFactActionData); overload; //
      destructor KillHandler; overload; //
      destructor KillHandler(expdata: TFactActionData); overload; //
  end;

implementation



end.
