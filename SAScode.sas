

options symbolgen mprint;
%macro input80to94(year,lastob); /*1980-1994 & 1997*/

infile "C:\Users\lb3558\Desktop\Turtle\D&year..csv" firstobs=2 obs=&lastob
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$20. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        ;

         time = input(time1, time11.);
         gps_lat1 = input(gps_lat, 10.); 
         gps_long1 = input(gps_long, 10.);
         hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),&year);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),&year);  
         numhatchsucc= scan(hatchsucc1,1,'%');
         hatchsucc = input(numhatchsucc, 8.2)/100; 
         numemergencesucc= scan(emergencesucc1,1,'%');
         emergencesucc = input(numemergencesucc, 8.2)/100;

         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

         final_lat = gps_lat1;
         final_long = gps_long1;
         final_access=location;

         if treatment1 in ('0','no','No','') then treatment = 'N';
         else treatment='Y';
              
%mend;

%macro DropAttrib(); /*add drop and attribute statement last*/

         if distVeg eq . then distVeg=0;
         if distHT eq . then distHT=0;
         if disVeg2 eq . then disVeg2=0;
         if disHT2 eq . then disHT2=0;

         if cnt eq . then cnt=0;
      	if cnn eq . then cnn= 0;
      	if cw eq . then cw = 0;
      	if snt eq . then snt = 0;
      	if snn eq . then snn = 0;
      	if sw eq . then sw = 0; 
      	if biopsy eq . then biopsy='N';
      	if incubation eq . then incubation=0;
      	if Rel_Eggs eq . then Rel_Eggs=0;
      	if Eggs_Taken eq . then Eggs_Taken=0;
      	if Hatched eq . then Hatched=0;
      	if Unhatched eq . then Unhatched=0;
      	if Live eq . then Live=0;
      	if Dead eq . then Dead=0;
      	if Pipped eq . then Pipped=0;
      	if hatchsucc eq . then hatchsucc = 0; 
      	if emergencesucc eq . then emergencesucc = 0; 

array chars {*} _character_;
   do _n_ = 1 to dim(chars);
   chars{_n_} = strip(chars{_n_});
   end;

   total_eggs = Hatched + Unhatched + Eggs_Taken + Pipped;
   emergencesucc = (Hatched-Live-Dead)/(Hatched+Unhatched+Pipped+eggs_taken);
   hatchsucc = Hatched / (Hatched+Unhatched+Pipped+ eggs_taken) ;
   if emergencesucc eq . then emergencesucc = 0;
   if hatchsucc eq . then hatchsucc = 0; 
   
   
 drop 
         time1 date1 gps_lat gps_long gps_lat1 gps_long1
         hatchdate1 hatchsucc1 emergencesucc1 
         numemergencesucc numhatchsucc treatment1 location ; 

attrib   
        	Nest label='Nest' format=3.
      	date label='Date' format=date9. 
      	time label='Time' format= timeampm11.
      	final_access label='Final Access' length=$4. 
      	orig_lat label='Original Lat' format=10.8
     	   orig_long label='Original Long' format=10.8
         final_lat label='Final Lat' format=10.8
     	   final_long label='Final Long' format=10.8
         reloc_lat label='Relocated Lat' format=10.8
     	   reloc_long label='Relocated Long' format=10.8
      	treatment label='Treatment' length=$2.
      	observed label='Observed' length=$1.
      	species label='Species' length=$4.
      	PIT label='Pit Tag' length=$25.
      	AE1 label='Pit Applied or Existing' length=$4.
      	LFF label='Left Flipper Fin Tag' length=$25.
      	AE2 label='LFF Applied or Existing' length=$4. 
      	RFF label='Right  Flipper Fin Tag' length=$25.
      	AE3 label='RFF Applied or Existing' length=$4. 
      	CNT label='Curved Notch to Tip' format=best12.
      	CNN label='Curved Notch to Notch' format=6.
      	CW label='Curved Width' format=best12.
      	SNT label='Straight Notch to Tip' format=best12.
      	SNN label='Straight Notch to Notch' format=6.
      	SW label='Straight Width' format=best12.
      	biopsy label='Biopsy' length=$1.
      	hatchdate label='Hatch Date' format=date9.
      	incubation label='Incubation' format=4.
      	Rel_Eggs label='Relocated Eggs' format=3. 
      	Eggs_Taken label='Eggs Taken' format=3.
      	hatched label='Hatched' format=3.
      	unhatched label='Unhatched' format=3. 
      	live label='Live' format=3.
      	dead label='Dead' format=3.
      	pipped label='Pipped Eggs' format=3. 
      	emergencesucc label='Emergence Success' format=percent6.
      	hatchsucc label='Hatch Success' format=percent6.
      	distHT label='Distance to High Tide (m)' format=6.2
      	distVeg label='Distance to Vegetation (m)' format=6.2
      	comments label='Comments' length=$450.
      	Total_Eggs label='Total Eggs' format=3.
         reloc_access label = 'Relocated Access' length=$20
         access label='Original Access' length=$20
         orig_beach_side label='Original Beach Side' length=$25
         reloc_beach_side label='Relocated Beach Side' length=$20
         tags label='Tags' length=$5.
        returning_turtle label='Returning Turtle' length=$1.
        reloc_lat label='Relocated Lat' format=10.8
        reloc_long label='Relocated Long' format=10.8
        disHT2 label='Relocated Distance to High Tide (m)' format=6.2
        disVeg2 label='Relocated Distance to Vegetation (m)' format=6.2
        dna_id label='DNA ID' length=$10.
        prevtags label='Previous Tags' length=$200.
        first_action label='First Action Observed' length=$20.
        exit_time label='Exit Time' format=timeampm11.
        ;
%mend;


data Y1980;
%input80to94(1980,58);
hatchsucc=hatchsucc*100;
emergencesucc=emergencesucc*100;
%DropAttrib();
run;

data Y1981;
%input80to94(1981,56);
%DropAttrib();
run;

data Y1982;
%input80to94(1982,97);
hatchsucc=hatchsucc*100;
emergencesucc=emergencesucc*100;
%DropAttrib();
run;
	
data Y1983;
%input80to94(1983,149);

   rel_eggs1 = scan(comments,1,'relocated');
   rel_eggs1 = substr(rel_eggs1,1,4);
   if nest in (5,6,11,22,25,33,39,50,52,57,59,64,66,75,79,81,89,90,91,99,109,113,121,138,139,140,141,144)
      then rel_eggs1 = '';
   if nest eq 145 then rel_eggs1 = '36';
   eggs_taken1 = scan(comments,2,'+');
   eggs_taken1 = scan(eggs_taken1,1,'');
   if nest = 140 then eggs_taken1 = '68';
   if nest = 7 then eggs_taken1 = '4';
   if nest = 109 then eggs_taken1 = '5';
   if nest=99 then eggs_taken1='37';
   eggs_taken = input(eggs_taken1, 3.);
   rel_eggs = input(rel_eggs1,4.);
   if eggs_taken eq . then eggs_taken=0;
   if rel_eggs eq . then rel_eggs=0;

   comments = catx(' @ ',comments,scan(treatment1,2,','));
   drop eggs_taken1 rel_eggs1;
%DropAttrib();
run;

data Y1984;
%input80to94(1984,127);
%DropAttrib();
run;

