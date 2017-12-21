$functionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"

Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\CommonTests.ps1

Describe "$functionName" {
	Mock -CommandName Invoke-RestMethod -MockWith { return $true }

	$goodParams.Id = $goodTenant

	Test-StandardParameters

	Context "Happy Path" {
		Test-Function @commonParams @goodParams
		$assertParams = @{ CommandName = "Invoke-RestMethod"; Times = 1; Exactly = [switch]$true }
	
		It "Passes the value of the Id parameter" {
			$assertParams.ParameterFilter = { $Uri -like "*tenants/$goodTenant/*" }
			Assert-MockCalled @assertParams
		}
	
		It "requests the logo endpoint" {
			$assertParams.ParameterFilter = { $Uri -like "*/logo" }
			Assert-MockCalled @assertParams
		}
	
		It "defaults to a local file called logo.png for the downloaded image file" {
			$assertParams.ParameterFilter = { $OutFile -eq ".\logo.png" }
			Assert-MockCalled @assertParams
		}
	
		It "outputs the image to the file specified in the OutFile parameter" {
			$customOutFile = "{0}\{1}.png" -f $TestDrive, $goodTenant
			$assertParams.ParameterFilter = { $OutFile -eq $customOutFile }
			$assertParams.Scope = "It"
			Test-Function @commonParams @goodParams -OutFile $customOutFile
			Assert-MockCalled @assertParams
		}
	}
}