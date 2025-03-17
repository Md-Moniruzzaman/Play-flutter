# device_info

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


<!-- public static String getSN() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {

            String serial;

            try {

                @SuppressLint("PrivateApi") Class<?> c =Class.forName("android.os.SystemProperties");

                Method get =c.getMethod("get", String.class);

                serial = (String)get.invoke(c, "ro.sunmi.serial");

            } catch (Exception e) {

                serial = "Can not retrieve";

                e.printStackTrace();

            }

            return serial;

        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            return Build.getSerial();

        } else {

            return Build.SERIAL;

        }

    } -->
