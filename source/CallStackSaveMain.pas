unit CallStackSaveMain;

interface

uses
  ToolsAPI, CallStackIDEOptions;

type
  TCallStackSaveExpert = class(TInterfacedObject, IOTAWizard)
  private
    FOptionsFrame: TCallStackIDEOptions;

    procedure OfflineCallStackClick(Sender: TObject);

    procedure SelectionChanged(const FileName: string; const LineNumber: Integer);
    procedure Focus(Sender: TObject);
    procedure OptionsChange(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;



    procedure Execute;
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Modified;
  end;

procedure Register;

implementation

uses
  Vcl.Forms,
  CallStackKeyboardBinding,
  OfflineCallStackForm,
  CallStackFrame;

Var
  iWizard : Integer = 0;
  iKeyboardBindingIndex : Integer = 0;

function InitialiseWizard(BIDES : IBorlandIDEServices) : TCallStackSaveExpert;
begin
  Result := TCallStackSaveExpert.Create;
  Application.Handle := (BIDES As IOTAServices).GetParentHandle;
  TOfflineCallStack.CreateDockableOfflineCallStack;
  TOfflineCallStack.HookEventHandlers(Result.SelectionChanged, Result.Focus, Result.OptionsChange);
end;

function InitWizard(Const BorlandIDEServices : IBorlandIDEServices;
  RegisterProc : TWizardRegisterProc;
  Var Terminate : TWizardTerminateProc) : Boolean; StdCall;
begin
  Result := BorlandIDEServices <> Nil;
  RegisterProc(InitialiseWizard(BorlandIDEServices));
end;

{ TCallStackSaveExpert }

procedure TCallStackSaveExpert.AfterSave;
begin

end;

procedure TCallStackSaveExpert.BeforeSave;
begin

end;

constructor TCallStackSaveExpert.Create;
begin
  inherited Create;
  FOptionsFrame := TCallStackIDEOptions.Create;
  (BorlandIDEServices as INTAEnvironmentOptionsServices).RegisterAddInOptions(FOptionsFrame);
end;

destructor TCallStackSaveExpert.Destroy;
begin
  (BorlandIDEServices as INTAEnvironmentOptionsServices).UnregisterAddInOptions(FOptionsFrame);
  FOptionsFrame := nil;
  TOfflineCallStack.RemoveDockableOfflineCallStack;
  inherited;
end;

procedure TCallStackSaveExpert.Destroyed;
begin

end;

procedure TCallStackSaveExpert.Execute;
begin

end;

procedure TCallStackSaveExpert.Focus(Sender: TObject);
begin
  (Sender as TOfflineCallStackFrame).LoadCallStackData;
end;

function TCallStackSaveExpert.GetIDString: string;
begin
  Result := 'TapperMedia.CallStackSave';
end;

function TCallStackSaveExpert.GetName: string;
begin
  Result := 'Call Stack Save';
end;

function TCallStackSaveExpert.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure TCallStackSaveExpert.Modified;
begin

end;

procedure TCallStackSaveExpert.OfflineCallStackClick(Sender: TObject);
begin
  TOfflineCallStack.ShowDockableOfflineCallStack;
end;

procedure TCallStackSaveExpert.OptionsChange(Sender: TObject);
begin

end;

procedure TCallStackSaveExpert.SelectionChanged(const FileName: string; const LineNumber: Integer);
begin

end;

procedure Register;
begin
  iWizard := (BorlandIDEServices as IOTAWizardServices).AddWizard(InitialiseWizard(BorlandIDEServices));
  iKeyboardBindingIndex := (BorlandIDEServices as IOTAKeyboardServices).AddKeyboardBinding(TCallStackKeyboardBinding.Create);
end;

initialization

finalization
  if iKeyboardBindingIndex > 0 then
    (BorlandIDEServices as IOTAKeyboardServices).RemoveKeyboardBinding(iKeyboardBindingIndex);

  if iWizard > 0 then
    (BorlandIDEServices as IOTAWizardServices).RemoveWizard(iWizard);

end.
