using FiscalDates
using Dates
using Test


# Using `FiscalCalBroadcast`
cal            = FiscalCalBroadcast
fy2022         = AccountingPeriod{cal}(2022,FiscalYear)
fy2023         = AccountingPeriod{cal}(2023,FiscalYear)
fy2028         = AccountingPeriod{cal}(2028,FiscalYear)
fy2023q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2023)
fy2023q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2023q3)
fy2023q2       = AccountingPeriod{cal}(2,FiscalQuarter,fy2023)
fy2023q2w8     = AccountingPeriod{cal}(8,FiscalWeek,fy2023q2)
fy2022w51      = AccountingPeriod{cal}(51,FiscalWeek,fy2022)
fy2022q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2022)
fy2022q4p2     = AccountingPeriod{cal}(2,FiscalPeriod,fy2022q4)
fy2022q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2022q4)
fy2022q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4p3)
@test timeframe(fy2022).d1                 == Date(2021,12,27)    skip=true 
@test timeframe(fy2023).d1                 == Date(2022,12,26)    skip=true 
@test timeframe(fy2023q3).d2               == Date(2023,9,24)     skip=true 
@test timeframe(fy2022w51).d2              == Date(2022,12,18)    skip=true 
@test timeframe(fy2022q4).d1               == Date(2022,9,26)     skip=true 
@test timeframe(fy2022q4p3).d1             == Date(2022,11,28)    skip=true 
@test timeframe(fy2022q4p3w2).d2           == Date(2022,12,11)    skip=true 
@test FiscalDates.fiscalyear(fy2023)          == 2023                skip=true
@test FiscalDates.fiscalyear(fy2022q4p3)      == 2022                skip=true
@test FiscalDates.quarterofFY(fy2022q4p3)     == 4                   skip=true
@test FiscalDates.periodofFY(fy2023q2w8)      == 5                   skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.firstday(fy2028)        == Date(2027,12,27)    skip=true
@test FiscalDates.lastday(fy2022)         == Date(2022,12,25)    skip=true
@test FiscalDates.fc_52or53wks(fy2022)        == 53                  skip=true
@test FiscalDates.fc_52or53wks(fy2023)        == 52                  skip=true
@test FiscalDates.fc_13or14wks(fy2022q4)      == 53                  skip=true
@test FiscalDates.fc_13or14wks(fy2023q3)      == 52                  skip=true
@test FiscalDates.fc_4or5wks(fy2022q4p2)      == 5                   skip=true
@test FiscalDates.fc_4or5wks(fy2022q4p3)      == 5                   skip=true
@test FiscalDates.offsetofFY(fy2023q2w8)      == 21                  skip=true


