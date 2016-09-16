property textSignatureName : "Company Standard"
set textPlaceholderName to "PlaceholderUserName"
set textPlaceholderJobTitle to "PlaceholderUserJobTitle"
set textPlaceholderEmail to "PlaceholderUserEmailAddress"


set textHtmlSignatureTemplateUrl to "http://seesolve.com/words/wp-content/uploads/2013/06/html_sig.html"
set textUserLibraryFolderPath to (path to library folder from user domain) as text
set textMailSignaturesFolderPath to textUserLibraryFolderPath & "Mail:V2:MailData:Signatures:"
set textMailSignaturesIcloudFolderPath to textUserLibraryFolderPath & "Mobile Documents:com~apple~mail:Data:MailData:Signatures:"


property textButtonOkay : "Okay"
property textButtonCancel : "Cancel"


tell application "System Events" to set textUserName to full name of current user



--
-- Setup, checks, and preparation: internet connection, OS version, GUI scripting,
-- and checking for open dialog windows in Mail, which can prevent processing
--
if my subTestForInternetConnection() is false then
	display dialog "Internet inaccessible." & return & "Please check your connection and run script again." buttons {textButtonOkay} default button textButtonOkay cancel button textButtonOkay with title "Internet Unavailable"
end if


set textOSVersion to system version of (system info)

considering numeric strings
	if (textOSVersion > 10.6) and (textOSVersion < 10.12) then
		-- set an indicator for Lion, as it uses a different signature file format
		if (textOSVersion starts with "10.7") then
			set boolVersionLion to true
		else
			set boolVersionLion to false
		end if
		
		-- notify user this script is not tested on Mavericks
		if (textOSVersion starts with "10.9") then
			display dialog "This script has not been tested on 10.9 (Mavericks) but may work on it. Use with caution." & return & return & "Report any issues to https://github.com/seesolve/CreateHtmlEmailSignature/issues" buttons {textButtonOkay} default button textButtonOkay cancel button textButtonOkay with title "Use With Caution" with icon caution
		end if
	else
		display dialog "You are using OS" & space & textOSVersion & ". This script is configured to run on 10.7, 10.8, 10.10 and 10.11 (Lion, Mountain Lion, Yosemite and El Capitan). This script has not been tested on 10.9 (Mavericks) but may work on it." & return & return & "This script will now quit." buttons {textButtonOkay} default button textButtonOkay cancel button textButtonOkay with title "Script Quitting"
	end if
end considering


my subCheckGuiScriptingEnabled()


my subMailSignaturesPrefsOpen()
my subMailSignaturesPrefsWindowCheck()



--
-- Ask user for user's name, job title, and email address.
--
set textUserName to text returned of (display dialog "Please enter your name, as you would like it to appear in your email signature" default answer textUserName buttons {textButtonCancel, textButtonOkay} default button textButtonOkay cancel button textButtonCancel with title "Enter User's Name")
	
set textUserEmail to text returned of (display dialog "Please enter the email address you would like to use in your email signature" default answer "" buttons {textButtonCancel, textButtonOkay} default button textButtonOkay cancel button textButtonCancel with title "Enter User's Email Address")
	
set textUserJobTitle to text returned of (display dialog "Please enter the job title you would like displayed in your email signature" default answer "" buttons {textButtonCancel, textButtonOkay} default button textButtonOkay cancel button textButtonCancel with title "Enter User's Job Title")




--
-- Create placeholder signature in Mail via GUI scripting
--
tell application "Mail"
	activate
	
	-- delete any previous company standard signatures created 
	delete (every signature whose name is textSignatureName)
end tell
delay 3


-- create signature
my subMailSignaturesPrefsSet()



--
-- Quit Mail (needed to enable changes to signature files are saved)
-- 
tell application "Mail"
	quit
end tell



--
-- Process HTML signature file, replacing placeholder text with user info
--
set textHtmlSignature to do shell script "curl" & space & textHtmlSignatureTemplateUrl

repeat with listPlaceholdersAndUserInfo in {{textPlaceholderName, textUserName}, {textPlaceholderJobTitle, textUserJobTitle}, {textPlaceholderEmail, textUserEmail}}
	set numPlaceholderTextOffset to offset of (item 1 of listPlaceholdersAndUserInfo) in textHtmlSignature
	
	set textHtmlSignature to text 1 thru (numPlaceholderTextOffset - 1) in textHtmlSignature & item 2 of listPlaceholdersAndUserInfo & text (numPlaceholderTextOffset + (length of (item 1 of listPlaceholdersAndUserInfo))) thru -1 in textHtmlSignature
end repeat



--
-- Create or modify mail signature file: 
-- for 10.7, file is created; for 10.8, file is modified
--
if boolVersionLion is true then
	set textMailSignatureFileNameExtension to "webarchive"
else
	set textMailSignatureFileNameExtension to "mailsignature"
end if


