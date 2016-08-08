Library CleanExEx;

uses
  Windows, Messages, CleanupEx, _plugins, bridgemain;

  {$ALIGN 1}
	{$WARN UNSAFE_CODE OFF}
	{$WARN UNSAFE_TYPE OFF}
	{$WARN UNSAFE_CAST OFF}
  //{$DEFINE WIN64}

	{$IFDEF WIN64}
	  //{$E dp64}                            // Extension supported is 3 in Delphi 7
  {$ELSE}
    //{$E dp32}
  {$ENDIF}

var
  SaveDLLProc:        TDLLProc;
  g_pluginHandle: THandle  = 0;
  g_hMenu: Cardinal        = 0;
  g_hsMenu: Cardinal       = 0;
  g_hWnD: Cardinal         = 0;
  g_Inst: Cardinal         = 0;
  
const
  PLUGIN_NAME: PAChar      = 'CleanupExEx';
  PLUGIN_AUTH: PAChar      = 'quygia128';
  PLUGIN_HOME: PAChar      = 'http://cin1team.biz';
  PLUGIN_BLOG: PAChar      = 'http://crackertool.tk';
  PLUGIN_VERS: Integer     = 10;
  //
  MENU_DELALLS             = 1;
  MENU_DELDP32             = 2;
  MENU_DELDP64             = 3;
  MENU_DELLDAT             = 4;
  MENU_DELXXXX             = 5;
  MENU_DELABUT             = 6;
  
////////////////////////////////////////////////////////////////////////////////
  {$R CleanupExEx.res}  
////////////////////////////////////////////////////////////////////////////////
procedure RegisterInitProc(cbType: CBTYPE;callbackInfo: Pointer); cdecl;
var
  info: PPLUG_CB_INITDEBUG;
begin
  ZeroMemory(@g_loadedname,SizeOf(g_loadedname));
	info:= PPLUG_CB_INITDEBUG(callbackInfo);
	g_loadedname[0]:= info^.szFileName;
  BridgeSettingSet('Last File','Last',g_loadedname[0]);
end;

procedure RegisterMenuProc(cbType: CBTYPE;callbackinfo: Pointer); cdecl;
var
	info: PPLUG_CB_MENUENTRY;
  db: PAnsiChar;
