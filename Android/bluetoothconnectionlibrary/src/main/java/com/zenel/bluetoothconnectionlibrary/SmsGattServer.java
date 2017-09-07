package com.zenel.bluetoothconnectionlibrary;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.support.annotation.NonNull;

public class SmsGattServer implements GattServer {
    @Override
    public void addService(@NonNull BluetoothGattService service) {

    }

    @Override
    public void writeCharacteristic(@NonNull BluetoothGattCharacteristic characteristic, @NonNull byte[] value) {

    }

    @Override
    public void sendResponse(@NonNull BluetoothDevice device, int requestId, int status, int offset, @NonNull byte[] value) {

    }
}
