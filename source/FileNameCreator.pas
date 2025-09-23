unit FileNameCreator;

interface

type
  TFileNameCreator = class
  public
    class function FileName: string;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  ApplicationOptions;

{ TFileNameCreator }

class function TFileNameCreator.FileName: string;
var
  FileCount: Integer;
begin
  FileCount := Length(TDirectory.GetFiles(AppOptions.JsonFileSavePath, '*.json'));
  if FileCount = 0 then
    Result := AppOptions.JsonFileSavePath + Format('%s.json', [AppOptions.BaseFileName])
  else
    Result := AppOptions.JsonFileSavePath + Format('%s (%d).json', [AppOptions.BaseFileName, FileCount + 1]);
end;

end.
