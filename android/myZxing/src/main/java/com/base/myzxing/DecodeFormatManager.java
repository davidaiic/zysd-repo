package com.base.myzxing;

import androidx.annotation.NonNull;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.DecodeHintType;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;


public final class DecodeFormatManager {


    public static final Map<DecodeHintType, Object> ALL_HINTS = new EnumMap<>(DecodeHintType.class);

    public static final Map<DecodeHintType, Object> CODE_128_HINTS = createDecodeHint(BarcodeFormat.CODE_128);

    public static final Map<DecodeHintType, Object> QR_CODE_HINTS = createDecodeHint(BarcodeFormat.QR_CODE);

    public static final Map<DecodeHintType, Object> ONE_DIMENSIONAL_HINTS = new EnumMap<>(DecodeHintType.class);

    public static final Map<DecodeHintType, Object> TWO_DIMENSIONAL_HINTS = new EnumMap<>(DecodeHintType.class);

    public static final Map<DecodeHintType, Object> DEFAULT_HINTS = new EnumMap<>(DecodeHintType.class);

    static {
        addDecodeHintTypes(ALL_HINTS, getAllFormats());
        addDecodeHintTypes(ONE_DIMENSIONAL_HINTS, getOneDimensionalFormats());
        addDecodeHintTypes(TWO_DIMENSIONAL_HINTS, getTwoDimensionalFormats());
        addDecodeHintTypes(DEFAULT_HINTS, getDefaultFormats());
    }


    private static List<BarcodeFormat> getAllFormats() {
        List<BarcodeFormat> list = new ArrayList<>();
        list.add(BarcodeFormat.AZTEC);
        list.add(BarcodeFormat.CODABAR);
        list.add(BarcodeFormat.CODE_39);
        list.add(BarcodeFormat.CODE_93);
        list.add(BarcodeFormat.CODE_128);
        list.add(BarcodeFormat.DATA_MATRIX);
        list.add(BarcodeFormat.EAN_8);
        list.add(BarcodeFormat.EAN_13);
        list.add(BarcodeFormat.ITF);
        list.add(BarcodeFormat.MAXICODE);
        list.add(BarcodeFormat.PDF_417);
        list.add(BarcodeFormat.QR_CODE);
        list.add(BarcodeFormat.RSS_14);
        list.add(BarcodeFormat.RSS_EXPANDED);
        list.add(BarcodeFormat.UPC_A);
        list.add(BarcodeFormat.UPC_E);
        list.add(BarcodeFormat.UPC_EAN_EXTENSION);
        return list;
    }


    private static List<BarcodeFormat> getOneDimensionalFormats() {
        List<BarcodeFormat> list = new ArrayList<>();
        list.add(BarcodeFormat.CODABAR);
        list.add(BarcodeFormat.CODE_39);
        list.add(BarcodeFormat.CODE_93);
        list.add(BarcodeFormat.CODE_128);
        list.add(BarcodeFormat.EAN_8);
        list.add(BarcodeFormat.EAN_13);
        list.add(BarcodeFormat.ITF);
        list.add(BarcodeFormat.RSS_14);
        list.add(BarcodeFormat.RSS_EXPANDED);
        list.add(BarcodeFormat.UPC_A);
        list.add(BarcodeFormat.UPC_E);
        list.add(BarcodeFormat.UPC_EAN_EXTENSION);
        return list;
    }

    private static List<BarcodeFormat> getTwoDimensionalFormats() {
        List<BarcodeFormat> list = new ArrayList<>();
        list.add(BarcodeFormat.AZTEC);
        list.add(BarcodeFormat.DATA_MATRIX);
        list.add(BarcodeFormat.MAXICODE);
        list.add(BarcodeFormat.PDF_417);
        list.add(BarcodeFormat.QR_CODE);
        return list;
    }

    private static List<BarcodeFormat> getDefaultFormats() {
        List<BarcodeFormat> list = new ArrayList<>();
        list.add(BarcodeFormat.QR_CODE);
        list.add(BarcodeFormat.UPC_A);
        list.add(BarcodeFormat.EAN_13);
        list.add(BarcodeFormat.CODE_128);
        return list;
    }


    public static Map<DecodeHintType, Object> createDecodeHints(@NonNull BarcodeFormat... barcodeFormats) {
        Map<DecodeHintType, Object> hints = new EnumMap<>(DecodeHintType.class);
        addDecodeHintTypes(hints, Arrays.asList(barcodeFormats));
        return hints;
    }

    public static Map<DecodeHintType, Object> createDecodeHint(@NonNull BarcodeFormat barcodeFormat) {
        Map<DecodeHintType, Object> hints = new EnumMap<>(DecodeHintType.class);
        addDecodeHintTypes(hints, Collections.singletonList(barcodeFormat));
        return hints;
    }


    private static void addDecodeHintTypes(Map<DecodeHintType, Object> hints, List<BarcodeFormat> formats) {
        hints.put(DecodeHintType.POSSIBLE_FORMATS, formats);
        hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);
        hints.put(DecodeHintType.CHARACTER_SET, "UTF-8");
    }

}
