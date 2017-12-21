function New-Tenant {
	<#
		.SYNOPSIS
			Creates a new tentant on an Octopus Deploy server
		.DESCRIPTION
			Verifies that an existing tenant with the same name does not already exist, and then proceeds to create a new tenant on the specified Octopus Deploy server.
		.PARAMETER Name
			The name of the tenant to create
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
		[string]$APIKey,

		[Parameter(Mandatory=$true)]
		[string]$Name
	)
	
	$ErrorActionPreference = "Stop"
	
	#validate tenant does not already exist
	if ( Get-OctoTenant -Server $Server -APIKey $APIKey | Where-Object { $_.Name -eq $Name } ) {
		throw "Specified tenant already exists! ($Name)"
	} else {
		Write-Verbose "Validated tenant does not already exist. ($Name)"
	}

	[uri]$uri = "$Server/api/tenants"
	Write-Verbose "URI: $($uri.AbsoluteUri)"
	$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	$body = @{ Name = $name } | ConvertTo-Json -Compress
	$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers -Method Post -Body $body
	Write-Debug "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
	Write-Output $result
}