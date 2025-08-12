package com.app.base.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.text.TextPaint;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.widget.TextView;

import androidx.appcompat.widget.AppCompatTextView;


import com.app.base.R;

import java.util.ArrayList;
import java.util.List;


public class AlignmentTextView extends AppCompatTextView {
    private float textHeight;
    private float textLineSpaceExtra = 0;
    private int width;
    private List<String> lines = new ArrayList<String>();
    private List<Integer> tailLines = new ArrayList<Integer>();
    private Align align = Align.ALIGN_LEFT;
    private boolean firstCalc = true;

    private float lineSpacingMultiplier = 1.0f;
    private float lineSpacingAdd = 0.0f;

    private int originalHeight = 0;
    private int originalLineCount = 0;
    private int originalPaddingBottom = 0;
    private boolean setPaddingFromMe = false;

    // 尾行对齐方式
    public enum Align {
        ALIGN_LEFT, ALIGN_CENTER, ALIGN_RIGHT
    }

    public AlignmentTextView(Context context) {
        super(context);
        setTextIsSelectable(false);
    }

    public AlignmentTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setTextIsSelectable(false);

        int[] attributes = new int[]{android.R.attr.lineSpacingExtra, android.R.attr.lineSpacingMultiplier};
        TypedArray arr = context.obtainStyledAttributes(attrs, attributes);
        lineSpacingAdd = arr.getDimensionPixelSize(0, 0);
        lineSpacingMultiplier = arr.getFloat(1, 1.0f);
        originalPaddingBottom = getPaddingBottom();
        arr.recycle();

        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.AlignmentTextView);

        int alignStyle = ta.getInt(R.styleable.AlignmentTextView_align, 0);
        switch (alignStyle) {
            case 1:
                align = Align.ALIGN_CENTER;
                break;
            case 2:
                align = Align.ALIGN_RIGHT;
                break;
            default:
                align = Align.ALIGN_LEFT;
                break;
        }

        ta.recycle();
    }


    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);

        //首先进行高度调整
        if (firstCalc) {
            width = getMeasuredWidth();
            String text = getText().toString();
            TextPaint paint = getPaint();
            lines.clear();
            tailLines.clear();


            String[] items = text.split("\\n");
            for (String item : items) {
                calc(paint, item);
            }

            measureTextViewHeight(text, paint.getTextSize(), getMeasuredWidth() -
                    getPaddingLeft() - getPaddingRight());


            textHeight = 2.0f * originalHeight / originalLineCount;

            textLineSpaceExtra = textHeight * (lineSpacingMultiplier - 1) + lineSpacingAdd;


            int heightGap = (int) ((textLineSpaceExtra + textHeight) * (lines.size() -
                    originalLineCount));

            setPaddingFromMe = true;

            setPadding(getPaddingLeft(), getPaddingTop(), getPaddingRight(),
                    originalPaddingBottom + heightGap);

            firstCalc = false;
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        TextPaint paint = getPaint();
        paint.setColor(getCurrentTextColor());
        paint.drawableState = getDrawableState();

        width = getMeasuredWidth();

        Paint.FontMetrics fm = paint.getFontMetrics();
        float firstHeight = getTextSize() - (fm.bottom - fm.descent + fm.ascent - fm.top);

        int gravity = getGravity();
        if ((gravity & 0x1000) == 0) {
            firstHeight = firstHeight + (textHeight - firstHeight) / 2;
        }

        int paddingTop = getPaddingTop();
        int paddingLeft = getPaddingLeft();
        int paddingRight = getPaddingRight();
        width = width - paddingLeft - paddingRight;

        for (int i = 0; i < lines.size(); i++) {
            float drawY = i * textHeight + firstHeight;
            String line = lines.get(i);

            float drawSpacingX = paddingLeft;
            float gap = (width - paint.measureText(line));
            float interval = gap / (line.length() - 1);

            if (tailLines.contains(i)) {
                interval = 0;
                if (align == Align.ALIGN_CENTER) {
                    drawSpacingX += gap / 2;
                } else if (align == Align.ALIGN_RIGHT) {
                    drawSpacingX += gap;
                }
            }

            for (int j = 0; j < line.length(); j++) {
                float drawX = paint.measureText(line.substring(0, j)) + interval * j;
                canvas.drawText(line.substring(j, j + 1), drawX + drawSpacingX, drawY +
                        paddingTop + textLineSpaceExtra * i, paint);
            }
        }
    }


    public void setAlign(Align align) {
        this.align = align;
        invalidate();
    }


    private void calc(Paint paint, String text) {
        if (text.length() == 0) {
            lines.add("\n");
            return;
        }
        int startPosition = 0;
        float oneChineseWidth = paint.measureText("中");
        int ignoreCalcLength = (int) (width / oneChineseWidth);
        StringBuilder sb = new StringBuilder(text.substring(0, Math.min(ignoreCalcLength + 1,
                text.length())));

        for (int i = ignoreCalcLength + 1; i < text.length(); i++) {
            if (paint.measureText(text.substring(startPosition, i + 1)) > width) {
                startPosition = i;
                lines.add(sb.toString());

                sb = new StringBuilder();

                if ((text.length() - startPosition) > ignoreCalcLength) {
                    sb.append(text.substring(startPosition, startPosition + ignoreCalcLength));
                } else {
                    lines.add(text.substring(startPosition));
                    break;
                }

                i = i + ignoreCalcLength - 1;
            } else {
                sb.append(text.charAt(i));
            }
        }
        if (sb.length() > 0) {
            lines.add(sb.toString());
        }

        tailLines.add(lines.size() - 1);
    }


    @Override
    public void setText(CharSequence text, BufferType type) {
        firstCalc = true;
        super.setText(text, type);
    }

    @Override
    public void setPadding(int left, int top, int right, int bottom) {
        if (!setPaddingFromMe) {
            originalPaddingBottom = bottom;
        }
        setPaddingFromMe = false;
        super.setPadding(left, top, right, bottom);
    }



    private void measureTextViewHeight(String text, float textSize, int deviceWidth) {
        TextView textView = new TextView(getContext());
        textView.setText(text);
        textView.setTextSize(TypedValue.COMPLEX_UNIT_PX, textSize);
        int widthMeasureSpec = MeasureSpec.makeMeasureSpec(deviceWidth, MeasureSpec.EXACTLY);
        int heightMeasureSpec = MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);
        textView.measure(widthMeasureSpec, heightMeasureSpec);
        originalLineCount = textView.getLineCount();
        originalHeight = textView.getMeasuredHeight();
    }

}
