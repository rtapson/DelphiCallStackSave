unit CallStackMenus;

interface

uses
  Vcl.Menus;

type
  TApplicationMainMenu = class
  private
    FOTAMainMenu: TMenuItem;
  protected
    procedure InstallMainMenu;
    procedure ShowOfflineCallStackClick(Sender: TObject);
    procedure ShowOfflineCallStackUpdate(Sender: TObject);


    // procedure AutoSaveOptionsExecute(Sender: TObject);
    // procedure AboutExecute(Sender: TObject);
    // procedure ProjCreateWizardExecute(Sender: TObject);
    // procedure ShowEditorMessagesClick(Sender: TObject);
    // procedure ShowEditorMessagesUpdate(Sender: TObject);
    // procedure ShowIDEMessagesClick(Sender: TObject);
    // procedure ShowIDEMessagesUpdate(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.Generics.Collections,
  System.Classes,
  Winapi.Windows,
  System.SysUtils,
  ToolsAPI,
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.ActnList,
  Vcl.ComCtrls,
  OfflineCallStackForm
  ;

var
  ApplicationMainMenu: TApplicationMainMenu;
  FOTAActions: TObjectList<TBasicAction>;

  // procedure UpdateModuleOps(Op : TModuleOption);
  // var
  // AppOps : TApplicationOptions;
  // begin
  // AppOps := ApplicationOps;
  // if Op In AppOps.ModuleOps then
  // AppOps.ModuleOps := AppOps.ModuleOps - [Op]
  // else
  // AppOps.ModuleOps := AppOps.ModuleOps + [Op];
  // end;

Function AddImageToIDE(strImageName: String): Integer;
Var
  NTAS: INTAServices;
  ilImages: TImageList;
  BM: TBitMap;
begin
  Result := -1;
  If FindResource(hInstance, PChar(strImageName + 'Image'), RT_BITMAP) > 0 Then
  Begin
    NTAS := (BorlandIDEServices As INTAServices);
    // Create image in IDE image list
    ilImages := TImageList.Create(Nil);
    Try
      BM := TBitMap.Create;
      Try
        BM.LoadFromResourceName(hInstance, strImageName + 'Image');
        ilImages.AddMasked(BM, clLime);
        // EXCEPTION: Operation not allowed on sorted list
        // Result := NTAS.AddImages(ilImages, 'OTATemplateImages');
        Result := NTAS.AddImages(ilImages);
      Finally
        BM.Free;
      End;
    Finally
      ilImages.Free;
    End;
  End;
end;

function FindMenuItem(strParentMenu: String): TMenuItem;
  Function IterateSubMenus(Menu: TMenuItem): TMenuItem;
  Var
    iSubMenu: Integer;
  Begin
    Result := Nil;
    For iSubMenu := 0 To Menu.Count - 1 Do
    Begin
      If CompareText(strParentMenu, Menu[iSubMenu].Name) = 0 Then
        Result := Menu[iSubMenu]
      Else
        Result := IterateSubMenus(Menu[iSubMenu]);
      If Result <> Nil Then
        Break;
    End;
  End;

Var
  iMenu: Integer;
  NTAS: INTAServices;
  Items: TMenuItem;
begin
  Result := Nil;
  NTAS := (BorlandIDEServices As INTAServices);
  For iMenu := 0 To NTAS.MainMenu.Items.Count - 1 Do
  Begin
    Items := NTAS.MainMenu.Items;
    If CompareText(strParentMenu, Items[iMenu].Name) = 0 Then
      Result := Items[iMenu]
    Else
      Result := IterateSubMenus(Items);
    If Result <> Nil Then
      Break;
  End;
end;

Function CreateMenuItem(strName, strCaption, strParentMenu: String;
  ClickProc, UpdateProc: TNotifyEvent; boolBefore, boolChildMenu: Boolean;
  strShortCut: String; const Category: string): TMenuItem;
Var
  NTAS: INTAServices;
  CA: TAction;
  // {$IFNDEF D2005}
  miMenuItem: TMenuItem;
  // {$ENDIF}
  iImageIndex: Integer;
begin
  NTAS := (BorlandIDEServices As INTAServices);
  // Add Image to IDE
  iImageIndex := AddImageToIDE(strName);
  // Create the IDE action (cached for removal later)
  CA := Nil;
  Result := TMenuItem.Create(NTAS.MainMenu);
  If Assigned(ClickProc) Then
  Begin
    CA := TAction.Create(NTAS.ActionList);
    CA.ActionList := NTAS.ActionList;
    CA.Name := strName + 'Action';
    CA.Caption := strCaption;
    CA.OnExecute := ClickProc;
    CA.OnUpdate := UpdateProc;
    CA.ShortCut := TextToShortCut(strShortCut);
    CA.Tag := TextToShortCut(strShortCut);
    CA.ImageIndex := iImageIndex;
    CA.Category := Category;
    FOTAActions.Add(CA);
  End
  Else If strCaption <> '' Then
  Begin
    Result.Caption := strCaption;
    Result.ShortCut := TextToShortCut(strShortCut);
    Result.ImageIndex := iImageIndex;
  End
  Else
    Result.Caption := '-';
  // Create menu (removed through parent menu)
  Result.Action := CA;
  Result.Name := strName + 'Menu';

  // Create Action and Menu.
  // {$IFDEF D2005}
  // This is the new way to do it BUT doesnt create icons for the menu.
  // NTAS.AddActionMenu(strParentMenu + 'Menu', CA, Result, boolBefore, boolChildMenu);
  // {$ELSE}
  miMenuItem := FindMenuItem(strParentMenu);
  If miMenuItem <> Nil Then
  Begin
    If Not boolChildMenu Then
    Begin
      If boolBefore Then
        miMenuItem.Parent.Insert(miMenuItem.MenuIndex, Result)
      Else
        miMenuItem.Parent.Insert(miMenuItem.MenuIndex + 1, Result);
    End
    Else
      miMenuItem.Add(Result);
  End;
  // {$ENDIF}
