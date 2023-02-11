
****************************************;
*BKawasaki 5-19-2020********************;
*Pediatric COVID-19 Case Search*********;
*                                       ;
****************************************;

*****************************************
*****apply original steps to separate ***
****n_childrens cases, then rename and*** 
**********reorder************************;

libname newcedrs odbc dsn='New_CEDRS_Warehouse' schema=CEDRS READ_LOCK_TYPE=NOLOCK;
libname agencies odbc dsn='New_CEDRS_Warehouse' schema=access READ_LOCK_TYPE=NOLOCK;
libname format odbc dsn='New_CEDRS_Warehouse' schema=lookups READ_LOCK_TYPE=NOLOCK;
libname archive 'J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data';
libname postjz 'C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz';
run;



Proc format;

	value $check_uncheck "121"=1 "119"=0 "120"=0 "."=0;*check what blanks or unknown are in Redcap, RedCap:1=checked, 0=unchecked;
	value check_uncheck 121=1 119=0 120=0 .=0;*check what blanks or unknown are in Redcap, RedCap:1=checked, 0=unchecked;
	value $text_check_uncheck "Yes"=1 "No"=0 "Unknown"=0 " "=0;*convert text response of PregnantYesNo, RedCap:1=checked, 0=unchecked;
	/*value $umc_yn "Yes"=1 "No"=2 "Unknown or undocumented"=3 " "=3;*/
	value ynu  /*"No"=0 " "=0 "Yes"=1*/ 121=1 119=2 120=3 .=3; *for the numeric varible umc_yn, Redcap=1=Yes, 2=No, 3=Unk or Undcocumented;
	value $ynu  /*"No"=0 " "=0 "Yes"=1*/ 121=1 119=2 120=3 .=3; *Redcap=1=Yes, 2=No, 3=Unk or Undcocumented;
	value $text_ynu  "Yes"=1 "No"=2 "Unknown"=3 " "=3; *Redcap=1=Yes, 2=No, 3=Unknown;
	value $school_daycare "Yes"=1 "No"=2 "Unknown"=3;
	value $covid_pcr_result "Positive"=1 "Negative"=2;
    value $pcr_site "CHCO (Children's Hospital Colorado)"=1 "CDPHE"=2  "Other"=3;
    value $sx_asx "Symptomatic"=1 "Remained asymptomatic"=2 "Unknown"=3;
	value $admit "Yes"=1 "No"=2 "Unknown"=3;
 	value $icu "Yes"=1 "No"=0;
	value $death "Yes"=1 "No"=2; 
 	VALUE umc_ten 121=1 119=2 120=3 .=3;
	value $admit_hosp "Children's Hospital Colorado"=1 "Denver Health"=2 "Rocky Mountain Hospital for Children"=3 "Other"=4;

Value $specimen_source
	"NP Swab"=1
	"Aspirate"=2
	"Throat/pharyngeal"=3
	"Tracheal aspirate" = 4  
	"Bronchial wash" = 5
	"Sputum" = 6
	"Blood" =7
	"Blood - Capillary" = 7
	"Nasal Wash" = 9
	"Serum" = 9
	"Other" =9
	"Other (Specify in notes)" = 9
	"Unknown" = 10
	"Saliva" = 11
	

	;


	run;


proc sql;
create table denominatory
as select distinct d.ProfileID, d.LastName, d.FirstName, d.MiddleName, d.BirthDate, d.Ethnicity, d.DeathDate, d.Address1, d.Address2, d.AddressType, d.City, d.State,
d.StateCode, d.ZipCode, d.County, d.Gender, e.EventID, e.Disease, e.EventStatus, e.ReportedDate, e.Age, e.AgeType, e.Outcome, e.HospitalName, e.HospitalizedYesNo, e.ActiveAddressID, e.HospitalizedYesNo, 
e.AdmissionDate, e.DischargeDate, e.MedicalRecordNumber, e.PregnantYesNo, e.LiveInInstitution, e.ExposureFacilityType, /*datepart(e.OnsetDate)as OnsetDate format mmddyy10.,*/ q.HospitalID

	
	from NewCEDRS.zDSI_Profiles d
	left join NewCEDRS.zDSI_Events e on d.ProfileID = e.ProfileID
	left join NewCEDRS.Hospitalizations q on e.EventID = q.EventID
	


	where d.ProfileID ne . and e.Deleted ne 1 and e.EventID ne . /*and (e.ReportedDate < '20MAY2020'd)*/ 
    and e.disease ='COVID-19' and e.EventStatus in ('Confirmed') and e.countyassigned <> 'Out of State'
	and '01MAR2020:00:00:00'dt <= ReportedDate <= '30JUN2020:00:00:00'dt 

	group by e.EventID;
	*/format BirthDate mmddyy10.;  
	quit;



	/*Sort, Deduplication*/

	proc sort data=denominatory; by EventID; run;


