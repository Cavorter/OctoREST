$functionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"

Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\CommonTests.ps1

Describe "$functionName" {
	$existingProject = "Projects-4321"
	$goodParams = @{ Tenant = $goodTenant; Project = $goodProject; Environment = $goodEnv }
	
	$returnJson = "{'Id':'$goodTenant','Name':'SomeTenant','TenantTags':['Customer Type/Internal'],'ProjectEnvironments':{'$existingProject':['Environments-1','Environments-4','Environments-2']},'Links':{'Self':'/api/tenants/$goodTenant','Variables':'/api/tenants/$goodTenant/variables','Logo':'/api/tenants/$goodTenant/logo'}}"
	$goodReturn = $returnJson | ConvertFrom-Json
	Mock -CommandName Invoke-RestMethod -MockWith { return $goodReturn }
	
	Test-StandardParameters
	
	Context "Specific Parameter Tests" {
		Test-Function @commonParams @goodParams
		$assertParams = @{ Times = 2; Scope = "Context"; Exactly = [switch]$true }

		It "Passes the value of the Tenant parameter" {
			$assertParams.CommandName = "Invoke-RestMethod"
			$assertParams.ParameterFilter = { $Uri -like "*tenants/$goodTenant" }
			Assert-MockCalled @assertParams
		}
		
		It "Passes the value of the Project parameter" {
			$assertParams.CommandName = "Invoke-RestMethod"
			$assertParams.ParameterFilter = { $Body -and ( $Body | ConvertFrom-Json ).ProjectEnvironments."$goodProject" }
			$assertParams.Times = 1
			Assert-MockCalled @assertParams
		}
		
		It "Passes the value of the Environment parameter" {
			$assertParams.CommandName = "Invoke-RestMethod"
			$assertParams.ParameterFilter = { $Body -and ( $Body | ConvertFrom-Json ).ProjectEnvironments."$goodProject" -contains $goodEnv }
			Assert-MockCalled @assertParams
		}
		
		It "Adds a new Environment to an existing Project" {
			$goodParams.Project = $existingProject
			$mockParams = @{ CommandName = "Invoke-RestMethod"; ParameterFilter = { $Body -and ( $Body | ConvertFrom-Json ).ProjectEnvironments."$existingProject" -contains $goodEnv } }
			Mock @mockParams -MockWith { return $goodReturn }
			Test-Function @commonParams @goodParams
			Assert-MockCalled @mockParams -Times 1 -Scope It
		}
	}
}