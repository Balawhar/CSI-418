-------- BOBFINANCE --------

Session 1
Zoom code = 446 403 9935
Zoom password = B0BF!n@nce

Session 2
Zoom code = 4647395369
Zoom password = 509214

-- UAT --
10.11.150.200 ( IP )
BOBF60DB ( Database )
bobitseg120 ( PC )
--

--PROD
BOBF01DB

------------------------------- Monthly Health Check ------------------------------------


Go to bobitseg120 ( PC ) through remote desktop ( its called bobfinjawad )

-> WinSCP -> 10.11.150.200(newDBUAT)(putty)

df -h to check u01

-> home/oracle/DBHlogs

empty everything inside the DBHlogs directory then check df -h

Create a folder on desktop and name it MonthlyHealthCheck<date>

inside that folder create another folder name it UAT

-> 10.11.150.200(newDBUAT)(putty) -> history -> Arman target(script)

df -h to check u01

run the Arman target(script)

df -h

-> home/oracle -> dbhealthcheck.sh

-> run ./dbhealthcheck.sh

once dbhealthcheck.sh finishes 

go to -> home/oracle/DBHlogs

take the HTML files only and put them in the UAT folder in the MonthlyHealthCheck folder on desktop

--

--Send an external Email to George Moussallem ( Elie,Habib,Nour (CC)):
--To proceed to PROD after UAT Is Done

--

Need to Send a Final Email:

-- Default Email

Dears,

With reference to our zoom session intervention dated on 04/06/2024, we have checked the two databases of both UAT and PROD and we came out with the below report:


on UAT:
File system Usage on /u01 is 53% - No action needed.
No storage warnings found on Tablespaces size.
No incidents or significant alerts found in Oracle logs.

on PROD:
File system Usage on /u01 is 78% 23 Gb are still available - No action needed.
No storage warnings found on Tablespaces size.
No incidents or significant alerts found in Oracle logs.
 

Please refer to the attached html reports for further details.

Moreover, kindly note that the launched health check over both UAT and PROD servers showed that both applications are working properly as well.


--


-- Fixed Email

Dears,

With reference to our zoom session intervention dated on 06/03/2024, we have checked the two databases of both UAT and PROD and we came out with the below report:


on UAT:
File system Usage on /u01 is 53% - No action needed.
No storage warnings found on Tablespaces size.
No incidents or significant alerts found in Oracle logs.
 

on PROD:
File system Usage on /u01 is 80% 21 Gb are still available - No action needed.
Warnings found on Tablespaces size:
	REF_DATA_ITEM: 90.95% space used. - Adding datafiles required 
	SYSAUX usage is	89.30% - Attention required on sys.AUD$ size (truncate)	
No incidents or significant alerts found in Oracle logs.
 
Please refer to the attached html reports for further details.

Moreover, kindly note that the launched health check over both UAT and PROD servers showed that both applications are working properly as well.



