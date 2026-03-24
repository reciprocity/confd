#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

run_test() {
  local test_script="$1"
  echo "--- Running $test_script"
  bash "$test_script"
  bash test/integration/expect/check.sh
  rm -f /tmp/confd-*
}

run_test test/integration/env/test.sh

run_test test/integration/file/test_yaml.sh
run_test test/integration/file/test_json.sh

run_test test/integration/consul/test.sh
run_test test/integration/etcd/test.sh
run_test test/integration/dynamodb/test.sh
run_test test/integration/redis/test.sh
run_test test/integration/ssm/test.sh
run_test test/integration/vault-v1/test.sh
run_test test/integration/vault-v2/test.sh
run_test test/integration/vault-approle/test.sh
run_test test/integration/zookeeper/test.sh

echo "All integration tests passed."
