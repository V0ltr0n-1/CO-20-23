
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
libname format odbc dsn='New_CEDRS_Warehouse' schema=lookups READ_LOCK_TYPE=NOLOCK;
libname archive 'J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data';
run;

proc freq data=NewCEDRS.zDSI_ProfileRaces;
	table Race1; run;


Proc format;
	value ID_sx 119="No" /*update all 3 to numeric*/
				120=.
				121="Yes";
	value $ID_sx 119="No"
				120=" "
				121="Yes";
	value sx_on_one 4014="No"
				 4016=.
				 4015="Yes";
	/*value $data_source "Children's Hospital Colorado medical record"=1 "Colorado Department of Public Health and Environment records"=2 
"Telephone call to family"=3 "Primary care provider"=4 "Other"=5;*/
	value $age_unit "days"=1 "months"=2 "years"=3;
	value $sex "Male"=1 "Female"=2 "Other"=3;/*do a proc freq or create new var with else =other*/
	value $ethnic "Hispanic or Latino"=1 "Not Hispanic or Latino"=2 "Unknown"=3;
	value $race "American Indian or Alaska Native"=1 "Asian"=2 "Black or African American"=3 "Native Hawaiian or Other Pacific Islander"=4 
"White"=5 "Unknown or not reported"=7 " "=7 "Other"=8;
	value trvldom
12= ' Alabama ' 
13= ' Alaska ' 
14= ' American Samoa ' 
15= ' Arizona ' 
16= ' Arkansas ' 
17= ' Baker Island ' 
18= ' California ' 
19= ' Colorado ' 
20= ' Connecticut ' 
21= ' Delaware ' 
22= ' District of Columbia ' 
23= ' Federated States of Micronesia ' 
24= ' Florida ' 
25= ' Georgia ' 
26= ' Guam ' 
27= ' Hawaii ' 
28= ' Howland Island ' 
29= ' Idaho ' 
30= ' Illinois ' 
31= ' Indiana ' 
32= ' Iowa ' 
33= ' Jarvis Island ' 
34= ' Johnston Atoll ' 
35= ' Kansas ' 
36= ' Kentucky ' 
37= ' Kingman Reef ' 
38= ' Louisiana ' 
39= ' Maine ' 
40= ' Marshall Islands ' 
41= ' Maryland ' 
42= ' Massachusetts ' 
43= ' Michigan ' 
44= ' Midway Islands ' 
45= ' Minnesota ' 
46= ' Mississippi ' 
47= ' Missouri ' 
48= ' Montana ' 
49= ' Navassa Island ' 
50= ' Nebraska ' 
51= ' Nevada ' 
52= ' New Hampshire ' 
53= ' New Jersey ' 
54= ' New Mexico ' 
55= ' New York ' 
56= ' North Carolina ' 
57= ' North Dakota ' 
58= ' Northern Mariana Islands ' 
59= ' Ohio ' 
60= ' Oklahoma ' 
61= ' Oregon ' 
62= ' Palau ' 
63= ' Palmyra Atoll ' 
64= ' Pennsylvania ' 
65= ' Puerto Rico ' 
66= ' Rhode Island ' 
67= ' South Carolina ' 
68= ' South Dakota ' 
69= ' Tennessee ' 
70= ' Texas ' 
71= ' U.S. Minor Outlying Islands ' 
72= ' Utah ' 
73= ' Vermont ' 
74= ' Virgin Islands of the U.S. ' 
75= ' Virginia ' 
76= ' Wake Island ' 
77= ' Washington ' 
78= ' West Virginia ' 
79= ' Wisconsin ' 
80= ' Wyoming ' 
 
;
	value trvlint
	512= ' AFGHANISTAN ' 
