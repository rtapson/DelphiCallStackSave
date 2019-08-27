unit CallStackSaver;

interface

uses
  ToolsAPI;

type
  TCallStackSaver = class(TInterfacedObject, IOTAThread50)
  public
    function AddNotifier(const Notifier: IOTAThreadNotifier): Integer;
    function Evaluate(const ExprStr: string; ResultStr: PWideChar;
      ResultStrSize: Cardinal; out CanModify: Boolean;
      AllowSideEffects: Boolean; FormatSpecifiers: PAnsiChar;
      out ResultAddr: Cardinal; out ResultSize: Cardinal;
      out ResultVal: Cardinal): TOTAEvaluateResult;
    function GetCallCount: Integer;
    function GetCallHeader(Index: Integer): string;
    procedure GetCallPos(Index: Integer; out FileName: string;
      out LineNum: Integer);
    function GetContext: _CONTEXT;
    function GetCurrentFile: string;
    function GetCurrentLine: Cardinal;
    function GetHandle: NativeUInt;
    function GetOSThreadID: Cardinal;
    function GetState: TOTAThreadState;
    function Modify(const ValueStr: string; ResultStr: PWideChar;
      ResultSize: Cardinal; out ResultVal: Integer): TOTAEvaluateResult;
    procedure RemoveNotifier(Index: Integer);
  end;

implementation

{ TCallStackSaver }

function TCallStackSaver.AddNotifier(const Notifier: IOTAThreadNotifier): Integer;
begin

end;

function TCallStackSaver.Evaluate(const ExprStr: string; ResultStr: PWideChar;
  ResultStrSize: Cardinal; out CanModify: Boolean; AllowSideEffects: Boolean;
  FormatSpecifiers: PAnsiChar; out ResultAddr, ResultSize,
  ResultVal: Cardinal): TOTAEvaluateResult;
begin

end;

function TCallStackSaver.GetCallCount: Integer;
begin

end;

function TCallStackSaver.GetCallHeader(Index: Integer): string;
begin

end;

procedure TCallStackSaver.GetCallPos(Index: Integer; out FileName: string; out LineNum: Integer);
var
  CurrentProc: IOTAProcess;
begin
  CurrentProc := (BorlandIDEServices as IOTADebuggerServices).CurrentProcess;
  CurrentProc.CurrentThread
end;

function TCallStackSaver.GetContext: _CONTEXT;
begin

end;

function TCallStackSaver.GetCurrentFile: string;
begin

end;

function TCallStackSaver.GetCurrentLine: Cardinal;
begin

end;

function TCallStackSaver.GetHandle: NativeUInt;
begin

end;

function TCallStackSaver.GetOSThreadID: Cardinal;
begin

end;

function TCallStackSaver.GetState: TOTAThreadState;
begin

end;

function TCallStackSaver.Modify(const ValueStr: string; ResultStr: PWideChar;
  ResultSize: Cardinal; out ResultVal: Integer): TOTAEvaluateResult;
begin

end;

procedure TCallStackSaver.RemoveNotifier(Index: Integer);
begin

end;

end.
