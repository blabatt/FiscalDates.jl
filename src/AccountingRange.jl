import Base.iterate, Base.length, Base.show
export AccountingRange

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
function Base.iterate(ar::AccountingRange, state=first(ar))
	state > ar.to ? nothing : ( n = next(state); (state , n) )
end
function Base.length(ar::AccountingRange)
	ppy = typeof(ar.from).parameters[1] <: FiscalCal5253 &&
	      typeof(ar.from).parameters[1].parameters[4] == ThirteenPeriods ?
				13 : 12
	(FY(ar.to).index - FY(ar.from).index) * ppy + ar.to.index - ar.from.index + 1
end
function Base.show(io::IO,ar::AccountingRange)
	println(io,"From ",ar.from," to ",ar.to)
end
