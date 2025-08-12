package com.manle.phone.android.yaodian.view;


import android.content.Context;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;



public class SlidingCheckLayout extends FrameLayout {
    private static final String TAG = SlidingCheckLayout.class.getSimpleName();
    private int mTouchSlop;

    private RecyclerView mTargetRv;

    private float mInitDownY;

    private float mInitDownX;

    private float mLastY;

    private float mLastX;

    private int mLastPosition = RecyclerView.NO_POSITION;

    private static final int sLongPressTime = 1;

    private boolean mSlidingEnable = true;
    private boolean mStartingCheck = false;
    private int mIncrease = 0;
    private CheckForLongPress mPendingCheckForLongPress;
    private Handler mHandler;

    private OnSlidingPositionListener mOnSlidingPositionListener;


    public SlidingCheckLayout(@NonNull Context context) {
        this(context, null);
    }

    public SlidingCheckLayout(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public SlidingCheckLayout(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        final ViewConfiguration vc = ViewConfiguration.get(context);
        mTouchSlop = vc.getScaledTouchSlop();
        mHandler = new Handler();
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        ensureTarget();
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        if (!isSlidingEnable() || !isEnabled()) {
            return super.dispatchTouchEvent(event);
        }
        if (!isCanIntercept()) {
            return super.dispatchTouchEvent(event);
        }
        final int action = event.getActionMasked();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                mInitDownY = mLastY = event.getY();
                mInitDownX = mLastX = event.getX();
                checkForLongClick(0, mInitDownX, mInitDownY);
                break;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                removeLongPressCallback();
                mLastPosition = RecyclerView.NO_POSITION;
                mIncrease = 0;
                if (mStartingCheck) {
                    mStartingCheck = false;
                    return true;
                }
                break;
            case MotionEvent.ACTION_MOVE:
                float y = event.getY();
                float x = event.getX();
                final float yInitDiff = y - mInitDownY;
                final float xInitDiff = x - mInitDownX;
                mLastY = y;
                mLastX = x;
                if (!mStartingCheck && (Math.abs(yInitDiff) > mTouchSlop || Math.abs(xInitDiff) > mTouchSlop)) {
                    removeLongPressCallback();
                }
                if (mStartingCheck) {
                    checkSlidingPosition(x, y);
                    return true;
                }
                break;
        }
        boolean result = super.dispatchTouchEvent(event);
        return result;
    }

    private void checkSlidingPosition(float x, float y) {
        View childViewUnder = mTargetRv.findChildViewUnder(x, y);
        if (mOnSlidingPositionListener == null || childViewUnder == null) return;

        int currentPosition = mTargetRv.getChildAdapterPosition(childViewUnder);

        if (currentPosition == mLastPosition || currentPosition == RecyclerView.NO_POSITION) return;

        if (mLastPosition != RecyclerView.NO_POSITION && Math.abs(currentPosition - mLastPosition) > 1) {
            if (mLastPosition > currentPosition) {
                mOnSlidingPositionListener.onSlidingRangePosition(currentPosition, mIncrease > 0 ? mLastPosition : mLastPosition - 1);
            } else {
                mOnSlidingPositionListener.onSlidingRangePosition(mIncrease < 0 ? mLastPosition : mLastPosition + 1, currentPosition);
            }
        } else {
            if ((mIncrease > 0 && mLastPosition > currentPosition) || (mIncrease < 0 && currentPosition > mLastPosition)) {
                mOnSlidingPositionListener.onSlidingPosition(mLastPosition);
            }
            mOnSlidingPositionListener.onSlidingPosition(currentPosition);
        }
        mIncrease = currentPosition > mLastPosition ? 1 : -1;
        mLastPosition = currentPosition;
    }

    private int checkDownPosition(float x, float y) {
        View childViewUnder = mTargetRv.findChildViewUnder(x, y);
        if (mOnSlidingPositionListener == null || childViewUnder == null)
            return RecyclerView.NO_POSITION;

        int currentPosition = mTargetRv.getChildAdapterPosition(childViewUnder);
        if (currentPosition == RecyclerView.NO_POSITION) return RecyclerView.NO_POSITION;

        return currentPosition;
    }

    public void setSlidingEnable(boolean slidingEnable) {
        mSlidingEnable = slidingEnable;
    }

    public void setOnSlidingPositionListener(OnSlidingPositionListener onSlidingPositionListener) {
        mOnSlidingPositionListener = onSlidingPositionListener;
    }

    public boolean isSlidingEnable() {
        return mSlidingEnable;
    }

    private void ensureTarget() {
        if (mTargetRv != null) return;
        for (int i = 0; i < getChildCount(); i++) {
            View childAt = getChildAt(i);
            if (childAt instanceof RecyclerView) {
                mTargetRv = (RecyclerView) childAt;
                return;
            }
        }
        throw new IllegalStateException("Children must have a RecyclerView");
    }

    private boolean isCanIntercept() {
        return mTargetRv != null && mTargetRv.getAdapter() != null && mTargetRv.getAdapter().getItemCount() != 0;
    }



    private void checkForLongClick(int delayOffset, float x, float y) {
        if (mPendingCheckForLongPress == null) {
            mPendingCheckForLongPress = new CheckForLongPress();
        }
        mPendingCheckForLongPress.setAnchor(x, y);
        mPendingCheckForLongPress.rememberPressedState();
        mHandler.postDelayed(mPendingCheckForLongPress,
                sLongPressTime - delayOffset);
    }


    private void removeLongPressCallback() {
        if (mPendingCheckForLongPress != null) {
            mHandler.removeCallbacks(mPendingCheckForLongPress);
        }
    }

    private final class CheckForLongPress implements Runnable {
        private float mX;
        private float mY;
        private boolean mOriginalPressedState;

        @Override
        public void run() {
            if ((mOriginalPressedState == isPressed()) && (mLastPosition = checkDownPosition(mX, mY)) != RecyclerView.NO_POSITION) {
                if (mOnSlidingPositionListener != null) {
                    mOnSlidingPositionListener.onSlidingPosition(mLastPosition);
                }
                requestDisallowInterceptTouchEvent(true);
                mStartingCheck = true;
            }
        }

        public void setAnchor(float x, float y) {
            mX = x;
            mY = y;
        }

        public void rememberPressedState() {
            mOriginalPressedState = isPressed();
        }
    }

    public interface OnSlidingPositionListener {
        void onSlidingPosition(int position);

        void onSlidingRangePosition(int startPosition, int endPosition);
    }
}