513= ' ALBANIA ' 
514= ' ALGERIA ' 
515= ' AMERICAN SAMOA ' 
516= ' ANDORRA ' 
517= ' ANGOLA ' 
518= ' ANGUILLA ' 
519= ' ANTARCTICA ' 
520= ' ANTIGUA AND BARBUDA ' 
521= ' ARGENTINA ' 
522= ' ARMENIA ' 
523= ' ARUBA ' 
524= ' ASHMORE AND CARTIER ISL ' 
525= ' AUSTRALIA ' 
526= ' AUSTRIA ' 
527= ' AZERBAIJAN ' 
528= ' BAHAMAS, THE ' 
529= ' BAHRAIN ' 
530= ' BAKER ISLAND ' 
531= ' BANGLADESH ' 
532= ' BARBADOS ' 
533= ' BASSAS DA INDIA ' 
534= ' BELARUS ' 
535= ' BELGIUM ' 
536= ' BELIZE ' 
537= ' BENIN ' 
538= ' BERMUDA ' 
539= ' BHUTAN ' 
540= ' BOLIVIA ' 
541= ' BOSNIA AND HERCEGOVINA ' 
542= ' BOTSWANA ' 
543= ' BOUVET ISLAND ' 
544= ' BRAZIL ' 
545= ' BR INDIAN OCEAN TERR ' 
546= ' BRUNEI ' 
547= ' BULGARIA ' 
548= ' BURKINA (UPPER VOLTA) ' 
549= ' BURMA ' 
550= ' BURUNDI ' 
551= ' CAMBODIA ' 
552= ' CAMEROON ' 
553= ' CANADA ' 
554= ' CAPE VERDE ' 
555= ' CAYMAN ISLANDS ' 
556= ' CENTRAL AFRICAN REP. ' 
557= ' CHAD ' 
558= ' CHILE ' 
559= ' CHINA ' 
560= ' CHRISTMAS ISLAND ' 
561= ' CLIPPERTON ISLAND ' 
562= ' COCOS (KEELING) ISLANDS ' 
563= ' COLOMBIA ' 
564= ' COMOROS ' 
565= ' CONGO ' 
566= ' COOK ISLANDS ' 
567= ' CORAL SEA ISLANDS ' 
568= ' COSTA RICA ' 
569= ' IVORY COAST ' 
570= ' CROATIA ' 
571= ' CUBA ' 
572= ' CYPRUS ' 
573= ' CZECH REPUBLIC ' 
574= ' CZECHOSLOVAKIA ' 
575= ' DENMARK ' 
576= ' DJIBOUTI ' 
577= ' DOMINICA ' 
578= ' DOMINICAN REPUBLIC ' 
579= ' PORTUGUESE TIMOR ' 
580= ' ECUADOR ' 
581= ' EGYPT ' 
582= ' EL SALVADOR ' 
583= ' EQUATORIAL GUINEA ' 
584= ' ERITREA ' 
585= ' ESTONIA ' 
586= ' ETHIOPIA ' 
587= ' EUROPA ISLAND ' 
588= ' FALKLAND (IS MALVINAS) ' 
589= ' FAROE ISLANDS ' 
590= ' FIJI ' 
591= ' FINLAND ' 
592= ' FRANCE ' 
593= ' FRENCH GUIANA ' 
594= ' FRENCH POLYNESIA ' 
595= ' FR SO & ANTARCTIC LNDS ' 
596= ' GABON ' 
597= ' GAMBIA, THE ' 
598= ' GAZA STRIP ' 
599= ' GEORGIA ' 
600= ' GERMANY ' 
601= ' GHANA ' 
602= ' GIBRALTAR ' 
603= ' GLORIOSO ISLANDS ' 
604= ' GREECE ' 
605= ' GREENLAND ' 
606= ' GRENADA ' 
607= ' GUADELOUPE ' 
608= ' GUAM ' 
609= ' GUATEMALA ' 
610= ' GUERNSEY ' 
611= ' GUINEA ' 
612= ' GUINEA-BISSAU ' 
613= ' GUYANA ' 
614= ' HAITI ' 
615= ' HEARD IS&MCDONALD ISLS ' 
616= ' VATICAN CITY ' 
617= ' HONDURAS ' 
618= ' HONG KONG ' 
619= ' HOWLAND ISLAND ' 
620= ' HUNGARY ' 
621= ' ICELAND ' 
622= ' INDIA ' 
623= ' INDONESIA ' 
624= ' IRAN ' 
625= ' IRAQ ' 
626= ' IRELAND ' 
627= ' MAN, ISLE OF ' 
628= ' ISRAEL ' 
629= ' ITALY ' 
630= ' JAMAICA ' 
631= ' JAN MAYEN ' 
632= ' JAPAN ' 
633= ' JARVIS ISLAND ' 
634= ' JERSEY ' 
635= ' JOHNSTON ATOLL ' 
636= ' JORDAN ' 
637= ' JUAN DE NOVA ISLAND ' 
638= ' KAZAKHSTAN ' 
639= ' KENYA ' 
640= ' KINGMAN REEF ' 
641= ' KIRIBATI ' 
642= ' KOREA,DEM PEOPLES REP ' 
643= ' KOREA, REPUBLIC OF ' 
644= ' KUWAIT ' 
645= ' KYRGYZSTAN ' 
646= ' LAOS ' 
647= ' LATVIA ' 
648= ' LEBANON ' 
649= ' LESOTHO ' 
650= ' LIBERIA ' 
651= ' LIBYA ' 
652= ' LIECHTENSTEIN ' 
653= ' LITHUANIA ' 
654= ' LUXEMBOURG ' 
655= ' MACAU ' 
656= ' MACEDONIA ' 
657= ' MADAGASCAR ' 
658= ' MALAWI ' 
659= ' MALAYSIA ' 
660= ' MALDIVES ' 
661= ' MALI ' 
662= ' MALTA ' 
663= ' MARSHALL ISLANDS ' 
664= ' MARTINIQUE ' 
665= ' MAURITANIA ' 
666= ' MAURITIUS ' 
667= ' MAYOTTE ' 
668= ' MEXICO ' 
669= ' FED STATES MICRONESIA ' 
670= ' MIDWAY ISLAND ' 
671= ' MOLDOVA ' 
672= ' MONACO ' 
673= ' MONGOLIA ' 
674= ' MONTENEGRO ' 
675= ' MONTSERRAT ' 
676= ' MOROCCO ' 
677= ' MOZAMBIQUE ' 
678= ' NAMIBIA ' 
679= ' NAURU ' 
680= ' NAVASSA ISLAND ' 
681= ' NEPAL ' 
682= ' NETHERLANDS ' 
683= ' NETHERLANDS ANTILLES ' 
684= ' IRAQ-S ARABIA NEUTRAL Z ' 
685= ' NEW CALEDONIA ' 
686= ' NEW ZEALAND ' 
687= ' NICARAGUA ' 
688= ' NIGER ' 
689= ' NIGERIA ' 
690= ' NIUE ' 
691= ' NOT SPECIFIED ' 
692= ' NORFOLK ISLAND ' 
693= ' NORTHERN MARIANA IS ' 
694= ' NORWAY ' 
695= ' OMAN ' 
696= ' PAKISTAN ' 
697= ' PALAU ' 
698= ' PALMYRA ATOLL ' 
699= ' PANAMA ' 
700= ' PAPUA NEW GUINEA ' 
701= ' PARACEL ISLANDS ' 
702= ' PARAGUAY ' 
703= ' PERU ' 
704= ' PHILIPPINES ' 
705= ' PITCAIRN ISLANDS ' 
706= ' POLAND ' 
707= ' PORTUGAL ' 
708= ' PUERTO RICO ' 
709= ' QATAR ' 
710= ' REUNION ' 
711= ' ROMANIA ' 
712= ' RUSSIA ' 
713= ' RWANDA ' 
714= ' ST. HELENA ' 
715= ' ST. KITTS AND NEVIS ' 
716= ' ST LUCIA ' 
717= ' ST. PIERRE AND MIQUELON ' 
718= ' ST. VINCENT/GRENADINES ' 
719= ' WESTERN SAMOA ' 
720= ' SAN MARINO ' 
721= ' SAO TOME AND PRINCIPE ' 
722= ' SAUDI ARABIA ' 
723= ' SENEGAL ' 
724= ' SERBIA ' 
725= ' SEYCHELLES ' 
726= ' SIERRA LEONE ' 
727= ' SINGAPORE ' 
728= ' SLOVAK REPUBLIC ' 
729= ' SLOVENIA ' 
730= ' SOLOMON ISLANDS ' 
731= ' SOMALIA ' 
732= ' SOUTH AFRICA ' 
733= ' S.GEORGIA/S.SANDWIC IS ' 
734= ' SPAIN ' 
735= ' SPRATLY ISLANDS ' 
736= ' SRI LANKA ' 
737= ' SUDAN ' 
738= ' SURINAME ' 
739= ' SVALBARD ' 
740= ' SWAZILAND ' 
741= ' SWEDEN ' 
742= ' SWITZERLAND ' 
743= ' SYRIA ' 
744= ' TAIWAN ' 
745= ' TAJIKISTAN ' 
746= ' TANZANIA, UNITED REP OF ' 
747= ' THAILAND ' 
748= ' TIMOR-LESTE ' 
749= ' TOGO ' 
750= ' TOKELAU ' 
751= ' TONGA ' 
752= ' TRINIDAD AND TOBAGO ' 
753= ' TROMELIN ISLAND ' 
754= ' TUNISIA ' 
755= ' TURKEY ' 
756= ' TURKMENISTAN ' 
757= ' TURKS AND CAICOS ISL ' 
758= ' TUVALU ' 
759= ' US MISC PACIFIC ISLANDS ' 
760= ' SOVIET UNION ' 
761= ' UGANDA ' 
762= ' UKRAINE ' 
763= ' UNITED ARAB EMIRATES ' 
764= ' UNITED KINGDOM ' 
765= ' UNITED STATES ' 
766= ' U.S. MINOR OUTLYING ISL ' 
767= ' unknown ' 
768= ' URUGUAY ' 
769= ' UZBEKISTAN ' 
770= ' VANUATU (NEW HEBRIDES) ' 
771= ' VENEZUELA ' 
772= ' VIETNAM ' 
773= ' BRITISH VIRGIN IS. ' 
774= ' VIRGIN ISLANDS ' 
775= ' WAKE ISLAND ' 
776= ' WALLIS AND FUTUNA ' 
777= ' WEST BANK ' 
778= ' WESTERN SAHARA ' 
779= ' YEMEN ' 
780= ' YUGOSLAVIA ' 
781= ' ZAIRE ' 
782= ' ZAMBIA ' 
783= ' ZIMBABWE ' 

