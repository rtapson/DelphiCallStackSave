unit CallStackKeyboardBinding;

interface

uses
  ToolsAPI, System.Classes;

type
  TCallStackKeyboardBinding = class(TNotifierObject, IOTAKeyboardBinding)
  private
    procedure SaveCallStack(const FileName: string);
    procedure CallStackSave(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
    procedure CallStackSaveWithName(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
  protected
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
    function GetBindingType: TBindingType;
    function GetDisplayName: string;
    function GetName: string;
  end;

implementation

uses
  System.Generics.Collections,
  Vcl.Dialogs,
  Vcl.Menus,
  CallStack,
  ApplicationOptions,
  FileNameCreator;

{ TCallStackKeyboardBinding }

procedure TCallStackKeyboardBinding.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
  BindingServices.AddKeyBinding([TextToShortCut('Ctrl+Alt+Q')], CallStackSave, nil);
  BindingServices.AddKeyBinding([TextToShortCut('Ctrl+Alt+A')], CallStackSaveWithName, nil);
end;

procedure TCallStackKeyboardBinding.CallStackSave(const Context: IOTAKeyContext;
  KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
var
  CallStackFileName: string;
begin
  CallStackFileName := FileNameCreator.FileName;
  SaveCallStack(CallStackFileName);
  BindingResult := krHandled;
end;

procedure TCallStackKeyboardBinding.CallStackSaveWithName(const Context: IOTAKeyContext; KeyCode: TShortCut;
  var BindingResult: TKeyBindingResult);
var
  CallStackFileName: string;
begin
  if InputQuery('Enter Call Stack Name', 'Call Stack Name:', CallStackFileName) then
  begin
    CallStackFileName := FileNameCreator.FileName(CallStackFileName);
    SaveCallStack(CallStackFileName);
  end;
  BindingResult := krHandled;
end;

function TCallStackKeyboardBinding.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

function TCallStackKeyboardBinding.GetDisplayName: string;
begin
  Result := 'Call Stack Keyboard Bingings';
end;

function TCallStackKeyboardBinding.GetName: string;
begin
  Result := 'CallStackKeyboardBingings';
end;

procedure TCallStackKeyboardBinding.SaveCallStack(const FileName: string);
var
  CurrentProc: IOTAProcess;
  TheThread: IOTAThread;
  CallCount: Integer;
  i: Integer;
  FrameFileName: string;
  LineNumber: Integer;
  CallStackList: TObjectList<TCallStackFrame>;
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
           TheThread.GetCallPos(i, FrameFileName, LineNumber);

           if (LineNumber = 0) and not AppOptions.RemoveUnreachableStackFrames then
           begin
               CallStackList.Add(TCallStackFrame.Create(TheThread.CallHeaders[i], FrameFileName, LineNumber));
           end
           else
           begin
               CallStackList.Add(TCallStackFrame.Create(TheThread.CallHeaders[i], FrameFileName, LineNumber));
           end;
        end;
        TCallStackWriter.WriteCallStack(FileName, CallStackList);
      finally
        CallStackList.Free;
      end;
      TheThread.EndCallStackAccess;
    end;
  end;
end;

end.
