package com.iksem.ui.bluetooth;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;

import com.google.android.material.button.MaterialButton;
import com.iksem.databinding.FragmentBluetoothBinding;

import java.util.HashSet;

public class BluetoothFragment extends Fragment implements View.OnClickListener {

    private FragmentBluetoothBinding binding;
    LinearLayout bluetoothPermissionWarning;
    MaterialButton bluetoothRefresh;
    public static ActivityResultLauncher<String[]> bluetoothGpsPermissionRequestLauncher;
    public static boolean bluetoothGpsPermissionGranted = false;
    BluetoothAdapter bluetoothAdapter;
    public HashSet<BluetoothDevice> btDevices = new HashSet<>();
    public DeviceListAdapter deviceListAdapter;
    RecyclerView bluetoothDiscoveredDevicesList;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = FragmentBluetoothBinding.inflate(inflater, container, false);
        View root = binding.getRoot();

        bluetoothPermissionWarning = binding.bluetoothPermissionWarning;
        bluetoothPermissionWarning.setOnClickListener(view -> bluetoothGpsPermissionsRequest());

        bluetoothRefresh = binding.bluetoothRefreshButton;
        bluetoothRefresh.setOnClickListener(this);

        bluetoothDiscoveredDevicesList = binding.bluetoothDiscoveredDevicesList;

        bluetoothGpsPermissionRequestLauncher = registerForActivityResult(new ActivityResultContracts.RequestMultiplePermissions(), result -> {

            boolean areAllGranted = true;
            for (Boolean b : result.values()) {
                areAllGranted = areAllGranted && b;
            }

            if (areAllGranted) {
                bluetoothGpsPermissionGranted = true;
                bluetoothPermissionWarning.setVisibility(View.GONE);
                bluetoothRefresh.setVisibility(View.VISIBLE);
                //TODO: turn on geolocation
                Log.i("permissions", "Bluetooth permission granted");
            } else {
                bluetoothGpsPermissionGranted = false;
                bluetoothPermissionWarning.setVisibility(View.VISIBLE);
                bluetoothRefresh.setVisibility(View.GONE);
                Log.i("permissions", "Bluetooth permission not granted");
            }
        });