begin
	info:= PPLUG_CB_MENUENTRY(callbackInfo);
  case (info^.hEntry) of
    MENU_DELALLS:
	  begin
      //DeleteFilesProc(MENU_DELALLS);
      db:= GetdbDir;
      ShellExecuteA(GuiGetWindowHandle,'OPEN',db,nil,nil,1);
    end;
    MENU_DELDP32:
	  begin
      DeleteFilesProc(MENU_DELDP32);
    end;
    MENU_DELDP64:
	  Begin
      DeleteFilesProc(MENU_DELDP64);
    end;
    MENU_DELLDAT:
	  Begin
      DeletelatestData;
    end;
    MENU_DELXXXX:
	  Begin
      DeleteFilesProc(MENU_DELXXXX);
    end;
    MENU_DELABUT:
	  Begin
      MessageBoxA(g_hWnD,'CleanupExEx v0.1 - 07.07.2014'#10'     by quygia128 '#10#10'Home: http://cin1team.biz '#10#13'Greetz fly go to all my friends','x64_dbg: CleanupExEx',MB_ICONINFORMATION);
    end;
  end;
end;

function cbDeldd32Command(argc: Integer; argv: PPAnsiChar): Boolean; cdecl;
begin
	DeleteFilesProc(MENU_DELDP32);
end;

function cbDeldd64Command(argc: Integer; argv: PPAnsiChar): Boolean; cdecl;
begin
	DeleteFilesProc(MENU_DELDP64);
end;

function cbDellddCommand(argc: Integer; argv: PPAnsiChar): Boolean; cdecl;
begin
  DeletelatestData;
end;

function cbDelddAllCommand(argc: Integer; argv: PPAnsiChar): Boolean; cdecl;
var
  db: PAnsiChar;
begin
  //
  db:= GetdbDir;
  ShellExecuteA(GuiGetWindowHandle,'OPEN',db,nil,nil,SW_SHOWNORMAL);
end;

function x_dbg_Plugininit(PlugInitInfo: PPLUG_INITSTRUCT): Boolean; cdecl;
begin
  g_pluginHandle:= PlugInitInfo^.pluginHandle;               //Address: 0043E7DC
  PlugInitInfo^.sdkVersion:= PLUG_SDKVERSION;
  PlugInitInfo^.PluginVersion:= PLUGIN_VERS;
  lstrcpyA(PlugInitInfo^.pluginName,PLUGIN_NAME);
  _plugin_registercallback(g_pluginHandle, CB_MENUENTRY, RegisterMenuProc);
  _plugin_registercallback(g_pluginHandle, CB_INITDEBUG, RegisterInitProc);
  Result:= True;
end;

procedure x_dbg_Pluginsetup(PlugSetupInfo: PPLUG_SETUPSTRUCT); cdecl;
begin
  g_hWnD:= PlugSetupInfo^.hwndDlg;
  g_hMenu:= PlugSetupInfo^.hMenu;
  // Add plugin Menu
  _plugin_menuaddentry(g_hMenu,MENU_DELDP32,'Clear Alls *.dd32');
  //g_hsMenu:= _plugin_menuadd(hMenu, '&Load Config');
  _plugin_menuaddseparator(g_hMenu);
  //_plugin_menuaddentry(g_hMenu,MENU_DELDP64,'Clear Alls *.dd64');
  //_plugin_menuaddseparator(g_hMenu);
  _plugin_menuaddentry(g_hMenu,MENU_DELLDAT,'Clear Latest Debug Data');
  _plugin_menuaddseparator(g_hMenu);
  _plugin_menuaddentry(g_hMenu,MENU_DELALLS,'Open Data Directory');
  _plugin_menuaddseparator(g_hMenu);
  _plugin_menuaddentry(g_hMenu,MENU_DELABUT,'About..');
  // Register Command
   if not(_plugin_registercommand(g_pluginHandle, 'Deldd32', cbDeldd32Command, false)) then
        _plugin_logputs('[MapMaster] ErroR Registering The "Deldd32" command! ');
   //if not(_plugin_registercommand(g_pluginHandle, 'Deldd64', cbDeldd64Command, false)) then
	   //_plugin_logputs('[MapMaster] ErroR Registering The "Deldd64" command! ');
   if not(_plugin_registercommand(g_pluginHandle, 'Delldd', cbDellddCommand, false)) then
	   _plugin_logputs('[MapMaster] ErroR Registering The "Delldd" command! ');
   if not(_plugin_registercommand(g_pluginHandle, 'Opendb', cbDelddAllCommand, false)) then
	   _plugin_logputs('[MapMaster] ErroR Registering The "Opendb" command! ');
  // Add Plugin info
  _plugin_logprintf('[***] HOME: %s - BLOG: %s '#10,PLUGIN_HOME,PLUGIN_BLOG);
  _plugin_logprintf('[***] %s Plugin v%i by %s '#10,PLUGIN_NAME, PLUGIN_VERS, PLUGIN_AUTH);

end;

function x_dbg_plugstop(): Boolean; cdecl;
begin
  //
  _plugin_unregistercallback(g_pluginHandle,CB_MENUENTRY);
  _plugin_unregistercallback(g_pluginHandle,CB_INITDEBUG);
  Result:= True;
end;

exports

  x_dbg_Plugininit       name   'pluginit',
  x_dbg_Pluginsetup      name   'plugsetup',
  x_dbg_plugstop         name   'plugstop';
  
procedure DLLEntryPoint(dwReason: DWORD);
var
  szPluginName:array[0..MAX_PATH-1] of ACHAR;
begin
  if (dwReason = DLL_PROCESS_DETACH) then
  begin
    // Uninitialize code here
    lstrcatA(szPluginName,PLUGIN_NAME);
    lstrcatA(szPluginName,' Unloaded By DLL_PROCESS_DETACH');
    OutputDebugStringA(szPluginName);
  end;
  // Call saved entry point procedure
  if Assigned(SaveDLLProc) then SaveDLLProc(dwReason);
end;

begin
  //Initialize code here
  g_Inst:= HInstance;
  SaveDLLProc:= @DLLProc;
  DLLProc:= @DLLEntryPoint;
end.