tell application "Finder"
	set listMailSignatures to every file of alias textMailSignaturesFolderPath whose name ends with textMailSignatureFileNameExtension
	
	if exists alias textMailSignaturesIcloudFolderPath then
		set listMailSignatures to (every file of alias textMailSignaturesIcloudFolderPath whose name ends with textMailSignatureFileNameExtension)
	end if
	
	set aliasMailSignature to item 1 of (sort listMailSignatures by creation date) as alias
	
	if boolVersionLion is true then
		set textMailSignaturePosixPath to POSIX path of aliasMailSignature
	end if
end tell


if boolVersionLion is false then
	set numOffsetTextBegin to (offset of (linefeed & linefeed & "<") in (read aliasMailSignature)) + 2
	
	open for access aliasMailSignature with write permission
	write textHtmlSignature to aliasMailSignature starting at numOffsetTextBegin
	close access aliasMailSignature
end if


if boolVersionLion is true then
	do shell script "echo" & space & quoted form of textHtmlSignature & space & "|" & space & ¬
		"textutil" & space & "-stdin" & space & "-format html" & space & "-convert webarchive" & space & "-output" & space & quoted form of textMailSignaturePosixPath
end if



--
-- Instructions to user to signature check
--
tell application "Finder"
	activate
	display dialog "Mail will now re-open to the signature pane." & return & return & "Please check your signature. Images may not display in the signature pane, but will display in your email message." & return & return & "Run script again to correct errors in the signature." buttons {textButtonOkay} default button textButtonOkay with title "Instructions"
end tell


tell application "Mail" to activate
delay 3

my subMailSignaturesPrefsOpen()



--
-- Handler to test for active internet connection
--
on subTestForInternetConnection()
	repeat 5 times -- many times as you like
		try -- pinging google
			set textPingResults to do shell script "/sbin/ping -c1 google.com"
		on error
			try -- pinging yahoo
				set textPingResults to do shell script "/sbin/ping -c1 yahoo.com"
			on error
				return false
			end try
		end try
		if textPingResults does not contain "1 packets transmitted, 1 packets received, 0% packet loss" then return true
	end repeat
end subTestForInternetConnection



--
-- Handler to enable GUI scripting
--
on subCheckGuiScriptingEnabled()
	tell application "System Events"
		activate -- brings System Events authentication dialog to front
		
		if UI elements enabled is false then
			set textButtonOkay to "Authenticate"
			
			display dialog "The script requires GUI scripting to be enabled." & return & "Please authenticate, or cancel script and contact your system administrator." buttons {textButtonCancel, textButtonOkay} default button textButtonOkay cancel button textButtonCancel with title "Enable GUI Scripting"
			
			set UI elements enabled to true
			return UI elements enabled
		end if
	end tell
end subCheckGuiScriptingEnabled



--
-- Handler to open Signatures preferences
--
on subMailSignaturesPrefsOpen()
	tell application "System Events"
		-- sometimes, despite activating Mail and waiting, Mail stays in the background; the following line brings Mail to the front, which is needed for the GUI scripting to work correctly
		set frontmost of application process "Mail" to true
		delay 2
		
		
		tell application process "Mail"
			-- open preferences and wait a few seconds, in case of processing delays
			keystroke "," using command down
			delay 3
			
			-- add new signature
			tell window 1
				click button "Signatures" of tool bar 1
				delay 2
			end tell
		end tell
	end tell
end subMailSignaturesPrefsOpen



--
-- Handler to check that opening Signatures preferences was successful
--
on subMailSignaturesPrefsWindowCheck()
	tell application "System Events"
		tell application process "Mail"
			if title of window 1 is not "Signatures" then
				display dialog "Signatures preferences window did not open. Please dismiss any open dialog windows in Mail and run script again. Contact your system administrator if this message displays and there are no open dialog windows." buttons {textButtonCancel} default button textButtonCancel cancel button textButtonCancel with title "Window Check"
			end if
		end tell
	end tell
end subMailSignaturesPrefsWindowCheck



--
-- Handler to set Signatures preferences
--
on subMailSignaturesPrefsSet()
	tell application "System Events"
		-- sometimes, despite activating Mail and waiting, Mail stays in the background; the following line brings Mail to the front, which is needed for the GUI scripting to work correctly
		set frontmost of application process "Mail" to true
		delay 2
		
		
		tell application process "Mail"
			tell window 1
				click button 1 of group 1 of splitter group 1 of group 1 of group 1
				delay 1.2
				
				keystroke textSignatureName
				delay 0.5
				keystroke return
				delay 1.2
				
				-- the 'click at' command refused to work (aargh), so we're changing the focus to enter placeholder text into the signature, so a signature file is created in Finder
				tell scroll area 3 of splitter group 1 of group 1 of group 1 to set focused to true
				delay 1.2
				
				keystroke "Placeholder"
				delay 1.2
				
				keystroke "w" using command down
				delay 3
			end tell
		end tell
	end tell
end subMailSignaturesPrefsSet
