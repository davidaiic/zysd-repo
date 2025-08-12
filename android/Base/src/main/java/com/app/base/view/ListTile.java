package com.app.base.view;

import static com.app.base.ext.ScreenExtKt.dp2px;
import static com.app.base.ext.ScreenExtKt.px2sp;
import static com.app.base.ext.ScreenExtKt.sp2px;

import android.content.Context;
import android.content.res.TypedArray;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.core.content.ContextCompat;
import androidx.databinding.BindingMethod;
import androidx.databinding.BindingMethods;

import com.app.base.R;



@BindingMethods({
        @BindingMethod(type = ListTile.class,
                attribute = "lt_suffix_text",
                method = "setSuffixText"),
        @BindingMethod(type = ListTile.class,
                attribute = "lt_switch_selected",
                method = "setSwitch"),

})
public class ListTile extends RelativeLayout {

    private int prefixDrawable;
    private float prefixWidth;
    private float prefixHeight;
    private float prefixSpace;
    private String prefixText;
    private int prefixTextColor;
    private float prefixTextSize;
    private int suffixDrawable;
    private float suffixWidth;
    private float suffixHeight;
    private float suffixSpace;
    private String suffixText;
    private int suffixTextColor;
    private float suffixTextSize;
    private ImageView prefixIV;
    private TextView prefixTV;
    private ImageView suffixIV;
    private TextView suffixTV;
    private ImageView btn_slip;
    private boolean showSwitch = false;
    private boolean topShow = false;
    private boolean bottomShow = false;
    private View topV, bottomV, ivRed;
    private TextView prefixSecondTv;
    private String prefixBottomText;
    private int prefixBottomTextColor;
    private float prefixBottomTextSize;
    private boolean switchSelected = false;

    public ListTile(Context context, AttributeSet attrs) {
        super(context, attrs);
        LayoutInflater.from(context).inflate(R.layout.view_list_tile, this);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.ListTile);

        prefixDrawable = ta.getResourceId(R.styleable.ListTile_lt_prefix_image, 0);
        prefixWidth = ta.getDimension(R.styleable.ListTile_lt_prefix_image_width, dp2px(context, 32));
        prefixHeight = ta.getDimension(R.styleable.ListTile_lt_prefix_image_height, dp2px(context, 32));
        prefixSpace = ta.getDimension(R.styleable.ListTile_lt_prefix_space, dp2px(context, 16));
        prefixText = ta.getString(R.styleable.ListTile_lt_prefix_text);
        prefixTextColor = ta.getColor(R.styleable.ListTile_lt_prefix_text_color, ContextCompat.getColor(context, R.color.color_292934));
        prefixTextSize = ta.getDimension(R.styleable.ListTile_lt_prefix_text_size, sp2px(context, 16));

        prefixBottomText = ta.getString(R.styleable.ListTile_lt_prefix_bottom_text);
        prefixBottomTextColor = ta.getColor(R.styleable.ListTile_lt_prefix_bottom_text_color, ContextCompat.getColor(context, R.color.color_90929E));
        prefixBottomTextSize = ta.getDimension(R.styleable.ListTile_lt_prefix_bottom_text_size, sp2px(context, 10));


        suffixDrawable = ta.getResourceId(R.styleable.ListTile_lt_suffix_image, 0);
        suffixWidth = ta.getDimension(R.styleable.ListTile_lt_suffix_image_width, dp2px(context, 32));
        suffixHeight = ta.getDimension(R.styleable.ListTile_lt_suffix_image_height, dp2px(context, 32));
        suffixSpace = ta.getDimension(R.styleable.ListTile_lt_suffix_space, dp2px(context, 16));
        suffixText = ta.getString(R.styleable.ListTile_lt_suffix_text);
        suffixTextColor = ta.getColor(R.styleable.ListTile_lt_suffix_text_color, ContextCompat.getColor(context, R.color.color_292934));
        suffixTextSize = ta.getDimension(R.styleable.ListTile_lt_suffix_text_size, sp2px(context, 16));
        showSwitch = ta.getBoolean(R.styleable.ListTile_lt_switch_show, false);
        switchSelected = ta.getBoolean(R.styleable.ListTile_lt_switch_selected, false);

