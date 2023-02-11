
****************************************;
*BKawasaki 5-19-2020********************;
*Pediatric COVID-19 Case Search*********;
*                                       ;
****************************************;

*****************************************
*****apply original steps to separate ***
****n_childrens cases, then rename and*** 
**********reoder************************;

libname newcedrs odbc dsn='New_CEDRS_Warehouse' schema=CEDRS READ_LOCK_TYPE=NOLOCK;
libname archive 'J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data';
run;

proc sql;
create table archive.denominatory
as select distinct d.ProfileID, d.LastName, d.FirstName, d.MiddleName, d.Birthdate, d.Ethnicity, d.DeathDate, d.Address1, d.Address2, d.AddressType, d.City, d.State,
d.StateCode, d.ZipCode, d.County,
r.Race1, r.Race2, r.Race3, r.Race4/*, input(d.BirthDate, anydtdtm.) as DOBdate fortmat=dtdate9.*/, d.Gender, e.EventID, e.Disease, e.EventStatus,
    e.ReportedDate, e.Age, e.AgeType, e.Outcome, e.HospitalName,e.ActiveAddressID, e.HospitalizedYesNo, e.AdmissionDate, e.DischargeDate,
f.DiabetesID, f.ChronicRenalDiseaseID,f.ChronicLiverDiseaseID, f.ChronicOtherID, f.ChronicOtherDesc,
f.UnderlyingMedicalConditionID,f.UnderlyingMedicalConditionDesc, f.PsychologicalID, f.PsychologicalDesc, f.DisabilityID,f.DisabilityDesc, f.VapeCurrentID, f.VapeFormerID,
f.SmokerCurrentID,f.SmokerFormerID, f.ExpoCatCruiseShipTravel,f.ExpoCatWorkplace, f.ExpoCatAirportAirplane,f.ExpoCatAuditLivingFacility, f.ExpoCatEducationFacility, 
f.ExpoCatCorrectionalFacility, f.ExpoCatAnimalContact, f.ExpoCatOther,f.ExpoSocialGatheringID,f.ExpoVisitHealthcareAsPatientID,f.ExpoVisitHealthcareNotPatientID,f.ExpoSocialGatheringInfo,f.ImmunocompromisedID,f.TravelInternationalID, f.TravelDomesticID, f.ExpoContConfRelContactOnly,
f.OccupationTypeID, f.OtherOccupationTypeDesc, f.ExpoContConfSettingDaycare, f.ExpoContConfSettingShoolUniversi, f.AutoImmuneConditionID, f.BloodDisorderID, f.CancerID, f.HypertensionID, f.HeartDiseaseID, f.SevereObesityID, f.LungDiseaseID, f.CommentSymptoms, /*f.ICU, s.TestingLabName, s.OriginatingLabName, s.CollectionDate*/
l.TestType, l.ResultDate, l.ResultText , v.SpecimenSource, c.ICU, sx.Symptoms, sx.SymptomOnsetDate, sx.OtherSymptomDesc, sx.SymptomResolutionDate
	
	from NewCEDRS.zDSI_Profiles d
    left join NewCEDRS.zDSI_ProfileRaces r on d.ProfileID = r.ProfileID
	left join NewCEDRS.zDSI_Events e on d.ProfileID = e.ProfileID
	left join NewCEDRS.SurveillanceFormCovid19 as f on e.EventID = f.EventID
	/*left join NewCEDRS.zDSI_Specimens s on e.EventID = s.EventID*/
	left join NewCEDRS.zDSI_LabTests l on e.EventID = l.EventID /*s.LabSpecimenID = l.LabSpecimenID*/
	left join NewCEDRS.viewLabDetails v on e.EventID = v.EventID
	left join NewCEDRS.zDSI_Covid19Data c on e.EventID = c.EventID
	inner join NewCEDRS.SurveillanceFormBase b on e.eventID = b.eventID
	left join NewCEDRS.SurveillanceformSymptoms sx on b.FormBaseID = sx.FormBaseID
	
	/*left join NewCEDRS.SurveillanceFormSymptoms u on e.EventID = u.EventID *no ID to join on; */



	where d.ProfileID ne . and e.Deleted ne 1 and e.EventID ne . /*and (e.ReportedDate < '20MAY2020'd)*/ 
    and e.disease ='COVID-19' and e.EventStatus in ('Confirmed') and e.countyassigned <> 'Out of State'

	group by e.EventID

