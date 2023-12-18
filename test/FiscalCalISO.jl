using FiscalDates
using Dates
using Test


# Using `FiscalCalISO`
cal            = FiscalCalISO
fy2022         = AccountingPeriod{cal}(2022,FiscalYear)
fy2026         = AccountingPeriod{cal}(2026,FiscalYear)
fy2023         = AccountingPeriod{cal}(2023,FiscalYear)
fy2022q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2022)
fy2023q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2023)
fy2023q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2023)
fy2022q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2022q3)
fy2023q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2023q3)
fy2022w51      = AccountingPeriod{cal}(51,FiscalWeek,fy2022)
fy2022q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2022)
fy2022q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2022q4)
fy2023q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2023q4)
fy2022q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4p3)
@test timeframe(fy2022).d2                   == Date(2023,1,1)      skip=true 
@test timeframe(fy2026).d1                   == Date(2025,12,29)    skip=true 
@test timeframe(fy2023q3).d2                 == Date(2023,10,1)     skip=true 
@test timeframe(fy2022w51).d2                == Date(2022,12,25)    skip=true 
@test timeframe(fy2022q4).d1                 == Date(2022,10,3)     skip=true 
@test timeframe(fy2022q4p3).d1               == Date(2022,11,28)    skip=true  # these are non-standard formulations ...
@test timeframe(fy2022q4p3w2).d2             == Date(2022,12,19)    skip=true  # ISO has no notion of month, though there 
@test FiscalDates.fiscalyear(fy2026)            == 2026                skip=true	# must be 4,4,5 weeks per period in each Q
@test FiscalDates.fiscalyear(fy2022q4p3)        == 2022                skip=true	# or 4,5,5 in Q4 of a leap year
@test FiscalDates.quarterofFY(fy2022w51)        == 4                   skip=true
@test FiscalDates.periodofFY(fy2022q3p1)        == 7                   skip=true
@test FiscalDates.firstday(fy2023q3)        == Date(2023,1,2)      skip=true
@test FiscalDates.lastday(fy2026)           == Date(2027,1,3)      skip=true
@test FiscalDates.weekofFY(fy1999)              == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)              == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)              == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)              == 9999                skip=true
@test FiscalDates.fc_52or53wks(fy2022)          == 52                  skip=true
@test FiscalDates.fc_52or53wks(fy2026)          == 53                  skip=true
@test FiscalDates.fc_13or14wks(fy2023q3)        == 13                  skip=true
@test FiscalDates.fc_13or14wks(fy2022q4)        == 13                  skip=true
@test FiscalDates.fc_4or5wks(fy2023q3p1)        == 4                   skip=true
@test FiscalDates.fc_4or5wks(fy2022q4p3)        == 5                   skip=true
@test FiscalDates.offsetofFY(fy2022q3p1)        == 7                   skip=true
