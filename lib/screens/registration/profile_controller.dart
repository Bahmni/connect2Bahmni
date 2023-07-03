class ProfileController<T> {
  T? data;

  void setData(T data) {
    this.data = data;
  }

  T? getData() {
    return data;
  }
}