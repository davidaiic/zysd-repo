package com.app.base.livdata;


public class Result<T> extends ProtectedUnPeekLiveData<T> {

  public Result(T value) {
    super(value);
  }

  public Result() {
    super();
  }

}
