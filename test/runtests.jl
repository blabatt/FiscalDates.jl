using FiscalDates
using Test
using Dates

@testset "FiscalCal445" include("FiscalCal445.jl")
@testset "FiscalCalGregorian" include("FiscalCalGregorian.jl")
@testset "FiscalCalISO" include("FiscalCalISO.jl")
@testset "FiscalCalBroadcast" include("FiscalCalBroadcast.jl")

