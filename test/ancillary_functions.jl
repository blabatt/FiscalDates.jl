using FiscalDates
using Dates
using Test


cal            = FiscalCal5253{Saturday,July,LastIn,FourFourFive}
fy2021         = AccountingPeriod{cal}(2021,FiscalYear)
fy2022         = AccountingPeriod{cal}(2022,FiscalYear)
fy2022         = AccountingPeriod{cal}(2022,FiscalYear)
fy2023         = AccountingPeriod{cal}(2023,FiscalYear)
fy2024         = AccountingPeriod{cal}(2024,FiscalYear)
fy2025         = AccountingPeriod{cal}(2025,FiscalYear)
fy2027         = AccountingPeriod{cal}(2027,FiscalYear)
fy2028         = AccountingPeriod{cal}(2028,FiscalYear)
fy2022w51      = AccountingPeriod{cal}(51,FiscalWeek,fy2022)
fy2027q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2027)
fy2027q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2027)
fy2027w40      = AccountingPeriod{cal}(40,FiscalWeek,fy2027)
fy2027q4p2     = AccountingPeriod{cal}(2,FiscalPeriod,fy2027q4)
fy2023q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2023)
fy2023q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2023q3)
fy2024p8       = AccountingPeriod{cal}(8,FiscalPeriod,fy2024)
fy2024p2       = AccountingPeriod{cal}(2,FiscalPeriod,fy2024)
fy2024p2w4     = AccountingPeriod{cal}(4,FiscalWeek,fy2024p2)
fy2027w53      = AccountingPeriod{cal}(53,FiscalWeek,fy2027)
fy2028w1       = AccountingPeriod{cal}(1,FiscalWeek,fy2028)
fy2022q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2022)
fy2022q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2022)
fy2022q4w2     = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4)
fy2027q4w2     = AccountingPeriod{cal}(2,FiscalWeek,fy2027q4)
fy2022q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2022q4)
fy2027q4p2     = AccountingPeriod{cal}(2,FiscalPeriod,fy2027q4)
fy2027q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2027q4)
fy2022q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4p3)
fy2027q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2027q4p3)
fy2027q4p2w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2027q4p2)
fy2027p12      = AccountingPeriod{cal}(12,FiscalPeriod,fy2027)
fy2022p12      = AccountingPeriod{cal}(12,FiscalPeriod,fy2022)
fy2027p2       = AccountingPeriod{cal}(2,FiscalPeriod,fy2027)
fy2027p2w4     = AccountingPeriod{cal}(4,FiscalWeek,fy2027p2)
fy2027p12w2    = AccountingPeriod{cal}(2,FiscalWeek,fy2027p12)
fy2022p12w2    = AccountingPeriod{cal}(2,FiscalWeek,fy2022p12)
fy2022p12w3    = AccountingPeriod{cal}(3,FiscalWeek,fy2022p12)
ar             = AccountingRange(AccountingPeriod{cal}(3,FiscalPeriod,fy2024),AccountingPeriod{cal}(12,FiscalPeriod,fy2025))
ar_yrs         = AccountingRange(fy2022,fy2027)
ar_tight       = AccountingRange(fy2022,fy2022)
ar_tight₂      = AccountingRange(fy2024p2,fy2024p2)

fy2024p2      = AccountingPeriod{cal}(2,FiscalPeriod,fy2024)
fy2024p3      = AccountingPeriod{cal}(3,FiscalPeriod,fy2024)
fy2024p4      = AccountingPeriod{cal}(4,FiscalPeriod,fy2024)
fy2024p5      = AccountingPeriod{cal}(5,FiscalPeriod,fy2024)
fy2024p6      = AccountingPeriod{cal}(6,FiscalPeriod,fy2024)
fy2025p4      = AccountingPeriod{cal}(4,FiscalPeriod,fy2025)
fy2025p6      = AccountingPeriod{cal}(6,FiscalPeriod,fy2025)
fy2024p2p3    = AccountingRange(fy2024p2,fy2024p3)
fy2024p4p6    = AccountingRange(fy2024p4,fy2024p6)
fy2024p4p4    = AccountingRange(fy2024p4,fy2024p4)
fy2024p4p5    = AccountingRange(fy2024p4,fy2024p5)
fy2024p5p5    = AccountingRange(fy2024p5,fy2024p5)
fy2024p5p6    = AccountingRange(fy2024p5,fy2024p6)
fy2025p4p6    = AccountingRange(fy2025p4,fy2025p6)

@test (fy2022 < fy2022)                       == false
@test (fy2022 < fy2023)                       == true
@test (fy2022w51 < fy2023)                    == true
@test (fy2022w51 < fy2027w53)                 == true
@test (fy2022w51 < fy2027w40)                 == true
@test (fy2022p12w2 < fy2022w51)               == true
@test (fy2027q4p2w2 < fy2027p12w2)            == true

@test (fy2027q3 < fy2027p2w4)                 == false
@test (fy2027p2 > fy2027p2w4)                 == true
@test (fy2022   < fy2022p12 )                 == true
@test (fy2027q4 > fy2027q4p3w2)               == false
# Pathological case: not equal less or greater!
@test (fy2023q3 <  fy2023q3p1) 	              == false
@test (fy2023q3 >  fy2023q3p1) 	              == false
@test (fy2023q3 == fy2023q3p1) 	              == false

@test next(fy2022)                            == fy2023
@test next(fy2022p12w2)                       == fy2022p12w3
@test next(fy2022q3)                          == fy2022q4
@test next(fy2027w53)                         == fy2028w1
@test prev(next(fy2027w53))                   == fy2027w53

@test in(Date(2024,12,17),ar)                 == true
@test in(Date(2027,1,1),  ar)                 == false
@test in(fy2024p8,        ar)                 == true
@test in(fy2024p2w4,      ar)                 == false
@test in(fy2027p12,       ar)                 == false
@test in(fy2022,          ar)                 == false
@test in(fy2022,          ar_yrs)             == true
@test in(fy2028,          ar_yrs)             == false
@test in(fy2022p12w2,     ar_yrs)             == true
@test in(fy2028w1,        ar_yrs)             == false
@test in(fy2022,          ar_tight)           == true
@test in(fy2024p2,        ar_tight₂)          == true
@test in(fy2024p4,        fy2024p4p5)         == true

@test length(ar)                              == 9 + 12 + 1
@test length(ar_yrs)                          == 2027 - 2022 + 1
