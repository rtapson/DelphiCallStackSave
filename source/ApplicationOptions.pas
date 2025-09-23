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
    function GetQuickSaveKeyBinding: string;
    function GetSaveKeyBinding: string;
    procedure SetQuickSaveKeyBinding(const Value: string);
    procedure SetSaveKeyBinding(const Value: string);
    function GetQuickSaveKeyBindingEnabled: Boolean;
    function GetSaveKeyBindingEnabled: Boolean;
    procedure SetQuickSaveKeyBindingEnabled(const Value: Boolean);
    procedure SetSaveKeyBindingEnabled(const Value: Boolean);
    function GetKeyBindingIndex: Integer;
    procedure SetKeyBindingIndex(const Value: Integer);

    property JsonFileSavePath: string read GetJsonFileSavePath write SetJsonFileSavePath;
    property BaseFileName: string read GetBaseFileName write SetBaseFileName;
    property RemoveUnreachableStackFrames: Boolean read GetRemoveUnreachableStackFrames write SetRemoveUnreachableStackFrames;
    property QuickSaveKeyBinding: string read GetQuickSaveKeyBinding write SetQuickSaveKeyBinding;
    property SaveKeyBinding: string read GetSaveKeyBinding write SetSaveKeyBinding;
    property QuickSaveKeyBindingEnabled: Boolean read GetQuickSaveKeyBindingEnabled write SetQuickSaveKeyBindingEnabled;
    property SaveKeyBindingEnabled: Boolean read GetSaveKeyBindingEnabled write SetSaveKeyBindingEnabled;

    //Not Saved
    property KeyBindingIndex: Integer read GetKeyBindingIndex write SetKeyBindingIndex;
  end;

function AppOptions: IOfflineCallStackOptions;

implementation

uses
  Registry,
  System.SysUtils, System.Classes, Vcl.Menus;

var
  FAppOptions: IOfflineCallStackOptions;

const
  CONST_RegistryKey = 'Software\TapperMedia\OfflineCallStack\';
  CONST_IniSection = 'Settings';
  CONST_Section =  CONST_RegistryKey + CONST_IniSection;
  CONST_JsonFilePath = 'JsonFileSavePath';
  CONST_BaseFileName = 'BaseFileName';
  CONST_RemUnreachableStackFrames = 'RemoveUnreachableStackFrames';
  CONST_QuickSaveKeyBinding = 'QuickSaveKeyBinding';
  CONST_SaveKeyBinding = 'SaveKeyBinding';

type
  TApplicationOptions = class(TInterfacedObject, IOfflineCallStackOptions)
  private
    FJsonFileSavePath: string;
    FBaseFileName: string;
    FRemoveUnreachableStackFrames: Boolean;
    FQuickSaveKeyBinding: string;
    FSaveKeyBinding: string;

    FQuickSaveKeyBindingEnabled: Boolean;
    FSaveKeyBindingEnabled: Boolean;
    FKeyBindingIndex: Integer;

    function GetJsonFileSavePath: string;
    procedure SetJsonFileSavePath(const Value: string);
    function GetBaseFileName: string;
    procedure SetBaseFileName(const Value: string);
    function GetRemoveUnreachableStackFrames: Boolean;
    procedure SetRemoveUnreachableStackFrames(const Value: Boolean);
    function GetQuickSaveKeyBinding: string;
    function GetSaveKeyBinding: string;
    procedure SetQuickSaveKeyBinding(const Value: string);
    procedure SetSaveKeyBinding(const Value: string);
    function GetQuickSaveKeyBindingEnabled: Boolean;
    function GetSaveKeyBindingEnabled: Boolean;
    procedure SetQuickSaveKeyBindingEnabled(const Value: Boolean);
    procedure SetSaveKeyBindingEnabled(const Value: Boolean);
    function GetKeyBindingIndex: Integer;
    procedure SetKeyBindingIndex(const Value: Integer);
  protected
    procedure LoadSettings;
    procedure SaveSettings;
  public
    constructor Create;
    destructor Destroy; override;

    property JsonFileSavePath: string read GetJsonFileSavePath write SetJsonFileSavePath;
    property BaseFileName: string read GetBaseFileName write SetBaseFileName;
    property RemoveUnreachableStackFrames: Boolean read GetRemoveUnreachableStackFrames write SetRemoveUnreachableStackFrames;
    property QuickSaveKeyBinding: string read GetQuickSaveKeyBinding write SetQuickSaveKeyBinding;
    property SaveKeyBinding: string read GetSaveKeyBinding write SetSaveKeyBinding;
    property QuickSaveKeyBindingEnabled: Boolean read GetQuickSaveKeyBindingEnabled write SetQuickSaveKeyBindingEnabled;
    property SaveKeyBindingEnabled: Boolean read GetSaveKeyBindingEnabled write SetSaveKeyBindingEnabled;
    property KeybindingIndex: Integer read GetKeyBindingIndex write SetKeyBindingIndex;
  end;

