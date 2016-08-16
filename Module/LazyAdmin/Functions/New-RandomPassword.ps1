###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  New-RandomPassword.ps1
# Autor        :  BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Generate passwords with a freely definable number of characters
# Repository   :  https://github.com/BornToBeRoot/PowerShell
###############################################################################################################

<#
    .SYNOPSIS
    Generate passwords with a freely definable number of characters

    .DESCRIPTION
	Generate passwords with a freely definable number of characters. You can also select which chars you want to use (upper case, lower case, numbers and special chars).

	.EXAMPLE
	New-RandomPassword -DisableSpecialChars

	Password
	--------
	8uUtzddG   

    .EXAMPLE
    New-RandomPassword -Length 6 -Count 10

	Count Password
	----- --------
		1 K5G+#E
		2 zXTpcr
		3 1A0D-3
		4 -eF*aR
		5 2GY]Hc
		6 eB-ukp
		7 &r54*h
		8 d%fz?=
		9 #lcEea
		10 4(Z$w*
		
    .LINK
    https://github.com/BornToBeRoot/PowerShell/blob/master/Documentation/New-RandomPassword.README.md
#>

function New-RandomPassword
{
	[CmdletBinding(DefaultParameterSetName='NoClipboard')]
	param(
		[Parameter(
			Position=0,
			HelpMessage='Length of the Password  (Default=8)')]
		[Int32]$Length=8,

		[Parameter(
			ParameterSetName='NoClipboard',
			Position=1,
			HelpMessage='Number of Passwords to be generated (Default=1)')]
		[Int32]$Count=1,

		[Parameter(
			ParameterSetName='Clipboard',
			Position=1,
			HelpMessage='Copy password to clipboard')]
		[switch]$CopyToClipboard,

		[Parameter(
			Position=2,
			HelpMessage='Use lower case characters (Default=$true')]
		[switch]$DisableLowerCase,

		[Parameter(
			Position=3,
			HelpMessage='Use upper case characters (Default=$true)')]
		[switch]$DisableUpperCase,
		
		[Parameter(
			Position=4,
			HelpMessage='Use upper case characters (Default=$true)')]
		[switch]$DisableNumbers,

		[Parameter(
			Position=5,
			HelpMessage='Use upper case characters (Default=$true)')]
		[switch]$DisableSpecialChars
	)

	Begin{

	}

	Process{
		if($Length -eq 0)
		{
			Write-Error -Message "Length of the password can not be 0... Check your input!" -Category InvalidArgument -ErrorAction Stop
		}

		if($Count -eq 0)
		{
			Write-Error -Message "Number of Passwords to be generated can not be 0... Check your input!" -Category InvalidArgument -ErrorAction Stop
		}
			
		$Character_LowerCase = "abcdefghiklmnprstuvwxyz"
		$Character_UpperCase = "ABCDEFGHKLMNPRSTUVWXYZ"
		$Character_Numbers = "0123456789"
		$Character_SpecialChars = "$%&/()=?+*#[]{}-_@"

		$Characters = [String]::Empty
			
		# Built string with characters
		if($DisableLowerCase -eq $false)
		{
			$Characters += $Character_LowerCase
		}

		if($DisableUpperCase -eq $false)
		{
			$Characters += $Character_UpperCase
		}

		if($DisableNumbers -eq $false)
		{
			$Characters += $Character_Numbers
		}
		
		if($DisableSpecialChars -eq $false)
		{
			$Characters += $Character_SpecialChars
		}
		
		if([String]::IsNullOrEmpty($Characters))
		{
			Write-Error -Message "Select at least 1 character set (lower case, upper case, numbers or special chars) to create a password." -Category InvalidArgument -ErrorAction Stop
		}

		for($i = 1; $i -ne $Count + 1; $i++)
		{
			$Password = [String]::Empty
					
			# Create random password
			while($Password.Length -lt $Length)
			{
				# Create random numbers
				$RandomNumber = Get-Random -Maximum $Characters.Length
				$Password += $Characters[$RandomNumber]
			}
			
			# Return result
			if($Count -eq 1)
			{
				# Set to clipboard
				if($CopyToClipboard)
				{
					Set-Clipboard -Value $Password
				}

				[pscustomobject] @{
					Password = $Password
				}
			}
			else 
			{
				[pscustomobject] @{
					Count = $i
					Password = $Password
				}	
			}
				
		}
	}

	End{
		
	}
}