function Add-OctoTenantToProject {
	<#
		.SYNOPSIS
			Associates a tenant with a project and environment on an Octopus Deploy server.
		.DESCRIPTION
			Creates an association with a Tenant and a specific project and environment.
		.PARAMETER Tenant
			ID or slug for a Tenant to add a project/environment to
		.PARAMETER Project
			ID or slug of the project to add to the Tenant.
		.PARAMETER Environment
			ID or slug of the environment to add to the project on the Tenant
		.PARAMETER Server
			The URI for an Octopus Deploy server
		.PARAMETER APIKey
			The API key for a user with the rights to view project information
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
		[string]$Tenant,
		
		[Parameter(Mandatory=$true)]
		[string]$Project,
		
		[Parameter(Mandatory=$true)]
		[string[]]$Environment,
		
		[Parameter(Mandatory=$true)]
		[string]$Server,
		
		[Parameter(Mandatory=$true)]
		[string]$APIKey
	)
	[uri]$uri = "$Server/api/tenants/$Tenant"
	Write-Verbose "URI: $($uri.AbsoluteUri)"
	$headers = @{ 'X-Octopus-ApiKey' = $APIKey }
	
	Write-Verbose "Reading existing tenant object.."
	$bodyObj = Invoke-RestMethod -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers
	# if project is already attached...
	if ( $bodyObj.ProjectEnvironments."$Project" ) {
		Write-Verbose "Appending $Environment to existing $Project entry"
		$bodyObj.ProjectEnvironments."$Project" += $Environment
	} else {
		Write-Verbose "Appending new entry for $project"
		# convert existing project entries to a hashtable
		$peObj = @{}
		foreach ( $projectObj in ( $bodyObj.ProjectEnvironments | Get-Member -MemberType NoteProperty ).Name ) {
			$peObj."$projectObj" = $bodyObj.ProjectEnvironments."$ProjectObj"
		}
		# add the new project and environment entry
		$peObj."$Project" = @( $Environment )
		# add the updated hashtable back to the source object
		$bodyObj.ProjectEnvironments = New-Object -TypeName PSCustomObject -Property $peObj
	}
	$body = $bodyObj | ConvertTo-Json -Depth 100 -Compress
	Write-Debug "Body: $body"
	
	Write-Verbose "Submitting updated tenant object..."
	$result = Invoke-RestMethod -Method Put -UseBasicParsing -Uri $uri.AbsoluteUri -Headers $headers -Body $body
	Write-Debug "Result: $($result | ConvertTo-Json -Depth 100 -Compress)"
	Write-Output $result
}