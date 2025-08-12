package com.app.base.ext

import android.text.TextUtils
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*



fun Long.getDateTimeFromMillis(format: SimpleDateFormat?): String = Date(this).dateSimpleFormat(
    format
        ?: defaultDateTimeFormat.get()
)



fun Long.getDateHourMinuteFromMillis(format: SimpleDateFormat = defaultDateHourMinuteFormat.get()): String = Date(this).dateSimpleFormat(format)


fun Date.dateSimpleFormat(format: SimpleDateFormat): String = format.format(this)



fun String.getFormat(): SimpleDateFormat {
    return SimpleDateFormat(this)
}



fun getNowDate(format: SimpleDateFormat = defaultDateFormat.get()): String {
    val curDate = Date(System.currentTimeMillis()) //获取当前时间
    return format.format(curDate)
}


const val DEFAULT_DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss"


const val DEFAULT_DATE_HOUR_MINUTE_FORMAT = "yyyy-MM-dd HH:mm"


const val DEFAULT_DATE_HOUR_MINUTE_FORMAT2 = "yyyy.MM.dd HH:mm"




const val DEFAULT_FORMAT_DATE = "yyyy-MM-dd"


const val DEFAULT_FORMAT_DATE2 = "yyyy/MM/dd"

const val DEFAULT_FORMAT_DATE3 = "yyyy.MM.dd"

const val DEFAULT_FORMAT_TIME = "HH:mm:ss"



val defaultDateTimeFormat: ThreadLocal<SimpleDateFormat> =
    object : ThreadLocal<SimpleDateFormat>() {

        override fun initialValue(): SimpleDateFormat {
            return SimpleDateFormat(DEFAULT_DATE_TIME_FORMAT)
        }
    }


val defaultDateFormat: ThreadLocal<SimpleDateFormat> =
    object : ThreadLocal<SimpleDateFormat>() {
        override fun initialValue(): SimpleDateFormat {
            return SimpleDateFormat(DEFAULT_FORMAT_DATE)
        }
    }


val defaultDateFormat2: ThreadLocal<SimpleDateFormat> =
    object : ThreadLocal<SimpleDateFormat>() {
        override fun initialValue(): SimpleDateFormat {
            return SimpleDateFormat(DEFAULT_FORMAT_DATE2)
        }
    }


val defaultDateFormat3: ThreadLocal<SimpleDateFormat> =
    object : ThreadLocal<SimpleDateFormat>() {
        override fun initialValue(): SimpleDateFormat {
            return SimpleDateFormat(DEFAULT_FORMAT_DATE3)
        }
    }

val defaultTimeFormat: ThreadLocal<SimpleDateFormat> =
    object : ThreadLocal<SimpleDateFormat>() {
        override fun initialValue(): SimpleDateFormat {
            return SimpleDateFormat(DEFAULT_FORMAT_TIME)
        }
    }


val defaultDateHourMinuteFormat: ThreadLocal<SimpleDateFormat> =
    object : ThreadLocal<SimpleDateFormat>() {
        override fun initialValue(): SimpleDateFormat {
            return SimpleDateFormat(DEFAULT_DATE_HOUR_MINUTE_FORMAT2)
        }
    }


fun getRunTime(getTime: String): String {
    if (TextUtils.isEmpty(getTime)) return "0"
    val restTime = getTime.toLong()
    if (restTime < 0) return "00:00"
    var hour: Long = 0
    var minite: Long = 0
    var second: Long = 0
    if (restTime >= 3600) {
        hour = restTime / 3600
        val temp = restTime % 3600
        if (temp != 0L) {
            if (temp >= 60) {
                minite = temp / 60
                val secTemp = temp % 60
                if (secTemp != 0L) {
                    second = secTemp
                }
            } else {
                val secTemp = temp % 60
                if (secTemp != 0L) {
                    second = secTemp
                }
            }
        }
    } else {
        minite = restTime / 60
        val secTemp = restTime % 60
        if (secTemp != 0L) {
            second = secTemp
        }
    }
    var hourStr = "0"
    hourStr = when {
        hour >= 10 -> {
            "$hour:"
        }
        hour in 1..9 -> {
            "0$hour:"
        }
        else -> {
            ""
        }
    }
    val minStr: String = if (minite < 10) {
        "0$minite:"
    } else {
        "$minite:"
    }
    val secStr: String = if (second < 10) {
        "0$second"
    } else {
        second.toString() + ""
    }
    return hourStr + minStr + secStr
}


fun getCurrDateStart(time: Long): Long {
    return time - (time + TimeZone.getDefault().rawOffset) % (1000 * 3600 * 24)
}


fun getCurrDateEnd(time: Long): Long {
    return time - (time + TimeZone.getDefault().rawOffset) % (1000 * 3600 * 24) + 1000 * (23 * 60 * 60 + 59 * 60 + 59)
}





fun isToday(sdate: String?): Boolean {
    var b = false
    var time: Date? = null
    try {
        time = defaultDateFormat2.get().parse(sdate)
    } catch (e: ParseException) {
        // TODO Auto-generated catch block
        e.printStackTrace()
    }
    val today = Date()
    if (time != null) {
        val nowDate: String = defaultDateFormat2.get().format(today)
        val timeDate: String = defaultDateFormat2.get().format(time)
        if (nowDate == timeDate) {
            b = true
        }
    }
    return b
}






fun isSameDay(millis1: Long, millis2: Long): Boolean {
    val interval = millis1 - millis2
    return interval < 86400000 && interval > -86400000 && millis2Days(millis1, TimeZone.getDefault()) == millis2Days(millis2, TimeZone.getDefault())
}

private fun millis2Days(millis: Long, timeZone: TimeZone): Long {
    return (timeZone.getOffset(millis).toLong() + millis) / 86400000
}


fun getTodayInMonth(): Int {
    val calendar = Calendar.getInstance()
    return calendar[Calendar.DAY_OF_MONTH]
}

