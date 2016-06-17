unit Data;

interface

uses
  SysUtils, Classes, ExtCtrls, ImgList, Controls, ActnList;

type
  TDataModule1 = class(TDataModule)
    actlstActions: TActionList;
    actlstEvents: TActionList;
    ilFaces: TImageList;
    ilLandscape: TImageList;
    tmrSysTime: TTimer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
