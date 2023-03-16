LIBNAME CHIS "/home/u59641456/EPI207/CHIS2007";
/********CODEBOOK AND DATA DICTIONARY*********/
/*Creating codebook using proc freq*/	
PROC FREQ DATA=CHIS.cleandata;
TABLE RACEDOF AHEDUC DSTRS30 DSTRS12 AD47 PROXY
AGE RACE EDUC POVLL WRKST SPD STD;
format age age. race race. educ educ. povll povll. wrkst wrkst. spd spd. std std.;
Label 
	  RACEDOF  = 'FORMER DOF RACE - ETHNICITY (old CHIS variable)'
	  AHEDUC   = 'EDUCATIONAL ATTAINMENT (old CHIS variable)'
	  DSTRS30  = 'EXPERIENCED SERIOUS PSYCHOLOGICAL DISTRESS IN THE PAST MONTH (old CHIS variable)'
	  DSTRS12  = 'EXPERIENCED SERIOUS PSYCHOLOGICAL DISTRESS IN PAST YEAR (old CHIS variable)'
	  AD47	   = 'TESTED FOR STD IN PAST 12 MOS (old CHIS variable)'
	  PROXY	   = 'A PROXY INTERVIEW'
	  AGE      = 'Age'
      RACE     = 'Race/ethnicity'
      EDUC     = 'Education status'
	  POVLL    = 'Poverty level'
	  WRKST    = 'Employment status'
	  SPD      = 'Serious Psychological Distress (SPD) status'
	  STD      = 'STD Testing';
Where Sex = 2;
RUN;
/*creating a data dictionary with all covariates*/
DATA CHIS.AdultDictionarynew;
SET CHIS.cleandata (keep =
						   RACEDOF AHEDUC DSTRS30 DSTRS12 AD47 PROXY rakedw0 rakedw80
						   AGE RACE SEX EDUC POVLL WRKST SPD STD);				   
Run;

Proc datasets library=CHIS;
Modify AdultDictionarynew;

Label 
	  rakedw0			= 'CHIS2007 RAKED WEIGHT - FULL SAMPLE'
	  rakedw80          = 'CHIS2007 RAKED WEIGHT - REPLICATE 80'
	  RACEDOF  			= 'FORMER DOF RACE - ETHNICITY (old CHIS variable)'
	  AHEDUC   			= 'EDUCATIONAL ATTAINMENT (old CHIS variable)'
	  DSTRS30       	= 'EXPERIENCED SERIOUS PSYCHOLOGICAL DISTRESS IN THE PAST MONTH (old CHIS variable)'
	  DSTRS12  			= 'EXPERIENCED SERIOUS PSYCHOLOGICAL DISTRESS IN PAST YEAR (old CHIS variable)'
	  AD47				= 'TESTED FOR STD IN PAST 12 MOS (old CHIS variable)'
	  PROXY	   			= 'A PROXY INTERVIEW'
	  AGE      			= 'Age (SRAGE_P renamed)'
      RACE     			= 'Race/ethnicity'
      SEX      			= 'Gender (SRSEX renamed)'
      EDUC     			= 'Education status'
	  POVLL    			= 'Poverty level (POVGWD_P renamed)'
	  WRKST    			= 'Employment status'
	  SPD      			= 'Serious Psychological Distress (SPD) status'
	  STD      			= 'STD Testing';

xattr set var
RAKEDW0		   (ValidValues = "0-High")
RAKEDW80       (ValidValues = "0-High")
RACEDOF  	   (ValidValues = "1 = Latino; 2 = Non-Latino PI; 3 = Non-Latino American Indian/Alaskan; 
							   4 = Non-Latino Asian; 5 = Non-Latino African American;
							   6 = Non-Latino White; 7 = Non-Latino Other, one race; 8 = Non-Latino, two+ races")
AHEDUC   	   (ValidValues = "1 = Grade 1-8; 2 = Grade 9-11; 3 = Grade12/H.S. DIPLOMA; 
							   4 = SOME COLLEGE; 5 = VOCATIONAL SCHOOL; 6 = AA OR AS DEGREE; 
							   7 = BA OR BS DEGREE; 8 = SOME GRAD. SCHOOL; 9 = MA OR MS DEGREE;
							   10 = PH.D. OR EQUIVALENT; 91 = NO FORMAL EDUCATION")
DSTRS30        (ValidValues = "-2 = proxy skipped; 1 = yes; 2 = no")
DSTRS12  	   (ValidValues = "-2 = proxy skipped; 1 = yes; 2 = no")	
AGE            (ValidValues = "1 = 18-25; 2 = 26-34; 3 = 35-49; 4 = 50+")
AD47		   (ValidValues = "1 = Yes; 2 = No")
PROXY		   (ValidValues = "1 = Yes; 2= No")
RACE           (ValidValues = "1 = Hispanic; 2 = Non-Hispanic White; 3 = Non-Hispanic Black; 4 = Non-Hispanic  American Indian/Alaskan; 5 = Non-Hispanic Asian; 6 =Non-Hispanic Other")
SEX            (ValidValues = "1 = Male; 2 = Female")
EDUC           (ValidValues = "1 = <High-school degree; 2 = High-school graduate; 3 = Some college; 4 = College or more")
POVLL          (ValidValues = "1 = <100% FPL; 2 = 100-199% FPL; 3 = 200-399% FPL; 4 = >=400% FPL")
WRKST          (ValidValues = "1 = Full-time employment; 2 = Part-time employment; 3 = Employed, not at work; 4 = Unemployed , looking for work; 5 = Unemployed, not looking for work")
SPD            (ValidValues = "1 = No SPD; 2 = SPD")
STD			   (ValidValues = "1 = No; 2 = Yes");
Run;
quit;

ods output variables=varlist;
ods output ExtendedAttributesVar=varlist2;

Proc contents data=CHIS.AdultDictionarynew;
Run;
Proc sort data=varlist2; 
By attributevariable; 
run;
Data varlist1;
Set varlist (rename = (Variable=attributevariable));
Run;
Proc sort data=varlist1; 
by attributevariable; 
run;
Data Varlist3;
Merge  varlist1 varlist2;
By attributevariable;
Run;
Data CHIS.FinalDataDictionaryNEW;
Set Varlist3;
Keep  Attributevariable Type Len Label AttributeCharValue;
Rename Attributevariable=Variable;
Rename Len=Length;
Rename AttributeCharValue=ValidValues;
Run;
Proc print data=CHIS.FinalDataDictionaryNEW;
Run;
