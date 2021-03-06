/*Country Female Unemployment Rate Data*/
/*======================================================*/

options validvarname=v7;

%let path=/home/spradhan3/my_content/Final_Project_2016/unemp_female;
libname datafe xlsx "&path/unemp_female_data.xlsx";
/* Looking at the top five GDP countries*/
data unemp_fe.unemp_female;/*Unemployment, total (% of total labor force)*/
	set datafe."Data"n;
	where Country_Code in ('CHN','DEU','GBR','JPN','USA');
	drop _1960-_1990 _2015 _2016;/*time frame is 1991-2014*/
	run;

proc transpose data=unemp_fe.unemp_female
	out=unemp_fe.unemp_female_transpose
	(rename=(col1=CHN col2=DEU col3=GBR col4=JPN col5=USA));
	run;

data unemp_fe.unemp_female_final;
	set unemp_fe.unemp_female_transpose;
	year=input(_Label_,year.);
	chn=chn/100;
	gbr=gbr/100;
	deu=deu/100;
	jpn=jpn/100;
	usa=usa/100;
	Average=(chn+deu+gbr+jpn)/4.0;
	maximum=max(chn,deu,gbr,jpn);
	minimum=min(chn,deu,gbr,jpn);
	format  chn percent8.2 deu percent8.2 gbr percent8.2 jpn percent8.2 usa percent8.2 average percent8.2 maximum percent8.2 minimum percent8.2;
	label 	chn="China"
			deu="Germany"
			gbr="United Kingdom"
			jpn="Japan"
			usa="United States"
			year="Year"
			average ="Group Average"
			maximum="Group Maximum"
			minimum="Group Minimum";
	drop _name_ _Label_;
	run;

proc contents data=unemp_fe.unemp_female_final;
run;

proc print data=unemp_fe.unemp_female_final noobs label;
var year usa average maximum minimum;
title "Female Unemployment Rate in the US and the Group Average, Max. and Min";
run;
title;
	
proc means data=unemp_fe.unemp_female_final;
var usa average maximum minimum;
title "Comparing Center and Spread of Female Unemployment Rate in the US and the Group Average, Max. and Min";
run;
title;

proc univariate data=unemp_fe.unemp_female_final;
var usa average maximum minimum;
title "Exploring Female Unemployment Data";
run;
title;




axis1 order=(1990 to 2015 by 5) label=("Year") offset=(2,2) major=(height=2) minor=(height=1)
      width=3 ;
axis2 order=(.04 to .09 by .01) label=("Unemp. Rate") offset=(0,0) major=(height=2) minor=(height=1)width=5;
symbol1 color=blue interpol=join value=dot height=1;
symbol2 value=dot color=red interpol=join height=1;
legend1 label=none
        shape=symbol(5,1)
        position=(top center inside)
        mode=share;
title "Comparing Yearly Female Unemployment Rate in USA and Group Average from 1991 to 2014";
proc gplot data= unemp_fe.unemp_female_final;
	plot usa*year average*year / overlay legend=legend1
	 vref=.01 to .10 by .01 lvref=2
	 haxis=axis1 vaxis=axis2
	 hminor=4;
	run;quit;title;

axis1  order=(1990 to 2015 by  5)  label=("Year") offset=(2,2) major=(height=2) minor=(height=1)
      width=3 ;
axis2 order=(.01 to .12 by .01) label=("Unemp. Rate") offset=(0,0) major=(height=2) minor=(height=1)width=3;
symbol1 color=blue interpol=join value=dot height=1;
symbol2 value=dot color=red interpol=join height=1;
symbol3 value=dot color=blueviolet interpol=join height=1;
legend1 label=none
        shape=symbol(5,1)
        position=(top center inside)
        mode=share;
title "Comparing Yearly Female Unemployment Rate in USA and Group Max. and Min. from 1991 to 2014";
proc gplot data= unemp_fe.unemp_female_final;
	plot usa*year maximum*year minimum*year / overlay legend=legend1
	 vref=.01 to .12 by .01  lvref=2
	 haxis=axis1 vaxis=axis2
	 hminor= 5;
	run;quit;title;