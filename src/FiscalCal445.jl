import Base.isless, Base.iterate

export FiscalYearend, LastIn, ClosestTo
export FiscalCal445

"""
    @enum FiscalYearend begin
        LastIn
        ClosestTo
		end

Description of how to choose the specific day that terminates the [`FiscalYear`](@ref) of a [`FiscalCal445`](@ref) calendar.
"""
@enum FiscalYearend begin
	LastIn
	ClosestTo
end




lastmonthofFY(ap::AccountingPeriod{C,D}) where {C<:FiscalCal445,D} = C.parameters[2] 
lastdowofFY(ap::AccountingPeriod{C,D}) where {C<:FiscalCal445,D} = C.parameters[1]
usinglastdayinCMlogic(ap::AccountingPeriod{C,D}) where {C<:FiscalCal445,D} = C.parameters[3] == LastIn 


function lastday(ap::AccountingPeriod{C,FiscalYear})::Date where {C<:FiscalCal445} # non-generic!!
	fy = fiscalyear(ap); m = lastmonthofFY(ap); dow = lastdowofFY(ap)
	ds = Date(fy,m,1); dl = ds + Dates.Day(daysinmonth(ds) - 1); Δ = dayofweek(dl) - dow
	if usinglastdayinCMlogic(ap)
		Δ ≥ 0 ? dl - Dates.Day(Δ) : 
		dl - Dates.Day(7 + Δ)
	else # last day in FY is the DOW closest the last calendar day of the month
		abs(Δ) < 4 ? dl - Dates.Day(Δ) : 
		Δ > 0 ? dl + Dates.Day(7 - Δ)  : 
		dl + Dates.Day( - Δ - 7)
	end
end

function fc_52or53wks(ap::AccountingPeriod{C,D}) where {C<:FiscalCal445,D}
	if ap.duration ∉ (CalendarYear,FiscalYear)
		fc_52or53wks(ap.parent) # recurse up until `ap` is a year
	end
	lastday(root(ap)) - firstday(root(ap)) == Dates.Day(370) ? 53 : 52
end

function periodofFY(ap::AccountingPeriod{C,D}) where {C<:FiscalCal445,D}
	idx = ap.index; dur = ap.duration
	!isnothing(ap.parent) && (pidx = ap.parent.index; pdur = ap.parent.duration)
	if dur ∈ (CalendarYear, FiscalYear, CalendarQuarter, FiscalQuarter)
		error("Period not discernable for a `Duration` coarser than `FiscalPeriod`.")
	elseif (dur ∈ (CalendarMonth, FiscalPeriod)) && (pdur ∈ (CalendarQuarter, FiscalQuarter))
		Q_offset = pidx - 1
		Q_offset*3 + idx
	elseif pdur ∈ (CalendarYear, FiscalYear)
		if dur ∈ (CalendarMonth, FiscalPeriod) 
			idx 
		elseif dur ∈ (CalendarWeek, FiscalWeek)    
			wk_of_Q  = idx == 53 ? 14 : (idx%13)+1
			Q_offset = idx == 53 ? 4  : fld(idx,13)
			(fc_52or53wks(ap) == 53 && idx == 44) ? 11 :             # ← the only week that changes, during a leap
			Q_offset * 13 + (wk_of_Q ≤ 4 ? 1 : wk_of_Q ≤ 8 ? 2 : 3)  # year, from the (happy-path) logic on this line.
		end
	else
		periodofFY(ap.parent)
	end
end

"""
    fc_13or14wks(::AccountingPeriod{C<:FiscalCal445,FiscalQuarter})

Returns the number of weeks in the given [`AccountingPeriod`](@ref).
"""
function fc_13or14wks(ap::AccountingPeriod{C,FiscalQuarter}) where {C<:FiscalCal445}
	fc_52or53wks(ap.parent) == 52 ? 13 : 
	ap.index == 4                 ? 14 : 
	13
end

function fc_4or5wks(ap::AccountingPeriod{C,FiscalPeriod}) where {C<:FiscalCal445}
	(ap.index % 3) == 0                   ? 5 :	
	fc_52or53wks(ap.parent) == 52         ? 4 :					 
	periodofFY(ap) == 11                  ? 5 : 
	4  
end


function weekofFY(ap::AccountingPeriod{C,FiscalWeek}) where {C<:FiscalCal445}
	idx = ap.index; pdur = ap.parent.duration
	if pdur ∈ (CalendarYear, FiscalYear)
		return idx
	end
	if depth(ap) == 3 # a full hierarch: week → period → quarter → year
		is4qp3inleap = isleap(ap)                   &&  # It's a leap year
		               ap.parent.index        == 3  &&  # Period is 3rd
		               ap.parent.parent.index == 4      # Quarter is 4th
		idx + (ap.parent.index - 1)*4 + (is4qp3inleap ? 1 : 0) + (ap.parent.parent.index - 1)*13
	elseif ap.parent.duration == FiscalPeriod
		is12Pinleap = isleap(ap) && ap.parent.index == 12    
		P = ap.parent.index; Q = fld(P,3) # Period and Quarter we're in
		idx + (Q-1)*13 + (m = (P-1)%3; m == 0 ? 0 : m == 1 ? 4 : 8 + (is12Pinleap ? 1 : 0))
	elseif pdur ∈ (CalendarQuarter, FiscalQuarter)
		idx + 13 * (ap.parent.index - 1)
	else
		error("Unrecognized `ap` hierarchy.")
	end
end



function firstday(ap::AccountingPeriod{<:FiscalCal445,FiscalPeriod})::Date  # non-generic!
	Q = quarterofFY(ap); P = periodofFY(ap); PofQ = P % 3 + 1
	firstday( root(ap) ) +                 # first day of FY
	Dates.Day(                             # days from first of FY to first of this FQ
					 (Q - 1) *                     # Quarters before the present one ×
						13 *                         # 13 weeks per Q (true ∀ except last Q) ×
						7                            # 7 days per week
						) +
	Dates.Day(                             # days from first of FQ to first of this period
						isleap(ap) && P == 12 ? 9 :      # P11 of a leap year (uncharacteristically) has 5 wks
						(PofQ - 1) * 4                   # otherwise, 4wks in first two periods of any Quarter 
						)
end