;

	run;
/*proc contents data=format.codes; run;
proc freq data = format.codes;
tables ConceptGroup; run;*/
proc sql;
create table denominatory
as select distinct d.ProfileID, d.LastName, d.FirstName, d.MiddleName, d.Birthdate, d.Ethnicity, d.DeathDate, d.Address1, d.Address2, d.AddressType, d.City, d.State,
d.StateCode, d.ZipCode, d.County, d.Gender, e.EventID, e.Disease, e.EventStatus, e.ReportedDate, e.Age, e.AgeType, e.Outcome, e.HospitalName, e.HospitalizedYesNo, e.ActiveAddressID, e.HospitalizedYesNo, 
e.AdmissionDate, e.DischargeDate, e.MedicalRecordNumber, e.PregnantYesNo, e.LiveInInstitution, e.ExposureFacilityType
	
	from NewCEDRS.zDSI_Profiles d
	left join NewCEDRS.zDSI_Events e on d.ProfileID = e.ProfileID


	where d.ProfileID ne . and e.Deleted ne 1 and e.EventID ne . /*and (e.ReportedDate < '20MAY2020'd)*/ 
    and e.disease ='COVID-19' and e.EventStatus in ('Confirmed') and e.countyassigned <> 'Out of State'

	group by e.EventID

