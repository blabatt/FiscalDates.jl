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
fy2027q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2027)
fy2027q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2027)
fy2027w40      = AccountingPeriod{cal}(40,FiscalWeek,fy2027)
fy2027q4p2     = AccountingPeriod{cal}(2,FiscalPeriod,fy2027q4)
fy2023q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2023)
fy2023q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2023q3)
fy2022w51      = AccountingPeriod{cal}(51,FiscalWeek,fy2022)
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
ar     = AccountingRange(AccountingPeriod{cal}(3,FiscalPeriod,fy2024),AccountingPeriod{cal}(12,FiscalPeriod,fy2025))
ar_yrs = AccountingRange(fy2022,fy2027)
@test firstday(fy2022q4p3)                    == Date(2022,6,26)
@test lastday(fy2022)                         == Date(2022,7,30)              
@test firstday(fy2024)                        == Date(2023,7,30)              
@test lastday(fy2023q3)                       == Date(2023,4,29)              
@test lastday(fy2022w51)                      == Date(2022,7,23)              
@test firstday(fy2022q4)                      == Date(2022,5,01)              
@test lastday(fy2022q4p3w2)                   == Date(2022,7,09)              
@test FiscalDates.FY(fy2024)                  == fy2024                         
@test FiscalDates.FY(fy2022q4p3)              == fy2022                         
@test FiscalDates.FY(cal,Date(2023,12,11))    == fy2024                         
@test FiscalDates.FY(cal,Date(2022,7,30))     == fy2022                         
@test FiscalDates.FY(cal,firstday(fy2022))    == fy2022                         
@test FiscalDates.FY(cal,firstday(fy2022) - Dates.Day(1))    == fy2021                         
@test FiscalDates.quarterofFY(fy2022q4p3w2)   == 4                            
@test FiscalDates.periodofFY(fy2022q4p3w2)    == 12                           
@test FiscalDates.periodofFY(fy2022q4p3)      == 12                           
@test FiscalDates.periodofFY(fy2023q3p1)      == 7                            
@test FiscalDates.periodofFY(fy2027q4p2)      == 11                           
@test FiscalDates.weekofFY(fy2022w51)         == 51                           
@test FiscalDates.weekofFY(fy2027w53)         == 53                           
@test FiscalDates.weekofFY(fy2027p12w2)       == 50                           
@test FiscalDates.weekofFY(fy2022p12w2)       == 49                           
@test FiscalDates.weekofFY(fy2027q4w2)        == 41                           
@test FiscalDates.weekofFY(fy2022q4w2)        == 41                           
@test FiscalDates.weekofFY(fy2022q4p3w2)      == 49                           
@test FiscalDates.weekofFY(fy2027q4p3w2)      == 50                           
@test FiscalDates.weekofFY(fy2027q4p2w2)      == 45                           
@test FiscalDates.firstday(fy2024)            == Date(2023,7,30)              
@test FiscalDates.lastday(fy2022q4p3)         == Date(2022,7,30)              
@test FiscalDates.lastmonthofFY(fy2024)       == 7                             
@test FiscalDates.lastmonthofFY(fy2022q4p3)   == 7                             
@test FiscalDates.lastdowofFY(fy2024)         == Saturday                      
@test FiscalDates.lastdowofFY(fy2022q4p3)     == Saturday                       
@test FiscalDates.usinglastdayinCMlogic(fy2024)         == true                         
@test FiscalDates.usinglastdayinCMlogic(fy2022q4p3w2)   == true                         
@test FiscalDates.fc_52or53wks(fy2022)        == 52                             
@test FiscalDates.fc_52or53wks(fy2027)        == 53                               
@test FiscalDates.fc_13or14wks(fy2022q4)      == 13                               
@test FiscalDates.fc_13or14wks(fy2023q3)      == 13                               
@test FiscalDates.fc_13or14wks(fy2027q4)      == 14                               
@test FiscalDates.fc_4or5wks(fy2022q4p3)      == 5                                
@test FiscalDates.fc_4or5wks(fy2023q3p1)      == 4                                
@test FiscalDates.fc_4or5wks(fy2027q4p2)      == 5                               
@test FiscalDates.offsetofFY(fy2027q4w2)      == 41                                  
@test (fy2022 < fy2022)                       == false                              
@test (fy2022 < fy2023)                       == true                             
@test (fy2022w51 < fy2023)                    == true                               
@test (fy2022w51 < fy2027w53)                 == true                             
@test (fy2022w51 < fy2027w40)                 == true                             
@test (fy2022p12w2 < fy2022w51)               == true                             
@test (fy2027q4p2w2 < fy2027p12w2)            == true                             
@test (fy2023q3 < fy2023q3p1) 	              == true                             
@test (fy2027q3 < fy2027p2w4)                 == false                              
@test next(fy2022)                            == fy2023                             
@test next(fy2022p12w2)                       == fy2022p12w3                             
@test next(fy2022q3)                          == fy2022q4                             
@test next(fy2027w53)                         == fy2028w1                              
@test prev(next(fy2027w53))                   == fy2027w53                             
@test length(ar)                              == 9 + 12 + 1
@test length(ar_yrs)                          == 2027 - 2022 + 1
# for ap in ar
# 	println("FY", FiscalDates.FY(ap).index, ap.duration, ap.index, " from: ", firstday(ap), " to ", lastday(ap))
# end
@test repr(ar)                                == "From FY2024P3 to FY2025P12\n"


