using System.Diagnostics;

namespace BluetoothConnectionLibrary.Utils
{
    public static class ZLog
    {
        private const string LogTag = "[BluetoothConnectionLibrary] : ";

        public static void Log(string format, params object[] objs)
        {
            Log(LogTag, string.Format(format, objs));
        }

        public static void Log(string message)
        {
            Log(LogTag, message);
        }

        private static void Log(string tag, string message)
        {
            Debug.WriteLine(tag + message);
        }
    }
}
