#!/bin/bash

## Output
## JSON, example:
## {
## 		"error": {
## 			"code": "0",
## 			"msg": "ok"
## 		},
## 		"test_execution": {
## 			"variables": [
## 				{"name": "checksum", "ref": "true", "rvalue": "250", "usr": "true", "uvalue": "250", "equal": "true"},
## 				{"name": "cost", "ref": "true", "rvalue": "250", "usr": "true", "uvalue": "192", "equal": "false"},
## 			]
## 			"files": [
## 				{"name": "image1.jpeg", "ref": "true", "usr": "true", "equal": "true"},
## 				{"name": "image2.jpeg", "ref": "true", "usr": "true", "equal": "false"}
## 			]
## 			"variablesp": [
## 				{"name": "time", "ref": "true", "rvalue": "35.2154", "usr": "true", "uvalue": "35.7895"},
## 				{"name": "area", "ref": "true", "rvalue": "10.5124", "usr": "false", "uvalue": ""}
## 			]
## 			"pbsvars": [
## 				{"name": "cpupercent", "ref": "true", "rvalue": "120", "usr": "true", "uvalue": "105"},
## 				{"name": "cput", "ref": "true", "rvalue": "00:20:58", "usr": "true", "uvalue": "00:21:21"}
## 				{"name": "mem", "ref": "true", "rvalue": "5420kb", "usr": "true", "uvalue": "5596kb"}
## 				{"name": "vmem", "ref": "true", "rvalue": "14312kb", "usr": "true", "uvalue": "15372kb"}
## 				{"name": "walltime", "ref": "true", "rvalue": "00:05:01", "usr": "true", "uvalue": "00:05:21"}
## 			]
## 		},
##      "evaluation": {
##			"errorcode": "0",
##			"msg": "ok",
##			"score": "4.8"
##		}
## }

## *** FUNCTIONS - BEGIN ***

## FUNCTION WRITE_JSON - BEGIN

