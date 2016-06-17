unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmMain = class(TForm)
    btnCreate: TButton;
    btnModify: TButton;
    lbledFname: TLabeledEdit;
    btnExit: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbledFnameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

const
  HINT_UNLOCK = 'Введите имя файла для разблокирования кнопок управления';

implementation

{$R *.dfm}

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  btnCreate.Enabled:= False;
  btnModify.Enabled:= False;
end;

procedure TfrmMain.lbledFnameChange(Sender: TObject);
begin
  if (lbledFname.Text = '') then
  begin
    btnCreate.Enabled:= False;
    btnModify.Enabled:= False;
  end
  else
  begin
    btnCreate.Enabled:= True;
    btnModify.Enabled:= True;
  end;
end;

end.
