package com.app.base.ext

import java.math.BigDecimal
import java.text.DecimalFormat
import kotlin.math.floor


const val DECIMAL_POINT_NUMBER: Int = 2



fun Double.add(d2: Double, decimalPoint: Int = DECIMAL_POINT_NUMBER): Double =
    BigDecimal(this).add(BigDecimal(d2)).setScale(decimalPoint, BigDecimal.ROUND_DOWN)
        .toDouble()


fun Double.sub(d2: Double, decimalPoint: Int = DECIMAL_POINT_NUMBER): Double =
    BigDecimal(this).subtract(BigDecimal(d2)).setScale(decimalPoint, BigDecimal.ROUND_DOWN)
        .toDouble()


fun Double.mul(d2: Double, decimalPoint: Int = DECIMAL_POINT_NUMBER): Double =
    BigDecimal(this).multiply(BigDecimal(d2)).setScale(decimalPoint, BigDecimal.ROUND_DOWN)
        .toDouble()


fun Double.div(d2: Double, decimalPoint: Int = DECIMAL_POINT_NUMBER): Double =
    BigDecimal(this).divide(BigDecimal(d2)).setScale(decimalPoint, BigDecimal.ROUND_DOWN)
        .toDouble()




fun Int.getWan(): String = if (this >= 10000) "${floor(this / 10000.00 * 10) / 10}W" else "$this"



