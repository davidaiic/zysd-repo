@file:Suppress(
    "UNCHECKED_CAST",
    "unused",
    "NON_PUBLIC_CALL_FROM_PUBLIC_INLINE",
    "SpellCheckingInspection"
)

package com.app.base.utils

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.BaseBundle
import android.os.Build
import android.os.Bundle
import android.os.Parcelable
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentFactory
import java.io.Serializable
import java.lang.reflect.Field
import java.lang.reflect.Method
import kotlin.properties.ReadWriteProperty
import kotlin.reflect.KClass
import kotlin.reflect.KProperty


object ActivityMessenger {
    private var sRequestCode = 0
        set(value) {
            field = if (value >= Integer.MAX_VALUE) 1 else value
        }


    inline fun <reified TARGET : Activity> startActivity(
        starter: FragmentActivity,
        vararg params: Pair<String, Any>
    ) = starter.startActivity(Intent(starter, TARGET::class.java).putExtras(*params))


    inline fun <reified TARGET : Activity> startActivity(
        starter: Fragment,
        vararg params: Pair<String, Any>
    ) = starter.startActivity(Intent(starter.context, TARGET::class.java).putExtras(*params))


    inline fun <reified TARGET : Activity> startActivity(
        starter: Context,
        vararg params: Pair<String, Any>
    ) = starter.startActivity(Intent(starter, TARGET::class.java).putExtras(*params))


    fun startActivity(
        starter: FragmentActivity,
        target: KClass<out Activity>,
        vararg params: Pair<String, Any>
    ) = starter.startActivity(Intent(starter, target.java).putExtras(*params))


    fun startActivity(
        starter: Fragment,
        target: KClass<out Activity>,
        vararg params: Pair<String, Any>
    ) = starter.startActivity(Intent(starter.context, target.java).putExtras(*params))


    fun startActivity(
        starter: Context,
        target: KClass<out Activity>,
        vararg params: Pair<String, Any>
    ) = starter.startActivity(Intent(starter, target.java).putExtras(*params))


    inline fun <reified TARGET : Activity> startActivityForResult(
        starter: FragmentActivity,
        vararg params: Pair<String, Any>,
        crossinline callback: ((result: Intent?) -> Unit)
    ) = startActivityForResult(starter, TARGET::class, *params, callback = callback)


    inline fun <reified TARGET : Activity> startActivityForResult(
        starter: Fragment,
        vararg params: Pair<String, Any>,
        crossinline callback: ((result: Intent?) -> Unit)
    ) = startActivityForResult(starter.activity, TARGET::class, *params, callback = callback)


    inline fun startActivityForResult(
        starter: FragmentActivity?,
        target: KClass<out Activity>,
        vararg params: Pair<String, Any>,
        crossinline callback: ((result: Intent?) -> Unit)
    ) {
        starter ?: return
        startActivityForResult(starter, Intent(starter, target.java).putExtras(*params), callback)
    }

    inline fun startActivityForResult(
        starter: FragmentActivity?,
        intent: Intent, crossinline callback: ((result: Intent?) -> Unit)
    ) {
        starter ?: return
        val fm = starter.supportFragmentManager
        val fragment = GhostFragment()
        fragment.init(++sRequestCode, intent) { result ->
            callback(result)
            fm.beginTransaction().remove(fragment).commitAllowingStateLoss()
        }
        fm.beginTransaction().add(fragment, GhostFragment::class.java.simpleName)
            .commitAllowingStateLoss()
    }


    fun finish(src: Activity, vararg params: Pair<String, Any>) = with(src) {
        setResult(Activity.RESULT_OK, Intent().putExtras(*params))
        finish()
    }


    fun finish(src: Fragment, vararg params: Pair<String, Any>) =
        src.activity?.run { finish(this, *params) }
}



