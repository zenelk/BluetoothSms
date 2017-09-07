package com.zenel.bluetoothconnectionlibrary;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.support.annotation.NonNull;

import java.util.UUID;

/* package */ class SmsPeripheralLink extends PeripheralLink {

    private BluetoothGattCharacteristic mSmsReadCharacteristic;
    private BluetoothGattCharacteristic mSmsWriteCharacteristic;

    public SmsPeripheralLink(@NonNull GattServer gattServer) {
        super(gattServer);
    }

    public void sendData(@NonNull byte[] data) {
        writeValueToCharacteristic(mSmsWriteCharacteristic, data);
    }

    @Override
    protected void setUpServices() {
        BluetoothGattService smsService = new BluetoothGattService(UUID.fromString(BluetoothUUIDs.SERVICE_BLUETOOTH_SMS), BluetoothGattService.SERVICE_TYPE_PRIMARY);
        mSmsReadCharacteristic = new BluetoothGattCharacteristic(UUID.fromString(BluetoothUUIDs.CHARACTERISTIC_BLUETOOTH_SMS_READ),
                BluetoothGattCharacteristic.PROPERTY_NOTIFY | BluetoothGattCharacteristic.PROPERTY_READ,
                BluetoothGattCharacteristic.PERMISSION_READ);
        mSmsWriteCharacteristic = new BluetoothGattCharacteristic(UUID.fromString(BluetoothUUIDs.CHARACTERISTIC_BLUETOOTH_SMS_WRITE),
                BluetoothGattCharacteristic.PROPERTY_WRITE | BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE,
                BluetoothGattCharacteristic.PERMISSION_WRITE);
        smsService.addCharacteristic(mSmsReadCharacteristic);
        smsService.addCharacteristic(mSmsWriteCharacteristic);
        addService(smsService);
    }

    @Override
    public void onCharacteristicWriteRequest(BluetoothDevice device, int requestId, BluetoothGattCharacteristic characteristic, boolean preparedWrite, boolean responseNeeded, int offset, byte[] value) {
        super.onCharacteristicWriteRequest(device, requestId, characteristic, preparedWrite, responseNeeded, offset, value);
        respondToWriteRequest(device, requestId, BluetoothGatt.GATT_SUCCESS, 0, value);
    }
}
