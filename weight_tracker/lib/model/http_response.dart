class HTTPResponse<T>{
  bool isSuccessful;
  T? data;
  String message="";
  int code = 100;
  HTTPResponse(this.isSuccessful, this.data, this.code, this.message  );
  
}