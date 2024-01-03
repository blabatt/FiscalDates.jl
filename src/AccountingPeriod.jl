import Base.isless, Base.iterate, Base.show

export AccountingPeriod
export next, prev, timeframe
export firstday, lastday
export isleap, offsetofFY, FY, periodofquarter, periodicity


"""
    struct AccountingPeriod

The time period with reference to which financial statements are prepared.

Parameter `C` is a concrete subtype of [`FiscalCalendar`](@ref). Parameter `D` is a variant of the [`Duration`](@ref) enum.

When instantiated, an object of this type is read as "the (index)th (duration) of (parent)" for the given `FiscalCalendar`. Concretely, this becomes something like "the 2nd period of FY2023" where FY2023 is itself an `AccountingPeriod` with no parent, namely "the 2023rd year of nothing."

The use of this term to indicate concrete time frames is consistent with the definitions provided on [wikipedia](https://en.wikipedia.org/wiki/Accounting_period) and [accountingcoach](https://www.accountingcoach.com/blog/what-is-an-accounting-period).
"""
struct AccountingPeriod{C,D}
	index::Int64
	duration::Duration
	parent::Union{AccountingPeriod,Nothing}
	AccountingPeriod(i::Int64,d::Duration,p::Union{AccountingPeriod,Nothing}=nothing) = new{FiscalCal5253{Saturday,July,LastIn::FiscalYearend},d}(i,d,p)
	AccountingPeriod{C}(i::Int64,d::Duration,p::Union{AccountingPeriod,Nothing}=nothing) where {C} = new{C,d}(i,d,p)
	AccountingPeriod{FiscalCalGregorian}(i::Int64,d::Duration,p::Union{AccountingPeriod,Nothing}=nothing) = new{FiscalCalGregorian{Date(2023,12,31)},d}(i,d,p)
end

function Base.show(io::IO,ap::AccountingPeriod)
	if isnothing(ap)
		s = ""
	else
		y = string("FY",FY(ap).index);
    if ap.duration == FiscalYear
			s = y
		elseif ap.duration == FiscalQuarter
			s = y * string("Q",quarterofFY(ap))
		elseif ap.duration == FiscalPeriod
			s = y * string("P",periodofFY(ap))
		elseif ap.duration == FiscalWeek
			s = y * string("Wk", weekofFY(ap))
		else
			s = ""
			error("Unrecognized `ap`")
		end
	end
	print(io,s)
end

depth(ap::AccountingPeriod,d::Integer=0) = ap.duration == FiscalYear ? d : depth(ap.parent,d+1)
parent(ap::AccountingPeriod) = ap.duration == FiscalYear ? ap : ap.parent

"""
    FY(ap::AccountingPeriod)

Determines the `FiscalYear` of a given [`AccountingPeriod`](@ref).
"""
FY(ap::AccountingPeriod) = ap.duration == FiscalYear ? ap : FY(ap.parent)

"""
    FY(cal::Type{C}, d::Date)

Given a [`FiscalCalendar`](@ref), returns the `FiscalYear` (really, the `AccountingPeriod{FiscalYear}`) for the queried calendar date `d`.
"""
function FY(cal::Type{C},d::Date)::AccountingPeriod{C} where {C<:FiscalCalendar}
  y = year(d); fy = AccountingPeriod{cal}(y, FiscalYear)
  lastday(fy) ≥ d ? fy : next(fy)
end

"""
    isleap(ap::AccountingPeriod)

Returns whether the given [`AccountingPeriod`](@ref) occurs in a fiscal leap year.
"""
isleap(ap::AccountingPeriod) = fc_52or53wks(ap) == 53


# function fiscalyear(ap::AccountingPeriod)::Int64
# 	ap.duration ∈ (CalendarYear, FiscalYear) ? ap.index :
# 	fiscalyear(ap.parent)
# end
#
#
"""
    quarterofFY(ap::AccountingPeriod)

Query the `FiscalQuarter` of the given [`AccountingPeriod`](@ref).
"""
function quarterofFY(ap::AccountingPeriod)
	if ap.parent.duration ∈ (CalendarYear, FiscalYear)
		ap.duration ∈ (CalendarQuarter, FiscalQuarter)  ? ap.index           :
		ap.duration ∈ (CalendarMonth, FiscalPeriod)     ? cld(ap.index, 13) :
		ap.duration ∈ (CalendarWeek, FiscalWeek)        ? cld(ap.index, 3)  :
		error("`ap` is ill-formed.")
	else
		quarterofFY(ap.parent)
	end
end



