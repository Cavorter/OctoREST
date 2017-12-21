function Get-TenantVariables {
	<#
		.SYNOPSIS
			Retrieves the variable set for a particular tenant on an Octopus Deploy instance
		.DESCRIPTION
			Retrieves the variable set for a particular tenant on an Octopus Deploy instance.
		.PARAMETER Tenant
			The ID of the tenant
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view tenant information
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
		[string]$Tenant,
		
		[Parameter(Mandatory=$true)]
		[string]$Server,
		
		[Parameter(Mandatory=$true)]
		[string]$APIKey
	)
	[uri]$uri = "$Server/api/tenants/$Tenant/variables"
	Write-Verbose "URI: $($uri.AbsoluteUri)"
	$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers
	Write-Verbose "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
	Write-Output $result
}