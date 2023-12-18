import Base.isless, Base.iterate

export AccountingPeriod
export next, timeframe
export firstday


"""
    struct AccountingPeriod

The time period with reference to which financial statements are prepared.

Parameter `C` is a concrete subtype of [`FiscalCalendar`](@ref). 

When instantiated, an object of this type is read as "the (index)th (duration) of (parent)" for the given `FiscalCalendar`. Concretely, this becomes something like "the 2nd period of FY2023" where FY2023 is itself an `AccountingPeriod` with no parent, namely "the 2023rd year of nothing."

The use of this term to indicate concrete [`TimeFrame`](@ref)s is consistent with the definitions provided on wikipedia (https://en.wikipedia.org/wiki/Accounting_period) and accountingcoach.com (https://www.accountingcoach.com/blog/what-is-an-accounting-period).
"""
struct AccountingPeriod{C,D}
	index::Int64
	duration::Duration
	parent::Union{AccountingPeriod,Nothing}
	AccountingPeriod(i::Int64,d::Duration,p::Union{AccountingPeriod,Nothing}=nothing) = new{FiscalCal445{Saturday,July,LastIn::FiscalYearend},d}(i,d,p)
	AccountingPeriod{C}(i::Int64,d::Duration,p::Union{AccountingPeriod,Nothing}=nothing) where {C} = new{C,d}(i,d,p)
	AccountingPeriod{FiscalCalGregorian}(i::Int64,d::Duration,p::Union{AccountingPeriod,Nothing}=nothing) = new{FiscalCalGregorian{Date(2023,12,31)},d}(i,d,p)
end


depth(ap::AccountingPeriod,d::Integer=0) = ap.duration == FiscalYear ? d : depth(ap.parent,d+1)
FY(ap::AccountingPeriod) = ap.duration == FiscalYear ? ap : FY(ap.parent)
parent(ap::AccountingPeriod) = ap.duration == FiscalYear ? ap : ap.parent



isleap(ap::AccountingPeriod) = fc_52or53wks(ap) == 53


# function fiscalyear(ap::AccountingPeriod)::Int64
# 	ap.duration ∈ (CalendarYear, FiscalYear) ? ap.index : 
# 	fiscalyear(ap.parent)
# end
# 
# 
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


function next(ap::AccountingPeriod{C,D}) where {C,D}
	e = "The `AccountingPeriod` has an unrecognized `Duration`."
	i = ap.index; dur = ap.duration; par = ap.parent; 
	pdur = isnothing(par) ? nothing : par.duration
	dur ∈ (CalendarYear, FiscalYear)       ? 
	  AccountingPeriod{C}(i+1,dur)                                    :
	dur ∈ (CalendarQuarter, FiscalQuarter) ? 
	  AccountingPeriod{C}((i%4)+1,dur,i%4 == 0 ? next(par) : par)     :
	dur ∈ (CalendarMonth, FiscalPeriod)    ? 
	  (wrap = pdur ∈ (CalendarQuarter,FiscalQuarter) ? 3 : 12;
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


function firstday(ap::AccountingPeriod{C,FiscalYear})::Date where {C}
	lastday(AccountingPeriod{C}(FY(ap).index-1,FiscalYear)) + Dates.Day(1) 
end


function firstday(ap::AccountingPeriod{C,FiscalQuarter})::Date where {C}
	firstday( FY(ap) ) +                   # first day of FY
	Dates.Day( (quarterofFY(ap) - 1) * (13 * 7) )   # offset of days in preceeding quarters
end


function firstday(ap::AccountingPeriod{C,FiscalWeek})::Date where {C}
	firstday(FY(ap)) +          # first day of FY
	(weekofFY(ap) - 1) *          # weeks since 1st week in FY
	Dates.Day(7)                  # days in a week
end


function lastday(ap::AccountingPeriod{C,D})::Date where{C,D}
	firstday( next(ap) ) - Dates.Day(1)
end