data denominatory_dedup;
set denominatory;
by EventID;
if first.EventID;
run;



/*Age calcs*/

proc sql;
create table denominatoragecalc2
as select *, input(BirthDate, anydtdtm.) as DOBdate format=datetime20.
	from denominatory_dedup
;
quit;


data denominatordaysold2;
set denominatoragecalc2;

/*BirthDate = input(put(BirthDate,$10.),yymmdd8.);
format BirthDate mmddyy8.;*/
YearIntck = yrdif(datepart(DOBDate),datepart(ReportedDate),'AGE');

run;


/**Subsetting to non-missing under 21***/
data twentyone2;
set denominatordaysold2;
where YearIntck <21 and YearIntck <>.;
run;/*skip to either repeating instrument*/






/**TESTS repeating including variables to flag as chco***/
proc sql;
create table tests_mar_jun20
as select distinct d.*, 
s.TestingLabName, s.OriginatingLabName, s.CollectionDate, s.Specimen, s.LabSpecimenID,
l.TestType, l.ResultDate, l.ResultText
	
	from twentyone2 d
    
	left join NewCEDRS.zDSI_Specimens s on d.EventID = s.EventID
	left join NewCEDRS.zDSI_LabTests l on s.LabSpecimenID = l.LabSpecimenID 


group by d.EventID

;
	quit;   /*skip to dataTransf, dedup FIRST*/



/*
	ods excel file='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\tests_mar_jun20.xls'	; /*older versions of SAS may replace this line with: ods tagsets.excelxp file=""*/
/*			proc report data=archive.testsmj;
				columns _all_;
			run;
		ods excel close;




		/*dedup tests*/

proc sort data=tests_mar_jun20; by LabSpecimenID; run;

data tests_mar_jun20_dedup;
set tests_mar_jun20;
by LabSpecimenID;
if first.LabSpecimenID;
run;


proc sort data=tests_mar_jun20_dedup; by EventID; run;

 
/*Data Transforming: plus creating new var to match REdcap var*/

data ch_dataTransftest_mar_jun20 /*(drop=Count)*/;
	set tests_mar_oct20_dedup;
	length redcap_repeat_instrument $100;
	redcap_repeat_instrument = "covid19_pcr_testing";

	length redcap_repeat_instance 8.;
		by EventID;
		if first.EventID then Count=.;
		Count+1;

	redcap_repeat_instance=Count;


new_bdate = input(BirthDate, e8601da.); *found official sas informat for the way date  is displayed here. create in data mgt step so final var is used in rename step;
    format new_bdate MMDDYY10.;


	new_dtpcr =datepart(CollectionDate);/*input (put(date_pcr, DATETIME.), 10.); *numeric datetime to date;*/
   format new_dtpcr MMDDYY10.;
  
	if TestType in ('PCR', 'RT-PCR', 'RT-PCR at CDC')
		then pcr_result = ResultText;
		else delete;

length pcr_res2 $100; /* to delete responses that dont fit the format above*/
	if pcr_result= "Positive" then pcr_res2= "Positive";
		else if pcr_result= "Negative" then pcr_res2= "Negative";
		else pcr_res2= " ";

		if pcr_res2 = " " then delete;

length testlab $100;
if TestingLabName=" " then testlab=" ";
		else if TestingLabName in ('CDPHE - State Lab', 'Childrens Hospital')
		then do;
		if TestingLabName='CDPHE - State Lab' then testlab='CDPHE';
			else if TestingLabName='Childrens Hospital' then testlab="CHCO (Children's Hospital Colorado)";
		end;
	else testlab= 'Other';