function write_json {
	ERROR_TEXT="\"error\": 
				{
				\"code\": \"${JSON_ERROR_CODE}\", \"msg\": \"${JSON_ERROR_MSG}\"
				}";
	if [ ${JSON_ERROR_CODE} -gt 0 ]; then
		OUTPUT_TEXT="{ ${ERROR_TEXT} }";
	else
		VARS_TEXT="";
		for i in $( seq 1 ${JSON_TESTEXEC_NUMVARS} ); do
			if [ $i -gt 1 ]; then
				VARS_TEXT="${VARS_TEXT},";
			fi;
			SVARS_TEXT="\"name\": \"${JSON_TESTEXEC_VARIABLES[$i,1]}\",
						\"ref\": \"${JSON_TESTEXEC_VARIABLES[$i,2]}\",
						\"rvalue\": \"${JSON_TESTEXEC_VARIABLES[$i,3]}\"";
			if [ ${CLI_ONLYREF} -eq 0 ]; then
				SVARS_TEXT="${SVARS_TEXT},
							\"usr\": \"${JSON_TESTEXEC_VARIABLES[$i,4]}\",
							\"uvalue\": \"${JSON_TESTEXEC_VARIABLES[$i,5]}\",
							\"equal\": \"${JSON_TESTEXEC_VARIABLES[$i,6]}\"";
			fi;
			VARS_TEXT="${VARS_TEXT} { ${SVARS_TEXT} }";
		done;
		FILES_TEXT="";
		for i in $( seq 1 ${JSON_TESTEXEC_NUMFILES} ); do
			if [ $i -gt 1 ]; then
				FILES_TEXT="${FILES_TEXT},";
			fi;
			SFILES_TEXT="\"name\": \"${JSON_TESTEXEC_FILES[$i,1]}\",
						 \"ref\": \"${JSON_TESTEXEC_FILES[$i,2]}\"";
			if [ ${CLI_ONLYREF} -eq 0 ]; then
				SFILES_TEXT="${SFILES_TEXT},
							 \"usr\": \"${JSON_TESTEXEC_FILES[$i,3]}\",
							 \"equal\": \"${JSON_TESTEXEC_FILES[$i,4]}\"";
			fi;
			FILES_TEXT="${FILES_TEXT} { ${SFILES_TEXT} }";
		done;
		VARSP_TEXT="";
		for i in $( seq 1 ${JSON_TESTEXEC_NUMVARSP} ); do
			if [ $i -gt 1 ]; then
				VARSP_TEXT="${VARSP_TEXT},";
			fi;
			SVARSP_TEXT="\"name\": \"${JSON_TESTEXEC_VARIABLESP[$i,1]}\",
						 \"ref\": \"${JSON_TESTEXEC_VARIABLESP[$i,2]}\",
						 \"rvalue\": \"${JSON_TESTEXEC_VARIABLESP[$i,3]}\"";
			if [ ${CLI_ONLYREF} -eq 0 ]; then
				SVARSP_TEXT="${SVARSP_TEXT},
							 \"usr\": \"${JSON_TESTEXEC_VARIABLESP[$i,4]}\",
							 \"uvalue\": \"${JSON_TESTEXEC_VARIABLESP[$i,5]}\"";
			fi;
						
			VARSP_TEXT="${VARSP_TEXT} { ${SVARSP_TEXT} }";
		done;
		PBSVARS_TEXT="";
		for i in $( seq 1 ${JSON_TESTEXEC_NUMPBSVARSP} ); do
			if [ $i -gt 1 ]; then
				PBSVARS_TEXT="${PBSVARS_TEXT},";
			fi;
			SPBSVARS_TEXT="\"name\": \"${JSON_TESTEXEC_PBSVARSP[$i,1]}\",
						   \"ref\": \"${JSON_TESTEXEC_PBSVARSP[$i,2]}\",
						   \"rvalue\": \"${JSON_TESTEXEC_PBSVARSP[$i,3]}\"";
			if [ ${CLI_ONLYREF} -eq 0 ]; then
				SPBSVARS_TEXT="${SPBSVARS_TEXT},
							 \"usr\": \"${JSON_TESTEXEC_PBSVARSP[$i,4]}\",
							 \"uvalue\": \"${JSON_TESTEXEC_PBSVARSP[$i,5]}\"";
			fi;
			PBSVARS_TEXT="${PBSVARS_TEXT} { ${SPBSVARS_TEXT} }";
		done;
		TESTEXEC_TEXT="\"test_execution\": 
					{
						\"variables\": 
						[
						${VARS_TEXT}
						],
						\"files\": 
						[
						${FILES_TEXT}
						], 
						\"variablesp\": 
						[
						${VARSP_TEXT}
						], 
						\"pbsvars\": 
						[
						${PBSVARS_TEXT}
						] 
					}";
		if [ ${CLI_ONLYREF} -eq 0 ]; then
			EVALUATION_TEXT="\"evaluation\":
			                {
							 \"errorcode\": \"${JSON_EVALUATION_CODEERROR}\",
							 \"msg\": \"${JSON_EVALUATION_MSG}\",
							 \"score\": \"${JSON_EVALUATION_SCORE}\"
							}";
			OUTPUT_TEXT="{ ${ERROR_TEXT}, ${TESTEXEC_TEXT}, ${EVALUATION_TEXT} }";
		else	
			OUTPUT_TEXT="{ ${ERROR_TEXT}, ${TESTEXEC_TEXT} }";
		fi;	
	fi;
	
	## Execute json 
	JSON_OUTPUT=$( echo ${OUTPUT_TEXT} | python3 -c 'import json,sys;from collections import OrderedDict; print( json.dumps(json.load(sys.stdin, object_pairs_hook=OrderedDict), indent=4));');
	printf "${JSON_OUTPUT}\n"
}

## FUNCTION WRITE_JSON - END

## FUNCTION PREPARE_EVALUATION - BEGIN

