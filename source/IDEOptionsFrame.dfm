object OfflineCallstackOptionsFrame: TOfflineCallstackOptionsFrame
  Left = 0
  Top = 0
  Width = 635
  Height = 474
  Align = alClient
  TabOrder = 0
  object JsonFileSavePathLabel: TLabel
    Left = 16
    Top = 16
    Width = 133
    Height = 13
    Caption = 'Offline call stack save path:'
  end
  object Label1: TLabel
    Left = 16
    Top = 72
    Width = 73
    Height = 13
    Caption = 'Base file name:'
  end
  object JsonFileSavePathEdit: TButtonedEdit
    Left = 32
    Top = 35
    Width = 321
    Height = 21
    RightButton.Visible = True
    TabOrder = 0
    Text = 'JsonFileSavePathEdit'
  end
  object BaseFileNameEdit: TEdit
    Left = 32
    Top = 91
    Width = 177
    Height = 21
    TabOrder = 1
    Text = 'BaseFileNameEdit'
  end
end
