unit IDEOptionsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList;

type
  TOfflineCallstackOptionsFrame = class(TFrame)
    JsonFileSavePathEdit: TButtonedEdit;
    JsonFileSavePathLabel: TLabel;
    Label1: TLabel;
    BaseFileNameEdit: TEdit;
    RemoveUnreachableStackFramesCheckbox: TCheckBox;
    KeyBindingsGroupBox: TGroupBox;
    QuickSaveLabel: TLabel;
    SaveWithFileNameLabel: TLabel;
    QuickSaveKeyBindingEdit: TButtonedEdit;
    ImageList1: TImageList;
    SaveKeyBindingEdit: TButtonedEdit;
    procedure QuickSaveKeyBindingEditChange(Sender: TObject);
    procedure QuickSaveKeyBindingEditRightButtonClick(Sender: TObject);
    procedure SaveKeyBindingEditRightButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitializeFrame;
    procedure FinaliseFrame;
  end;

implementation

uses
  ToolsApi,
  ApplicationOptions,
  CallStackKeyboardBinding;

{$R *.dfm}

{ TOfflineCallstackOptionsFrame }

procedure TOfflineCallstackOptionsFrame.FinaliseFrame;
begin
  AppOptions.JsonFileSavePath := JsonFileSavePathEdit.Text;
  AppOptions.BaseFileName := BaseFileNameEdit.Text;
  AppOptions.RemoveUnreachableStackFrames := RemoveUnreachableStackFramesCheckbox.Checked;
end;

procedure TOfflineCallstackOptionsFrame.InitializeFrame;
begin
  JsonFileSavePathEdit.Text := AppOptions.JsonFileSavePath;
  BaseFileNameEdit.Text := AppOptions.BaseFileName;
  RemoveUnreachableStackFramesCheckbox.Checked := AppOptions.RemoveUnreachableStackFrames;
  QuickSaveKeyBindingEdit.Text := if AppOptions.QuickSaveKeyBindingEnabled then AppOptions.QuickSaveKeyBinding else '';
  SaveKeyBindingEdit.Text := if AppOptions.SaveKeyBindingEnabled then AppOptions.SaveKeyBinding else '';
  QuickSaveKeyBindingEdit.RightButton.Visible := False;
  SaveKeyBindingEdit.RightButton.Visible := False;
end;

procedure TOfflineCallstackOptionsFrame.QuickSaveKeyBindingEditChange(Sender:
    TObject);
begin
  (Sender as TButtonedEdit).RightButton.Visible := True;
end;

procedure TOfflineCallstackOptionsFrame.QuickSaveKeyBindingEditRightButtonClick(Sender: TObject);
begin
  AppOptions.QuickSaveKeyBinding := QuickSaveKeyBindingEdit.Text;

  if AppOptions.KeyBindingIndex > 0 then
    (BorlandIDEServices as IOTAKeyboardServices).RemoveKeyboardBinding(AppOptions.KeyBindingIndex);

  AppOptions.KeyBindingIndex := (BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TCallStackKeyboardBinding.Create);
  QuickSaveKeyBindingEdit.RightButton.Visible := False;
end;

procedure TOfflineCallstackOptionsFrame.SaveKeyBindingEditRightButtonClick(Sender: TObject);
begin
  AppOptions.SaveKeyBinding := SaveKeyBindingEdit.Text;

  if AppOptions.KeyBindingIndex > 0 then
    (BorlandIDEServices as IOTAKeyboardServices).RemoveKeyboardBinding(AppOptions.KeyBindingIndex);

  AppOptions.KeyBindingIndex := (BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TCallStackKeyboardBinding.Create);
  SaveKeyBindingEdit.RightButton.Visible := False;

end;

end.
