package com.example.employee_system.util;

import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;

public class SystemUtil {
    public static double getCpuUsage() {
        com.sun.management.OperatingSystemMXBean osBean = (com.sun.management.OperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();
        // CPU 사용량을 퍼센트로 반환 (0.0 to 1.0 범위이므로 100을 곱하여 퍼센트로 변환)
        return osBean.getSystemCpuLoad() * 100;
    }

    public static double getMemoryUsage() {
        com.sun.management.OperatingSystemMXBean osBean = (com.sun.management.OperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();
        long totalMemorySize = osBean.getTotalPhysicalMemorySize();
        long freeMemorySize = osBean.getFreePhysicalMemorySize();
        long usedMemorySize = totalMemorySize - freeMemorySize;
        // 메모리 사용량을 MB 단위로 반환
        return usedMemorySize / (1024 * 1024);
    }
}
