:: ==============================================================
:: Script for starting the monitoring component for ExplorViz
:: ==============================================================
@ECHO OFF

REM Get the directory of this file and change the working directory to it.
cd %~dp0

REM Set every variable we will need for the execution.
SET BINDIR=%cd%

SET KIEKER_JAR="kieker-1.14-SNAPSHOT-aspectj.jar"
SET KIEKER_CONFIG=".\META-INF\kieker.monitoring.sa.properties" 
REM SET AOP_CONFIG=".\META-INF\aop.springPetclinic.xml"
SET AOP_CONFIG=".\META-INF\aop.sa.xml"
SET MAINCLASS="org.springframework.samples.petclinic.PetClinicApplication"
SET JAVA_CP=".;BOOT-INF\classes\;BOOT-INF\lib\*"

START "springPetclinic" /B java -javaagent:%KIEKER_JAR% -Dkieker.monitoring.skipDefaultAOPConfiguration=true -Dkieker.monitoring.configuration=%KIEKER_CONFIG% -Dorg.aspectj.weaver.loadtime.configuration=%AOP_CONFIG% -cp %JAVA_CP% %MAINCLASS%

REM CALL .\create-load.bat

REM java -javaagent:"kieker-1.14-SNAPSHOT-aspectj.jar" -Dkieker.monitoring.skipDefaultAOPConfiguration=true -Dkieker.monitoring.configuration=".\META-INF\kieker.monitoring.properties" -Dorg.aspectj.weaver.loadtime.configuration=".\META-INF\aop.springPetclinic.xml" -cp ".:BOOT-INF/classes/:BOOT-INF/lib/*" "org.springframework.samples.petclinic.PetClinicApplication"
