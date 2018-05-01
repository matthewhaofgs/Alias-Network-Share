try
	set mountedGeneralDiskName to "General"
	set generalDiskIsMounted to false
	set homeDiskIsMounted to false
	set generalVolumeName to "G Drive"
	set homeVolumeName to "H Drive"
	set networkAvailable to true
	tell application "System Events" to set currentUsername to name of current user
	tell application "System Events" to set diskNames to name of every disk
	set shellCommand to "dscl /Active\\ Directory/OFGS/All\\ Domains -read /Users/" & currentUsername & " homeDirectory | awk '{ print $2 }' | sed -e 's/<[^>]*>//g' | sed 's/\\\\/\\//g' "
	set networkHomePath to do shell script shellCommand
	set networkHomePath to "smb:" & networkHomePath
	
		if mountedGeneralDiskName is not in diskNames then
		mount volume "smb://i.ofgs.nsw.edu.au/dfs/General"
	end if
	
	if currentUsername is not in diskNames then
		mount volume networkHomePath
	end if
	tell application "Finder"
		delete (every item of folder (path to desktop folder) whose name is "H Drive")
		delete (every item of folder (path to desktop folder) whose name is "G Drive")
		
		if not (exists alias file generalVolumeName of (path to desktop folder)) then
			make new alias file to disk "General" at (path to desktop folder)
			set name of result to generalVolumeName
		end if
		if not (exists alias file homeVolumeName of (path to desktop folder)) then
			make new alias file to disk currentUsername at (path to desktop folder)
			set name of result to homeVolumeName
		end if
		
	end tell
on error e
	#display dialog e
end try
