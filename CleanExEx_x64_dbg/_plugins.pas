Unit _plugins;

(**
*
* Ported form _plugins.h (x64_dbg-PluginSDK v0.10) to Unit Delphi by quygia128
* Home: http://cin1team.biz
* Blog: http://crackertool.blogspot.com (www.crackertool.tk)
* Last Edit: 06.30.2014 by quygia128
* 
* Update: https://github.com/quygia128
*
* Thanks to TQN for Delphi Coding, phpbb3 and BOB for Nice Plugin(Tools) Power By Delphi,
* all my friends at CiN1Team(ALL CIN1'S MEMBER) & Other RCE Team.
* Of course thanks to Mr.eXodia author of x64_dbg, Nice Work!
*
**)

interface

uses 
	Windows, bridgemain;

	{$ALIGN 1}									                // Struct byte alignment
	{$WARN UNSAFE_CODE OFF}
	{$WARN UNSAFE_TYPE OFF}
	{$WARN UNSAFE_CAST OFF}
	//{$DEFINE WIN64}
  
Type

{$IFDEF WIN64}
  {$MINENUMSIZE 8}                          	// Size of enumerated types are 8 bytes
	duint = UInt64;
	dsint = Int64;
	pduint = ^duint;
	pdsint  = ^dsint;
{$ELSE}
  {$MINENUMSIZE 4}                            // Size of enumerated types are 4 bytes
	duint = ULong;
	dsint = LongInt;
	pduint = ^duint;
	pdsint = ^dsint;
{$ENDIF} //WIN64

{$IFDEF UNICODE}
	AChar          = AnsiChar;                	// Delphi 6,7 SRC Work With Delphi 2009, 2010, XE.x
	PAChar         = PAnsiChar;               	// Delphi 6,7 SRC Work With Delphi 2009, 2010, XE.x
{$ELSE}
	AChar          = Char;
	PAChar         = PChar;
{$ENDIF}
  
const
	PLUG_SDKVERSION  = $1;
  {$IFDEF WIN64}
		x32_DBG          = 'x64_dbg.dll';
  {$ELSE}
		x32_DBG          = 'x32_dbg.dll';
  {$ENDIF}


Type

PPLUG_INITSTRUCT = ^PLUG_INITSTRUCT;
	PLUG_INITSTRUCT = packed record
		//provided by the debugger
		pluginHandle: Integer;
		//provided by the pluginit function
		sdkVersion: Integer;
		pluginVersion: Integer;
		pluginName:array[0..255] of AChar;
	end;

PPLUG_SETUPSTRUCT = ^PLUG_SETUPSTRUCT;
	PLUG_SETUPSTRUCT = packed record
		//provided by the debugger
		hwndDlg: HWND; //gui window handle
		hMenu: Integer; //plugin menu handle
	end;

//callback structures
PPLUG_CB_INITDEBUG = ^PLUG_CB_INITDEBUG;
	PLUG_CB_INITDEBUG = packed record
		szFileName: PAChar;
	end;

PPLUG_CB_STOPDEBUG = ^PLUG_CB_STOPDEBUG;
	PLUG_CB_STOPDEBUG = packed record
		reserved: Pointer;
	end;

PPLUG_CB_CREATEPROCESS = ^PLUG_CB_CREATEPROCESS;
	PLUG_CB_CREATEPROCESS = Packed record
		CreateProcessInfo: {CREATE_PROCESS_DEBUG_INFO*}PCreateProcessDebugInfo;
		modInfo: PIMAGEHLP_MODULE64;
		DebugFileName: PAChar;
		fdProcessInfo: {PROCESS_INFORMATION*}PProcessInformation;
	end;

PPLUG_CB_EXITPROCESS = ^PLUG_CB_EXITPROCESS;
	PLUG_CB_EXITPROCESS = packed record
		ExitProcess: {EXIT_PROCESS_DEBUG_INFO*}PExitProcessDebugInfo;
	end;

PPLUG_CB_CREATETHREAD = ^PLUG_CB_CREATETHREAD;
	PLUG_CB_CREATETHREAD = packed record
		CreateThread: {CREATE_THREAD_DEBUG_INFO*}PCreateThreadDebugInfo;
		dwThreadId: DWORD;
	end;

PPLUG_CB_EXITTHREAD = ^PLUG_CB_EXITTHREAD;
	PLUG_CB_EXITTHREAD = packed record
		ExitThread: {EXIT_THREAD_DEBUG_INFO*}PExitThreadDebugInfo;
		dwThreadId: DWORD;
	end;

PPLUG_CB_SYSTEMBREAKPOINT = ^PLUG_CB_SYSTEMBREAKPOINT;
	PLUG_CB_SYSTEMBREAKPOINT = packed record
		reserved: Pointer;
	end;

PPLUG_CB_LOADDLL = ^PLUG_CB_LOADDLL;
	PLUG_CB_LOADDLL = packed record
		LoadDll: {LOAD_DLL_DEBUG_INFO*}PLoadDLLDebugInfo;
		modInfo: PIMAGEHLP_MODULE64;
		modname: PAChar;
	end;

PPLUG_CB_UNLOADDLL = ^PLUG_CB_UNLOADDLL;
	PLUG_CB_UNLOADDLL = packed record
		UnloadDll: {UNLOAD_DLL_DEBUG_INFO*}PUnloadDLLDebugInfo;
	end;

PPLUG_CB_OUTPUTDEBUGSTRING = ^PLUG_CB_OUTPUTDEBUGSTRING;
	PLUG_CB_OUTPUTDEBUGSTRING = packed record
		DebugString: {OUTPUT_DEBUG_STRING_INFO*}POutputDebugStringInfo;
	end;

PPLUG_CB_EXCEPTION = ^PLUG_CB_EXCEPTION;
	PLUG_CB_EXCEPTION = packed record
		Exception: {EXCEPTION_DEBUG_INFO*}PExceptionDebugInfo;
	end;

PPLUG_CB_BREAKPOINT = ^PLUG_CB_BREAKPOINT;
	PLUG_CB_BREAKPOINT = packed record
		breakpoint: PBRIDGEBP;
	end;

PPLUG_CB_PAUSEDEBUG = ^PLUG_CB_PAUSEDEBUG;
	PLUG_CB_PAUSEDEBUG = packed record
		reserved: Pointer;
	end;

PPLUG_CB_RESUMEDEBUG = ^PLUG_CB_RESUMEDEBUG;
	PLUG_CB_RESUMEDEBUG = packed record
		reserved: Pointer;
	end;

PPLUG_CB_STEPPED = ^PLUG_CB_STEPPED;
	PLUG_CB_STEPPED = packed record
		reserved: Pointer;
	end;

PPLUG_CB_ATTACH = ^PLUG_CB_ATTACH;
	PLUG_CB_ATTACH = packed record
		dwProcessId: DWORD;
	end;

PPLUG_CB_DETACH = ^PLUG_CB_DETACH;
	PLUG_CB_DETACH = packed record
		fdProcessInfo: {PROCESS_INFORMATION*}PProcessInformation;
	end;

PPLUG_CB_DEBUGEVENT = ^PLUG_CB_DEBUGEVENT;
	PLUG_CB_DEBUGEVENT = packed record
		DebugEvent: {DEBUG_EVENT*}PDebugEvent;
	end;

PPLUG_CB_MENUENTRY = ^PLUG_CB_MENUENTRY;
	PLUG_CB_MENUENTRY = packed record
		hEntry: Integer;
	end;

Type
	CBTYPE = (
		CB_INITDEBUG,           //PLUG_CB_INITDEBUG
		CB_STOPDEBUG,           //PLUG_CB_STOPDEBUG
		CB_CREATEPROCESS,       //PLUG_CB_CREATEPROCESS
		CB_EXITPROCESS,         //PLUG_CB_EXITPROCESS
		CB_CREATETHREAD,        //PLUG_CB_CREATETHREAD
		CB_EXITTHREAD,          //PLUG_CB_EXITTHREAD
		CB_SYSTEMBREAKPOINT,    //PLUG_CB_SYSTEMBREAKPOINT
		CB_LOADDLL,             //PLUG_CB_LOADDLL
		CB_UNLOADDLL,           //PLUG_CB_UNLOADDLL
		CB_OUTPUTDEBUGSTRING,   //PLUG_CB_OUTPUTDEBUGSTRING
		CB_EXCEPTION,           //PLUG_CB_EXCEPTION
		CB_BREAKPOINT,          //PLUG_CB_BREAKPOINT
		CB_PAUSEDEBUG,          //PLUG_CB_PAUSEDEBUG
		CB_RESUMEDEBUG,         //PLUG_CB_RESUMEDEBUG
		CB_STEPPED,             //PLUG_CB_STEPPED
		CB_ATTACH,              //PLUG_CB_ATTACHED (before attaching, after CB_INITDEBUG)
		CB_DETACH,              //PLUG_CB_DETACH (before detaching, before CB_STOPDEBUG)
		CB_DEBUGEVENT,          //PLUG_CB_DEBUGEVENT (called on any debug event)
		CB_MENUENTRY            //PLUG_CB_MENUENTRY
	  );

  //typedef void (*CBPLUGIN)(CBTYPE cbType, void* callbackInfo);
  //typedef bool (*CBPLUGINCOMMAND)(int, char**);
  CBPLUGIN = procedure(cbType: CBTYPE;callbackInfo: Pointer); cdecl;
  CBPLUGINCOMMAND = function(argc: Integer;Command: PPAnsiChar): Boolean; cdecl;

  
{PLUG_IMPEXP void}    procedure _plugin_registercallback(pluginHandle: Integer;CB_Type: CBTYPE;cb_Plugin: CBPLUGIN); cdecl; external x32_DBG;
{PLUG_IMPEXP bool}    function  _plugin_unregistercallback(pluginHandle: Integer;CB_Type: CBTYPE): Boolean; cdecl; external x32_DBG;
{PLUG_IMPEXP bool}	  function  _plugin_registercommand(pluginHandle: Integer;const command: PAChar;cbCommand: CBPLUGINCOMMAND;debugonly: Boolean): Boolean; cdecl; external x32_DBG;
{PLUG_IMPEXP bool}	  function  _plugin_unregistercommand(pluginHandle: Integer;const command: PAChar): Boolean; cdecl; external x32_DBG;
{PLUG_IMPEXP void}	  procedure _plugin_logprintf(const format: PAChar); cdecl; varargs; external x32_DBG;
{PLUG_IMPEXP void}	  procedure _plugin_logputs(const text: PAChar); cdecl; external x32_DBG;
{PLUG_IMPEXP void}	  procedure _plugin_debugpause(); cdecl; external x32_DBG;
{PLUG_IMPEXP void}	  procedure _plugin_debugskipexceptions(skip: Boolean); cdecl; external x32_DBG;
{PLUG_IMPEXP int}	  function  _plugin_menuadd(hMenu: Integer;const title: PAChar): Integer; cdecl; external x32_DBG;
{PLUG_IMPEXP bool}	  function  _plugin_menuaddentry(hMenu,hEntry: Integer;const title: PAChar): Boolean; cdecl; external x32_DBG;
{PLUG_IMPEXP bool}	  function  _plugin_menuaddseparator(hMenu: Integer): Boolean; cdecl; external x32_DBG;
{PLUG_IMPEXP bool}	  function  _plugin_menuclear(hMenu: Integer): Boolean; cdecl; external x32_DBG;

implementation

end.