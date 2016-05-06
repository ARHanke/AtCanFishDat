rem create annual tables of log-based catch-effort data (with some help from the slip data)
rem This job works for 1986-1995 and 1998-2002 (1996-1997 were missed when formatting was amended to deal with 4-digit years)
rem This job is run in SQL-Plus via '@d:\assess\extract\marfis\ziff\testrun.sql'
ACCEPT Y CHAR PROMPT 'Enter the Year (yyyy) >';
drop table agglog;
create table agglog as
select d.log_code lcode, (substr(d.log_code,1,14) || substr(d.log_code,16,5)) logcode,substr(e.t_species_id_est,1,3) spec,sum(e.t_live_weight/1000) logwt
from cl.log_detail_&&Y d, cl.log_estimate_&&Y e
where d.log_code=e.log_code
and d.estimate_key=e.estimate_key
group by d.log_code,substr(e.t_species_id_est,1,3);
rem Ignoring gear on the slip for selecting, as it is often incorrect.
drop table slip;
create table slip as
select (substr(slip_code,1,14) || substr(slip_code,16,5)) slipcode,gear_id gear,substr(species_id,1,3) spec,sum(t_live_weight/1000) slipwt
from cl.slip_detail_&&Y
group by (substr(slip_code,1,14) || substr(slip_code,16,5)),gear_id,substr(species_id,1,3);
rem Both slip and log denote the gear, making it seem a likely link for joining. However
rem the gear type is miscoded on the slip with extreme frequency, as evidenced by the
rem nature of the effort data in the log (typically suitable for the log gear type when
rem log and slip disagree). Thus gear is discounted when joining.
rem and l.gear=s.gear (+)
rem Have to edit for desired species codes. The structure facilitates keeping track of species composition in the catch. The TotalWt is for all species,
rem for whatever aggregation the source data represents (set, trip, etc), so can be used to check if a given record might be shy a relevant species. I.e.
rem it is not the summed weight of the species selected, but of all species in the catch.
rem Originally written for CPUE analyses, with following filters.
rem and gear_id in ('1200','1500','1900','2100','3100','4100','5100','6200','6300','7100')
rem and t_live_weight>0
rem and (t_nbr_hours>0 or t_nbr_sets>0 or t_nbr_tows>0 or t_nbr_hooks>0)
drop table logadjslip;
create table logadjslip as
select l.lcode,l.logcode,l.spec,logwt,nvl(slipwt,0) slipwt,nvl((nvl(slipwt,0)/nullif(logwt,0)),1) adjfac
from agglog l, slip s
where logcode=slipcode (+)
and l.spec=s.spec (+);
drop table cpuelog;
create table cpuelog as
select h.log_code logcode, e.estimate_key ekey, substr(h.log_code,1,6) cfv,unit_area area,  date_fished,
t_latitude lat, t_longitude lon,substr(gear_id,1,2) gear,(t_depth/1.83) depth,
effort_measure eff,t_nbr_hours hrs,t_nbr_sets sets,t_nbr_tows tows,
t_nbr_hooks hooks,
unit_of_measure units,
nvl(sum(nvl((t_live_weight/1000),0)),0) TotalWt,
nvl(sum(decode(substr(t_species_id_est,1,3),'351', nvl((t_live_weight/1000), 0))),0) Argentine,
nvl(sum(decode(substr(t_species_id_est,1,3),'360', nvl((t_live_weight/1000), 0))),0) Capelin,
nvl(sum(decode(substr(t_species_id_est,1,3),'100', nvl((t_live_weight/1000), 0))),0) Cod,
nvl(sum(decode(substr(t_species_id_est,1,3),'173', nvl((t_live_weight/1000), 0))),0) Cusk,
nvl(sum(decode(substr(t_species_id_est,1,3),'362', nvl((t_live_weight/1000), 0))),0) Dogfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'143', nvl((t_live_weight/1000), 0))),0) WinterF,
nvl(sum(decode(substr(t_species_id_est,1,3),'142', nvl((t_live_weight/1000), 0))),0) WitchF,
nvl(sum(decode(substr(t_species_id_est,1,3),'141', nvl((t_live_weight/1000), 0))),0) YellowtailF,
nvl(sum(decode(substr(t_species_id_est,1,3),'179', nvl((t_live_weight/1000), 0))),0) Grenadier,
nvl(sum(decode(substr(t_species_id_est,1,3),'110', nvl((t_live_weight/1000), 0))),0) Haddock,
nvl(sum(decode(substr(t_species_id_est,1,3),'172', nvl((t_live_weight/1000), 0))),0) HakeS,
nvl(sum(decode(substr(t_species_id_est,1,3),'171', nvl((t_live_weight/1000), 0))),0) HakeW,
nvl(sum(decode(substr(t_species_id_est,1,3),'130', nvl((t_live_weight/1000), 0))),0) Halibut,
nvl(sum(decode(substr(t_species_id_est,1,3),'200', nvl((t_live_weight/1000), 0))),0) Herring,
nvl(sum(decode(substr(t_species_id_est,1,3),'177', nvl((t_live_weight/1000), 0))),0) Monkfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'140', nvl((t_live_weight/1000), 0))),0) Plaice,
nvl(sum(decode(substr(t_species_id_est,1,3),'170', nvl((t_live_weight/1000), 0))),0) Pollock,
nvl(sum(decode(substr(t_species_id_est,1,3),'120', nvl((t_live_weight/1000), 0))),0) Redfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'372', nvl((t_live_weight/1000), 0))),0) SharkB,
nvl(sum(decode(substr(t_species_id_est,1,3),'369', nvl((t_live_weight/1000), 0))),0) SharkP,
nvl(sum(decode(substr(t_species_id_est,1,3),'356', nvl((t_live_weight/1000), 0))),0) Skate,
nvl(sum(decode(substr(t_species_id_est,1,3),'144', nvl((t_live_weight/1000), 0))),0) Turbot,
nvl(sum(decode(substr(t_species_id_est,1,3),'174', nvl((t_live_weight/1000), 0))),0) Wolffish,
nvl(sum(decode(substr(t_species_id_est,1,3),'250', nvl((t_live_weight/1000), 0))),0) Mackerel,
nvl(sum(decode(substr(t_species_id_est,1,3),'608', nvl((t_live_weight/1000), 0))),0) SurfClam,
nvl(sum(decode(substr(t_species_id_est,1,3),'612', nvl((t_live_weight/1000), 0))),0) Scallop,
nvl(sum(decode(substr(t_species_id_est,1,3),'613', nvl((t_live_weight/1000), 0))),0) Squid,
nvl(sum(decode(substr(t_species_id_est,1,3),'617', nvl((t_live_weight/1000), 0))),0) Whelk,
nvl(sum(decode(substr(t_species_id_est,1,3),'700', nvl((t_live_weight/1000), 0))),0) Lobster,
nvl(sum(decode(substr(t_species_id_est,1,3),'702', nvl((t_live_weight/1000), 0))),0) Shrimp,
nvl(sum(decode(substr(t_species_id_est,1,3),'705', nvl((t_live_weight/1000), 0))),0) SnowCrab,
nvl(sum(decode(substr(t_species_id_est,1,3),'703', nvl((t_live_weight/1000), 0))),0) JonahCrab,
nvl(sum(decode(substr(t_species_id_est,1,3),'712', nvl((t_live_weight/1000), 0))),0) PMont,
nvl(sum(decode(substr(t_species_id_est,1,3),'251', nvl((t_live_weight/1000), 0))),0) Swordfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'252', nvl((t_live_weight/1000), 0))),0) TunaAlb,
nvl(sum(decode(substr(t_species_id_est,1,3),'253', nvl((t_live_weight/1000), 0))),0) TunaBE,
nvl(sum(decode(substr(t_species_id_est,1,3),'254', nvl((t_live_weight/1000), 0))),0) TunaBF,
nvl(sum(decode(substr(t_species_id_est,1,3),'255', nvl((t_live_weight/1000), 0))),0) TunaSJ,
nvl(sum(decode(substr(t_species_id_est,1,3),'256', nvl((t_live_weight/1000), 0))),0) TunaYF,
nvl(sum(decode(substr(t_species_id_est,1,3),'259', nvl((t_live_weight/1000), 0))),0) TunaUnk,
nvl(sum(decode(substr(t_species_id_est,1,3),'375', nvl((t_live_weight/1000), 0))),0) SharkM,
nvl(sum(decode(substr(t_species_id_est,1,3),'379', nvl((t_live_weight/1000), 0))),0) SharkUnk,
nvl(sum(decode(substr(t_species_id_est,1,3),'350', nvl((t_live_weight/1000), 0))),0) Alewife,
nvl(sum(decode(substr(t_species_id_est,1,3),'149', nvl((t_live_weight/1000), 0))),0) UNKFlounder
from cl.log_header_&&Y h,cl.log_detail_&&Y d,cl.log_estimate_&&Y e
where h.log_code=d.log_code
and h.log_code=e.log_code
and d.estimate_key=e.estimate_key
group by e.estimate_key, h.log_code, unit_area,  date_fished,
t_latitude, t_longitude,gear_id,(t_depth/1.83),
effort_measure,t_nbr_hours,t_nbr_sets,t_nbr_tows,
t_nbr_hooks,t_lines_per_tub, t_hooks_per_line,unit_of_measure;
drop table cpueslip;
create table cpueslip as
select h.log_code logcode, e.estimate_key ekey, substr(h.log_code,1,6) cfv,unit_area area,  date_fished,
t_latitude lat, t_longitude lon,substr(gear_id,1,2) gear,(t_depth/1.83) depth,
effort_measure eff,t_nbr_hours hrs,t_nbr_sets sets,t_nbr_tows tows,
t_nbr_hooks hooks,
unit_of_measure units,
nvl(sum(nvl((t_live_weight/1000),0)),0) TotalWt,
nvl(sum(decode(substr(t_species_id_est,1,3),'351', nvl((adjfac*t_live_weight/1000), 0))),0) Argentine,
nvl(sum(decode(substr(t_species_id_est,1,3),'360', nvl((adjfac*t_live_weight/1000), 0))),0) Capelin,
nvl(sum(decode(substr(t_species_id_est,1,3),'100', nvl((adjfac*t_live_weight/1000), 0))),0) Cod,
nvl(sum(decode(substr(t_species_id_est,1,3),'173', nvl((adjfac*t_live_weight/1000), 0))),0) Cusk,
nvl(sum(decode(substr(t_species_id_est,1,3),'362', nvl((adjfac*t_live_weight/1000), 0))),0) Dogfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'143', nvl((adjfac*t_live_weight/1000), 0))),0) WinterF,
nvl(sum(decode(substr(t_species_id_est,1,3),'142', nvl((adjfac*t_live_weight/1000), 0))),0) WitchF,
nvl(sum(decode(substr(t_species_id_est,1,3),'141', nvl((adjfac*t_live_weight/1000), 0))),0) YellowtailF,
nvl(sum(decode(substr(t_species_id_est,1,3),'179', nvl((adjfac*t_live_weight/1000), 0))),0) Grenadier,
nvl(sum(decode(substr(t_species_id_est,1,3),'110', nvl((adjfac*t_live_weight/1000), 0))),0) Haddock,
nvl(sum(decode(substr(t_species_id_est,1,3),'172', nvl((adjfac*t_live_weight/1000), 0))),0) HakeS,
nvl(sum(decode(substr(t_species_id_est,1,3),'171', nvl((adjfac*t_live_weight/1000), 0))),0) HakeW,
nvl(sum(decode(substr(t_species_id_est,1,3),'130', nvl((adjfac*t_live_weight/1000), 0))),0) Halibut,
nvl(sum(decode(substr(t_species_id_est,1,3),'200', nvl((adjfac*t_live_weight/1000), 0))),0) Herring,
nvl(sum(decode(substr(t_species_id_est,1,3),'177', nvl((adjfac*t_live_weight/1000), 0))),0) Monkfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'140', nvl((adjfac*t_live_weight/1000), 0))),0) Plaice,
nvl(sum(decode(substr(t_species_id_est,1,3),'170', nvl((adjfac*t_live_weight/1000), 0))),0) Pollock,
nvl(sum(decode(substr(t_species_id_est,1,3),'120', nvl((adjfac*t_live_weight/1000), 0))),0) Redfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'372', nvl((adjfac*t_live_weight/1000), 0))),0) SharkB,
nvl(sum(decode(substr(t_species_id_est,1,3),'369', nvl((adjfac*t_live_weight/1000), 0))),0) SharkP,
nvl(sum(decode(substr(t_species_id_est,1,3),'356', nvl((adjfac*t_live_weight/1000), 0))),0) Skate,
nvl(sum(decode(substr(t_species_id_est,1,3),'144', nvl((adjfac*t_live_weight/1000), 0))),0) Turbot,
nvl(sum(decode(substr(t_species_id_est,1,3),'174', nvl((adjfac*t_live_weight/1000), 0))),0) Wolffish,
nvl(sum(decode(substr(t_species_id_est,1,3),'250', nvl((adjfac*t_live_weight/1000), 0))),0) Mackerel,
nvl(sum(decode(substr(t_species_id_est,1,3),'608', nvl((adjfac*t_live_weight/1000), 0))),0) SurfClam,
nvl(sum(decode(substr(t_species_id_est,1,3),'612', nvl((adjfac*t_live_weight/1000), 0))),0) Scallop,
nvl(sum(decode(substr(t_species_id_est,1,3),'613', nvl((adjfac*t_live_weight/1000), 0))),0) Squid,
nvl(sum(decode(substr(t_species_id_est,1,3),'617', nvl((adjfac*t_live_weight/1000), 0))),0) Whelk,
nvl(sum(decode(substr(t_species_id_est,1,3),'700', nvl((adjfac*t_live_weight/1000), 0))),0) Lobster,
nvl(sum(decode(substr(t_species_id_est,1,3),'702', nvl((adjfac*t_live_weight/1000), 0))),0) Shrimp,
nvl(sum(decode(substr(t_species_id_est,1,3),'705', nvl((adjfac*t_live_weight/1000), 0))),0) SnowCrab,
nvl(sum(decode(substr(t_species_id_est,1,3),'703', nvl((adjfac*t_live_weight/1000), 0))),0) JonahCrab,
nvl(sum(decode(substr(t_species_id_est,1,3),'712', nvl((adjfac*t_live_weight/1000), 0))),0) PMont,
nvl(sum(decode(substr(t_species_id_est,1,3),'251', nvl((adjfac*t_live_weight/1000), 0))),0) Swordfish,
nvl(sum(decode(substr(t_species_id_est,1,3),'252', nvl((adjfac*t_live_weight/1000), 0))),0) TunaAlb,
nvl(sum(decode(substr(t_species_id_est,1,3),'253', nvl((adjfac*t_live_weight/1000), 0))),0) TunaBE,
nvl(sum(decode(substr(t_species_id_est,1,3),'254', nvl((adjfac*t_live_weight/1000), 0))),0) TunaBF,
nvl(sum(decode(substr(t_species_id_est,1,3),'255', nvl((adjfac*t_live_weight/1000), 0))),0) TunaSJ,
nvl(sum(decode(substr(t_species_id_est,1,3),'256', nvl((adjfac*t_live_weight/1000), 0))),0) TunaYF,
nvl(sum(decode(substr(t_species_id_est,1,3),'259', nvl((adjfac*t_live_weight/1000), 0))),0) TunaUnk,
nvl(sum(decode(substr(t_species_id_est,1,3),'375', nvl((adjfac*t_live_weight/1000), 0))),0) SharkM,
nvl(sum(decode(substr(t_species_id_est,1,3),'379', nvl((adjfac*t_live_weight/1000), 0))),0) SharkUnk,
nvl(sum(decode(substr(t_species_id_est,1,3),'350', nvl((adjfac*t_live_weight/1000), 0))),0) Alewife,
nvl(sum(decode(substr(t_species_id_est,1,3),'149', nvl((adjfac*t_live_weight/1000), 0))),0) UNKFlounder
from cl.log_header_&&Y h,cl.log_detail_&&Y d,cl.log_estimate_&&Y e, logadjslip l
where h.log_code=d.log_code
and h.log_code=e.log_code
and h.log_code=l.lcode
and d.estimate_key=e.estimate_key
and substr(t_species_id_est,1,3)=spec (+)
group by e.estimate_key, h.log_code, unit_area,  date_fished,
t_latitude, t_longitude,gear_id,(t_depth/1.83),
effort_measure,t_nbr_hours,t_nbr_sets,t_nbr_tows,
t_nbr_hooks,t_lines_per_tub, t_hooks_per_line,unit_of_measure;
rem Based on 2000, the effort variable possibilities sets, tows and hooks
rem  were mutually exclusive. Only one ever existed, hours being the sole
rem  likelihood of a second effort variable. This fits with the ZIF practice
rem  of having just the two hours and count variables. And note that the count
rem  variable will represent sheets for gillnets, hooks for longliners.
rem Remember that the t_live_weight values are in kgs. Do not let the existence
rem  of the units_of_measure variable confuse, it relates to the skippers estimates.
rem Note bogus data for catchers_recid, trip_sub_trip_flag, trip_num, sub_trip_num. [For a VDC application]
rem  Subtrips and fishing days will be computed by the application as and when requested. [This comment refers to a VDC application]
rem Tossed completely zero catch records for CPUE analyses with code below
rem and (Argentine+Capelin+Cod+Cusk+Dogfish+WinterF+WitchF+YellowtailF+
rem Grenadier+Haddock+HakeS+HakeW+Halibut+Herring+Monkfish+Plaice+Pollock+Redfish+SharkB+
rem SharkP+Skate+Turbot+Wolffish+Mackerel+SurfClam+Scallop+Squid+Whelk+Lobster+Shrimp+SnowCrab+PMont+Swordfish+Alewife)>0;
drop table cpueloglong;
create table cpueloglong as
select logcode, ekey,
'XXXXXXXXXXXX' catchers_recid,
'S' region_code,
cfv cfv_number,
to_number(substr(logcode,7,4)) yland,
to_number(substr(logcode,11,2)) mland,
to_number(substr(logcode,13,2)) dland,
 date_fished caught_date,
 substr(area,1,3) nafo_division_code, lower(substr(area,4,1)) nafo_unit_area,
 tonnage_class_code tonnage_class, length_class_code length_class,
 gear gear_type,
 decode(greatest(Argentine,Capelin,Cod,Cusk,Dogfish,WinterF,WitchF,YellowtailF,
Grenadier,Haddock,HakeS,HakeW,Halibut,Herring,Monkfish,Plaice,Pollock,Redfish,SharkB,
SharkP,Skate,Turbot,Wolffish,Mackerel,
SurfClam,Scallop,Squid,Whelk,
Lobster,Shrimp,SnowCrab,JonahCrab,PMont,
Swordfish,TunaBE,TunaBF,SharkM,Alewife,UNKFlounder,TunaAlb,TunaSJ,TunaYF,TunaUnk,SharkUnk),Argentine,'351',Cod,'100',Capelin,'360',Cusk,'173',Dogfish,'362',
WinterF,'143',WitchF,'142',YellowtailF,'141',Grenadier,'179',
Haddock,'110',HakeS,'172',HakeW,'171',Halibut,'130',Herring,'200',Monkfish,'177',
Plaice,'140',Pollock,'170',Redfish,'120',SharkB,'372',SharkP,'369',
Skate,'356',Turbot,'144',Wolffish,'174',Mackerel,'250',Swordfish,'251',TunaBE,'253',TunaBF,'254',SharkM,'375',Alewife,'350',
SurfClam,'608',Scallop,'612',Squid,'613',Whelk,'617',Lobster,'700',Shrimp,'702',
SnowCrab,'705',JonahCrab,'703',PMont,'712',UNKFlounder,'149',TunaAlb,'252',TunaSJ,'255',TunaYF,'256',TunaUnk,'259',SharkUnk,'379',
'000') main_species_caught,
to_number(substr(to_char(date_fished,'YYYY'),1,4)) ycaught,
to_number(substr(to_char(date_fished,'MM'),1,2)) mcaught,
to_number(substr(to_char(date_fished,'DD'),1,2)) dcaught,
0 trip_num,
0 sub_trip_num,
depth,
decode((-1),
sign(depth-.01),'10',
sign((depth-.01)*(depth-25.99)),'1',
sign((depth-25.995)*(depth-50.99)),'2',
sign((depth-50.995)*(depth-75.99)),'3',
sign((depth-75.995)*(depth-100.99)),'4',
sign((depth-100.995)*(depth-125.99)),'5',
sign((depth-125.995)*(depth-150.99)),'6',
sign((depth-150.995)*(depth-175.99)),'7',
sign((depth-175.995)*(depth-200.99)),'8',
sign((depth-200.995)*(depth-250.99)),'9',
sign((depth-250.995)*(depth-997.99)),'0','10') depthzone,
 lat latitude,  lon longitude,
