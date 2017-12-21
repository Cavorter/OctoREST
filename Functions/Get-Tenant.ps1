function Get-Tenant {
	<#
		.SYNOPSIS
			Retrieves one or more tenant objects from an Octopus Deploy server.
		.DESCRIPTION
			Connects to an Octopus Deploy server and retrieves one or tenant objects depending on if the Id parameter is specified. If not specified returns all tenants. If specified returns only the specified tenant.
			Implements the GET method for the /api/tenants endpoint.
		.PARAMETER Id
			The ID of a tenant to retrieve
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view tenant information
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
	[uri]$uri = "$Server/api/tenants/$Id"
	Write-Verbose "URI: $($uri.AbsoluteUri)"
	$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers
	Write-Debug "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
	Write-Output $result
}