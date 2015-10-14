#include <windows.h>
#include <inttypes.h>
#include <stdio.h>

static int do_CreateFile(int argc, wchar_t **argv);
static int do_CreateDirectory(int argc, wchar_t **argv);
static int do_GetFileInformation(int argc, wchar_t **argv);

static void fail(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    fputs("\n", stderr);
    exit(1);
}

#define SYM(n)							{ L#n, n }
struct sym
{
	const wchar_t *name;
	DWORD value;
};
struct sym symtab[] =
{
	SYM(GENERIC_ALL),
	SYM(GENERIC_EXECUTE),
	SYM(GENERIC_READ),
	SYM(GENERIC_WRITE),
    SYM(FILE_SHARE_READ),
    SYM(FILE_SHARE_WRITE),
    SYM(FILE_SHARE_DELETE),
    SYM(CREATE_ALWAYS),
    SYM(CREATE_NEW),
    SYM(OPEN_ALWAYS),
    SYM(OPEN_EXISTING),
    SYM(TRUNCATE_EXISTING),
    SYM(FILE_ATTRIBUTE_READONLY),
    SYM(FILE_ATTRIBUTE_HIDDEN),
    SYM(FILE_ATTRIBUTE_SYSTEM),
    SYM(FILE_ATTRIBUTE_DIRECTORY),
    SYM(FILE_ATTRIBUTE_ARCHIVE),
    SYM(FILE_ATTRIBUTE_DEVICE),
    SYM(FILE_ATTRIBUTE_NORMAL),
    SYM(FILE_ATTRIBUTE_TEMPORARY),
    SYM(FILE_ATTRIBUTE_SPARSE_FILE),
    SYM(FILE_ATTRIBUTE_REPARSE_POINT),
    SYM(FILE_ATTRIBUTE_COMPRESSED),
    SYM(FILE_ATTRIBUTE_OFFLINE),
    SYM(FILE_ATTRIBUTE_NOT_CONTENT_INDEXED),
    SYM(FILE_ATTRIBUTE_ENCRYPTED),
    SYM(FILE_ATTRIBUTE_INTEGRITY_STREAM),
    SYM(FILE_ATTRIBUTE_VIRTUAL),
    SYM(FILE_ATTRIBUTE_NO_SCRUB_DATA),
    SYM(FILE_ATTRIBUTE_EA),
};
static int symcmp(const void *p1, const void *p2)
{
	const struct sym *sym1 = (const struct sym *)p1;
	const struct sym *sym2 = (const struct sym *)p2;
	return wcscmp(sym1->name, sym2->name);
}
static void syminit(void)
{
    qsort(symtab, sizeof symtab / sizeof symtab[0], sizeof symtab[0], symcmp);
}
static struct sym *symget(const wchar_t *name)
{
    struct sym symkey = { .name = name };
    return bsearch(&symkey, symtab, sizeof symtab / sizeof symtab[0], sizeof symtab[0], symcmp);
}
static DWORD symval(const wchar_t *name)
{
    DWORD value = 0;
    while (name[0])
    {
        wchar_t part[128], *endp;
        endp = wcschr(name, L'+');
        if (0 == endp)
            endp = (wchar_t *)name + wcslen(name);
        if (endp - name >= sizeof part)
            fail("invalid constant %S", name);
        memcpy(part, name, (endp - name) * sizeof(wchar_t));
        part[endp - name] = L'\0';
        name = *endp ? endp + 1 : endp;
        value += wcstoul(part, &endp, 0);
        if (L'\0' != *endp)
        {
            struct sym *sym = symget(part);
            if (0 == sym)
                fail("unknown symbol %S", part);
            value += sym->value;
        }
    }
    return value;
}

#define API(n)							{ L#n, do_##n }
struct api
{
    const wchar_t *name;
    int (*fn)(int argc, wchar_t **argv);
};
struct api apitab[] =
{
    API(CreateFile),
    API(CreateDirectory),
    API(GetFileInformation),
};
static int apicmp(const void *p1, const void *p2)
{
	const struct api *api1 = (const struct api *)p1;
	const struct api *api2 = (const struct api *)p2;
	return wcscmp(api1->name, api2->name);
}
static void apiinit(void)
{
    qsort(apitab, sizeof apitab / sizeof apitab[0], sizeof apitab[0], apicmp);
}
static struct api *apiget(const wchar_t *name)
{
    struct api apikey = { .name = name };
    return bsearch(&apikey, apitab, sizeof apitab / sizeof apitab[0], sizeof apitab[0], apicmp);
}

#define ERR(n)							{ L#n, n }
struct err
{
	const wchar_t *name;
	DWORD value;
};
struct err errtab[] =
{
    ERR(ERROR_SUCCESS),
    ERR(ERROR_INVALID_FUNCTION),
    ERR(ERROR_FILE_NOT_FOUND),
};
static int errcmp(const void *p1, const void *p2)
{
	const struct err *err1 = (const struct err *)p1;
	const struct err *err2 = (const struct err *)p2;
	return (int)err1->value - (int)err2->value;
}
static void errinit(void)
{
    qsort(errtab, sizeof errtab / sizeof errtab[0], sizeof errtab[0], errcmp);
}
static struct err *errget(DWORD value)
{
    struct err errkey = { .value = value };
    return bsearch(&errkey, errtab, sizeof errtab / sizeof errtab[0], sizeof errtab[0], errcmp);
}
static const wchar_t *errstr(DWORD value)
{
    struct err *err = errget(value);
    if (0 != err)
        return err->name;
    static wchar_t errbuf[64];
    _snwprintf(errbuf, sizeof errbuf, L"ERROR(%u)", (unsigned)value);
    return errbuf;
}
static void errprint(int success)
{
    if (success)
        printf("0\n");
    else
        printf("%S\n", errstr(GetLastError()));
}

