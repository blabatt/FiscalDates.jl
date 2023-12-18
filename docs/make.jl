using Documenter, Proforma

makedocs(
				 sitename="Microgrid Proforma",
				 format = Documenter.HTML(prettyurls = false), # may want to Δ this per Documenter docs when publishing to web
				 pages=[
								"Proforma" => "index.md",
								"Units and Money" => "units.md",
								"Fees and Contracts" => "contract.md",
								"Business Activities" => "service.md",
								"Ledger System" => "ledger.md",
								"Simulations" => "simulation.md",
								"Financial Reporting" => "reporting.md"
								]
				 )
#deploydocs(repo = "github.com/blabatt/mg-proforma.git")
