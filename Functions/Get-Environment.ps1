function Get-Environment {
	<#
		.SYNOPSIS
			Retrieves one or more environment objects from an Octopus Deploy server.
		.DESCRIPTION
			Connects to an Octopus Deploy server and retrieves an array of environment objects if the Id parameter is not specified or a single object for an environment specified by the Id parameter.
			Implements the GET method for the /api/environments endpoint.
		.PARAMETER Id
			The ID of the project to retrieve
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view environment information
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$false)]
		[string]$Id = "all",
		
		[Parameter(Mandatory=$true)]
		[string]$Server,
		
		[Parameter(Mandatory=$true)]
		[string]$APIKey
	)
	[uri]$uri = "$Server/api/environments/$Id"
	Write-Verbose "URI: $($uri.AbsoluteUri)"
	$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers
	Write-Debug "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
	Write-Output $result
}