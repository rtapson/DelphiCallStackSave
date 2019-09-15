unit OfflineCallStackForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DockToolForm,
  CallStackFrame,
    Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.VirtualImageList;

type
  TOfflineCallStack = class(TDockableToolbarForm)
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOfflineCallStackFrame: TOfflineCallStackFrame;
    procedure CreateToolbarButtons;
    procedure AddToolbarButton(Action: TAction);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Focus;

    class procedure CreateDockableOfflineCallStack;
    class procedure RemoveDockableOfflineCallStack;
    class procedure ShowDockableOfflineCallStack;
    //class Procedure RenderDocumentTree(BaseLanguageModule : TBaseLanguageModule);
    class Procedure HookEventHandlers(SelectionChangeProc : TSelectionChange;
        Focus, ScopeChange : TNotifyEvent);
  end;

  TOfflineCallStackClass = class of TOfflineCallStack;

implementation

{$R *.dfm}

uses
  DeskUtil,
  Vcl.ComCtrls;

var
  FormInstance: TOfflineCallStack;

procedure RegisterDockableForm(FormClass: TOfflineCallStackClass; var FormVar;
  const FormName: string);
begin
  If @RegisterFieldAddress <> Nil Then
    RegisterFieldAddress(FormName, @FormVar);
  RegisterDesktopFormClass(FormClass, FormName, FormName);
end;

procedure UnRegisterDockableForm(var FormVar; const FormName: string);
begin
  if @UnRegisterFieldAddress <> nil Then
    UnRegisterFieldAddress(@FormVar);
end;

procedure CreateDockableForm(var FormVar: TOfflineCallStack;
  FormClass: TOfflineCallStackClass);
begin
  TCustomForm(FormVar) := FormClass.Create(nil);
  RegisterDockableForm(FormClass, FormVar, TCustomForm(FormVar).Name);
end;

procedure FreeDockableForm(var FormVar: TOfflineCallStack);
begin
  if Assigned(FormVar) then
  begin
    UnRegisterDockableForm(FormVar, FormVar.Name);
    FreeAndNil(FormVar);
  end;
end;

procedure ShowDockableForm(Form: TOfflineCallStack);
begin
  if not Assigned(Form) then
    Exit;
  if not Form.Floating then
  begin
    Form.ForceShow;
    FocusWindow(Form);
    Form.Focus;
  end
  else
  begin
    Form.Show;
    Form.Focus;
  end;
End;

{ TOfflineCallStack }

procedure TOfflineCallStack.AddToolbarButton(Action: TAction);
var
  Button: TToolButton;
  lastbtnidx: integer;
begin
  Button := TToolButton.Create(Toolbar);
  Button.Action := Action;
  lastbtnidx := Toolbar.ButtonCount - 1;
  if lastbtnidx > -1 then
    Button.Left := Toolbar.Buttons[lastbtnidx].Left + Toolbar.Buttons[lastbtnidx].Width
  else
    Button.Left := 0;
  Button.Parent := Toolbar;
end;

constructor TOfflineCallStack.Create(AOwner: TComponent);
begin
  inherited;
  DeskSection := Name;
  AutoSave := True;
  SaveStateNecessary := True;
  FOfflineCallStackFrame := TOfflineCallStackFrame.Create(Self);
  FOfflineCallStackFrame.Parent := Self;
end;

class procedure TOfflineCallStack.CreateDockableOfflineCallStack;
begin
  if not Assigned(FormInstance) then
    CreateDockableForm(FormInstance, TOfflineCallStack);
end;

procedure TOfflineCallStack.CreateToolbarButtons;
var
  Action, RefreshAction: TAction;
begin
  ToolBar.Images := VirtualImageList1;
  ToolActionList.Images := VirtualImageList1;
  //ShowCaptions := True;
  Action := TAction.Create(ToolActionList);
  Action.ImageIndex := 0;
  Action.Name := 'LoadCallStackAction';
  Action.Caption := 'Load Call Stack';
  //Action.OnExecute := FOfflineCallStackFrame.LoadCallStackExecute;
  Action.ActionList := ToolActionList;
  AddToolbarButton(Action);

  RefreshAction := TAction.Create(ToolActionList);
  RefreshAction.ImageIndex := 1;
  RefreshAction.Name := 'RefreshCallStackAction';
  RefreshAction.Caption := 'Refresh';
  RefreshAction.OnExecute := FOfflineCallStackFrame.RefreshStackFiles;
  RefreshAction.ActionList := ToolActionList;
  AddToolbarButton(RefreshAction);

end;

destructor TOfflineCallStack.Destroy;
begin
  SaveStateNecessary := True;
  inherited;
end;

procedure TOfflineCallStack.Focus;
begin
  if Assigned(FOfflineCallStackFrame) and (FOfflineCallStackFrame.Visible) then
  begin
     FOfflineCallStackFrame.SetFocus;
     FOfflineCallStackFrame.RefreshStackFiles(Self);
  end;
end;

procedure TOfflineCallStack.FormCreate(Sender: TObject);
begin
  CreateToolbarButtons;
  FOfflineCallStackFrame.LoadCallStackData;
end;

class procedure TOfflineCallStack.HookEventHandlers(SelectionChangeProc : TSelectionChange;
  Focus, ScopeChange: TNotifyEvent);
begin
  if Assigned(FormInstance) then
  begin
    FormInstance.FOfflineCallStackFrame.OnSelectionChange := SelectionChangeProc;
    FormInstance.FOfflineCallStackFrame.OnFocus := Focus;
    FormInstance.FOfflineCallStackFrame.OnOptionsChange := ScopeChange;
  end;
end;

class procedure TOfflineCallStack.RemoveDockableOfflineCallStack;
begin
  FreeDockableForm(FormInstance);
end;

class procedure TOfflineCallStack.ShowDockableOfflineCallStack;
begin
  CreateDockableOfflineCallStack;
  ShowDockableForm(FormInstance);
end;

end.
