
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
	/*value ID_sx 119="No" /*update all 3 to numeric*/
				/*120=.
				121="Yes";
	value $ID_sx 119="No"
				120=" "
				121="Yes";*/
	value sx_on_one 4014=0
				 4016=0
				 4015=1;
	/*value $data_source "Children's Hospital Colorado medical record"=1 "Colorado Department of Public Health and Environment records"=2 
"Telephone call to family"=3 "Primary care provider"=4 "Other"=5;*/
	value $DATA_SOURCE "Children's Hospital Colorado medical record"=1 "Colorado Department of Public Health and Environment records"=2 
"Telephone call to family"=3 "Primary care provider"=4 "Other"=5;
	value $age_unit "days"=1 "months"=2 "years"=3;
	value $sex "Male"=1 "Female"=2 "Other"=3;/*do a proc freq or create new var with else =other*/
	value $ethnic "Hispanic or Latino"=1 "Not Hispanic or Latino"=2 "Unknown"=3;
	value $race "American Indian or Alaska Native"=1 "Asian"=2 "Black or African American"=3 "Native Hawaiian or Other Pacific Islander"=4 
"White"=5 "Unknown or not reported"=7 " "=7 "Other"=8;
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
*value pcr_date ;
Value $redcap_repeat_instrument "RT-PCR"="covid19_pcr_testing"
								"RT"="covid19_pcr_testing"
							"IgG"= "covid19_serologic_testing"
							"IgA"= "covid19_serologic_testing"
							"IgM"=  "covid19_serologic_testing"
							"Ig"="covid19_pcr_testing"
							"Yes"="hospital_coursepatient_outcome"
							"Ye"="hospital_coursepatient_outcome"
							"No"=" ";
	Value $empty "0"=" " "1"= " " "2"=" " "3"=" " "4"=" " "5"=" " "6"=" " "7"=" " "8"=" " "9"=" "
					"W"=" " "O"=" " "A"=" " "N"=" " "U"=" " "B"=" " "American Indian or Alaska Native"=" " "Asian"=" " "Black or African American"=" "
				"Native Hawaiian or Other Pacific Islander"=" " "White"=" " "Unknown or not reported"=" "  "Other"=" ";




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
783= ' ZIMBABWE ' ;

value admisssion_location
0="	No Agency"
2="	Alamosa County Public Health Department"
3="	Arkansas Valley Regional Medical Center"
4="	Aspen Valley Hospital"
5="	Medical Center of Aurora - North"
6="	Baca County Public Health Agency"
7="	Bent County Public Health Agency"
9="	Boulder Community Hospital"
10="	Boulder County Public Health"
11="	Broomfield Public Health and Environment"
12="	Cedar Springs Hospital"
13="	Chaffee County Public Health"
14="	Charter Centennial Peaks"
15="	Cheyenne County Public Health Agency"
16="	Childrens Hospital"
17="	Clagett Memorial Hospital"
18="	Clear Creek Public & Environmental Health"
21="	Community Hospital"
22="	Conejos County Hospital"
23="	Conejos County Public Health and Nursing Service"
24="	Costilla County Public Health Agency"
25="	Craig Hospital"
26="	Crowley County Nursing Service"
27="	Custer County Public Health Agency"
28="	Delta County Dept of Health and Human Services"
29="	Delta County Memorial Hospital"
30="	Denver Public Health Department"
31="	Denver Health Medical Center"
32="	Dolores County Public Health"
33="	Eagle County Public Health"
34="	East Morgan County Hospital"
35="	El Paso County Public Health"
36="	Elbert County Dept Health and Human Services"
37="	Estes Park Medical Center "
38="	Evans Army Hospital, Preventative Medicine"
39="	Colorado Canyons"
40="	Fort Lyons Medical Center"





;

	run;
