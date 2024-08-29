#! /bin/bash
# Copyright 2023 Google. All rights reserved.
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# A script that runs the graphical vivado tool from within the built container.

set -euo pipefail
set -x

INTERACTIVE=""
if sh -c ": >/dev/tty" >/dev/null 2>/dev/null; then
	# Only add these if running on actual terminal.
	INTERACTIVE="--interactive --tty"
fi

readonly VIVADO_PATH="/opt/Xilinx/Vivado/2020.1"

docker run \
  ${INTERACTIVE} \
  -u $(id -u):$(id -g) \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v "${PWD}:/work:rw" \
  -e DISPLAY="${DISPLAY}" \
  -e HOME="/work" \
  -e VIVADO_PATH="${VIVADO_PATH}" \
  --net=host \
  xilinx-vivado:latest  \
  /bin/bash -c \
    "env \
      LD_LIBRARY_PATH=${VIVADO_PATH}/lib/lnx64.o \
      ${VIVADO_PATH}/bin/setEnvAndRunCmd.sh vivado \
    "
