package com.app.base.view;

import android.content.Context;

import com.google.android.flexbox.FlexLine;
import com.google.android.flexbox.FlexboxLayoutManager;

import java.util.List;


public class FlexboxMaxLinesLayoutManager extends FlexboxLayoutManager {

    private int maxLines;

    public FlexboxMaxLinesLayoutManager(Context context, int maxLines) {
        super(context);
        this.maxLines = maxLines;
    }

    @Override
    public int getMaxLine() {
        return super.getMaxLine();
    }


    @Override
    public List<FlexLine> getFlexLinesInternal() {
        List<FlexLine> flexLines = super.getFlexLinesInternal();
        int size = flexLines.size();
        if (maxLines > 0 && size > maxLines) {
            flexLines.subList(maxLines, size).clear();
        }
        return flexLines;
    }


    public int getLines() {
        return super.getFlexLinesInternal().size();
    }
}