/*proc contents data=format.codes; run;
proc freq data = format.codes;
tables ConceptGroup; run;*/
proc sql;
create table denominatory
as select distinct d.ProfileID, d.LastName, d.FirstName, d.MiddleName, d.BirthDate, d.Ethnicity, d.DeathDate, d.Address1, d.Address2, d.AddressType, d.City, d.State,
d.StateCode, d.ZipCode, d.County, d.Gender, e.EventID, e.Disease, e.EventStatus, e.ReportedDate, e.Age, e.AgeType, e.Outcome, e.HospitalName, e.HospitalizedYesNo, e.ActiveAddressID, e.HospitalizedYesNo, 
e.AdmissionDate, e.DischargeDate, e.MedicalRecordNumber, e.PregnantYesNo, e.LiveInInstitution, e.ExposureFacilityType, /*datepart(e.OnsetDate)as OnsetDate format mmddyy10.,*/ q.HospitalID
	
	from NewCEDRS.zDSI_Profiles d
	left join NewCEDRS.zDSI_Events e on d.ProfileID = e.ProfileID
	left join NewCEDRS.Hospitalizations q on d.ProfileID = q.ProfileID


	where d.ProfileID ne . and e.Deleted ne 1 and e.EventID ne . /*and (e.ReportedDate < '20MAY2020'd)*/ 
    and e.disease ='COVID-19' and e.EventStatus in ('Confirmed') and e.countyassigned <> 'Out of State'
	and '01MAR2020:00:00:00'dt <= ReportedDate <= '30SEP2020:00:00:00'dt 

	group by e.EventID;
	*/format BirthDate mmddyy10.;  
	quit;



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


/**Subsetting to non-missing under 21***/
data twentyone2;
set denominatordaysold2;
where YearIntck <21 and YearIntck <>.;
run;

/**including variables to flag as chco***/
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
run;/*skip to proc sql childrens*/



******************************************************************************************************************************************
******************SKIP THESE STEPS WHEN RUNNING DATA ON ALL COLORADO UNDER21 & CHANGE DATA NAME IN LARGE JOIN BELOW***********************;
/*data chco_yn;
set all21;
IF (HospitalName = 'Childrens Hospital') or (TestingLabName = 'Childrens Hospital') or (OriginatingLabName = 'Childrens Hospital')
THEN CHCFlag = 'YES';
Else CHCFlag = 'NO';
run;

data chco_y;
	  	set chco_yn;
		where CHCFlag='YES';run; *output=15011 obs, 42 var[2/8/22;*/

******************************************************************************************************************************************************
***************************************************************BEGIN**********************************************************************************;


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
/* v.SpecimenSource,*/ sx.Symptoms, sx.SymptomOnsetDate, sx.FeverOver100_4, sx.FeverChills, sx.AnyCough, sx.RunnyNose, sx.DifficultyBreathing, sx.ChestPain, sx.TasteSmell, 
sx.Headache, sx.SoreThroat, sx.Wheezing, sx.Apnea, sx.Cyanosis, /*sx.HypoxiaID,*/ sx.Diarrhea, sx.AbdoPain, sx.Vomiting, sx.Seizures, sx.AnyRash, sx.Conjunctivitis, 
sx.Fatigue, sx.OtherSymptomDesc, sx.SymptomResolutionDate, sx.OtherSymptoms,
 f.CommentSymptoms,f.LungDiseaseID, f.DiabetesID, f.HeartDiseaseID, f.HypertensionID, f.ChronicRenalDiseaseID,f.ChronicLiverDiseaseID, f.AutoImmuneConditionID,
f.BloodDisorderID, f.SevereObesityID, f.ExpoContConfRelChild, f.ExpoContConfRelOtherFamily, f.ExpoContConfRelSpousePartner, f.ExpoContConfRelParent, 
f.ExpoContSympSettingHousehold,
ft.CountryID, st.StateID, ev.OnsetDate
	
	from all21 h /*CHANGE THIS DATASET DEPENDIN ON ALL CO OR CHCO ONLY*************************/
    left join NewCEDRS.zDSI_ProfileRaces r on h.ProfileID = r.ProfileID
	left join NewCEDRS.SurveillanceFormCovid19 as f on h.EventID = f.EventID
	left join NewCEDRS.Events as ev on h.EventID = ev.EventID
	/*left join NewCEDRS.viewLabDetails v on e.EventID = v.EventID*/
	left join NewCEDRS.zDSI_Covid19Data c on h.EventID = c.EventID
	inner join NewCEDRS.SurveillanceFormBase b on h.eventID = b.eventID
	left join NewCEDRS.SurveillanceformSymptoms sx on b.FormBaseID = sx.FormBaseID
	left join NewCEDRS.ForeignTrips as ft on h.EventID = ft.EventID
    left join NewCEDRS.UnitedStateTrips as st on h.EventID = st.EventID

	group by h.EventID