"""
    offsetofFY(ap::AccountingPeriod)

Retrieve the index of the given [`AccountingPeriod`](@ref) within its `FiscalYear`, at the same [`Duration`](@ref).
"""
function offsetofFY(ap::AccountingPeriod{C,D}) where {C,D}
	D == FiscalWeek     ? weekofFY(ap)    :
	D == FiscalPeriod   ? periodofFY(ap)  :
	D == FiscalQuarter  ? quarterofFY(ap) :
	D == FiscalYear     ? ap.index        :
	error("Unrecognized `duration` for given `ap`.")
end


function Base.isless(ap1::AccountingPeriod{C,D1},ap2::AccountingPeriod{C,D2}) where{C,D1,D2}
	ap1fy = FY(ap1).index; ap2fy = FY(ap2).index
	ap1fy ≠ ap2fy   ? ap1fy < ap2fy                      :
	D1 == D2        ? offsetofFY(ap1) < offsetofFY(ap2)  :
                    offsetofFY(ap1) < offsetofFY(ap2) # TODO: BUG: (?) comparing offsets of different durations?!
end


"""
    next(ap::AccountingPeriod{C,D}) where {C,D}

Retrieves the sequential [`AccountingPeriod`](@ref) that follows the given one.
"""
function next(ap::AccountingPeriod{C,D}) where {C,D}
	e = "The `AccountingPeriod` has an unrecognized `Duration`."
	i = ap.index; dur = ap.duration; par = ap.parent;
	pdur = isnothing(par) ? nothing : par.duration
	dur ∈ (CalendarYear, FiscalYear)       ?
    AccountingPeriod{C}(i+1,dur)                                    :
	dur ∈ (CalendarQuarter, FiscalQuarter) ?
    AccountingPeriod{C}((i%4)+1,dur,i%4 == 0 ? next(par) : par)     :
	dur ∈ (CalendarMonth, FiscalPeriod)    ?
    (wrap = pdur ∈ (CalendarQuarter,FiscalQuarter) ? 3 : 12; # TODO: the 12 number is wrong for ThirteenPeriods Cals
     m = i % wrap;
     AccountingPeriod{C}(m + 1, dur, m == 0 ? next(par) : par))     :
	dur ∈ (CalendarWeek, FiscalWeek)       ?
    AccountingPeriod{C}(
      pdur ∈ (CalendarMonth,FiscalPeriod)    ?  (m=i%fc_4or5wks(par)  ; np = m == 0 ? next(par) : par; m + 1)   :
      pdur ∈ (CalendarQuarter,FiscalQuarter) ?  (m=i%fc_13or14wks(par); np = m == 0 ? next(par) : par; m + 1)   :
      pdur ∈ (CalendarYear, FiscalYear)      ?  (m=i%fc_52or53wks(par); np = m == 0 ? next(par) : par; m + 1)   :
      error(e),
    dur,np)                                                         :
  error(e)
end

"""
    prev(ap::AccountingPeriod{C,D}) where {C,D}

Retrieves the sequential [`AccountingPeriod`](@ref) that preceeds the given one.

This is the natural inverse of [`next`](@ref):
    ap = AccountingPeriod(...)
    ap == prev(next(ap))
"""
function prev(ap::AccountingPeriod{C,D}) where {C,D}
  e = "The `AccountingPeriod` has an unrecognized `Duration`."
  i = ap.index; dur = ap.duration; par = ap.parent;
  pdur = isnothing(par) ? nothing : par.duration
  dur ∈ (CalendarYear, FiscalYear)       ?
    AccountingPeriod{C}(i-1,dur)                                    :
  dur ∈ (CalendarQuarter, FiscalQuarter) ?
  AccountingPeriod{C}(i == 1 ? 4 : mod1(i,4)-1,dur,i == 1 ? prev(par) : par)     :
  dur ∈ (CalendarMonth, FiscalPeriod)    ?
    (wrap = pdur ∈ (CalendarQuarter,FiscalQuarter) ? 3 : 12; # TODO: the 12 number is wrong for ThirteenPeriods Cals
     m = mod1(i,wrap);
     AccountingPeriod{C}(i == 1 ? wrap : m - 1, dur, i == 1 ? prev(par) : par))     :
  dur ∈ (CalendarWeek, FiscalWeek)       ?
    AccountingPeriod{C}(
      pdur ∈ (CalendarMonth,FiscalPeriod)    ? (wrap = fc_4or5wks(par); m=mod1(i,wrap); np = m == 1 ? prev(par) : par; m == 1 ? wrap : m - 1)  :
      pdur ∈ (CalendarQuarter,FiscalQuarter) ? (wrap = fc_13or14wks(par); m=mod1(i,wrap) ; np = m == 1 ? prev(par) : par; m == 1 ? fc_13or14wks(prev(par)) : m - 1)  :
      pdur ∈ (CalendarYear, FiscalYear)      ? (wrap = fc_52or53wks(par); m=mod1(i,wrap) ; np = m == 1 ? prev(par) : par; m == 1 ? fc_52or53wks(prev(par)) : m - 1)  :
      error(e),
    dur,np)                                                         :
  error(e)
