#!/bin/bash
# Executes howso-engine unit tests with GDB -- Linux/x86 only!
#
# usage: ./test_debug.sh test {engine-version}
#
####
set -e
set -u
# set -x

# Global Versions
amlg_version="0.0.0"
engine_version="0.0.0"

# root directory for git repository.
src_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")"/; pwd -P )

# root directory for build artifacts.
out_dir=${src_dir}/target
pkg_dir=${out_dir}/package
amlg_exe=${src_dir}/target/bin/amalgam-mt-afmi

# root directory for release artifacts.
rel_dir=${src_dir}/release

# set a timestamp
timestamp=$(date +%x_%H:%M)

# Get the Platform we are running the build on.
plat=$(uname | tr '[:upper:]' '[:lower:]')

# Get the Platform chipset architecture. 'amd64' or 'arm64'
arch=${ARCH:-$(uname -m | tr '[:upper:]' '[:lower:]')}
if [[ "$arch" = 'x86_64' ]]; then arch="amd64"; fi

test() {
  engine_version=${1:-'0.0.0'}
  echo "Testing Howso Engine version ${engine_version}..."

  check_amalgam_exe

  sudo apt-get install -y gdb
  echo "GDB installation complete"

  update_version_file ${engine_version}
  cd ${src_dir}/unit_tests
  echo "Running howso-engine unit tests with amalgam version \"${amlg_version}\"..."

  # Don't immediately fail if GDB exits with a non-zero code
  set +e

  # Capture GDB output (timeout 3 hours)
  gdb_output=$(gdb -batch -ex run -ex bt --args ${amlg_exe} ./ut_comprehensive_unit_test.amlg | tee /tmp/ut_results)
  gdb_exit_code=$?
  echo "$gdb_output" | tail -n 200
  echo "GDB exited with code $gdb_exit_code"
  echo "\n\n---- End GDB output ----\n\n"
  
  reset_version_file
  local ut_res=$(cat /tmp/ut_results | grep "PASSED : Total comprehensive test execution time" | wc -l)
  if [ $ut_res \< 1 ]; then
    cat /tmp/ut_results
    exit 81
  fi
}
