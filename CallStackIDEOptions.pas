unit CallStackIDEOptions;

interface

uses
  ToolsAPI, IDEOptionsFrame, Vcl.Forms;

type
  TCallStackIDEOptions = class(TInterfacedObject, INTAAddInOptions)
  private
    FFrame: TOfflineCallstackOptionsFrame;
  public
    procedure DialogClosed(Accepted: Boolean);
    procedure FrameCreated(AFrame: TCustomFrame);
    function GetArea: string;
    function GetCaption: string;
    function GetFrameClass: TCustomFrameClass;
    function GetHelpContext: Integer;
    function IncludeInIDEInsight: Boolean;
    function ValidateContents: Boolean;
  end;

implementation

uses
  ApplicationOptions;

{ TCallStackIDEOptions }

procedure TCallStackIDEOptions.DialogClosed(Accepted: Boolean);
var
  JsonPath, BaseFileName: string;
begin
  if Accepted then
  begin
    FFrame.FinaliseFrame(JsonPath, BaseFileName);
    AppOptions.JsonFileSavePath := JsonPath;
    AppOptions.BaseFileName := BaseFileName;
  end;
end;

procedure TCallStackIDEOptions.FrameCreated(AFrame: TCustomFrame);
begin
  if AFrame is TOfflineCallstackOptionsFrame then
  begin
    FFrame := AFrame as TOfflineCallstackOptionsFrame;
    FFrame.InitializeFrame(AppOptions.JsonFileSavePath, AppOptions.BaseFileName);
  end;
end;

function TCallStackIDEOptions.GetArea: string;
begin
  Result := '';
end;

function TCallStackIDEOptions.GetCaption: string;
begin
  Result := 'Offline Call Stack.Options';
end;

function TCallStackIDEOptions.GetFrameClass: TCustomFrameClass;
begin
  Result := TOfflineCallstackOptionsFrame;
end;

function TCallStackIDEOptions.GetHelpContext: Integer;
begin
  Result := 0;
end;

function TCallStackIDEOptions.IncludeInIDEInsight: Boolean;
begin
  Result := True;
end;

function TCallStackIDEOptions.ValidateContents: Boolean;
begin
  Result := True;
end;

end.
