unit ApplicationOptions;

interface

type
  IOfflineCallStackOptions = interface
    ['{3A7D75A7-7EFC-4186-A5C2-0A876BDA6D6C}']
    function GetJsonFileSavePath: string;
    procedure SetJsonFileSavePath(const Value: string);
    function GetBaseFileName: string;
    procedure SetBaseFileName(const Value: string);

    property JsonFileSavePath: string read GetJsonFileSavePath write SetJsonFileSavePath;
    property BaseFileName: string read GetBaseFileName write SetBaseFileName;
  end;

function AppOptions: IOfflineCallStackOptions;

implementation

uses
  Registry,
  System.SysUtils;

var
  FAppOptions: IOfflineCallStackOptions;

const
  //This constant represents the registry key the auto save settings are stored under.
  strRegistryKey = 'Software\TapperMedia\OfflineCallStack\';
  strIniSection = 'Settings';
  strJsonFilePath = 'JsonFileSavePath';
  strBaseFileName = 'BaseFileName';

type
  TApplicationOptions = class(TInterfacedObject, IOfflineCallStackOptions)
  private
    FJsonFileSavePath: string;
    FBaseFileName: string;
    function GetJsonFileSavePath: string;
    procedure SetJsonFileSavePath(const Value: string);
    function GetBaseFileName: string;
    procedure SetBaseFileName(const Value: string);
  protected
    procedure LoadSettings;
    procedure SaveSettings;
  public
    constructor Create;
    destructor Destroy; override;

    property JsonFileSavePath: string read GetJsonFileSavePath write SetJsonFileSavePath;
    property BaseFileName: string read GetBaseFileName write SetBaseFileName;
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

procedure TApplicationOptions.LoadSettings;
var
  reg: TRegIniFile;
begin
  reg := TRegIniFile.Create();
  try
    FJsonFileSavePath := reg.ReadString(strRegistryKey + strIniSection, strJsonFilePath, '');
    FBaseFileName := reg.ReadString(strRegistryKey + strIniSection, strBaseFileName, 'CallStack');
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

initialization
  if not Assigned(FAppOptions) then
    FAppOptions := TApplicationOptions.Create;

finalization

end.
