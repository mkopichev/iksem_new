package com.iksem.ui.protocols;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class ProtocolsViewModel extends ViewModel {

    private final MutableLiveData<String> mText;

    public ProtocolsViewModel() {

        mText = new MutableLiveData<>();
        mText.setValue("This is protocols fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}