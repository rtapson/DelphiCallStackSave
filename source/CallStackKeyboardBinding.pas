unit CallStackKeyboardBinding;

interface

uses
  ToolsAPI, System.Classes;

type
  TCallStackKeyboardBinding = class(TNotifierObject, IOTAKeyboardBinding)
  private
    procedure BuildFileName(var BindingResult: TKeyBindingResult);
    procedure SaveCallStack();
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
  SysUtils,
  Vcl.Dialogs,
  Vcl.Menus,
  CallStack,
  ApplicationOptions,
  FileNameCreator;

{ TCallStackKeyboardBinding }

procedure TCallStackKeyboardBinding.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
  AppOptions.QuickSaveKeyBindingEnabled := BindingServices.AddKeyBinding([TextToShortCut(AppOptions.QuickSaveKeyBinding)], CallStackSave, nil);
  AppOptions.SaveKeyBindingEnabled := BindingServices.AddKeyBinding([TextToShortCut(AppOptions.SaveKeyBinding)], CallStackSaveWithName, nil);
end;

procedure TCallStackKeyboardBinding.BuildFileName(var BindingResult: TKeyBindingResult);
var
  CallStackFileName: string;
begin
  if InputQuery('Enter Call Stack Name', 'Call Stack Name:', CallStackFileName) then
  begin
    if not CallStackFileName.IsEmpty then
      AppOptions.BaseFileName := CallStackFileName;
  end;
end;

procedure TCallStackKeyboardBinding.CallStackSave(const Context: IOTAKeyContext;
  KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
begin
  if AppOptions.BaseFileName.IsEmpty then
  begin
    BuildFileName(BindingResult);
  end;
  SaveCallStack();
  BindingResult := krHandled;
end;

procedure TCallStackKeyboardBinding.CallStackSaveWithName(const Context: IOTAKeyContext; KeyCode: TShortCut;
  var BindingResult: TKeyBindingResult);
begin
  BuildFileName(BindingResult);
  SaveCallStack();
  BindingResult := krHandled;
end;

function TCallStackKeyboardBinding.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

function TCallStackKeyboardBinding.GetDisplayName: string;
begin
  Result := 'Save Call Stack Commands';
end;

function TCallStackKeyboardBinding.GetName: string;
begin
  Result := 'CallStackKeyboardBingings';
end;

procedure TCallStackKeyboardBinding.SaveCallStack();
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
        TCallStackWriter.WriteCallStack(TFileNameCreator.FileName, CallStackList);
      finally
        CallStackList.Free;
      end;
      TheThread.EndCallStackAccess;
    end;
  end;
end;

end.