# Another parameterization of `FiscalCal445`
cal            = FiscalCal5253{Wednesday,February,ClosestTo,FourFourFive}
fy2022         = AccountingPeriod{cal}(2022,FiscalYear)
fy2023         = AccountingPeriod{cal}(2023,FiscalYear)
fy2025         = AccountingPeriod{cal}(2025,FiscalYear)
fy2026         = AccountingPeriod{cal}(2026,FiscalYear)
fy2027         = AccountingPeriod{cal}(2027,FiscalYear)
fy2022q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2027)
fy2027q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2027)
fy2022q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2022q4)
fy2027q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2027q4)
fy2022q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4p3)
fy2027q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2027q4p3)
fy2023q3       = AccountingPeriod{cal}(3,FiscalQuarter,fy2023)
fy2023q3p1     = AccountingPeriod{cal}(1,FiscalPeriod,fy2023q3)
fy2022p12      = AccountingPeriod{cal}(12,FiscalPeriod,fy2022)
fy2027p12      = AccountingPeriod{cal}(12,FiscalPeriod,fy2027)
fy2022p12w13   = AccountingPeriod{cal}(13,FiscalWeek,fy2022p12)
fy2027p12w13   = AccountingPeriod{cal}(13,FiscalWeek,fy2027p12)
fy2022q4w13    = AccountingPeriod{cal}(13,FiscalWeek,fy2022q4)
fy2027q4w13    = AccountingPeriod{cal}(13,FiscalWeek,fy2027q4)
fy2022w51      = AccountingPeriod{cal}(51,FiscalWeek,fy2022)
fy2027w53      = AccountingPeriod{cal}(53,FiscalWeek,fy2027)
fy2022q4       = AccountingPeriod{cal}(4,FiscalQuarter,fy2022)
fy2022q4p3     = AccountingPeriod{cal}(3,FiscalPeriod,fy2022q4)
fy2022q4p3w2   = AccountingPeriod{cal}(2,FiscalWeek,fy2022q4p3)
@test lastday(fy2022)                         == Date(2022,3,2)       
@test firstday(fy2025)                        == Date(2024,2,29)      
@test lastday(fy2023q3)                       == Date(2022,11,30)     
@test lastday(fy2022w51)                      == Date(2022,2,23)      
@test firstday(fy2022q4)                      == Date(2021,12,2)      
@test firstday(fy2022q4p3)                    == Date(2022,1,27)      
@test lastday(fy2022q4p3w2)                   == Date(2022,2,9)       
@test FiscalDates.FY(fy2025)                  == fy2025
@test FiscalDates.FY(fy2022q4p3)              == fy2022                
@test FiscalDates.quarterofFY(fy2023q3)       == 3                   
@test FiscalDates.periodofFY(fy2022q4p3)      == 12                 
@test FiscalDates.weekofFY(fy2022w51)         == 51                  
@test FiscalDates.weekofFY(fy2027w53)         == 53                  
@test FiscalDates.weekofFY(fy2022p12w2)       == 49                  
@test FiscalDates.weekofFY(fy2027p12w2)       == 50                  
@test FiscalDates.weekofFY(fy2022q4w13)       == (4-1)*13+13 
@test FiscalDates.weekofFY(fy2027q4w13)       == (4-1)*13+13 
@test FiscalDates.weekofFY(fy2022q4p3w2)      == (4-1)*13+(3-1)*4+2  
@test FiscalDates.weekofFY(fy2027q4p3w2)      == (4-1)*13+(3-1)*4+2+1
@test FiscalDates.firstday(fy2026)            == Date(2025,2,27)    
@test FiscalDates.lastday(fy2023)             == Date(2023,3,1)    
@test FiscalDates.lastmonthofFY(fy2025)       == 2                   
@test FiscalDates.lastmonthofFY(fy2022q4p3)   == 2                   
@test FiscalDates.lastdowofFY(fy2022)         == Wednesday           
@test FiscalDates.lastdowofFY(fy2022q4p3)     == Wednesday           
@test FiscalDates.usinglastdayinCMlogic(fy2025)         == false               
@test FiscalDates.usinglastdayinCMlogic(fy2022q4p3)     == false               
@test FiscalDates.fc_52or53wks(fy2022)        == 52                  
@test FiscalDates.fc_52or53wks(fy2023)        == 52                  
@test FiscalDates.fc_52or53wks(fy2027)        == 53               
@test FiscalDates.fc_13or14wks(fy2022q4)      == 13                  
@test FiscalDates.fc_13or14wks(fy2023q3)      == 13                  
@test FiscalDates.fc_13or14wks(fy2027q4)      == 14              
@test FiscalDates.fc_4or5wks(fy2022q4p3)      == 5                   
@test FiscalDates.fc_4or5wks(fy2023q3p1)      == 4                   
@test FiscalDates.fc_4or5wks(fy2027q4p2)      == 5                   
@test FiscalDates.offsetofFY(fy2027q4p2)      == 11 

