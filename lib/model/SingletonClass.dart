class SingletonClass {
  static final SingletonClass _singleton = SingletonClass._internal();
  String isHomePageLoaded;
  String isChatPageLoaded;

  factory SingletonClass() {
    return _singleton;
  }

  setIsHomeLoaded(String flag){
    isHomePageLoaded = flag;
  }

  setIsChatLoaded(String flag){
    isChatPageLoaded = flag;
  }

  SingletonClass._internal();
}