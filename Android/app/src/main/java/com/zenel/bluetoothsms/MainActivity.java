package com.zenel.bluetoothsms;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.widget.Toast;

import com.zenel.bluetoothconnectionlibrary.PeripheralManager;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends Activity {
    private static final String[] PERMISSIONS_TO_MANAGE = new String[] {
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.BLUETOOTH,
            Manifest.permission.BLUETOOTH_ADMIN
    };
    private static final int PERMISSION_REQUEST_ID = 0;

    private final PeripheralManager mPeripheralManager = new PeripheralManager();

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_ID) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                mPeripheralManager.startAdvertising();
            }
            else {
                Toast.makeText(this, "Yo homeboy, one of your permission was denied. You suck.", Toast.LENGTH_LONG).show();
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            checkPermissions();
        }
        else {
            mPeripheralManager.startAdvertising();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        mPeripheralManager.stopAdvertising();
    }

    @TargetApi(Build.VERSION_CODES.M)
    private void checkPermissions() {
        List<String> permissionsToRequest = new ArrayList<>();
        for (String permission : PERMISSIONS_TO_MANAGE) {
            if (checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED) {
                permissionsToRequest.add(permission);
            }
        }
        if (permissionsToRequest.size() == 0) {
            mPeripheralManager.startAdvertising();
        }
        else {
            requestPermissions(PERMISSIONS_TO_MANAGE, PERMISSION_REQUEST_ID);
        }
    }
}