;
	quit;


proc contents data=archive.denominatory; run;
	


	proc contents data=NewCEDRS.zDSI_Profiles; run;
	proc contents data=NewCEDRS.zDSI_Events; run;
    proc contents data=NewCEDRS.SurveillanceFormCovid19; run;
	proc contents data=NewCEDRS.Labs; run;
	proc contents data=NewCEDRS.zDSI_LabTests; run;
	proc contents data=NewCEDRS.LabSpecimens; run;
	proc contents data=NewCEDRS.SurveillanceFormRisk; run;
	proc contents data=NewCEDRS.viewLabDetails; run;
	proc contents data=NewCEDRS.zDSI_Covid19Data; run;
	proc contents data=NewCEDRS.zDSI_Specimens; run;
	proc contents data=NewCEDRS.zDSI_Covid19Data; run;
	proc contents data=NewCEDRS.SurveillanceFormSymptoms; run;
	proc contents data=NewCEDRS.SurveillanceFormRisk; run;/*has FormBaseID and FormRiskID link 2 2 below*/
	proc contents data=NewCEDRS.SurveillanceFormBase; run;/*has eventid and FormBaseID, link 1*/
	proc contents data=NewCEDRS.viewEventDetailsOmitDeletes; run;
	proc contents data=NewCEDRS.viewFirstHospitalDetails; run;
	proc contents data=NewCEDRS.viewEventDetails; run;/*has FormBaseID and FormRiskID link 2 2 below*/
	proc contents data=NewCEDRS.SurveillanceFormTreatments; run;
	proc contents data=NewCEDRS.Hospitalizations; run;
*LIBNAME newcedrs odbc dsn='Cedrs3_read' uid=nalden schema=CEDRS;/*run;

/***Pull CEDRS COVID-19 Cases that are Confirmed, not deleted, with a report date > 3/1/2020*/
/*proc sql;
create table archive.denominatorb
as select distinct d.ProfileID, d.LastName, d.FirstName, d.MiddleName, d.Birthdate/*, input(d.BirthDate, anydtdtm.) as DOBdate fortmat=dtdate9.*/,/* d.Gender,r.Race1, r.Race2, r.Race3, r.Race4*/, e.EventID, e.Disease, e.EventStatus,
    /*e.ReportedDate, e.Age, e.AgeType, e.Outcome, e.HospitalizedYesNo, e.HospitalName, s.TestingLabName, s.OriginatingLabName,
/*adding new expanded vars*/	
/*r.Race1, r.Race2, r.Race3, r.Race4, d.Address1, d.City, d.State, d.ZipCode, d.County, d.Ethnicity, f.ImmunocompromisedID,
f.LungDiseaseID, f.DiabetesID, f.HeartDiseaseID, f.ChronicRenalDiseaseID, f.ChronicLiverDiseaseID, f.ChronicOtherID,f.ChronicOtherDesc,
f.HypertensionID, f.AutoImmuneConditionID, f.BloodDisorderID, f.CancerID, f.SevereObesityID,
f.UnderlyingMedicalConditionID,f.UnderlyingMedicalConditionDesc, f.PsychologicalID, f.PsychologicalDesc, f.DisabilityID,f.DisabilityDesc, f.VapeCurrentID, f.VapeFormerID,
f.SmokerCurrentID, f.SmokerFormerID, f.ExpoCatCruiseShipTravel,f.ExpoCatWorkplace, f.ExpoCatAirportAirplane,f.ExpoCatAuditLivingFacility, f.ExpoCatEducationFacility, 
f.ExpoCatCorrectionalFacility, f.ExpoCatAnimalContact, f.ExpoCatOther,f.ExpoSocialGatheringID,f.ExpoVisitHealthcareAsPatientID,f.ExpoVisitHealthcareNotPatientID,f.ExpoSocialGatheringInfo,s.Specimen, s.CollectionDate, s.OriginatingLabName, s.TestingLabName, l.TestType, l.ResultDate, l.ResultText
*/
	/*from NewCEDRS.zDSI_Profiles d 
	/*left join NewCEDRS.zDSI_ProfileRaces r on d.ProfileID = r.ProfileID*/
	/*left join NewCEDRS.zDSI_Events e on d.ProfileID = e.ProfileID
	left join NewCEDRS.zDSI_Specimens s on e.EventID = s.EventID
	/*new left joins*/
	/*left join NewCEDRS.zDSI_ProfileRaces r on d.ProfileID = r.ProfileID
	left join NewCEDRS.SurveillanceFormCOVID19 f on e.EventID = f.EventID
	left join NewCEDRS.zDSI_LabTests l on s.LabSpecimenID = l.LabSpecimenID */


	/*where d.ProfileID ne . and e.Deleted ne 1 and e.EventID ne . /*and (e.ReportedDate < '20MAY2020'd)*/ 
   /* and e.disease ='COVID-19' and e.EventStatus in ('Confirmed') and e.countyassigned <> 'Out of State'

	group by e.EventID

;
	quit;*/



	/*start here*/

