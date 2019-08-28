object OfflineCallstackOptionsFrame: TOfflineCallstackOptionsFrame
  Left = 0
  Top = 0
  Width = 562
  Height = 380
  Align = alClient
  TabOrder = 0
  object JsonFileSavePathLabel: TLabel
    Left = 16
    Top = 16
    Width = 193
    Height = 19
    Caption = 'Offline call stack save path:'
  end
  object Label1: TLabel
    Left = 16
    Top = 72
    Width = 108
    Height = 19
    Caption = 'Base file name:'
  end
  object JsonFileSavePathEdit: TButtonedEdit
    Left = 32
    Top = 35
    Width = 321
    Height = 27
    RightButton.Visible = True
    TabOrder = 0
    Text = 'JsonFileSavePathEdit'
  end
  object BaseFileNameEdit: TEdit
    Left = 32
    Top = 91
    Width = 177
    Height = 27
    TabOrder = 1
    Text = 'BaseFileNameEdit'
  end
  object RemoveUnreachableStackFramesCheckbox: TCheckBox
    Left = 16
    Top = 136
    Width = 273
    Height = 17
    Caption = 'Remove unreachable stack frames'
    TabOrder = 2
  end
end