end


"""
    firstday(ap::AccountingPeriod)

Retrieve the first calendar day of the given `FiscalYear`.
"""
function firstday(ap::AccountingPeriod{C,FiscalYear})::Date where {C}
	lastday(AccountingPeriod{C}(FY(ap).index-1,FiscalYear)) + Dates.Day(1)
end


"""
    firstday(ap::AccountingPeriod)

Retrieve the first calendar day of the given `FiscalQuarter`.
"""
function firstday(ap::AccountingPeriod{C,FiscalQuarter})::Date where {C}
	firstday( FY(ap) ) +                   # first day of FY
	Dates.Day( (quarterofFY(ap) - 1) * (13 * 7) )   # offset of days in preceeding quarters
end

"""
    firstday(ap::AccountingPeriod)

Retrieve the first calendar day of the given `FiscalWeek`.
"""
function firstday(ap::AccountingPeriod{C,FiscalWeek})::Date where {C}
	firstday(FY(ap)) +          # first day of FY
	(weekofFY(ap) - 1) *          # weeks since 1st week in FY
	Dates.Day(7)                  # days in a week
end


"""
    lastday(ap::AccountingPeriod)

Retrieve the last calendar day of the given [`AccountingPeriod`](@ref).
"""
function lastday(ap::AccountingPeriod{C,D})::Date where{C,D}
	firstday( next(ap) ) - Dates.Day(1)
end


"""
    fc_52or53wks(::AccountingPeriod)

Returns the number of weeks in the given `FiscalYear`, effectively determining whether the encompassing fiscal year is a leap fiscal year.
"""
function fc_52or53wks(ap::AccountingPeriod{C,D}) where {C,D}
	lastday(FY(ap)) - firstday(FY(ap)) == Dates.Day(370) ? 53 : 52
end


"""
    fc_13or14wks(::AccountingPeriod{C<:FiscalCal5253,FiscalQuarter})

Returns the number of weeks in the given [`AccountingPeriod`](@ref).
"""
function fc_13or14wks(ap::AccountingPeriod{C,FiscalQuarter}) where {C}
	QofFY = quarterofFY(ap)
	if ap.parent.duration != FiscalYear
		error("Unrecognized `ap` structure.")
	end
	!isleap(ap)  ? 13 :
	QofFY == 4   ? 14 :
	13
end


function periodicity(ap::AccountingPeriod{C,D}) where {C,D}
	if C <: FiscalCalGregorian || C <: FiscalCalBroadcast
		error("No periods defined for this type of `FiscalCalendar`.")
	elseif C <: FiscalCal5253
		C.parameters[4]
	elseif C <: FiscalCalISO # TODO: parameterize FiscalCalISO calendars in this way
		C.parameters[1]
	end
end


function perioddurations(ap::AccountingPeriod)
	if periodicity(ap) == ThirteenPeriods
		!isleap(ap) ? repeat([4],13) : [4,4,4,4,4,4,4,4,4,4,4,4,5]
	elseif periodicity(ap) == FourFourFive
		!isleap(ap) ? repeat([4,4,5],4) : vcat(repeat([4,4,5],3),[4,5,5])
	elseif periodicity(ap) == FourFiveFour
		!isleap(ap) ? repeat([4,5,4],4) : vcat(repeat([4,5,4],3),[4,5,5])
	elseif periodicity(ap) == FiveFourFour
		!isleap(ap) ? repeat([5,4,4],4) : vcat(repeat([5,4,4],3),[5,4,5])
	end
end


"""
    fc_4or5wks(::AccountingPeriod{C,FiscalPeriod})

Returns the number of weeks in the given `FiscalPeriod`.
"""
function fc_4or5wks(ap::AccountingPeriod{C,FiscalPeriod}) where {C}
	if ap.parent.duration == FiscalQuarter
		PofQ = ap.index; PofFY = periodofFY(ap)
	elseif ap.parent.duration == FiscalYear
		PofFY = periodofFY(ap); Q = cld(PofFY,3); PofQ = mod1(PofFY,3) # TODO: Δ Q, PofQ calcs.
	else
		error("Unrecognized `ap` structure.")
	end
	perioddurations(ap)[PofFY]
end


"""
    firstday(ap::AccountingPeriod)

Retrieve the first calendar day of a given [`AccountingPeriod`](@ref).
"""
function firstday(ap::AccountingPeriod{C,FiscalPeriod})::Date where {C<:FiscalCal5253}
  Q = quarterofFY(ap); P = periodofFY(ap)
  firstday( FY(ap) ) +                 # first day of FY
  Dates.Week(													 # weeks since beginning of FY
             sum(perioddurations(ap)[1:P-1])
             )
end