data Y1985;
%input80to94(1985,133);
comments = catx(' @ ',comments,treatment1);
%DropAttrib();
run;

data Y1986;
%input80to94(1986,196);

if treatment1 not in ('0','no','No','') then access=treatment1;
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';

final_access = propcase(final_access);
access=propcase(access);
reloc_access=propcase(reloc_access);
orig_beach_side = access;
reloc_beach_side = reloc_access;

if final_access in ('??','Hatchery','South','East','West') then final_access='';
if access in ('Yes','??','Hatchery','South','East','West') then access='';
if reloc_access in ('??','Hatchery','South','East','West') then reloc_access='';

if reloc_beach_side eq 'Hatchery' then comments = catx(' @ ',comments,reloc_beach_side);
if orig_beach_side not in ('South','East','West') then orig_beach_side='';
if reloc_beach_side not in ('South','East','West') then reloc_beach_side='';  
if nest eq 16 then LFF='GA2154';
%DropAttrib();
run;

data Y1987;
%input80to94(1987,96);

if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';

final_access = propcase(final_access);
access=propcase(access);
reloc_access=propcase(reloc_access);
orig_beach_side = access;
reloc_beach_side = reloc_access;

if final_access in ('??','Hatchery','South','East','West') then final_access='';
if access in ('??','Hatchery','South','East','West') then access='';
if reloc_access in ('??','Hatchery','South','East','West') then reloc_access='';

if orig_beach_side not in ('??','Hatchery','South','East','West') then orig_beach_side='';
if reloc_beach_side not in ('??','Hatchery','South','East','West') then reloc_beach_side=''; 
if nest eq 90 then LFF='AAR209'; 
%DropAttrib();
run;


data Y1988;
%input80to94(1988,113);

if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';

final_access = propcase(final_access);
access=propcase(access);
reloc_access=propcase(reloc_access);
orig_beach_side = access;
reloc_beach_side = reloc_access;

if final_access in ('??','Hatchery','South','East','West') then final_access='';
if access in ('??','Hatchery','South','East','West') then access='';
if reloc_access in ('??','Hatchery','South','East','West') then reloc_access='';

if orig_beach_side not in ('Hatchery','South','East','West') then orig_beach_side='';
if reloc_beach_side not in ('Hatchery','South','East','West') then reloc_beach_side='';   
%DropAttrib();
run;


data Y1989;
%input80to94(1989,108);

if treatment1 in ('rel mid-incubation', 'mid-incubation') then comments = catx(' @ ',comments,treatment1);

if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';

final_access = propcase(final_access);
access=propcase(access);
reloc_access=propcase(reloc_access);
orig_beach_side = access;
reloc_beach_side = reloc_access;

if final_access in ('??','Hatchery','South','East','West') then final_access='';
if access in ('??','Hatchery','South','East','West') then access='';
if reloc_access in ('??','Hatchery','South','East','West') then reloc_access='';

if orig_beach_side not in ('??','Hatchery','South','East','West') then orig_beach_side='';
if reloc_beach_side not in ('??','Hatchery','South','East','West') then reloc_beach_side=''; 

if nest=65 then orig_beach_side='South';   
if nest=65 then access='';
if nest=67 then orig_beach_side='';
if nest=67 then reloc_beach_side='East';
%DropAttrib();
run;


data Y1990;
%input80to94(1990,187);

if treatment1 in ('rel mid-incubation', 'mid-incubation') then comments = catx(' @ ',comments,treatment1);
if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';

nest=_n_;
final_access = propcase(final_access);
access=propcase(access);
reloc_access=propcase(reloc_access);
orig_beach_side = access;
reloc_beach_side = reloc_access;

if final_access in ('Rel Site #1','Cci Rel Site','??','Hatchery','South','East','West') then final_access='';
if access in ('Rel Site #1','Cci Rel Site','??','Hatchery','South','East','West') then access='';
if reloc_access in ('Rel Site #1','Cci Rel Site','??','Hatchery','South','East','West') then reloc_access='';

if reloc_beach_side='Cci Rel Site' then reloc_beach_side='CCI Rel Site'; 
if orig_beach_side in ('Rel Site #1','CCI Rel Site') then comments = catx(' @ ',comments,orig_beach_side);
if reloc_beach_side in ('Rel Site #1','CCI Rel Site') then comments = catx(' @ ',comments,reloc_beach_side);
if orig_beach_side not in ('??','Hatchery','South','East','West') then orig_beach_side='';
if reloc_beach_side not in ('??','Hatchery','South','East','West') then reloc_beach_side='';

%DropAttrib();
run;


data Y1991;
%input80to94(1991,184);

nest=_n_;

if treatment1 eq '0' then access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';
%DropAttrib();
run;


data Y1992;
%input80to94(1992,131);
if nest eq 36 then RFF = 'QQV397 / QQV399';
access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';
%DropAttrib();
run;


data Y1993;
%input80to94(1993,71);

if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';
%DropAttrib();
run;


data Y1994;
%input80to94(1994,123);

if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
   else reloc_access='';
if nest eq 24 then LFF='QQM251 / SSJ605';
%DropAttrib();
run;


data Y1995;
infile 'C:\Users\lb3558\Desktop\Turtle\D1995.csv' firstobs=2 obs=88
    dsd dlm=',' missover;
    
input 
        Nest:3. Date1:$15. Time1:$11. location:$20. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$6. DisVeg:$6. Comments:$450.
        dummy returning_turtle:$1. total_eggs:3. tags:$5.
        ;

         time = input(time1, time11.);
       	gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),1995);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),1995);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

       

         final_lat = gps_lat1;
         final_long = gps_long1;
         final_access=location;
         if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
         	else access=location;
         if treatment1 not in ('0','no','No','') then reloc_access=location;
         	else reloc_access='';
   
         if treatment1 in ('0','no','No','') then treatment = 'N';
         else treatment='Y';

         drop dummy;
%DropAttrib();
run;
    

data Y1996;
infile 'C:\Users\lb3558\Desktop\Turtle\D1996.csv' firstobs=2 obs=100
    dsd dlm=',' missover;
    
  input 
        Nest:3. Date1:$15. Time1:$11. location:$20. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. total_eggs:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$6. DisVeg:$20. Comments:$450.
        ;

         time = input(time1, time11.);
       	gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate = mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),1996);
         date = mdy(scan(date1,1,'/'),scan(date1,2,'/'),1996);  
       	numhatchsucc = scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc = scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         if disVeg not eq '' then comments=disVeg;
         if disVeg not eq '' then disVeg='';

         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;
       	
         final_lat = gps_lat1;
         final_long = gps_long1;
         final_access=location;

         if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
            else access=location;
         if treatment1 not in ('0','no','No','') then reloc_access=location;
            else reloc_access='';

         orig_beach_side = scan(access,2,',');
         reloc_beach_side = scan(reloc_access,2,',');
         final_access=scan(final_access,1,',');
         access=scan(access,1,',');
         reloc_access=scan(reloc_access,1,',');

         if nest in (2,4,7,9,18,21,28,33,34,37,43,54,62,64,66,68,72,76,78,79,80,83,87,89,94,95,97)
         	then orig_beach_side='South';
         if nest in (3,5,8,39,45,50,52,70,73,74,75,81,90,98) then orig_beach_side='East';
         if nest in (6,12,13,14,19,22,23,30,35,36,40,46,47,51,56,57,58,59,60,61,63,65,69,71,77,84,85,86,93,96)
         	then reloc_beach_side='South';
         if nest in (10,11,15,16,17,20,24,25,26,27,29,31,32,38,41,42,44,48,49,53,55,67,82,88,91,92,99)
         	then reloc_beach_side='East';
         if nest eq 1 then access=280;
         if treatment1 in ('0','no','No','') then treatment = 'N';
            else treatment='Y';

