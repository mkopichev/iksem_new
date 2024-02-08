package com.iksem.ui;

import android.annotation.SuppressLint;
import android.app.Activity;

public class GetSystemBarsHeight {

    public static int getStatusBarHeight(Activity activity) {

        int statusBarHeight = 0;
        @SuppressLint({"InternalInsetResource", "DiscouragedApi"}) int resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            statusBarHeight = activity.getResources().getDimensionPixelSize(resourceId);
        }
        return statusBarHeight;
    }

    public static int getNavigationBarHeight(Activity activity) {

        int navigationBarHeight = 0;
        @SuppressLint({"DiscouragedApi", "InternalInsetResource"}) int resourceId = activity.getResources().getIdentifier("navigation_bar_height", "dimen", "android");
        if (resourceId > 0) {
            navigationBarHeight = activity.getResources().getDimensionPixelSize(resourceId);
        }
        return navigationBarHeight;
    }
}