;
	quit;

	proc contents data=NewCEDRS.SurveillanceformSymptoms; run;

	proc contents data=childrens; run;


	data all21_dedupmj;
set childrens;
by EventID;
if first.eventID;
run;  /*chco cases lt 21 in mar-jun 2020: 321 obs*/


proc export data=all21_dedupmj
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\chco fuzzy match\all21_dedupmj.CSV'	/*pause 2/8*********/	
      dbms=csv replace;    run;


	  
proc export data=all21_dedupmj
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\all21_dedupmj.XLS'		
      dbms=xls replace;    run;

 
/*Data Transforming: plus creating new var to match REdcap var*/

data ch_dataTransf /*(drop=Count)*/;
	set all21_dedupmj;
	length cdrs_source 8;
	cdrs_source=1;
	length immunumc10 8;
	immunumc10=ImmunocompromisedID;

	length lungumc1 8;/*copying lung disease into new var for umc___1 specific var*/
	lungumc1=LungDiseaseID;
	length liverumc2 8;/*copying liver into new var for umc___2 specific var*/
	liverumc2=ChronicLiverDiseaseID;
	length diabmel 8;/*copying diabetes into new var diab mel for diab mel specific var, all datamgt in one place and to not confuse SAS*/
	diabmel=DiabetesID;
	length diabumc3 8;/*copying same diabetes into new var diabumc for umc___3 specific var*/
	diabumc3=DiabetesID;

	length renalumc5 8;/*copying renal for umc5*/
	renalumc5=ChronicRenalDiseaseID;
	length bloodumc8 8;/*copying blood disorder for umc___8 specific var*/
	bloodumc8=BloodDisorderID;
	length pregumc14 $200;/*copying pregnancy for umc___14 specific var*/
	pregumc14=PregnantYesNO;
	length obesumc19 8; /*chronic renal into new var umc19*/
	obesumc19=SevereObesityID;

	/*length pcr_res2 $100; /* to delete responses that dont fit the format above*/
	/*if pcr_result= "Positive" then pcr_res2= "Positive";
		else if pcr_result= "Negative" then pcr_res2= "Negative";
		else pcr_result= " ";*/ *moved below;



 

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

 new_bdate = input(BirthDate, e8601da.); *found official sas informat for the way date  is displayed here. create in data mgt step so final var is used in rename step;
    format new_bdate MMDDYY10.;

	new_ddate = input(DeathDate, e8601da.); *found official sas informat for the way date  is displayed here. create in data mgt step so final var is used in rename step;
    format new_ddate MMDDYY10.;

	new_dtpcr =datepart(CollectionDate);/*input (put(date_pcr, DATETIME.), 10.); *numeric datetime to date;*/
   format new_dtpcr MMDDYY10.;
  
   new_sxdate =datepart(OnsetDate);/*input (put(date_pcr, DATETIME.), 10.); *numeric datetime to date;*/
   format new_sxdate MMDDYY10.;
   

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

	array family_contact{4} ExpoContConfRelChild ExpoContConfRelOtherFamily ExpoContConfRelSpousePartner ExpoContConfRelParent;
		do Count = 1 to 4;
			if family_contact{Count} = . Then fam_contact= . ;/*change back to "" if troubling*/
			else if family_contact{Count} = 1 Then fam_contact= 1 ; *Yes;
		    else if family_contact{Count} = 0 Then  fam_contact= 0 ; *No;
	end; *Need the correct format code for 0 and 1 to include;
		
	array school{2} ExpoContConfSettingShoolUniversi ExpoContConfSettingDaycare;
	do Count = 1 to 2;
		if school{Count} = 119 then sch_exp=119;
		else if school{Count}=120 then sch_exp=120;
	    Else if school{Count}= 121 then sch_exp=121;
	end;


	if TestType in ('PCR', 'RT-PCR', 'RT-PCR at CDC')
		then pcr_result = ResultText;
		else pcr_result = ' ';

length pcr_res2 $100; /* to delete responses that dont fit the format above*/
	if pcr_result= "Positive" then pcr_res2= "Positive";
		else if pcr_result= "Negative" then pcr_res2= "Negative";
		else pcr_result= " ";

	
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


length int 8;
	if CountryID = . then int=.;
	else int=CountryID;

length dom 8;
	if StateID = . then dom=.;
	else dom=StateID; 
	

	if EventID=541852 then delete;

*format DiabetesID	ChronicRenalDiseaseID	ChronicLiverDiseaseID	ChronicOtherID UnderlyingMedicalConditionID PsychologicalID DisabilityID 
		VapeCurrentID	VapeFormerID	SmokerCurrentID	SmokerFormerID ExpoSocialGatheringID ExpoVisitHealthcareAsPatientID	
		ExpoVisitHealthcareNotPatientID ImmunocompromisedID	TravelInternationalID	TravelDomesticID OccupationTypeID AutoImmuneConditionID	
		BloodDisorderID	CancerID 	HypertensionID	HeartDiseaseID	SevereObesityID	LungDiseaseID 
		immunocomp. /*int $trvlint. dom $trvldom.*/;


run;




/*create data set of childrens cases not alredy in CHOC dataset*/******remove 19 CHCO identified from this delete list;
/* data ch21_miss;
	  set ch_dataTransf;/*changed from ch21_2 to ch21_3*/
	/*  if MedicalRecordNumber in ('2009334', '2315989','1360847','1855981','1540195', '2065706', '2327154', '1282162','2013623','1920234', '2190636',
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




proc export data=ch21_miss
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\ch21_miss.XLS'		
      dbms=xls replace;    run;

proc export data=ch21_miss
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\ch21_miss.XLS'		
      dbms=xls replace;    run;*/


data all21_mj;
	set ch_dataTransf;
	drop state;
	run;
/*proc print data=ch_miss;run;*/

			
/*proc contents data=archive.n_chclt21_mj; run; *pre var renaming check;
***********non-chco x*****;*/



proc datasets library=work;
modify  all21_mj;
attrib _all_ label=' '; 
 
rename  cdrs_source=data_source___2 MedicalRecordNumber=mrn FirstName=fname LastName=lname new_bdate=dob Age=age AgeType=age_unit Gender=sex 
		Ethnicity=ethnic newrace=race
		compd_add=address City=city StateCode=state County=county ZipCode=zip ImmunocompromisedID=immunocomp UnderlyingMedicalConditionID=umc_yn
		/*LungDiseaseID=pulm_dx___7*/ lungumc1=umc___1 /*ChronicLiverDiseaseID=gi_dx___5*/ liverumc2=umc___2 diabumc3=umc___3  
		cardio=umc___4 
		ChronicRenalDiseaseID=nephro_dx___2 renalumc5=umc___5 
		bloodumc8=umc___8 /*other=umc___9*/ pregumc14=umc___14 obesumc19=umc___19 immunumc10=umc___10  /*UnderlyingMedicalConditionDesc=umc_other*/ diabmel=endo_dx___1 /*adding vars and also formatting*/
		HypertensionID=cards_dx___4
		PsychologicalID=psych_dx PsychologicalDesc=psych_other PregnantYesNo=gyn_dx___1 SevereObesityID=weight_dx___1 vsmoke=personal_smoking___2 /*int=covid_rf___1
		dom=covid_rf___2 created in next step*/ fam_contact=covid_rf___3 ExpoContSympSettingHousehold=covid_rf___9 int=int_travel dom=dom_travel
		sch_exp=school_daycare new_dtpcr=date_pcr pcr_res2=covid_pcr_result testlab=pcr_site
        Symptoms=sx_asx new_sxdate=sx_onset_date FeverOver100_4=sx_onset___1 FeverChills=sx_onset___2 AnyCough=sx_onset___3 
		RunnyNose=sx_onset___4 DifficultyBreathing=sx_onset___5
		ChestPain=sx_onset___6 TasteSmell=sx_onset___8 Headache=sx_onset___9 SoreThroat=sx_onset___12 Wheezing=sx_onset___13 Apnea=sx_onset___14
		Cyanosis=sx_onset___15 /*HypoxiaID=sx_onset___16*/ Diarrhea=sx_onset___17 AbdoPain=sx_onset___18 Vomiting=sx_onset___19 
		Seizures=sx_onset___20
		AnyRash=sx_onset___21 Conjunctivitis=sx_onset___22 Fatigue=sx_onset___26 OtherSymptoms=sx_onset___25 /*OtherSymptomDesc=sx_onset_other*/ 
		SymptomResolutionDate=date_sx_resolve /*CommentSymptoms=sx_comment*/ HospitalizedYesNO=admit AdmissionDate=admit_date ICU=icu  died=death
		new_ddate=date_death DischargeDate=dis_date /*icudate*/
		 /*any_smoke=personal_smoking any_vape=smoke_other*/
		/*ExpoContConfRelContactOnly=fam_contact*/; 
 
		
