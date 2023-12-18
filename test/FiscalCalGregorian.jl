using FiscalDates
using Dates
using Test


# Using `Gregorian`, end date of Dec 31st
cal            = FiscalCalGregorian{Date(2023,12,31)}
fy2022         = AccountingPeriod{cal}(2022,FiscalYear)
fy2023         = AccountingPeriod{cal}(2023,FiscalYear)
fy2023q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2023)
fy2023q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2023q3)
fy2022w51      = AccountingPeriod{cal}(51,FiscalWeek,fy2022)
fy2022q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2022)
fy2022q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2022q4)
fy2022q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4p3)
@test timeframe(fy2022).d2                 == Date(2022,12,31)    skip=true 
@test timeframe(fy2023).d1                 == Date(2023,1,1)      skip=true 
@test timeframe(fy2023q3).d2               == Date(2023,9,30)     skip=true 
@test timeframe(fy2022w51).d2              == Date(2023,12,23)    skip=true 
@test timeframe(fy2022q4).d1               == Date(2022,10,1)     skip=true 
@test timeframe(fy2022q4p3).d1             == Date(2022,12,1)     skip=true 
@test timeframe(fy2022q4p3w2).d2           == Date(2022,12,14)    skip=true 
@test FiscalDates.fiscalyear(fy2023)          == 2023                skip=true
@test FiscalDates.fiscalyear(fy2022q4p3)      == 2022                skip=true
@test FiscalDates.quarterofFY(fy2022q4p3)     == 4                   skip=true
@test FiscalDates.periodofFY(fy2022q4p3w2)    = 12                  skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)            == 9999                skip=true
@test FiscalDates.firstday(fy2022)        == Date(2022,1,1)      skip=true
@test FiscalDates.lastday(fy2023)         == Date(2023,12,31)    skip=true
# the following don't seem relevant to Gregorian calendars
# @test fc_52or53wks(fy2022)        ==                     skip=true
# @test fc_13or14wks(fy2022q4)      ==                     skip=true
# @test fc_4or5wks(fy2022q4p3)      ==                     skip=true
@test FiscalDates.offsetofFY(fy2027)          == 2027 


# Using `Gregorian`, different end date parameterization
cal            = FiscalCalGregorian{Date(2023,4,30)}
fy2022         = AccountingPeriod{cal}(2022,FiscalYear)
fy2023         = AccountingPeriod{cal}(2023,FiscalYear)
fy2023q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2023)
fy2023q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2023q3)
fy2022w51      = AccountingPeriod{cal}(51,FiscalWeek,fy2022)
fy2022q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2022)
fy2022q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2022q4)
fy2022q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4p3)
@test timeframe(fy2022).d2                     == Date(2022,4,30)     skip=true 
@test timeframe(fy2023).d1                     == Date(2022,5,1)      skip=true 
@test timeframe(fy2023q3).d2                   == Date(2022,11,30)    skip=true 
@test timeframe(fy2022w51).d2                  == Date(2022,4,21)     skip=true 
@test timeframe(fy2022q4).d1                   == Date(2023,2,1)      skip=true 
@test timeframe(fy2022q4p3).d1                 == Date(2023,4,1)      skip=true 
@test timeframe(fy2022q4p3w2).d2               == Date(2023,4,14)     skip=true 
@test FiscalDates.fiscalyear(fy2023)              == 2023                skip=true
@test FiscalDates.fiscalyear(fy2022q4p3)          == 2022                skip=true
@test FiscalDates.quarterofFY(fy2022q3)           == 3                   skip=true
@test FiscalDates.periodofFY(fy2022w51)           == 12                  skip=true
@test FiscalDates.weekofFY(fy1999)                == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)                == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)                == 9999                skip=true
@test FiscalDates.weekofFY(fy1999)                == 9999                skip=true
@test FiscalDates.firstday(fy2022)            == Date(2021,5,1)      skip=true
@test FiscalDates.lastday(fy2023)             == Date(2023,4,30)     skip=true
@test FiscalDates.offsetofFY(fy2022w51)           == 51                  skip=true

