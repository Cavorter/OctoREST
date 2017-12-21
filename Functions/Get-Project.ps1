function Get-Project {
	<#
		.SYNOPSIS
			Retrieves one or more project objects from an Octopus Deploy server.
		.DESCRIPTION
			Connects to an Octopus Deploy server and retrieves an array of project objects if the Id parameter is not specified, or a single object for a project if the ID parameter is specified.
			Implements the GET method for the /api/projects endpoint.
		.PARAMETER Id
			The Id or slug of a project to retrieve.
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view project information
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
	[uri]$uri = "$Server/api/projects/$Id"
	Write-Verbose "URI: $($uri.AbsoluteUri)"
	$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers
	Write-Debug "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
	Write-Output $result
}