using System;
using Windows.Devices.Bluetooth.Advertisement;
using BluetoothConnectionLibrary.Utils;

namespace BluetoothConnectionLibrary.Internal
{
    public class Scanner
    {
        private readonly BluetoothLEAdvertisementWatcher _watcher;
        private State _state;

        public Scanner()
        {
            _watcher = new BluetoothLEAdvertisementWatcher();
        }

        public State CurrentState
        {
            get { return _state; }
            set
            {
                _state = value;
                ChangedState?.Invoke(this, new ScannerChangedStateEventArgs(value));
            }
        }

        public event EventHandler<ScannerChangedStateEventArgs> ChangedState;
        public event EventHandler<EventArgs> Found;

        public enum State
        {
            Stopped,
            Running
        }

        public void Start()
        {
            _watcher.Received += WatcherOnReceived;
            _watcher.Stopped += WatcherOnStopped;
            _watcher.Start();
            CurrentState = State.Running;;
        }

        public void Stop()
        {
            _watcher.Received -= WatcherOnReceived;
            _watcher.Stop();
        }
        
        private void WatcherOnReceived(BluetoothLEAdvertisementWatcher sender, BluetoothLEAdvertisementReceivedEventArgs args)
        {
            ZLog.Log("Found something! " + args.Advertisement.LocalName);       
        }

        private void WatcherOnStopped(BluetoothLEAdvertisementWatcher sender, BluetoothLEAdvertisementWatcherStoppedEventArgs args)
        {
            _watcher.Stopped -= WatcherOnStopped;
            CurrentState = State.Stopped;
        }
    }

    public class ScannerChangedStateEventArgs : EventArgs
    {
        public Scanner.State State { get; }

        public ScannerChangedStateEventArgs(Scanner.State state)
        {
            State = state;
        }
    }
}