0 fish_days,
 hrs effort_hrs,
 greatest(sets, tows, hooks) effort_count,
'XX' trip_sub_trip_flag,
 TotalWt,
Argentine,Capelin,Cod,Cusk,Dogfish,WinterF,WitchF,YellowtailF,
Grenadier,Haddock,HakeS,HakeW,Halibut,Herring,Monkfish,Plaice,Pollock,Redfish,SharkB,
SharkP,Skate,Turbot,Wolffish,Mackerel,
SurfClam,Scallop,Squid,Whelk,
Lobster,Shrimp,SnowCrab,JonahCrab,PMont,
Swordfish,TunaBE,TunaBF,SharkM,Alewife,UNKFlounder,TunaAlb,TunaSJ,TunaYF,TunaUnk,SharkUnk
 from cpuelog, cl.catchers_&&Y
 where cfv = cfv_number (+);
rem filter for CPUE analyses
rem and (Argentine+Capelin+Cod+Cusk+Dogfish+WinterF+WitchF+YellowtailF+
rem Grenadier+Haddock+HakeS+HakeW+Halibut+Herring+Monkfish+Plaice+Pollock+Redfish+SharkB+
rem SharkP+Skate+Turbot+Wolffish+Mackerel+SurfClam+Scallop+Squid+Whelk+Lobster+Shrimp+SnowCrab+PMont+Swordfish+Alewife)>0;
drop table cpuesliplong;
create table cpuesliplong as
select logcode,ekey,
'XXXXXXXXXXXX' catchers_recid,
'S' region_code,
cfv cfv_number,
to_number(substr(logcode,7,4)) yland,
to_number(substr(logcode,11,2)) mland,
to_number(substr(logcode,13,2)) dland,
 date_fished caught_date,
 substr(area,1,3) nafo_division_code, lower(substr(area,4,1)) nafo_unit_area,
 nvl(tonnage_class_code,0) tonnage_class, nvl(length_class_code,0) length_class,
 gear gear_type,
 decode(greatest(Argentine,Capelin,Cod,Cusk,Dogfish,WinterF,WitchF,YellowtailF,
Grenadier,Haddock,HakeS,HakeW,Halibut,Herring,Monkfish,Plaice,Pollock,Redfish,SharkB,
SharkP,Skate,Turbot,Wolffish,Mackerel,
SurfClam,Scallop,Squid,Whelk,
Lobster,Shrimp,SnowCrab,JonahCrab,PMont,
Swordfish,TunaBE,TunaBF,SharkM,Alewife,UNKFlounder,TunaAlb,TunaSJ,TunaYF,TunaUnk,SharkUnk),Argentine,'351',Cod,'100',Capelin,'360',Cusk,'173',Dogfish,'362',
WinterF,'143',WitchF,'142',YellowtailF,'141',Grenadier,'179',
Haddock,'110',HakeS,'172',HakeW,'171',Halibut,'130',Herring,'200',Monkfish,'177',
Plaice,'140',Pollock,'170',Redfish,'120',SharkB,'372',SharkP,'369',
Skate,'356',Turbot,'144',Wolffish,'174',Mackerel,'250',Swordfish,'251',TunaBE,'253',TunaBF,'254',SharkM,'375',Alewife,'350',
SurfClam,'608',Scallop,'612',Squid,'613',Whelk,'617',Lobster,'700',Shrimp,'702',
SnowCrab,'705',JonahCrab,'703',PMont,'712',UNKFlounder,'149',TunaAlb,'252',TunaSJ,'255',TunaYF,'256',TunaUnk,'259',SharkUnk,'379',
'000') main_species_caught,
to_number(substr(to_char(date_fished,'YYYY'),1,4)) ycaught,
to_number(substr(to_char(date_fished,'MM'),1,2)) mcaught,
to_number(substr(to_char(date_fished,'DD'),1,2)) dcaught,
0 trip_num,
0 sub_trip_num,
depth,
decode((-1),
sign(depth-.01),'10',
sign((depth-.01)*(depth-25.99)),'1',
sign((depth-25.995)*(depth-50.99)),'2',
sign((depth-50.995)*(depth-75.99)),'3',
sign((depth-75.995)*(depth-100.99)),'4',
sign((depth-100.995)*(depth-125.99)),'5',
sign((depth-125.995)*(depth-150.99)),'6',
sign((depth-150.995)*(depth-175.99)),'7',
sign((depth-175.995)*(depth-200.99)),'8',
sign((depth-200.995)*(depth-250.99)),'9',
sign((depth-250.995)*(depth-997.99)),'0','10') depthzone,
 lat latitude,  lon longitude,
