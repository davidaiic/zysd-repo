@file:Suppress("unused")

package com.app.base.app_use.transform

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.renderscript.RenderScript
import androidx.core.graphics.createBitmap
import coil.size.Size
import coil.transform.Transformation


class BlurTransformation @JvmOverloads constructor(
    private val context: Context,
    private val radius: Int = DEFAULT_RADIUS,
    private val sampling: Float = DEFAULT_SAMPLING
) : Transformation {

    init {
        require(radius in 0..25) { "radius must be in [0, 25]." }
        require(sampling > 0) { "sampling must be > 0." }
    }

    override val cacheKey: String = "${BlurTransformation::class.java.name}-$radius-$sampling"

    override suspend fun transform(bitmap: Bitmap, size: Size): Bitmap {
        val scaledWidth = (bitmap.width / sampling).toInt()
        val scaledHeight = (bitmap.height / sampling).toInt()
        var newBitmap: Bitmap = createBitmap(scaledWidth, scaledHeight, Bitmap.Config.ARGB_8888)
        newBitmap.density = bitmap.density
        val canvas = Canvas(newBitmap)
        canvas.scale(1 / sampling, 1 / sampling)
        val paint = Paint()
        paint.flags = Paint.FILTER_BITMAP_FLAG
        canvas.drawBitmap(bitmap, 0f, 0f, paint)

        return try {
            RSBlur.blur(context, newBitmap, radius)
        } catch (e: Exception) {
            FastBlur.blur(newBitmap, radius, true)
        }
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        return other is BlurTransformation &&
                context == other.context &&
                radius == other.radius &&
                sampling == other.sampling
    }

    override fun hashCode(): Int {
        var result = context.hashCode()
        result = 31 * result + radius.hashCode()
        result = 31 * result + sampling.hashCode()
        return result
    }

    override fun toString(): String {
        return "BlurTransformation(context=$context, radius=$radius, sampling=$sampling)"
    }

    private companion object {
        private const val DEFAULT_RADIUS = 10
        private const val DEFAULT_SAMPLING = 1f
    }
}