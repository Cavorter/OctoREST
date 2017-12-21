function Remove-Tenant {
	<#
		.SYNOPSIS
			Deletes a tenant from an Octopus Deploy server.
		.DESCRIPTION
			Connects to an Octopus Deploy server and deletes a tenant with the specified Id.
			Implements the Delete method for the /api/tenants endpoint.
		.PAREMETER Id
			The ID of a tenant to delete
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view tenant information
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
		[string]$Id,
		
		[Parameter(Mandatory=$true)]
		[string]$Server,
		
		[Parameter(Mandatory=$true)]
		[string]$APIKey
	)
	
	Begin {
		[uri]$uri = "$Server/api/tenants/$Id"
		Write-Verbose "URI: $($uri.AbsoluteUri)"
		$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	}
	
	Process {
		$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers -Method Delete
		Write-Verbose "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
		Write-Output $result
	}
}