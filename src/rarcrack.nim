import rarlib, os
{.passL:"-lunrar".}

proc fprintf(f: File, frmt: cstring): cint {.
  importc: "fprintf", header: "<stdio.h>", varargs, discardable.}
proc printf(frmt: cstring): cint {.
  importc: "printf", header: "<stdio.h>", varargs, discardable.}

proc main() =
  var rarOpen: RAROpenArchiveData
  var rarHeader: RARHeaderData

  var
    rr: cint


  echo """                          
                                    _             
  _ __ __ _ _ __ ___ _ __ __ _  ___| | _____ _ __ 
 | '__/ _` | '__/ __| '__/ _` |/ __| |/ / _ \ '__|
 | | | (_| | | | (__| | | (_| | (__|   <  __/ |   
 |_|  \__,_|_|  \___|_|  \__,_|\___|_|\_\___|_|   
                                                  
  _          __   __       
 | |__ _  _  \ \ / /_ _ ___
 | '_ \ || |  \ V / _` |_ /
 |_.__/\_, |   |_|\__,_/__|
       |__/                
""" 


  if(paramCount() != 2):
    fprintf(stderr, "usage: %s <rarfile> <dictionary>\n", paramStr(0))
    quit(-1)

  rarOpen.ArcName = paramStr(1);
  rarOpen.OpenMode = RAR_OM_EXTRACT;
  rarOpen.CmtBuf = nil;
  rarOpen.CmtBufSize = 0;
  rarHeader.CmtBuf = nil;
  rarHeader.CmtBufSize = 0;

  var hArchData = RAROpenArchive(rarOpen.addr);

  if (hArchData == 0): 
    fprintf(stderr, "[-] failed to open %s\n", paramStr(1));
    quit(-1);
  

  var 
    f: File
    line: string
  if(f.open(paramStr(2))):
    while f.readLine(line):
      RARSetPassword(hArchData, line);
      rr = RARReadHeader(hArchData, rarHeader.addr);
      if (rr == 0):
        rr = RARProcessFile(hArchData, RAR_TEST, nil, nil);
      if (rr == 0): 
        printf("[+] Password cracked: '%s'\n", line);
        break;
      discard RARCloseArchive(hArchData);
      hArchData = RAROpenArchive(rarOpen.addr);

    f.close
    echo "[!] No more passwords"
  else:
    echo "[-] Could not open dictionary file"
  

main()

