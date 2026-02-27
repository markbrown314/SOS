#!/bin/bash

if [ ! -d modules ]; then
    echo "Error: make sure you run this in the SOS base directory"
    exit 1
fi

install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/apps/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/include/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/performance/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/shmemx/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/spec-example/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/unit/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/performance/shmem_perf_suite/Makefile.am
install -Dv scripts/remove-tests-sos-dep.am modules/tests-sos/test/performance/tests/Makefile.am
