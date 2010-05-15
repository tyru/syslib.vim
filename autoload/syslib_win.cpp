/* vim:ts=4:sw=4:sts=0:tw=0:set et: */
/*
 * syslib_win.cpp
 *
 * Written By: tyru <tyru.exe@gmail.com>
 * Last Change: 2010-05-14.
 *
 */

#include "common.c"

#include <windows.h>

#include <shlobj.h>



/* syslib functions */
int
syslib_get_current_errno(void)
{
    return GetLastError();
}

int
syslib_get_last_errno(void)
{
    return GetLastError();
}

int
syslib_remove_directory(const char *pathname)
{
    return RemoveDirectory(pathname);
}

int
syslib_create_symlink(const char *args)
{
    NodeArg *real_args = deserialize_args(args);
    return syslib_create_symlink_args(real_args->buf, real_args->next->buf);
}
static int
syslib_create_symlink_args(LPCSTR lpszPathObj, LPCSTR lpszPathLink)
{
    HRESULT hres;
    IShellLink* psl;

    // Get a pointer to the IShellLink interface.
    hres = CoCreateInstance(CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER,
                            IID_IShellLink, (LPVOID*)&psl);
    if (SUCCEEDED(hres))
    {
        IPersistFile* ppf;

        // Set the path to the shortcut target and add the description.
        psl->SetPath(lpszPathObj);

        // Query IShellLink for the IPersistFile interface for saving the
        // shortcut in persistent storage.
        hres = psl->QueryInterface(IID_IPersistFile, (LPVOID*)&ppf);

        if (SUCCEEDED(hres))
        {
            WCHAR wsz[MAX_PATH];

            // Ensure that the string is Unicode.
            MultiByteToWideChar(CP_ACP, 0, lpszPathLink, -1, wsz, MAX_PATH);

            // Add code here to check return value from MultiByteWideChar
            // for success.

            // Save the link by calling IPersistFile::Save.
            hres = ppf->Save(wsz, TRUE);
            ppf->Release();
        }
        psl->Release();
    }
    return static_cast<int>(hres);
}

int
syslib_create_hardlink(const char *args)
{
    // TODO Create symlink/hardlink not shortcut
    // on windows higher than Vista.
    return syslib_create_symlink(args);
}
static int
syslib_create_hardlink_args(const char *path, const char *hardlink_path)
{
    // TODO Create symlink/hardlink not shortcut
    // on windows higher than Vista.
    return syslib_create_symlink_args(path, hardlink_path);
}
