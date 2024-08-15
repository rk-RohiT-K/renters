import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/leave_reasons/leave_reasons_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'tenant_details_model.dart';
export 'tenant_details_model.dart';

class TenantDetailsWidget extends StatefulWidget {
  const TenantDetailsWidget({
    super.key,
    required this.nameTenant,
    bool? paymentUpdate,
  }) : this.paymentUpdate = paymentUpdate ?? false;

  final String? nameTenant;
  final bool paymentUpdate;

  @override
  State<TenantDetailsWidget> createState() => _TenantDetailsWidgetState();
}

class _TenantDetailsWidgetState extends State<TenantDetailsWidget> {
  late TenantDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TenantDetailsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().tenantEditActive = false;
      setState(() {});
    });

    _model.editNameFieldFocusNode ??= FocusNode();

    _model.editRoomNoFieldFocusNode ??= FocusNode();
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
          child: FutureBuilder<List<TenantsRecord>>(
            future: queryTenantsRecordOnce(
              queryBuilder: (tenantsRecord) => tenantsRecord.where(
                'Name',
                isEqualTo: widget!.nameTenant,
              ),
              singleRecord: true,
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              List<TenantsRecord> columnTenantsRecordList = snapshot.data!;
              // Return an empty Container when the item does not exist.
              if (snapshot.data!.isEmpty) {
                return Container();
              }
              final columnTenantsRecord = columnTenantsRecordList.isNotEmpty
                  ? columnTenantsRecordList.first
                  : null;

              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 20,
                        borderWidth: 1,
                        buttonSize: 40,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 20,
                        ),
                        onPressed: () async {
                          FFAppState().tenantEditActive = false;
                          setState(() {});
                          context.safePop();
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Tenant Details',
                          style: FlutterFlowTheme.of(context)
                              .headlineLarge
                              .override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0,
                              ),
                        ),
                      ),
                      if (!FFAppState().tenantEditActive)
                        FlutterFlowIconButton(
                          borderRadius: 20,
                          borderWidth: 1,
                          buttonSize: 40,
                          icon: Icon(
                            Icons.edit_note,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24,
                          ),
                          onPressed: () async {
                            FFAppState().tenantEditActive = true;
                            setState(() {});
                          },
                        ),
                      if (!FFAppState().tenantEditActive)
                        Builder(
                          builder: (context) =>
                              StreamBuilder<List<RoomsRecord>>(
                            stream: queryRoomsRecord(
                              queryBuilder: (roomsRecord) => roomsRecord
                                  .where(
                                    'land_lord',
                                    isEqualTo: currentUserReference,
                                  )
                                  .where(
                                    'room_no',
                                    isEqualTo:
                                        columnTenantsRecord?.roomNo?.toString(),
                                  ),
                              singleRecord: true,
                            ),
                            builder: (context, snapshot) {
                              // Customize what your widget looks like when it's loading.
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              List<RoomsRecord> iconButtonRoomsRecordList =
                                  snapshot.data!;
                              // Return an empty Container when the item does not exist.
                              if (snapshot.data!.isEmpty) {
                                return Container();
                              }
                              final iconButtonRoomsRecord =
                                  iconButtonRoomsRecordList.isNotEmpty
                                      ? iconButtonRoomsRecordList.first
                                      : null;

                              return FlutterFlowIconButton(
                                borderRadius: 20,
                                borderWidth: 1,
                                buttonSize: 40,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  size: 24,
                                ),
                                onPressed: () async {
                                  var confirmDialogResponse =
                                      await showDialog<bool>(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Delete Tenant'),
                                                content: Text(
                                                    'Do you want to remove this Tenant?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            false),
                                                    child: Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            true),
                                                    child: Text('Yes'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;
                                  if (confirmDialogResponse) {
                                    await showDialog(
                                      context: context,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          elevation: 0,
                                          insetPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          alignment: AlignmentDirectional(0, 0)
                                              .resolve(
                                                  Directionality.of(context)),
                                          child: GestureDetector(
                                            onTap: () => _model
                                                    .unfocusNode.canRequestFocus
                                                ? FocusScope.of(context)
                                                    .requestFocus(
                                                        _model.unfocusNode)
                                                : FocusScope.of(context)
                                                    .unfocus(),
                                            child: LeaveReasonsWidget(),
                                          ),
                                        );
                                      },
                                    ).then((value) => setState(() {}));

                                    await PastTenantRecord.collection
                                        .doc()
                                        .set(createPastTenantRecordData(
                                          name: columnTenantsRecord?.name,
                                          roomOccupied: columnTenantsRecord
                                              ?.roomNo
                                              ?.toString(),
                                          startDate:
                                              columnTenantsRecord?.startDate,
                                          endDate: getCurrentTimestamp,
                                          leaveReasons:
                                              FFAppState().leaveReason,
                                          landLord: currentUserReference,
                                        ));
                                    FFAppState().leaveReason = 'NA';
                                    setState(() {});

                                    await iconButtonRoomsRecord!.reference
                                        .update({
                                      ...mapToFirestore(
                                        {
                                          'Tenants': FieldValue.arrayRemove(
                                              [columnTenantsRecord?.name]),
                                        },
                                      ),
                                    });
                                    await columnTenantsRecord!.reference
                                        .delete();

                                    context.pushNamed('MainPage');
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      if (FFAppState().tenantEditActive)
                        StreamBuilder<List<RoomsRecord>>(
                          stream: queryRoomsRecord(
                            queryBuilder: (roomsRecord) => roomsRecord.where(
                              'room_no',
                              isEqualTo:
                                  columnTenantsRecord?.roomNo?.toString(),
                            ),
                            singleRecord: true,
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<RoomsRecord> iconButtonRoomsRecordList =
                                snapshot.data!;
                            final iconButtonRoomsRecord =
                                iconButtonRoomsRecordList.isNotEmpty
                                    ? iconButtonRoomsRecordList.first
                                    : null;

                            return FlutterFlowIconButton(
                              borderRadius: 20,
                              borderWidth: 1,
                              buttonSize: 40,
                              icon: Icon(
                                Icons.check,
                                color: Color(0xFF3BB31D),
                                size: 24,
                              ),
                              onPressed: () async {
                                if ((_model.editNameFieldTextController
                                                .text !=
                                            null &&
                                        _model.editNameFieldTextController
                                                .text !=
                                            '') &&
                                    (_model.editRoomNoFieldTextController
                                                .text !=
                                            null &&
                                        _model.editRoomNoFieldTextController
                                                .text !=
                                            '') &&
                                    (_model.datePicked != null)) {
                                  if (columnTenantsRecord?.roomNo ==
                                      (int.parse(_model
                                          .editRoomNoFieldTextController
                                          .text))) {
                                    if (columnTenantsRecord?.name !=
                                        _model
                                            .editNameFieldTextController.text) {
                                      await iconButtonRoomsRecord!.reference
                                          .update({
                                        ...mapToFirestore(
                                          {
                                            'Tenants': FieldValue.arrayRemove(
                                                [columnTenantsRecord?.name]),
                                          },
                                        ),
                                      });

                                      await iconButtonRoomsRecord!.reference
                                          .update({
                                        ...mapToFirestore(
                                          {
                                            'Tenants': FieldValue.arrayUnion([
                                              _model.editNameFieldTextController
                                                  .text
                                            ]),
                                          },
                                        ),
                                      });
                                    }
                                  } else {
                                    _model.diffRoom =
                                        await queryRoomsRecordOnce(
                                      queryBuilder: (roomsRecord) =>
                                          roomsRecord.where(
                                        'room_no',
                                        isEqualTo: (int.parse(_model
                                                .editRoomNoFieldTextController
                                                .text))
                                            .toString(),
                                      ),
                                      singleRecord: true,
                                    ).then((s) => s.firstOrNull);
                                    _model.sameRoom =
                                        await queryRoomsRecordOnce(
                                      queryBuilder: (roomsRecord) =>
                                          roomsRecord.where(
                                        'room_no',
                                        isEqualTo: columnTenantsRecord?.roomNo
                                            ?.toString(),
                                      ),
                                      singleRecord: true,
                                    ).then((s) => s.firstOrNull);

                                    await _model.diffRoom!.reference.update({
                                      ...mapToFirestore(
                                        {
                                          'Tenants': FieldValue.arrayUnion(
                                              [columnTenantsRecord?.name]),
                                        },
                                      ),
                                    });

                                    await _model.sameRoom!.reference.update({
                                      ...mapToFirestore(
                                        {
                                          'Tenants': FieldValue.arrayRemove(
                                              [columnTenantsRecord?.name]),
                                        },
                                      ),
                                    });
                                  }

                                  await columnTenantsRecord!.reference
                                      .update(createTenantsRecordData(
                                    name:
                                        _model.editNameFieldTextController.text,
                                    roomNo: int.tryParse(_model
                                        .editRoomNoFieldTextController.text),
                                    startDate: _model.datePicked,
                                  ));
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000));
                                  FFAppState().tenantEditActive = false;
                                  setState(() {});
                                } else {
                                  var confirmDialogResponse =
                                      await showDialog<bool>(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text('Field(s) Empty'),
                                                content: Text(
                                                    'Some of the fields are not Set. Do you wish to continue? No Changes will be made.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            false),
                                                    child: Text('NO'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            true),
                                                    child: Text('YES'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;
                                  if (confirmDialogResponse) {
                                    await Future.delayed(
                                        const Duration(milliseconds: 500));
                                    FFAppState().tenantEditActive = false;
                                    setState(() {});
                                  }
                                }

                                setState(() {});
                              },
                            );
                          },
                        ),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentDirectional(0, 0),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              columnTenantsRecord!.image,
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              height: MediaQuery.sizeOf(context).width * 0.5,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/error_image.png',
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                height: MediaQuery.sizeOf(context).width * 0.5,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (FFAppState().tenantEditActive)
                        Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: FlutterFlowIconButton(
                              borderRadius: 100,
                              buttonSize: 200,
                              fillColor: Color(0x945A5C60),
                              icon: Icon(
                                Icons.flip_camera_ios,
                                color: Color(0xBAFFFFFF),
                                size: 40,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (!FFAppState().tenantEditActive)
                                Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        widget!.nameTenant,
                                        'tenantZero',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0,
                                          ),
                                    ),
                                  ),
                                ),
                              if (FFAppState().tenantEditActive)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 8, 0),
                                    child: TextFormField(
                                      controller:
                                          _model.editNameFieldTextController ??=
                                              TextEditingController(
                                        text: columnTenantsRecord?.name,
                                      ),
                                      focusNode: _model.editNameFieldFocusNode,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
                                            ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0,
                                          ),
                                      validator: _model
                                          .editNameFieldTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          'Room No. ',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Inter',
                                                color: Color(0xFF3A72A4),
                                                letterSpacing: 0,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!FFAppState().tenantEditActive)
                                  Text(
                                    valueOrDefault<String>(
                                      columnTenantsRecord?.roomNo?.toString(),
                                      '000',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0,
                                        ),
                                  ),
                                if (FFAppState().tenantEditActive)
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 0, 8, 0),
                                      child: TextFormField(
                                        controller: _model
                                                .editRoomNoFieldTextController ??=
                                            TextEditingController(
                                          text: columnTenantsRecord?.roomNo
                                              ?.toString(),
                                        ),
                                        focusNode:
                                            _model.editRoomNoFieldFocusNode,
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0,
                                                  ),
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Inter',
                                                    letterSpacing: 0,
                                                  ),
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          focusedErrorBorder: InputBorder.none,
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter',
                                              letterSpacing: 0,
                                            ),
                                        validator: _model
                                            .editRoomNoFieldTextControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Text(
                                    'Start Date',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF3A72A4),
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ),
                                Text(
                                  _model.datePicked != null
                                      ? dateTimeFormat(
                                          'd/M/y', _model.datePicked)
                                      : dateTimeFormat('d/M/y',
                                          columnTenantsRecord!.startDate!),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Inter',
                                        letterSpacing: 0,
                                      ),
                                ),
                                if (FFAppState().tenantEditActive)
                                  FlutterFlowIconButton(
                                    borderRadius: 20,
                                    borderWidth: 1,
                                    buttonSize: 40,
                                    icon: Icon(
                                      Icons.calendar_month,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24,
                                    ),
                                    onPressed: () async {
                                      final _datePickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: getCurrentTimestamp,
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2050),
                                        builder: (context, child) {
                                          return wrapInMaterialDatePickerTheme(
                                            context,
                                            child!,
                                            headerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            headerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .override(
                                                      fontFamily: 'Readex Pro',
                                                      fontSize: 32,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                            pickerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            pickerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            selectedDateTimeBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            selectedDateTimeForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            iconSize: 24,
                                          );
                                        },
                                      );

                                      if (_datePickedDate != null) {
                                        safeSetState(() {
                                          _model.datePicked = DateTime(
                                            _datePickedDate.year,
                                            _datePickedDate.month,
                                            _datePickedDate.day,
                                          );
                                        });
                                      }
                                    },
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 100, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Text(
                                    'Rent',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Inter',
                                          color: Color(0xFF3A72A4),
                                          letterSpacing: 0,
                                        ),
                                  ),
                                ),
                                StreamBuilder<List<RoomsRecord>>(
                                  stream: queryRoomsRecord(
                                    queryBuilder: (roomsRecord) =>
                                        roomsRecord.where(
                                      'room_no',
                                      isEqualTo: columnTenantsRecord?.roomNo
                                          ?.toString(),
                                    ),
                                    singleRecord: true,
                                  ),
                                  builder: (context, snapshot) {
                                    // Customize what your widget looks like when it's loading.
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    List<RoomsRecord> textRoomsRecordList =
                                        snapshot.data!;
                                    // Return an empty Container when the item does not exist.
                                    if (snapshot.data!.isEmpty) {
                                      return Container();
                                    }
                                    final textRoomsRecord =
                                        textRoomsRecordList.isNotEmpty
                                            ? textRoomsRecordList.first
                                            : null;

                                    return Text(
                                      valueOrDefault<String>(
                                        textRoomsRecord?.defaultRent
                                            ?.toString(),
                                        '000',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0,
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [],
                          ),
                        ]
                            .divide(SizedBox(height: 10))
                            .around(SizedBox(height: 10)),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
