function Get-Status {
	<#
		.SYNOPSIS
			Retrieves the server status for the specified Octopus Deploy server.
		.DESCRIPTION
			Retrieves the server status for the specified Octopus Deploy server.
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view project information
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
		[string]$Server,
		
		[Parameter(Mandatory=$true)]
		[string]$APIKey
	)
	[uri]$uri = "$Server/api/serverstatus"
	Write-Verbose "URI: $($uri.AbsoluteUri)"
	$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers
	Write-Debug "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
	Write-Output $result
}