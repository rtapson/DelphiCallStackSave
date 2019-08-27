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
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitializeFrame(const JsonFilePath, BaseFileName: string);
    procedure FinaliseFrame(var JsonFilePath, BaseFileName: string);
  end;

implementation

{$R *.dfm}

{ TOfflineCallstackOptionsFrame }

procedure TOfflineCallstackOptionsFrame.FinaliseFrame(var JsonFilePath, BaseFileName: string);
begin
  JsonFilePath := JsonFileSavePathEdit.Text;
  BaseFileName := BaseFileNameEdit.Text;
end;

procedure TOfflineCallstackOptionsFrame.InitializeFrame(const JsonFilePath, BaseFileName: string);
begin
  JsonFileSavePathEdit.Text := JsonFilePath;
  BaseFileNameEdit.Text := BaseFileName;
end;

end.
