#!/bin/bash

# 从 /sys/fs/cgroup/cpu/cpu.cfs_quota_us 中读取 limitcpu_us 的值
limitcpu_us=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us);

# 检查 limitcpu_us 是否为空或小于1（如果为是，说明不存在limit cpu）
if [ -z ${limitcpu_us} ] || (( $(bc <<< "$limitcpu_us < 1") )); then
    # 设置 worker_processes 为 "auto"
    worker_processes="auto"
else
    # 如果 否，进行计算，并设置 worker_processes 的值
    # 使用数学运算符将 limitcpu_us 转换为 worker_processes 的值
    # 将 limitcpu_us 减去 1，然后除以 100000，最后加上 1
    worker_processes=$(( (limitcpu_us - 1) / 100000 + 1 ));
fi

echo "limitcpu_us: $limitcpu_us, worker_processes: $worker_processes" || true
# cat /etc/nginx/nginx.conf

### openresty配置 ###
sed -i 's/worker_processes 1/worker_processes '"$worker_processes"'/g' /etc/openresty/nginx.conf
