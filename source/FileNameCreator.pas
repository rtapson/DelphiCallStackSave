unit FileNameCreator;

interface

type
  IFileNameCreator = interface
    ['{88B9D136-E4FD-475A-A708-DD44182E1B45}']
    function GetFileName: string;
  end;

function FileName: string;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  ApplicationOptions;

type
  TFileNameCreator = class(TInterfacedObject, IFileNameCreator)
  public
    function GetFileName: string;
  end;

function FileName: string;
var
  FNameCreator: IFileNameCreator;
begin
  FNameCreator := TFileNameCreator.Create;
  Result := FNameCreator.GetFileName;
end;

{ TFileNameCreator }

function TFileNameCreator.GetFileName: string;
var
  FileCount: Integer;
begin
  FileCount := Length(TDirectory.GetFiles(AppOptions.JsonFileSavePath, '*.json'));
  if FileCount = 0 then
    Result := Format('%s.json', [AppOptions.BaseFileName])
  else
    Result := Format('%s (%d).json', [AppOptions.BaseFileName, FileCount + 1]);
end;

end.
