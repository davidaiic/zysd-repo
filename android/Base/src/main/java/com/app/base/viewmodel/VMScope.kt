package com.app.base.viewmodel

@Retention(AnnotationRetention.RUNTIME)
@Target(AnnotationTarget.FIELD)
annotation class VMScope(val scopeName: String) {
}