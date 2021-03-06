#!/bin/sh

# RunUnitTests.sh
#
# Copyright (c) 2007-2009 Google Inc. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
# * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# Build all of our SDK Projects just to verify that we don't break them.

set -o errexit
set -o nounset
set -o verbose

# If QSBSRCROOT isn't set, then we'll make it relative to our current SRCROOT.
QSBSRCROOT=${QSBSRCROOT:="${SRCROOT}/../"}

cd "${SRCROOT}/SDK/Templates/QSBAppleScriptPlugin"
xcodebuild -project "___PROJECTNAME___.xcodeproj" -target "___PROJECTNAME___" -configuration "${CONFIGURATION}" OBJROOT="${OBJROOT}" SYMROOT="${SYMROOT}" CACHE_ROOT="${CACHE_ROOT}" QSBSRCROOT="${QSBSRCROOT}" || true
cd "${SRCROOT}/SDK/Templates/QSBPlugin"
xcodebuild -project "___PROJECTNAME___.xcodeproj" -target "___PROJECTNAME___" -configuration "${CONFIGURATION}" OBJROOT="${OBJROOT}" SYMROOT="${SYMROOT}" CACHE_ROOT="${CACHE_ROOT}" QSBSRCROOT="${QSBSRCROOT}"  || true
cd "${SRCROOT}/SDK/Templates/QSBPythonPlugin"
xcodebuild -project "___PROJECTNAME___.xcodeproj" -target "___PROJECTNAME___" -configuration "${CONFIGURATION}" OBJROOT="${OBJROOT}" SYMROOT="${SYMROOT}" CACHE_ROOT="${CACHE_ROOT}" QSBSRCROOT="${QSBSRCROOT}"  || true
