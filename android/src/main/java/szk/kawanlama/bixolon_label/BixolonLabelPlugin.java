package szk.kawanlama.bixolon_label;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbManager;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.bixolon.commonlib.BXLCommonConst;
import com.bixolon.commonlib.common.BXLFileHelper;
import com.bixolon.commonlib.connectivity.searcher.BXLUsbDevice;
import com.bixolon.commonlib.log.LogService;
import com.bixolon.labelprinter.BixolonLabelPrinter;

import java.util.Set;

/**
 * BixolonLabelPlugin
 */
public class BixolonLabelPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private BixolonLabelPrinter mBixolonLabelPrinter;
    private Context context;
    private PendingIntent mPermissionIntent;
    private final String ACTION_USB_PERMISSION = "com.android.example.USB_PERMISSION";
    private UsbManager usbManager;
    private final int vendorId = 5380;

    static {
        try {
            System.loadLibrary("bxl_common");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bixolon_label");
        channel.setMethodCallHandler(this);
        this.context = flutterPluginBinding.getApplicationContext();
        this.mBixolonLabelPrinter = new BixolonLabelPrinter(this.context);
        BXLUsbDevice.refreshUsbDevicesList(this.context);
        usbManager = (UsbManager) context.getSystemService(Context.USB_SERVICE);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            mPermissionIntent = PendingIntent.getBroadcast(this.context, 0,
                    new Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
        } else {
            mPermissionIntent = PendingIntent.getBroadcast(this.context, 0,
                    new Intent(ACTION_USB_PERMISSION), PendingIntent.FLAG_UPDATE_CURRENT);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "connectIp":
                final String ipAddress = call.argument("ipAddress");
                this.mBixolonLabelPrinter.connect(ipAddress, 9100, 5000);
                result.success(this.mBixolonLabelPrinter.isConnected());
                break;
            case "printText":
                try {
                    final String data = call.argument("text");
                    this.mBixolonLabelPrinter.beginTransactionPrint();
                    this.mBixolonLabelPrinter.drawText(data, 50, 50, 51, 1, 1, 0, 0, false, false, 48);
                    this.mBixolonLabelPrinter.print(1, 1);
                    this.mBixolonLabelPrinter.endTransactionPrint();
                    result.success("success print data");
                } catch (Exception e) {
                    result.success(e.getMessage());
                }
                break;
            case "printImage":
                final byte[] byteData = call.argument("byteData");
                final int horizontalStartPosition = call.argument("horizontalPosition");
                final int verticalStartPosition = call.argument("verticalPosition");
                final int width = call.argument("width");
                final int level = call.argument("level");
                final boolean dithering = call.argument("dithering");

                BitmapFactory.Options options = new BitmapFactory.Options();
                options.inMutable = true;
                Bitmap bmp = BitmapFactory.decodeByteArray(byteData, 0, byteData.length, options);
                this.mBixolonLabelPrinter.beginTransactionPrint();
                this.mBixolonLabelPrinter.drawBitmap(bmp, horizontalStartPosition, verticalStartPosition, width, level, dithering);
                this.mBixolonLabelPrinter.print(1, 1);
                this.mBixolonLabelPrinter.endTransactionPrint();
                result.success("success print image");
                break;
            case "disconnect":
                try {
                    this.mBixolonLabelPrinter.disconnect();
                    result.success(true);
                } catch (Exception e) {
                    result.success(false);
                }
                break;
            case "isConnected":
                result.success(this.mBixolonLabelPrinter.isConnected());
                break;
            case "connectUsb":
                try {
                    final Set<UsbDevice> usbDevice = BXLUsbDevice.getUsbPrinters();
                    if (usbDevice.size() > 0) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                            final UsbDevice stickerPrinter = usbDevice.stream().findFirst().get();
                            final String deviceName = stickerPrinter.getDeviceName();
                            if (!usbManager.hasPermission(stickerPrinter)) {
                                usbManager.requestPermission(stickerPrinter, mPermissionIntent);
                            }
                            this.mBixolonLabelPrinter.connect(stickerPrinter, deviceName);
                        }
                        result.success(this.mBixolonLabelPrinter.isConnected());
                    }
                } catch (Exception e) {
                    result.success(false);
                }
                break;
            case "requestUsbPermission":
                try {
                    final Set<UsbDevice> usbDevice = BXLUsbDevice.getUsbPrinters();
                    if (usbDevice.size() > 0) {
                        final UsbDevice device;
                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                            device = usbDevice.stream().filter(value -> value.getVendorId() == vendorId).findFirst().orElse(null);
                            if (device != null && !usbManager.hasPermission(device)) {
                                usbManager.requestPermission(device, mPermissionIntent);
                            }
                        }
                    }
                    result.success("success");
                } catch (Exception e) {
                    result.success("failed" + e.getMessage());
                }
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
