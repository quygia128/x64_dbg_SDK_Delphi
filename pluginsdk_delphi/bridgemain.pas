Unit bridgemain;

(**
*
* Ported form bridgemain.h (x64_dbg-PluginSDK v0.10) to Unit Delphi by quygia128
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
	Windows;

	{$ALIGN 1}                                  // Struct byte alignment
	{$WARN UNSAFE_CODE OFF}
	{$WARN UNSAFE_TYPE OFF}
	{$WARN UNSAFE_CAST OFF}
	//{$DEFINE WIN64}

Type
  DWORD64 = Int64;
  PDWORD64 = PInt64;

{$IFDEF WIN64}
  duint = UInt64;
	dsint = Int64;
	pduint = ^duint;
	pdsint  = ^dsint;
{$ELSE}
	duint = ULong;
	dsint = LongInt;
	pduint = ^duint;
	pdsint = ^dsint;
{$ENDIF} //WIN64


{$IFDEF UNICODE}
	AChar          = AnsiChar;                // Delphi 6,7 SRC Work With Delphi 2009, 2010, XE.x
	PAChar         = PAnsiChar;               // Delphi 6,7 SRC Work With Delphi 2009, 2010, XE.x
{$ELSE}
	AChar          = Char;
	PAChar         = PChar;
{$ENDIF}
	
Const  
	//Bridge defines
	MAX_SETTING_SIZE = 65536;
	DBG_VERSION = 18;
  {$IFDEF WIN64}
		x32_BRIDGE  = 'x64_bridge.dll';
  {$ELSE}
		x32_BRIDGE  = 'x32_bridge.dll';
  {$ENDIF}

//Bridge functions
{BRIDGE_IMPEXP char*}   function BridgeInit(): PAChar; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP char*}   function BridgeStart(): PAChar; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void*}   function BridgeAlloc(size: LongInt): Pointer; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure BridgeFree(ptr: Pointer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function BridgeSettingGet(const section: PAChar; const key:PAChar;value: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function BridgeSettingGetUint(const section: PAChar;const key: PAChar;value: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function BridgeSettingSet(const section: PAChar; const key: PAChar; const value: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function BridgeSettingSetUint(const section: PAChar; const key: PAChar;value: duint): Boolean; cdecl; external x32_BRIDGE;

Const
//Debugger defines
  MAX_LABEL_SIZE = 256;
  MAX_COMMENT_SIZE = 512;
  MAX_MODULE_SIZE = 256;
  MAX_BREAKPOINT_SIZE = 256;
  MAX_SCRIPT_LINE_SIZE = 2048;

  TYPE_VALUE = 1;
  TYPE_MEMORY = 2;
  TYPE_ADDR = 4;
  MAX_MNEMONIC_SIZE = 64;

Type
//Debugger enums
DBGSTATE = (
    initialized,
    paused,
    running,
    stopped
	);

SEGMENTREG = (
    SEG_DEFAULT,
    SEG_ES,
    SEG_DS,
    SEG_FS,
    SEG_GS,
    SEG_CS,
    SEG_SS
);

ADDRINFOFLAGS = (
    flagmodule=1,
    flaglabel=2,
    flagcomment=4,
    flagbookmark=8,
    flagfunction=16
);

BPXTYPE = (
    bp_none=0,
    bp_normal=1,
    bp_hardware=2,
    bp_memory=4
);

FUNCTYPE = (
    FUNC_NONE,
    FUNC_BEGIN,
    FUNC_MIDDLE,
    FUNC_END,
    FUNC_SINGLE
);

LOOPTYPE = (
    LOOP_NONE,
    LOOP_BEGIN,
    LOOP_MIDDLE,
    LOOP_ENTRY,
    LOOP_END
);

DBGMSG = (
    DBG_SCRIPT_LOAD,                // param1=const char* filename,      param2=unused
    DBG_SCRIPT_UNLOAD,              // param1=unused,                    param2=unused
    DBG_SCRIPT_RUN,                 // param1=int destline,              param2=unused
    DBG_SCRIPT_STEP,                // param1=unused,                    param2=unused
    DBG_SCRIPT_BPTOGGLE,            // param1=int line,                  param2=unused
    DBG_SCRIPT_BPGET,               // param1=int line,                  param2=unused
    DBG_SCRIPT_CMDEXEC,             // param1=const char* command,       param2=unused
    DBG_SCRIPT_ABORT,               // param1=unused,                    param2=unused
    DBG_SCRIPT_GETLINETYPE,         // param1=int line,                  param2=unused
    DBG_SCRIPT_SETIP,               // param1=int line,                  param2=unused
    DBG_SCRIPT_GETBRANCHINFO,       // param1=int line,                  param2=SCRIPTBRANCH* info
    DBG_SYMBOL_ENUM,                // param1=SYMBOLCBINFO* cbInfo,      param2=unused
    DBG_ASSEMBLE_AT,                // param1=duint addr,                param2=const char* instruction
    DBG_MODBASE_FROM_NAME,          // param1=const char* modname,       param2=unused
    DBG_DISASM_AT,                  // param1=duint addr,				 param2=DISASM_INSTR* instr
    DBG_STACK_COMMENT_GET,          // param1=duint addr,                param2=STACK_COMMENT* comment
    DBG_GET_THREAD_LIST,            // param1=THREADALLINFO* list,       param2=unused
    DBG_SETTINGS_UPDATED,           // param1=unused,                    param2=unused
    DBG_DISASM_FAST_AT,             // param1=duint addr,                param2=BASIC_INSTRUCTION_INFO* basicinfo
    DBG_MENU_ENTRY_CLICKED          // param1=int hEntry,                param2=unused
);

SCRIPTLINETYPE = (
    linecommand,
    linebranch,
    linelabel,
    linecomment,
    lineempty
);

SCRIPTBRANCHTYPE = (
    scriptnobranch,
    scriptjmp,
    scriptjnejnz,
    scriptjejz,
    scriptjbjl,
    scriptjajg,
    scriptjbejle,
    scriptjaejge,
    scriptcall
);

DISASM_INSTRTYPE = (
    instr_normal,
    instr_branch,
    instr_stack
);

DISASM_ARGTYPE = (
    arg_normal,
    arg_memory
);

STRING_TYPE = (
    str_none,
    str_ascii,
    str_unicode
);

THREADPRIORITY = (
    PriorityIdle = -15,
    PriorityAboveNormal = 1,
    PriorityBelowNormal = -1,
    PriorityHighest = 2,
    PriorityLowest = -2,
    PriorityNormal = 0,
    PriorityTimeCritical = 15,
    PriorityUnknown = $7FFFFFFF
);

THREADWAITREASON = (
    Executive = 0,
    FreePage = 1,
    PageIn = 2,
    PoolAllocation = 3,
    DelayExecution = 4,
    Suspended = 5,
    UserRequest = 6,
    WrExecutive = 7,
    WrFreePage = 8,
    WrPageIn = 9,
    WrPoolAllocation = 10,
    WrDelayExecution = 11,
    WrSuspended = 12,
    WrUserRequest = 13,
    WrEventPair = 14,
    WrQueue = 15,
    WrLpcReceive = 16,
    WrLpcReply = 17,
    WrVirtualMemory = 18,
    WrPageOut = 19,
    WrRendezvous = 20,
    Spare2 = 21,
    Spare3 = 22,
    Spare4 = 23,
    Spare5 = 24,
    WrCalloutStack = 25,
    WrKernel = 26,
    WrResource = 27,
    WrPushLock = 28,
    WrMutex = 29,
    WrQuantumEnd = 30,
    WrDispatchInt = 31,
    WrPreempted = 32,
    WrYieldExecution = 33,
    WrFastMutex = 34,
    WrGuardedMutex = 35,
    WrRundown = 36
);

MEMORY_SIZE =(
    size_byte,
    size_word,
    size_dword,
    size_qword
);

//const
//Debugger typedefs
//VALUE_SIZE = MEMORY_SIZE;

Type

SYM_TYPE = (
    SymNone,
    SymCoff,
    SymCv,
    SymPdb,
    SymExport,
    SymDeferred,
    SymSym,       // .sym file
    SymDia,
    SymVirtual,
    NumSymTypes
);

GUID = packed record
    Data1: DWord; //4
    Data2: WORD; //2
    Data3: WORD; //2
    Data4:array[0..8-1] of Byte;//8
  end;

PIMAGEHLP_MODULE = ^IMAGEHLP_MODULE;
  IMAGEHLP_MODULE = packed record
    SizeOfStruct: DWORD;           // set to sizeof(IMAGEHLP_MODULE)
    BaseOfImage: DWORD;            // base load address of module
    ImageSize: DWORD;              // virtual size of the loaded module
    TimeDateStamp: DWORD;          // date/time stamp from pe header
    CheckSum: DWORD;               // checksum from the pe header
    NumSyms: DWORD;                // number of symbols in the symbol table
    SymType: SYM_TYPE;                // type of symbols loaded
    ModuleName:array[0..32-1] of AnsiChar;         // module name
    ImageName:array[0..255-1] of AnsiChar;         // image name
    LoadedImageName:array[0..255-1] of AnsiChar;   // symbol file name
  end;

PIMAGEHLP_MODULE64 = ^IMAGEHLP_MODULE64;
	IMAGEHLP_MODULE64 = packed record
    SizeOfStruct: DWORD;              // set to sizeof(IMAGEHLP_MODULE64)
    BaseOfImage: int64;               // base load address of module
    ImageSize: DWORD;                 // virtual size of the loaded module
    TimeDateStamp: DWORD;             // date/time stamp from pe header
    CheckSum: DWORD;                  // checksum from the pe header
    NumSyms: DWORD;                   // number of symbols in the symbol table
    SymType: SYM_TYPE;                // type of symbols loaded
    ModuleName:array[0..32-1] of ACHAR;         // module name
    ImageName:array[0..256-1] of ACHAR;         // image name
    LoadedImageName:array[0..256-1] of ACHAR;   // symbol file name
    // new elements: 07-Jun-2002
    LoadedPdbName:array[0..256-1] of ACHAR;     // pdb file name
    CVSig: DWORD;                     // Signature of the CV record in the debug directories
    CVData:array[0..(MAX_PATH * 3)-1] of ACHAR;   // Contents of the CV record
    PdbSig:DWORD;                     // Signature of PDB
    PdbSig70: GUID;                   // Signature of PDB (VC 7 and up)
    PdbAge: DWORD;                    // DBI age of pdb
    PdbUnmatched: LongBool;           // loaded an unmatched pdb
    DbgUnmatched: LongBool;           // loaded an unmatched dbg
    LineNumbers: LongBool;            // we have line number information
    GlobalSymbols: LongBool;          // we have internal symbol information
    TypeInfo: LongBool;               // we have type information
                                      // new elements: 17-Dec-2003
    SourceIndexed: LongBool;          // pdb supports source server
    Publics: LongBool;                // contains public symbols
  end;

PIMAGEHLP_MODULEW64 = ^IMAGEHLP_MODULEW64;
	IMAGEHLP_MODULEW64 = packed record
    SizeOfStruct: DWORD;              // set to sizeof(IMAGEHLP_MODULE64)
    BaseOfImage: Int64;               // base load address of module
    ImageSize: DWORD;                 // virtual size of the loaded module
    TimeDateStamp: DWORD;             // date/time stamp from pe header
    CheckSum: DWORD;                  // checksum from the pe header
    NumSyms: DWORD;                   // number of symbols in the symbol table
    SymType: SYM_TYPE;                // type of symbols loaded
    ModuleName:array[0..32-1] of WCHAR;         // module name
    ImageName:array[0..256-1] of WCHAR;         // image name
    LoadedImageName:array[0..256-1] of WCHAR;   // symbol file name
    // new elements: 07-Jun-2002
    LoadedPdbName:array[0..256-1] of WCHAR;     // pdb file name
    CVSig: DWORD;                     // Signature of the CV record in the debug directories
    CVData:array[0..(MAX_PATH * 3)-1] of WCHAR; // Contents of the CV record
    PdbSig: DWORD;                    // Signature of PDB
    PdbSig70: GUID;                   // Signature of PDB (VC 7 and up)
    PdbAge: DWORD;                    // DBI age of pdb
    PdbUnmatched: LongBool;           // loaded an unmatched pdb
    DbgUnmatched: LongBool;           // loaded an unmatched dbg
    LineNumbers: LongBool;            // we have line number information
    GlobalSymbols: LongBool;          // we have internal symbol information
    TypeInfo: LongBool;               // we have type information
                                      // new elements: 17-Dec-2003
    SourceIndexed: LongBool;          // pdb supports source server
    Publics: LongBool;                // contains public symbols
  end;

PSYMBOLINFO = ^SYMBOLCBINFO;
//typedef void (*CBSYMBOLENUM)(SYMBOLINFO* symbol, void* user);
CBSYMBOLENUM = procedure(symbol: PSYMBOLINFO;user: Pointer);

//Debugger structs
PMEMPAGE = ^MEMPAGE;
MEMPAGE = packed record
    mbi: MEMORY_BASIC_INFORMATION;
    info:array[0..MAX_MODULE_SIZE-1] of AChar;
end;

PMEMMAP = ^MEMMAP;
MEMMAP = packed record
    count: Integer;
    page: PMEMPAGE;
end;

PBRIDGEBP = ^BRIDGEBP;
BRIDGEBP = packed record
    bptype: BPXTYPE;
    addr: duint;
    enabled,
    singleshoot,
    active: Boolean;
    name:array[0..MAX_BREAKPOINT_SIZE-1] of AChar;
    module:array[0..MAX_MODULE_SIZE-1] of AChar;
    slot: WORD;
end;

PBPMAP = ^BPMAP;
BPMAP = Packed record
    count: Integer;
    bp: PBRIDGEBP;
end;

PslFUNCTION = ^slFUNCTION;
slFUNCTION  = packed record
    start,
    slend: duint;
end;

PADDRINFO = ^ADDRINFO;
ADDRINFO = packed record
    flags: Integer; //ADDRINFOFLAGS
    module:array[0..MAX_MODULE_SIZE-1] of AChar; //module the address is in
    ilabel:array[0..MAX_LABEL_SIZE-1] of AChar;
    comment:array[0..MAX_COMMENT_SIZE-1] of AChar;
    isbookmark: Boolean;
    ifunction: slFUNCTION;
end;

//PSYMBOLINFO = ^SYMBOLINFO;
SYMBOLINFO = packed record
    addr: duint;
    decoratedSymbol: PAChar;
    undecoratedSymbol: PAChar;
end;

PSYMBOLMODULEINFO = ^SYMBOLMODULEINFO;
SYMBOLMODULEINFO = packed record
    base: duint;
    name:array[0..MAX_MODULE_SIZE-1] of AChar;
end;

PSYMBOLCBINFO = ^SYMBOLCBINFO;
SYMBOLCBINFO = packed record
    base: duint ;
    cbSymbolEnum: CBSYMBOLENUM;
    user: Pointer;
end;

PFLAGS = ^FLAGS;
FLAGS = packed record
    c,
    p,
    a,
    z,
    s,
    t,
    i,
    d,
    o: BOOL;
end;

PREGDUMP = ^REGDUMP;
REGDUMP = packed record
    cax,
    ccx,
    cdx,
    cbx,
    csp,
    cbp,
    csi,
    cdi: duint;
{$IFDEF WIN64}
    r8,
    r9,
    r10,
    r11,
    r12,
    r13,
    r14,
    r15: duint;
{$ELSE} //WIN64
    cip: duint;
    eflags: Cardinal;
    flags: FLAGS;
    gs,
    fs,
    es,
    ds,
    cs,
    ss: WORD;
    dr0,
    dr1,
    dr2,
    dr3,
    dr6,
    dr7: duint;
{$ENDIF}
end;

PDISASM_ARG = ^DISASM_ARG;
DISASM_ARG = packed record
    distype:DISASM_ARGTYPE;
    segment: SEGMENTREG;
    mnemonic:array[0..64-1] of AChar;
    constant,
    value,
    memvalue: duint;
end;

PDISASM_INSTR = ^DISASM_INSTR;
DISASM_INSTR = packed record
    instruction:array[0..64-1] of AChar;
    distype: DISASM_INSTRTYPE;
    argcount,
    instr_size: Integer;
    arg:array[0..3-1] of DISASM_ARG;
end;

PSTACK_COMMENT = ^STACK_COMMENT;
STACK_COMMENT = packed record
    color:array[0..8-1] of AChar; //hex color-code
    comment:array[0..MAX_COMMENT_SIZE-1] of AChar;
end;

PTHREADINFO = ^THREADINFO;
THREADINFO = packed record
    ThreadNumber: Integer;
    hThread: THANDLE;
    dwThreadId: DWORD;
    ThreadStartAddress,
    ThreadLocalBase: duint;
end;

PTHREADALLINFO = ^THREADALLINFO;
THREADALLINFO = packed record
    BasicInfo: THREADINFO;
    ThreadCip: duint;
    SuspendCount: DWORD;
    Priority:THREADPRIORITY;
    WaitReason: THREADWAITREASON;
    LastError: DWORD;
end;

PTHREADLIST = ^THREADLIST;
THREADLIST = packed record
    count: Integer;
    list: PTHREADALLINFO;
    CurrentThread: Integer;
end;

PMEMORY_INFO = ^MEMORY_INFO;
MEMORY_INFO = packed record
    value: ULONG_PTR; //displacement / addrvalue (rip-relative)
    size: MEMORY_SIZE; //byte/word/dword/qword
    mnemonic:array[0..MAX_MNEMONIC_SIZE-1] of AChar;
end;

PVALUE_INFO = ^VALUE_INFO;
VALUE_INFO = packed record
    value: ULONG_PTR;
    size: MEMORY_SIZE{VALUE_SIZE};
end;

PBASIC_INSTRUCTION_INFO = ^BASIC_INSTRUCTION_INFO;
BASIC_INSTRUCTION_INFO = packed record
    biitype: DWORD; //value|memory|addr
    value: VALUE_INFO; //immediat
    memory:MEMORY_INFO;
    addr:ULONG_PTR; //addrvalue (jumps + calls)
    branch: Boolean; //jumps/calls
end;

PSCRIPTBRANCH = ^SCRIPTBRANCH;
SCRIPTBRANCH = packed record
    scbtype: SCRIPTBRANCHTYPE;
    dest: Integer;
    branchlabel:array[0..256-1] of AChar;
end;

//Debugger functions
{BRIDGE_IMPEXP char*}   function DbgInit(): PAChar; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgMemRead(va:duint;dest: PByte;size: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgMemWrite(va: duint; const src: PByte;size: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP duint}   function DbgMemGetPageSize(base: duint): duint; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP duint}   function DbgMemFindBaseAddr(addr: duint;size: Pduint): duint; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgCmdExec(const cmd: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgCmdExecDirect(const cmd: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgMemMap(memmap: PMEMMAP): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgIsValidExpression(const expression: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgIsDebugging(): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgIsJumpGoingToExecute(addr: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgGetLabelAt(addr: duint;segment:SEGMENTREG;text: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgSetLabelAt(addr: duint; const text: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgGetCommentAt(addr: duint;text: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgSetCommentAt(addr:duint; const text: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgGetBookmarkAt(addr: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgSetBookmarkAt(addr: duint;isbookmark: Boolean): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgGetModuleAt(addr: duint;text: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP BPXTYPE} function DbgGetBpxTypeAt(addr: duint): BPXTYPE; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP duint}   function DbgValFromString(const szstring: PAChar): duint; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgGetRegDump(regdump: PREGDUMP): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgValToString(const szstring: PAChar;value: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgMemIsValidReadPtr(addr: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP int}     function DbgGetBpList(bptype:BPXTYPE;list: PBPMAP): Integer; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP FUNCTYPE}function DbgGetFunctionTypeAt(addr: duint): FUNCTYPE; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP LOOPTYPE}function DbgGetLoopTypeAt(addr: duint;depth: Integer): LOOPTYPE; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP duint}   function DbgGetBranchDestination(addr: duint): duint; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgFunctionOverlaps(fOstart: duint;fOend: duint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgFunctionGet(addr: duint;fGstart: Pduint; fGend: pduint): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgScriptLoad(const filename: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgScriptUnload(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgScriptRun(destline: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgScriptStep(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgScriptBpToggle(line: Integer): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgScriptBpGet(line: Integer): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgScriptCmdExec(const command: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgScriptAbort(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP SCRIPTLINETYPE}function DbgScriptGetLineType(line: Integer): SCRIPTLINETYPE; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgScriptSetIp(line: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgScriptGetBranchInfo(line: Integer;info: PSCRIPTBRANCH): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgSymbolEnum(base: duint;cbSymbolEnum: CBSYMBOLENUM;user: Pointer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgAssembleAt(addr: duint; const instruction: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP duint}   function DbgModBaseFromName(const name: PAChar): duint; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgDisasmAt(addr: duint;instr: PDISASM_INSTR); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function DbgStackCommentGet(addr: duint;comment: PSTACK_COMMENT):Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgGetThreadList(list: PTHREADLIST); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgSettingsUpdated(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgDisasmFastAt(addr: duint; basicinfo: PBASIC_INSTRUCTION_INFO); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure DbgMenuEntryClicked(hEntry: Integer); cdecl; external x32_BRIDGE;

Const
//Gui defines
	GUI_PLUGIN_MENU   = 0;
	GUI_DISASSEMBLY   = 0;
	GUI_DUMP          = 1;
	GUI_STACK         = 2;

	GUI_MAX_LINE_SIZE = 65536;
  
Type
//Gui enums
GUIMSG = (
    GUI_DISASSEMBLE_AT,             // param1=(duint)va,            param2=(duint)cip
    GUI_SET_DEBUG_STATE,            // param1=(DBGSTATE)state,      param2=unused
    GUI_ADD_MSG_TO_LOG,             // param1=(const char*)msg,     param2=unused
    GUI_CLEAR_LOG,                  // param1=unused,               param2=unused
    GUI_UPDATE_REGISTER_VIEW,       // param1=unused,               param2=unused
    GUI_UPDATE_DISASSEMBLY_VIEW,    // param1=unused,               param2=unused
    GUI_UPDATE_BREAKPOINTS_VIEW,    // param1=unused,               param2=unused
    GUI_UPDATE_WINDOW_TITLE,        // param1=(const char*)file,    param2=unused
    GUI_GET_WINDOW_HANDLE,          // param1=unused,               param2=unused
    GUI_DUMP_AT,                    // param1=(duint)va             param2=unused
    GUI_SCRIPT_ADD,                 // param1=int count,            param2=const char** lines
    GUI_SCRIPT_CLEAR,               // param1=unused,               param2=unused
    GUI_SCRIPT_SETIP,               // param1=int line,             param2=unused
    GUI_SCRIPT_ERROR,               // param1=int line,             param2=const char* message
    GUI_SCRIPT_SETTITLE,            // param1=const char* title,    param2=unused
    GUI_SCRIPT_SETINFOLINE,         // param1=int line,             param2=const char* info
    GUI_SCRIPT_MESSAGE,             // param1=const char* message,  param2=unused
    GUI_SCRIPT_MSGYN,               // param1=const char* message,  param2=unused
    GUI_SYMBOL_LOG_ADD,             // param1(const char*)msg,      param2=unused
    GUI_SYMBOL_LOG_CLEAR,           // param1=unused,               param2=unused
    GUI_SYMBOL_SET_PROGRESS,        // param1=int percent           param2=unused
    GUI_SYMBOL_UPDATE_MODULE_LIST,  // param1=int count,            param2=SYMBOLMODULEINFO* modules
    GUI_REF_ADDCOLUMN,              // param1=int width,            param2=(const char*)title
    GUI_REF_SETROWCOUNT,            // param1=int rows,             param2=unused
    GUI_REF_GETROWCOUNT,            // param1=unused,               param2=unused
    GUI_REF_DELETEALLCOLUMNS,       // param1=unused,               param2=unused
    GUI_REF_SETCELLCONTENT,         // param1=(CELLINFO*)info,      param2=unused
    GUI_REF_GETCELLCONTENT,         // param1=int row,              param2=int col
    GUI_REF_RELOADDATA,             // param1=unused,               param2=unused
    GUI_REF_SETSINGLESELECTION,     // param1=int index,            param2=bool scroll
    GUI_REF_SETPROGRESS,            // param1=int progress,			param2=unused
    GUI_REF_SETSEARCHSTARTCOL,      // param1=int col               param2=unused
    GUI_STACK_DUMP_AT,              // param1=duint addr,           param2=duint csp
    GUI_UPDATE_DUMP_VIEW,           // param1=unused,               param2=unused
    GUI_UPDATE_THREAD_VIEW,         // param1=unused,               param2=unused
    GUI_ADD_RECENT_FILE,            // param1=(const char*)file,    param2=unused
    GUI_SET_LAST_EXCEPTION,         // param1=unsigned int code,    param2=unused
    GUI_GET_DISASSEMBLY,            // param1=duint addr,           param2=char* text
    GUI_MENU_ADD,                   // param1=int hMenu,            param2=const char* title
    GUI_MENU_ADD_ENTRY,             // param1=int hMenu,            param2=const char* title
    GUI_MENU_ADD_SEPARATOR,         // param1=int hMenu,            param2=unused
    GUI_MENU_CLEAR,                 // param1=int hMenu,            param2=unused
    GUI_SELECTION_GET,              // param1=int hWindow,          param2=SELECTIONDATA* selection
    GUI_SELECTION_SET,              // param1=int hWindow,          param2=const SELECTIONDATA* selection
    GUI_GETLINE_WINDOW              // param1=const char* title,    param2=char* text
);

//GUI structures
PCELLINFO = ^CELLINFO;
CELLINFO = packed record
    row,
    col: Integer;
    str: PAChar;
end;

PSELECTIONDATA = ^SELECTIONDATA;
SELECTIONDATA = packed record
    adrstart,
    adrend: duint;
end;

//GUI functions
{BRIDGE_IMPEXP void}    procedure GuiDisasmAt(addr: duint;cip: duint); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiSetDebugState(state: DBGSTATE); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiAddLogMessage(const msg: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiLogClear(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiUpdateAllViews(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiUpdateRegisterView(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiUpdateDisassemblyView(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiUpdateBreakpointsView(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiUpdateWindowTitle(const filename: PACHar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP HWND}    function GuiGetWindowHandle(): HWND; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiDumpAt(va: duint); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiScriptAdd(count: Integer; const lines: PPAnsiChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiScriptClear(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiScriptSetIp(line: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiScriptError(line: Integer; const szmessage: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiScriptSetTitle(const title: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiScriptSetInfoLine(line: integer; const info: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiScriptMessage(const szmessage: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP int}     function GuiScriptMsgyn(const szmessage: PAChar): integer; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiSymbolLogAdd(const szmessage: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiSymbolLogClear(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiSymbolSetProgress(percent: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiSymbolUpdateModuleList(count: integer;modules: PSYMBOLMODULEINFO); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceAddColumn(width: Integer; const title: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceSetRowCount(count: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP int}     function GuiReferenceGetRowCount(): Integer; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceDeleteAllColumns(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceSetCellContent(row: Integer;col: Integer; const st: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP char*}   function GuiReferenceGetCellContent(row: Integer;col: Integer): PAChar; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceReloadData(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceSetSingleSelection(index: Integer;scroll: Boolean); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceSetProgress(progress: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiReferenceSetSearchStartCol(col: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiStackDumpAt(addr: duint;csp: duint); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiUpdateDumpView(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiUpdateThreadView(); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiAddRecentFile(const filename: PAChar); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiSetLastException(exception: LongWord); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function GuiGetDisassembly(addr: duint;text: PAChar): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP int}     function GuiMenuAdd(hMenu: Integer; const title: PAChar): Integer; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP int}     function GuiMenuAddEntry(hMenu: Integer; const title: PAChar): Integer; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiMenuAddSeparator(hMenu: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP void}    procedure GuiMenuClear(hMenu: Integer); cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function GuiSelectionGet(hWindow: Integer;selection: PSELECTIONDATA): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function GuiSelectionSet(hWindow: Integer;const selection: SELECTIONDATA): Boolean; cdecl; external x32_BRIDGE;
{BRIDGE_IMPEXP bool}    function GuiGetLineWindow(const title: PACHar;text: PAChar): Boolean; cdecl; external x32_BRIDGE;

implementation

initialization

end.
