
package com.base.myzxing.util;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.text.TextPaint;
import android.text.TextUtils;

import androidx.annotation.ColorInt;
import androidx.annotation.FloatRange;
import androidx.annotation.NonNull;

import com.base.myzxing.DecodeFormatManager;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.RGBLuminanceSource;
import com.google.zxing.Result;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.GlobalHistogramBinarizer;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;


import java.util.HashMap;
import java.util.Map;


public final class CodeUtils {

    public static final int DEFAULT_REQ_WIDTH = 480;
    public static final int DEFAULT_REQ_HEIGHT = 640;

    private CodeUtils() {
        throw new AssertionError();
    }


    public static Bitmap createQRCode(String content, int heightPix) {
        return createQRCode(content, heightPix, null);
    }


    public static Bitmap createQRCode(String content, int heightPix, int codeColor) {
        return createQRCode(content, heightPix, null, codeColor);
    }


    public static Bitmap createQRCode(String content, int heightPix, Bitmap logo) {
        return createQRCode(content, heightPix, logo, Color.BLACK);
    }

    public static Bitmap createQRCode(String content, int heightPix, Bitmap logo, int codeColor) {
        return createQRCode(content, heightPix, logo, 0.2f, codeColor);
    }


    public static Bitmap createQRCode(String content, int heightPix, Bitmap logo, @FloatRange(from = 0.0f, to = 1.0f) float ratio) {
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.MARGIN, 1);
        return createQRCode(content, heightPix, logo, ratio, hints);
    }

    public static Bitmap createQRCode(String content, int heightPix, Bitmap logo, @FloatRange(from = 0.0f, to = 1.0f) float ratio, int codeColor) {
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "utf-8");
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        hints.put(EncodeHintType.MARGIN, 1);
        return createQRCode(content, heightPix, logo, ratio, hints, codeColor);
    }

    public static Bitmap createQRCode(String content, int heightPix, Bitmap logo, @FloatRange(from = 0.0f, to = 1.0f) float ratio, Map<EncodeHintType, ?> hints) {
        return createQRCode(content, heightPix, logo, ratio, hints, Color.BLACK);
    }


    public static Bitmap createQRCode(String content, int heightPix, Bitmap logo, @FloatRange(from = 0.0f, to = 1.0f) float ratio, Map<EncodeHintType, ?> hints, int codeColor) {
        try {

            BitMatrix bitMatrix = new QRCodeWriter().encode(content, BarcodeFormat.QR_CODE, heightPix, heightPix, hints);
            int[] pixels = new int[heightPix * heightPix];
            for (int y = 0; y < heightPix; y++) {
                for (int x = 0; x < heightPix; x++) {
                    if (bitMatrix.get(x, y)) {
                        pixels[y * heightPix + x] = codeColor;
                    } else {
                        pixels[y * heightPix + x] = Color.WHITE;
                    }
                }
            }

            Bitmap bitmap = Bitmap.createBitmap(heightPix, heightPix, Bitmap.Config.ARGB_8888);
            bitmap.setPixels(pixels, 0, heightPix, 0, 0, heightPix, heightPix);

            if (logo != null) {
                bitmap = addLogo(bitmap, logo, ratio);
            }

            return bitmap;
        } catch (Exception e) {
            LogUtils.w(e.getMessage());
        }

        return null;
    }


    private static Bitmap addLogo(Bitmap src, Bitmap logo, @FloatRange(from = 0.0f, to = 1.0f) float ratio) {
        if (src == null) {
            return null;
        }

        if (logo == null) {
            return src;
        }

        int srcWidth = src.getWidth();
        int srcHeight = src.getHeight();
        int logoWidth = logo.getWidth();
        int logoHeight = logo.getHeight();

        if (srcWidth == 0 || srcHeight == 0) {
            return null;
        }

        if (logoWidth == 0 || logoHeight == 0) {
            return src;
        }

        float scaleFactor = srcWidth * ratio / logoWidth;
        Bitmap bitmap;
        try {
            bitmap = Bitmap.createBitmap(srcWidth, srcHeight, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            canvas.drawBitmap(src, 0, 0, null);
            canvas.scale(scaleFactor, scaleFactor, srcWidth / 2, srcHeight / 2);
            canvas.drawBitmap(logo, (srcWidth - logoWidth) / 2, (srcHeight - logoHeight) / 2, null);
            canvas.save();
            canvas.restore();
        } catch (Exception e) {
            bitmap = null;
            LogUtils.w(e.getMessage());
        }

        return bitmap;
    }


    public static String parseQRCode(String bitmapPath) {
        Result result = parseQRCodeResult(bitmapPath);
        if (result != null) {
            return result.getText();
        }
        return null;
    }


    public static Result parseQRCodeResult(String bitmapPath) {
        return parseQRCodeResult(bitmapPath, DEFAULT_REQ_WIDTH, DEFAULT_REQ_HEIGHT);
    }


    public static Result parseQRCodeResult(String bitmapPath, int reqWidth, int reqHeight) {
        return parseCodeResult(bitmapPath, reqWidth, reqHeight, DecodeFormatManager.QR_CODE_HINTS);
    }


    public static String parseCode(String bitmapPath) {
        return parseCode(bitmapPath, DecodeFormatManager.ALL_HINTS);
    }

    public static String parseCode(String bitmapPath, Map<DecodeHintType, Object> hints) {
        Result result = parseCodeResult(bitmapPath, hints);
        if (result != null) {
            return result.getText();
        }
        return null;
    }


    public static String parseQRCode(Bitmap bitmap) {
        return parseCode(bitmap, DecodeFormatManager.QR_CODE_HINTS);
    }


    public static String parseCode(Bitmap bitmap) {
        return parseCode(bitmap, DecodeFormatManager.ALL_HINTS);
    }

    public static String parseCode(Bitmap bitmap, Map<DecodeHintType, Object> hints) {
        Result result = parseCodeResult(bitmap, hints);
        if (result != null) {
            return result.getText();
        }
        return null;
    }


    public static Result parseCodeResult(String bitmapPath, Map<DecodeHintType, Object> hints) {
        return parseCodeResult(bitmapPath, DEFAULT_REQ_WIDTH, DEFAULT_REQ_HEIGHT, hints);
    }


    public static Result parseCodeResult(String bitmapPath, int reqWidth, int reqHeight, Map<DecodeHintType, Object> hints) {
        return parseCodeResult(compressBitmap(bitmapPath, reqWidth, reqHeight), hints);
    }


    public static Result parseCodeResult(Bitmap bitmap) {
        return parseCodeResult(getRGBLuminanceSource(bitmap), DecodeFormatManager.ALL_HINTS);
    }


    public static Result parseCodeResult(Bitmap bitmap, Map<DecodeHintType, Object> hints) {
        return parseCodeResult(getRGBLuminanceSource(bitmap), hints);
    }


    public static Result parseCodeResult(LuminanceSource source, Map<DecodeHintType, Object> hints) {
        Result result = null;
        MultiFormatReader reader = new MultiFormatReader();
        try {
            reader.setHints(hints);
            if (source != null) {
                result = decodeInternal(reader, source);
                if (result == null) {
                    result = decodeInternal(reader, source.invert());
                }
                if (result == null && source.isRotateSupported()) {
                    result = decodeInternal(reader, source.rotateCounterClockwise());
                }
            }

        } catch (Exception e) {
            LogUtils.w(e.getMessage());
        } finally {
            reader.reset();
        }

        return result;
    }

    private static Result decodeInternal(MultiFormatReader reader, LuminanceSource source) {
        Result result = null;
        try {
            try {
                result = reader.decodeWithState(new BinaryBitmap(new HybridBinarizer(source)));
            } catch (Exception e) {

            }
            if (result == null) {
                result = reader.decodeWithState(new BinaryBitmap(new GlobalHistogramBinarizer(source)));
            }
        } catch (Exception e) {

        }
        return result;
    }



    private static Bitmap compressBitmap(String path, int reqWidth, int reqHeight) {
        if (reqWidth > 0 && reqHeight > 0) {

            BitmapFactory.Options newOpts = new BitmapFactory.Options();
            newOpts.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(path, newOpts);
            float width = newOpts.outWidth;
            float height = newOpts.outHeight;
            int wSize = 1;
            if (width > reqWidth) {
                wSize = (int) (width / reqWidth);
            }
            int hSize = 1;
            if (height > reqHeight) {
                hSize = (int) (height / reqHeight);
            }
            int size = Math.max(wSize, hSize);
            if (size <= 0)
                size = 1;
            newOpts.inSampleSize = size;
            newOpts.inJustDecodeBounds = false;

            return BitmapFactory.decodeFile(path, newOpts);

        }

        return BitmapFactory.decodeFile(path);
    }



    private static RGBLuminanceSource getRGBLuminanceSource(@NonNull Bitmap bitmap) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();

        int[] pixels = new int[width * height];
        bitmap.getPixels(pixels, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());
        return new RGBLuminanceSource(width, height, pixels);

    }

    public static Bitmap createBarCode(String content, int desiredWidth, int desiredHeight) {
        return createBarCode(content, BarcodeFormat.CODE_128, desiredWidth, desiredHeight, null);
    }


    public static Bitmap createBarCode(String content, BarcodeFormat format, int desiredWidth, int desiredHeight) {
        return createBarCode(content, format, desiredWidth, desiredHeight, null);
    }

    public static Bitmap createBarCode(String content, int desiredWidth, int desiredHeight, boolean isShowText) {
        return createBarCode(content, BarcodeFormat.CODE_128, desiredWidth, desiredHeight, null, isShowText, 40, Color.BLACK);
    }


    public static Bitmap createBarCode(String content, int desiredWidth, int desiredHeight, boolean isShowText, @ColorInt int codeColor) {
        return createBarCode(content, BarcodeFormat.CODE_128, desiredWidth, desiredHeight, null, isShowText, 40, codeColor);
    }


    public static Bitmap createBarCode(String content, BarcodeFormat format, int desiredWidth, int desiredHeight, Map<EncodeHintType, ?> hints) {
        return createBarCode(content, format, desiredWidth, desiredHeight, hints, false, 40, Color.BLACK);
    }


    public static Bitmap createBarCode(String content, BarcodeFormat format, int desiredWidth, int desiredHeight, Map<EncodeHintType, ?> hints, boolean isShowText) {
        return createBarCode(content, format, desiredWidth, desiredHeight, hints, isShowText, 40, Color.BLACK);
    }

    public static Bitmap createBarCode(String content, BarcodeFormat format, int desiredWidth, int desiredHeight, boolean isShowText, @ColorInt int codeColor) {
        return createBarCode(content, format, desiredWidth, desiredHeight, null, isShowText, 40, codeColor);
    }


    public static Bitmap createBarCode(String content, BarcodeFormat format, int desiredWidth, int desiredHeight, Map<EncodeHintType, ?> hints, boolean isShowText, @ColorInt int codeColor) {
        return createBarCode(content, format, desiredWidth, desiredHeight, hints, isShowText, 40, codeColor);
    }


    public static Bitmap createBarCode(String content, BarcodeFormat format, int desiredWidth, int desiredHeight, Map<EncodeHintType, ?> hints, boolean isShowText, int textSize, @ColorInt int codeColor) {
        if (TextUtils.isEmpty(content)) {
            return null;
        }
        final int WHITE = Color.WHITE;
        final int BLACK = codeColor;

        MultiFormatWriter writer = new MultiFormatWriter();
        try {
            BitMatrix result = writer.encode(content, format, desiredWidth,
                    desiredHeight, hints);
            int width = result.getWidth();
            int height = result.getHeight();
            int[] pixels = new int[width * height];
            for (int y = 0; y < height; y++) {
                int offset = y * width;
                for (int x = 0; x < width; x++) {
                    pixels[offset + x] = result.get(x, y) ? BLACK : WHITE;
                }
            }

            Bitmap bitmap = Bitmap.createBitmap(width, height,
                    Bitmap.Config.ARGB_8888);
            bitmap.setPixels(pixels, 0, width, 0, 0, width, height);
            if (isShowText) {
                return addCode(bitmap, content, textSize, codeColor, textSize / 2);
            }
            return bitmap;
        } catch (WriterException e) {
            LogUtils.w(e.getMessage());
        }
        return null;
    }

    private static Bitmap addCode(Bitmap src, String code, int textSize, @ColorInt int textColor, int offset) {
        if (src == null) {
            return null;
        }

        if (TextUtils.isEmpty(code)) {
            return src;
        }

        int srcWidth = src.getWidth();
        int srcHeight = src.getHeight();

        if (srcWidth <= 0 || srcHeight <= 0) {
            return null;
        }

        Bitmap bitmap;
        try {
            bitmap = Bitmap.createBitmap(srcWidth, srcHeight + textSize + offset * 2, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            canvas.drawBitmap(src, 0, 0, null);
            TextPaint paint = new TextPaint();
            paint.setTextSize(textSize);
            paint.setColor(textColor);
            paint.setTextAlign(Paint.Align.CENTER);
            canvas.drawText(code, srcWidth / 2, srcHeight + textSize / 2 + offset, paint);
            canvas.save();
            canvas.restore();
        } catch (Exception e) {
            bitmap = null;
            LogUtils.w(e.getMessage());
        }

        return bitmap;
    }


}