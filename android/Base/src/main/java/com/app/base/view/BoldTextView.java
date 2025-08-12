package com.app.base.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.text.TextPaint;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatTextView;

import com.app.base.R;



public class BoldTextView extends AppCompatTextView {

    private float mStrokeWidth = 0.5f;
    public BoldTextView(Context context) {
        this(context,null);
    }

    public BoldTextView(Context context, AttributeSet attrs) {
        this(context, attrs,0);
    }

    public BoldTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        TypedArray array = context.obtainStyledAttributes(attrs, R.styleable.BoldTextView,defStyleAttr,0);
        mStrokeWidth = array.getFloat(R.styleable.BoldTextView_stroke_width,mStrokeWidth);
    }

    @Override
    protected void onDraw(Canvas canvas) {

        TextPaint paint = getPaint();
        paint.setStrokeWidth(mStrokeWidth);
        paint.setStyle(Paint.Style.FILL_AND_STROKE);
        super.onDraw(canvas);
    }

    public void setStrokeWidth(float mStrokeWidth) {
        this.mStrokeWidth = mStrokeWidth;
        invalidate();
    }

    public float getStrokeWidth() {
        return mStrokeWidth;
    }
}