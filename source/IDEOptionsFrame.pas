unit IDEOptionsFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TOfflineCallstackOptionsFrame = class(TFrame)
    JsonFileSavePathEdit: TButtonedEdit;
    JsonFileSavePathLabel: TLabel;
    Label1: TLabel;
    BaseFileNameEdit: TEdit;
    RemoveUnreachableStackFramesCheckbox: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitializeFrame;
    procedure FinaliseFrame;
  end;

implementation

uses
  ApplicationOptions;

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
end;

end.
