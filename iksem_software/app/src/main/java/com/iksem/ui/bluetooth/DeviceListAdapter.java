package com.iksem.ui.bluetooth;

import static com.iksem.ui.bluetooth.BluetoothFragment.bluetoothGpsPermissionsRequest;

import android.Manifest;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.iksem.R;

import java.util.ArrayList;
import java.util.HashSet;

public class DeviceListAdapter extends RecyclerView.Adapter<DeviceListAdapter.BluetoothDeviceViewHolder> {

    final private ArrayList<BluetoothDevice> devices;
    final private Context context;

    public DeviceListAdapter(Context context, HashSet<BluetoothDevice> devices) {

        this.devices = new ArrayList<>(devices);
        this.context = context;
    }

    @NonNull
    @Override
    public BluetoothDeviceViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        LayoutInflater inflater = LayoutInflater.from(context);
        View view = inflater.inflate(R.layout.item_from_list, parent, false);
        return new BluetoothDeviceViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull BluetoothDeviceViewHolder holder, int position) {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED) {
                bluetoothGpsPermissionsRequest();
                return;
            } else if (ActivityCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH) != PackageManager.PERMISSION_GRANTED) {
                bluetoothGpsPermissionsRequest();
                return;
            }
        holder.device.setText(devices.get(position).getName());
    }

    @Override
    public int getItemCount() {

        return devices.size();
    }

    public static class BluetoothDeviceViewHolder extends RecyclerView.ViewHolder {

        ToggleButton device;

        public BluetoothDeviceViewHolder(@NonNull View itemView) {

            super(itemView);
            device = itemView.findViewById(R.id.item_of_interest);
        }
    }
}
