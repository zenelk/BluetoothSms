package com.zenel.bluetoothconnectionlibrary;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.support.annotation.NonNull;

/* package */ interface GattServer {
    void addService(@NonNull BluetoothGattService service);
    void writeCharacteristic(@NonNull BluetoothGattCharacteristic characteristic, @NonNull byte[] value);
    void sendResponse(@NonNull BluetoothDevice device, int requestId, int status, int offset, @NonNull byte[] value);
}