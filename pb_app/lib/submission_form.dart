import 'dart:io';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pb_app/modals.dart';
import 'package:pb_app/utils.dart';

class SubmissionFormScreen extends StatefulWidget {
  const SubmissionFormScreen._();

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return const SubmissionFormScreen._();
        },
      ),
    );
  }

  @override
  State<SubmissionFormScreen> createState() => _SubmissionFormScreenState();
}

class _SubmissionFormScreenState extends State<SubmissionFormScreen> {
  // used to hide the centered hint when focused
  final _nameFocusNode = FocusNode();

  // Home screen and lock screen page view controller
  final _pageController = PageController(
    viewportFraction: 0.9,
  );

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _nameFocusNode,
                    builder: (context, _) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: platformAwareBorderRadius(10),
                          color: Colors.black12,
                        ),
                        child: TextField(
                          autofocus: true,
                          focusNode: _nameFocusNode,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: _nameFocusNode.hasFocus ? '' : 'Name',
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: const [
            _Card('Home Screen'),
            _Card('Lock Screen'),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: SmoothRectangleBorder(
                borderRadius: platformAwareBorderRadius(10),
              ),
            ),
            child: const Text('Continue to Details'),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatefulWidget {
  const _Card(this.title);

  final String title;

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 5,
      ),
      color: Colors.black38,
      shape: platformAwareShape(50),
      child: InkWell(
        onTap: () async {
          try {
            final xfile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (xfile == null || !mounted) return;
            setState(() {
              image = File(xfile.path);
            });
          } catch (e) {
            if (kDebugMode && mounted) {
              ToastProvider.of(context).showToast(e.toString());
            }
          }
        },
        splashColor: Colors.black12,
        highlightColor: Colors.black12,
        customBorder: platformAwareShape(50),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(SmoothRadius(
                  cornerRadius: 50,
                  cornerSmoothing: Platform.isIOS ? 0.6 : 0.2,
                )),
                image: image != null
                    ? DecorationImage(
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            Center(
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.7),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: platformAwareBorderRadius(99),
                ),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