libname CCC 'J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data';


proc sql;
create table denominatoragecalc2
as select *, input(BirthDate, anydtdtm.) as DOBdate format=datetime20.
	from ccc.denominatory

;
quit;

/*Proc print data=denominatoragecalc;
	run;*/

data denominatordaysold2;
set denominatoragecalc2;
YearIntck = yrdif(datepart(DOBDate),datepart(ReportedDate),'AGE');
IF (HospitalName = 'Childrens Hospital') or (TestingLabName = 'Childrens Hospital') or (OriginatingLabName = 'Childrens Hospital')
THEN CHCFlag = 'YES';
Else CHCFlag = 'NO';
run;

/*proc print data=denominatordaysold;
	run;
/*create data of CHCO affiliates who are <21 and not missing*/
data twentyone2;
set denominatordaysold2;
where YearIntck <21 and YearIntck <>.;
run;
/*proc print data=twentyone; run; */
/*sort dataset by eventid and dedup*/
data final2;
set twentyone2;
by EventID;
if first.eventID;
run;




/*proc export data=twentyone
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\twentyone.CSV'		
      dbms=csv replace;    run;*/
proc export data=final2
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CCC 3_22\final2.CSV'		
      dbms=csv replace;    run;


/*Subset under 21 to CHOC alone*/

data chclt21_2;
	set final2;
	where CHCFlag= 'YES';
	run;
proc export data=chclt21_2
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CCC 3_22\chclt21_2.CSV'		
      dbms=csv replace;    run;
