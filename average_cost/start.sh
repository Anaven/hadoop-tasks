#!/bin/bash
if [ $# -lt 2 ]; then
	echo "usage: ./$0 jobname comment(eg. 20130315)"
	exit 1
fi

HADOOP_HOME=/home/img/hadoop_wutai/hadoop
LOCAL_BASE_DIR=`dirname $0`
LOG_DIR=${LOCAL_BASE_DIR}/logs
HADOOP_WORK_DIR=/app/ns/image/image_traffic/liucheng07

if [ ! -d ${LOG_DIR} ]; then
    mkdir -p logs
fi

# you should modify
JOB_NAME=$1
LOG_NAME=$2

exec >& ${LOG_DIR}/${JOB_NAME}.${LOG_NAME}.log

INPUT_DIR=${HADOOP_WORK_DIR}/in/*                                                  
OUTPUT_DIR=${HADOOP_WORK_DIR}/out/${JOB_NAME}/${LOG_NAME}

PYTHON_ARCH_FILE=/app/ns/image/image_traffic/tools/Python-2.7.10.tar.gz
PYTHON_HOME=Python-2.7.10

# you should modify
MAPPER_NAME=mapper.py
REDUCER_NAME=reducer.py

${HADOOP_HOME}/bin/hadoop fs -rmr ${OUTPUT_DIR}

StartTime=`date +"%s"`

${HADOOP_HOME}/bin/hadoop streaming \
	-D mapred.job.priority='VERY_HIGH' \
	-D mapred.job.name=Aven_${JOB_NAME}_{$LOG_NAME} \
	-D mapred.reduce.tasks=1 \
	-D mapred.job.map.capacity=100 \
	-D mapred.min.split.size=4294967296 \
	-input ${INPUT_DIR} \
	-output ${OUTPUT_DIR} \
	-mapper "${PYTHON_HOME}/python ${MAPPER_NAME}" \
	-reducer "${PYTHON_HOME}/python ${REDUCER_NAME}" \
	-cacheArchive ${PYTHON_ARCH_FILE}'#'${PYTHON_HOME} \
	-file ${LOCAL_BASE_DIR}/${MAPPER_NAME} \
	-file ${LOCAL_BASE_DIR}/${REDUCER_NAME}

if [ ${?} -ne 0 ]
then
    echo "${JOB_NAME} error"
    exit 1
fi

EndTime=`date +"%s"`
HadoopTime=$(( EndTime - StartTime ))
echo "spend $HadoopTime s"
