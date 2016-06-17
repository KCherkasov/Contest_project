object frmMain: TfrmMain
  Left = 0
  Top = 18
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Warhammer 40000 Inquisition ver. 0.0.1'
  ClientHeight = 677
  ClientWidth = 1350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblPersonAbout: TLabel
    Left = 1128
    Top = 8
    Width = 170
    Height = 19
    Caption = #1055#1086#1076#1088#1086#1073#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object imgPortrait: TImage
    Left = 1088
    Top = 32
    Width = 249
    Height = 249
  end
  object lblPlanet: TLabel
    Left = 56
    Top = 8
    Width = 142
    Height = 19
    Caption = #1053#1072#1089#1077#1083#1077#1085#1080#1077' '#1087#1083#1072#1085#1077#1090#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object imgPlanet: TImage
    Left = 832
    Top = 32
    Width = 249
    Height = 249
  end
  object lblPlanetInfo: TLabel
    Left = 880
    Top = 8
    Width = 168
    Height = 19
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1083#1072#1085#1077#1090#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 19
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object lblEventInfo: TLabel
    Left = 520
    Top = 8
    Width = 118
    Height = 19
    Caption = #1057#1074#1086#1076#1082#1072' '#1089#1086#1073#1099#1090#1080#1081
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object lstPeopleList: TListBox
    Left = 8
    Top = 32
    Width = 249
    Height = 641
    ItemHeight = 13
    TabOrder = 0
    OnClick = lstPeopleListClick
  end
  object mmoPerson: TMemo
    Left = 1088
    Top = 288
    Width = 249
    Height = 353
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object btnExit: TButton
    Left = 1208
    Top = 648
    Width = 131
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = btnExitClick
  end
  object lbledtYear: TLabeledEdit
    Left = 832
    Top = 616
    Width = 65
    Height = 21
    EditLabel.Width = 25
    EditLabel.Height = 19
    EditLabel.Caption = #1043#1086#1076
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = 19
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsBold, fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 3
  end
  object lbledtMonth: TLabeledEdit
    Left = 944
    Top = 616
    Width = 49
    Height = 21
    EditLabel.Width = 44
    EditLabel.Height = 19
    EditLabel.Caption = #1052#1077#1089#1103#1094
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = 19
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsBold, fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 4
  end
  object lbledtDay: TLabeledEdit
    Left = 1040
    Top = 616
    Width = 41
    Height = 21
    EditLabel.Width = 34
    EditLabel.Height = 19
    EditLabel.Caption = #1044#1077#1085#1100
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = 19
    EditLabel.Font.Name = 'Times New Roman'
    EditLabel.Font.Style = [fsBold, fsItalic]
    EditLabel.ParentFont = False
    TabOrder = 5
  end
  object mmoPlanetInfo: TMemo
    Left = 832
    Top = 288
    Width = 249
    Height = 305
    TabOrder = 6
  end
  object btnTurn: TButton
    Left = 832
    Top = 648
    Width = 249
    Height = 25
    Caption = #1061#1086#1076
    TabOrder = 7
    OnClick = btnTurnClick
  end
  object mmoEventList: TMemo
    Left = 264
    Top = 32
    Width = 561
    Height = 249
    TabOrder = 8
  end
end
