#!/bin/sh

echo 1 | tee /sys/devices/system/cpu/cpu*/cpuidle/state1/disable >/dev/null
echo 1 | tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable >/dev/null  
echo 1 | tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable >/dev/null

cat /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq
