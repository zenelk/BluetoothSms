package com.zenel.bluetoothconnectionlibrary;

import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattServer;
import android.bluetooth.BluetoothGattService;
import android.support.annotation.NonNull;

import junit.framework.TestCase;

import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.any;
import static org.mockito.Mockito.atLeast;
import static org.mockito.Mockito.eq;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

public class SmsPeripheralLinkTest extends TestCase {
    @Mock
    private GattServer mGattServer;
    private SmsPeripheralLink mPeripheralLink;
    private BluetoothGattCharacteristic mCharacteristic;

    @Override
    public void setUp() throws Exception {
        super.setUp();
        MockitoAnnotations.initMocks(this);
        mPeripheralLink = new SmsPeripheralLink(mGattServer);
        mCharacteristic = new BluetoothGattCharacteristic(null, 0, 0);
    }

    @Override
    public void tearDown() throws Exception {
        super.tearDown();
        mGattServer = null;
        mPeripheralLink = null;
    }

    public void testServicesAreAddedOnCreation() throws Exception {
        verify(mGattServer, atLeast(1)).addService(any(BluetoothGattService.class));
    }

    public void testRemovingAStateChangeListenerThatIsNotAddedDoesNotThrowAnException() throws Exception {
        PeripheralLink.StateChangedListener listener = new PeripheralLink.StateChangedListener() {
            @Override
            public void onPeripheralLinkStateChanged(@NonNull PeripheralLink link, int newState) {
            }
        };
        mPeripheralLink.removeStateChangedListener(listener);
    }

    public void testListenerIsNotifiedWhenStateChanges() throws Exception {
        final int[] result = {-1};
        PeripheralLink.StateChangedListener listener = new PeripheralLink.StateChangedListener() {
            @Override
            public void onPeripheralLinkStateChanged(@NonNull PeripheralLink link, int newState) {
                result[0] = SmsPeripheralLink.STATE_CONNECTING;
            }
        };
        mPeripheralLink.addStateChangedListener(listener);
        mPeripheralLink.onConnectionStateChange(null, -1, BluetoothGattServer.STATE_CONNECTING);
        assertEquals(result[0], SmsPeripheralLink.STATE_CONNECTING);
    }


    public void testARemovedStateChangeListenerIsNotNotified() throws Exception {
        final int[] result = {-1};
        PeripheralLink.StateChangedListener listener = new PeripheralLink.StateChangedListener() {
            @Override
            public void onPeripheralLinkStateChanged(@NonNull PeripheralLink link, int newState) {
                result[0] = SmsPeripheralLink.STATE_CONNECTING;
            }
        };
        mPeripheralLink.addStateChangedListener(listener);
        mPeripheralLink.removeStateChangedListener(listener);
        mPeripheralLink.onConnectionStateChange(null, -1, BluetoothGattServer.STATE_CONNECTING);
        assertEquals(result[0], -1);
    }

    public void testStateChangedListenerIsNotifiedOnlyOnceIfAddedTwice() throws Exception {
        final List<Integer> results = new ArrayList<>();
        SmsPeripheralLink.StateChangedListener listener = new PeripheralLink.StateChangedListener() {
            @Override
            public void onPeripheralLinkStateChanged(@NonNull PeripheralLink link, int newState) {
                results.add(newState);
            }
        };
        mPeripheralLink.addStateChangedListener(listener);
        mPeripheralLink.addStateChangedListener(listener);
        mPeripheralLink.onConnectionStateChange(null, -1, BluetoothGattServer.STATE_CONNECTING);
        assertEquals(results.size(), 1);
    }

    public void testReceivingCompletedWriteNotifiesDataReceivedListeners() throws Exception {
        final List<Boolean> results = new ArrayList<>();
        PeripheralLink.ReceivedDataListener listener = new PeripheralLink.ReceivedDataListener() {
            @Override
            public void onPeripheralLinkReceivedData(@NonNull PeripheralLink link, @NonNull byte[] data) {
                results.add(true);
            }
        };
        byte[] data = new byte[0];
        mPeripheralLink.addReceivedDataListener(listener);
        mPeripheralLink.onCharacteristicWriteRequest(null, -1, mCharacteristic, false, false, 0, data);
        assertTrue(results.get(0));
    }

    public void testARemovedReceivedDataListenerIsNotNotified() throws Exception {
        final List<Boolean> results = new ArrayList<>();
        PeripheralLink.ReceivedDataListener listener = new PeripheralLink.ReceivedDataListener() {
            @Override
            public void onPeripheralLinkReceivedData(@NonNull PeripheralLink link, @NonNull byte[] data) {
                results.add(true);
            }
        };
        mPeripheralLink.addReceivedDataListener(listener);
        mPeripheralLink.removeReceivedDataListener(listener);
        byte[] data = new byte[0];
        mPeripheralLink.onCharacteristicWriteRequest(null, -1, mCharacteristic, false, false, 0, data);
        assertEquals(results.size(), 0);
    }

    public void testReceivedDataListenerIsNotifiedOnlyOnceIfAddedTwice() throws Exception {
        final List<Boolean> results = new ArrayList<>();
        PeripheralLink.ReceivedDataListener listener = new PeripheralLink.ReceivedDataListener() {
            @Override
            public void onPeripheralLinkReceivedData(@NonNull PeripheralLink link, @NonNull byte[] data) {
                results.add(true);
            }
        };
        mPeripheralLink.addReceivedDataListener(listener);
        mPeripheralLink.addReceivedDataListener(listener);
        byte[] data = new byte[0];
        mPeripheralLink.onCharacteristicWriteRequest(null, -1, mCharacteristic, false, false, 0, data);
        assertEquals(results.size(), 1);
    }

    public void testRespondsToWriteRequest() throws Exception {
        mPeripheralLink.onCharacteristicWriteRequest(null, -1, mCharacteristic, false, false, 0, new byte[0]);
        verify(mGattServer, times(1)).sendResponse(null, -1, 0, 0, new byte[0]);
    }

    public void testSendingDataWithAnEmptyQueueIsSentImmediatelyToGattServer() throws Exception {
        byte[] data = new byte[10];
        mPeripheralLink.sendData(data);
        verify(mGattServer, times(1)).writeCharacteristic(any(BluetoothGattCharacteristic.class), eq(data));
    }

    public void testQueuesDataWhenGattServerIsBusy() throws Exception {
        byte[] data = new byte[10];
        mPeripheralLink.sendData(data);
        mPeripheralLink.sendData(data);
        verify(mGattServer, times(1)).writeCharacteristic(any(BluetoothGattCharacteristic.class), eq(data));
    }

    public void testStateDefaultsToDisconnected() throws Exception {
        assertEquals(mPeripheralLink.getState(), SmsPeripheralLink.STATE_DISCONNECTED);
    }

    public void testStateIsUpdatedWhenStateChanges() throws Exception {
        mPeripheralLink.onConnectionStateChange(null, 0, SmsPeripheralLink.STATE_CONNECTING);
        assertEquals(mPeripheralLink.getState(), SmsPeripheralLink.STATE_CONNECTING);
    }
}
