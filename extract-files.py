#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2026 The PixelOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Regenerates vendor/xiaomi/sm8550-common-dolby from a fuxi ROM dump:
#
#     ./extract-files.py /path/to/dump        # dumpyara output
#     ./extract-files.py rom.zip              # untouched OTA
#
# Run from this directory. The generated files land in the sibling vendor repo.
#
# Notes on the generated output, kept here because Android.bp is rewritten on
# every run and any comments added to it would be lost:
#
#  * Every blob is installed as a cc_prebuilt_library_shared or
#    cc_prebuilt_binary rather than through PRODUCT_COPY_FILES. Android 17
#    rejects ELF files in PRODUCT_COPY_FILES with
#    "found ELF prebuilt in PRODUCT_COPY_FILES, use cc_prebuilt_binary /
#    cc_prebuilt_library_shared instead".
#
#  * shared_libs is derived from each blob's DT_NEEDED table, and Soong checks
#    that the two agree. Do not prune the list by hand.
#
#  * relative_install_path is derived from the blob's on-device directory, so
#    vendor.dolby.media.c2@1.0-service and vendor.dolby.hardware.dms@2.0-service
#    install to /vendor/bin/hw. This is load bearing: their rc files exec
#    /vendor/bin/hw/<name>, and if the binaries land in /vendor/bin instead,
#    init cannot start them, IComponentStore/default1 never registers, and
#    cameraserver blocks forever in MediaCodecList::getCodecList().
#
# The Dolby Vision video blobs (dolbycodec2, c2.dolby.*, libdolbyottcameracontrol)
# are deliberately absent: they belong to device/xiaomi/fuxi-miuicamera.
#

from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/xiaomi/sm8550-common-dolby',
    'device/xiaomi/sm8550-common',
    'hardware/qcom-caf/sm8550',
    'hardware/xiaomi',
    'vendor/xiaomi/sm8550-common',
]

# The blobs are byte-identical to the stock image, so no fixups are needed.
# If a future ROM changes one of them, add the fixup here rather than editing
# the generated Android.bp.
lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
}

module = ExtractUtilsModule(
    'sm8550-common-dolby',
    'xiaomi',
    blob_fixups={},
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