contents data=all21_mj;
run;
	quit;



	/*tying in logic skip questions, add 3rd level of detail for the 9umcs and dx [weight] etc in transform and rename etc steps*/

data all21_mj_logic;
	set all21_mj;

	length covid_rf___1 8;
		if int_travel ne .
			then covid_rf___1=1;
			else covid_rf___1=0;
	
	length covid_rf___2 8;
		if dom_travel ne .
			then covid_rf___2=1;
			else covid_rf___2=0;
	/*if endo_dx___1=121 then umc___1=121;
		else umc___3=umc___1;
	if endo_dx___1=121 then umc___2=121;
		else umc___3=umc___2;
	if endo_dx___1=121 then umc___3=121;
		else umc___3=umc___3;
	if endo_dx___1=121 then umc___4=121;
		else umc___3=umc___4;
		if endo_dx___1=121 then umc___5=121;
		else umc___3=umc___5;
		if endo_dx___1=121 then umc___8=121;
		else umc___3=umc___8;
		if endo_dx___1=121 then umc___9=121;
		else umc___3=umc___9;
		if endo_dx___1=121 then umc___10=121;
		else umc___3=umc___10;
		if endo_dx___1=121 then umc___19=121;
		else umc___3=umc___19;
		if endo_dx___1=121 then umc___other=121;
		else umc___3=umc___other;*/

	if (umc___1=121 OR umc___2=121 OR umc___3=121 OR umc___4=121 OR umc___5=121 OR umc___8=121 OR umc___14="Yes" OR umc___19=121 OR umc___10=121 
	/*OR umc_other ne " "= could be nonsense text*/)
	then umc_yn=121;
	else umc_yn=umc_yn;


	if (sx_onset___1=4015 OR sx_onset___2=121 OR sx_onset___3=121 OR sx_onset___4=121 OR sx_onset___5=121 OR sx_onset___6=121 OR sx_onset___8=121
	OR sx_onset___9=121 OR sx_onset___12=121 OR sx_onset___13=121 OR sx_onset___14=121 OR sx_onset___15=121 OR sx_onset___17=121 OR sx_onset___18=121 
	OR sx_onset___19=121 OR sx_onset___20=121 OR sx_onset___21=121 OR sx_onset___22=121 OR sx_onset___26=121 OR sx_onset___25=121 OR sx_onset_date ne .)
	then sx_asx=121;
	else sx_asx=sx_asx; 

	/*if sx_onset_date ne . then sx_asx=121;
		else sx_asx=sx_asx;*/
	
		run; 



proc export data=all21_mj
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\all21_mj.XLS'		
      dbms=xls replace;    run;



proc export data=all21_mj_logic
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\all21_mj_logic.XLS'		
      dbms=xls replace;    run;

	  /*compare to prev dataset to see if logic change occurred 2/22/22*/

	***skipping these checks***;
/*proc export data=ch21_msmj_apr2b
               outfile='J:\Programs\Other Pathogens or Responses\2019-nCoV\Pediatric COVID-19 Registry\CEDRS Data\ch21_msmj_apr2b.XLS'		
      		dbms=xls replace;    run;
	proc print data=all21;run;

proc contents data=ccc.n_chclt21_mj; run;*post var renaming check;
proc contents data=archive.reord_ch_mj; run;



/*****redcap counterpart var from last step****start from here 3/15/22

data_source___2 mrn fname lname dob age age_unit sex 
		ethnic race
		address city state county zip immunocomp umc_yn
		pulm_dx___7 umc___1 gi_dx___5 umc___2 umc___3  
		umc___4 
		nephro_dx___2 umc___5 
		umc___8 umc___10 umc___19 endo_dx___1 
	cards_dx___4
		psych_dx psych_other gyn_dx weight_dx___1 personal_smoking covid_rf___1
		covid_rf___2 covid_rf___3 covid_rf___9 int_travel dom_travel
		school_daycare date_pcr covid_pcr_result pcr_site
        sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 
		sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15  sx_onset___17 sx_onset___18 sx_onset___19 
		sx_onset___20
		sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25  
		date_sx_resolve admit admit_date icu  death
		date_death dis_date */




