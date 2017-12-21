$functionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"

Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\CommonTests.ps1

Describe "$functionName" {
	Mock -CommandName Invoke-RestMethod -MockWith { return $true }

	Test-StandardParameters

	Context "Id Parameter implementation" {
		$assertParams = @{ CommandName = "Invoke-RestMethod"; Times = 1; Scope = "It"; Exactly = [switch]$true }

		It "Passes 'all' if Id parameter is not specified" {
			$assertParams.ParameterFilter = { $Uri -like "*environments/all" }
			Test-Function @commonParams
			Assert-MockCalled @assertParams
		}
	
		It "Passes the value of the Id parameter if specified" {
			$assertParams.ParameterFilter = { $Uri -like "*environments/$goodEnv" }
			Test-Function @commonParams -Id $goodEnv
			Assert-MockCalled @assertParams
		}
	}
}