static int do_CreateFile(int argc, wchar_t **argv)
{
    if (argc != 8)
        fail("prototype:\n"
            "  HANDLE WINAPI CreateFile(\n"
            "    _In_     LPCTSTR               lpFileName,\n"
            "    _In_     DWORD                 dwDesiredAccess,\n"
            "    _In_     DWORD                 dwShareMode,\n"
            "    _In_opt_ LPSECURITY_ATTRIBUTES lpSecurityAttributes,\n"
            "    _In_     DWORD                 dwCreationDisposition,\n"
            "    _In_     DWORD                 dwFlagsAndAttributes,\n"
            "    _In_opt_ HANDLE                hTemplateFile\n"
            "  );");
    HANDLE h = CreateFileW(argv[1], symval(argv[2]), symval(argv[3]), 0, symval(argv[5]), symval(argv[6]), 0);
    errprint(INVALID_HANDLE_VALUE != h);
    return 0;
}
static int do_CreateDirectory(int argc, wchar_t **argv)
{
    if (argc != 3)
        fail("prototype:\n"
            "  BOOL WINAPI CreateDirectory(\n"
            "    _In_     LPCTSTR               lpPathName,\n"
            "    _In_opt_ LPSECURITY_ATTRIBUTES lpSecurityAttributes\n"
            "  );");
    BOOL r = CreateDirectoryW(argv[1], 0);
    errprint(r);
    return 0;
}
static const char *fileinfo_str(char *cbuf, size_t cbufsize,
    LPBY_HANDLE_FILE_INFORMATION FileInfo)
{
    char btimebuf[32], atimebuf[32], mtimebuf[32];
    SYSTEMTIME systime;
    FileTimeToSystemTime(&FileInfo->ftCreationTime, &systime);
    snprintf(btimebuf, sizeof btimebuf, "%d-%02d-%02dT%02d:%02d:%02dZ",
        systime.wYear, systime.wMonth, systime.wDay,
        systime.wHour, systime.wMinute, systime.wSecond);
    FileTimeToSystemTime(&FileInfo->ftLastAccessTime, &systime);
    snprintf(atimebuf, sizeof atimebuf, "%d-%02d-%02dT%02d:%02d:%02dZ",
        systime.wYear, systime.wMonth, systime.wDay,
        systime.wHour, systime.wMinute, systime.wSecond);
    FileTimeToSystemTime(&FileInfo->ftLastWriteTime, &systime);
    snprintf(mtimebuf, sizeof mtimebuf, "%d-%02d-%02dT%02d:%02d:%02dZ",
        systime.wYear, systime.wMonth, systime.wDay,
        systime.wHour, systime.wMinute, systime.wSecond);
    snprintf(cbuf, cbufsize, "{FileAttributes=%" PRIx32 ", "
        "CreationTime=%s, LastAccessTime=%s, LastWriteTime=%s, "
        "VolumeSerialNumber=%" PRIx32 ", FileSize=%" PRIu64 ", NumberOfLinks=%u, FileIndex=%#" PRIx64 "}",
        FileInfo->dwFileAttributes,
        btimebuf, atimebuf, mtimebuf,
        FileInfo->dwVolumeSerialNumber,
        ((uint64_t)FileInfo->nFileSizeHigh << 32) | (uint64_t)FileInfo->nFileSizeLow,
        FileInfo->nNumberOfLinks,
        ((uint64_t)FileInfo->nFileIndexHigh << 32) | (uint64_t)FileInfo->nFileIndexLow);
    return cbuf;
}
static int do_GetFileInformation(int argc, wchar_t **argv)
{
    if (argc != 2)
        fail("usage: GetFileInformation FileName");
    HANDLE h = CreateFileW(argv[1],
        FILE_READ_ATTRIBUTES, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
        0, OPEN_EXISTING, FILE_FLAG_OPEN_REPARSE_POINT | FILE_FLAG_BACKUP_SEMANTICS, 0);
    if (INVALID_HANDLE_VALUE == h)
        errprint(0);
    else
    {
        BY_HANDLE_FILE_INFORMATION info;
        BOOL r = GetFileInformationByHandle(h, &info);
        if (r)
        {
            char cbuf[512];
            printf("0 %s", fileinfo_str(cbuf, sizeof cbuf, &info));
        }
        else
            errprint(0);
        CloseHandle(h);
    }
    return 0;
}
static void usage()
{
    fail("usage: winfstest ApiName args...");
}
int wmain(int argc, wchar_t **argv)
{
    syminit();
    apiinit();
    errinit();
    if (argc < 2)
        usage();
    struct api *api = apiget(argv[1]);
    if (0 == api)
        fail("cannot find API %S", argv[1]);
	return api->fn(argc - 1, argv + 1);
}
