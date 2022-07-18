unit FileNameCreator;

interface

type
  IFileNameCreator = interface
    ['{88B9D136-E4FD-475A-A708-DD44182E1B45}']
    function GetFileName: string; overload;
    function GetFileName(const BaseFileName: string): string; overload;
  end;

function FileName(const BaseFileName: string = ''): string;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  ApplicationOptions;

type
  TFileNameCreator = class(TInterfacedObject, IFileNameCreator)
  public
    function GetFileName: string; overload;
    function GetFileName(const BaseFileName: string): string; overload;
  end;

function FileName(const BaseFileName: string = ''): string;
var
  FNameCreator: IFileNameCreator;
begin
  FNameCreator := TFileNameCreator.Create;
  if BaseFileName = '' then
    Result := FNameCreator.GetFileName
  else
    Result := FNameCreator.GetFileName(BaseFileName);
end;

{ TFileNameCreator }

function TFileNameCreator.GetFileName: string;
//var
//  FileCount: Integer;
begin
  Result := GetFileName(AppOptions.BaseFileName);
end;

function TFileNameCreator.GetFileName(const BaseFileName: string): string;
var
  FileCount: Integer;
begin
  FileCount := Length(TDirectory.GetFiles(AppOptions.JsonFileSavePath, '*.json'));
  if FileCount = 0 then
    Result := AppOptions.JsonFileSavePath + Format('%s.json', [BaseFileName])
  else
    Result := AppOptions.JsonFileSavePath + Format('%s (%d).json', [BaseFileName, FileCount + 1]);
end;

end.
