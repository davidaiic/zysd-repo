package com.base.myzxing.analyze;

import androidx.annotation.Nullable;

import com.base.myzxing.DecodeConfig;
import com.google.zxing.DecodeHintType;
import com.google.zxing.Reader;
import com.google.zxing.qrcode.QRCodeReader;


import java.util.Map;



public class QRCodeAnalyzer extends BarcodeFormatAnalyzer {

    public QRCodeAnalyzer() {
        this((DecodeConfig)null);
    }

    public QRCodeAnalyzer(@Nullable Map<DecodeHintType,Object> hints){
        this(new DecodeConfig().setHints(hints));
    }

    public QRCodeAnalyzer(@Nullable DecodeConfig config) {
        super(config);
    }

    @Override
    public Reader createReader() {
        return new QRCodeReader();
    }

}