%DropAttrib();
run;


data Y1997;
%input80to94(1997,76);

if treatment1 not in ('0','no','No','') then access=scan(treatment1,2,',');
   else access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;
%DropAttrib();
run;


data Y1998;
infile 'C:\Users\lb3558\Desktop\Turtle\D1998.csv' firstobs=2 obs=91
    dsd dlm=',' missover;
    
input 
        Nest:3. Date1:$15. Time1:$11. location:$4. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$6. DisVeg:$6. Comments:$450.
        ;

         if treatment1 eq 'RELOCATED 10 YDS BACK' then comments = 'RELOCATED 10 YDS BACK';
         orig_lat1=scan(treatment1,2,':');
         orig_lat2=scan(orig_lat1,1,'W');
         if orig_lat2 eq . then orig_lat2 = gps_lat;
         orig_long2=scan(treatment1,3,':');
         if orig_long2 eq . then orig_long2 = gps_long;
              
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long2, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),1998);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),1998);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         
         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

         final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
         final_long = gps_long1;

         if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
         if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

         final_access=location; 
         if treatment1 eq '' then access=location;
         if treatment1 not in ('0','no','No','') then reloc_access=location;

         if treatment1 in ('0','no','No','') then treatment = 'N';
            else treatment='Y';

         if cnt eq . then cnt=0;
      	if cnn eq . then cnn= 0;
      	if cw eq . then cw = 0;
      	if snt eq . then snt = 0;
      	if snn eq . then snn = 0;
      	if sw eq . then sw = 0; 
      	if biopsy eq . then biopsy='N';
      	if incubation eq . then incubation=0;
      	if Rel_Eggs eq . then Rel_Eggs=0;
      	if Eggs_Taken eq . then Eggs_Taken=0;
      	if Hatched eq . then Hatched=0;
      	if Unhatched eq . then Unhatched=0;
      	if Live eq . then Live=0;
      	if Dead eq . then Dead=0;
      	if Pipped eq . then Pipped=0;
      	if hatchsucc eq . then hatchsucc = 0; 
      	if emergencesucc eq . then emergencesucc = 0;
drop orig_lat1 orig_lat2 orig_long2 gps_lat gps_long gps_lat1 gps_long1;
%DropAttrib(); 
run;







options symbolgen mprint;
%macro input99to02(year,lastob); /*1999-2002, */

infile "C:\Users\lb3558\Desktop\Turtle\D&year..csv" firstobs=2 obs=&lastob
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$4. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        ;

/*for 2000 only*/ if treatment1 eq 'MISSING ORIGINAL' then comments = 'MISSING ORIGINAL';

/*for 2001*/
if treatment1 eq '10 FEET IN FRONT OF NEST' then comments = '10 FEET IN FRONT OF NEST';
if treatment1 eq '5 FT IN FRONT' then comments = '5 FT IN FRONT';
if treatment1 eq '20 FT IN FRONT OF NEST' then comments = '20 FT IN FRONT OF NEST';
/*end of 2001 treatment relocation info*/

orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,3,':');
   if orig_long2 eq . then orig_long2 = gps_long;
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long2, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),&year);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),&year);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=location; /*final access always = location*/
if treatment1 in ('0','no','No','') then access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;

if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';


drop orig_lat1 orig_lat2 orig_long2 gps_lat gps_long gps_lat1 gps_long1; 

   
%mend;



%macro Attrib(); /*add attribute statement last*/


      if distVeg eq . then distVeg=0;
      if distHT eq . then distHT=0;
      if disVeg2 eq . then disVeg2=0;
      if disHT2 eq . then disHT2=0;

      if cnt eq . then cnt=0;
   	if cnn eq . then cnn= 0;
   	if cw eq . then cw = 0;
   	if snt eq . then snt = 0;
   	if snn eq . then snn = 0;
   	if sw eq . then sw = 0; 
   	if biopsy eq '' then biopsy='N';
   	if incubation eq . then incubation=0;
   	if Rel_Eggs eq . then Rel_Eggs=0;
   	if Eggs_Taken eq . then Eggs_Taken=0;
   	if Hatched eq . then Hatched=0;
   	if Unhatched eq . then Unhatched=0;
   	if Live eq . then Live=0;
   	if Dead eq . then Dead=0;
   	if Pipped eq . then Pipped=0;
   	if hatchsucc eq . then hatchsucc = 0; 
   	if emergencesucc eq . then emergencesucc = 0; 


array chars {*} _character_;
   do _n_ = 1 to dim(chars);
   chars{_n_} = strip(chars{_n_});
   end;

   total_eggs = Hatched + Unhatched + Eggs_Taken + Pipped;
   if hatchdate not in ('11AUG2005'd, '19AUG2015'd, '14AUG2017'd ) then emergencesucc = (Hatched-Live-Dead)/(Hatched+Unhatched+Pipped+eggs_taken);
   

   hatchsucc = Hatched / (Hatched+Unhatched+Pipped+ eggs_taken) ;
   if emergencesucc eq . then emergencesucc = 0;
   if hatchsucc eq . then hatchsucc = 0; 
   
   
 drop 
         time1 date1 gps_lat gps_long gps_lat1 gps_long1
         hatchdate1 hatchsucc1 emergencesucc1 
         numemergencesucc numhatchsucc treatment1 location dummy ; 

