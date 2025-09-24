#define MyAppName "Call Stack Save"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Tapper Media"
#define MyAppURL "https://github.com/rtapson"
;#define MyAppExeName "MyProg.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{0CC0E929-94FC-472C-B9F4-75396A29616C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes
DefaultDirName={userpf}\TapperMedia\CallStackSave
DisableDirPage=yes
DisableStartupPrompt=False
DisableWelcomePage=False

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "C:\gitprojects\DelphiCallStackSave\bin\D13\Win32\Debug\CallStackSaveExpert.bpl"; DestDir: "{userpf}\TapperMedia\CallStackSave\Win32"; Flags: ignoreversion; Components: Delphi13Win32
Source: "C:\gitprojects\DelphiCallStackSave\bin\D13\Win32\Debug\dcp\CallStackSaveExpert.dcp"; DestDir: "{userpf}\TapperMedia\CallStackSave\Win32"; Flags: ignoreversion; Components: Delphi13Win32
Source: "C:\gitprojects\DelphiCallStackSave\bin\D13\Win64\Debug\CallStackSaveExpert.bpl"; DestDir: "{userpf}\TapperMedia\CallStackSave\Win64"; Flags: ignoreversion; Components: Delphi13Win64
Source: "C:\gitprojects\DelphiCallStackSave\bin\D13\Win64\Debug\dcp\CallStackSaveExpert.dcp"; DestDir: "{userpf}\TapperMedia\CallStackSave\Win64"; Flags: ignoreversion; Components: Delphi13Win64

[Components]
Name: "Delphi13Win32"; Description: "Delphi 13 Win32"
Name: "Delphi13Win64"; Description: "Delphi 13 Win54"

[Registry]
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\37.0\Known Packages"; ValueType: string; ValueName: "CallStackSave"; ValueData: "{userpf}\TapperMedia\CallStackSave\Win32\CallStackSaveExpert.bpl"; Components: Delphi13Win32
Root: "HKCU"; Subkey: "Software\Embarcadero\BDS\37.0\Known Packages x64"; ValueType: string; ValueName: "CallStackSave"; ValueData: "{userpf}\TapperMedia\CallStackSave\Win64\CallStackSaveExpert.bpl"; Components: Delphi13Win64a
