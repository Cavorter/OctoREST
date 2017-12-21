$functionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"

Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\CommonTests.ps1

Describe "$functionName" {
	$goodParams.Id = $goodTenant

	Mock -CommandName Invoke-RestMethod -MockWith { return $true }

	Test-StandardParameters

	Context "Id Parameter" {
		Test-Function @commonParams @goodParams
		$assertParams = @{ CommandName = "Invoke-RestMethod"; Times = 1; Exactly = [switch]$true; Scope = "Context" }
	
		It "Passes the value of the Id parameter if specified" {
			$assertParams.ParameterFilter = { $Uri -like "*tenants/$goodTenant" }
			Assert-MockCalled @assertParams
		}
	
		It "Specifies the Delete method for Invoke-RestMethod" {
			$assertParams.ParameterFilter = { $Method -eq "Delete" }
			Assert-MockCalled @assertParams
		}
	}
}