attrib   
        	Nest label='Nest' format=3.
      	date label='Date' format=date9. 
      	time label='Time' format= timeampm11.
      	final_access label='Final Access' length=$4. 
      	orig_lat label='Original Lat' format=10.8
     	   orig_long label='Original Long' format=10.8
         final_lat label='Final Lat' format=10.8
     	   final_long label='Final Long' format=10.8
         reloc_lat label='Relocated Lat' format=10.8
     	   reloc_long label='Relocated Long' format=10.8
      	treatment label='Treatment' length=$2.
      	observed label='Observed' length=$1.
      	species label='Species' length=$4.
      	PIT label='Pit Tag' length=$25.
      	AE1 label='Pit Applied or Existing' length=$4.
      	LFF label='Left Flipper Fin Tag' length=$25.
      	AE2 label='LFF Applied or Existing' length=$4. 
      	RFF label='Right  Flipper Fin Tag' length=$25.
      	AE3 label='RFF Applied or Existing' length=$4. 
      	CNT label='Curved Notch to Tip' format=best12.
      	CNN label='Curved Notch to Notch' format=6.
      	CW label='Curved Width' format=best12.
      	SNT label='Straight Notch to Tip' format=best12.
      	SNN label='Straight Notch to Notch' format=6.
      	SW label='Straight Width' format=best12.
      	biopsy label='Biopsy' length=$1.
      	hatchdate label='Hatch Date' format=date9.
      	incubation label='Incubation' format=4.
      	Rel_Eggs label='Relocated Eggs' format=3. 
      	Eggs_Taken label='Eggs Taken' format=3.
      	hatched label='Hatched' format=3.
      	unhatched label='Unhatched' format=3. 
      	live label='Live' format=3.
      	dead label='Dead' format=3.
      	pipped label='Pipped Eggs' format=3. 
      	emergencesucc label='Emergence Success' format=percent6.
      	hatchsucc label='Hatch Success' format=percent6.
      	distHT label='Distance to High Tide (m)' format=6.2
      	distVeg label='Distance to Vegetation (m)' format=6.2
      	comments label='Comments' length=$450.
      	Total_Eggs label='Total Eggs' format=3.
         reloc_access label = 'Relocated Access' length=$20
         access label='Original Access' length=$20
         orig_beach_side label='Original Beach Side' length=$25
         reloc_beach_side label='Relocated Beach Side' length=$20
         tags label='Tags' length=$5.
        returning_turtle label='Returning Turtle' length=$1.
        reloc_lat label='Relocated Lat' format=10.8
        reloc_long label='Relocated Long' format=10.8
        distHT2 label='Relocated Distance to High Tide (m)' format=6.2
        distVeg2 label='Relocated Distance to Vegetation (m)' format=6.2
        dna_id label='DNA ID' length=$10.
        prevtags label='Previous Tags' length=$200.
        first_action label='First Action Observed' length=$20.
        exit_time label='Exit Time' format=timeampm11.
        ;
%mend;



data Y1999;
   %input99to02(1999,109);
if nest eq 94 then comments=catx(', ',comments,'LFF tag: ' || LFF);
if nest eq 94 then LFF='';
   %attrib();
run;


data Y2000;
   %input99to02(2000,52);

/*Nest 50 says missing original in treatment*/
   if nest eq 50 then orig_lat = '';
   if nest eq 50 then orig_long = '';
   if nest eq 2 then RFF='SSA068 / SSJ877';
   if nest in (10,42) then comments=catx(', ',comments,'RFF tag: ' || RFF);
   if nest in (10,42) then RFF='';

   %attrib();
run;


data Y2001; 
   %input99to02(2001,78);

   if nest eq 36 then final_long= -77.961180;
   if nest eq 36 then reloc_long = -77.961180;
   if nest in (12,23) then LFF='QQM237';

   %attrib();
run;


data Y2002;
   %input99to02(2002,79);

if nest eq 47 then orig_long = -77.975670;
if nest in (7,19) then access=278;
if nest in (7,19) then final_access=278;
if nest eq 54 then access=279;
if nest eq 54 then final_access=279;

if nest in (11,60,64,75) then pit=''; 

   %attrib();
run;


data Y2003;

infile "C:\Users\lb3558\Desktop\Turtle\D2003.csv" firstobs=2 obs=78
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$4. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        dummy;


orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,3,':');
orig_long3=scan(orig_long2,1,';');
   if orig_long3 eq . then orig_long3 = gps_long; 
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long3, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),2003);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),2003);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         
         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

if LFF eq 'none' then LFF = '';
if RFF eq 'none' then RFF = '';

final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=location; /*final access always = location*/
if treatment1 in ('0','no','No','') then access=location;
if treatment1 not in ('0','no','No','') then reloc_access=location;


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

if nest eq 63 then treatment = 'N';
if nest eq 63 then access = '39L';
if nest eq 63 then reloc_access = '';

drop orig_lat1 orig_lat2 orig_long2 orig_long3 gps_lat gps_long gps_lat1 gps_long1 ; 

   
   if treatment1 eq 'Relocated mid-incubation' then comments = catx(' @ ',comments,treatment1);
   
   if nest eq 67 then final_lat = 33.51601;
   if nest eq 67 then final_long = -78.00279;
   if nest eq 67 then reloc_long = -78.00279;
   if nest eq 67 then reloc_lat = 33.51601;
   if nest eq 13 then access='23L';
   if nest eq 13 then orig_beach_side='South';
   if nest eq 26 then access='18L';
   if nest eq 26 then orig_beach_side='South';   
   if nest eq 75 then access='19L';
   if nest eq 75 then orig_beach_side='South';
   if nest eq 76 then access='36R';
   if nest eq 76 then orig_beach_side='South';
   if nest eq 29 then access='42R';
   if nest eq 29 then orig_beach_side='East';
   if nest eq 11 then access='42R';
   if nest eq 11 then orig_beach_side='East';
   if nest eq 59 then access='42R';
   if nest eq 59 then orig_beach_side='East';
   

if substr(PIT,1,1) eq '(' then substr(PIT,1,1)=''; 
if nest eq 15 then pit=''; 
if nest eq 21 then comments=catx(', ',comments,'LFF tag: ' || LFF);
if nest eq 21 then LFF='';
if nest in (17,36, 53) then LFF='SSK334 / QQJ979';  

   %attrib();
run;



data Y2004;

infile "C:\Users\lb3558\Desktop\Turtle\D2004.csv" firstobs=2 obs=43
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$40. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        ;

orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,3,':');
orig_long3=scan(orig_long2,1,';');
   if orig_long3 eq . then orig_long3 = gps_long;
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long3, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),2004);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),2004);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         
         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;


final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=scan(location,2,''); /*final access always = location*/

if treatment1 in ('0','no','No','') then orig_beach_side=scan(location,1,'');
if treatment1 in ('0','no','No','') then access=scan(location,2,'');


if treatment1 not in ('0','no','No','') then reloc_beach_side=scan(location,1,'');
if treatment1 not in ('0','no','No','') then reloc_access=scan(location,2,'');


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

drop orig_lat1 orig_lat2 orig_long2 orig_long3 gps_lat gps_long gps_lat1 gps_long1 ; 

   if nest eq 28 then orig_beach_side='South';
   if nest eq 28 then access='36L';
   if nest eq 38 then access= '36';
   if nest eq 38 then reloc_access='';
   if nest eq 38 then reloc_beach_side = '';
   if nest eq 38 then reloc_long = '';
   if nest eq 38 then reloc_lat = '';
   
   
   if orig_beach_side eq 'south' then orig_beach_side='South';
     %attrib();
run;



options symbolgen mprint;
%macro input05to08(year,lastob); /*2005-2008, */



infile "C:\Users\lb3558\Desktop\Turtle\D&year..csv" firstobs=2 obs=&lastob
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$40. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        ;

orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,3,':');
   if orig_long2 eq . then orig_long2 = gps_long;

      
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long2, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),&year);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),&year);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         
         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;


final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=scan(location,2,''); /*final access always = location*/

if treatment1 in ('0','no','No','') then orig_beach_side=scan(location,1,'');
if treatment1 in ('0','no','No','') then access=scan(location,2,'');


if treatment1 not in ('0','no','No','') then reloc_beach_side=scan(location,1,'');
if treatment1 not in ('0','no','No','') then reloc_access=scan(location,2,'');


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

drop orig_lat1 orig_lat2 orig_long2 gps_lat gps_long gps_lat1 gps_long1; 

   
%mend;


