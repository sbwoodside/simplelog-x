/*
*   File:		browser_interface.h
*
*   Created:	17-10-2003
*   Author:		Lauri pesonen, Anygraaf Oy, Finland
*
*/

#ifndef _BROWSER_INTERFACE_H_
#define _BROWSER_INTERFACE_H_

#include <e32std.h>
#include <eikenv.h>
#include <apgtask.h>		// TApaTask, TApaTaskList
#include <eikdll.h>			// EikDll
#include <apgcli.h>			// RApaLsSession

const TUid KDorisBrowserUid = { 0x101F81A8 };

class CDorisBrowserInterface : public CBase
{
public:
		typedef enum {
			ENothing=0,
			EOpenURL_STRING,
			EHistoryBack,
			EOpenBookmark_INTEGER,
			ESelectOrOpenClick,
			EBookmarksPage,
			ENewBookmarkDialog,
			ENewBookmarkSelectedDialog,
			EEditBookmarksPage,
			EURLDialog,
			EViewScreenFull,
			EViewScreenNormal,
			EViewScreenToggle,
			EViewColorsAndBackgroundsShow,
			EViewColorsAndBackgroundsHide,
			EViewColorsAndBackgroundsToggle,
			EZoomSmaller,
			EZoomLarger,
			EZoomFitToScreen,
			EZoomExactFit,
			EZoomRealPixels,
			ELoadImagesAll,
			ELoadImagesVisible,
			ELoadImagesDiscardAll,
			EReload,
			EClearCookies,
			EClearCache,
			EEncodingAutomatic,
			EEncoding_STRING,
			EPreferencesDialog,
			EHelpAboutDialog,
			EHelpPage,
			EStopLoading,
			EHangUpConnection,
			EExit
		} TDorisCommand;

public:
		static CDorisBrowserInterface *NewL();
    static CDorisBrowserInterface *NewLC();
    ~CDorisBrowserInterface();

		TBool IsRunning();
		TBool GetAppFullPath( TDes &full_path );

		void AppendL( const TDorisCommand aCommand );
		void AppendL( const TDorisCommand aCommand, const TDesC &aParameter );
		void AppendL( const TDorisCommand aCommand, const TInt aIntpar );

		void ExecuteL();

		void Zero();

		void SendKey( TInt aKeyCode, TInt aModifiers );

private:
    CDorisBrowserInterface();
    void ConstructL();

		void ExecutePackedCommandLineL( const TDesC &docName );
		void StartAppIfNotRunningL();
		void StartAppIfNotRunningL( const TDesC &parameter );
		void SendCommandToRunningApp( const TDesC &docName );

		RApaLsSession iApaSession;

		TBuf<2048> *iPackedString;
};

#endif // _BROWSER_INTERFACE_H_