/*create data set of childrens cases not alredy in CHOC dataset*/
 data ch_miss2;
	  set chclt21_2;
	  if MedicalRecordNumber in ('2009334', '2315989','1360847','1855981','1540195', '2065706', '2327154', '1282162','2013623','1920234', '2190636',
         '2046186','1162382', '1115163', '1116507', '1117225', '1554918', '2316492', '2233719', '1532372', '1730451', '2322704', '2105569', '927818',
		'2029832', '2296041', '849663', '2331817', '1076084', '2296935', '1314416', '1753459', '679752', '2265171', '1335580', '2256700', '1289044',
		'1374425', '2336104', '1764012', '1135896', '882649', '855386', '2317214', '2155427', '2302992', '1740094', '2316793', '2088574', '2262313',
		'1557061', '1104303', '2203699', '1283824', '1159811', '2319726', '1707608', '933658', '1586913', '2261232', '2320687', '2320677', '1062287',
		'1498377', '2013689', '2191075', '2108337', '1953647', '1315880', '1608741', '1011819', '719183', '2267185', '1534628', '1039763', '1174665',
		'1318971', '962407', '1255899', '2318936', '2256771', '1658578', '2164715', '2017430', '2020620', '1355458', '1703340', '1497671', '1245840',
		'1821274', '1620686', '1707916', '2037612', '2018366', '2218780', '954468', '1498813', '2258171', '1599003', '2200469', '2304626', '858364',
		'1868111', '1230390', '2256089', '1232719', '2260255', '1686707', '1014806', '2320964', '1035788', '2320475', '1454857', '1966567', '1179336', 
		'2056300', '1929925', '2090096', '2017977', '2321288', '2316710', '1150530', '1005037', '968381', '2315075', '1090088', '2237111', '1716096',
		'1228597', '988754', '1752268', '2299032', '1619927', '906852', '2029902', '2319308', '1779461', '800288', '1398916', '2273696', '2312655',
		'1232014', '2316118', '1176459', '1232015', '2319335', '1236164', '2240724', '2320419', '1850704', '1655528', '1762529', '1253641', '2271230', 
		'1391109', '921315', '1964715', '1178347', '2210383', '1876968', '1742239', '1849693', '1848988', '1177550', '644755', '2235185', '1053394',
		'893173', '2140101', '2132839', '1717931', '2177021', '2303100', '1380705', '1812182', '1618605', '2247025', '1781396', '2232728', '2007962', 
		'2326100', '1910984', '1183815', '1112361', '1914003', '1772732', '1354750', '1327029', '767829', '1132265', '1016878', '1854381', '2096926', 
		'2158249', '2192123', '811882', '801073', '1763816', '938518', '2144551', '1684762', '1050545', '1305309', '1059542', '1499504', '1292314', 
		'2068020', '2263617', '1224325', '2189246', '2132013', '1620584', '1202512', '896846', '1982717', '2302898', '2239621', '1188203', '2265326',
		'1731989', '829422', '1334765', '1223866', '1926869', '1653844', '1070557', '2331763', '1854504', '1094562', '937577', '1250536', '1247800', 
		'1058857', '1199902', '2142311', '1491711', '1377713', '1332631', '2153122', '1125618', '1017822', '1432999', '2312292', '2202938', '853327', 
		'1087869', '992058', '2135324', '2323629', '2158807', '1406646', '1354712', '2333580', '1058278', '2329800', '1772612', '1213943', '2060511', 
		'1595827', '1700607', '962210', '2210462', '2321130', '945765', '942161', '2273512', '2126973', '1065644', '2314625', '1493030', '1677915', 
		'2316496', '2112769', '2302923', '2323587', '1195252', '1668791', '1834695', '2267812', '2017896', '1932225', '2117565', '1250563', '1187554', 
		'1195078', '1799262', '1557697', '2232037', '2053711', '1927091', '2315251', '1155737', '1423330', '2320378', '2176957', '2028421', '899164', 
		'1599190', '1177420', '2315559', '2075535', '2266855', '1153346', '1987246', '2169753', '1432389', '2264276', '1422769', '2325585', '2272736', 
		'1944072', '2304674', '1244235', '912564', '2112549', '1719891', '2158439', '783317', '857636', '2328239', '2107215', '1432375', '2273683', 
		'2083086', '2323344', '2081263', '1267540', '2205345', '979194', '2071943', '1756377', '1016658', '2337296', '2328238', '2082337', '2326594', 
		'1212818', '2329845', '2077195', '2323872', '871976', '2196478', '1107489', '1928462', '1437983', '2115821', '2068137', '1887959', '2143195', 
		'800007', '1824622', '2204532', '1170249', '1594871', '1094528', '1035034') then delete;
		else if profileID in('1058954','1078713', '1090185', '1058955','660202') then delete;*deleting obs without mrn whose fname,lname,&dob appear in CHOC dataset;
	  run;

*subset missing to Mar-June cases;
data ch_miss_mj2;
	set ch_miss2;
	if '01MAR2020:00:00:00'dt <= ReportedDate <= '30JUN2020:00:00:00'dt; 
	run;

