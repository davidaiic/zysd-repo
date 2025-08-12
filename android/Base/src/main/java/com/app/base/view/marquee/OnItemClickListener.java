package com.app.base.view.marquee;

import android.view.View;



public interface OnItemClickListener<V extends View, E> {
    void onItemClickListener(V mView, E mData, int mPosition);
}
