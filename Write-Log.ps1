function Write-Log 
{ 

    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 

        [Parameter(Mandatory=$false)] 
        [Alias('Log')] 
        [string]$LogFilePath= 'c:\Temp\', 

        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 

        [Parameter(Mandatory=$false)] 
        [Alias('FileName')] 
        [string]$LogFileName= 'LogFile',

        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 

    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
       
        # $DateTime = Get-Date -Format 'MMddyy_HHmmss' 
        # $FileName = $DateTime + "_trfLog.log"
        # $FullPath= $LogPath  $DateTime + "_trfLog.log"

        $IDate = Get-Date -Format 'yyyy_MM_dd'

        $FullPath =  $LogFilePath + $LogFileName + '_' + $IDate + "_TrfLog.txt"
        # Write-Output $FileName
        # Write-Output $FullPath
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $FullPath) -AND $NoClobber) { 
            Write-Error "Log file $FullPath already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $FullPath)) { 
            Write-Verbose "Creating $FullPath." 
            $NewLogFile = New-Item $FullPath -Force -ItemType File 
            } 
        else { 
            # Nothing to see here yet. 
            } 

        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 

        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 

        # Write log entry to $LogPath 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $FullPath -Append 
    } 
    End 
    { 
    } 
}
