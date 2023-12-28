import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hyper_tools/extensions/error_model_extension.dart';
import 'package:hyper_tools/extensions/text_editing_controller_extension.dart';
import 'package:hyper_tools/global/messenger.dart';
import 'package:hyper_tools/helpers/role_helper.dart';
import 'package:hyper_tools/http/requests/project/task/patch_task.dart';
import 'package:hyper_tools/models/error_model.dart';
import 'package:hyper_tools/pages/project/project_provider.dart';
import 'package:hyper_tools/pages/task/components/name/task_name_provider.dart';
import 'package:hyper_tools/pages/task/task_provider.dart';
import 'package:provider/provider.dart';

class TaskName extends StatelessWidget {
  const TaskName({
    required this.projectId,
    required this.taskId,
    super.key,
  });

  final String projectId;
  final String taskId;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<TaskNameProvider>(
        create: (_) => TaskNameProvider(
          initialName: context.read<TaskProvider>().task?.name,
        ),
        child: _TaskNameBuilder(
          projectId: projectId,
          taskId: taskId,
        ),
      );
}

class _TaskNameBuilder extends HookWidget {
  const _TaskNameBuilder({
    required this.projectId,
    required this.taskId,
  });

  final String projectId;
  final String taskId;

  void _onNameChanged(BuildContext context, String name) {
    context.read<TaskNameProvider>().currentName = name;
  }

  Future<void> _onClickSave(BuildContext context) async {
    try {
      final TaskNameProvider provider = context.read<TaskNameProvider>();
      final TaskProvider taskProvider = context.read<TaskProvider>();

      await PatchTask(
        projectId: projectId,
        taskId: taskId,
        name: provider.currentName,
      ).patch();

      taskProvider.setName(provider.currentName);

      if (context.mounted) {
        FocusScope.of(context).unfocus();
        Messenger.showSnackBarQuickInfo('Sauvegardé', context);
      }
    } on ErrorModel catch (e) {
      e.show();
    }
  }

  Widget _buildNameField(TextEditingController controller) => Builder(
        builder: (BuildContext context) => TextField(
          readOnly: !RoleHelper.canEditTask(
            context.read<ProjectProvider>().project!.role,
          ),
          style: Theme.of(context).appBarTheme.titleTextStyle,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Écrire un nom',
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      );

  Widget _buildSaveButton() => Builder(
        builder: (BuildContext context) => TextButton(
          onPressed: () async => _onClickSave(context),
          child: const Text('Enregistrer'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        useTextEditingController(text: context.read<TaskProvider>().task?.name);

    useEffect(
      controller
          .onValueChanged((String value) => _onNameChanged(context, value)),
      <Object?>[],
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: _buildNameField(controller)),
        if (context.select<TaskNameProvider, String?>(
              (TaskNameProvider provider) => provider.currentName,
            ) !=
            context.watch<TaskProvider>().task?.name)
          _buildSaveButton(),
      ],
    );
  }
}