function prepare_evaluation {
	if [ "x" != "x${EVAL_EXPRESSION}" ]; then
		if [ ${JSON_EVALUATION_CODEERROR} -eq 0 ]; then
			## Create values for reference and user (varp and pbsvarp)
			PYTHON_VARS_REF="";
			PYTHON_VARS_USR="";
			if [ ${VARIABLESP_LIST_NUM} -gt 0 ]; then
				i=0;
				for ivar in ${!VARIABLESP_LIST_ARRAY[@]}; do
					(( i++ ));
					PYTHON_VARS_REF="${PYTHON_VARS_REF}\n${EVALUATION_REF_PREFIX}${JSON_TESTEXEC_VARIABLESP[$i,1]}=${JSON_TESTEXEC_VARIABLESP[$i,3]};";
					PYTHON_VARS_USR="${PYTHON_VARS_USR}\n${EVALUATION_USR_PREFIX}${JSON_TESTEXEC_VARIABLESP[$i,1]}=${JSON_TESTEXEC_VARIABLESP[$i,5]};";
				done;
			fi;
			if [ ${PBSVARSP_LIST_NUM} -gt 0 ]; then
				i=0;
				for ivar in ${!PBSVARSP_LIST_ARRAY[@]}; do
					(( i++ ));
					PYTHON_VARS_REF="${PYTHON_VARS_REF}\n${EVALUATION_REF_PREFIX}${JSON_TESTEXEC_PBSVARSP[$i,1]}=${JSON_TESTEXEC_PBSVARSP[$i,3]};";
					PYTHON_VARS_USR="${PYTHON_VARS_USR}\n${EVALUATION_USR_PREFIX}${JSON_TESTEXEC_PBSVARSP[$i,1]}=${JSON_TESTEXEC_PBSVARSP[$i,5]};";
				done;
			fi;
		fi;	
		PYTHON_CMD=$( printf "${PYTHON_VARS_REF}\n${PYTHON_VARS_USR}\n__RESULT=${EVAL_EXPRESSION};\nprint(__RESULT);");
		PYTHON_OUTPUT=$( python3 -c "${PYTHON_CMD}" 2>&1 );
		if [ $? -ne 0 ]; then
			PYTHON_OUTPUT=$( echo ${PYTHON_OUTPUT} | sed 's/\"//g' | sed 's/\n//g' );
			change_evaluation_codeerror ${EVALUATION_ERROR_CODE_PYTHON} "${PYTHON_OUTPUT}";
		else
			JSON_EVALUATION_SCORE=${PYTHON_OUTPUT};
			JSON_EVALUATION_MSG="Operation performed successfully!";
		fi;	
	else
		change_evaluation_codeerror ${EVALUATION_ERROR_CODE_NOTEXPRESSION} "Expression was not provided!";
	fi;
}

## FUNCTION PREPARE_EVALUATION - END

## FUNCTION EXIT SCRIPT - BEGIN

function exit_script {
	write_json;
	exit ${JSON_ERROR_CODE};
}

## FUNCTION EXIT SCRIPT - END

## FUNCTION CHECK_FILE_EXIST - BEGIN

function check_file_exist {
	if [ ! -f $1 ]; then
		JSON_ERROR_CODE=${ERROR_CODE_FILE_NOT_FOUND};
		JSON_ERROR_MSG="File $1 was not found!";
		exit_script
	fi;
}

## FUNCTION CHECK_FILE_EXIST - END

## FUNCTION CHANGE_EVALUATION_CODEERROR - BEGIN

function change_evaluation_codeerror {
	if [ ${JSON_EVALUATION_CODEERROR} -eq 0 ]; then
		JSON_EVALUATION_CODEERROR="$1";
		JSON_EVALUATION_SCORE="0.0";
		JSON_EVALUATION_MSG="$2";
	fi;	
}

## FUNCTION CHANGE_EVALUATION_CODEERROR - END

## *** FUNCTIONS - END ***

## *** INITIAL VALUES - BEGIN ***

SCRIPT_VERSION="0.1.20200414"

JSON_ERROR_CODE="0";
JSON_ERROR_MSG="Process completed successfully!";
JSON_TESTEXEC_NUMVARS=0;
declare -A JSON_TESTEXEC_VARIABLES;
JSON_TESTEXEC_VARIABLES="";
JSON_TESTEXEC_NUMFILES=0;
declare -A JSON_TESTEXEC_FILES;
JSON_TESTEXEC_FILES="";
JSON_TESTEXEC_NUMVARSP=0;
declare -A JSON_TESTEXEC_VARIABLESP;
JSON_TESTEXEC_VARIABLESP="";
JSON_TESTEXEC_NUMPBSVARSP=0;
declare -A JSON_TESTEXEC_PBSVARSP;
JSON_TESTEXEC_PBSVARSP="";
JSON_EVALUATION_CODEERROR="0";
JSON_EVALUATION_MSG="";
JSON_EVALUATION_SCORE="0.0";

PBSFILE_PREFIX="";
CLI_ONLYREF=0;
REF_OUT_FOLDER_NAME="";
USR_OUT_FOLDER_NAME="";
VARIABLES_LIST="";
FILES_LIST="";
VARIABLESP_LIST="";
PBSVARSP_LIST="";
EVAL_EXPRESSION="";

## *** INITIAL VALUES - END ***

## *** RESULT AND ERROR CODES - BEGIN ***

RESULT_TRUE="True";
RESULT_FALSE="False";

ERROR_CODE_BAD_PARAMETER=1;
ERROR_CODE_PBSFILE_PREFIX_NOT_SPECIFIED=2;
ERROR_CODE_OUT_FOLDER_NOT_SPECIFIED=3;
ERROR_CODE_OUT_FOLDER_NOT_FOUND=4;
ERROR_CODE_FILE_NOT_FOUND=5;
ERROR_CODE_FILE_NOT_READABLE=6;
ERROR_CODE_FILE_NOT_WRITABLE=7;
ERROR_CODE_VARPREFIXES=8;
ERROR_CODE_EXECUTION=9;

