unit CallStackKeyboardBinding;

interface

uses
  ToolsAPI, System.Classes;

type
  TCallStackKeyboardBinding = class(TNotifierObject, IOTAKeyboardBinding)
  private
    function GetFileName: string;
    procedure CallStackSave(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
  protected
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
    function GetBindingType: TBindingType;
    function GetDisplayName: string;
    function GetName: string;
  end;

implementation

uses
  System.Generics.Collections,
  System.SysUtils,
  Rest.JSON,
//  System.JSON.Writers,
  System.IOUtils,
  Vcl.Dialogs,
  Vcl.Menus,
  CallStack,
  ApplicationOptions,
  FileNameCreator;

{ TCallStackKeyboardBinding }

procedure TCallStackKeyboardBinding.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
  BindingServices.AddKeyBinding([TextToShortCut('Ctrl+Alt+F8')], CallStackSave, nil);
end;

procedure TCallStackKeyboardBinding.CallStackSave(const Context: IOTAKeyContext;
  KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
var
  CurrentProc: IOTAProcess;
  TheThread: IOTAThread;
  CallCount: Integer;
  i: Integer;
  FileName: string;
  LineNumber: Integer;
  CallStackList: TObjectList<TCallStackFrame>;
  CallStackFileName: string;
begin
  CurrentProc := (BorlandIDEServices as IOTADebuggerServices).CurrentProcess;
  if Assigned(CurrentProc) then
  begin
    TheThread := CurrentProc.CurrentThread;
    if TheThread.StartCallStackAccess = csAccessible then
    begin
      CallStackList := TObjectList<TCallStackFrame>.Create;
      try
        CallCount := TheThread.CallCount;
        for i := 1 to CallCount do
        begin
           TheThread.GetCallPos(i, FileName, LineNumber);
           CallStackList.Add(TCallStackFrame.Create(TheThread.CallHeaders[i], FileName, LineNumber));
        end;
        CallStackFileName := AppOptions.JsonFileSavePath + FileNameCreator.FileName;
        TCallStackWriter.WriteCallStack(CallStackFileName, CallStackList);
      finally
        CallStackList.Free;
      end;
      TheThread.EndCallStackAccess;
    end;
    BindingResult := krHandled;
  end;
end;

function TCallStackKeyboardBinding.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

function TCallStackKeyboardBinding.GetDisplayName: string;
begin
  Result := 'Call Stack Keyboard Bingings';
end;

function TCallStackKeyboardBinding.GetFileName: string;
begin

end;

function TCallStackKeyboardBinding.GetName: string;
begin
  Result := 'CallStackKeyboardBingings';
end;

end.
