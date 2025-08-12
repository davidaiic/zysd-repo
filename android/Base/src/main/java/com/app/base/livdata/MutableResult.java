package com.app.base.livdata;


public class MutableResult<T> extends Result<T> {

  public MutableResult(T value) {
    super(value);
  }

  public MutableResult() {
    super();
  }


  public void setValue(T value) {
    super.setValue(value);
  }


  public void postValue(T value) {
    super.postValue(value);
  }

  public static class Builder<T> {
    private boolean isAllowNullValue;

    public Builder() {
    }

    public Builder<T> setAllowNullValue(boolean allowNullValue) {
      this.isAllowNullValue = allowNullValue;
      return this;
    }

    public MutableResult<T> create() {
      MutableResult<T> liveData = new MutableResult<>();
      liveData.isAllowNullValue = this.isAllowNullValue;
      return liveData;
    }
  }
}
