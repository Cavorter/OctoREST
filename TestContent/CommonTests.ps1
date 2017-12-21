$goodServer = "http://some.octopusserver.com"
$goodKey = "API-1234567890123456"

$commonParams = @{ Server = $goodServer; APIKey = $goodKey }

$goodTenant = "Tenants-1234"
$goodProject = "Projects-1234"
$goodEnv = "Environments-1234"

function Test-StandardParameters {
	Context "Test Standard Parameters" {
		Test-ParamMandatoryAttrib

		Test-Function @commonParams @goodParams
		$assertParams = @{ Scope = "Context" }

		It "Passes the value of the Server parameter" {
			$assertParams.CommandName = "Invoke-RestMethod"
			$assertParams.ParameterFilter = { $Uri -like "$goodServer/*" }
			Assert-MockCalled @assertParams
		}
		
		It "Passes the value of the APIKey parameter" {
			$assertParams.CommandName = "Invoke-RestMethod"
			$assertParams.ParameterFilter = { $Headers.'X-Octopus-ApiKey' -eq $goodKey }
			Assert-MockCalled @assertParams
		}
	}
}

function Test-ParamMandatoryAttrib {
	foreach ( $mandatory in $goodParams.Keys ) {
		It "the Mandatory attribute for the $mandatory parameter is $true" {
			( Get-Command -Name $functionName ).Parameters."$mandatory".ParameterSets.__AllParameterSets.IsMandatory | Should Be $true
		}
	}
}