;


run; /*skip to rename/modify step*/



proc freq data=CH_DATATRANSFTEST_MAR_OCT20; tables pcr_result pcr_res2; run; *checking for non pcr records;
/*saving externally to test email transport size*/
data archive.testsmj_size;
	
		set testsmj;
	
	run;

	**************************************************************;

proc datasets library=work;
modify  ch_dataTransftest_mar_jun20;
attrib _all_ label=' '; 
 
rename  FirstName=fname LastName=lname new_bdate=dob new_dtpcr=date_pcr pcr_res2=covid_pcr_result testlab=pcr_site Specimen=pcr_source;
 
		
contents data=ch_dataTransftest_mar_jun20;
run;
	quit; /*skip to 2x export*/


/*
proc export data=ch_dataTransftest_mar_jun20
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CHCO Code 5 20 22\ch_dataTransftest_mar_oct20.XLS'		
      dbms=xls replace;    run;



proc export data=ch_dataTransftest_mar_jun20
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CHCO Code 5 20 22\ch_dataTransftest_mar_oct20.XLS'		
      dbms=xls replace;    run;																		/*skip to retain step*/

	 



/*Reordering variables;*/

data archive.retain_mar_jun20;
	
	retain ProfileID EventID redcap_repeat_instrument redcap_repeat_instance fname lname dob date_pcr 
			covid_pcr_result pcr_site pcr_source;
		

		set ch_dataTransftest_mar_jun20;
	
	run;




	/*Subsetting to RedCap vars alone*/



data archive.redcap_mar_jun20;
	set archive.retain_mar_jun20;

	Keep ProfileID EventID redcap_repeat_instrument redcap_repeat_instance fname lname dob date_pcr covid_pcr_result pcr_site pcr_source;
	
	
	run;



/*	
proc export data=archive.redcap_mar_jun20
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CHCO Code 5 20 22\redcap_mar_jun20.csv'		
      dbms=xls replace;    run;


	  /*insert format*/
	data archive.format_test_mar_jun20;
	set archive.redcap_mar_jun20;

		Keep ProfileID EventID redcap_repeat_instrument redcap_repeat_instance fname lname dob date_pcr covid_pcr_result pcr_site pcr_source;


	  format  covid_pcr_result $covid_pcr_result. pcr_site $pcr_site. pcr_source $specimen_source. ;

		run;


		ods excel file='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CHCO Code 5 20 22\format_test_mar_jun20.xls'	; /*older versions of SAS may replace this line with: ods tagsets.excelxp file=""*/
			proc report data=archive.format_test_mar_jun20;
				columns _all_;
			run;
		ods excel close;


		proc freq data=archive.format_test_mar_jun20; tables covid_pcr_result ; run;
/*END TEST dataset*/

		









/*Start ADMIT table*/

		
proc sql;
create table denominatory
as select distinct d.ProfileID, d.LastName, d.FirstName, d.MiddleName, d.BirthDate, d.Ethnicity, d.DeathDate, d.Address1, d.Address2, d.AddressType, d.City, d.State,
d.StateCode, d.ZipCode, d.County, d.Gender, e.EventID, e.Disease, e.EventStatus, e.ReportedDate, e.Age, e.AgeType, e.Outcome, e.HospitalName, e.HospitalizedYesNo, e.ActiveAddressID, e.HospitalizedYesNo, 
e.AdmissionDate, e.DischargeDate, e.MedicalRecordNumber, e.PregnantYesNo, e.LiveInInstitution, e.ExposureFacilityType, /*datepart(e.OnsetDate)as OnsetDate format mmddyy10.,*/
q.HospitalID

	
	from NewCEDRS.zDSI_Profiles d
	left join NewCEDRS.zDSI_Events e on d.ProfileID = e.ProfileID
	left join NewCEDRS.Hospitalizations q on e.EventID = q.EventID
	


	where d.ProfileID ne . and e.Deleted ne 1 and e.EventID ne . /*and (e.ReportedDate < '20MAY2020'd)*/ 
    and e.disease ='COVID-19' and e.EventStatus in ('Confirmed') and e.countyassigned <> 'Out of State'
	and '01MAR2020:00:00:00'dt <= ReportedDate <= '30JUN2020:00:00:00'dt 

	group by e.EventID;
	*/format BirthDate mmddyy10.;  
	quit;

