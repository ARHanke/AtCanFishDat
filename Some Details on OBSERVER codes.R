sqlQuery(channel, "select * from observer.isoperationcodes")
#OPTNCD_ID            OPERATION
# 1          1     GROUNDFISH/SQUID
# 2          2         SCALLOP DRAG
# 3          3          PURSE SEINE
# 4          4 SHARK,TUNA,SWORDFISH
# 5          5         SQUID JIGGER
# 6          6  OVER THE SIDE SALES
# 7          7             RESEARCH
# 8          8               SHRIMP
# 9          9                OTHER
# 10        90               SURVEY

sqlQuery(channel, "select * from observer.ISGEARFEATURECODES")
# GEARFCD_ID      GEARFCL_ID                               FEATURE QUANT_DATA
# 8          101 GEAR DIMENSIONS           DISTANCE BETWEEN FLOATS (M)          Y
# 9          102 GEAR DIMENSIONS        NUMBER OF HOOKS BETWEEN FLOATS          Y
# 10         103 GEAR DIMENSIONS                LENGTH OF GANGINGS (M)          Y
# 11         104 GEAR DIMENSIONS       LENGTH BETWEEN LIGHT BUOYS (KM)          Y
# 12         105 GEAR DIMENSIONS            DISTANCE BETWEEN HOOKS (M)          Y
# 13         106 GEAR DIMENSIONS       LENGTH BETWEEN RADIO BUOYS (KM)          Y
# 48         140      HOOK TYPES                                J-HOOK          N
# 49         141      HOOK TYPES                                CIRCLE          N
# 50         142      HOOK TYPES                     LONG-SHANK CIRCLE          N
# 51         143      HOOK TYPES                    SHORT-SHANK CIRCLE          N
# 52         144      HOOK TYPES                       MODIFIED J-HOOK          N
# 53         150     HOOK MAKERS                                MUSTAD          N
# 54         151     HOOK MAKERS                            EAGLE CLAW          N
# 55         120      BAIT TYPES                                LIGHTS          N
# 56         121      BAIT TYPES                             BAIT (NS)          N
# 57         122      BAIT TYPES                                 LURES          N
# 71         123      BAIT TYPES                                 SQUID          N
# 72         124      BAIT TYPES                             ATL SAURY          N
# 73         125      BAIT TYPES                              MACKEREL          N
# 74         118      BAIT TYPES                        MACKEREL/SQUID          N
# 75         152     HOOK MAKERS                               MILWARD          N
# 76         127      BAIT TYPES                               HERRING          N
# 77         117      BAIT TYPES                      HERRING/MACKEREL          N
# 78         119      BAIT TYPES                HERRING/MACKEREL/SQUID          N
# 79         130      BAIT TYPES                                  SHAD          N
# 80         131      BAIT TYPES                             GASPEREAU          N
# 81         132      BAIT TYPES                             ROCK CRAB          N
# 82         133      BAIT TYPES                              RED HAKE          N
# 83         134      BAIT TYPES                               REDFISH          N
# 84         135      BAIT TYPES                              SCULPINS          N
# 85         129      BAIT TYPES                             SEA RAVEN          N
# 86         128      BAIT TYPES                              LUMPFISH          N
# 87         126      BAIT TYPES                       ALFONSINO HEADS          N
# 88         136      BAIT TYPES                            BUTTERFISH          N
# 89         137      BAIT TYPES                         HERRING/SQUID          N
# 92         116      BAIT TYPES                         HERRING/LURES          N
# 93         114      BAIT TYPES                          SQUID/LIGHTS          N
# 94         115      BAIT TYPES                       MACKEREL/LIGHTS          N
# 95         113      BAIT TYPES                         BAIT / LIGHTS          N
# 96         138      BAIT TYPES                    REDFISH / MACKEREL          N
# 97          91 GEAR DIMENSIONS                     CENTER WEIGHT(KG)          Y
# 100        153     HOOK MAKERS                   FISKEVEGN (russian)          N
# 101        145      HOOK TYPES                    E-Z HOOK (russian)          N
# 102        216      TRAP TYPES                             NORDIK 99          N
# 107        322 GEAR DIMENSIONS                 HIGH INTENSITY LIGHTS          Y
# 108        323 GEAR DIMENSIONS                         STROBE LIGHTS          Y
# 123        112      BAIT TYPES             ARTIFICIAL - TREATED HIDE          N
# 153        450      BAIT TYPES                               HADDOCK          N
# 154        451      BAIT TYPES                                CUNNER          N
# 155        452      BAIT TYPES                              FLOUNDER          N
# 156        453      BAIT TYPES                                   COD          N
# 157        454      BAIT TYPES                                SALMON          N
# 158        455      BAIT TYPES                           SILVER HAKE          N
# 159        456      BAIT TYPES                               CAPELIN          N
# 160        457      BAIT TYPES                                 TROUT          N
# 161        458      BAIT TYPES                                 SMELT          N
# 167        459      BAIT TYPES                                  CUSK          N
# 168        460      BAIT TYPES                               DOGFISH          N
# 169        461      BAIT TYPES                     GREENLAND HALIBUT          N
# 170        462      BAIT TYPES                               POLLOCK          N
# 171        463      BAIT TYPES                                 SKATE          N
# 172        464      BAIT TYPES                            WHITE HAKE          N
# 173        465      BAIT TYPES                     ATLANTIC WOLFFISH          N
# 174        466      BAIT TYPES                      SPOTTED WOLFFISH          N
# 175        467      BAIT TYPES                       GROUNDFISH (NS)          N
# 176        154     HOOK MAKERS                                 CATCH          N

