#!/bin/bash

if [ "$#" -lt 3 ] 
then
	echo 'Usage: $0 --release=d96b --path=d96b-maersk --smooks-version=1.7.0 [--suffix=maersk]' && exit 1
fi

SUFFIX=""
REPO_ID="internal"
REPO_URL="http://52.179.158.171:8081/repository/internal/"
GROUP_ID=org.milyn.edi.unedifact

for i in "$@"
do
case $i in
    -p=*|--path=*)
    MODULE_PATH="${i#*=}"
    shift # past argument=value
    ;;
    -r=*|--release=*)
    EDIFACT_RELEASE="${i#*=}"
    shift # past argument=value
    ;;
    -v=*|--smooks-version=*)
    SMOOKS_VERSION="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--suffix=*)
    SUFFIX="-${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

if [ ! -d ${MODULE_PATH} ]; then
	echo "${MODULE_PATH} does not exist!"
	exit 1
fi

if [[ ! ${MODULE_PATH} == ${EDIFACT_RELEASE}* ]]; then
	echo "${MODULE_PATH} does not contain ${EDIFACT_RELEASE}!"
	exit 1
fi

cd ${MODULE_PATH}

# Clean and install mappings and bindings
mvn clean install

if [[ ! -f mapping/target/${GROUP_ID}.${EDIFACT_RELEASE}-mapping${SUFFIX}_${SMOOKS_VERSION}.jar ]]; then
	echo "File ./${MODULE_PATH}/mapping/target/${GROUP_ID}.${EDIFACT_RELEASE}-mapping${SUFFIX}_${SMOOKS_VERSION}.jar does not exist"
	exit 1
fi

if [[ ! -f binding/target/${GROUP_ID}.${EDIFACT_RELEASE}-binding${SUFFIX}_${SMOOKS_VERSION}.jar ]]; then
	echo "File ./${MODULE_PATH}/binding/target/${GROUP_ID}.${EDIFACT_RELEASE}-binding${SUFFIX}_${SMOOKS_VERSION}.jar does not exist"
	exit 1
fi

# Upload artifacts to repo (Credentials should be in ~/.m2/settings.xml)
mvn deploy:deploy-file -DgroupId=${GROUP_ID} \
-DartifactId=${EDIFACT_RELEASE}-mapping${SUFFIX} \
-Dversion=${SMOOKS_VERSION} \
-Dpackaging=jar \
-Dfile=mapping/target/${GROUP_ID}.${EDIFACT_RELEASE}-mapping${SUFFIX}_${SMOOKS_VERSION}.jar \
-Durl=${REPO_URL} \
-DrepositoryId=${REPO_ID}

mvn deploy:deploy-file -DgroupId=${GROUP_ID} \
-DartifactId=${EDIFACT_RELEASE}-binding${SUFFIX} \
-Dversion=${SMOOKS_VERSION} \
-Dpackaging=jar \
-Dfile=binding/target/${GROUP_ID}.${EDIFACT_RELEASE}-binding${SUFFIX}_${SMOOKS_VERSION}.jar \
-Durl=${REPO_URL} \
-DrepositoryId=${REPO_ID}

cd ../