proc export data=ch_miss_mj2
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CCC 3_22\ch_miss_mj2.XLS'		
      dbms=xls replace;    run;
proc print data=ch_miss_mj;run;
/*Pause, data for CCC Lisa et al*/
/*start here 3/19/21*/
*nonCHOC data under 21yrs;
data n_chclt21_2;
	set final;
	where CHCFlag= 'NO';
	run;
proc export data=n_chclt21
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\n_chclt21.CSV'		
      dbms=csv replace;    run;

proc export data=chclt21
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\chclt21.CSV'		
      dbms=csv replace;    run;


		/*subset nonCHOC under 21yrs to Mar-June*/
		data ccc.n_chclt21_mj;
			set n_chclt21;
			if '01MAR2020:00:00:00'dt <= ReportedDate <= '30JUN2020:00:00:00'dt; 
			run;

		proc export data=ccc.n_chclt21_mj
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\n_chclt21_mj.XLS'		
      		dbms=xls replace;    run;

			
proc contents data=ccc.n_chclt21_mj; run; *pre var renaming check;

/*rename and reorder non-childrens Mar - June dataset from CEDRS var name to Redcap var name*/
proc datasets library=CCC;
modify  n_chclt21_mj; 
*add var 'data_source'; 
rename MedicalRecordNumber=mrn FirstName=fname LastName=lname BirthDate=dob Age=age AgeType=age_unit Gender=sex Ethnicity=ethnic Race1=race Race2=race Race3=race Race4=race
		Address1=address Address2=address City=city State=state County=county ZipCode=zip ImmunocompromisedID=immunocomp 
		PsychologicalDesc=psych_dx PregnantYesNo=gyn_dx any_smoke=personal_smoking any_vape=smoke_other
		ExpoContConfRelContactOnly=fam_contact ExpoContConfSettingDaycare=school_daycare ExpoContConfSettingShoolUniversi=school_daycare;
		run;
	quit;

proc contents data=ccc.n_chclt21_mj; run;*post var renaming check;


*reordering variables;
data ccc.red_nch_mj;
	retain mrn etc;
	set ccc.n_chclt21_mj;
	run; 
	

proc freq data=final;*checking counts of chidrens and non-childrens px;
tables CHCFlag;
run;

/*sort then compare obs*/

/*import original CHOC dataset, mrn=char*/
PROC IMPORT OUT= WORK.choc_sas 
            DATAFILE= "C:\Users\iaoyegun\Documents\CCC non-matches\use t
his\choc sas import.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="'dedup ChildrenWithCOVIDIn$'"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

proc sort data = ccc.cdrs;
 by MedicalRecordNumber;
run;
 
proc sort data = ccc.chclt21;
 by MedicalRecordNumber;
run; 
 
proc compare
 base=ccc.cdrs
 compare=ccc.chclt21 listall;
 id MedicalRecordNumber;
run;
/*****/
proc sort data = final;
 by MedicalRecordNumber;
run;
 
proc sort data = choc_sas;
 by MedicalRecordNumber;
run; 
 
proc compare
 base=final
 compare=choc_sas listcompobs;
 id MedicalRecordNumber;
 title "Missing CHOC, children not included in CHOC dataset list comp obs";
run;
/*listing all observations found in final but not in choc_sas*/




data mortality;
set twentyone;
where Outcome='Patient died';
run;



proc freq data=twentyone;
Tables Disease;
where YearIntck<5;
Title 'COVID-19 Confirmed and Probable Cases Less than 5';
run;

proc freq data=twentyone;
Tables Disease;
where YearIntck>5 and YearIntck<10;
Title 'COVID-19 Confirmed and Probable Cases Ages 5-9';
run;


proc freq data=twentyone;
Tables Disease;
where YearIntck GE 10 ;
Title 'COVID-19 Confirmed and Probable Cases Age 10 and up';
run;

proc freq data=twentyone;
Tables Disease;
where Outcome='Patient died' ;
Title 'COVID-19 Cases who Passed <21 years of age';
run;



