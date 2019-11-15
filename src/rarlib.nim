const
  ERAR_SUCCESS* = 0
  ERAR_END_ARCHIVE* = 10
  ERAR_NO_MEMORY* = 11
  ERAR_BAD_DATA* = 12
  ERAR_BAD_ARCHIVE* = 13
  ERAR_UNKNOWN_FORMAT* = 14
  ERAR_EOPEN* = 15
  ERAR_ECREATE* = 16
  ERAR_ECLOSE* = 17
  ERAR_EREAD* = 18
  ERAR_EWRITE* = 19
  ERAR_SMALL_BUF* = 20
  ERAR_UNKNOWN* = 21
  ERAR_MISSING_PASSWORD* = 22
  ERAR_EREFERENCE* = 23
  ERAR_BAD_PASSWORD* = 24
  RAR_OM_LIST* = 0
  RAR_OM_EXTRACT* = 1
  RAR_OM_LIST_INCSPLIT* = 2
  RAR_SKIP* = 0
  RAR_TEST* = 1
  RAR_EXTRACT* = 2
  RAR_VOL_ASK* = 0
  RAR_VOL_NOTIFY* = 1
  RAR_DLL_VERSION* = 6
  RAR_HASH_NONE* = 0
  RAR_HASH_CRC32* = 1
  RAR_HASH_BLAKE2* = 2

when not defined(Windows):
  const
    CALLBACK* = true
    PASCAL* = true
  type
    LONG* = clong
    HANDLE* = int
    LPARAM* = clong
    UINT* = cuint
const
  RHDF_SPLITBEFORE* = 0x00000001
  RHDF_SPLITAFTER* = 0x00000002
  RHDF_ENCRYPTED* = 0x00000004
  RHDF_SOLID* = 0x00000010
  RHDF_DIRECTORY* = 0x00000020

type
  RARHeaderData* {.bycopy.} = object
    ArcName*: array[260, char]
    FileName*: array[260, char]
    Flags*: cuint
    PackSize*: cuint
    UnpSize*: cuint
    HostOS*: cuint
    FileCRC*: cuint
    FileTime*: cuint
    UnpVer*: cuint
    Method*: cuint
    FileAttr*: cuint
    CmtBuf*: cstring
    CmtBufSize*: cuint
    CmtSize*: cuint
    CmtState*: cuint

type
  RARHeaderDataEx* {.bycopy.} = object
    ArcName*: array[1024, char]
    ArcNameW*: array[1024, uint16]
    FileName*: array[1024, char]
    FileNameW*: array[1024, uint16]
    Flags*: cuint
    PackSize*: cuint
    PackSizeHigh*: cuint
    UnpSize*: cuint
    UnpSizeHigh*: cuint
    HostOS*: cuint
    FileCRC*: cuint
    FileTime*: cuint
    UnpVer*: cuint
    Method*: cuint
    FileAttr*: cuint
    CmtBuf*: cstring
    CmtBufSize*: cuint
    CmtSize*: cuint
    CmtState*: cuint
    DictSize*: cuint
    HashType*: cuint
    Hash*: array[32, char]
    Reserved*: array[1014, cuint]


type
  RAROpenArchiveData* {.bycopy.} = object
    ArcName*: cstring
    OpenMode*: cuint
    OpenResult*: cuint
    CmtBuf*: cstring
    CmtBufSize*: cuint
    CmtSize*: cuint
    CmtState*: cuint

type UNRARCALLBACK = (proc(msg: UINT, UserData: LPARAM, P1: LPARAM, P2: LPARAM): cint)

type
    RAROpenArchiveDataEx* {.bycopy.} = object
      ArcName*: cstring
      ArcNameW*: ptr uint16
      OpenMode*: cuint
      OpenResult*: cuint
      CmtBuf*: cstring
      CmtBufSize*: cuint
      CmtSize*: cuint
      CmtState*: cuint
      Flags*: cuint
      Callback*: UNRARCALLBACK
      UserData*: LPARAM
      Reserved*: array[28, cuint]


type
    UNRARCALLBACK_MESSAGES* = enum UCM_CHANGEVOLUME, UCM_PROCESSDATA, UCM_NEEDPASSWORD, UCM_CHANGEVOLUMEW, UCM_NEEDPASSWORDW
      
      
type CHANGEVOLPROC = (proc(ArcName: cstring, Mode: cint): cint)
type PROCESSDATAPROC = (proc(Addr: ptr cuchar , Size: cint): cint)


proc RAROpenArchive*(ArchiveData: ptr RAROpenArchiveData): HANDLE {.dynlib: "libunrar.so", importc.}
proc RAROpenArchiveEx*(ArchiveData: ptr RAROpenArchiveDataEx): HANDLE {.dynlib: "libunrar.so", importc.}
proc RARCloseArchive*(hArcData: HANDLE): cint {.dynlib: "libunrar.so", importc.}
proc RARReadHeader*(hArcData: HANDLE, HeaderData: ptr RARHeaderData): cint {.dynlib: "libunrar.so", importc.}
proc RARReadHeaderEx*(hArcData: HANDLE, HeaderData: ptr RARHeaderDataEx): cint {.dynlib: "libunrar.so", importc.}
proc RARProcessFile*(hArcData: HANDLE, Operation: cint; DestPath: cstring, DestName: cstring, TestMode: bool = false): cint {.dynlib: "libunrar.so", importc.}
proc RARProcessFileW*(hArcData: HANDLE, Operation: cint; DestPath: ptr uint16, DestName: ptr uint16, TestMode: bool = false): cint {.dynlib: "libunrar.so", importc.}
proc RARSetCallback*(hArcData: HANDLE, Callback: UNRARCALLBACK; UserData: LPARAM) {.dynlib: "libunrar.so", importc.}
proc RARSetChangeVolProc*(hArcData: HANDLE, ChangeVolProc: CHANGEVOLPROC) {.dynlib: "libunrar.so", importc.}
proc RARSetProcessDataProc*(hArcData: HANDLE, ProcessDataProc: PROCESSDATAPROC) {.dynlib: "libunrar.so", importc.}
proc RARSetPassword*(hArcData: HANDLE, Password: cstring) {.dynlib: "libunrar.so", importc.}
proc RARGetDllVersion*(): cint {.dynlib: "libunrar.so", importc.}