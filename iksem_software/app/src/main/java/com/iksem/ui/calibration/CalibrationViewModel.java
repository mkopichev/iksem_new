package com.iksem.ui.calibration;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class CalibrationViewModel extends ViewModel {

    private final MutableLiveData<String> mText;

    public CalibrationViewModel() {

        mText = new MutableLiveData<>();
        mText.setValue("This is calibration fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}
