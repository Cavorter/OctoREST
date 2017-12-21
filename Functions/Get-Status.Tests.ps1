$functionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Split('.')[0]
. "$PSScriptRoot\$functionName.ps1"

Set-Alias -Name Test-Function -Value $functionName -Scope Script

. $PSScriptRoot\..\TestContent\CommonTests.ps1

Describe "$functionName" {
	Mock -CommandName Invoke-RestMethod -MockWith { return $true }

	Test-StandardParameters
}