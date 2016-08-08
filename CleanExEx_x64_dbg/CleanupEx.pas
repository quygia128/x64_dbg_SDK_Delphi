unit CleanupEx;
(*
 * CleanupExEx v1.0
 * Author: quygia128
 * IDE: Delphi 7
 * Date: 06.26.2014
 * Debugger: x64_dbg Plugin
 *
 *)

interface

uses
  windows, SysUtils, _plugins, bridgemain;
  {$WARN UNSAFE_CODE OFF}
	{$WARN UNSAFE_TYPE OFF}
	{$WARN UNSAFE_CAST OFF}
  
var
  g_loadedname:array[0..8] of PAnsiChar;
  function ShellExecuteA(hWnd: HWND; Operation, FileName, Parameters, Directory: PAnsiChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteA';
  function DeletelatestData: Boolean;
  function DeleteFilesProc(DelType: LongInt): Boolean;
  function GetdbDir: PAnsiChar; cdecl;

implementation

function GetdbDir: PAnsiChar;
var
  i: LongInt;
  x64dir:array[0..MAX_PATH*4-1] of Char;
begin
  ZeroMemory(@x64dir,SizeOf(x64dir));
    GetModuleFileNameA(GetModuleHandleA(nil),@x64dir,MAX_PATH*4-1);
    for i:= lstrlenA(@x64dir) downto 0 do begin
      if x64dir[i] <> '\' then x64dir[i]:= #0
      else begin
        lstrcatA(@x64dir,'db');
        Break;
      end;
    end;
    Result:= @x64dir;
end;

function DeletelatestData: Boolean;
var
  szOllyPath:array[0..MAX_PATH-1] of CHAR;
  szInfomation:array[0..MAX_PATH-1] of CHAR;
  szUDDFullPath:array[0..MAX_PATH-1] of CHAR;
  szFileNameW:array[0..MAX_PATH-1] of CHAR;
  szFName:array[0..MAX_PATH-1] of CHAR;
  datadir:array[0..MAX_PATH-1] of Char;
  x64dir:array[0..MAX_PATH-1] of Char;
  i: LongInt;
Begin
  Result:= False;
  if 6 = MessageBox(0,'Are you sure you want to delete the latest data ?','Confirm!',MB_ICONQUESTION + MB_YESNO) then begin
    //Zero initmemory
    ZeroMemory(@x64dir,SizeOf(x64dir));
    ZeroMemory(@szFileNameW,SizeOf(szFileNameW));
    ZeroMemory(@datadir,SizeOf(datadir));
    ZeroMemory(@szInfomation,SizeOf(szInfomation));
    // Get UDD path and backslash
    GetModuleFileNameA(GetModuleHandleA(nil),@x64dir,MAX_PATH);
    for i:= lstrlenA(@x64dir) downto 0 do begin
      if x64dir[i] <> '\' then x64dir[i]:= #0
      else begin
        lstrcatA(@x64dir,'db\');
        Break;
      end;
    end;
    lstrcatA(@datadir,@x64dir);
    // Case Delete data type
    // Delete debug data
    BridgeSettingGet('Recent Files','01',@szFileNameW);
    if lstrlenA(@szFileNameW) < 4 then
      BridgeSettingGet('Last File','Last',@szFileNameW);

    if not(lstrlenA(@szFileNameW) > 0) then begin
      _plugin_logputs('WARNING: File Not Found!');
      Exit;
    end
    else lstrcpyA(@szInfomation,@szFileNameW);
    lstrcatA(@szInfomation,'.dd32');
    lstrcatA(@x64dir,PAnsiChar(ExtractFileName(string(szInfomation))));
    ZeroMemory(@szInfomation,SizeOf(szInfomation));
    lstrcatA(@szInfomation,@x64dir);
    if DeleteFileA(@szInfomation) then begin
      _plugin_logprintf('CleanupExEx: Deleted file : %s', szInfomation);
      Result:= True;
    end;
    // Delete dd64
    //Zero initmemory
    ZeroMemory(@x64dir,SizeOf(x64dir));
    ZeroMemory(@szFileNameW,SizeOf(szFileNameW));
    ZeroMemory(@datadir,SizeOf(datadir));
    ZeroMemory(@szInfomation,SizeOf(szInfomation));
    // Get UDD path and backslash
    GetModuleFileNameA(GetModuleHandleA(nil),@x64dir,MAX_PATH);
    for i:= lstrlenA(@x64dir) downto 0 do begin
      if x64dir[i] <> '\' then x64dir[i]:= #0
      else begin
        lstrcatA(@x64dir,'db\');
        Break;
      end;
    end;
    lstrcatA(@datadir,@x64dir);
    // Case Delete data type
    // Delete debug data
    BridgeSettingGet('Recent Files','01',@szFileNameW);
    if lstrlenA(@szFileNameW) < 4 then
      BridgeSettingGet('Last File','Last',@szFileNameW);

    if not(lstrlenA(@szFileNameW) > 0) then begin
      Exit;
    end
    else lstrcpyA(@szInfomation,@szFileNameW);
    lstrcatA(@szInfomation,'.dd64');
    lstrcatA(@x64dir,PAnsiChar(ExtractFileName(string(szInfomation))));
    ZeroMemory(@szInfomation,SizeOf(szInfomation));
    lstrcatA(@szInfomation,@x64dir);
    if DeleteFileA(@szInfomation) then begin
      _plugin_logprintf('CleanupExEx: Deleted file : %s', @szInfomation);
      Result:= True;
    end;
  end;
End;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function DeleteFilesProc(DelType: LongInt): Boolean;
var
  wfd: WIN32_FIND_DATAA;
  hsnapshot: THandle;
  szFileNameA:array[0..MAX_PATH-1] of CHAR;
  szExtensionNameA:array[0..MAX_PATH-1] of CHAR;
  szExtensionNameBuffA:array[0..31] of CHAR;
  n,DelDataCt,i: LongInt;
  datadir:array[0..MAX_PATH-1] of Char;
  x64dir:array[0..MAX_PATH-1] of Char;
Begin
  Result:= False;
  DelDataCt:= 0;
  ZeroMemory(@x64dir,SizeOf(x64dir));
  ZeroMemory(@datadir,SizeOf(datadir));
  ZeroMemory(@szFileNameA,SizeOf(szFileNameA));
  ZeroMemory(@szExtensionNameA,SizeOf(szExtensionNameA));
  ZeroMemory(@szExtensionNameBuffA,SizeOf(szExtensionNameBuffA));
  ZeroMemory(@wfd,SizeOf(wfd));

  GetModuleFileNameA(GetModuleHandleA(nil),@x64dir,MAX_PATH);
  for i:= lstrlenA(@x64dir) downto 0 do begin
    if x64dir[i] <> '\' then x64dir[i]:= #0
    else begin
      x64dir[i]:= #0;
      Break;
    end;
  end;
  // Get UDD path and backslash
  lstrcatA(@datadir,@x64dir);
  lstrcatA(@datadir,'\db\');
  // Case Delete data type
  case DelType of
    1:begin
      // All ollydbg data
      lstrcatA(@szExtensionNameA,@datadir);
      lstrcatA(@szExtensionNameA,'*.*');
    end;
    2:begin
      // All Debug data
      lstrcatA(@szExtensionNameA,@datadir);
      lstrcatA(@szExtensionNameA,'*.dd32');
    end;
    3:begin
      // All Backup data
      lstrcatA(@szExtensionNameA,@datadir);
      lstrcatA(@szExtensionNameA,'*.dd64');
    end;
    4:begin
      // All Backup data
      //DeletelatestData;
    end;
	  5:begin
      // For Future (Edit extentions(XXX))
      //Stringfromini('CleanupExEx','Extension',szExtensionNameBuffW,TEXTLEN);
      lstrcatA(@szExtensionNameA,@datadir);
      lstrcatA(@szExtensionNameA,'*.xxxx');
    end;
  end;
  if 6 = MessageBoxA(GuiGetWindowHandle,'Are you sure you want to delete all x64_dbg data ?','Confirm!',MB_ICONQUESTION + MB_YESNO) then begin
    hSnapshot:= FindFirstFileA(@szExtensionNameA,wfd);
    Try
      if (hSnapshot <> INVALID_HANDLE_VALUE) then begin
        lstrcatA(@szFileNameA,@datadir);
        lstrcatA(@szFileNameA,wfd.cFileName);
        if not(DeleteFileA(@szFileNameA)) then
          _plugin_logprintf('Failed to delete the file: %s',wfd.cFileName)
        else Inc(DelDataCt);
        ZeroMemory(@szFileNameA,SizeOf(szFileNameA));
        while FindNextFileA(hSnapshot,wfd) do begin
          lstrcatA(@szFileNameA,@datadir);
          lstrcatA(@szFileNameA,wfd.cFileName);
          if not(DeleteFileA(@szFileNameA)) then
           _plugin_logprintf('Failed to delete the file: %s',wfd.cFileName)
          else Inc(DelDataCt);
          ZeroMemory(@szFileNameA,SizeOf(szFileNameA));
        end;
        _plugin_logprintf('CleanupExEx Deleted: %i Files!',DelDataCt);
      end
      else begin
        _plugin_logprintf('WARNING: File Not Found!');
      end;
      Result:= True;
    except
      Result:= False;
    end;
  end;
End;

end.