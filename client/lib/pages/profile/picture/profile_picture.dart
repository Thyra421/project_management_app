import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:hyper_tools/components/future_widget/provider_resolver.dart';
import 'package:hyper_tools/components/shimmer_placeholder.dart';
import 'package:hyper_tools/extensions/error_model_extension.dart';
import 'package:hyper_tools/http/requests/picture/get_picture.dart';
import 'package:hyper_tools/http/requests/picture/post_picture.dart';
import 'package:hyper_tools/models/error_model.dart';
import 'package:hyper_tools/models/picture/picture_model.dart';
import 'package:hyper_tools/pages/profile/picture/profile_picture_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatelessWidget {
  ProfilePicture({super.key});

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _loadPicture(BuildContext context) async {
    final ProfilePictureProvider provider =
        context.read<ProfilePictureProvider>();

    try {
      final PictureModel picture = await GetPicture().get();

      provider.setSuccessState(picture);
    } on ErrorModel catch (e) {
      provider.setErrorState(e);
    }
  }

  Future<void> _onTapPicture(BuildContext context) async {
    final ProfilePictureProvider provider =
        context.read<ProfilePictureProvider>();

    try {
      final XFile? file =
          await _imagePicker.pickImage(source: ImageSource.gallery);

      if (file == null) return;

      provider.isLoading = true;

      final PictureModel picture =
          await PostPicture(filePath: file.path).send();

      provider.setSuccessState(picture);
    } on ErrorModel catch (e) {
      provider.isLoading = false;
      e.show();
    }
  }

  Widget _imageLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;

    return const ShimmerPlaceholder(
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _imageErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) =>
      const Center(child: Icon(Boxicons.bx_error));

  ColoredBox _noPicture(BuildContext context) => ColoredBox(
        color: Theme.of(context).colorScheme.secondary,
        child: const Center(
          child: Icon(Boxicons.bxs_user, size: 32, color: Colors.white),
        ),
      );

  Image _picture(ProfilePictureProvider provider) => Image.network(
        provider.picture!.url!,
        fit: BoxFit.cover,
        errorBuilder: _imageErrorBuilder,
        loadingBuilder: _imageLoadingBuilder,
      );

  Widget _builder(BuildContext context) => InkWell(
        onTap: () async => _onTapPicture(context),
        child: Builder(
          builder: (BuildContext builderContext) {
            final ProfilePictureProvider provider =
                builderContext.watch<ProfilePictureProvider>();

            if (provider.picture?.url == null) return _noPicture(context);

            return _picture(provider);
          },
        ),
      );

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<ProfilePictureProvider>(
        create: (_) => ProfilePictureProvider(),
        builder: (BuildContext providerContext, _) =>
            ProviderResolver<ProfilePictureProvider>.future(
          builder: _builder,
          future: () async => _loadPicture(providerContext),
        ),
      );
}
