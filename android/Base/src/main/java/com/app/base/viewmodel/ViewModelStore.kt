package com.app.base.viewmodel
import androidx.activity.ComponentActivity
import androidx.fragment.app.Fragment
import androidx.lifecycle.*


private val vMStores = HashMap<String, VMStore>()//作用域对应的商店


fun ComponentActivity.injectViewModel() {

    this::class.java.declaredFields.forEach { field ->
        field.getAnnotation(VMScope::class.java)?.also { scope ->
            val element = scope.scopeName
            val store: VMStore
            if (vMStores.keys.contains(element)) {
                store = vMStores[element]!!
            } else {
                store = VMStore()
                vMStores[element] = store
            }
            store.bindHost(this)
            val clazz = field.type as Class<ViewModel>
            val vm = ViewModelProvider(store, VMFactory()).get(clazz)
            field.set(this, vm)
        }
    }
}



fun Fragment.injectViewModel() {

    this::class.java.declaredFields.forEach { field ->
        field.getAnnotation(VMScope::class.java)?.also { scope ->
            val element = scope.scopeName
            val store: VMStore
            if (vMStores.keys.contains(element)) {
                store = vMStores[element]!!
            } else {
                store = VMStore()
                vMStores[element] = store
            }
            store.bindHost(this)
            val clazz = field.type as Class<ViewModel>
            val vm = ViewModelProvider(store, VMFactory()).get(clazz)
            //给view model赋值
            field.set(this, vm)
        }
    }
}


class VMStore : ViewModelStoreOwner {

    private val bindTargets = ArrayList<LifecycleOwner>()
    private var vmStore: ViewModelStore? = null


    fun bindHost(host: LifecycleOwner) {
        if (!bindTargets.contains(host)) {
            bindTargets.add(host)
            host.lifecycle.addObserver(object : LifecycleEventObserver {
                override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                    if (event == Lifecycle.Event.ON_DESTROY) {
                        bindTargets.remove(host)
                        if (bindTargets.isEmpty()) {
                            vMStores.entries.find { it.value == this@VMStore }?.also {
                                vmStore?.clear()
                                vMStores.remove(it.key)
                            }
                        }
                    }
                }
            })
        }
    }

    override fun getViewModelStore(): ViewModelStore {
        if (vmStore == null)
            vmStore = ViewModelStore()
        return vmStore!!
    }
}

class VMFactory : ViewModelProvider.Factory {
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return modelClass.newInstance()
    }

}