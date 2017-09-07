package com.zenel.bluetoothconnectionlibrary;

import android.support.annotation.NonNull;

public class PeripheralManager implements Advertiser {
    private final Advertiser mAdvertiser;
    private final PeripheralLink mPeripheralLink;
    private boolean mAdvertising;

    public PeripheralManager() {
        mAdvertiser = new BluetoothLeAdvertiserDecorator();
        mPeripheralLink = new SmsPeripheralLink(new SmsGattServer());
    }

    public PeripheralManager(@NonNull Advertiser advertiser, @NonNull PeripheralLink peripheralLink) {
        mAdvertiser = advertiser;
        mPeripheralLink = peripheralLink;
    }

    @Override
    public void startAdvertising() {
        if (mAdvertising) {
            return;
        }
        mAdvertising = true;
        mAdvertiser.startAdvertising();
    }

    @Override
    public void stopAdvertising() {
        if (!mAdvertising) {
            return;
        }
        mAdvertising = false;
        mAdvertiser.stopAdvertising();
    }
}
