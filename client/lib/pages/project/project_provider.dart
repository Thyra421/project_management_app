import 'package:hyper_tools/components/future_widget/provider_base.dart';
import 'package:hyper_tools/models/project/project_model.dart';
import 'package:hyper_tools/models/project/task/task_preview_model.dart';

class ProjectProvider extends ProviderBase {
  ProjectProvider() : super(isInitiallyLoading: true);

  ProjectModel? _project;

  ProjectModel? get project => _project;

  set project(ProjectModel? value) {
    _project = value;
    notifyListeners();
  }

  TaskPreviewModel? findTaskPreview(String taskId) => project?.taskPreviews
      .firstWhere((TaskPreviewModel taskPreview) => taskPreview.id == taskId);

  void setTaskStartDate({required String taskId, required DateTime date}) {
    if (_project == null) return;

    findTaskPreview(taskId)?.startDate = date;

    notifyListeners();
  }

  void setTaskEndDate({required String taskId, required DateTime date}) {
    if (_project == null) return;

    findTaskPreview(taskId)?.endDate = date;

    notifyListeners();
  }

  void setTaskName({required String taskId, required String name}) {
    if (_project == null) return;

    findTaskPreview(taskId)?.name = name;

    notifyListeners();
  }

  void setTaskOwner({required String taskId, required String name}) {
    if (project == null) return;

    findTaskPreview(taskId)?.ownerName = name;

    notifyListeners();
  }

  void setTaskProgress({required String taskId, required int progress}) {
    if (project == null) return;

    findTaskPreview(taskId)?.progress = progress;

    notifyListeners();
  }

  void addTaskPreview(TaskPreviewModel taskPreview) {
    if (project == null) return;

    _project!.taskPreviews.add(taskPreview);

    notifyListeners();
  }

  void deleteTaskPreview(String taskId) {
    if (project == null) return;

    _project!.taskPreviews.removeWhere(
      (TaskPreviewModel taskPreview) => taskPreview.id == taskId,
    );

    notifyListeners();
  }

  void setName(String name) {
    if (project == null) return;

    _project!.name = name;

    notifyListeners();
  }
}
