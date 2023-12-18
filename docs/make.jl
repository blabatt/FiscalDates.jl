using Documenter, FiscalDates 

makedocs(
				 sitename="FiscalDates",
				 format = Documenter.HTML(prettyurls = false), # may want to Δ this per Documenter docs when publishing to web
				 pages=[
								"FiscalDates" => "index.md",
								]
				 )
#deploydocs(repo = "github.com/blabatt/mg-proforma.git")
