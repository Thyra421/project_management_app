import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hyper_tools/extensions/error_model_extension.dart';
import 'package:hyper_tools/extensions/text_editing_controller_extension.dart';
import 'package:hyper_tools/global/messenger.dart';
import 'package:hyper_tools/helpers/role_helper.dart';
import 'package:hyper_tools/http/requests/project/task/subtask/delete_subtask.dart';
import 'package:hyper_tools/http/requests/project/task/subtask/patch_subtask.dart';
import 'package:hyper_tools/models/error_model.dart';
import 'package:hyper_tools/models/project/task/subtask/subtask_model.dart';
import 'package:hyper_tools/pages/project/project_provider.dart';
import 'package:hyper_tools/pages/task/components/subtask/subtask_provider.dart';
import 'package:hyper_tools/pages/task/task_provider.dart';
import 'package:provider/provider.dart';

class Subtask extends StatelessWidget {
  const Subtask(this.subtask, {super.key});

  final SubtaskModel subtask;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<SubtaskProvider>(
        create: (_) => SubtaskProvider(initialName: subtask.name),
        child: _SubtaskBuilder(subtask),
      );
}

class _SubtaskBuilder extends HookWidget {
  const _SubtaskBuilder(this.subtask);

  final SubtaskModel subtask;

  Future<void> _onClickDelete(BuildContext context) async {
    final TaskProvider provider = context.read<TaskProvider>();

    try {
      await DeleteSubtask(
        projectId: provider.projectId,
        taskId: provider.taskId,
        subtaskId: subtask.id,
      ).send();

      provider.deleteSubtask(subtaskId: subtask.id);

      if (context.mounted) Messenger.showSnackBarQuickInfo('Supprimé', context);
    } on ErrorModel catch (e) {
      e.show();
    }
  }

  void _onNameChanged(BuildContext context, String name) {
    context.read<SubtaskProvider>().currentName = name;
  }

  Future<void> _onCheckboxChanged(BuildContext context, bool value) async {
    final TaskProvider provider = context.read<TaskProvider>();

    try {
      await PatchSubtask(
        projectId: provider.projectId,
        taskId: provider.taskId,
        subtaskId: subtask.id,
        isDone: value,
      ).send();

      provider.setSubtaskIsDone(subtaskId: subtask.id, value: value);

      if (context.mounted) {
        Messenger.showSnackBarQuickInfo('Sauvegardé', context);
      }
    } on ErrorModel catch (e) {
      e.show();
    }
  }

  Future<void> _onPressSave(BuildContext context) async {
    final String? name = context.read<SubtaskProvider>().currentName;
    final TaskProvider provider = context.read<TaskProvider>();

    try {
      await PatchSubtask(
        projectId: provider.projectId,
        taskId: provider.taskId,
        subtaskId: subtask.id,
        name: name,
      ).send();

      provider.setSubtaskName(subtaskId: subtask.id, value: name);

      if (context.mounted) {
        Messenger.showSnackBarQuickInfo('Sauvegardé', context);
      }
    } on ErrorModel catch (e) {
      e.show();
    }
  }

  TextField _nameField(TextEditingController controller) => TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        decoration: const InputDecoration(
          filled: false,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      );

  SlidableAction _deleteButton() => SlidableAction(
        onPressed: _onClickDelete,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.red,
        label: 'Supprimer',
        borderRadius: BorderRadius.circular(16),
      );

  Widget _buildSaveButton() => Builder(
        builder: (BuildContext context) => TextButton(
          onPressed: () async => _onPressSave(context),
          child: const Text('Sauvegarder'),
        ),
      );

  Widget _buildCheckbox() => Builder(
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Checkbox(
            value: subtask.isDone,
            onChanged: (bool? value) async => RoleHelper.canEditTask(
              context.read<ProjectProvider>().project!.role,
            )
                ? _onCheckboxChanged(context, value!)
                : null,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        useTextEditingController(text: subtask.name);

    useEffect(
      controller
          .onValueChanged((String value) => _onNameChanged(context, value)),
      <Object?>[],
    );

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: <Widget>[_deleteButton()],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildCheckbox(),
            Expanded(child: _nameField(controller)),
            if (subtask.name !=
                context.select<SubtaskProvider, String?>(
                  (SubtaskProvider provider) => provider.currentName,
                ))
              _buildSaveButton(),
          ],
        ),
      ),
    );
  }
}