/*Reordering variables;*/

data archive.retain_all21_mj;
	
	retain EventID /*record_id redcap_repeat_instrument redcap_repeat_instance iv*/ data_source___2 mrn fname lname dob age age_unit sex ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___14 umc___19 umc___10  
		/*pulm_dx___7 gi_dx___5 (CHCO delete)*/ endo_dx___1 cards_dx___4 nephro_dx___2 /*psych_dx psych_other*/ gyn_dx___1 weight_dx___1 personal_smoking___2 covid_rf___1 covid_rf___2 covid_rf___3 covid_rf___9 int_travel dom_travel
		school_daycare date_pcr covid_pcr_result pcr_site sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 /*sx_onset_other */
		date_sx_resolve /*sx_comment*/ admit admit_date icu death date_death dis_date 
		/*fam_contact*/;

		set all21_mj_logic;
	
	/*if  redcap_repeat_instrument="No" then delete;
		IF cards_dx___4=1 Then umc___4=1; else if cardio=1 then umc___4=1;
	IF endo_dx___1=1  THEN umc___3=1; 
	IF immunocomp=1 THEN umc___10=1;
	IF weight_dx___1=1 THEN umc___19=1;
	If umc___1=1 then umc_yn=1;
  	else if umc___2=1 then umc_yn=1; else if umc___3=1 then umc_yn=1; else if umc___4=1 then umc_yn=1; else if umc___5=1
	then umc_yn=1; else if umc___8=1 then umc_yn=1; else if umc___9=1 then umc_yn=1; else if umc___10=1then umc_yn=1;
	else if umc_other=1 then umc_yn=1; **
 
	 /*record_id =_n_;
	 redcap_repeat_instrument ;
	redcap_repeat_instance;*/
	run;




	/*Subsetting to RedCap vars alone*/



data archive.redcap_all21_mjb;
	set archive.retain_all21_mj;
	Keep EventID /*record_id redcap_repeat_instrument redcap_repeat_instance iv*/ data_source___2 mrn fname lname dob age age_unit sex ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___14 umc___19 umc___10  
		/*pulm_dx___7 gi_dx___5 (CHCO delete)*/ endo_dx___1 cards_dx___4 nephro_dx___2 /*psych_dx psych_other*/ gyn_dx___1 weight_dx___1 personal_smoking___2 covid_rf___1 covid_rf___2 covid_rf___3 covid_rf___9 int_travel dom_travel
		school_daycare date_pcr covid_pcr_result pcr_site sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 /*sx_onset_other */
		date_sx_resolve /*sx_comment*/ admit admit_date icu death date_death dis_date 
		/*fam_contact*/;
	
	
	run;