sqlQuery(channel, "select * from observer.ISGEARCODES")[,1:3]
# GEARCD_ID       GEAR                    DESCRIPTION
# 20  31   PS  PURSE SEINE
# 21  40   GN GILLNETS (NOT SPECIFIED)
# 22  41  GNS SET GILLNETS
# 23  42  GND     DRIFT GILLNETS
# 24  50   LL  LONGLINE (TYPE NOT SPECIFIED)
# 25  51  LLS SET LINES (BOTTOM OR NEAR BOT.
# 26  52  LLD DRIFT LINES (DRIFTING LONGLINE
# 27  53  LHP HANDLINES (INC.POLELINES,JIG-L
# 28  54  LTL  TROLL LINES
# 29  55  LHM  MECHANIZED SQUID JIGGER
# 30  58  LDV   DORY VESSEL LINE GEARS
# 31  60  FIX     TRAPS (TYPE NOT SPECIFIED)
# 34  63  FWR  WEIRS
# 37  81  HAR     HARPOONS
# 38  90  MIS   OTHER GEARS UNCOVER.BY ABOVE
# 47  99   NK   GEARS NOT KNOWN OR SPECIFIED
# 51  30   PS PURSE SEINERS (CHARTERS)
# 52  39   GNGILLNETS (CHARTERS)
# 53  49   LLLONGLINE (CHARTERS)

sqlQuery(channel, "select * from observer.ISSPECIESSOUGHTCODES")[,1:3]
#SPECSCD_ID                        COMMON                      SCIENTIFIC
# 18         71                  BLUEFIN TUNA                 THUNNUS THYNNUS
# 19         72                     SWORDFISH                 XIPHIAS GLADIUS
# 20         73               TUNA, SWORDFISH          SCOMBROIDEI (SUBORDER)
# 21        190                 ALBACORE TUNA                THUNNUS ALALUNGA
# 22        191                YELLOWFIN TUNA               THUNNUS ALBACARES
# 23        192                   BIGEYE TUNA                  THUNNUS OBESUS
# 28        230      PORBEAGLE,MACKEREL SHARK                     LAMNA NASUS
# 47       7001         COD, HADDOCK, POLLOCK                            <NA>
# 48       7002 SILVER HAKE, SQUID, ARGENTINE                            <NA>
# 49       7099                         OTHER                            <NA>
# 52       7011            ECOSYSTEM SAMPLING                            <NA>
 
sqlQuery(channel, "select * from observer.ISSPECIESCODES where SPECCD_ID in (30,7001,4511,71,72,73,190,191,192,230,7099)")[,1:2]
# SPECCD_ID                   COMMON
# 1        72                SWORDFISH
# 2      7099                 RESERVED
# 3       230 PORBEAGLE,MACKEREL SHARK
# 4        71             BLUEFIN TUNA
# 5       191           YELLOWFIN TUNA
# 6       190            ALBACORE TUNA
# 7        73   TUNAS,SWORDFISHES,ETC.
# 8       192              BIGEYE TUNA

