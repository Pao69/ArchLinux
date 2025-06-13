#!/bin/bash

# Try NVIDIA first
if command -v nvidia-smi &> /dev/null; then
    usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1)
    echo "${usage}"
    exit 0
fi

# Try AMD with radeontop
if command -v radeontop &> /dev/null; then
    usage=$(radeontop -d - -l 1 | grep -oP 'gpu \K[0-9.]+(?=%)')
    echo "${usage}"
    exit 0
fi

# Try AMD/Intel (kernel exposes busy percent)
if [ -f /sys/class/drm/card0/device/gpu_busy_percent ]; then
    usage=$(cat /sys/class/drm/card0/device/gpu_busy_percent)
    echo "${usage}"
    exit 0
fi

# Try intel_gpu_top (Intel)
if command -v intel_gpu_top &> /dev/null; then
    usage=$(timeout 1s intel_gpu_top -J | grep -oP '"busy":\K[0-9]+')
    echo "${usage}"
    exit 0
fi

echo "N/A" 