/*proc freq data=denominatory; tables HospitalID; run; */

proc sort data=denominatory; by EventID; run;


data denominatory_dedup;
set denominatory;
by EventID;
if first.EventID;
run;


/* testing Isolated effect of hospitaliztionID on deduplication*/

	proc sql;
create table hospitalization
as select distinct dy.*, q.HospitalizationID

	
	from denominatory_dedup dy
	left join NewCEDRS.Hospitalizations q on dy.EventID = q.EventID
	

	group by dy.EventID;
	*/format BirthDate mmddyy10.;  
	quit;

	proc sort data=hospitalization; by EventID; run;


data hospitalization_dedup;
set hospitalization;
by EventID;
if first.EventID;
run;



/*Age calcs*/

proc sql;
create table denominatoragecalc2
as select *, input(BirthDate, anydtdtm.) as DOBdate format=datetime20.
	from denominatory
;
quit;


data denominatordaysold2;
set denominatoragecalc2;

/*BirthDate = input(put(BirthDate,$10.),yymmdd8.);
format BirthDate mmddyy8.;*/
YearIntck = yrdif(datepart(DOBDate),datepart(ReportedDate),'AGE');

run;


/**Subsetting to non-missing under 21***/
data twentyone2;
set denominatordaysold2;
where YearIntck <21 and YearIntck <>.;
run;/*skip to either repeating instrument*/
		

/*proc freq data=Twentyone2; tables HospitalizationID; run;*/


proc sql;
create table childrenshosp
as select distinct h.*,c.ICU, aa.AgencyName

	from twentyone2 h 
   
	left join NewCEDRS.zDSI_Covid19Data c on h.EventID = c.EventID
	left join Agencies.Agencies aa on h.HospitalID = aa.AgencyID
	
	group by h.EventID

;
	quit;

/*proc freq data=agencies.agencies;
	tables agencyname; run;*/


	/*Sort, Deduplication*/

	proc sort data=childrenshosp; by EventID; run;


data childrenshosp_dedup;
set childrenshosp;
by EventID;
if first.EventID;
run;




data ch_dataTransfhosp /*(drop=Count)*/;
	set childrenshosp_dedup;
	length redcap_repeat_instrument $100;
	redcap_repeat_instrument = "hospital_coursepatient_outcome";


length redcap_repeat_instance 8.;
		by EventID;
		if first.EventID then Count=.;
		Count+1;

redcap_repeat_instance=Count;

	length intermed_icu $100;
		if icu= "Yes" then intermed_icu= "Yes";
		else if icu= "No" then intermed_icu= "No";
		else intermed_icu= " ";

	length AgencyName2 $100;
		if AgencyName= " " then AgencyName2= " ";
		else if (AgencyName = "Children's Hospital Colorado Springs" OR AgencyName= "Childrens Hospital" OR AgencyName="Childrens Hospital @ Memorial Health Systems")  then AgencyName2= "Children's Hospital Colorado";
		else if AgencyName= "Denver Health Medical Center" then AgencyName2= "Denver Health";
		else if AgencyName= "Presbyterian St.Lukes Medical Center" then AgencyName2= "Rocky Mountain Hospital for Children";
		else AgencyName2= "Other";

	length admit_hospital_other $100;
		if AgencyName2= "Other" then admit_hospital_other = AgencyName;

	
	new_bdate = input(BirthDate, e8601da.); *found official sas informat for the way date  is displayed here. create in data mgt step so final var is used in rename step;
    format new_bdate MMDDYY10.;

	new_ddate = input(DeathDate, e8601da.); *found official sas informat for the way date  is displayed here. create in data mgt step so final var is used in rename step;
    format new_ddate MMDDYY10.;
	

if DeathDate ne " " then died = "Yes";
	else died = "No";


	if EventID = 541852 then delete;

run; /*skip to rename/modify step*/

