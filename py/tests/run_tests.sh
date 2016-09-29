#!/bin/bash
set -eu
here="$(dirname $0)"

echo "=== SMOKE TEST"
PYTHONPATH=$here/.. python $here/smoketest.py 

