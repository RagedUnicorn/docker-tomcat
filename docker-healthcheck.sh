#!/bin/sh

set -euo pipefail

if nc -z localhost 8080; then
	exit 0
fi

exit 1