function AppOptions: IOfflineCallStackOptions;
begin
  Result := FAppOptions;
end;

{ TApplicationOptions }

constructor TApplicationOptions.Create;
begin
  FKeyBindingIndex := 0;
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

function TApplicationOptions.GetKeyBindingIndex: Integer;
begin
  Result := FKeyBindingIndex;
end;

function TApplicationOptions.GetQuickSaveKeyBinding: string;
begin
  Result := FQuickSaveKeyBinding;
end;

function TApplicationOptions.GetQuickSaveKeyBindingEnabled: Boolean;
begin
  Result := FQuickSaveKeyBindingEnabled;
end;

function TApplicationOptions.GetRemoveUnreachableStackFrames: Boolean;
begin
  Result := FRemoveUnreachableStackFrames;
end;

function TApplicationOptions.GetSaveKeyBinding: string;
begin
  Result := FSaveKeyBinding;
end;

function TApplicationOptions.GetSaveKeyBindingEnabled: Boolean;
begin
  Result := FSaveKeyBindingEnabled;
end;

procedure TApplicationOptions.LoadSettings;
var
  reg: TRegIniFile;
begin
  reg := TRegIniFile.Create();
  try
    FJsonFileSavePath := reg.ReadString(CONST_Section, CONST_JsonFilePath, '');
    FBaseFileName := reg.ReadString(CONST_Section, CONST_BaseFileName, 'CallStack');
    FRemoveUnreachableStackFrames := reg.ReadBool(CONST_Section, CONST_RemUnreachableStackFrames, False);
    FQuickSaveKeyBinding := reg.ReadString(CONST_Section,  CONST_QuickSaveKeyBinding, 'Ctrl+Alt+Q');
    FSaveKeyBinding := reg.ReadString(CONST_Section, CONST_SaveKeyBinding, 'Ctrl+Alt+A');
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
    reg.WriteString(CONST_Section, CONST_JsonFilePath, FJsonFileSavePath);
    reg.WriteString(CONST_Section, CONST_BaseFileName, FBaseFileName);
    reg.WriteBool(CONST_Section, CONST_RemUnreachableStackFrames, FRemoveUnreachableStackFrames);
    reg.WriteString(CONST_Section, CONST_QuickSaveKeyBinding, FQuickSaveKeyBinding);
    reg.WriteString(CONST_Section, CONST_SaveKeyBinding, FSaveKeyBinding);
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

procedure TApplicationOptions.SetKeyBindingIndex(const Value: Integer);
begin
  FKeyBindingIndex := Value;
end;

procedure TApplicationOptions.SetQuickSaveKeyBinding(const Value: string);
begin
  FQuickSaveKeyBinding := Value;
end;

procedure TApplicationOptions.SetQuickSaveKeyBindingEnabled(const Value: Boolean);
begin
  FQuickSaveKeyBindingEnabled := Value;
end;

procedure TApplicationOptions.SetRemoveUnreachableStackFrames(const Value: Boolean);
begin
  FRemoveUnreachableStackFrames := Value;
end;

procedure TApplicationOptions.SetSaveKeyBinding(const Value: string);
begin
  FSaveKeyBinding := Value;
end;

procedure TApplicationOptions.SetSaveKeyBindingEnabled(const Value: Boolean);
begin
  FSaveKeyBindingEnabled := Value;
end;

initialization
  if not Assigned(FAppOptions) then
    FAppOptions := TApplicationOptions.Create;

finalization

end.
