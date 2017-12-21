$functionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"

Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\CommonTests.ps1

Describe "$functionName" {
	Mock -CommandName Invoke-RestMethod -MockWith { return $true }

	$goodParams.Tenant = $goodTenant

	Test-StandardParameters

	Context "Tenant Parameter" {
		It "Passes the value of the Tenant parameter" {
			$mockParams = @{ CommandName = "Invoke-RestMethod"; ParameterFilter = { $Uri -like "*tenants/$goodTenant/variables" } }
			Mock @mockParams -MockWith { return $true }
			Test-Function @goodParams @commonParams
			Assert-MockCalled @mockParams -Times 1 -Scope It
		}
	}
}