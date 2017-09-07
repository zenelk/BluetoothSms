package com.zenel.bluetoothconnectionlibrary;

import junit.framework.TestCase;

import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.mockito.Mockito.*;

public class PeripheralManagerTest extends TestCase {
    @Mock
    private Advertiser mAdvertiser;
    @Mock
    private PeripheralLink mPeripheralLink;
    private PeripheralManager mPeripheralManager;

    @Override
    public void setUp() throws Exception {
        super.setUp();
        MockitoAnnotations.initMocks(this);
        mPeripheralManager = new PeripheralManager(mAdvertiser, mPeripheralLink);
    }

    @Override
    public void tearDown() throws Exception {
        super.tearDown();
        mAdvertiser = null;
        mPeripheralManager = null;
    }

    public void testStartAdvertisingStartsAdvertisingOnAdvertiser() throws Exception {
        mPeripheralManager.startAdvertising();
        verify(mAdvertiser, times(1)).startAdvertising();
    }

    public void testStopAdvertisingStopsAdvertisingOnAdvertiser() throws Exception {
        mPeripheralManager.startAdvertising();
        mPeripheralManager.stopAdvertising();
        verify(mAdvertiser, times(1)).stopAdvertising();
    }

    public void testStartingAdvertisingTwiceOnlyStartsAdvertisingOnceOnAdvertiser() throws Exception {
        mPeripheralManager.startAdvertising();
        mPeripheralManager.startAdvertising();
        verify(mAdvertiser, times(1)).startAdvertising();
    }

    public void testStoppingAdvertisingWhileAdvertisingIsNotRunningDoesNotStopAdvertisingOnAdvertiser() throws Exception {
        mPeripheralManager.stopAdvertising();
        verify(mAdvertiser, never()).stopAdvertising();
    }

    public void testAdvertisingCanBeRestartedAfterStopping() throws Exception {
        mPeripheralManager.startAdvertising();
        mPeripheralManager.stopAdvertising();
        mPeripheralManager.startAdvertising();
        verify(mAdvertiser, times(2)).startAdvertising();
    }
}
