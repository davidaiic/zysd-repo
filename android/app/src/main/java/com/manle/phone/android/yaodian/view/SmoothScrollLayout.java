package com.manle.phone.android.yaodian.view;

import android.content.Context;
import android.os.Handler;
import android.os.Message;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;


import com.app.base.app_use.ext.ImageExtKt;
import com.makeramen.roundedimageview.RoundedImageView;
import com.manle.phone.android.yaodian.R;
import com.manle.phone.android.yaodian.bean.SearchUserBean;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;



public class SmoothScrollLayout extends FrameLayout {

    private ScrollHandler mHandler;
    private MyAdapter mAdapter;
    private RecyclerView recyclerView;

    public SmoothScrollLayout(@NonNull Context context) {
        this(context, null);
    }

    public SmoothScrollLayout(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public SmoothScrollLayout(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        View.inflate(context, R.layout.layout_smooth_scroll, this);
        mHandler = new ScrollHandler(this);
        mAdapter = new MyAdapter();
        recyclerView = (RecyclerView) findViewById(R.id.rvNews);
        recyclerView.setLayoutManager(new LinearLayoutManager(context));
        recyclerView.setAdapter(mAdapter);
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        return false;       //拦截事件
    }

    public void setData(List<SearchUserBean> data) {
        mAdapter.setList(data);
        if (data != null && data.size() > 0) {
            mHandler.sendEmptyMessageDelayed(0, 100);
        }
    }

    public void smoothScroll() {
        recyclerView.smoothScrollBy(0, 5);
        mHandler.sendEmptyMessageDelayed(0, 100);
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        mHandler.removeCallbacksAndMessages(null);
    }


    private static class ScrollHandler extends Handler {
        private WeakReference<SmoothScrollLayout> view;

        public ScrollHandler(SmoothScrollLayout mView) {
            view = new WeakReference<>(mView);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (view.get() != null) {
                view.get().smoothScroll();
            }
        }
    }

    private static class MyAdapter extends RecyclerView.Adapter<ViewHolder> {

        private List<SearchUserBean> list;

        public MyAdapter() {
            list = new ArrayList<>();
        }

        public void setList(List<SearchUserBean> list) {
            this.list.clear();
            this.list.addAll(list);
            notifyDataSetChanged();
        }

        @Override
        public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_smooth_scroll, parent, false);
            return new ViewHolder(view);
        }

        @Override
        public void onBindViewHolder(ViewHolder holder, int position) {

            holder.bindData(list.get(position % list.size()));
        }

        @Override
        public int getItemCount() {
            return list.size() > 0 ? Integer.MAX_VALUE : 0;
        }
    }

    private static class ViewHolder extends RecyclerView.ViewHolder {
        private TextView contentTv;
        private RoundedImageView riv;

        public ViewHolder(View itemView) {
            super(itemView);
            contentTv = (TextView) itemView.findViewById(R.id.contentTv);
            riv = (RoundedImageView) itemView.findViewById(R.id.headRiv);
        }

        public void bindData(SearchUserBean content) {
            contentTv.setText(content.getContent());
            ImageExtKt.loadImage(riv, content.getAvatar(), R.drawable.ic_error_img, R.drawable.ic_error_img);

        }
    }

}