data Y2005;
   %input05to08(2005,60);

   if nest in (5,7,8) then pit='';
   *if nest eq 10 then emergencesucc=.;
   if nest eq 32 then access='39R';
   if nest eq 32 then reloc_access = '';
   if nest eq 32 then reloc_beach_side = '';
   if nest eq 32 then reloc_long = '';
   if nest eq 32 then reloc_lat = '';
   %attrib();
run;


data Y2006;
   %input05to08(2006,63);

if nest eq 37 then pit=''; 
if nest in (9,22,36) then pit=scan(pit,1,'');
if nest in (9,22,36)then comments=catx(', ',comments,'pit tag: right side');
if nest eq 3 then LFF='SSK334 / RRZ597';
if nest eq 25 then comments=catx(', ',comments,'RFF tag: ' || RFF);
if nest eq 25 then RFF='';
if nest eq 28 then comments=catx(', ',comments,'LFF tag: ' || LFF); 
if nest eq 28 then LFF='';
if nest eq 11 then comments=catx(', ',comments,'LFF tag: M637');
if nest eq 11 then LFF='RRZ518';
if nest in (54,60) then comments=catx(', ',comments,'LFF tag: …637'); 
if nest in (54,60) then LFF='RRZ587';
%attrib();
run;


data Y2007;
   %input05to08(2007,51);

if nest eq 46 then pit='4704111E48';
if nest in (3,30,31,41) then pit='';
if nest in (3,30,41) then LFF='';
if nest in (3,30,42) then RFF='';
if substr(PIT,1,1) eq '(' then substr(PIT,1,1)='';
if nest eq 19 then RFF='RRE136 / TTS975';

   %attrib();
run;


data Y2008;
   %input05to08(2008,105);

if nest eq 15 then pit='';
if nest in (15,41,54,61,76,90) then LFF='';
if nest in (21,40, 59,82) then comments=catx(', ',comments,'RFF tag: ' || RFF);
if nest in (15,21,25,40,46,54,59,68,76,82,97) then RFF=''; 
if nest in (16,22,23,43,46,68,71,86) then pit=scan(pit,1,'');
if nest in (22,23,43,46,68,71,86)then comments=catx(', ',comments,'pit tag: right side');
if nest eq 103 then comments=catx(', ',comments,'pit tag: ' || pit); 
if nest eq 103 then pit='';


   %attrib();
run;



options symbolgen mprint;
%macro input09to10(year,lastob); /*2009-2010*/

infile "C:\Users\lb3558\Desktop\Turtle\D&year..csv" firstobs=2 obs=&lastob
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$40. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        ;

break = scan(treatment1,2,';');


         orig_lat1=scan(treatment1,2,':');
         orig_lat2=scan(orig_lat1,1,'W');
            if orig_lat2 eq . then orig_lat2 = gps_lat;
         orig_long2=scan(treatment1,3,':');
         orig_long3=scan(orig_long2,1,';');
            if orig_long3 eq . then orig_long3 = gps_long;
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long3, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),&year);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),&year);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         
         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;


final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=scan(location,2,''); /*final access always = location*/

if treatment1 not in ('0','no','No','') then orig_beach_side=scan(break,1,'');
if treatment1 not in ('0','no','No','') then access=scan(break,2,'');
if treatment1 in ('0','no','No','') then orig_beach_side=scan(location,1,'');
if treatment1 in ('0','no','No','') then access=scan(location,2,'');


if treatment1 not in ('0','no','No','') then reloc_beach_side=scan(location,1,'');
if treatment1 not in ('0','no','No','') then reloc_access=scan(location,2,'');


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

drop orig_lat1 orig_lat2 orig_long2 orig_long3 gps_lat gps_long gps_lat1 gps_long1 break; 

   
%mend;



data Y2009;
   %input09to10(2009,38);

if nest in (19,23,34) then LFF='';
if nest in (19,23,34) then RFF=''; 
if nest in (6,12,20,28,31,32,33,36) then pit=scan(pit,1,'');
if nest in (6,12,20,28,31,32,33,36)then comments=catx(', ',comments,'pit tag: right side');
if nest in (3,11,18) then LFF='RRZ587';
if nest in (3,11,18) then comments=catx(', ',comments,'LFF tag: M637');
 
   %attrib();
run;


data Y2010;
   %input09to10(2010,76);

    if nest eq 14 then orig_lat = "";
    if nest eq 14 then orig_long = "";
    *if nest eq 14 then final_lat = .;
    if nest eq 14 then final_long = .;
    if nest eq 45 then final_access = '42L';
    if nest eq 45 then orig_beach_side = 'East';
    if nest eq 45 then access='42L';

   if nest in (25,45,48,67) then pit=''; 
   if nest in (31,45,61) then comments=catx(', ',comments,'LFF tag: ' || LFF);
   if nest in (10,25,31,45,48,61,67) then LFF='';
   if nest in (10,25,48,67) then RFF=''; 
   if nest eq 55 then distveg = 21; 

   if nest eq 49 then access = '36L';
   if nest eq 49 then reloc_access = '36L';

   %attrib();
run;




options symbolgen mprint;
%macro input11to14(year,lastob); /*2011-2014, excluding 2013 */

infile "C:\Users\lb3558\Desktop\Turtle\D&year..csv" firstobs=2 obs=&lastob
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$40. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        ;

break = scan(treatment1,2,';');


orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,3,':');
orig_long3=scan(orig_long2,1,';');
   if orig_long3 eq . then orig_long3 = gps_long;
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long3, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),&year);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),&year);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         
         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;


final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=location; /*final access always = location*/

if treatment1 not in ('0','no','No','') then orig_beach_side=scan(break,1,'');
if treatment1 not in ('0','no','No','') then access=scan(break,2,'');

if treatment1 in ('0','no','No','') then access=location;

if treatment1 not in ('0','no','No','') then reloc_access=location;


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

drop orig_lat1 orig_lat2 orig_long2 orig_long3 gps_lat gps_long gps_lat1 gps_long1 break; 

   
%mend;


data Y2011;
   %input11to14(2011,100);

   if nest eq 89 then final_long = -77.95990;
   if nest eq 89 then orig_long = -77.95990;

   if nest in (28,59,60,78,85) then pit='';
   if nest in (8,13,27,42,65) then comments=catx(', ',comments,'RFF tag: ' || RFF);
   if nest eq 93 then comments=catx(', ',comments,'LFF tag: ' || LFF);
   if nest eq 93 then LFF='';
   if nest in (28,39,59,60,78,85) then LFF='';
   if nest in (4,8,13,15,27,28,32,42,50,59,60,65,78,85) then RFF=''; 
   if nest in (3,8,9,13,21,27,42,65,88,89) then pit=scan(pit,1,'');
   if nest in (8,27,42,65,88)then comments=catx(', ',comments,'pit tag: right side');
   if nest eq 3 then prevtags='985100010477173, 985120016904574';
   if nest eq 9 then prevtags='470D3E096A';
   if nest eq 13 then prevtags='985120016904574, 4C13384E69';
   if nest eq 21 then prevtags='4704140E2E';
   if nest eq 89 then prevtags='4704140E2E';
   if nest eq 79 then access='29R';
   if nest eq 79 then reloc_access='29R';
   if nest eq 97 then access='25R';
   if nest eq 97 then reloc_access = '25R';

   %attrib();
run;

