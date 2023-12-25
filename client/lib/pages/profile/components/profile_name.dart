import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hyper_tools/extensions/error_model_extension.dart';
import 'package:hyper_tools/global/messenger.dart';
import 'package:hyper_tools/http/requests/user/patch_me.dart';
import 'package:hyper_tools/models/error_model.dart';
import 'package:hyper_tools/pages/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileName extends HookWidget {
  const ProfileName({super.key});

  void _onNameChanged(
    BuildContext context,
    TextEditingController controller,
  ) {
    context.read<ProfileProvider>().currentName = controller.text;
  }

  void Function() _initializeController(
    BuildContext context,
    TextEditingController controller,
  ) {
    void listener() => _onNameChanged(context, controller);

    controller.addListener(listener);

    return () => controller.removeListener(listener);
  }

  Future<void> _onClickSave(BuildContext context) async {
    try {
      final String? name = context.read<ProfileProvider>().currentName;

      await PatchMe(name: name).patch();

      context.read<ProfileProvider>().setName(name!);

      Messenger.showSnackBarQuickInfo('Sauvegardé', context);
      FocusScope.of(context).unfocus();
    } on ErrorModel catch (e) {
      e.show();
    }
  }

  Widget _saveButton(BuildContext context) {
    final ProfileProvider provider = context.watch<ProfileProvider>();

    if (provider.currentName != null &&
        provider.currentName!.isNotEmpty &&
        provider.currentName != provider.me?.name) {
      return TextButton(
        onPressed: () async => _onClickSave(context),
        child: const Text('Enregistrer'),
      );
    }
    return const SizedBox.shrink();
  }

  TextField _textField(
    BuildContext context,
    TextEditingController controller,
  ) =>
      TextField(
        style: Theme.of(context).appBarTheme.titleTextStyle,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        decoration: const InputDecoration(
            hintText: 'Écrire votre nom', prefixIcon: Icon(Boxicons.bx_user)),
      );

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController(
      text: context.read<ProfileProvider>().me?.name,
    );

    useEffect(() => _initializeController(context, controller));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(child: _textField(context, controller)),
        _saveButton(context),
      ],
    );
  }
}