;
	quit;



	


	proc contents data=NewCEDRS.zDSI_Profiles; run;
	proc contents data=NewCEDRS.zDSI_Events; run;
    proc contents data=NewCEDRS.SurveillanceFormCovid19; run;
	/*proc contents data=NewCEDRS.Labs; run;*/
	/*proc contents data=NewCEDRS.zDSI_LabTests; run;*/
	/*proc contents data=NewCEDRS.LabSpecimens; run;*/
	/*proc contents data=NewCEDRS.SurveillanceFormRisk; run;*/
	/*proc contents data=NewCEDRS.viewLabDetails; run;*/
	proc contents data=NewCEDRS.zDSI_Covid19Data; run;
	/*proc contents data=NewCEDRS.zDSI_Specimens; run;*/
	/*proc contents data=NewCEDRS.zDSI_Covid19Data; run;*/
	proc contents data=NewCEDRS.SurveillanceFormSymptoms; run;
	/*proc contents data=NewCEDRS.SurveillanceFormRisk; run;/*has FormBaseID and FormRiskID link 2 2 below*/
	/*proc contents data=NewCEDRS.SurveillanceFormBase; run;/*has eventid and FormBaseID, link 1*/
	/*proc contents data=NewCEDRS.viewEventDetailsOmitDeletes; run;*/
	proc contents data=NewCEDRS.viewFirstHospitalDetails; run;
	/*proc contents data=NewCEDRS.viewEventDetails; run;/*has FormBaseID and FormRiskID link 2 2 below*/
	/*proc contents data=NewCEDRS.SurveillanceFormTreatments; run;*/
	proc contents data=NewCEDRS.Hospitalizations; run;


