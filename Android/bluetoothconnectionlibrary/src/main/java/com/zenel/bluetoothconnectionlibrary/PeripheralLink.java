package com.zenel.bluetoothconnectionlibrary;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattServer;
import android.bluetooth.BluetoothGattServerCallback;
import android.bluetooth.BluetoothGattService;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

public abstract class PeripheralLink extends BluetoothGattServerCallback {
    public static final int STATE_CONNECTING = BluetoothGattServer.STATE_CONNECTING;
    public static final int STATE_CONNECTED = BluetoothGattServer.STATE_CONNECTED;
    public static final int STATE_DISCONNECTING = BluetoothGattServer.STATE_DISCONNECTING;
    public static final int STATE_DISCONNECTED = BluetoothGattServer.STATE_DISCONNECTED;
    private static final int BLE_MAX_PACKET_SIZE = 20;

    private final GattServer mGattServer;
    private final List<StateChangedListener> mStateChangedListeners = new ArrayList<>();
    private final List<ReceivedDataListener> mReceivedDataListeners = new ArrayList<>();
    private final List<CharacteristicWrite> mQueuedWrites = new ArrayList<>();
    private boolean mQueueStarted;
    private int mState = STATE_DISCONNECTED;

    protected abstract void setUpServices();

    public PeripheralLink(@NonNull GattServer gattServer) {
        mGattServer = gattServer;
        setUpServices();
    }

    public void writeValueToCharacteristic(@NonNull BluetoothGattCharacteristic characteristic, @NonNull byte[] data) {
        int offset = 0;
        List<CharacteristicWrite> writes = new ArrayList<>();
        while (offset < data.length) {
            int length = BLE_MAX_PACKET_SIZE;
            if (offset + length >= data.length) {
                length = data.length - offset;
            }
            byte[] chunk = new byte[length];
            System.arraycopy(data, offset, chunk, 0, length);
            writes.add(new CharacteristicWrite(characteristic, chunk));
            offset += length;
        }
        synchronized (mQueuedWrites) {
            mQueuedWrites.addAll(writes);
            if (!mQueueStarted) {
                sendNext();
            }
        }
    }

    protected final void addService(@NonNull BluetoothGattService service) {
        mGattServer.addService(service);
    }

    protected final void respondToWriteRequest(@NonNull BluetoothDevice device, int requestId, int status, int offset, @NonNull byte[] value) {
        mGattServer.sendResponse(device, requestId, status, offset, value);
    }

    private void sendNext() {
        CharacteristicWrite write;
        synchronized (mQueuedWrites) {
            if (mQueuedWrites.size() < 1) {
                mQueueStarted = false;
                return;
            }
            mQueueStarted = true;
            write = mQueuedWrites.remove(0);
        }
        mGattServer.writeCharacteristic(write.getCharacteristic(), write.getData());
    }

    private void notifyListenersOfStateChange(int newState) {
        for (StateChangedListener listener : mStateChangedListeners) {
            listener.onPeripheralLinkStateChanged(this, newState);
        }
    }

    public final void addStateChangedListener(@NonNull StateChangedListener listener) {
        if (mStateChangedListeners.contains(listener)) {
            return;
        }
        mStateChangedListeners.add(listener);
    }

    public final void removeStateChangedListener(@NonNull StateChangedListener listener) {
        mStateChangedListeners.remove(listener);
    }

    public final void addReceivedDataListener(@NonNull ReceivedDataListener listener) {
        if (mReceivedDataListeners.contains(listener)) {
            return;
        }
        mReceivedDataListeners.add(listener);
    }

    public final void removeReceivedDataListener(@NonNull ReceivedDataListener listener) {
        mReceivedDataListeners.remove(listener);
    }

    @Override
    public void onConnectionStateChange(BluetoothDevice device, int status, int newState) {
        super.onConnectionStateChange(device, status, newState);
        setState(newState);
    }

    @Override
    public void onCharacteristicWriteRequest(BluetoothDevice device, int requestId, BluetoothGattCharacteristic characteristic, boolean preparedWrite, boolean responseNeeded, int offset, byte[] value) {
        super.onCharacteristicWriteRequest(device, requestId, characteristic, preparedWrite, responseNeeded, offset, value);
        notifyListenersOfDataReceived(value);
    }

    public final int getState() {
        return mState;
    }

    private void setState(int newState) {
        mState = newState;
        notifyListenersOfStateChange(newState);
    }

    private void notifyListenersOfDataReceived(@NonNull byte[] value) {
        for (ReceivedDataListener listener : mReceivedDataListeners) {
            listener.onPeripheralLinkReceivedData(this, value);
        }
    }

    private class CharacteristicWrite {
        private BluetoothGattCharacteristic mCharacteristic;
        private byte[] mData;

        public CharacteristicWrite(@NonNull BluetoothGattCharacteristic characteristic, @NonNull byte[] data) {
            mCharacteristic = characteristic;
            mData = data;
        }

        public BluetoothGattCharacteristic getCharacteristic() {
            return mCharacteristic;
        }

        public byte[] getData() {
            return mData;
        }
    }

    interface StateChangedListener {
        void onPeripheralLinkStateChanged(@NonNull PeripheralLink link, int newState);
    }

    interface ReceivedDataListener {
        void onPeripheralLinkReceivedData(@NonNull PeripheralLink link, @NonNull byte[] data);
    }
}
