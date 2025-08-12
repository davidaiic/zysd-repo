package com.manle.phone.android.yaodian.view;



import android.content.Context;
import android.text.TextUtils;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatTextView;


public class MarqueeTextView extends AppCompatTextView {

    public MarqueeTextView(Context context) {
        this(context, null);
    }

    public MarqueeTextView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public MarqueeTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }


    private void init() {
        this.setEllipsize(TextUtils.TruncateAt.MARQUEE);
        this.setMarqueeRepeatLimit(-1);
        this.setSingleLine(true);
        this.setMaxLines(1);
    }

    @Override
    public boolean isFocused() {
        return true;
    }
}