$functionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"

Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\CommonTests.ps1

Describe "$functionName" {
	$goodParams.Name = $goodTenant

	Mock -CommandName Get-OctoTenant -MockWith { return $false }
	Mock -CommandName Invoke-RestMethod -MockWith { return $true }

	Test-StandardParameters

	Context "Name Parameter" {
		It "Passes the value of the Name parameter" {
			Test-Function @commonParams @goodParams
			Assert-MockCalled -CommandName Invoke-RestMethod -Times 1 -Scope It -ParameterFilter { $Body -and ( ( $Body | ConvertFrom-Json ).Name -eq $goodTenant ) }
		}
	
		It "Validates the value of the Name parameter" {
			Mock -CommandName Get-OctoTenant -MockWith { return ( New-Object -TypeName PsObject -Property @{ Name = $goodTenant } ) }
			{ Test-Function @commonParams @goodParams } | Should Throw
		}
	}
}