data sans_icu;
	set ch_dataTransfhosp;
	drop icu count;
	run;


proc datasets library=work;
modify  sans_icu;
attrib _all_ label=' '; 
 
rename  FirstName=fname LastName=lname new_bdate=dob HospitalizedYesNO=admit AdmissionDate=admit_date died=death AgencyName2=admit_hospital
		intermed_icu=icu new_ddate=date_death DischargeDate=dis_date ;
 
		
contents data=sans_icu;
run;
	quit; /*skip to 2x export*/



	
data sans_icu_logic;
	set sans_icu;

	

	if (admit_date ne " " OR dis_date ne " " OR admit_hospital ne " " /*or ICU ne " "*/) then admit= "Yes";
		else admit=admit;/*should icu and admit hospital (AgencyName) be included?*/
	
		run; 

proc export data=sans_icu_Logic
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\sans_icu_logic.XLS'		
      dbms=xls replace;    run;



proc export data=sans_icu
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\sans_icu.XLS'		
      dbms=xls replace;    run;																		/*skip to retain step*/




data archive.retain_all21_mjhosp;
	
	retain ProfileID EventID redcap_repeat_instrument redcap_repeat_instance fname lname dob admit admit_date admit_hospital admit_hospital_other 
		icu death date_death dis_date;
		

		set sans_icu_logic;
	
	run;




	/*Subsetting to RedCap vars alone*/



data archive.redcap_all21_mjhosp;
	set archive.retain_all21_mjhosp;

	Keep ProfileID EventID redcap_repeat_instrument redcap_repeat_instance fname lname dob admit admit_date admit_hospital admit_hospital_other icu death 
		date_death dis_date;
	
	if EventID = 541852 then delete;
	
	run;



	
proc export data=archive.redcap_all21_mjhosp
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\redcap_all21_mjhosp.csv'		
      dbms=xls replace;    run;


	  /*formatting*/
data archive.format_hosp_mar_jun20;
	set archive.redcap_all21_mjhosp;

	Keep ProfileID EventID redcap_repeat_instrument redcap_repeat_instance fname lname dob admit admit_date admit_hospital admit_hospital_other icu death 
		date_death dis_date;


	  format  admit $text_ynu. icu $icu. death $death. admit_hospital $admit_hosp.;

		run;


ods excel file='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CHCO Code 5 20 22\format_hosp_mar_jun20.xls'	; /*older versions of SAS may replace this line with: ods tagsets.excelxp file=""*/
			proc report data=archive.format_hosp_mar_jun20;
				columns _all_;
			run;
		ods excel close;






















































proc export data=archive.format_ch_mj
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\format_ch_mj.CSV'		
      dbms=xls replace;    run;

proc export data=archive.format_ch_mj
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\format_ch_mj.CSV'		
      dbms=xls replace;    run;




data dob_format;
    set archive.format_ch_mj;
	drop age age_unit;
	*length new_dob $15;
    new_dob = input(dob, e8601da.); *found official sas informat for the way date  is displayed here. create in data mgt step so final var is used in rename step;
    format new_dob MMDDYY10.;

	new_ddate = input(date_death, e8601da.); *found official sas informat for the way date  is displayed here. create in data mgt step so final var is used in rename step;
    format new_ddate MMDDYY10.;

	new_dtpcr =datepart(date_pcr);/*input (put(date_pcr, DATETIME.), 10.); *numeric datetime to date;*/
   format new_dtpcr MMDDYY10.;
    *drop day;
run;


/*create dataset*/
data original_data;
    input day $ sales;
   datalines;
 
01012022 15
01022022 19
01052022 22
01142022 11
01152022 26
01212022 28
;
run;

/*view dataset*/
proc print data=original_data;

data new_data;
    set original_data;
    new_day = input(day, MMDDYY10.);
    format new_day MMDDYY10.;
    drop day;
run;

/*view new dataset*/
proc print data=new_data; 
******************END;













































































































































































































/*when creating admission table location: do proc freq of hospital name var to see if rocky mountain or other 3 options exist;
likely use hospital id so it remain numeric var, verify id to hospital name and create new var where if old var= 16 then new var =1, 
etc else new var =4*/