EVALUATION_ERROR_CODE_VAR=1;
EVALUATION_ERROR_CODE_FILE=2;
EVALUATION_ERROR_CODE_VARP=3;
EVALUATION_ERROR_CODE_PBSVARP=4;
EVALUATION_ERROR_CODE_PYTHON=5;
EVALUATION_ERROR_CODE_NOTEXPRESSION=6;

EVALUATION_REF_PREFIX="REF_";
EVALUATION_USR_PREFIX="";

## *** RESULT AND ERROR CODES - END ***

## *** PARSING ARGUMENTS - BEGIN ***

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -h|--help)
      echo;
      echo "PBS EXECUTION AND EVALUATION REPORT GENERATOR - Version ${SCRIPT_VERSION}";
      echo;
      echo "Usage: $0 [options]";
      echo " -pbsfile_prefix PREFIX            : PBS File Prefix (e.g. -pbsfile_prefix PBS_FILE)";
      echo " -onlyref                          : process reference results only";
      echo " -refoutfolder REF_OUT_FOLDER_NAME : output folder to process";
      echo " -usroutfolder USR_OUT_FOLDER_NAME : output folder to process";
      echo " -variables LIST_OF_VARS           : list of variables to compare";
      echo " -files LIST_OF_FILES              : list of output files";
      echo " -variablesp LIST_OF_PERFVARS      : list of performance variables to compute CF";
      echo " -pbsvarsp LIST_OF_PBSVARS         : list of performance PBS variables to compute CF";
      echo " -evaluation EXPRESSION            : Python expression for the evaluation";
      echo " -eval_refprefix PREFIX            : Prefix for reference variables";
      echo " -eval_usrprefix PREFIX            : Prefix for user variables";
      echo " -h|--help                         : shows this help";
      echo;
      exit 0;
    ;;

    -pbsfile_prefix)
      if [[ $# -gt 1 ]]; then
        PBSFILE_PREFIX=($2);
        shift
      fi;  
    ;;

    -onlyref)
		CLI_ONLYREF=1;
    ;;
    
    -refoutfolder)
      if [[ $# -gt 1 ]]; then
        REF_OUT_FOLDER_NAME=($2);
        shift
      fi;  
    ;;

    -usroutfolder)
      if [[ $# -gt 1 ]]; then
        USR_OUT_FOLDER_NAME=($2);
        shift
      fi;  
    ;;
    
    -variables)
      if [[ $# -gt 1 ]]; then
        VARIABLES_LIST=($2);
        shift
      fi;  
    ;;

	-files)
      if [[ $# -gt 1 ]]; then
        FILES_LIST=($2);
        shift
      fi;  
    ;;

    -variablesp)
      if [[ $# -gt 1 ]]; then
        VARIABLESP_LIST=($2);
        shift
      fi;  
    ;;
    
    -pbsvarsp)
      if [[ $# -gt 1 ]]; then
        PBSVARSP_LIST=($2);
        shift
      fi;  
    ;;
    
    -evaluation)
      if [[ $# -gt 1 ]]; then
        EVAL_EXPRESSION=($2);
        shift
      fi;  
    ;;
    
    -eval_refprefix)
      if [[ $# -gt 1 ]]; then
        EVALUATION_REF_PREFIX=($2);
        shift
      fi;  
    ;;

    -eval_usrprefix)
      if [[ $# -gt 1 ]]; then
        EVALUATION_USR_PREFIX=($2);
        shift
      fi;  
    ;;
      
    "")
    ;;
    
    *)
    JSON_ERROR_CODE="${ERROR_CODE_BAD_PARAMETER}";
    JSON_ERROR_MSG="Unknown parameter: $key";
    exit_script;
    ;;
  esac
  shift
done

## PBSFILE_PREFIX validation
if [[ "x" == "x${PBSFILE_PREFIX}" ]]; then
	JSON_ERROR_CODE="${ERROR_CODE_PBSFILE_PREFIX_NOT_SPECIFIED}";
	JSON_ERROR_MSG="PBSFILE_PREFIX was not specified!";
	exit_script
fi;

## Output ref folder validation
if [[ "x" == "x${REF_OUT_FOLDER_NAME}" ]]; then
	JSON_ERROR_CODE="${ERROR_CODE_OUT_FOLDER_NOT_SPECIFIED}";
	JSON_ERROR_MSG="Reference output folder was not specified!";
	exit_script
elif [ ! -d "${REF_OUT_FOLDER_NAME}" ]; then
	JSON_ERROR_CODE="${ERROR_CODE_OUT_FOLDER_NOT_FOUND}";
	JSON_ERROR_MSG="Folder: ${REF_OUT_FOLDER_NAME} does not exist!";
	exit_script
fi;

## Output usr folder validation
if [ ${CLI_ONLYREF} -eq 0 ]; then
	if [[ "x" == "x${USR_OUT_FOLDER_NAME}" ]]; then
		JSON_ERROR_CODE="${ERROR_CODE_OUT_FOLDER_NOT_SPECIFIED}";
		JSON_ERROR_MSG="User output folder was not specified!";
		exit_script
	elif [ ! -d "${USR_OUT_FOLDER_NAME}" ]; then
		JSON_ERROR_CODE="${ERROR_CODE_OUT_FOLDER_NOT_FOUND}";
		JSON_ERROR_MSG="Folder: ${USR_OUT_FOLDER_NAME} does not exist!";
		exit_script
	fi;
fi;

## Get variables from cli
if [[ "x" == "x${VARIABLES_LIST}" ]]; then
	VARIABLES_LIST_NUM=0;
	VARIABLES_LIST_ARRAY="";
else
	VARIABLES_LIST_ARRAY=($( echo ${VARIABLES_LIST} | sed 's/,/\n/g' ));
	VARIABLES_LIST_NUM=${#VARIABLES_LIST_ARRAY[@]};
fi;

## Get files from cli
if [[ "x" == "x${FILES_LIST}" ]]; then
	FILES_LIST_NUM=0;
	FILES_LIST_ARRAY="";
else
	FILES_LIST_ARRAY=($( echo ${FILES_LIST} | sed 's/,/\n/g' ));
	FILES_LIST_NUM=${#FILES_LIST_ARRAY[@]};
fi;

## Get performance variables from cli
if [[ "x" == "x${VARIABLESP_LIST}" ]]; then
	VARIABLESP_LIST_NUM=0;
	VARIABLESP_LIST_ARRAY="";
else
	VARIABLESP_LIST_ARRAY=($( echo ${VARIABLESP_LIST} | sed 's/,/\n/g' ));
	VARIABLESP_LIST_NUM=${#VARIABLESP_LIST_ARRAY[@]};
fi;

## Get PBS performance variables from cli
if [[ "x" == "x${PBSVARSP_LIST}" ]]; then
	PBSVARSP_LIST_NUM=0;
	PBSVARSP_LIST_ARRAY="";
else
	PBSVARSP_LIST_ARRAY=($( echo ${PBSVARSP_LIST} | sed 's/,/\n/g' ));
	PBSVARSP_LIST_NUM=${#PBSVARSP_LIST_ARRAY[@]};
fi;

## Determine if the output, error, and qstat files exist for reference
file_to_check=${REF_OUT_FOLDER_NAME}/${PBSFILE_PREFIX}.OU;
check_file_exist ${file_to_check}
ref_output_file=${file_to_check};
file_to_check=${REF_OUT_FOLDER_NAME}/${PBSFILE_PREFIX}.ER;
check_file_exist ${file_to_check}
ref_error_file=${file_to_check};
pbs_ref_qstat_file=${REF_OUT_FOLDER_NAME}/${PBSFILE_PREFIX}.QSTAT;
ref_qstat_exec_info=$( cat ${pbs_ref_qstat_file} 2> /dev/null );
if [ $? -ne 0 ]; then
	JSON_ERROR_CODE=${ERROR_CODE_FILE_NOT_READABLE};
	JSON_ERROR_MSG="File $1 cannot be read! It was not possible to read the qstat info from reference output folder!";
	exit_script
fi;
	
## Determine if the output, error and qstat files exist for user
if [ ${CLI_ONLYREF} -eq 0 ]; then
	file_to_check=${USR_OUT_FOLDER_NAME}/${PBSFILE_PREFIX}.OU;
	check_file_exist ${file_to_check}
	usr_output_file=${file_to_check};
	file_to_check=${USR_OUT_FOLDER_NAME}/${PBSFILE_PREFIX}.ER;
	check_file_exist ${file_to_check}
	usr_error_file=${file_to_check};
	pbs_usr_qstat_file=${USR_OUT_FOLDER_NAME}/${PBSFILE_PREFIX}.QSTAT;
	usr_qstat_exec_info=$( cat ${pbs_usr_qstat_file} 2> /dev/null );
	if [ $? -ne 0 ]; then
		JSON_ERROR_CODE=${ERROR_CODE_FILE_NOT_READABLE};
		JSON_ERROR_MSG="File $1 cannot be read! It was not possible to read the qstat info from user output folder!";
		exit_script
	fi;
fi;

## Determine if variable prefixes are different
if [ "x${EVALUATION_REF_PREFIX}" == "x${EVALUATION_USR_PREFIX}" ]; then
	JSON_ERROR_CODE=${ERROR_CODE_VARPREFIXES};
	JSON_ERROR_MSG="Variable prefixes are equal!";
	exit_script
fi;	

## *** PARSING ARGUMENTS - END ***

## *** GET INFO FROM OUTPUTS AND FILES - BEGIN ***

## Check if error file has information
if [ ${CLI_ONLYREF} -eq 1 ]; then
	error_file_size=$( wc -c ${ref_error_file} | awk '{print $1}' );
	JSONT_ERROR_MSG="Reference error file is not empty!";
else
	error_file_size=$( wc -c ${usr_error_file} | awk '{print $1}' );
	JSONT_ERROR_MSG="User error file is not empty!";
fi;
if [ ${error_file_size} -gt 0 ]; then
	JSON_ERROR_CODE="${ERROR_CODE_EXECUTION}";
	JSON_ERROR_MSG=${JSONT_ERROR_MSG};
	exit_script
fi;

## Retrieve variables information
if [ ${VARIABLES_LIST_NUM} -gt 0 ]; then
	filter=$( echo ${VARIABLES_LIST_ARRAY[@]} | sed 's/ /|/g' );
	ref_output_text=$( cat ${ref_output_file} | sed -n -E "/${filter}/p" );
	
	i=0;
	for ivar in ${!VARIABLES_LIST_ARRAY[@]}; do
		(( i++ ));
		JSON_TESTEXEC_VARIABLES[$i,1]=${VARIABLES_LIST_ARRAY[$ivar]};
		ref_text=$( printf "${ref_output_text}" | grep "\b${VARIABLES_LIST_ARRAY[$ivar]}\b" );
		if [ "x" != "x${ref_text}" ]; then
			JSON_TESTEXEC_VARIABLES[$i,2]=${RESULT_TRUE};
			ref_value=$( printf "${ref_text}" | awk -v FS="=" '{print $2}' );
			ref_value=$( echo ${ref_value} | sed 's/ *$//g' );	## Remove trailing spaces
			JSON_TESTEXEC_VARIABLES[$i,3]=${ref_value};
			if [ ${CLI_ONLYREF} -eq 0 ]; then
				usr_output_text=$( cat ${usr_output_file} | sed -n -E "/${filter}/p" );
				usr_text=$( printf "${usr_output_text}" | grep "\b${VARIABLES_LIST_ARRAY[$ivar]}\b" );
				if [ "x" != "x${usr_text}" ]; then
					JSON_TESTEXEC_VARIABLES[$i,4]=${RESULT_TRUE};
					usr_value=$( printf "${usr_text}" | awk -v FS="=" '{print $2}' );
					usr_value=$( echo ${usr_value} | sed 's/ *$//g' );
					JSON_TESTEXEC_VARIABLES[$i,5]=${usr_value};
					if [ "x${ref_value}" == "x${usr_value}" ]; then
						JSON_TESTEXEC_VARIABLES[$i,6]=${RESULT_TRUE};
					else
						JSON_TESTEXEC_VARIABLES[$i,6]=${RESULT_FALSE};
						change_evaluation_codeerror $EVALUATION_ERROR_CODE_VAR "Var ${JSON_TESTEXEC_VARIABLES[$i,1]} is not equal to reference!";
					fi;	
				else
					JSON_TESTEXEC_VARIABLES[$i,4]=${RESULT_FALSE};
					JSON_TESTEXEC_VARIABLES[$i,5]="";
					JSON_TESTEXEC_VARIABLES[$i,6]=${RESULT_FALSE};
					change_evaluation_codeerror $EVALUATION_ERROR_CODE_VAR "Var ${JSON_TESTEXEC_VARIABLES[$i,1]} not found on user!";
				fi;
			else
				JSON_TESTEXEC_VARIABLES[$i,4]=${RESULT_FALSE};
				JSON_TESTEXEC_VARIABLES[$i,5]="";
				JSON_TESTEXEC_VARIABLES[$i,6]=${RESULT_FALSE};
			fi;
		else
			JSON_TESTEXEC_VARIABLES[$i,2]=${RESULT_FALSE};
			JSON_TESTEXEC_VARIABLES[$i,3]="";
			JSON_TESTEXEC_VARIABLES[$i,4]=${RESULT_FALSE};
			JSON_TESTEXEC_VARIABLES[$i,5]="";
			JSON_TESTEXEC_VARIABLES[$i,6]=${RESULT_FALSE};
			change_evaluation_codeerror $EVALUATION_ERROR_CODE_VAR "Var ${JSON_TESTEXEC_VARIABLES[$i,1]} not found on reference!";
		fi;
	done;
	JSON_TESTEXEC_NUMVARS=${i};
fi;

## Retrieve performance variables information
if [ ${VARIABLESP_LIST_NUM} -gt 0 ]; then
	filter=$( echo ${VARIABLESP_LIST_ARRAY[@]} | sed 's/ /|/g' );
	ref_output_text=$( cat ${ref_output_file} | sed -n -E "/${filter}/p" );
	
	i=0;
	for ivar in ${!VARIABLESP_LIST_ARRAY[@]}; do
		(( i++ ));
		JSON_TESTEXEC_VARIABLESP[$i,1]=${VARIABLESP_LIST_ARRAY[$ivar]};
		ref_text=$( printf "${ref_output_text}" | grep "\b${VARIABLESP_LIST_ARRAY[$ivar]}\b" );
		if [ "x" != "x${ref_text}" ]; then
			JSON_TESTEXEC_VARIABLESP[$i,2]=${RESULT_TRUE};
			ref_value=$( printf "${ref_text}" | awk -v FS="=" '{print $2}' );
			ref_value=$( echo ${ref_value} | sed 's/ *$//g' );
			JSON_TESTEXEC_VARIABLESP[$i,3]=${ref_value};
			if [ ${CLI_ONLYREF} -eq 0 ]; then
				usr_output_text=$( cat ${usr_output_file} | sed -n -E "/${filter}/p" );
				usr_text=$( printf "${usr_output_text}" | grep "\b${VARIABLESP_LIST_ARRAY[$ivar]}\b" );
				if [ "x" != "x${usr_text}" ]; then
					JSON_TESTEXEC_VARIABLESP[$i,4]=${RESULT_TRUE};
					usr_value=$( printf "${usr_text}" | awk -v FS="=" '{print $2}' );
					usr_value=$( echo ${usr_value} | sed 's/ *$//g' );
					JSON_TESTEXEC_VARIABLESP[$i,5]=${usr_value};
				else
					JSON_TESTEXEC_VARIABLESP[$i,4]=${RESULT_FALSE};
					JSON_TESTEXEC_VARIABLESP[$i,5]="";
					change_evaluation_codeerror $EVALUATION_ERROR_CODE_VARP "VarP ${JSON_TESTEXEC_VARIABLESP[$i,1]} not found on user!";
				fi;
			else
				JSON_TESTEXEC_VARIABLESP[$i,4]=${RESULT_FALSE};
				JSON_TESTEXEC_VARIABLESP[$i,5]="";
			fi;
		else	
			JSON_TESTEXEC_VARIABLESP[$i,2]=${RESULT_FALSE};
			JSON_TESTEXEC_VARIABLESP[$i,3]="";
			JSON_TESTEXEC_VARIABLESP[$i,4]=${RESULT_FALSE};
			JSON_TESTEXEC_VARIABLESP[$i,5]="";
			change_evaluation_codeerror $EVALUATION_ERROR_CODE_VARP "VarP ${JSON_TESTEXEC_VARIABLESP[$i,1]} not found on reference!";
		fi;
	done;
	JSON_TESTEXEC_NUMVARSP=${i};
fi;

## Retrieve PBS performance variables information
if [ ${PBSVARSP_LIST_NUM} -gt 0 ]; then
	filter=$( echo ${PBSVARSP_LIST_ARRAY[@]} | sed 's/ /|/g' );
	ref_output_text=$( printf "${ref_qstat_exec_info}\n" | sed -n -E "/${filter}/p" );
	
	i=0;
	for ivar in ${!PBSVARSP_LIST_ARRAY[@]}; do
		(( i++ ));
		JSON_TESTEXEC_PBSVARSP[$i,1]=${PBSVARSP_LIST_ARRAY[$ivar]};
		ref_text=$( printf "${ref_output_text}" | grep "\bresources_used\.${PBSVARSP_LIST_ARRAY[$ivar]}\b" );
		if [ "x" != "x${ref_text}" ]; then
			JSON_TESTEXEC_PBSVARSP[$i,2]=${RESULT_TRUE};
			ref_value=$( printf "${ref_text}" | awk -v FS="=" '{print $2}' );
			ref_value=$( echo ${ref_value} | sed 's/ *$//g' );
			JSON_TESTEXEC_PBSVARSP[$i,3]=${ref_value};
			if [ ${CLI_ONLYREF} -eq 0 ]; then
				usr_output_text=$( printf "${usr_qstat_exec_info}\n" | sed -n -E "/${filter}/p" );
				usr_text=$( printf "${usr_output_text}" | grep "\bresources_used\.${PBSVARSP_LIST_ARRAY[$ivar]}\b" );
				if [ "x" != "x${usr_text}" ]; then
					JSON_TESTEXEC_PBSVARSP[$i,4]=${RESULT_TRUE};
					usr_value=$( printf "${usr_text}" | awk -v FS="=" '{print $2}' );
					usr_value=$( echo ${usr_value} | sed 's/ *$//g' );
					JSON_TESTEXEC_PBSVARSP[$i,5]=${usr_value};
				else
					JSON_TESTEXEC_PBSVARSP[$i,4]=${RESULT_FALSE};
					JSON_TESTEXEC_PBSVARSP[$i,5]="";
					change_evaluation_codeerror $EVALUATION_ERROR_CODE_PBSVARP, "PBSVarP ${JSON_TESTEXEC_PBSVARSP[$i,1]} not found on user!";
				fi;
			else
				JSON_TESTEXEC_PBSVARSP[$i,4]=${RESULT_FALSE};
				JSON_TESTEXEC_PBSVARSP[$i,5]="";
			fi;
		else
			JSON_TESTEXEC_PBSVARSP[$i,2]=${RESULT_FALSE};
			JSON_TESTEXEC_PBSVARSP[$i,3]="";
			JSON_TESTEXEC_PBSVARSP[$i,4]=${RESULT_FALSE};
			JSON_TESTEXEC_PBSVARSP[$i,5]="";
			change_evaluation_codeerror $EVALUATION_ERROR_CODE_PBSVARP "PBSVarP ${JSON_TESTEXEC_PBSVARSP[$i,1]} not found on reference!";
		fi;
	done;
	JSON_TESTEXEC_NUMPBSVARSP=${i};
fi;

## Compare files
i=0;
for ivar in ${!FILES_LIST_ARRAY[@]}; do
	(( i++ ));
	JSON_TESTEXEC_FILES[$i,1]=${FILES_LIST_ARRAY[$ivar]};
	ref_file=${REF_OUT_FOLDER_NAME}/${FILES_LIST_ARRAY[$ivar]};
	usr_file=${USR_OUT_FOLDER_NAME}/${FILES_LIST_ARRAY[$ivar]};
	
	if [ -f ${ref_file} ]; then
		JSON_TESTEXEC_FILES[$i,2]=${RESULT_TRUE};
		if [ ${CLI_ONLYREF} -eq 0 ]; then
			if [ -f ${usr_file} ]; then
				JSON_TESTEXEC_FILES[$i,3]=${RESULT_TRUE};
				comp_result=$( diff ${ref_file} ${usr_file} 2> /dev/null );
				if [ $? -eq 0 ]; then
					JSON_TESTEXEC_FILES[$i,4]=${RESULT_TRUE};
				else
					JSON_TESTEXEC_FILES[$i,4]=${RESULT_FALSE};
					change_evaluation_codeerror $EVALUATION_ERROR_CODE_FILE "File ${JSON_TESTEXEC_FILES[$i,1]} not equal to reference!";
				fi;	
			else
				JSON_TESTEXEC_FILES[$i,3]=${RESULT_FALSE};
				JSON_TESTEXEC_FILES[$i,4]=${RESULT_FALSE};
				change_evaluation_codeerror $EVALUATION_ERROR_CODE_FILE "File ${JSON_TESTEXEC_FILES[$i,1]} not found on user!";
			fi;
		else
			JSON_TESTEXEC_FILES[$i,3]=${RESULT_FALSE};
			JSON_TESTEXEC_FILES[$i,4]=${RESULT_FALSE};
		fi; 
	else
		JSON_TESTEXEC_FILES[$i,2]=${RESULT_FALSE};
		JSON_TESTEXEC_FILES[$i,3]=${RESULT_FALSE};
		JSON_TESTEXEC_FILES[$i,4]=${RESULT_FALSE};
		change_evaluation_codeerror $EVALUATION_ERROR_CODE_FILE "File ${JSON_TESTEXEC_FILES[$i,1]} not found on reference!";
	fi;
done;	
JSON_TESTEXEC_NUMFILES=${i};

## Prepare evaluation, if possible
prepare_evaluation

## Write JSON with final results
write_json

## *** GET INFO FROM OUTPUTS AND FILES - END ***