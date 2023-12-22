import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hyper_tools/components/evenly_sized_children.dart';
import 'package:hyper_tools/components/texts/title_text.dart';
import 'package:hyper_tools/extensions/num_extension.dart';
import 'package:hyper_tools/models/project/project_preview_model.dart';
import 'package:hyper_tools/models/project/project_role.dart';
import 'package:hyper_tools/pages/home/home_page_provider.dart';
import 'package:provider/provider.dart';

class CreateProjectModal extends HookWidget {
  const CreateProjectModal({super.key});

  Future<void> _onClickCreate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final ProjectPreviewModel preview = ProjectPreviewModel(
      id: '',
      membersCount: 1,
      name: controller.text,
      role: ProjectRole.owner,
    );

    final HomePageProvider provider = context.read<HomePageProvider>();

    provider.projects!.projects.add(preview);
    provider.notifyListeners();

    Navigator.pop(context);
  }

  Text get _description => const Text(
        'En créant un projet vous en devenez propriétaire et avez la possibilité de gérer vos collaborateurs.',
      );

  TitleText get _title => const TitleText('Créer un nouveau projet');

  ElevatedButton _createButton(
    BuildContext context,
    TextEditingController controller,
  ) =>
      ElevatedButton(
        onPressed: () async => _onClickCreate(context, controller),
        child: const Text('Créer'),
      );

  TextButton _cancelButton(BuildContext context) => TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Annuler'),
      );

  TextField _nameField(TextEditingController controller) => TextField(
        decoration: const InputDecoration(hintText: 'Nom du projet'),
        controller: controller,
      );

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController();

    return Dialog(
      child: Padding(
        padding: 32.a,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _title,
            16.ph,
            _description,
            32.ph,
            _nameField(controller),
            16.ph,
            EvenlySizedChildren(
              children: <Widget>[
                _cancelButton(context),
                _createButton(context, controller),
              ],
            ),
          ],
        ),
      ),
    );
  }
}