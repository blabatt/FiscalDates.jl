module FiscalDates
using Dates

export Duration, FiscalYear, CalendarYear, FiscalQuarter, CalendarQuarter, FiscalPeriod, CalendarMonth, FiscalWeek, CalendarWeek
export PeriodDurations, ThirteenPeriods, FourFourFive, FourFiveFour, FiveFourFour
export FiscalCalendar, FiscalCal5253, FiscalCalGregorian, FiscalCalISO, FiscalCalBroadcast
export firstday, lastday


"""
    @enum Duration begin
        FiscalYear
        CalendarYear
        FiscalQuarter
        CalendarQuarter
        FiscalPeriod
        CalendarMonth
        FiscalWeek
        CalendarWeek
    end

Abstract concepts of a time duration with no specifics provided.

Calendar years and months, as well as fiscal years and periods, all stretch over a varying number of days. As such, these are not strict measurements; they are, rather, context-dependent time durations.
"""
@enum Duration begin
	FiscalYear
	CalendarYear
	FiscalQuarter
	CalendarQuarter
	FiscalPeriod
	CalendarMonth
	FiscalWeek
	CalendarWeek
end


"""
    @enum PeriodDurations begin
        ThirteenPeriods
        FourFourFive
        FourFiveFour
        FiveFourFour
    end

The periodicity of the durations, in weeks, of successive `FiscalPeriod`s in a `FiscalYear`.
"""
@enum PeriodDurations begin
  ThirteenPeriods
  FourFourFive
  FourFiveFour
  FiveFourFour
end


"""
    abstract type FiscalCalendar

Concrete implementations may be parametric, such as [`FiscalCalGregorian`](@ref), parameterized by a specific `Date` and [`FiscalCal5253`](@ref), parameterized by an ending month as well as a couple other factors, or the may be singleton types, such as [`FiscalCalISO`](@ref) and [`FiscalCalBroadcast]`(@ref). In either case, significant work must be done to implement a new `FiscalCalendar`. 

The following functions must have method implementations specific to the new concrete type (here called `NEW_C`): 
* `lastday(::AccountingPeriod{NEW_C,FiscalYear})`
* [`periodofFY`](@ref)
* [`weekofFY`](@ref) 

Unfortunately, these functions cannot be generically implemented across all `FiscalCalendar`s due to the highly irregular logic of these calendaring systems, in general.

See a discussion of various calendars, including several not used for fiscal purposes and so not implemented here, such as the Mayan calendar, [here](https://www.fourmilab.ch/documents/calendar/).
"""
abstract type FiscalCalendar end




"""
    struct FiscalCal5253{D,W,T} <: FiscalCalendar

Commonly-used [`FiscalCalendar`](@ref) with 52 or 53 week periods. 

`FiscalWeek`s always begins on the same day of the week. `FiscalCal5253`s are parameterized by the logic used to determine the final day of any `FiscalYear`. These parameters include: a day of the week, `D` that the fiscal year ends on; a calendar month of the year, `M`, that the fiscal year ends on; and `T`, a `Bool` that indicates how to terminate each `FiscalYear` given `D` and `M`. The duration of its `FiscalPeriod`s is indicated by type parameter `P`. See more details [here](https://en.wikipedia.org/wiki/4%E2%80%934%E2%80%935_calendar).
"""
struct FiscalCal5253{D,M,T,P} <: FiscalCalendar
end




"""
    struct FiscalCalGregorian{D} <: FiscalCalendar

A Gregorian calendar with arbitrary termination `Date`, used as a [`FiscalCalendar`](@ref).

Type parmeter `D` is the termination date of an arbitrary year. Every `FiscalYear` in this particular `FCGregorian` will have the month and day coincide with the month and day of `D`.
"""
struct FiscalCalGregorian{D} <: FiscalCalendar
end



"""
    struct FiscalCalISO <: FiscalCalendar

A week-centered [`FiscalCalendar`](@ref). 

The first Thursday of a calendar year is always in that ISO year's first week. Every ISO week begins on a Monday. ISO Calendars are static, standardized in ISO 8601. See more [here](https://en.wikipedia.org/wiki/ISO_week_date) or [here](https://webspace.science.uu.nl/~gent0113/calendar/isocalendar.htm).
"""
struct FiscalCalISO <: FiscalCalendar
end



"""
    struct FiscalCalBroadcast <: FiscalCalendar

[`FiscalCalendar`](@ref) commonly used in the Broadcast industry.

Weeks always begin on a Monday. The first week of a Broadcast "month" contains the first of the corresponding Gregorian month. Eg, if May 1st is a Thursday, then April 28th is the first of 5th (unnamed) Broadcast month. By extension, the first week of the `FCBroadcast`s year contains January 1st of the corresponding Calendar year. See [here](https://en.wikipedia.org/wiki/Broadcast_calendar) or [here](https://www.indeed.com/career-advice/career-development/fiscal-year) for more information. 
"""
struct FiscalCalBroadcast <: FiscalCalendar
end




include("./AccountingPeriod.jl")
include("./FiscalCal5253.jl")
include("./FiscalCalGregorian.jl")
include("./FiscalCalISO.jl")
include("./FiscalCalBroadcast.jl")
include("./AccountingRange.jl")


end
