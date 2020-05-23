# ---------------------------------------------------------------------------------------------------
function Write-Log ([parameter(Mandatory = $true)][string]$msg,
                    [switch]$err, [switch]$warn,[switch]$deb)
# ---------------------------------------------------------------------------------------------------
{
    <#
    .Synopsis
    Writes a message to a logfile.

    .Description
    Writes a message to a logfile. In front of the message the current date and time is written.
	
    .Parameter msg
    Message wich will be written in the logfile
	
    .Parameter err
    If $err is present [ERROR][date,time] msg will be logged
	
    .Parameter warn
    If $warn is present [WARNING][date,time] msg will be logged

    #>

    if ($logfile -eq $null)
    {

        try { $logpath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "\logs\" } # => Script Directory\Logs
        catch { $logpath = "./logs" } # => Current Directory

        if (!(Test-Path $logpath -PathType Container))
        {
            # Create logs path below Current Directory
            New-Item $logpath -ItemType Directory | Out-Null
        }

        $logfile = Join-Path $logpath "TiersEnvironment.log"

    }  # end of if ($logfile -eq $null)

    if (Test-Path (Split-Path $logfile) -PathType Container)
    {
        # write message to log
	    if ($warn.isPresent)
	    {
            Write-EventLog -ComputerName $env:computername -LogName "Windows PowerShell" -Source "Tiering" -EntryType Warning -Message $msg -EventId "40001"
		    Write-Host "! $msg" -ForegroundColor Yellow
            $msg = "[{0}] {1}" -f "WARNING", $msg
            $msg = "[{0}] {1}" -f ((get-date).tostring()), $msg
		    $msg >> $logfile
	    }
	    elseif ($err.isPresent)
	    {
            Write-EventLog -ComputerName $env:computername -LogName "Windows PowerShell" -Source "Tiering" -EntryType Error -Message $msg -EventId "40002"
		    Write-Host "! $msg" -ForegroundColor Red
		    $msg = "[{0}] {1}" -f "ERROR  ", $msg
            $msg = "[{0}] {1}" -f ((get-date).tostring()), $msg
		    $msg >> $logfile
	    }
	    elseif ($deb.isPresent)
	    {
		    Write-Host "! $msg" -ForegroundColor Cyan
		    $msg = "[{0}] {1}" -f "Debug  ", $msg
            $msg = "[{0}] {1}" -f ((get-date).tostring()), $msg
		    $msg >> $logfile
	    }

	    else
	    {
            Write-EventLog -ComputerName $env:computername -LogName "Windows PowerShell" -Source "Tiering" -EntryType Information -Message $msg -EventId "40000"		    
            Write-Host $msg -ForegroundColor Green
		    $msg = "[{0}] {1}" -f "INFO   ", $msg
            $msg = "[{0}] {1}" -f ((get-date).tostring()), $msg
		    $msg >> $logfile
	    }
    }  

}  # end of function Write-Log
# ---------------------------------------------------------------------------------------------------