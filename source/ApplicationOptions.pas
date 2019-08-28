unit ApplicationOptions;

interface

type
  IOfflineCallStackOptions = interface
    ['{3A7D75A7-7EFC-4186-A5C2-0A876BDA6D6C}']
    function GetJsonFileSavePath: string;
    procedure SetJsonFileSavePath(const Value: string);
    function GetBaseFileName: string;
    procedure SetBaseFileName(const Value: string);
    function GetRemoveUnreachableStackFrames: Boolean;
    procedure SetRemoveUnreachableStackFrames(const Value: Boolean);

    property JsonFileSavePath: string read GetJsonFileSavePath write SetJsonFileSavePath;
    property BaseFileName: string read GetBaseFileName write SetBaseFileName;
    property RemoveUnreachableStackFrames: Boolean read GetRemoveUnreachableStackFrames write SetRemoveUnreachableStackFrames;
  end;

function AppOptions: IOfflineCallStackOptions;

implementation

uses
  Registry,
  System.SysUtils;

var
  FAppOptions: IOfflineCallStackOptions;

const
  strRegistryKey = 'Software\TapperMedia\OfflineCallStack\';
  strIniSection = 'Settings';
  strJsonFilePath = 'JsonFileSavePath';
  strBaseFileName = 'BaseFileName';
  strRemoveUnreachableStackFrames = 'RemoveUnreachableStackFrames';

type
  TApplicationOptions = class(TInterfacedObject, IOfflineCallStackOptions)
  private
    FJsonFileSavePath: string;
    FBaseFileName: string;
    FRemoveUnreachableStackFrames: Boolean;
    function GetJsonFileSavePath: string;
    procedure SetJsonFileSavePath(const Value: string);
    function GetBaseFileName: string;
    procedure SetBaseFileName(const Value: string);
    function GetRemoveUnreachableStackFrames: Boolean;
    procedure SetRemoveUnreachableStackFrames(const Value: Boolean);
  protected
    procedure LoadSettings;
    procedure SaveSettings;
  public
    constructor Create;
    destructor Destroy; override;

    property JsonFileSavePath: string read GetJsonFileSavePath write SetJsonFileSavePath;
    property BaseFileName: string read GetBaseFileName write SetBaseFileName;
    property RemoveUnreachableStackFrames: Boolean read GetRemoveUnreachableStackFrames write SetRemoveUnreachableStackFrames;
  end;

function AppOptions: IOfflineCallStackOptions;
begin
  Result := FAppOptions;
end;

{ TApplicationOptions }

constructor TApplicationOptions.Create;
begin
  LoadSettings;
end;

destructor TApplicationOptions.Destroy;
begin
  SaveSettings;
  inherited;
end;

function TApplicationOptions.GetBaseFileName: string;
begin
  Result := FBaseFileName;
end;

function TApplicationOptions.GetJsonFileSavePath: string;
begin
  Result := IncludeTrailingPathDelimiter(FJsonFileSavePath);
end;

function TApplicationOptions.GetRemoveUnreachableStackFrames: Boolean;
begin
  Result := FRemoveUnreachableStackFrames;
end;

procedure TApplicationOptions.LoadSettings;
var
  reg: TRegIniFile;
begin
  reg := TRegIniFile.Create();
  try
    FJsonFileSavePath := reg.ReadString(strRegistryKey + strIniSection, strJsonFilePath, '');
    FBaseFileName := reg.ReadString(strRegistryKey + strIniSection, strBaseFileName, 'CallStack');
    FRemoveUnreachableStackFrames := reg.ReadBool(strRegistryKey + strIniSection, strRemoveUnreachableStackFrames, False);
  finally
    reg.Free;
  end;
end;

procedure TApplicationOptions.SaveSettings;
var
  reg: TRegIniFile;
begin
  reg := TRegIniFile.Create();
  try
    reg.WriteString(strRegistryKey + strIniSection, strJsonFilePath, FJsonFileSavePath);
    reg.WriteString(strRegistryKey + strIniSection, strBaseFileName, FBaseFileName);
    reg.WriteBool(strRegistryKey + strIniSection, strRemoveUnreachableStackFrames, FRemoveUnreachableStackFrames);
  finally
    reg.Free;
  end;
end;

procedure TApplicationOptions.SetBaseFileName(const Value: string);
begin
  FBaseFileName := Value;
end;

procedure TApplicationOptions.SetJsonFileSavePath(const Value: string);
begin
  FJsonFileSavePath := Value;
end;

procedure TApplicationOptions.SetRemoveUnreachableStackFrames(const Value: Boolean);
begin
  FRemoveUnreachableStackFrames := Value;
end;

initialization
  if not Assigned(FAppOptions) then
    FAppOptions := TApplicationOptions.Create;

finalization

end.