sqlQuery(channel, "select year_landed, country,count(country) from observer.catch_samples where species = 72 group by year_landed, country")
sqlQuery(channel, "select year_landed, country,count(country) from observer.catch_samples where species = 72 group by year_landed, country order by country")

sqlQuery(channel, "select min(board_date) from observer.istrips")
sqlQuery(channel, "select * from observer.istriptypecodes")
  # 8         70                      MACKEREL         NA         <NA>             NA             <NA>
  # 9         72                     SWORDFISH         NA         <NA>             NA             <NA>
  # 10        73               TUNA, SWORDFISH         NA         <NA>             NA             <NA>
  
sqlQuery(channel, "select * from observer.issettypecodes") 
# SETCD_ID                SET_TYPE
# 1         1              COMMERCIAL
# 2         2   TEST FISHERY - LENGTH
# 3         3  TEST FISHERY - BYCATCH
# 4         4          SURVEY - FIXED
# 5         5         SURVEY - RANDOM
# 6         6 SURVEY - FISHERS CHOICE
# 7         7    COMMERCIAL - C AND P
# 8         8             EXPLORATORY
# 9         9            EXPERIMENTAL
# 10       10        COMMERCIAL INDEX
# 11       11         ECOSYSTEM STUDY

sqlQuery(channel, "select * from observer.ISCOUNTRYCODES ")
# CTRYCD_ID              COUNTRY
# 1          2               CANADA
# 2          3        CANADA - NFLD
# 3          4                 CUBA
# 4          8    FRANCE (MAINLAND)
# 5         12              ICELAND
# 6         16               POLAND
# 7         18              ROMANIA
# 8         21                   UK
# 9         31               LATVIA
# 10        32              ESTONIA
# 11        33            LITHUANIA
# 12         1             BULGARIA
# 13         5               FAROES
# 14         6            GREENLAND
# 15         7              DENMARK
# 16         9         FRANCE (SPM)
# 17        10 FED. REP. OF GERMANY
# 18        11     GERMAN DEM. REP.
# 19        13                ITALY
# 20        14                JAPAN
# 21        15               NORWAY
# 22        17             PORTUGAL
# 23        19                SPAIN
# 24        20                 USSR
# 25        22                  USA
# 26        23               ISRAEL
# 27        24              IRELAND
# 28        34               RUSSIA
# 29        25          SOUTH KOREA

sqlQuery(channel, paste("select year_landed,gear,country,count(country)",
                    "from observer.catch_samples",
                    "where gear in (50,52,55)",
                    "group by year_landed,gear,country",
                    "order by country,year_landed,gear"))

sqlQuery(channel, "select * from observer.ISGEARFEATURES")[1:10,]

sqlQuery(channel,paste("SELECT min(setdate)",
                       "FROM observer.issetprofile",
                      "WHERE pntcd_id in (1,2,3,4)",          
                      "AND extract(year from setdate) > 1976",sep=" "))

sqlQuery(channel,paste("Select min(created_date) from observer.isgears where gearcd_id=52"))

sqlQuery(channel, "select min(board_date) from observer.istrips where trip_id in (select trip_id from observer.isgears where gearcd_id = 52)")
a = sqlQuery(channel, paste("select a.*, b.num_hook_haul, c.gearcd_id from observer.istrips a",
            "INNER JOIN observer.isfishsets b ",
            "ON a.trip_id = b.trip_id",
            "INNER JOIN observer.isgears c",
            "ON b.gear_id = c.gear_id",
            "Where num_hook_haul > 0"))
a = as.data.table(a)
a[,YEAR:=format(BOARD_DATE,"%Y")]
a[,.(mean(NUM_HOOK_HAUL),.N),by=YEAR]
a[YEAR==1978]
a[GEARCD_ID==55,]
print(a[order(GEARCD_ID,YEAR),.(N=.N,MHH=mean(NUM_HOOK_HAUL)),by=.(YEAR,GEARCD_ID)],topn=100)