data archive.reord_ch_mj2;
	
	Retain EventID /*record_id redcap_repeat_instrument redcap_repeat_instance iv*/ data_source___2 mrn fname lname dob age age_unit sex ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___19 umc___10  
		pulm_dx___7 gi_dx___5 nephro_dx___2 endo_dx___1 cards_dx___4 psych_dx /*psych_other*/ gyn_dx___1 weight_dx___1 personal_smoking covid_rf___1 covid_rf___2 covid_rf___3 covid_rf___9 int_travel dom_travel
		school_daycare date_pcr covid_pcr_result pcr_site sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 /*sx_onset_other */
		date_sx_resolve /*sx_comment*/ admit admit_date icu death date_death dis_date 
		/*fam_contact*/;
	set ch_mj_logic;
	
	run;






	format data_source___2 $DATA_SOURCE. age_unit $age_unit. ethnic $ethnic. sex $sex. /*race $race.*/ umc___2 immunocomp 
		umc___1 umc___3 umc___4 umc___5 umc___8 umc___9 endo_dx___1 cards_dx___4 weight_dx___1 personal_smoking 
		umc_yn school_daycare sx_asx immunocomp. /* date_pcr MMDDYY10.  pcr_site $pcr_site. covid_pcr_result $covid_pcr_result.*/
 		/*icu $icu. death $death.  admit $admit.*/  endo_dx___1 cards_dx___4 weight_dx___1 sx_onset___2 sx_onset___3 sx_onset___4
		sx_onset___5	sx_onset___6	sx_onset___8	sx_onset___9	sx_onset___12	sx_onset___13	sx_onset___14 sx_onset___15 sx_onset___17	
		sx_onset___18	sx_onset___19	sx_onset___20	sx_onset___21	sx_onset___22	sx_onset___25 sx_onset___26 covid_rf___1 
			covid_rf___2 covid_rf___9 IMMUNOCOMP.  	sx_onset___1 sx_on_one.
		/*covid_rf___1 trvlint. covid_rf___2 trvldom.*/ umc___10 $umc_ten. umc_yn school_daycare immunocomp sx_asx YESNO. 
		sx_onset_date mmddyy10. /*redcap_repeat_instrument $redcap_repeat_instrument.; iv*/;

	run; 
	

	/*data repeatable;
	set archive.reord_ch_mj;
	input record_id redcap_repeat_instrument;
	run;
	proc sort data=archive.reord_ch_mj out=repeatable;
	by record_id redcap_repeat_instrument;
	select , row_number
	run;*/

proc freq data=allthings;
table redcap_repeat_instrument ; run;

data archive.keep_ch_mj;
	set archive.reord_ch_mj;
	keep EventID record_id  redcap_repeat_instrument 
	redcap_repeat_instance data_source___2 mrn fname lname dob age age_unit sex 
		ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___19 umc___10 umc_other 
		endo_dx___1 cards_dx___4
		/*psych_dx psych_other gyn_dx weight_dx___1*/ personal_smoking covid_rf___1 covid_rf___2 covid_rf___9 /*int_travel dom_travel*/
		school_daycare /*date_pcr covid_pcr_result pcr_site*/ sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 sx_onset_other 
		date_sx_resolve sx_comment /*admit admit_date icu death date_death dis_date*/ 
		/*fam_contact*/;
		/*IF card_dx___4=1 Then umc___4=1; else if cardio=1 then umc___4=1;
	IF endo_dx___1=1  THEN umc___3=1; 
	IF immunocomp=1 THEN umc___10=1;
	IF weight_dx___1=1 THEN umc___19=1;
	If umc___1=1 then umc_yn=1;
  	else if umc___2=1 then umc_yn=1; else if umc___3=1 then umc_yn=1; else if umc___4=1 then umc_yn=1; else if umc___5=1
	then umc_yn=1; else if umc___8=1 then umc_yn=1; else if umc___9=1 then umc_yn=1; else if umc___10=1then umc_yn=1;
	else if umc_other=1 then umc_yn=1; */
 	
	run;


	******dont run here  copied below;
	data final;
	set allthings_sorted;
	retain EventID record_id  redcap_repeat_instrument redcap_repeat_instance data_source___2 mrn fname lname dob age age_unit sex 
		ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___9 umc___10 umc_other 
		endo_dx___1 cards_dx___4
		/*psych_dx psych_other gyn_dx weight_dx___1*/ personal_smoking covid_rf___1 covid_rf___2 covid_rf___9 /*int_travel dom_travel*/
		school_daycare /*date_pcr covid_pcr_result pcr_site*/ sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 sx_onset_other 
		date_sx_resolve sx_comment /*admit admit_date icu death date_death dis_date*/ 
		/*fam_contact*/;
		if lname= " " then race=" ";
		
	
		by EVENTID;
		record_ID="NEW";
		format redcap_repeat_instrument $redcap_repeat_instrument.;
		run;



		******RESUME;


	proc append base=archive.Reord_ch_mj   data=Testtype_final force ; run;
	

