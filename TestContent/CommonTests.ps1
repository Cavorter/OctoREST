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

function Test-IdParameter {
	Param(
		[Parameter(Mandatory = $true)]
		[string]$Stub,

		[Parameter(Mandatory = $true)]
		[string]$Id
	)
	Context "Id Parameter implementation" {
		$assertParams = @{ CommandName = "Invoke-RestMethod"; Times = 1; Scope = "It"; Exactly = [switch]$true }

		It "Passes 'all' if Id parameter is not specified" {
			$assertParams.ParameterFilter = { $Uri -like "*$stub/all" }
			Test-Function @commonParams
			Assert-MockCalled @assertParams
		}
	
		It "Passes the value of the Id parameter if specified" {
			$assertParams.ParameterFilter = { $Uri -like "*$stub/$Id" }
			Test-Function @commonParams -Id $Id
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