/*insert format*/

	
proc export data=archive.redcap_all21_mjb
               outfile='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\redcap_all21_mjb.csv'		
      dbms=xls replace;    run;


	data archive.format_all21_mar_sep20;
	set archive.redcap_all21_mjb;
	Keep EventID /*record_id redcap_repeat_instrument redcap_repeat_instance iv*/ data_source___2 mrn fname lname dob /*age age_unit*/ sex ethnic 
		race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___14 umc___19 umc___10  
		/*pulm_dx___7 gi_dx___5 (CHCO delete)*/ endo_dx___1 cards_dx___4 nephro_dx___2 /*psych_other*/ gyn_dx___1 weight_dx___1 
		personal_smoking___2 
		covid_rf___1 covid_rf___2 covid_rf___3 covid_rf___9 int_travel dom_travel
		school_daycare /*date_pcr covid_pcr_result pcr_site (test table data)*/ sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 
		/*sx_onset_other */
		date_sx_resolve /*sx_comment*/ /*admit admit_date icu death date_death dis_date (hospital table data)*/
		/*fam_contact*/;



	  format /*age_unit $age_unit.*/ ethnic $ethnic. sex $sex. race $race. umc_yn ynu. umc___4 cards_dx___4 check_uncheck.
		immunocomp school_daycare sx_asx umc_ten.   admit $text_ynu.  umc___14  gyn_dx___1  $text_check_uncheck. 
		umc___1  umc___2 umc___3 umc___5 umc___8 umc___19 umc___10 endo_dx___1  nephro_dx___2  
		weight_dx___1 personal_smoking___2 covid_rf___1 covid_rf___2 covid_rf___3 covid_rf___9 sx_onset___2 sx_onset___3 sx_onset___4 
		sx_onset___5	sx_onset___6	sx_onset___8	sx_onset___9	sx_onset___12	sx_onset___13	sx_onset___14 sx_onset___15 sx_onset___17	
		sx_onset___18	sx_onset___19	sx_onset___20	sx_onset___21	sx_onset___22	sx_onset___26 sx_onset___25 check_uncheck. 
		/* date_pcr MMDDYY10.  pcr_site $pcr_site. covid_pcr_result $covid_pcr_result.*/
 		/*icu $icu. death $death.  admit $admit.*/ sx_onset___1 sx_on_one. covid_pcr_result $covid_pcr_result. pcr_site $pcr_site. 
		icu $icu. death $death. int_travel trvlint.  dom_travel trvldom.   
		/*dob date_pcr sx_onset_date date_sx_resolve /*admit_date*/ /*death_date /*dis_date*/ /*mmddyy10.*/ 
		/*redcap_repeat_instrument $redcap_repeat_instrument.; iv*/;

		run;


		ods excel file='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\chco fuzzy match\format_all21_mar_sep20.xls'	; /*older versions of SAS may replace this line with: ods tagsets.excelxp file=""*/
			proc report data=archive.format_all21_mar_sep20;
				columns _all_;
			run;
		ods excel close;



		/******************************END****************************/



		ods tagsets.excelxp file='C:\Users\iaoyegun\Documents\CCC non-matches\CEDRS post jz\format_ch_mj.xlsx'	; /*older versions of SAS may replace this line with: ods tagsets.excelxp file=""*/
			proc report data=archive.format_ch_mj;
				columns _all_;
			run;
		ods excel close;














		/************************re-ordering after 3 table merge, ADD pcr_source, admit_hospital, and both repeating instruments in correct locations****************************/



data archive.retain_all21_mj;
	
	retain EventID /*record_id redcap_repeat_instrument redcap_repeat_instance iv*/ data_source___2 mrn fname lname dob age age_unit sex ethnic race
		address city state county zip immunocomp umc_yn umc___1 umc___2 umc___3 umc___4 umc___5 umc___8 umc___14 umc___19 umc___10  
		/*pulm_dx___7 gi_dx___5 (CHCO delete)*/ endo_dx___1 cards_dx___4 nephro_dx___2 /*psych_dx psych_other*/ gyn_dx___1 weight_dx___1 personal_smoking___2 covid_rf___1 covid_rf___2 covid_rf___3 covid_rf___9 int_travel dom_travel
		school_daycare date_pcr covid_pcr_result pcr_site sx_asx sx_onset_date sx_onset___1 sx_onset___2 sx_onset___3 sx_onset___4 sx_onset___5
		sx_onset___6 sx_onset___8 sx_onset___9 sx_onset___12 sx_onset___13 sx_onset___14
		sx_onset___15 sx_onset___17 sx_onset___18 sx_onset___19 sx_onset___20 sx_onset___21 sx_onset___22 sx_onset___26 sx_onset___25 /*sx_onset_other */
		date_sx_resolve /*sx_comment*/ admit admit_date icu death date_death dis_date 
		/*fam_contact*/;

		set all21_mj_logic;
	
	/*if  redcap_repeat_instrument="No" then delete;
		IF cards_dx___4=1 Then umc___4=1; else if cardio=1 then umc___4=1;
	IF endo_dx___1=1  THEN umc___3=1; 
	IF immunocomp=1 THEN umc___10=1;
	IF weight_dx___1=1 THEN umc___19=1;
	If umc___1=1 then umc_yn=1;
  	else if umc___2=1 then umc_yn=1; else if umc___3=1 then umc_yn=1; else if umc___4=1 then umc_yn=1; else if umc___5=1
	then umc_yn=1; else if umc___8=1 then umc_yn=1; else if umc___9=1 then umc_yn=1; else if umc___10=1then umc_yn=1;
	else if umc_other=1 then umc_yn=1; **
 
	 /*record_id =_n_;
	 redcap_repeat_instrument ;
	redcap_repeat_instance;*/
	run;













		/*identify test variables from christy's set, and data dictionary*/


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
