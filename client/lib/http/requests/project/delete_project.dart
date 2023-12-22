import 'package:hyper_tools/helpers/route_helper.dart';
import 'package:hyper_tools/http/requests/delete_request.dart';

class DeleteProject extends DeleteRequest<void> {
  DeleteProject({required this.projectId});

  final String projectId;

  @override
  Map<String, dynamic>? get body => null;

  @override
  void builder(Map<String, dynamic> json) {}

  @override
  bool get private => true;

  @override
  Uri get uri => RouteHelper.buildUri('project/$projectId');
}
