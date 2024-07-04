package com.example.employee_system.util;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;

public class NetworkUtil {
    public static String getServerIp() {
        InetAddress local = null;
        try {
            local = InetAddress.getLocalHost();
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }

        if (local == null) {
            return "";
        } else {
            return local.getHostAddress();
        }
    }

    public static String getLocalMacAddress() {
        String result = "";
        InetAddress ip;

        try {
            ip = InetAddress.getLocalHost();
            NetworkInterface network = NetworkInterface.getByInetAddress(ip);
            byte[] mac = network.getHardwareAddress();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < mac.length; i++) {
                sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));
            }
            result = sb.toString();
        } catch (UnknownHostException | SocketException e) {
            e.printStackTrace();
        }

        return result;
    }

}