proc sql;
create table denominatoragecalc2
as select *, input(BirthDate, anydtdtm.) as DOBdate format=datetime20.
	from denominatory
;
quit;

/*Proc print data=denominatoragecalc;
	run;*/

data denominatordaysold2;
set denominatoragecalc2;

/*BirthDate = input(put(BirthDate,$10.),yymmdd8.);
format BirthDate mmddyy8.;*/
YearIntck = yrdif(datepart(DOBDate),datepart(ReportedDate),'AGE');

run;

data twentyone2;
set denominatordaysold2;
where YearIntck <21 and YearIntck <>.;
run;


proc sql;
create table tests
as select distinct d.*, 
s.TestingLabName, s.OriginatingLabName, s.CollectionDate,
l.TestType, l.ResultDate, l.ResultText
	
	from twentyone2 d
    
	left join NewCEDRS.zDSI_Specimens s on d.EventID = s.EventID
	left join NewCEDRS.zDSI_LabTests l on d.EventID = l.EventID 
	
	group by d.EventID

;
	quit;

data all21;
set tests;
by EventID;
if first.eventID;
run;

****************IRB renewal calcs**************************;
proc freq data = all21;
	tables PregnantYesNo LiveInInstitution ExposureFacilityType;
	run;
proc freq data = all21;
	tables Gender*Ethnicity;
	run;

proc freq data = all21;
	tables Gender*(Race1 Race2 Race3 Race4);
	run;


	/**************STOP for IRB renewal****************/


data chco_yn;
set all21;
IF (HospitalName = 'Childrens Hospital') or (TestingLabName = 'Childrens Hospital') or (OriginatingLabName = 'Childrens Hospital')
THEN CHCFlag = 'YES';
Else CHCFlag = 'NO';
run;

proc sql;
create table childrens
as select distinct h.*, r.Race1, r.Race2, r.Race3, r.Race4,c.ICU,
f.DiabetesID, f.ChronicRenalDiseaseID,f.ChronicLiverDiseaseID, f.ChronicOtherID, f.ChronicOtherDesc,
f.UnderlyingMedicalConditionID,f.UnderlyingMedicalConditionDesc, f.PsychologicalID, f.PsychologicalDesc, f.DisabilityID,f.DisabilityDesc, f.VapeCurrentID, f.VapeFormerID,
f.SmokerCurrentID,f.SmokerFormerID, f.ExpoCatCruiseShipTravel,f.ExpoCatWorkplace, f.ExpoCatAirportAirplane,f.ExpoCatAuditLivingFacility, f.ExpoCatEducationFacility, 
f.ExpoCatCorrectionalFacility, f.ExpoCatAnimalContact, f.ExpoCatOther,f.ExpoSocialGatheringID,f.ExpoVisitHealthcareAsPatientID,f.ExpoVisitHealthcareNotPatientID,
f.ExpoSocialGatheringInfo,f.ImmunocompromisedID,f.TravelInternationalID, f.TravelDomesticID, f.ExpoContConfRelContactOnly,
f.OccupationTypeID, f.OtherOccupationTypeDesc, f.ExpoContConfSettingDaycare, f.ExpoContConfSettingShoolUniversi, f.AutoImmuneConditionID, f.BloodDisorderID, f.CancerID,
f.HypertensionID, f.HeartDiseaseID, f.SevereObesityID, f.LungDiseaseID, f.CommentSymptoms, /*f.ICU*/
/* v.SpecimenSource,*/ sx.Symptoms, sx.FeverOver100_4, sx.FeverChills, sx.AnyCough, sx.RunnyNose, sx.DifficultyBreathing, sx.ChestPain, sx.TasteSmell, 
sx.Headache, sx.SoreThroat, sx.Wheezing, sx.Apnea, sx.Cyanosis, /*sx.HypoxiaID,*/ sx.Diarrhea, sx.AbdoPain, sx.Vomiting, sx.Seizures, sx.AnyRash, sx.Conjunctivitis, 
sx.Fatigue, sx.SymptomOnsetDate, sx.OtherSymptomDesc, sx.SymptomResolutionDate, sx.OtherSymptoms,
 f.CommentSymptoms,f.LungDiseaseID, f.DiabetesID, f.HeartDiseaseID, f.HypertensionID, f.ChronicRenalDiseaseID,f.ChronicLiverDiseaseID, f.AutoImmuneConditionID,