data allthings;
	set archive.keep_ch_mj
		Testtype_final
		admit_final;
		format pcr_site $pcr_site40.;
		run;
		
		data fixup;
	set allthings;
		if lname= " " then race=" "; 
		if lname= " " then immuncomp=" "; if lname= " " then umc_yn=" "; if lname= " " then  umc___1=" ";
		if lname= " " then umc___2=" "; if lname= " " then umc___3=" "; if lname= " " then umc___4=" ";
		if lname= " " then umc___5=" "; if lname= " " then umc___8=" "; if lname= " " then umc___9=" ";
        if lname= " " then umc___10=" "; if lname= " " then endo_dx___1=" "; if lname= " " then cards_dx___4=" ";
		if lname= " " then personal_smoking=" ";if lname= " " then covid_rf___1=" "; if lname= " " then covid_rf___2=" ";
		if lname= " " then covid_rf___9=" ";if lname= " " then school_daycare=" "; if lname= " " then sx_asx=" ";
		if lname= " " then sx_onset___1=" "; if lname= " " then sx_onset___2=" "; if lname= " " then sx_onset___3=" ";
		if lname= " " then sx_onset___4=" "; if lname= " " then sx_onset___5=" "; if lname= " " then sx_onset___6=" ";
		if lname= " " then sx_onset___8=" "; if lname= " " then sx_onset___9=" "; if lname= " " then sx_onset___12=" ";
		if lname= " " then sx_onset___13=" "; if lname= " " then sx_onset___14=" ";
		if lname= " " then sx_onset___15=" "; if lname= " " then sx_onset___17=" ";if lname= " " then sx_onset___18=" ";
		if lname= " " then sx_onset___19=" "; if lname= " " then sx_onset___20=" "; if lname= " " then sx_onset___21=" ";
		if lname= " " then sx_onset___22=" "; if lname= " " then sx_onset___26=" "; 
		if lname= " " then sx_onset___25=" "; 
	run;
proc sort data=fixup out=allthings_sorted;
by EventID;
run;
	


data final22;
	set allthings_sorted;
	retain EventID record_id  redcap_repeat_instrument redcap_repeat_instance data_source___2 mrn fname lname dob age age_unit sex 
		ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___9 umc___10 umc_other 
		endo_dx___1 cards_dx___4
		/*psych_dx psych_other gyn_dx weight_dx___1*/ personal_smoking covid_rf___1 covid_rf___2 covid_rf___9 /*int_travel dom_travel*/
		school_daycare /*date_pcr covid_pcr_result pcr_site*/ sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 sx_onset_other 
		date_sx_resolve sx_comment /*admit admit_date icu death date_death dis_date*/ 
		/*fam_contact*/;
		if lname= " " then race=" ";
		
	
		by EVENTID;
		record_ID="NEW";
		format redcap_repeat_instrument $redcap_repeat_instrument.;
		run;

	proc append base=archive.Reord_ch_mj   data=Testtype_final force ; run;


	proc export data= final22
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CCC 3_22\final22.CSV'		
      dbms=csv replace;    run;

/*export and maintain formats*/
	ods excel file="J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\keep_ch_mj_trvlb.XLS";
		proc report data=archive.keep_ch_mj;
		columns _all_;
		run;
	ods excel close;