data Y2012;
   %input11to14(2012,77);

   if nest eq 6 then pit='';
   if nest eq 7 then comments=catx(', ',comments,'LFF tag: ' || LFF);
   if nest eq 7 then LFF='';

   %attrib();
run;


data dup2013; /*deleted duplicate rows in data step below*/
     
infile "C:\Users\lb3558\Desktop\Turtle\D2013.csv" firstobs=2 obs=127
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$40. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        ;

break = scan(treatment1,2,';');


orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,3,':');
orig_long3=scan(orig_long2,1,';');
   if orig_long3 eq . then orig_long3 = gps_long;
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long3, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),2013);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),2013);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         
         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=scan(location,2,''); /*final access always = location*/

if treatment1 not in ('0','no','No','') then orig_beach_side=scan(break,1,'');
if treatment1 not in ('0','no','No','') then access=scan(break,2,'');
if treatment1 in ('0','no','No','') then orig_beach_side=scan(location,1,'');
if treatment1 in ('0','no','No','') then access=scan(location,2,'');


if treatment1 not in ('0','no','No','') then reloc_beach_side=scan(location,1,'');
if treatment1 not in ('0','no','No','') then reloc_access=scan(location,2,'');


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

drop orig_lat1 orig_lat2 orig_long2 orig_long3 gps_lat gps_long gps_lat1 gps_long1 break; 

   
  if nest eq 3 then orig_long=-77.95992;
  if nest eq 8 then orig_long = -78.00858;
  if nest eq 40 then orig_long = -77.94979;
  if nest eq 40 then final_long = -77.94979;
  if nest eq 3 then access='39L';
  if nest eq 3 then orig_beach_side='East';

   if nest eq 26 then pit='';
   if nest eq 4 then LFF='RRZ587';
   if nest eq 4 then comments=catx(', ',comments,'LFF tag: XXM6..');
   if nest in (30,77) then LFF='RRZ587';
   if nest in (30,77) then comments=catx(', ',comments,'LFF tag: XXM63.'); 
   if nest in (26,37,55,88) then LFF='';
   if nest in (26,37,88,101) then RFF=''; 
   if nest in (5,54) then pit=scan(pit,1,'');
   if nest in (5,54,98)then comments=catx(', ',comments,'pit tag: right side');
   if nest eq 98 then pit='982.000167802816; 3D6.000A0077C0';
   %attrib();
run;


data Y2013;
set dup2013;
by nest;
  if first.nest;
run;

data Y2014;
   %input11to14(2014,34);

    if nest eq 8 then pit='';
   if nest in (8,11,21) then LFF='';
   if nest eq 8 then RFF=''; 
   if nest eq 25 then pit=scan(pit,1,'');
   if nest eq 25 then comments=catx(', ',comments,'pit tag: right side');

   %attrib();
run;


data Y2015; /*This year had new variables added to the end. Did not drop location or treatment yet*/
infile "C:\Users\lb3558\Desktop\Turtle\D2015.csv" firstobs=2 obs=97
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$15. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$11. DisVeg:$11. Comments:$450.
        dummy disHT2:$9. disVeg2:$9. DNA_ID:$10. prevtags:$200.  ;

orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,2,',');
   if orig_long2 eq . then orig_long2 = gps_long;

   
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long2, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),2015);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),2015);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;

         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

         distVeg2=input(disVeg2, 6.);
         distHT2=input(disHT2,6.);
         drop disVeg2 disHT2;
         rename distHT2=disHT2 distVeg2=disVeg2;

         if distVeg eq . then distVeg=0;
         if distHT eq . then distHT=0;
         if distVeg2 eq . then distVeg2=0;
         if distHT2 eq . then distHT2=0; 

         
         if biopsy eq '2' then biopsy = 'Y';

final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=location; /*final access always = location*/

if treatment1 not in ('0','no','No','') then access=scan(treatment1,3,',');

if treatment1 in ('0','no','No','') then access=location;

if treatment1 not in ('0','no','No','') then reloc_access=location;


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

if nest in (8,35,51,70) then pit=scan(pit,1,'');
if nest in (8,35,51,70) then comments=catx(', ',comments,'pit tag: right side');
if nest eq 71 then pit='';
/*if nest eq 61..has two pit tags*/ 

 if nest in (6,18,38,68) then comments=catx(', ',comments,'LFF tag: ' || LFF);
 if nest in (6,18,38,68) then LFF='';

 if nest eq 8 then RFF='UUT644 TTL562';

 if nest in (42,53,65,77,92) then comments=catx(', ',comments,'RFF tag: ' || RFF);
 if nest in (42,53,65,77,92) then RFF='';

if nest in (10,18,38,55,65) then prevtags=scan(prevtags,2,'-');
if nest eq 54 then comments='nested on Masonboro twice';	
if nest in (15,21,24,29,40,49,60,66,67,71,72) then comments=catx(', ',comments,prevtags);
if nest in (11,15,17,21,23,24,29,40,49,54,55,60,66,67,68,69,71,72) then prevtags='';

if nest eq 30 then final_long = -77.9599800 ;
if nest eq 30 then orig_long = -77.9599800 ;
if nest eq 30 then reloc_long = -77.9599800;
if nest eq 32 then final_long = -77.9599800 ;
if nest eq 32 then orig_long = -77.9599800 ;
if nest eq 32 then reloc_long = -77.9599800;

if nest eq 25 then orig_long = orig_long*-1; 
if nest eq 33 then orig_long = orig_long*-1;
if nest eq 35 then orig_long = -77.57357;
if nest eq 35 then orig_lat = -33.50590;

 
if nest eq 9 then hatchdate = '28JUL2015'd;
  drop 
         time1 date1 hatchdate1 orig_lat1 orig_lat2 orig_long2 gps_lat gps_long gps_lat1 gps_long1
         hatchsucc1 emergencesucc1 numemergencesucc numhatchsucc dummy; 

%attrib();

run;


data Y2016; /*total clutch variable introduced, did not drop location or treatment yet*/

infile "C:\Users\lb3558\Desktop\Turtle\D2016.csv" firstobs=2 obs=103
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. location:$4. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. total_clutch:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. Comments:$450.
        dummy disHT2:$9. disVeg2:$9. ;

orig_lat1=scan(treatment1,2,':');
orig_lat2=scan(orig_lat1,1,'W');
   if orig_lat2 eq . then orig_lat2 = gps_lat;
orig_long2=scan(treatment1,2,',');
   if orig_long2 eq . then orig_long2 = gps_long;
        
         time = input(time1, time11.);
       	orig_lat = input(orig_lat2, 10.); 
       	orig_long = input(orig_long2, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),2016);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),2016);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;


         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

          distVeg2=input(disVeg2, 6.);
         distHT2=input(disHT2,6.);
         drop disVeg2 disHT2;
         rename distHT2=disHT2 distVeg2=disVeg2;

         if distVeg eq . then distVeg=0;
         if distHT eq . then distHT=0;
         if distVeg2 eq . then distVeg2=0;
         if distHT2 eq . then distHT2=0; 

       
final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=location; /*final access always = location*/

if treatment1 not in ('0','no','No','') then access=scan(treatment1,3,',');

if treatment1 in ('0','no','No','') then access=location;

