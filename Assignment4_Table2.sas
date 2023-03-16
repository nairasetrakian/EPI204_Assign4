LIBNAME CHIS "/home/u59641456/EPI207/CHIS2007";
/********TABLE 2*********/
/*descriptive statistics to obtain the distribution of STD testing by SPD status among female adults*/
PROC SURVEYFREQ DATA =chis.cleandata VARMETHOD=JACKKNIFE; 
WEIGHT rakedw0;
REPWEIGHT rakedw1-rakedw80/JKCOEFS=1;
TABLE STD STD*SPD/col CL;
WHERE SEX=2; /*restricting to only females*/
RUN;

/*Multivariate logistic regression modeling the effect of SPD on STD testing among female adults, controlling for age, race, education, poverty level, and employment status*/
PROC SURVEYLOGISTIC DATA =chis.cleandata VARMETHOD=JACKKNIFE;
WEIGHT rakedw0;
REPWEIGHT rakedw1-rakedw80/JKCOEFS=1;
CLASS RACE (REF="HISPANIC") AGE (REF="18-25")EDUC (REF="< HIGH-SCHOOL DEGREE") 
POVLL (REF="<100% FPL") WRKST (REF="FULL-TIME EMPLOYMENT") SPD (REF="NO SPD")/PARAM=REF;
MODEL STD = SPD AGE RACE EDUC POVLL WRKST;
where SEX = 2;
FORMAT RACE RACE. AGE AGE. EDUC EDUC. POVLL POVLL. WRKST WRKST. SPD SPD. STD STD.;
RUN;
