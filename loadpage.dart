import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'loadpage_model.dart';
export 'loadpage_model.dart';

class LoadpageWidget extends StatefulWidget {
  const LoadpageWidget({
    super.key,
    required this.isSignUp,
  });

  final bool? isSignUp;

  @override
  State<LoadpageWidget> createState() => _LoadpageWidgetState();
}

class _LoadpageWidgetState extends State<LoadpageWidget>
    with TickerProviderStateMixin {
  late LoadpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadpageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget!.isSignUp!) {
        FFAppState().lastDateOfUsingApp = getCurrentTimestamp;

        context.goNamed(
          'AddRooms',
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
            ),
          },
        );
      } else {
        if (functions.checkIfMonthCrossedBy(FFAppState().lastDateOfUsingApp!)) {
          _model.allRoomsDocs = await queryRoomsRecordOnce();
          while (_model.counter < _model.allRoomsDocs!.length) {
            await _model.allRoomsDocs![_model.counter].reference
                .update(createRoomsRecordData(
              rentStatus: RentState.Due,
              rentAmountPaid: 0,
              electercityBillPaid: 0,
              billStatus: BillStatus.Due,
            ));
            _model.counter = _model.counter + 1;
          }
        }
        FFAppState().lastDateOfUsingApp = getCurrentTimestamp;

        context.goNamed(
          'Dashboard',
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          },
        );
      }
    });

    animationsMap.addAll({
      'iconOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 100,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Icon(
                    Icons.rotate_right_sharp,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 80,
                  ).animateOnPageLoad(
                      animationsMap['iconOnPageLoadAnimation']!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
