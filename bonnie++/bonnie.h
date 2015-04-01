#ifndef BONNIE
#define BONNIE

#define BON_VERSION "1.03d"

#include "conf.h"
#include "port.h"

#define SemKey 4711
#define NumSems TestCount
// million files (7) + up to 12 random extra chars
#define RandExtraLen (12)
#define MaxNameLen (7 + RandExtraLen)
// data includes index to which directory (6 bytes) and terminating '\0' for
// the name and pointer to file name
#define MaxDataPerFile (MaxNameLen + 6 + 1 + 4)
#define MinTime (0.5)
#define Seeks (8192)
#define UpdateSeek (10)
#define SeekProcCount (3)
#define DefaultChunkBits (13)
#define DefaultChunkSize (1 << DefaultChunkBits)
#define UnitBits (20)
#define Unit (1 << UnitBits)
#define CreateNameLen 6
#define DefaultFileSize 300
#define DirectoryUnit 1024
#define DefaultDirectorySize 16
#define DefaultDirectoryMaxSize 0
#define DefaultDirectoryMinSize 0
// 1024M per file for IO.
#define IOFileSize 1024
// 3 digits
#define MaxIOFiles 1000

typedef const char * PCCHAR;
typedef char * PCHAR;
typedef PCHAR const CPCHAR;
typedef PCCHAR const CPCCHAR;
typedef void * PVOID;
typedef PVOID const CPVOID;
typedef const CPVOID CPCVOID;

enum tests_t
{
  Putc = 0,
  FastWrite,
  ReWrite,
  Getc,
  FastRead,
  Lseek,
  CreateSeq,
  StatSeq,
  DelSeq,
  CreateRand,
  StatRand,
  DelRand,
  TestCount
};

int   io_error(CPCCHAR message, bool do_exit = false);
int bon_setugid(CPCCHAR user, CPCCHAR group, bool quiet);

#endif
