import Base.iterate
export AccountingRange 

"""
    struct AccountingRange

A convenience [`TimeFrame`](@ref) that affords an iterator of [`AccountingPeriod`](@ref)s over the range's encompassed `Date`s.

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


