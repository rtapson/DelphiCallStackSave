object OfflineCallStackFrame: TOfflineCallStackFrame
  Left = 0
  Top = 0
  Width = 359
  Height = 545
  Align = alClient
  TabOrder = 0
  OnEnter = FrameEnter
  object CallStackListBox: TListBox
    Left = 0
    Top = 22
    Width = 359
    Height = 523
    Style = lbOwnerDrawFixed
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = CallStackListBoxDblClick
    OnDrawItem = CallStackListBoxDrawItem
  end
  object CallStackFilesDropdown: TComboBoxEx
    Left = 0
    Top = 0
    Width = 359
    Height = 22
    Align = alTop
    ItemsEx = <>
    TabOrder = 1
    OnChange = CallStackFilesDropdownChange
  end
end