0 fish_days,
 hrs effort_hrs,
 greatest(sets, tows, hooks) effort_count,
'XX' trip_sub_trip_flag,
 TotalWt,
Argentine,Capelin,Cod,Cusk,Dogfish,WinterF,WitchF,YellowtailF,
Grenadier,Haddock,HakeS,HakeW,Halibut,Herring,Monkfish,Plaice,Pollock,Redfish,SharkB,
SharkP,Skate,Turbot,Wolffish,Mackerel,
SurfClam,Scallop,Squid,Whelk,
Lobster,Shrimp,SnowCrab,JonahCrab,PMont,
Swordfish,TunaBE,TunaBF,SharkM,Alewife,UNKFlounder,TunaAlb,TunaSJ,TunaYF,TunaUnk,SharkUnk
 from cpueslip, cl.catchers_&&Y
 where cfv = cfv_number (+);
rem Reducing the species column to just the main species caught. If we want to model multiple species
rem or investigate bycatch and species groups, we need to back up to the preceding 'long' tables.
rem drop table cpuelogshort;
rem create table cpuelogshort as
rem select logcode,ekey,
rem catchers_recid,region_code,cfv_number,yland,mland,dland,caught_date,nafo_division_code,nafo_unit_area,
rem nvl(tonnage_class,0) tonnage_class, nvl(length_class,0) length_class,
rem gear_type,main_species_caught,ycaught,mcaught,dcaught,
rem trip_num,sub_trip_num,depthzone,latitude,longitude,
rem fish_days,effort_hrs,effort_count,trip_sub_trip_flag,TotalWt,
rem decode(main_species_caught,
rem 	'351',Argentine,'100',Cod,'360',Capelin,'173',Cusk,'362',Dogfish,
rem 	'143',WinterF,'142',WitchF,'141',YellowtailF,'179',Grenadier,
rem 	'110',Haddock,'172',HakeS,'171',HakeW,'130',Halibut,'200',Herring,'177',Monkfish,
rem 	'140',Plaice,'170',Pollock,'120',Redfish,'372',SharkB,'369',SharkP,
rem 	'356',Skate,'144',Turbot,'174',Wolffish,'250',Mackerel,'251',Swordfish,'350',Alewife,'608',SurfClam,'612',Scallop,'613',Squid,'617',Whelk,'700',Lobster,'702',Shrimp,'705',SnowCrab,'712',PMont,0) msc_tons
rem from cpueloglong;
rem drop table cpueslipshort;
rem create table cpueslipshort as
rem select logcode,ekey,
rem catchers_recid,region_code,cfv_number,yland,mland,dland,caught_date,nafo_division_code,nafo_unit_area,
rem nvl(tonnage_class,0) tonnage_class, nvl(length_class,0) length_class,
rem gear_type,main_species_caught,ycaught,mcaught,dcaught,
rem trip_num,sub_trip_num,depthzone,latitude,longitude,
rem fish_days,effort_hrs,effort_count,trip_sub_trip_flag,
rem (Argentine+Capelin+Cod+Cusk+Dogfish+WinterF+WitchF+YellowtailF+
rem Grenadier+Haddock+HakeS+HakeW+Halibut+Herring+Monkfish+Plaice+Pollock+Redfish+SharkB+
rem SharkP+Skate+Turbot+Wolffish+Mackerel+SurfClam+Scallop+Squid+Whelk+Lobster+Shrimp+SnowCrab+PMont+Swordfish+Alewife) TotalWt,
rem decode(main_species_caught,
rem 	'351',Argentine,'100',Cod,'360',Capelin,'173',Cusk,'362',Dogfish,
rem 	'143',WinterF,'142',WitchF,'141',YellowtailF,'179',Grenadier,
rem 	'110',Haddock,'172',HakeS,'171',HakeW,'130',Halibut,'200',Herring,'177',Monkfish,
rem 	'140',Plaice,'170',Pollock,'120',Redfish,'372',SharkB,'369',SharkP,
rem 	'356',Skate,'144',Turbot,'174',Wolffish,'250',Mackerel,'251',Swordfish,'350',Alewife,'608',SurfClam,'612',Scallop,'613',Squid,'617',Whelk,'700',Lobster,'702',Shrimp,'705',SnowCrab,'712',PMont,0) msc_tons
rem from cpuesliplong;
rem Based on 2000-2002, the database requires 7 MB per year. The one-year table below includes log-only
rem variables used by the Catch Rate application where slip data is problematic or missing.
drop table cpue&&Y;
create table cpue&&Y as
select
l.catchers_recid,l.region_code,l.cfv_number,l.yland,l.mland,l.dland,l.caught_date,l.nafo_division_code,l.nafo_unit_area,
l.tonnage_class, l.length_class,
l.gear_type,s.main_species_caught,l.ycaught,l.mcaught,l.dcaught,
l.trip_num,l.sub_trip_num,l.depthzone,l.latitude,l.longitude,
l.fish_days,l.effort_hrs,l.effort_count,l.trip_sub_trip_flag,l.depth,s.TotalWt,
l.Argentine,l.Capelin,l.Cod,l.Cusk,l.Dogfish,l.WinterF,l.WitchF,l.YellowtailF,
l.Grenadier,l.Haddock,l.HakeS,l.HakeW,l.Halibut,l.Herring,l.Monkfish,l.Plaice,l.Pollock,l.Redfish,l.SharkB,
l.SharkP,l.Skate,l.Turbot,l.Wolffish,l.Mackerel,
l.SurfClam,l.Scallop,l.Squid,l.Whelk,
l.Lobster,l.Shrimp,l.SnowCrab,l.JonahCrab,l.PMont,
l.Swordfish,l.TunaBE,l.TunaBF,l.SharkM,l.Alewife,l.UNKFlounder,l.TunaAlb,l.TunaSJ,l.TunaYF,l.TunaUnk,l.SharkUnk,
s.TotalWt sliptotwt,l.main_species_caught logmsc,l.TotalWt logtotwt
from cpueloglong l, cpuesliplong s
where l.logcode=s.logcode (+) and l.ekey=s.ekey (+);

