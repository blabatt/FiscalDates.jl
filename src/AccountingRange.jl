import Base.iterate, Base.length, Base.show, Base.in
export AccountingRange
export length, firstday, in

"""
    struct AccountingRange

An iterator of [`AccountingPeriod`](@ref)s over the range's encompassed `Date`s.

`AccountingRange` performs no bounds checking. Namely, if either `from` or `to` overlaps or is a superset of the other, then the iterator will cover the union of these two `AccountingPeriod`s, ``\\text{from} \\cup \\text{to}``. `AccountingRange` iterators always proceed forward in time, even if `from` is later than `to`.
"""
struct AccountingRange{C,D}
	from::AccountingPeriod{C,D}
	to::AccountingPeriod{C,D}
end
first(ar::AccountingRange)::AccountingPeriod = ar.from
last(ar::AccountingRange)::AccountingPeriod  = ar.to
function Base.iterate(ar::AccountingRange, state=first(ar))
	state > ar.to ? nothing : ( n = next(state); (state , n) )
end


firstday(ar::AccountingRange) = firstday(first(ar))
lastday(ar::AccountingRange)  = lastday(last(ar))
in(d::Date,per::AccountingPeriod) = firstday(per) ≤ d ≤ lastday(per)
in(d::Date,ar::AccountingRange)   = firstday(ar)  ≤ d ≤ lastday(ar)
function in(per::AccountingPeriod,ar::AccountingRange)
  firstday(ar) ≤ firstday(per) && lastday(ar) ≥ lastday(per)
end


"""
    length(ar::AccountingRange)

Return the length of the given iterator.
"""
function length(ar::AccountingRange{C,FiscalPeriod}) where {C<:FiscalCalendar}
	ppy = typeof(ar.from).parameters[1] <: FiscalCal5253 &&
	      typeof(ar.from).parameters[1].parameters[4] == ThirteenPeriods ?
				13 : 12
	(FY(ar.to).index - FY(ar.from).index) * ppy + ar.to.index - ar.from.index + 1
end

"""
    length(ar::AccountingRange)

Return the length of the given iterator, in units of `FiscalYear`s.
"""
function length(ar::AccountingRange{C,FiscalYear}) where {C<:FiscalCalendar}
  FY(ar.to).index - FY(ar.from).index + 1
end

function Base.show(io::IO,ar::AccountingRange)
	println(io,"From ",ar.from," to ",ar.to)
end
