unit CallStackFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Generics.Collections,
  CallStack;

type
  TSelectionChange = procedure(const FileName: string; const LineNumber: Integer) of object;

  TOfflineCallStackFrame = class(TFrame)
    CallStackListBox: TListBox;
    CallStackFilesDropdown: TComboBoxEx;
    procedure CallStackFilesDropdownChange(Sender: TObject);
    procedure CallStackListBoxDblClick(Sender: TObject);
    procedure CallStackListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FrameEnter(Sender: TObject);
  private
    FOnSelectionChange: TSelectionChange;
    FOnFocus: TNotifyEvent;
    FOnOptionsChange: TNotifyEvent;
    FCallStack: TObjectList<TCallStackFrame>;

    procedure AddCallStackFilesToDropdown;
    procedure OpenInIDEEditor(const EditorFileName: string; const LineNumber: Integer);
  public
    { Public declarations }
    procedure LoadCallStackData;
    procedure LoadCallStackExecute(Sender: TObject);
    procedure RefreshStackFiles(Sender: TObject);
    procedure RefreshData;

    property OnSelectionChange: TSelectionChange read FOnSelectionChange write FOnSelectionChange;
    property OnFocus: TNotifyEvent read FOnFocus write FOnFocus;
    property OnOptionsChange: TNotifyEvent read FOnOptionsChange write FOnOptionsChange;
  end;

implementation

{$R *.dfm}

uses
  System.Types,
  System.Json,
  System.IOUtils,
  ToolsApi,
  ApplicationOptions;

{ TOfflineCallStackFrame }

procedure TOfflineCallStackFrame.AddCallStackFilesToDropdown;
var
  FileName: string;
begin
  CallStackFilesDropdown.Clear;
  for FileName in TDirectory.GetFiles(AppOptions.JsonFileSavePath, '*.json') do
  begin
    CallStackFilesDropdown.Items.Add(FileName);
  end;
end;

procedure TOfflineCallStackFrame.CallStackFilesDropdownChange(Sender: TObject);
var
  CallStackFrame: TCallStackFrame;
begin
  TCallStackReader.ReadCallStack(CallStackFilesDropdown.Text, FCallStack);
  CallStackListBox.Clear;
  for CallStackFrame in FCallStack do
  begin
    CallStackListBox.Items.Add(CallStackFrame.Header);
  end;
end;

procedure TOfflineCallStackFrame.CallStackListBoxDblClick(Sender: TObject);
var
  SelectionIndex: Integer;
begin
  SelectionIndex := CallStackListBox.ItemIndex;
  if FCallStack[SelectionIndex].FileName <> '' then
    OpenInIDEEditor(FCallStack[SelectionIndex].FileName, FCallStack[SelectionIndex].LineNumber );
end;

procedure TOfflineCallStackFrame.CallStackListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do
  begin
    if FCallStack[Index].FileName = '' then
      Font.Color := clRed;

    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TOfflineCallStackFrame.FrameEnter(Sender: TObject);
begin
  if Assigned(FOnFocus) then OnFocus(Self);
end;

procedure TOfflineCallStackFrame.LoadCallStackData;
begin
  if not Assigned(FCallStack) then
    FCallStack := TObjectList<TCallStackFrame>.Create;
  FCallStack.Clear;
  AddCallStackFilesToDropdown;
end;

procedure TOfflineCallStackFrame.LoadCallStackExecute(Sender: TObject);
begin

end;

procedure TOfflineCallStackFrame.OpenInIDEEditor(const EditorFileName: string; const LineNumber: Integer);
var
  IServices : IOTAServices;
  IActionServices : IOTAActionServices;
  IModuleServices : IOTAModuleServices;
  IEditorServices : IOTAEditorServices60;
  IModule : IOTAModule;
  i : Integer;
  IEditor : IOTAEditor;
  ISourceEditor : IOTASourceEditor;
  IFormEditor : IOTAFormEditor;
  IComponent : IOTAComponent;
  INTAComp : INTAComponent;
  AForm : TForm;
  IEditView : IOTAEditView;
  CursorPos : TOTAEditPos;
  FileName : String;
begin
  IServices := BorlandIDEServices as IOTAServices;
  Assert(Assigned(IServices), 'IOTAServices not available');

  IServices.QueryInterface(IOTAACtionServices, IActionServices);
  if IActionServices <> Nil then begin

    IServices.QueryInterface(IOTAModuleServices, IModuleServices);
    Assert(IModuleServices <> Nil);

    if IActionServices.OpenFile(EditorFileName) then begin

      //  At this point, if the named file has an associated .DFM and
      //  we stopped here, the form designer would be in front of the
      //  code editor.

      IModule := IModuleServices.Modules[0];
      //  IModule is the one holding our .Pas file and its .Dfm, if any
      //  So, iterate the IModule's editors until we find the one
      //  for the .Pas file and then call .Show on it.  This will
      //  bring the code editor in front of the form editor.

      ISourceEditor := Nil;

      for i := 0 to IModule.ModuleFileCount - 1 do begin
        IEditor := IModule.ModuleFileEditors[i];
        FileName := IEditor.FileName;
//RWT        Memo1.Lines.Add(Format('%d %s', [i, FileName]));
        if CompareText(ExtractFileExt(IEditor.FileName), '.Pas') = 0 then begin
          if ISourceEditor = Nil then begin
            IEditor.QueryInterface(IOTASourceEditor, ISourceEditor);
            IEditor.Show;
          end
        end
        else begin
          // Maybe the editor is a Form Editor.  If it is
          // close the form (the counterpart to the .Pas, that is}
          IEditor.QueryInterface(IOTAFormEditor, IFormEditor);
          if IFormEditor <> Nil then begin
            IComponent := IFormEditor.GetRootComponent;
            IComponent.QueryInterface(INTAComponent, INTAComp);
            AForm := TForm(INTAComp.GetComponent);
            //AForm.Close; < this does NOT close the on-screen form
            // IActionServices.CloseFile(IEditor.FileName); <- neither does this
            SendMessage(AForm.Handle, WM_Close, 0, 0);  // But this does !
          end;
        end;
      end;

      //  Next, place the editor caret where we want it ...
      IServices.QueryInterface(IOTAEditorServices, IEditorServices);
      Assert(IEditorServices <> Nil);

      IEditView := IEditorServices.TopView;
      Assert(IEditView <> Nil);
      CursorPos.Line := LineNumber;
      CursorPos.Col := 0;
      IEditView.SetCursorPos(CursorPos);
      //  and scroll the IEditView to the caret
      IEditView.MoveViewToCursor;
    end;
  end;

end;

procedure TOfflineCallStackFrame.RefreshData;
begin
  LoadCallStackData;
end;

procedure TOfflineCallStackFrame.RefreshStackFiles(Sender: TObject);
begin
  LoadCallStackData;
end;

end.