        topShow = ta.getBoolean(R.styleable.ListTile_lt_top_show, false);
        bottomShow = ta.getBoolean(R.styleable.ListTile_lt_bottom_show, false);

        ta.recycle();
    }

    @Override
    protected void onFinishInflate() {
        super.onFinishInflate();
        prefixIV = findViewById(R.id.iv_prefix);
        prefixTV = findViewById(R.id.tv_prefix);
        suffixIV = findViewById(R.id.iv_suffix);
        suffixTV = findViewById(R.id.tv_suffix);
        btn_slip = findViewById(R.id.btn_slip);
        prefixSecondTv = findViewById(R.id.tv_prefix_second);
        ivRed = findViewById(R.id.iv_red);
        topV = findViewById(R.id.topV);
        bottomV = findViewById(R.id.bottomV);
        initView();
    }

    private void initView() {
        if (prefixDrawable != 0) {
            prefixIV.setVisibility(VISIBLE);
            prefixIV.setImageResource(prefixDrawable);
        } else {
            prefixIV.setVisibility(GONE);
        }
        LayoutParams prefixIVLayoutParams = (LayoutParams) prefixIV.getLayoutParams();
        prefixIVLayoutParams.width = (int) prefixWidth;
        prefixIVLayoutParams.height = (int) prefixHeight;
        prefixIVLayoutParams.rightMargin = (int) prefixSpace;
        prefixIV.setLayoutParams(prefixIVLayoutParams);

        prefixTV.setText(prefixText);
        prefixTV.setTextSize(px2sp(getContext(), prefixTextSize));
        prefixTV.setTextColor(prefixTextColor);


        prefixSecondTv.setTextSize(px2sp(getContext(), prefixBottomTextSize));
        prefixSecondTv.setTextColor(prefixBottomTextColor);
        if (TextUtils.isEmpty(prefixBottomText)) {
            prefixSecondTv.setVisibility(GONE);
        } else {
            prefixSecondTv.setVisibility(VISIBLE);
            prefixSecondTv.setText(prefixBottomText);

        }


        LinearLayout.LayoutParams suffixIVLayoutParams = (LinearLayout.LayoutParams) suffixIV.getLayoutParams();
        suffixIVLayoutParams.width = (int) suffixWidth;
        suffixIVLayoutParams.height = (int) suffixHeight;
        suffixIVLayoutParams.leftMargin = (int) suffixSpace;
        suffixIV.setLayoutParams(suffixIVLayoutParams);
        suffixTV.setTextSize(px2sp(getContext(), suffixTextSize));
        suffixTV.setTextColor(suffixTextColor);
        if (!TextUtils.isEmpty(suffixText)) {
            suffixTV.setVisibility(VISIBLE);
            suffixTV.setText(suffixText);
        } else {
            suffixTV.setVisibility(GONE);
        }

        btn_slip.setVisibility(showSwitch ? VISIBLE : GONE);
        btn_slip.setSelected(switchSelected);

        if (suffixDrawable != 0 && !showSwitch) {
            suffixIV.setVisibility(VISIBLE);
            suffixIV.setImageResource(suffixDrawable);
        } else {
            suffixIV.setVisibility(GONE);
        }
        topV.setVisibility(topShow ? VISIBLE : GONE);
        bottomV.setVisibility(bottomShow ? VISIBLE : GONE);


    }

    private ImageView getSwitch() {
        return btn_slip;
    }

    public void setSwitch(boolean selected) {
        btn_slip.setSelected(selected);
    }


    public void setSuffixText(String text) {
        if (TextUtils.isEmpty(text)) {
            suffixTV.setVisibility(GONE);
        } else {
            suffixTV.setVisibility(VISIBLE);
            suffixTV.setText(text);
        }

    }

    public void setIvRedVisibility(boolean showIvRed) {
        ivRed.setVisibility(showIvRed ? VISIBLE : GONE);

    }
}