        bluetoothGpsPermissionsRequest();
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        return root;
    }

    @Override
    public void onDestroyView() {

        super.onDestroyView();
        binding = null;
        requireActivity().unregisterReceiver(broadcastReceiver1);
        requireActivity().unregisterReceiver(broadcastReceiver2);
        requireActivity().unregisterReceiver(broadcastReceiver3);
    }

    private final BroadcastReceiver broadcastReceiver1 = new BroadcastReceiver() {
        public void onReceive(Context context, Intent intent) {

            String action = intent.getAction();
            assert action != null;
            if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {

                final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);

                switch (state) {
                    case BluetoothAdapter.STATE_OFF:
                        Log.i("broadcastReceiver1", "onReceive: STATE OFF");
                        break;
                    case BluetoothAdapter.STATE_TURNING_OFF:
                        Log.i("broadcastReceiver1", "broadcastReceiver1: STATE TURNING OFF");
                        break;
                    case BluetoothAdapter.STATE_ON:
                        Log.i("broadcastReceiver1", "broadcastReceiver1: STATE ON");
                        break;
                    case BluetoothAdapter.STATE_TURNING_ON:
                        Log.i("broadcastReceiver1", "broadcastReceiver1: STATE TURNING ON");
                        break;
                }
            }
        }
    };

    private final BroadcastReceiver broadcastReceiver2 = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {

            final String action = intent.getAction();

            assert action != null;
            if (action.equals(BluetoothAdapter.ACTION_SCAN_MODE_CHANGED)) {

                int mode = intent.getIntExtra(BluetoothAdapter.EXTRA_SCAN_MODE, BluetoothAdapter.ERROR);

                switch (mode) {
                    case BluetoothAdapter.SCAN_MODE_CONNECTABLE_DISCOVERABLE:
                        Log.i("broadcastReceiver2", "broadcastReceiver2: Discoverability Enabled.");
                        break;
                    case BluetoothAdapter.SCAN_MODE_CONNECTABLE:
                        Log.i("broadcastReceiver2", "broadcastReceiver2: Discoverability Disabled. Able to receive connections.");
                        break;
                    case BluetoothAdapter.SCAN_MODE_NONE:
                        Log.i("broadcastReceiver2", "broadcastReceiver2: Discoverability Disabled. Not able to receive connections.");
                        break;
                    case BluetoothAdapter.STATE_CONNECTING:
                        Log.i("broadcastReceiver2", "broadcastReceiver2: Connecting....");
                        break;
                    case BluetoothAdapter.STATE_CONNECTED:
                        Log.i("broadcastReceiver2", "broadcastReceiver2: Connected.");
                        break;
                }

            }
        }
    };

    private final BroadcastReceiver broadcastReceiver3 = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            final String action = intent.getAction();
            Log.i("broadcastReceiver3", "onReceive: ACTION FOUND.");

            assert action != null;
            if (action.equals(BluetoothDevice.ACTION_FOUND)) {
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                btDevices.add(device);
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
                    if (ActivityCompat.checkSelfPermission(requireActivity(), Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED) {
                        bluetoothGpsPermissionsRequest();
                        return;
                    } else if (ActivityCompat.checkSelfPermission(requireActivity(), Manifest.permission.BLUETOOTH) != PackageManager.PERMISSION_GRANTED) {
                        bluetoothGpsPermissionsRequest();
                        return;
                    }
                assert device != null;
                Log.i("broadcastReceiver3", "onReceive: " + device.getName() + ": " + device.getAddress());
                deviceListAdapter = new DeviceListAdapter(context, btDevices);
                bluetoothDiscoveredDevicesList.setAdapter(deviceListAdapter);
            }
        }
    };

    @Override
    public void onClick(View view) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            if (ActivityCompat.checkSelfPermission(requireActivity(), Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED) {
                bluetoothGpsPermissionsRequest();
                return;
            } else if (ActivityCompat.checkSelfPermission(requireActivity(), Manifest.permission.BLUETOOTH) != PackageManager.PERMISSION_GRANTED) {
                bluetoothGpsPermissionsRequest();
                return;
            }
        if (bluetoothAdapter.isDiscovering()) {
            Log.i("bluetooth", "Cancel discovery");
            bluetoothAdapter.cancelDiscovery();
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            if (ActivityCompat.checkSelfPermission(requireActivity(), Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED) {
                bluetoothGpsPermissionsRequest();
                return;
            } else if (ActivityCompat.checkSelfPermission(requireActivity(), Manifest.permission.BLUETOOTH) != PackageManager.PERMISSION_GRANTED) {
                bluetoothGpsPermissionsRequest();
                return;
            }
        Log.i("bluetooth", "Looking for unpaired devices");
        IntentFilter discoveryStartedIntent = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_STARTED);
        requireActivity().registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Log.i("TAG", "Discovering...");
            }
        }, discoveryStartedIntent);
        btDevices.clear();
        bluetoothAdapter.startDiscovery();
        IntentFilter discoverDevicesIntent = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        requireActivity().registerReceiver(broadcastReceiver3, discoverDevicesIntent);
    }

    public static void bluetoothGpsPermissionsRequest() {

        if (!bluetoothGpsPermissionGranted) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                bluetoothGpsPermissionRequestLauncher.launch(new String[]{
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.BLUETOOTH,
                        Manifest.permission.BLUETOOTH_ADMIN,
                        Manifest.permission.BLUETOOTH_SCAN,
                        Manifest.permission.BLUETOOTH_CONNECT});
            } else {
                bluetoothGpsPermissionRequestLauncher.launch(new String[]{
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.BLUETOOTH,
                        Manifest.permission.BLUETOOTH_ADMIN});
            }
        }
    }
}