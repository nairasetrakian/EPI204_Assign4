LIBNAME CHIS "/home/u59641456/EPI207/CHIS2007";
/********TABLE 1*********/
/*Descriptive statistics to obtain the distribution of SPD by other covariates in the model (age, race, education, poverty, employment status, STD)*/
PROC SURVEYFREQ DATA =CHIS.cleandata VARMETHOD=JACKKNIFE; 
WEIGHT rakedw0; 
REPWEIGHT rakedw1-rakedw80/JKCOEFS=1; /*CHIS sampling weights*/
TABLE SPD AGE*SPD RACE*SPD EDUC*SPD POVLL*SPD 
	  WRKST*SPD STD*SPD /row;
Where sex=2; /*restricting to only females*/
RUN;
