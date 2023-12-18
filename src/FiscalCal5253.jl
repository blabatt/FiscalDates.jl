import Base.isless, Base.iterate

export FiscalYearend, LastIn, ClosestTo
export FiscalCal5253
export firstday

"""
    @enum FiscalYearend begin
        LastIn
        ClosestTo
		end

Description of how to choose the specific day that terminates the [`FiscalYear`](@ref) of a [`FiscalCal5253`](@ref) calendar.
"""
@enum FiscalYearend begin
	LastIn
	ClosestTo
end




lastmonthofFY(ap::AccountingPeriod{C,D}) where {C<:FiscalCal5253,D} = C.parameters[2] 
lastdowofFY(ap::AccountingPeriod{C,D}) where {C<:FiscalCal5253,D} = C.parameters[1]
usinglastdayinCMlogic(ap::AccountingPeriod{C,D}) where {C<:FiscalCal5253,D} = C.parameters[3] == LastIn 


function lastday(ap::AccountingPeriod{C,FiscalYear})::Date where {C<:FiscalCal5253} 
	fy = FY(ap).index; m = lastmonthofFY(ap); dow = lastdowofFY(ap)
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

function periodofFY(ap::AccountingPeriod{C,D}) where {C<:FiscalCal5253,D}
	dur = ap.duration
	if dur ∉ (FiscalPeriod, CalendarMonth, FiscalWeek, CalendarWeek)
		error("Period not discernable for a `Duration` coarser than `FiscalPeriod`.")
	elseif (dur ∈ (CalendarMonth, FiscalPeriod)) && (parent(ap).duration ∈ (CalendarQuarter, FiscalQuarter))
		Q = quarterofFY(ap); PofQ = ap.index
		(Q - 1) * 3 + PofQ 
	elseif parent(ap).duration ∈ (CalendarYear, FiscalYear)
		if dur ∈ (CalendarMonth, FiscalPeriod) 
			ap.index
		elseif dur ∈ (CalendarWeek, FiscalWeek)    
			WofFY = weekofFY(ap) 
			WofQ = WofFY == 53 ? 14 : mod1(WofFY,13)
			Q = WofFY == 53 ? 4 : cld(WofFY,13)
			PofQ = isleap(ap) && WofFY == 48 ? 2 : WofQ == 13 ? 3 : cld(WofQ,4) 
			(Q-1) * 3 + PofQ
		end
	else
		periodofFY(ap.parent)
	end
end


function periodofquarter(ap::AccountingPeriod{C,FiscalPeriod}) where {C<:FiscalCal5253}
		periodofFY(ap) == 13 ? 4 : mod1(periodofFY(ap),3)
end

function weekofFY(ap::AccountingPeriod{C,FiscalWeek}) where {C<:FiscalCal5253}
	p = parent(ap)
	if p.duration ∈ (CalendarYear, FiscalYear)
		WofFY = ap.index 
	elseif depth(ap) == 3               # ie, a full hierarchy: week → period → quarter → year
		WofP = ap.index; PofQ = periodofquarter(p); QofFY = parent(p).index;  # TODO: genericize
		is4qp3inleap = isleap(ap) && PofQ == 3 && QofFY == 4                  
		WofFY = WofP + (PofQ - 1) * 4 + (is4qp3inleap ? 1 : 0) + (QofFY - 1)*13
	elseif p.duration == FiscalPeriod   # ie, week → period → year
		WofP = ap.index; PofFY = periodofFY(ap); Q = fld(PofFY,3); PofQ = periodofquarter(p) #mod1(PofFY,3)  #P = parent(ap).index
		is12Pinleap = isleap(ap) && p.index == 12    
		WofFY = (Q-1)*13 +                # weeks in previous Qs
		        WofP     +                # week into this P
                                      # weeks of previous Ps of this Q:
						(PofQ == 1 ? 0 : PofQ == 2 ? 4 : 8 + (is12Pinleap ? 1 : 0)) 
	elseif p.duration ∈ (CalendarQuarter, FiscalQuarter)
		WofQ = ap.index; Q = p.index
		WofFY = WofQ + 13 * (Q - 1)
	else
		error("Unrecognized `ap` hierarchy.")
	end
	WofFY
end



