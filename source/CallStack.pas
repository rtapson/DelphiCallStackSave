unit CallStack;

interface

uses
  System.Generics.Collections;

type
  TCallStackFrame = class
  private
    FHeader: string;
    FFileName: string;
    FLineNumber: Integer;
  public
    constructor Create(const Header, FileName : string; const LineNumber: Integer);
    property Header: string read FHeader write FHeader;
    property FileName: string read FFileName write FFileName;
    property LineNumber: Integer read FLineNumber write FLineNumber;
  end;

  TCallStackWriter = class
  private
    class procedure EnsurePathExists(const FileName: string);
  public
    class procedure WriteCallStack(const FileName: string; const CallStack: TObjectList<TCallStackFrame>);
  end;

  TCallStackReader = class  
  public
    class procedure ReadCallStack(const FileName: string; const CallStack: TObjectList<TCallStackFrame>);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.JSON,
  System.JSON.Builders,
  System.JSON.Writers,
  System.JSON.Readers,
  System.JSON.Types;

{ TCallStack }

constructor TCallStackFrame.Create(const Header, FileName: string;
  const LineNumber: Integer);
begin
  FHeader := Header;
  FFileName := FileName;
  FLineNumber := LineNumber;
end;

{ TCallStackReader }

class procedure TCallStackReader.ReadCallStack(const FileName: string; const CallStack: TObjectList<TCallStackFrame>);
var
  StringReader: TStringReader;
  JsonReader: TJsonTextReader;

  JsonString, Header, ModuleFileName: string;
  LineNumber: Integer;
  CallStackFrame: TCallStackFrame;
begin
  if FileName = '' then Exit;
  try
    JsonString := TFile.ReadAllText(FileName);
  except
    Exit;
  end;
  CallStack.Clear;
  
  StringReader := TStringReader.Create(JsonString);
  try
    JsonReader := TJsonTextReader.Create(StringReader);
    try
      while JsonReader.Read do
      begin
        if JsonReader.TokenType = TJsonToken.StartObject then
        begin
          while JsonReader.Read do 
          begin
            if JsonReader.TokenType = TJsonToken.PropertyName then
            begin
              if JsonReader.Value.ToString = 'header' then
              begin
                JsonReader.Read;
                Header := JsonReader.Value.ToString
              end
              else if JsonReader.Value.ToString = 'fileName' then
              begin
                JsonReader.Read;
                ModuleFileName := JsonReader.Value.ToString
              end
              else if JsonReader.Value.ToString = 'lineNumber' then
              begin
                JsonReader.Read;
                LineNumber := JsonReader.Value.AsInteger;
              end;          
            end
            else if JsonReader.TokenType = TJsonToken.EndObject then     
            begin
              if Header <> '' then            
                CallStack.Add(TCallStackFrame.Create(Header, ModuleFileName, LineNumber));
            end;
          end;
        end;
      end;    
    finally
      JsonReader.Free;
    end;    
  finally
    StringReader.Free;
  end;
end;

{ TCallStackWriter }

class procedure TCallStackWriter.EnsurePathExists(const FileName: string);
var
  Path: string;
begin
  Path := ExtractFilePath(FileName);
  if not TDirectory.Exists(Path) then
    TDirectory.CreateDirectory(Path);
end;

class procedure TCallStackWriter.WriteCallStack(const FileName: string; const CallStack: TObjectList<TCallStackFrame>);
var
  CallStackFrame: TCallStackFrame;
  Builder: TJsonObjectBuilder;
  StringWriter: TStringWriter;
  MyTextWriter: TJsonTextWriter;

  Temp: TJSONCollectionBuilder.TElements;
begin
  EnsurePathExists(FileName);
  StringWriter := TStringWriter.Create;
  MyTextWriter := TJsonTextWriter.Create(StringWriter);
  Builder := TJsonObjectBuilder.Create(MyTextWriter);
  try
    MyTextWriter.Formatting := TJsonFormatting.Indented;

    Temp := Builder
      .BeginObject
        .BeginArray('callStackFrames');

        for CallStackFrame in CallStack do
        begin     
          Temp.BeginObject
            .Add('header', CallStackFrame.Header)
            .Add('fileName', CallStackFrame.FileName)
            .Add('lineNumber', CallStackFrame.LineNumber)
            .EndObject;
        end;
        
        Temp.EndArray
      .EndObject;
      TFile.WriteAllText(FileName, StringWriter.ToString);   
  finally
    Builder.Free;
  end;
end;

end.