if treatment1 not in ('0','no','No','') then reloc_access=location;


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

   
   if nest eq 42 then distveg2 = 30;
   if nest eq 63 then distHT2=30;
   if nest eq 69 then distHT2=30;
   if nest eq 97 then RFF='';
   if nest eq 8 then access='42L';
   if nest eq 8 then reloc_access='42L';
   if nest eq 32 then access='36L';
   if nest eq 32 then reloc_access='36L';
   if nest eq 65 then access='36L';
   if nest eq 65 then reloc_access='36L';

   if nest in (5,12,23,36,39,47,64) then comments=catx(', ',comments,'LFF tag: ' || LFF);
   if nest in (5,12,23,36,39,47,64) then LFF='';

   if nest in (51,97) then comments=catx(', ',comments,'RFF tag: ' || RFF);
   if nest in (51,97) then RFF='';

  drop 
         time1 date1 hatchdate1 orig_lat1 orig_lat2 orig_long2 gps_lat gps_long gps_lat1 gps_long1
         hatchsucc1 emergencesucc1 numemergencesucc numhatchsucc dummy;

%attrib();

run;


data Y2017; /*did not drop location or treatment yet*/

infile "C:\Users\lb3558\Desktop\Turtle\D2017.csv" firstobs=2 obs=41
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. first_action:$20. location:$4. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. Live:3. Dead:3.
        Pipped:3. total_clutch:3. EmergenceSucc1:$8. HatchSucc1:$8. DisHT:$9. DisVeg:$9. 
        exit_time1:$11. Comments:$450.      ;

orig_lat1=scan(treatment1,1,',');

   if orig_lat1 eq . then orig_lat1 = gps_lat;
orig_long2=scan(treatment1,2,',');
   if orig_long2 eq . then orig_long2 = gps_long;
        
         time = input(time1, time11.);
         exit_time = input(exit_time1, time11.);
       	orig_lat = input(orig_lat1, 10.); 
       	orig_long = input(orig_long2, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),2017);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),2017);  
       	numhatchsucc= scan(hatchsucc1,1,'%');
       	hatchsucc = input(numhatchsucc, 8.2)/100; 
      	numemergencesucc= scan(emergencesucc1,1,'%');
       	emergencesucc = input(numemergencesucc, 8.2)/100;


         distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

         distVeg2=input(disVeg2, 6.);
         distHT2=input(disHT2,6.);
         drop disVeg2 disHT2;
         rename distHT2=disHT2 distVeg2=disVeg2;

         first_action = propcase(first_action);
         if distVeg eq . then distVeg=0;
         if distHT eq . then distHT=0;
         if distVeg2 eq . then distVeg2=0;
         if distHT2 eq . then distHT2=0;


         if nest eq 1 then distHT=29;
         if nest eq 2 then distHT=17.3;
         if nest eq 3 then distHT=36;
         if nest eq 4 then distHT=27.7;  
         if nest eq 5 then distHT=10.36;
         if nest eq 6 then distHT=20.5;
         if nest eq 7 then distHT=19.64;
         if nest eq 8 then distHT=21.9;
         if nest eq 10 then distHT=20.35;
         if nest eq 11 then distHT=16.12;
         if nest eq 12 then distHT=26.77;

         if nest eq 31 then pit='';
         if nest eq 31 then LFF='';
         if nest eq 31 then RFF='';

         if nest eq 2 then snt=85.8; 
         if nest eq 2 then snn=83.9;
         if nest eq 2 then sw=64.5;
         if nest eq 12 then cnt=111.3; 
         if nest eq 12 then cnn=110.2;
         if nest eq 12 then cw=100.3;
         if nest eq 12 then snn=102;
         if nest eq 12 then sw=79.8;

final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=location; /*final access always = location*/

if treatment1 in ('0','no','No','') then access=location;

if treatment1 not in ('0','no','No','') then reloc_access=location;


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

   if cnt eq . then cnt=0;
	if cnn eq . then cnn= 0;
	if cw eq . then cw = 0;
	if snt eq . then snt = 0;
	if snn eq . then snn = 0;
	if sw eq . then sw = 0; 
	if biopsy eq '' then biopsy='N';
	if incubation eq . then incubation=0;
	if Rel_Eggs eq . then Rel_Eggs=0;
	if Eggs_Taken eq . then Eggs_Taken=0;
	if Hatched eq . then Hatched=0;
	if Unhatched eq . then Unhatched=0;
	if Live eq . then Live=0;
	if Dead eq . then Dead=0;
	if Pipped eq . then Pipped=0;   

  drop 
         time1 date1 hatchdate1 orig_lat1 orig_long2 gps_lat gps_long gps_lat1 gps_long1
         hatchsucc1 emergencesucc1 numemergencesucc numhatchsucc exit_time1 total_clutch;

if location eq 'Shoals ClubR' then location='';

   
array chars {*} _character_;
   do _n_ = 1 to dim(chars);
   chars{_n_} = strip(chars{_n_});
   end;

   total_eggs = Hatched + Unhatched + Eggs_Taken + Pipped;
   if nest not in (15, 34) then emergencesucc = (Hatched-Live-Dead)/(Hatched+Unhatched+Pipped+eggs_taken);
   

   hatchsucc = Hatched / (Hatched+Unhatched+Pipped+ eggs_taken) ;
   if emergencesucc eq . then emergencesucc = 0;
   if hatchsucc eq . then hatchsucc = 0; 
   if nest eq 14 then final_access = '';
   if nest eq 14 then access = '';

   if nest eq 33 then comments=catx(', ',comments,'LFF tag: ' || LFF);
   if nest eq 33 then LFF='';
   
 drop 
         time1 date1 gps_lat gps_long gps_lat1 gps_long1
         hatchdate1 hatchsucc1 emergencesucc1 
         numemergencesucc numhatchsucc treatment1 location dummy ; 

attrib   
        	Nest label='Nest' format=3.
      	date label='Date' format=date9. 
      	time label='Time' format= timeampm11.
      	final_access label='Final Access' length=$4. 
      	orig_lat label='Original Lat' format=10.8
     	   orig_long label='Original Long' format=10.8
         final_lat label='Final Lat' format=10.8
     	   final_long label='Final Long' format=10.8
         reloc_lat label='Relocated Lat' format=10.8
     	   reloc_long label='Relocated Long' format=10.8
      	treatment label='Treatment' length=$2.
      	observed label='Observed' length=$1.
      	species label='Species' length=$4.
      	PIT label='Pit Tag' length=$25.
      	AE1 label='Pit Applied or Existing' length=$4.
      	LFF label='Left Flipper Fin Tag' length=$25.
      	AE2 label='LFF Applied or Existing' length=$4. 
      	RFF label='Right  Flipper Fin Tag' length=$25.
      	AE3 label='RFF Applied or Existing' length=$4. 
      	CNT label='Curved Notch to Tip' format=best12.
      	CNN label='Curved Notch to Notch' format=6.
      	CW label='Curved Width' format=best12.
      	SNT label='Straight Notch to Tip' format=best12.
      	SNN label='Straight Notch to Notch' format=6.
      	SW label='Straight Width' format=best12.
      	biopsy label='Biopsy' length=$1.
      	hatchdate label='Hatch Date' format=date9.
      	incubation label='Incubation' format=4.
      	Rel_Eggs label='Relocated Eggs' format=3. 
      	Eggs_Taken label='Eggs Taken' format=3.
      	hatched label='Hatched' format=3.
      	unhatched label='Unhatched' format=3. 
      	live label='Live' format=3.
      	dead label='Dead' format=3.
      	pipped label='Pipped Eggs' format=3. 
      	emergencesucc label='Emergence Success' format=percent6.
      	hatchsucc label='Hatch Success' format=percent6.
      	distHT label='Distance to High Tide (m)' format=6.2
      	distVeg label='Distance to Vegetation (m)' format=6.2
      	comments label='Comments' length=$450.
      	Total_Eggs label='Total Eggs' format=3.
         reloc_access label = 'Relocated Access' length=$20
         access label='Original Access' length=$20
         orig_beach_side label='Original Beach Side' length=$25
         reloc_beach_side label='Relocated Beach Side' length=$20
         tags label='Tags' length=$5.
        returning_turtle label='Returning Turtle' length=$1.
        reloc_lat label='Relocated Lat' format=10.8
        reloc_long label='Relocated Long' format=10.8
        distHT2 label='Relocated Distance to High Tide (m)' format=6.2
        distVeg2 label='Relocated Distance to Vegetation (m)' format=6.2
        dna_id label='DNA ID' length=$10.
        prevtags label='Previous Tags' length=$200.
        first_action label='First Action Observed' length=$20.
        exit_time label='Exit Time' format=timeampm11.
        ;

