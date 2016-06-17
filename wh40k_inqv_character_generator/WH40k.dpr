program WH40k;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Data in 'Data.pas' {DataModule1: TDataModule},
  cat in 'cat.pas',
  gtl in 'gtl.pas',
  IngameEventHandler in 'IngameEventHandler.pas',
  OrderHandler in 'OrderHandler.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  //Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