end;

Procedure RemoveToolbarButtonsAssociatedWithActions;
  Function IsCustomAction(Action: TBasicAction): Boolean;
  Var
    i: Integer;
  Begin
    Result := False;
    For i := 0 To FOTAActions.Count - 1 Do
      If Action = FOTAActions[i] Then
      Begin
        Result := True;
        Break;
      End;
  End;
  Procedure RemoveAction(TB: TToolbar);
  Var
    i: Integer;
  Begin
    If TB <> Nil Then
      For i := TB.ButtonCount - 1 DownTo 0 Do
      Begin
        If IsCustomAction(TB.Buttons[i].Action) Then
          TB.RemoveControl(TB.Buttons[i]);
      End;
  End;

Var
  NTAS: INTAServices;
Begin
  NTAS := (BorlandIDEServices As INTAServices);
  RemoveAction(NTAS.ToolBar[sCustomToolBar]);
  RemoveAction(NTAS.ToolBar[sStandardToolBar]);
  RemoveAction(NTAS.ToolBar[sDebugToolBar]);
  RemoveAction(NTAS.ToolBar[sViewToolBar]);
  RemoveAction(NTAS.ToolBar[sDesktopToolBar]);
{$IFDEF D0006}
  RemoveAction(NTAS.ToolBar[sInternetToolBar]);
  RemoveAction(NTAS.ToolBar[sCORBAToolBar]);
{$IFDEF D2009}
  RemoveAction(NTAS.ToolBar[sAlignToolbar]);
  RemoveAction(NTAS.ToolBar[sBrowserToolbar]);
  RemoveAction(NTAS.ToolBar[sHTMLDesignToolbar]);
  RemoveAction(NTAS.ToolBar[sHTMLFormatToolbar]);
  RemoveAction(NTAS.ToolBar[sHTMLTableToolbar]);
  RemoveAction(NTAS.ToolBar[sPersonalityToolBar]);
  RemoveAction(NTAS.ToolBar[sPositionToolbar]);
  RemoveAction(NTAS.ToolBar[sSpacingToolbar]);
{$ENDIF}
{$ENDIF}
End;

{ TApplicationMainMenu }

constructor TApplicationMainMenu.Create;
begin
  FOTAMainMenu := nil;
  InstallMainMenu;
end;

destructor TApplicationMainMenu.Destroy;
begin
  FOTAMainMenu.Free;
  // Frees all child menus
  inherited Destroy;
end;

procedure TApplicationMainMenu.InstallMainMenu;
var
  NTAS: INTAServices;
begin
  NTAS := (BorlandIDEServices As INTAServices);
  if (NTAS <> Nil) And (NTAS.MainMenu <> Nil) then
  begin
    FOTAMainMenu := CreateMenuItem('RTOfflineCallStack', 'Offline Call Stack', 'ViewDebugItem',
      ShowOfflineCallStackClick, ShowOfflineCallStackUpdate, False, True, 'Ctrl+Alt+O', 'Debug');
{
    FOTAMainMenu := CreateMenuItem('OTATemplate', '&OTA Template', 'Tools', Nil,
      Nil, True, False, '');
    CreateMenuItem('OTAAutoSaveOptions', 'Auto Save &Option...', 'OTATemplate',
      AutoSaveOptionsExecute, Nil, False, True, 'Ctrl+Shift+O');
    CreateMenuItem('OTAProjectCreatorWizard', '&Project Creator Wizard...',
      'OTATemplate', ProjCreateWizardExecute, Nil, False, True, 'Ctrl+Shift+P');
    CreateMenuItem('OTANotifiers', 'Notifer Messages', 'OTATemplate', Nil, Nil,
      False, True, '');
    CreateMenuItem('OTAShowCompilerMsgs', 'Show &Compiler Messages',
      'OTANotifiers', ShowCompilerMessagesClick, ShowCompilerMessagesUpdate,
      False, True, '');
    CreateMenuItem('OTAShowEditorrMsgs', 'Show &Editor Messages',
      'OTANotifiers', ShowEditorMessagesClick, ShowEditorMessagesUpdate, False,
      True, '');
    CreateMenuItem('OTAShowIDEMsgs', 'Show &IDE Messages', 'OTANotifiers',
      ShowIDEMessagesClick, ShowIDEMessagesUpdate, False, True, '');
    CreateMenuItem('OTASeparator0001', '', 'OTATemplate', Nil, Nil, False,
      True, '');
    CreateMenuItem('OTAAbout', '&About...', 'OTATemplate', AboutExecute, Nil,
      False, True, 'Ctrl+Shift+Q');
      }
  end;
end;

procedure TApplicationMainMenu.ShowOfflineCallStackClick(Sender: TObject);
begin
  TOfflineCallStack.ShowDockableOfflineCallStack;
end;

procedure TApplicationMainMenu.ShowOfflineCallStackUpdate(Sender: TObject);
begin

end;

initialization
  FOTAActions := TObjectList<TBasicAction>.Create;
  ApplicationMainMenu := TApplicationMainMenu.Create;


finalization
  RemoveToolbarButtonsAssociatedWithActions;
  ApplicationMainMenu.Free;
  FOTAActions.Free;

end.
