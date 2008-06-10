/*
*   File:		browser_interface.h
*
*   Created:	October 21, 2003
*   Author:		Lauri pesonen, Anygraaf Oy, Finland
*
*/

#include "doris_interface.h"

#pragma message("TODO: change the InfoWinL() calls depending on how you handle error situations.")

CDorisBrowserInterface *CDorisBrowserInterface::NewL()
{
    CDorisBrowserInterface *self = CDorisBrowserInterface::NewLC();
    CleanupStack::Pop();
    return self;
}

CDorisBrowserInterface *CDorisBrowserInterface::NewLC()
{
    CDorisBrowserInterface *self = new (ELeave) CDorisBrowserInterface();
    CleanupStack::PushL (self);
    self->ConstructL();
    return self;
}

void CDorisBrowserInterface::ConstructL()
{
	iPackedString = new (ELeave) TBuf<2048>;

	if( KErrNone != iApaSession.Connect() )
	{
		CEikonEnv::Static()->InfoWinL(_L("iApaSession.Connect() failed."),_L(""));
	}
}

CDorisBrowserInterface::CDorisBrowserInterface()
{
}

CDorisBrowserInterface::~CDorisBrowserInterface()
{
	delete iPackedString;
	iPackedString = NULL;

	iApaSession.Close();
}

void CDorisBrowserInterface::StartAppIfNotRunningL()
{
	StartAppIfNotRunningL( _L("") );
}

void CDorisBrowserInterface::StartAppIfNotRunningL( const TDesC &parameter )
{
	TFileName appName;

	if(!IsRunning() && GetAppFullPath(appName))
	{
		CApaCommandLine *cmdLine = CApaCommandLine::NewLC();
		cmdLine->SetLibraryNameL(appName);
		cmdLine->SetDocumentNameL(parameter);
		cmdLine->SetCommandL(EApaCommandRun);
		EikDll::StartAppL(*cmdLine);
		CleanupStack::PopAndDestroy();
	}
}

TBool CDorisBrowserInterface::IsRunning()
{
	TApaTaskList tlist( CCoeEnv::Static()->WsSession() );
	TApaTask task = tlist.FindApp( KDorisBrowserUid );
	return task.Exists();
}

void CDorisBrowserInterface::SendCommandToRunningApp( const TDesC &docName )
{
	TApaTaskList tlist( CCoeEnv::Static()->WsSession() );
	TApaTask task = tlist.FindApp( KDorisBrowserUid );
	if( task.Exists() )
	{
		task.BringToForeground();
		(void)task.SwitchOpenFile( docName );
	}
}

void CDorisBrowserInterface::SendKey( TInt aKeyCode, TInt aModifiers )
{
	TApaTaskList tlist( CCoeEnv::Static()->WsSession() );
	TApaTask task = tlist.FindApp( KDorisBrowserUid );
	if( task.Exists() )
	{
		// task.BringToForeground();
		task.SendKey( aKeyCode, aModifiers );
	}
}

void CDorisBrowserInterface::Zero()
{
	iPackedString->Zero();
}

void CDorisBrowserInterface::AppendL( const TDorisCommand aCommand )
{
	AppendL( aCommand, _L("") );
}

void CDorisBrowserInterface::AppendL( const TDorisCommand aCommand, const TInt aIntpar )
{
	TBuf<32> aParameter;
	aParameter.Format( _L("%d"), aIntpar );
	AppendL( aCommand, aParameter );
}

void CDorisBrowserInterface::AppendL( const TDorisCommand aCommand, const TDesC &aParameter )
{
	if( (aCommand == EEncoding_STRING || aCommand == EOpenURL_STRING) &&
			(aParameter.Length() == 0)
		)
	{
		CEikonEnv::Static()->InfoWinL(_L("This command requires a string parameter."),_L(""));
	} else {
		TBuf<32> asmallstr;
		asmallstr.Format( _L("<%d>"), aCommand );

		if( iPackedString->MaxLength() >= iPackedString->Length() + asmallstr.Length() )
		{
			iPackedString->Append( asmallstr );
		} else {
			CEikonEnv::Static()->InfoWinL(_L("Out of command buffer space."),_L(""));
		}

		if( iPackedString->MaxLength() >= iPackedString->Length() + aParameter.Length() )
		{
			iPackedString->Append( aParameter );
		} else {
			CEikonEnv::Static()->InfoWinL(_L("Out of command buffer space."),_L(""));
		}
	}
}

void CDorisBrowserInterface::ExecuteL()
{
	ExecutePackedCommandLineL( *iPackedString );
}

void CDorisBrowserInterface::ExecutePackedCommandLineL( const TDesC &docName )
{
	if(!IsRunning())
	{
		TFileName full_path;
		if(GetAppFullPath( full_path ))
		{
			StartAppIfNotRunningL(docName);
		}
	} else {
		SendCommandToRunningApp( docName );
	}
}

TBool CDorisBrowserInterface::GetAppFullPath( TDes &full_path )
{
	TBool ret = EFalse;

	TApaAppInfo browser_info;
	if( KErrNone == iApaSession.GetAppInfo( browser_info, KDorisBrowserUid ) )
	{
		if( full_path.MaxLength() >= browser_info.iFullName.Length() ) {
			full_path.Copy( browser_info.iFullName );
			ret = ETrue;
		}
	}
	return ret;
}