f.BloodDisorderID, f.SevereObesityID, f.ExpoContConfRelChild, f.ExpoContConfRelOtherFamily, f.ExpoContConfRelSpousePartner, f.ExpoContConfRelParent, 
f.ExpoContSympSettingHousehold,
ft.CountryID, st.StateID	
	from chco_yn h
    left join NewCEDRS.zDSI_ProfileRaces r on h.ProfileID = r.ProfileID
	left join NewCEDRS.SurveillanceFormCovid19 as f on h.EventID = f.EventID
	/*left join NewCEDRS.viewLabDetails v on e.EventID = v.EventID*/
	left join NewCEDRS.zDSI_Covid19Data c on h.EventID = c.EventID
	inner join NewCEDRS.SurveillanceFormBase b on h.eventID = b.eventID
	left join NewCEDRS.SurveillanceformSymptoms sx on b.FormBaseID = sx.FormBaseID
	left join NewCEDRS.ForeignTrips as ft on h.EventID = ft.EventID
    left join NewCEDRS.UnitedStateTrips as st on h.EventID = st.EventID

	group by h.EventID

;
	quit;


data all21;
set childrens;
by EventID;
if first.eventID;
run;


proc export data=all21
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\ChCO 6_21\all21.CSV'		
      dbms=csv replace;    run;

/*Subset under 21 to CHOC alone*/
/*Data Transforming: creating new var to match REdcap var*/
	  data all21b;
	  	set all21;
		where CHCFlag='YES';run;
data ch21 /*(drop=Count)*/;
	set all21;
	where CHCFlag= 'YES';
	length cdrs_source $80;
	cdrs_source=1;
	length immuno10 $50;
	immuno10=ImmunocompromisedID;
	length diabmel $10;/*copying diabetes into new var diab mel for diab mel specific var, all datamgt in one place and to not confuse SAS*/
	diabmel=DiabetesID;
	compd_add= CATX (' ', Address1, Address2);
	*compd_add=Address1||Address2;
	length newrace $100;
	if Race1="Other Race" then newrace="Other";
		else if Race1="Unknown" then newrace="Unknown or not reported";
		else newrace=Race1;
	/*if HypertensionID=119 or HeartDiseaseID= 119
		then cardio=119;
		/*else if HypertensionID=120 or HeartDiseaseID= 120
		then cardio=120;*/
	    /*Else if HypertensionID=121 or HeartDiseaseID= 121
		then cardio=121;
		else cardio=.;*/

array hhd{2} HypertensionID HeartDiseaseID;
	do Count = 1 to 2;
		if hhd{Count} = 119 then cardio=119;
		else if hhd{Count}=120 then cardio=120;
	    Else if hhd{Count}= 121 then cardio=121;
	end;

	array chronic1{3} CancerID  SevereObesityID  AutoImmuneConditionID;
	do Count = 1 to 3;
		if chronic1{Count} = 119 then other=119;
		else if chronic1{Count}=120 then other=120;
	    Else if chronic1{Count}= 121 then other=121;
	end;
	array vape_smoke{4} SmokerCurrentID SmokerFormerID VapeCurrentID VapeFormerID;
	do Count = 1 to 4;
		if vape_smoke{Count} = 119 then vsmoke=119;
		else if vape_smoke{Count}=120 then vsmoke=120;
	    Else if vape_smoke{Count}= 121 then vsmoke=121;
	end;

	/*array family_contact{4} ExpoContConfRelChild ExpoContConfRelOtherFamily ExpoContConfRelSpousePartner ExpoContConfRelParent;
		do Count = 1 to 4;
			if family_contact{Count} = . Then fam_contact=' ';
			else if family_contact{Count} = 1 Then family_contact= 'Yes';
		    else if family_contact{Count} = 0 Then  family_contact= 'No';
	end; *Need the correct format code for 0 and 1 to include;*/
		
	array school{2} ExpoContConfSettingShoolUniversi ExpoContConfSettingDaycare;
	do Count = 1 to 2;
		if school{Count} = 119 then sch_exp=119;
		else if school{Count}=120 then sch_exp=120;
	    Else if school{Count}= 121 then sch_exp=121;
	end;


	if TestType in ('PCR', 'RT-PCR', 'RT-PCR at CDC')
		then pcr_result = ResultText;
		else pcr_result = ' ';
		
