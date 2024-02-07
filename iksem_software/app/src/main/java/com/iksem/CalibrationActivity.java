package com.iksem;

import android.annotation.SuppressLint;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.appbar.MaterialToolbar;

public class CalibrationActivity extends AppCompatActivity {

    MaterialToolbar materialToolbar;

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        setContentView(R.layout.activity_calibration);
        materialToolbar = findViewById(R.id.calibration_toolbar);
    }
}
