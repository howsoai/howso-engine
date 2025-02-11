#!/bin/bash
# Linux build scripts for howso-engine release cycle - build/test/package
#
# usage: ./build/build.sh build|test|package
#
####
set -e
set -u
# set -x

# Global Versions
amlg_version="0.0.0"
engine_version="0.0.0"

# root directory for git repository.
src_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")"/..; pwd -P )

# root directory for build artifacts.
out_dir=${src_dir}/target
pkg_dir=${out_dir}/package
amlg_exe=${src_dir}/target/bin/amalgam-mt

# root directory for release artifacts.
rel_dir=${src_dir}/release

# set a timestamp
timestamp=$(date +%x_%H:%M)

# Get the Platform we are running the build on.
plat=$(uname | tr '[:upper:]' '[:lower:]')

# Get the Platform chipset architecture. 'amd64' or 'arm64'
arch=${ARCH:-$(uname -m | tr '[:upper:]' '[:lower:]')}
if [[ "$arch" = 'x86_64' ]]; then arch="amd64"; fi

build() {
  engine_version=${1:-'0.0.0'}
  check_amalgam_exe
  echo "Building Howso Engine version \"${engine_version}\" with amalgam version \"${amlg_version}\"..."
  update_version_file ${engine_version}

  cd ${src_dir}
  rm -f howso.caml
  rm -f trainee_template.caml
  rm -f migrations.caml

  # make local user dev/engine directory.
  mkdir -p ~/.howso/lib/dev/engine
  mkdir -p ~/.howso/lib/dev/engine/migrations

  # make package output directory.
  mkdir -p ${pkg_dir}/

  # Create howso artifact:
  "${amlg_exe}" deploy_howso.amlg
  if [ ! -f ~/.howso/lib/dev/engine/howso.caml ]; then
    echo "No caml files built - howso engine build failed"
    exit 76
  fi
  cp -r ~/.howso/lib/dev/engine/* ${pkg_dir}/
}

test() {
  engine_version=${1:-'0.0.0'}
  echo "Testing Howso Engine version ${engine_version}..."

  arm_ver=${2:-''}
  if [[ "$arm_ver" == "arm64_8a" ]]; then
    amlg_exe=${src_dir}/target/bin/amalgam-st
  fi
  check_amalgam_exe

  update_version_file ${engine_version}
  cd ${src_dir}/unit_tests
  echo "Running howso-engine unit tests with amalgam version \"${amlg_version}\"..."
  "${amlg_exe}" --debug-internal-memory ./ut_comprehensive_unit_test.amlg | tee /tmp/ut_results
  reset_version_file
  local ut_res=$(cat /tmp/ut_results | grep "PASSED : Total comprehensive test execution time" | wc -l)
  if [ $ut_res \< 1 ]; then
    cat /tmp/ut_results
    exit 81
  fi
}

performance_test() {
  engine_version=${1:-'0.0.0'}
  echo "Performance testing Howso Engine version ${engine_version}..."

  arm_ver=${2:-''}
  if [[ "$arm_ver" == "arm64_8a" ]]; then
    amlg_exe="${src_dir}/target/bin/amalgam-st"
  fi
  check_amalgam_exe

  update_version_file ${engine_version}
  echo "Running howso-engine performance tests with amalgam version \"${amlg_version}\"..."
  "${amlg_exe}" ./run_performance_tests.amlg | tee /tmp/pt_results
  reset_version_file
  local pt_res=$(cat /tmp/pt_results | grep "PASSED : Total comprehensive test execution time" | wc -l)
  if [ "$pt_res" \< 1 ]; then
    cat /tmp/pt_results
    exit 81
  fi
}

build_test() {
  engine_version=${1:-'0.0.0'}

  # build, test
  build ${engine_version}
  test ${engine_version}
  reset_version_file
}

build_test_package() {
  engine_version=${1:-'0.0.0'}

  # build, test, package.
  build ${engine_version}
  test ${engine_version}
  package ${engine_version}

  # reset version.json
  reset_version_file
}

build_package() {
  engine_version=${1:-'0.0.0'}

  # build, package.
  build ${engine_version}
  package ${engine_version}

  # reset version.json
  reset_version_file
}

update_version_file() {
  engine_version=${1:-'0.0.0'}
  echo "Updating version.json with: \"version\": \"${engine_version}\", amalgam=\"${amlg_version}\""

  cd  ${src_dir}
  git checkout version.json

  temp_file=${src_dir}/version.json.orig
  cp ${src_dir}/version.json $temp_file
  jq ". | .version=\"${engine_version}\"" ${temp_file} > ${temp_file}.tmp && mv ${temp_file}.tmp ${temp_file}
  jq ". | .dependencies.amalgam=\"${amlg_version}\"" ${temp_file} > ${src_dir}/version.json
  rm ${temp_file}
  cat ${src_dir}/version.json
  echo 'Done updating version.json'
}

reset_version_file() {
  cd  ${src_dir}
  git checkout version.json
}

check_amalgam_exe() {
  # Check if the amalgam binary exists. If not, warn user to download
  # a proper version and locate it at howso-engine/target/bin/amalgam
  if [[ ! -x "$amlg_exe" ]]; then
    echo "${amlg_exe} does not exist. Download a proper amalgam binary."
    exit 146
  fi
  amlg_version=$("$amlg_exe" --version)
}

package() {
  echo "Archiving, Compressing, Encrypting howso directory"
  engine_version=${1}

  if [ -f ${src_dir}/version.json ]; then
    # use jq to replace version and put output into package directory.
    jq ". | .version=\"${engine_version}\"" ${src_dir}/version.json > ${pkg_dir}/version.json
  fi

  cd ${pkg_dir}/
  tar -zcvf ${out_dir}/howso-engine-${engine_version}.tar.gz ./
}

# Run the function matching the first cmd line argument - if there are 0 args, then run build.
if [[ $# -eq 0 ]] ; then
    build $engine_version
fi
"$@"