length testlab $100;
if TestingLabName=" " then testlab=" ";
		else if TestingLabName in ('CDPHE', 'Childrens Hospital')
		then do;
		if TestingLabName='CDPHE' then testlab='CDPHE';
			else if TestingLabName='Childrens Hospital' then testlab="CHCO (Children's Hospital Colorado)";
		end;
	else testlab= 'Other';

if DeathDate ne " " then died = "Yes";
	else died = "No";


/*length int $200;
	if CountryID = . then int=" ";
	else*/ int=CountryID;

/*length dom $200;
	if StateID = . then dom=" ";
	else*/ dom=StateID; 
	

format DiabetesID	ChronicRenalDiseaseID	ChronicLiverDiseaseID	ChronicOtherID UnderlyingMedicalConditionID PsychologicalID DisabilityID 
		VapeCurrentID	VapeFormerID	SmokerCurrentID	SmokerFormerID ExpoSocialGatheringID ExpoVisitHealthcareAsPatientID	
		ExpoVisitHealthcareNotPatientID ImmunocompromisedID	TravelInternationalID	TravelDomesticID OccupationTypeID AutoImmuneConditionID	
		BloodDisorderID	CancerID	HypertensionID	HeartDiseaseID	SevereObesityID	LungDiseaseID 
		ID_sx. int trvlint. dom trvldom.;

run;

proc freq data=ch21;
	tables  dom int ImmunocompromisedID	TravelInternationalID	TravelDomesticID OccupationTypeID AutoImmuneConditionID	
		BloodDisorderID	CancerID /*ExpoContConfRelChild ExpoContConfRelOtherFamily ExpoContConfRelSpousePartner ExpoContConfRelParent /*int dom  /*cardio TravelInternationalID TravelDomesticID died vsmoke other HeartDiseaseID HypertensionID sch_exp*/;
	run;

/*******check if new address and aother variables created here, if yes include below in final export*******/

*skipped export below, 6/21***;
proc export data=ch21
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CCC 3_22\ch21.CSV'		
      dbms=csv replace;    run;
/*create data set of childrens cases not alredy in CHOC dataset*/******remove 19 CHCO identified from this delete list;
 data ch21_miss;
	  set ch21;
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
data ch21_msmj ;
	drop state;
	set ch21_miss;

	if '01MAR2020:00:00:00'dt <= ReportedDate <= '30JUN2020:00:00:00'dt; 
	
	run;

	data ch21_msmj_apr2;
set ch21_msmj;
by EventID;
if first.eventID;
run;
proc export data=ch21_msmj_apr2
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\CCC 3_22\ch21_msmj_apr2.XLS'		
      dbms=xls replace;    run;
proc print data=ch_miss_mj;run;

*nonCHOC data under 21yrs;
data n_chclt21_2 ;
	set final;
	where CHCFlag= 'NO';
	run;
proc export data=n_chclt21
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\n_chclt21.CSV'		
      dbms=csv replace;    run;


		/*subset nonCHOC under 21yrs to Mar-June*/
		data archive.n_chclt21_mj;
			set n_chclt21;
			if '01MAR2020:00:00:00'dt <= ReportedDate <= '30JUN2020:00:00:00'dt; 
			run;

		proc export data=archive.n_chclt21_mj
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\n_chclt21_mj.XLS'		
      		dbms=xls replace;    run;

			
proc contents data=archive.n_chclt21_mj; run; *pre var renaming check;


proc datasets library=work;
modify  ch21_msmj_apr2;
attrib _all_ label=' '; 
 