fun <O> Intent.get(key: String, defaultValue: O? = null): O? {
    try {
        val extras = IntentFieldMethod.mExtras.get(this) as? Bundle ?: return defaultValue
        IntentFieldMethod.unparcel.invoke(extras)
        val map = IntentFieldMethod.mMap.get(extras) as? Map<String, Any> ?: return defaultValue
        return map[key] as? O ?: return defaultValue
    } catch (e: Exception) {
        //Ignore
    }
    return defaultValue
}


fun <O> Bundle.get(key: String, defaultValue: O? = null): O? {
    try {
        IntentFieldMethod.unparcel.invoke(this)
        val map = IntentFieldMethod.mMap.get(this) as? Map<String, Any> ?: return defaultValue
        return map[key] as? O ?: return defaultValue
    } catch (e: Exception) {
        //Ignore
    }
    return defaultValue
}

fun Intent.putExtras(vararg params: Pair<String, Any>): Intent {
    if (params.isEmpty()) return this
    params.forEach { (key, value) ->
        when (value) {
            is Int -> putExtra(key, value)
            is Byte -> putExtra(key, value)
            is Char -> putExtra(key, value)
            is Long -> putExtra(key, value)
            is Float -> putExtra(key, value)
            is Short -> putExtra(key, value)
            is Double -> putExtra(key, value)
            is Boolean -> putExtra(key, value)
            is Bundle -> putExtra(key, value)
            is String -> putExtra(key, value)
            is IntArray -> putExtra(key, value)
            is ByteArray -> putExtra(key, value)
            is CharArray -> putExtra(key, value)
            is LongArray -> putExtra(key, value)
            is FloatArray -> putExtra(key, value)
            is Parcelable -> putExtra(key, value)
            is ShortArray -> putExtra(key, value)
            is DoubleArray -> putExtra(key, value)
            is BooleanArray -> putExtra(key, value)
            is CharSequence -> putExtra(key, value)
            is Serializable -> {
                putExtra(key, value)
            }

            is Array<*> -> {
                when {
                    value.isArrayOf<String>() ->
                        putExtra(key, value as Array<String?>)
                    value.isArrayOf<Parcelable>() ->
                        putExtra(key, value as Array<Parcelable?>)
                    value.isArrayOf<CharSequence>() ->
                        putExtra(key, value as Array<CharSequence?>)
                    else -> putExtra(key, value)
                }
            }

        }
    }
    return this
}

fun Bundle.putExtras(vararg params: Pair<String, Any>): Bundle {
    if (params.isEmpty()) return this
    params.forEach { (key, value) ->
        when (value) {
            is Int -> putInt(key, value)
            is Byte -> putByte(key, value)
            is Char -> putChar(key, value)
            is Long -> putLong(key, value)
            is Float -> putFloat(key, value)
            is Short -> putShort(key, value)
            is Double -> putDouble(key, value)
            is Boolean -> putBoolean(key, value)
            is Bundle -> putBundle(key, value)
            is String -> putString(key, value)
            is IntArray -> putIntArray(key, value)
            is ByteArray -> putByteArray(key, value)
            is CharArray -> putCharArray(key, value)
            is LongArray -> putLongArray(key, value)
            is FloatArray -> putFloatArray(key, value)
            is Parcelable -> putParcelable(key, value)
            is ShortArray -> putShortArray(key, value)
            is DoubleArray -> putDoubleArray(key, value)
            is BooleanArray -> putBooleanArray(key, value)
            is CharSequence -> putCharSequence(key, value)
            is Serializable -> putSerializable(key, value)
            is Array<*> -> {
                when {
                    value.isArrayOf<String>() ->
                        putStringArray(key, value as Array<String?>)
                    value.isArrayOf<Parcelable>() ->
                        putParcelableArray(key, value as Array<Parcelable?>)
                    value.isArrayOf<CharSequence>() ->
                        putCharSequenceArray(key, value as Array<CharSequence?>)
                    else -> putSerializable(key, value)
                }
            }

        }
    }
    return this
}