run;


data Y2018; /*variables: goforth, embryo, noembryo, disT?? Did not drop location or treatment yet*/

infile "C:\Users\lb3558\Desktop\Turtle\D2018.csv" firstobs=2 obs=53
    dsd dlm=',' missover;

input 
        Nest:3. Date1:$15. Time1:$11. first_action:$20. location:$4. gps_Lat:$10. gps_Long:$10. 
  	     Treatment1:$40. Observed:$1. Species:$4. PIT:$25. AE1:$4. LFF:$25. AE2:$4. 
        RFF:$25. AE3:$4. CNT:6. CNN:6. CW:6. SNT:6. SNN:6. SW:6. Biopsy:$1. HatchDate1:$15.
        Incubation:3. Rel_Eggs:3. Eggs_Taken:3. Hatched:3. Unhatched:3. no_embryo:3. embryo:3. Live:3. Dead:3.
        Pipped:3. total_clutch:3. EmergenceSucc:8. HatchSucc:8. DisHT:$9. DisT:$9. DisVeg:$9. disHT2:$9. 
        exit_time1:$11. goforth:$15. Comments:$450.    ;

orig_lat1=scan(treatment1,1,',');
   if orig_lat1 eq . then orig_lat1 = gps_lat;
orig_long2=scan(treatment1,2,',');
   if orig_long2 eq . then orig_long2 = gps_long;
        
         time = input(time1, time11.);
         exit_time = input(exit_time1, time11.);
       	orig_lat = input(orig_lat1, 10.); 
       	orig_long = input(orig_long2, 10.);
         gps_lat1 = input(gps_lat, 10.); 
       	gps_long1 = input(gps_long, 10.);
       	hatchdate= mdy(scan(hatchdate1,1,'/'),scan(hatchdate1,2,'/'),2018);
         date= mdy(scan(date1,1,'/'),scan(date1,2,'/'),2018); 


   distVeg=input(disVeg, 6.);
         distHT=input(disHT,6.);
         drop disVeg disHT;
         rename distHT=disHT distVeg=disVeg;

         distVeg2=input(disVeg2, 6.);
         distHT2=input(disHT2,6.);
         drop disVeg2 disHT2;
         rename distHT2=disHT2 distVeg2=disVeg2;


         if distVeg eq . then distVeg=0;
         if distHT eq . then distHT=0;
         if distVeg2 eq . then distVeg2=0;
         if distHT2 eq . then distHT2=0;
       	

final_lat = gps_lat1; /*final_lat,long = gps_lat,long*/
final_long = gps_long1;

if treatment1 not in ('0','no','No','') then reloc_lat = gps_lat1; /*if treatment populated, relocated lat,long=gps_lat,long*/
if treatment1 not in ('0','no','No','') then reloc_long = gps_long1;

final_access=location; /*final access always = location*/

if treatment1 in ('0','no','No','') then access=location;

if treatment1 not in ('0','no','No','') then reloc_access=location;


if treatment1 in ('0','no','No','') then treatment = 'N';
   else treatment='Y';

   if cnt eq . then cnt=0;
	if cnn eq . then cnn= 0;
	if cw eq . then cw = 0;
	if snt eq . then snt = 0;
	if snn eq . then snn = 0;
	if sw eq . then sw = 0; 
	if biopsy eq '' then biopsy='N';
	if incubation eq . then incubation=0;
	if Rel_Eggs eq . then Rel_Eggs=0;
	if Eggs_Taken eq . then Eggs_Taken=0;
	if Hatched eq . then Hatched=0;
	if Unhatched eq . then Unhatched=0;
	if Live eq . then Live=0;
	if Dead eq . then Dead=0;
	if Pipped eq . then Pipped=0;
	

  drop 
         time1 date1 hatchdate1 orig_lat1 orig_long2 gps_lat gps_long gps_lat1 gps_long1
         dummy exit_time1 total_clutch disT;

%attrib();

run;


/* current version

data turtles.LauraNew;
set 
   

     Y1999 Y2000 Y2001 Y2002 Y2003 Y2004 Y2005 Y2006 Y2007 Y2008
      Y2009 Y2010 Y2011 Y2012 Y2013 Y2014 Y2015 Y2016 Y2017 Y2018;

keep  nest final_lat final_long access observed species pit ae1 lff ae2 rff ae3 
      cnt cnn cw snt snn sw biopsy incubation rel_eggs eggs_taken hatched unhatched
      live dead pipped disHT disVeg comments date time orig_lat orig_long treatment
      reloc_access hatchdate total_eggs emergencesucc hatchsucc final_access orig_beach_side
      reloc_beach_side returning_turtle tags reloc_lat reloc_long disHT2 disVeg2 dna_id
      prevtags first_action exit_time
      ;

run;

*/

data turtles.Lj1;
set 
Y1980 Y1981 Y1982 Y1983 Y1984 Y1985 Y1986 Y1987 Y1988 Y1989
    Y1990 Y1991 Y1992 Y1993 Y1994 Y1995 Y1996 Y1997 Y1998

Y1999 Y2000 Y2001 Y2002 Y2003 Y2004 Y2005 Y2006 Y2007 Y2008
      Y2009 Y2010 Y2011 Y2012 Y2013 Y2014 Y2015 Y2016 Y2017;

keep  nest final_lat final_long access observed species pit ae1 lff ae2 rff ae3 
      cnt cnn cw snt snn sw biopsy incubation rel_eggs eggs_taken hatched unhatched
      live dead pipped disHT disVeg comments date time orig_lat orig_long treatment
      reloc_access hatchdate total_eggs emergencesucc hatchsucc final_access orig_beach_side
      reloc_beach_side returning_turtle tags reloc_lat reloc_long disHT2 disVeg2 dna_id
      prevtags first_action exit_time
      ;
if LFF in ('none', 'None') then LFF = '';
if RFF in ('none', 'None') then RFF = '';
access = compress(access);
reloc_access = compress(reloc_access);
final_access = compress(final_access);

run;













































 