rename  cdrs_source=data_source___2 MedicalRecordNumber=mrn FirstName=fname LastName=lname BirthDate=dob Age=age AgeType=age_unit Gender=sex 
		Ethnicity=ethnic newrace=race
		compd_add=address City=city StateCode=state County=county ZipCode=zip ImmunocompromisedID=immunocomp UnderlyingMedicalConditionID=umc_yn
		LungDiseaseID=umc___1 ChronicLiverDiseaseID=umc___2 DiabetesID=umc___3 cardio=umc___4 ChronicRenalDiseaseID=umc___5 
		BloodDisorderID=umc___8 other=umc___9 immuno10=umc___10 UnderlyingMedicalConditionDesc=umc_other diabmel=endo_dx___1 /*adding vars and also formatting*/
		HypentensionID=cards_dx___4
		PsychologicalID=psych_dx PsychologicalDesc=psych_other PregnantYesNo=gyn_dx SevereObesityID=weight_dx___1 vsmoke=personal_smoking int=covid_rf___1
		dom=covid_rf___2 /*fam_contact=covid_rf___3*/ ExpoContSympSettingHousehold=covid_rf___9 /*int=int_travel dom=dom_travel*/
		sch_exp=school_daycare CollectionDate=date_pcr pcr_result=covid_pcr_result testlab=pcr_site
        Symptoms=sx_asx SymptomOnsetDate=sx_onset_date FeverOver100_4=sx_onset___1 FeverChills=sx_onset___2 AnyCough=sx_onset___3 
		RunnyNose=sx_onset___4 DifficultyBreathing=sx_onset___5
		ChestPain=sx_onset___6 TasteSmell=sx_onset___8 Headache=sx_onset___9 SoreThroat=sx_onset___12 Wheezing=sx_onset___13 Apnea=sx_onset___14
		Cyanosis=sx_onset___15 /*HypoxiaID=sx_onset___16*/ Diarrhea=sx_onset___17 AbdoPain=sx_onset___18 Vomiting=sx_onset___19 
		Seizures=sx_onset___20
		AnyRash=sx_onset___21 Conjunctivitis=sx_onset___22 Fatigue=sx_onset___26 OtherSymptoms=sx_onset___25 OtherSymptomDesc=sx_onset_other 
		SymptomResolutionDate=date_sx_resolve CommentSymptoms=sx_comment HospitalizedYesNO=admit AdmissionDate=admit_date ICU=icu /*icudate*/ died=death
		DeathDate=date_death DischargeDate=dis_date 
		 /*any_smoke=personal_smoking any_vape=smoke_other*/
		/*ExpoContConfRelContactOnly=fam_contact*/; 
contents data=ch21_msmj_apr2;
run;
	quit;
proc export data=ch21_msmj_apr2
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\ch21_msmj_apr2.XLS'		
      		dbms=xls replace;    run;
	proc print data=all21;run;

proc contents data=ccc.n_chclt21_mj; run;*post var renaming check;

data 
*reordering variables;
data archive.reord_ch_mj;
	retain data_source___2 mrn fname lname dob age age_unit sex 
		ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___9 umc___10 umc_other 
		endo_dx___1 cards_dx___4
		psych_dx psych_other gyn_dx weight_dx___1 personal_smoking covid_rf___1 covid_rf___2 covid_rf___9 /*int_travel dom_travel*/
		school_daycare date_pcr covid_pcr_result pcr_site sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 sx_onset_other 
		date_sx_resolve sx_comment admit admit_date icu death date_death dis_date 
		/*fam_contact*/;
	set ch21_msmj_apr2;
	format age_unit $age_unit. ethnic $ethnic. race $race. umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___9 umc___10 umc___4 umc___9 umc___10 endo_dx___1 cards_dx___4 weight_dx___1 personal_smoking sx_asx sx_onset___2 sx_onset___3 sx_onset___4
		sx_onset___5	sx_onset___6	sx_onset___8	sx_onset___9	sx_onset___12	sx_onset___13	sx_onset___14 sx_onset___15 sx_onset___17	
		sx_onset___18	sx_onset___19	sx_onset___20	sx_onset___21	sx_onset___22	sx_onset___26 ID_sx. sx_onset___1 sx_on_one. 
		covid_rf___1 trvlint. covid_rf___2 trvldom.;

	run; 


data archive.keep_ch_mj;
	set archive.reord_ch_mj;
	keep data_source___2 mrn fname lname dob age age_unit sex 
		ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___9 umc___10 umc_other 
		endo_dx___1 cards_dx___4
		psych_dx psych_other gyn_dx weight_dx___1 personal_smoking covid_rf___1 covid_rf___2 covid_rf___9 /*int_travel dom_travel*/
		school_daycare date_pcr covid_pcr_result pcr_site sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 sx_onset_other 
		date_sx_resolve sx_comment admit admit_date icu death date_death dis_date 
		/*fam_contact*/;
	run;
	

	proc export data=archive.keep_ch_mj
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\keep_ch_mj_trvl.XLS'		
      		dbms=xls replace;    run;

/*export and maintain formats*/
	ods excel file="J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\keep_ch_mj_trvlb.XLS";
		proc report data=archive.keep_ch_mj;
		columns _all_;
		run;
	ods excel close;
