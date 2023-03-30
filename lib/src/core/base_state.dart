import 'dart:developer';

import 'package:exxe/src/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../app/common/dialog/dialog_control.dart';
import '../config/colors.dart';
import 'base_bloc.dart';

abstract class BaseState<T extends StatefulWidget, B extends BaseController>
    extends State<T> {
  B get bloc;

  bool get dismissKeyboardWhenClickOutside => false;

  // change this flag to true when using your layout
  bool get isCustomLayout => false;

  // set true to not use default loading on base state
  bool get manualControlLoading => false;

  // override this function to catch event click on parent
  void onTapParent() {}

  initData() {}

  @override
  void initState() {
    initData();
    bloc.waitingStream.listen(_listenWaiting);

    bloc.errorStream.listen(_listenError);
    super.initState();
  }

  void _listenError(error) {
    error.showDefaultDialog();
  }

  void _listenWaiting(loading) {
    if (loading) {
      log('show loading');
      AppDialog.I.showLoading();
    } else {
      log('close loading');
      AppDialog.I.closeDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    body = manualControlLoading
        ? buildContent(context)
        : StreamBuilder<bool>(
            stream: bloc.loadingStream,
            builder: (context, snapShot) {
              if (snapShot.data == true || snapShot.data == null) {
                final loading = buildLoading(context);
                return isCustomLayout
                    ? Scaffold(
                        body: Center(
                          child: loading,
                        ),
                      )
                    : loading;
              }
              return buildContent(context);
            },
          );

    final appBar = buildAppBar(context);
    return isCustomLayout
        ? body
        : GestureDetector(
            onTap: () {
              onTapParent();
              if (dismissKeyboardWhenClickOutside) {
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            // TODO: add drawers and floating
            child: Scaffold(
              backgroundColor: AppColors.gray05,
              appBar: appBar == null
                  ? null
                  : PreferredSize(
                      preferredSize: Size.fromHeight(appBarHeight),
                      child: appBar,
                    ),
              floatingActionButton: buildFloatingActionButton(context),
              body: SafeArea(
                child: body,
              ),
            ),
          );
  }

  Widget buildContent(BuildContext context) => Container();

  Widget buildLoading(BuildContext context) =>
      const SizedBox().appCenterProgressLoading;

  Widget? buildAppBar(BuildContext context) => null;

  Widget? buildFloatingActionButton(BuildContext context) => null;

  double get appBarHeight => kToolbarHeight;

  // override this function to listen event change
  void blocListener(dynamic state) {}

  void showInfoDialog(String content, Function() onConfirm) =>
      AppDialog.I.showNotification(message: content, onConfirm: onConfirm);

  void showWarningDialog(
    String content, {
    VoidCallback? onConfirmClicked,
    VoidCallback? onCancelClicked,
    bool isConfirmRight = true,
  }) =>
      AppDialog.I.showWarning(message: content);

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
