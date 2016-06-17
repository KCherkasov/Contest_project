object frmMain: TfrmMain
  Left = 1105
  Top = 194
  BorderStyle = bsSingle
  Caption = 'Warhammer 40'#39'000 Editor Toolset: TStorage Database Editor'
  ClientHeight = 637
  ClientWidth = 709
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object btnCreate: TButton
    Left = 8
    Top = 24
    Width = 169
    Height = 33
    Caption = 'Create New Database'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object btnModify: TButton
    Left = 8
    Top = 56
    Width = 169
    Height = 33
    Caption = 'Modify Database'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object lbledFname: TLabeledEdit
    Left = 184
    Top = 24
    Width = 169
    Height = 33
    EditLabel.Width = 114
    EditLabel.Height = 19
    EditLabel.Caption = 'Database file name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = lbledFnameChange
  end
  object btnExit: TButton
    Left = 560
    Top = 600
    Width = 145
    Height = 33
    Caption = 'Exit from editor'
    TabOrder = 3
    OnClick = btnExitClick
  end
end
