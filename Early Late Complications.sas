PROC IMPORT OUT=comptime DATAFILE="H:\Active Clients\Priti, Parikh\Early Late Complications.xlsx"
            DBMS=XLSX REPLACE;
		    GETNAMES=YES;	
			SHEET="Sheet1";
run;

proc print data=comptime (obs=5);
run;

* check distribution of observations in cells;
proc freq data=comptime;
table Surgery*Complication / nocol nopercent;
run;

* run the ordinal logistic regression model;
proc logistic data=comptime descending;
title "Ordinal Logisitc Regression";
class Surgery (ref="Sleeve");
model Complication = Surgery;
run;

* how you would run a multinomial logistic regression if the proportional odds assumption had been violated;
proc logistic data=comptime descending;
title "Ordinal Logisitc Regression";
class Surgery (ref="Sleeve");
model Complication = Surgery / link=glogit;
run;


* how you would force a series of binary logistic regressions (not recommended, here for purposes of illustration);
proc logistic data=comptime descending;
where Complication=0 or Complication=1;
title "Binary Logisitc Regression";
title2 "None vs Early";
class Surgery (ref="Sleeve");
model Complication = Surgery;
run;

proc logistic data=comptime descending;
where Complication=0 or Complication=2;
title2 "None vs Late";
class Surgery (ref="Sleeve");
model Complication = Surgery;
run;

proc logistic data=comptime descending;
where Complication=1 or Complication=2;
title2 "Early vs Late";
class Surgery (ref="Sleeve");
model Complication = Surgery;
run;

