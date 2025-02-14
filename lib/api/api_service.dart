
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'api_model.dart';

part 'api_service.g.dart';

class Apis{
  static const String todo = '/todos';
}

@RestApi(baseUrl: "https://dummyjson.com")
abstract class ApiClient{
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(Apis.todo)
  Future<TodoResponse> getTodo();

}