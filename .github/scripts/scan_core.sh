#!/bin/bash
set -x

CORE_DIR="/tmp/core"
CORE_OUTPUT=$(mktemp /tmp/debug.XXXXXX)
CORE_ARCHIVE=${GITHUB_WORKSPACE}/archives
CORE_ARCHIVE_DUMP=${CORE_ARCHIVE}/core_files

case $1 in
  init)
    mkdir ${CORE_ARCHIVE} ${CORE_DIR}
    if [ ! -e "${CORE_ARCHIVE}" ] || [ ! -e "${CORE_DIR}" ]; then
      echo "error: creating core archive"
      exit 2
    fi

    sudo bash -c 'echo '${CORE_DIR}'/%E.%p.core > /proc/sys/kernel/core_pattern'
    echo "set debuginfod enabled on" > ${HOME}/.gdbinit
  ;;
  inject-fail)
    # force hello unit test to hang for unit testing
    echo -e "#include <stdlib.h>\nint main(void) { while(1) {}; return 0;}" > ${GITHUB_WORKSPACE}/modules/tests-sos/test/unit/hello.c
  ;;
  scan)
    mkdir -p ${CORE_ARCHIVE} ${CORE_ARCHIVE_DUMP}

    if [ ! -e "${CORE_ARCHIVE}" ] || [ ! -e "${CORE_ARCHIVE_DUMP}" ]; then
      echo "error: creating core archive"
      exit 2
    fi

    core_list=$(find ${CORE_DIR} -name *.core -type f -printf '%f;')
    IFS=';'
    for core in ${core_list}
    do
      exe=$(echo ${core} | sed 's/\.[0-9]*\.core$//' | sed 's/\!/\//g')
      echo -e "\n---\nDumping core dump info for: ${exe}\n---\n" >> ${CORE_OUTPUT}
      gdb --batch -x ${GITHUB_WORKSPACE}/.github/scripts/gdb_dump_info.cmd -c ${CORE_DIR}/${core} ${exe} >> ${CORE_OUTPUT}
      # copy core file to artifact location
      core_file_demangled=$(echo ${CORE_DIR}/${core} | sed 's/\!/\//g')
      core_file=$(basename $core_file_demangled)
      cp ${CORE_DIR}/${core} ${CORE_ARCHIVE_DUMP}/${core_file}
    done

    if [ "${core_list}" == "" ]; then
      echo "notice: no core dumps found"
      exit 0
    fi

    cat ${CORE_OUTPUT}

    cd ${GITHUB_WORKSPACE}
    tar -cvzf ${CORE_ARCHIVE}/sos_test.tar.gz build
    cp ${CORE_OUTPUT} ${CORE_ARCHIVE}/output.txt
  ;;
  *)
    echo "error: invalid parameter specified"
    exit 1
  ;;
esac
