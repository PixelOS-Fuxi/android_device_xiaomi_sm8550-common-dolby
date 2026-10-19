#
# Copyright (C) 2026 The PixelOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Dolby audio stack for fuxi (Xiaomi 13, SM8550).
#
# This tree carries only the *audio* half of the Dolby stack. The Dolby Vision
# video components (dolbycodec2, c2.dolby.hevc.*, c2.dolby.store) stay in
# device/xiaomi/fuxi-miuicamera, because they are only reachable through MIUI
# Camera and their Codec2 declarations live next to the camera blobs.
#
# IMPORTANT: audio_effects.xml is owned by device/xiaomi/sm8550-common.
# Do not add a PRODUCT_COPY_FILES entry for it here. The Dolby library and
# effect entries are already merged into
# device/xiaomi/sm8550-common/configs/audio/sku_kalama/audio_effects.xml,
# alongside the ViPER4Android entries. That copy is deliberately taken from
# the device tree rather than from the primary-hal repo, so a repo sync cannot
# revert the merge. A second copy rule would silently clobber one of the two.

DOLBY_PATH := device/xiaomi/sm8550-common-dolby

# Properties
TARGET_ODM_PROP += $(DOLBY_PATH)/dolby.prop

# Dolby DMS (audio post-processing service) VINTF declaration
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DOLBY_PATH)/configs/vintf/framework_matrix_dolby_audio.xml

# SELinux policy
BOARD_VENDOR_SEPOLICY_DIRS += $(DOLBY_PATH)/sepolicy/vendor

# Init scripts
# dolbycodec2.rc is NOT here: dolbycodec2 is the Dolby Vision video store and
# both the binary and its init script are owned by device/xiaomi/fuxi-miuicamera.
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/init/vendor.dolby.hardware.dms@2.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.dolby.hardware.dms@2.0-service.rc \
    $(DOLBY_PATH)/configs/init/vendor.dolby.media.c2@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.dolby.media.c2@1.0-service.rc

# Device manifest fragments:
#   - vendor.dolby.hardware.dms IDms/default
#   - android.hardware.media.c2 IComponentStore/default1 (Dolby audio decoders)
DEVICE_MANIFEST_FILE += \
    $(DOLBY_PATH)/configs/vintf/vendor.dolby.hardware.dms.xml \
    $(DOLBY_PATH)/configs/vintf/c2_manifest_dolby_audio.xml

# Dolby audio decoders (AC3 / EAC3 / EAC3-JOC / AC4)
PRODUCT_COPY_FILES += \
    $(DOLBY_PATH)/configs/media/media_codecs_dolby_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_dolby_audio.xml

# Proprietary files
$(call inherit-product, vendor/xiaomi/sm8550-common-dolby/sm8550-common-dolby-vendor.mk)
