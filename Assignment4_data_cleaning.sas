LIBNAME CHIS "/home/u59641456/EPI207/CHIS2007";

/********DATA CLEANING*********/
/*formatting and defining valid values of covariates*/
PROC FORMAT;
VALUE AGE /*Used SRAGE_P to create age categories*/
	  18 - 25 = "18-25" 
	  26 - 34 = "26-34"
	  35 - 49 = "35-49"
	  50 - HIGH = "50+"
;
VALUE SEX /*SRSEX renamed*/
      1 = "MALE"
      2 = "FEMALE"
;
VALUE RACE /*Used RACEDOF to create new Race categories*/
      1 = "HISPANIC"
      2 = "NON-HISPANIC WHITE"
      3 = "NON-HISPANIC BLACK"
      4 = "NON-HISPANIC AMERICAN INDIAN/ALASKAN"
      5 = "NON-HISPANIC ASIAN"
      6 = "NON-HISPANIC OTHER"
;
VALUE EDUC /*Used AHEDUC to create new Race categories*/
	  1 = "< HIGH-SCHOOL DEGREE"
	  2 = "HIGH-SCHOOL GRADUATE"
	  3 = "SOME COLLEGE"
	  4 = "COLLEGE OR MORE"
;
VALUE POVLL /*used POVGWD_P to create poverty thresholds*/
      LOW - 0.99 = "<100% FPL"
      1 - 1.99 = "100-199% FPL"
      2 - 3.99 = "200-399% FPL"
      4 - HIGH = ">=400% FPL"
;
VALUE WRKST
       1 = "FULL-TIME EMPLOYMENT"
       2 = "PART-TIME EMPLOYMENT"
       3 = "EMPLOYED, NOT AT WORK"
       4 = "UNEMPLOYED, LOOKING FOR WORK"
       5 = "UNEMPLOYED, NOT LOOKING FOR WORK"
;
VALUE SPD /*Created using DSTRS30 and DSTRS12*/
	  1 = "NO SPD"
	  2 = "SPD"
;
VALUE STD /*Created using AD47*/
	  1 = "No"
	  2 = "Yes"
;

/*Deleting irrelevant variables from CHIS dataset and keeping relevant variables (Keep: Age, Sex, Race, Education, Poverty level, Employmenet Status, 
Psychological Distress in the last 30 days and 12 months, Proxy interview, STDs)*/
/*renaming variables*/
DATA CHIS.cleandata;
SET CHIS.adult07 (keep = SRAGE_P SRSEX RACEDOF AHEDUC POVGWD_P  WRKST 
					   DSTRS30 DSTRS12 PROXY AD47
					   rakedw0-rakedw80
			    rename = (SRAGE_P=AGE SRSEX=SEX POVGWD_P=POVLL));
/*delete if proxy interview response is yes*/
IF PROXY = 2 THEN PROXY = 2;
ELSE DELETE;

/*recoding race variable from CHIS (RACEDOF) into 6 categories (1=Hispanic, 2=Non-hispanic white,
3=non-hispanic black, 4=non-hispanic american indian/alaskan, 5=non-hispanic asian, 
6=non-hispanic other)*/
RACE=.;
IF RACEDOF=1 THEN RACE=1;
IF RACEDOF=6 THEN RACE=2;
IF RACEDOF=5 THEN RACE=3;
IF RACEDOF=3 THEN RACE=4;
IF RACEDOF=4 THEN RACE=5;
IF RACEDOF=2 THEN RACE=6;
IF RACEDOF=7 THEN RACE=6;
IF RACEDOF=8 THEN RACE=6;

/*Recoding education variable from CHIS (AHEDUC) into 5 categories (1=full-time employment, 2=part-time employment
3=employed, not at work, 4=unemployed,looking for work, 5=unemployed, not looking for work)*/
EDUC=.;
IF AHEDUC=1 THEN EDUC=1;
IF AHEDUC=2 THEN EDUC=1;
IF AHEDUC=91 THEN EDUC=1;
IF AHEDUC=3 THEN EDUC=2;
IF AHEDUC=4 THEN EDUC=3;
IF AHEDUC=5 THEN EDUC=3;
IF AHEDUC=6 THEN EDUC=3;
IF AHEDUC=7 THEN EDUC=4;
IF AHEDUC=8 THEN EDUC=4;
IF AHEDUC=9 THEN EDUC=4;
IF AHEDUC=10 THEN EDUC=4;

/*Recoding Serious Psychological Distress variable (using DSTRS30 and DSTRS12) to SPD (Exposure)*/
If DSTRS30<1 then delete; /*Delete proxy interviews*/
If DSTRS12<1 then delete;
SPD=.;
IF DSTRS30=1 THEN SPD=2; /*SPD if DSTRS30 or DSTRS12 is answered Yes*/
IF DSTRS12=1 THEN SPD=2;       				 
If DSTRS12=2 and DSTRS30=2 then SPD=1; /*NO SPD if DSTRS12 and DSTRS30 answered No*/
IF SPD=. THEN SPD=1; /*if SPD missing, then NO SPD*/

/*Recoding STD testing variable (Outcome)*/
IF ad47 <1 THEN DELETE; /*delete inapplicable or proxy skipped responses*/

STD=.; /*Recode AD47 as STD Testing*/
If AD47=1 THEN STD=2;
IF AD47=2 then STD=1;

FORMAT 
AGE AGE.
SEX SEX.
RACE RACE.
EDUC EDUC. 
POVLL POVLL.  
WRKST WRKST.
SPD SPD.
STD STD.
;  
RUN;
