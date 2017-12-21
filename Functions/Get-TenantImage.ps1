function Get-TenantImage {
	<#
		.SYNOPSIS
			Retrieves the image associated with a Tenant
		.DESCRIPTION
			Uses the Octopus Deploy REST API to retrieve the logo image associated with a specific tenant.
		.PARAMETER Id
			The ID of a tenant to retrieve the image for
		.PARAMETER OutFile
			The name and path of where to save the image file. If not specified defaults to a file named "logo.png" in the current path.
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view tenant information
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
		[string]$Id,
		
		[Parameter(Mandatory=$false)]
		[string]$OutFile = ".\logo.png",
		
		[Parameter(Mandatory=$true)]
		[string]$Server,
		
		[Parameter(Mandatory=$true)]
		[string]$APIKey
	)
	
	Begin {
		[uri]$uri = "$Server/api/tenants/$Id/logo"
		Write-Verbose "URI: $($uri.AbsoluteUri)"
		$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
		Write-Verbose "OutFile: $OutFile"
	}
	
	Process {
		$result = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers -OutFile $OutFile
		Write-Output $result
	}
}