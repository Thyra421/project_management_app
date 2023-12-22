import 'package:hyper_tools/helpers/route_helper.dart';
import 'package:hyper_tools/http/requests/post_request.dart';

class PostTask extends PostRequest<String> {
  PostTask({
    required this.projectId,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
  });

  final String projectId;
  final String name;
  final String description;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Map<String, dynamic>? get body => <String, dynamic>{
        'ownerId': ownerId,
        'description': description,
        'name': name,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

  @override
  String builder(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  bool get private => throw UnimplementedError();

  @override
  Uri get uri => RouteHelper.buildUri('project/$projectId/task');
}