class GhostFragment : Fragment() {

    private var requestCode = -1
    private var intent: Intent? = null
    private var callback: ((result: Intent?) -> Unit)? = null

    fun init(requestCode: Int, intent: Intent, callback: ((result: Intent?) -> Unit)) {
        this.requestCode = requestCode
        this.intent = intent
        this.callback = callback
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        intent?.let { startActivityForResult(it, requestCode) }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == this.requestCode) {
            val result = if (resultCode == Activity.RESULT_OK && data != null) data else null
            callback?.let { it(result) }
        }
    }

    override fun onDetach() {
        super.onDetach()
        intent = null
        callback = null
    }
}

internal object IntentFieldMethod {
    lateinit var mExtras: Field
    lateinit var mMap: Field
    lateinit var unparcel: Method

    init {
        try {
            mExtras = Intent::class.java.getDeclaredField("mExtras")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                mMap = BaseBundle::class.java.getDeclaredField("mMap")
                unparcel = BaseBundle::class.java.getDeclaredMethod("unparcel")
            } else {
                mMap = Bundle::class.java.getDeclaredField("mMap")
                unparcel = Bundle::class.java.getDeclaredMethod("unparcel")
            }
            mExtras.isAccessible = true
            mMap.isAccessible = true
            unparcel.isAccessible = true
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}

class ActivityExtras<T>(private val extraName: String, private val defaultValue: T) :
    ReadWriteProperty<Activity, T> {


    private var extra: T? = null

    override fun getValue(thisRef: Activity, property: KProperty<*>): T {

        return extra ?: thisRef.intent?.get<T>(extraName)?.also { extra = it }
        ?: defaultValue.also { extra = it }
    }

    override fun setValue(thisRef: Activity, property: KProperty<*>, value: T) {
        extra = value
    }
}


class FragmentExtras<T>(private val extraName: String, private val defaultValue: T) :
    ReadWriteProperty<Fragment, T> {


    private var extra: T? = null

    override fun getValue(thisRef: Fragment, property: KProperty<*>): T {

        return extra ?: thisRef.arguments?.get<T>(extraName)?.also { extra = it }
        ?: defaultValue.also { extra = it }
    }

    override fun setValue(thisRef: Fragment, property: KProperty<*>, value: T) {
        extra = value
    }
}

fun <T> extraFrag(extraName: String): FragmentExtras<T?> = FragmentExtras(extraName, null)

fun <T> extraFrag(extraName: String, defaultValue: T): FragmentExtras<T> =
    FragmentExtras(extraName, defaultValue)


fun <T> extraAct(extraName: String): ActivityExtras<T?> = ActivityExtras(extraName, null)

fun <T> extraAct(extraName: String, defaultValue: T): ActivityExtras<T> =
    ActivityExtras(extraName, defaultValue)


inline fun <reified T : Fragment> Context.newInstanceFragment(vararg params: Pair<String, Any>): T {
    val args = Bundle().putExtras(*params)
    val className = T::class.java.name;
    val clazz = FragmentFactory.loadFragmentClass(
        classLoader, className
    )
    val f = clazz.getConstructor().newInstance()
    if (args != null) {
        args.classLoader = f.javaClass.classLoader
        f.arguments = args
    }
    return f as T
}





inline fun <reified TARGET : Activity> Activity.startActivity(
    vararg params: Pair<String, Any>
) = startActivity(Intent(this, TARGET::class.java).putExtras(*params))

inline fun <reified TARGET : FragmentActivity> FragmentActivity.startActivity(
    vararg params: Pair<String, Any>
) = startActivity(Intent(this, TARGET::class.java).putExtras(*params))


inline fun <reified TARGET : Activity> Context.startActivity(
    vararg params: Pair<String, Any>
) = startActivity(Intent(this, TARGET::class.java).putExtras(*params))

inline fun <reified TARGET : Activity> Fragment.startActivity(
    vararg params: Pair<String, Any>
) = activity?.run {
    startActivity(Intent(this, TARGET::class.java).putExtras(*params))
}

fun FragmentActivity.startActivity(
    target: KClass<out Activity>, vararg params: Pair<String, Any>
) = startActivity(Intent(this, target.java).putExtras(*params))

fun Fragment.startActivity(
    target: KClass<out Activity>, vararg params: Pair<String, Any>
) = activity?.run {
    startActivity(Intent(this, target.java).putExtras(*params))
}

inline fun <reified TARGET : Activity> FragmentActivity.startActivityForResult(
    vararg params: Pair<String, Any>, crossinline callback: ((result: Intent?) -> Unit)
) = startActivityForResult(TARGET::class, *params, callback = callback)

inline fun <reified TARGET : Activity> Fragment.startActivityForResult(
    vararg params: Pair<String, Any>, crossinline callback: ((result: Intent?) -> Unit)
) = activity?.startActivityForResult(TARGET::class, *params, callback = callback)

inline fun FragmentActivity.startActivityForResult(
    target: KClass<out Activity>, vararg params: Pair<String, Any>,
    crossinline callback: ((result: Intent?) -> Unit)
) = ActivityMessenger.startActivityForResult(this, target, *params, callback = callback)


inline fun Fragment.startActivityForResult(
    target: KClass<out Activity>, vararg params: Pair<String, Any>,
    crossinline callback: ((result: Intent?) -> Unit)
) = activity?.run {
    ActivityMessenger.startActivityForResult(this, target, *params, callback = callback)
}

fun Activity.finish(vararg params: Pair<String, Any>) = run {
    setResult(Activity.RESULT_OK, Intent().putExtras(*params))
    finish()
}

fun Activity.finish(intent: Intent) = run {
    setResult(Activity.RESULT_OK, intent)
    finish()
}

fun String.toIntent(flags: Int = 0): Intent = Intent(this).setFlags(flags)

inline fun FragmentActivity?.startActivityForResult(
    intent: Intent, crossinline callback: ((result: Intent?) -> Unit)
) = this?.run {
    ActivityMessenger.startActivityForResult(this, intent, callback)
}

inline fun Fragment.startActivityForResult(
    intent: Intent, crossinline callback: ((result: Intent?) -> Unit)
) = activity?.run {
    ActivityMessenger.startActivityForResult(this, intent, callback)
}



inline fun FragmentActivity.registerForActivityResult(crossinline callback: ((result: Intent?) -> Unit)): ActivityResultLauncher<Intent> {
    return registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { activityResult ->
        if (activityResult.resultCode == Activity.RESULT_OK) {
            activityResult.data.let {
                callback.invoke(it)
            }
        }
    }
}

inline fun Fragment.registerForActivityResult(crossinline callback: ((result: Intent) -> Unit)): ActivityResultLauncher<Intent> {
    return registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { activityResult ->
        if (activityResult.resultCode == Activity.RESULT_OK) {
            activityResult.data?.let {
                callback.invoke(it)
            }
        }
    }
}



inline fun <reified TARGET : FragmentActivity> FragmentActivity.startActivityForResult(myActivityLauncher: ActivityResultLauncher<Intent>, vararg params: Pair<String, Any>) {
    val intent = Intent(this, TARGET::class.java).putExtras(*params)
    myActivityLauncher.launch(intent)
}

inline fun <reified TARGET : FragmentActivity> FragmentActivity.startActivityForResult(myActivityLauncher: ActivityResultLauncher<Intent>, intent: Intent) {
    myActivityLauncher.launch(intent)
}

inline fun <reified TARGET : FragmentActivity> Fragment.startActivityForResult(myActivityLauncher: ActivityResultLauncher<Intent>, vararg params: Pair<String, Any>) {
    val intent = Intent(this.activity, TARGET::class.java).putExtras(*params)
    myActivityLauncher.launch(intent)
}

