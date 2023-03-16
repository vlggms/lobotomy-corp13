#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
mkdir ci_test/config

#test config
cp tools/ci/ci_config.txt ci_test/config/config.txt
#so that we get the right default map
cp tools/ci/ci_maps.txt ci_test/config/maps.txt

cd ci_test
DreamDaemon lobotomy-corp13.dmb -close -trusted -verbose -params "log-directory=ci"
cd ..
cat ci_test/data/logs/ci/clean_run.lk
