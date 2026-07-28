// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StudentsTable extends Students with TableInfo<$StudentsTable, Student> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _firstNameArMeta = const VerificationMeta(
    'firstNameAr',
  );
  @override
  late final GeneratedColumn<String> firstNameAr = GeneratedColumn<String>(
    'first_name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameArMeta = const VerificationMeta(
    'lastNameAr',
  );
  @override
  late final GeneratedColumn<String> lastNameAr = GeneratedColumn<String>(
    'last_name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameFrMeta = const VerificationMeta(
    'firstNameFr',
  );
  @override
  late final GeneratedColumn<String> firstNameFr = GeneratedColumn<String>(
    'first_name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameFrMeta = const VerificationMeta(
    'lastNameFr',
  );
  @override
  late final GeneratedColumn<String> lastNameFr = GeneratedColumn<String>(
    'last_name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthPlaceMeta = const VerificationMeta(
    'birthPlace',
  );
  @override
  late final GeneratedColumn<String> birthPlace = GeneratedColumn<String>(
    'birth_place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registrationDateMeta = const VerificationMeta(
    'registrationDate',
  );
  @override
  late final GeneratedColumn<DateTime> registrationDate =
      GeneratedColumn<DateTime>(
        'registration_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _schoolLevelMeta = const VerificationMeta(
    'schoolLevel',
  );
  @override
  late final GeneratedColumn<String> schoolLevel = GeneratedColumn<String>(
    'school_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    firstNameAr,
    lastNameAr,
    firstNameFr,
    lastNameFr,
    phone,
    address,
    gender,
    birthDate,
    birthPlace,
    registrationDate,
    status,
    createdAt,
    updatedAt,
    deviceId,
    schoolLevel,
    isArchived,
    photoPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'students';
  @override
  VerificationContext validateIntegrity(
    Insertable<Student> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('first_name_ar')) {
      context.handle(
        _firstNameArMeta,
        firstNameAr.isAcceptableOrUnknown(
          data['first_name_ar']!,
          _firstNameArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstNameArMeta);
    }
    if (data.containsKey('last_name_ar')) {
      context.handle(
        _lastNameArMeta,
        lastNameAr.isAcceptableOrUnknown(
          data['last_name_ar']!,
          _lastNameArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastNameArMeta);
    }
    if (data.containsKey('first_name_fr')) {
      context.handle(
        _firstNameFrMeta,
        firstNameFr.isAcceptableOrUnknown(
          data['first_name_fr']!,
          _firstNameFrMeta,
        ),
      );
    }
    if (data.containsKey('last_name_fr')) {
      context.handle(
        _lastNameFrMeta,
        lastNameFr.isAcceptableOrUnknown(
          data['last_name_fr']!,
          _lastNameFrMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('birth_place')) {
      context.handle(
        _birthPlaceMeta,
        birthPlace.isAcceptableOrUnknown(data['birth_place']!, _birthPlaceMeta),
      );
    }
    if (data.containsKey('registration_date')) {
      context.handle(
        _registrationDateMeta,
        registrationDate.isAcceptableOrUnknown(
          data['registration_date']!,
          _registrationDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('school_level')) {
      context.handle(
        _schoolLevelMeta,
        schoolLevel.isAcceptableOrUnknown(
          data['school_level']!,
          _schoolLevelMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Student map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Student(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      firstNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name_ar'],
      )!,
      lastNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name_ar'],
      )!,
      firstNameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name_fr'],
      ),
      lastNameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name_fr'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      birthPlace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_place'],
      ),
      registrationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      schoolLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_level'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
    );
  }

  @override
  $StudentsTable createAlias(String alias) {
    return $StudentsTable(attachedDatabase, alias);
  }
}

class Student extends DataClass implements Insertable<Student> {
  final String id;
  final String code;
  final String firstNameAr;
  final String lastNameAr;
  final String? firstNameFr;
  final String? lastNameFr;
  final String? phone;
  final String? address;
  final String? gender;
  final DateTime? birthDate;
  final String? birthPlace;
  final DateTime registrationDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deviceId;
  final String? schoolLevel;
  final bool isArchived;
  final String? photoPath;
  const Student({
    required this.id,
    required this.code,
    required this.firstNameAr,
    required this.lastNameAr,
    this.firstNameFr,
    this.lastNameFr,
    this.phone,
    this.address,
    this.gender,
    this.birthDate,
    this.birthPlace,
    required this.registrationDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
    this.schoolLevel,
    required this.isArchived,
    this.photoPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['first_name_ar'] = Variable<String>(firstNameAr);
    map['last_name_ar'] = Variable<String>(lastNameAr);
    if (!nullToAbsent || firstNameFr != null) {
      map['first_name_fr'] = Variable<String>(firstNameFr);
    }
    if (!nullToAbsent || lastNameFr != null) {
      map['last_name_fr'] = Variable<String>(lastNameFr);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || birthPlace != null) {
      map['birth_place'] = Variable<String>(birthPlace);
    }
    map['registration_date'] = Variable<DateTime>(registrationDate);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || schoolLevel != null) {
      map['school_level'] = Variable<String>(schoolLevel);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    return map;
  }

  StudentsCompanion toCompanion(bool nullToAbsent) {
    return StudentsCompanion(
      id: Value(id),
      code: Value(code),
      firstNameAr: Value(firstNameAr),
      lastNameAr: Value(lastNameAr),
      firstNameFr: firstNameFr == null && nullToAbsent
          ? const Value.absent()
          : Value(firstNameFr),
      lastNameFr: lastNameFr == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNameFr),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      birthPlace: birthPlace == null && nullToAbsent
          ? const Value.absent()
          : Value(birthPlace),
      registrationDate: Value(registrationDate),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      schoolLevel: schoolLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolLevel),
      isArchived: Value(isArchived),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
    );
  }

  factory Student.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Student(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      firstNameAr: serializer.fromJson<String>(json['firstNameAr']),
      lastNameAr: serializer.fromJson<String>(json['lastNameAr']),
      firstNameFr: serializer.fromJson<String?>(json['firstNameFr']),
      lastNameFr: serializer.fromJson<String?>(json['lastNameFr']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      gender: serializer.fromJson<String?>(json['gender']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      birthPlace: serializer.fromJson<String?>(json['birthPlace']),
      registrationDate: serializer.fromJson<DateTime>(json['registrationDate']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      schoolLevel: serializer.fromJson<String?>(json['schoolLevel']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'firstNameAr': serializer.toJson<String>(firstNameAr),
      'lastNameAr': serializer.toJson<String>(lastNameAr),
      'firstNameFr': serializer.toJson<String?>(firstNameFr),
      'lastNameFr': serializer.toJson<String?>(lastNameFr),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'gender': serializer.toJson<String?>(gender),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'birthPlace': serializer.toJson<String?>(birthPlace),
      'registrationDate': serializer.toJson<DateTime>(registrationDate),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'schoolLevel': serializer.toJson<String?>(schoolLevel),
      'isArchived': serializer.toJson<bool>(isArchived),
      'photoPath': serializer.toJson<String?>(photoPath),
    };
  }

  Student copyWith({
    String? id,
    String? code,
    String? firstNameAr,
    String? lastNameAr,
    Value<String?> firstNameFr = const Value.absent(),
    Value<String?> lastNameFr = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<DateTime?> birthDate = const Value.absent(),
    Value<String?> birthPlace = const Value.absent(),
    DateTime? registrationDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
    Value<String?> schoolLevel = const Value.absent(),
    bool? isArchived,
    Value<String?> photoPath = const Value.absent(),
  }) => Student(
    id: id ?? this.id,
    code: code ?? this.code,
    firstNameAr: firstNameAr ?? this.firstNameAr,
    lastNameAr: lastNameAr ?? this.lastNameAr,
    firstNameFr: firstNameFr.present ? firstNameFr.value : this.firstNameFr,
    lastNameFr: lastNameFr.present ? lastNameFr.value : this.lastNameFr,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    gender: gender.present ? gender.value : this.gender,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    birthPlace: birthPlace.present ? birthPlace.value : this.birthPlace,
    registrationDate: registrationDate ?? this.registrationDate,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    schoolLevel: schoolLevel.present ? schoolLevel.value : this.schoolLevel,
    isArchived: isArchived ?? this.isArchived,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
  );
  Student copyWithCompanion(StudentsCompanion data) {
    return Student(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      firstNameAr: data.firstNameAr.present
          ? data.firstNameAr.value
          : this.firstNameAr,
      lastNameAr: data.lastNameAr.present
          ? data.lastNameAr.value
          : this.lastNameAr,
      firstNameFr: data.firstNameFr.present
          ? data.firstNameFr.value
          : this.firstNameFr,
      lastNameFr: data.lastNameFr.present
          ? data.lastNameFr.value
          : this.lastNameFr,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      gender: data.gender.present ? data.gender.value : this.gender,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      birthPlace: data.birthPlace.present
          ? data.birthPlace.value
          : this.birthPlace,
      registrationDate: data.registrationDate.present
          ? data.registrationDate.value
          : this.registrationDate,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      schoolLevel: data.schoolLevel.present
          ? data.schoolLevel.value
          : this.schoolLevel,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Student(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('firstNameAr: $firstNameAr, ')
          ..write('lastNameAr: $lastNameAr, ')
          ..write('firstNameFr: $firstNameFr, ')
          ..write('lastNameFr: $lastNameFr, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('schoolLevel: $schoolLevel, ')
          ..write('isArchived: $isArchived, ')
          ..write('photoPath: $photoPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    firstNameAr,
    lastNameAr,
    firstNameFr,
    lastNameFr,
    phone,
    address,
    gender,
    birthDate,
    birthPlace,
    registrationDate,
    status,
    createdAt,
    updatedAt,
    deviceId,
    schoolLevel,
    isArchived,
    photoPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Student &&
          other.id == this.id &&
          other.code == this.code &&
          other.firstNameAr == this.firstNameAr &&
          other.lastNameAr == this.lastNameAr &&
          other.firstNameFr == this.firstNameFr &&
          other.lastNameFr == this.lastNameFr &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.gender == this.gender &&
          other.birthDate == this.birthDate &&
          other.birthPlace == this.birthPlace &&
          other.registrationDate == this.registrationDate &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.schoolLevel == this.schoolLevel &&
          other.isArchived == this.isArchived &&
          other.photoPath == this.photoPath);
}

class StudentsCompanion extends UpdateCompanion<Student> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> firstNameAr;
  final Value<String> lastNameAr;
  final Value<String?> firstNameFr;
  final Value<String?> lastNameFr;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> gender;
  final Value<DateTime?> birthDate;
  final Value<String?> birthPlace;
  final Value<DateTime> registrationDate;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deviceId;
  final Value<String?> schoolLevel;
  final Value<bool> isArchived;
  final Value<String?> photoPath;
  final Value<int> rowid;
  const StudentsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.firstNameAr = const Value.absent(),
    this.lastNameAr = const Value.absent(),
    this.firstNameFr = const Value.absent(),
    this.lastNameFr = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.schoolLevel = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentsCompanion.insert({
    required String id,
    required String code,
    required String firstNameAr,
    required String lastNameAr,
    this.firstNameFr = const Value.absent(),
    this.lastNameFr = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gender = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.birthPlace = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String deviceId,
    this.schoolLevel = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       firstNameAr = Value(firstNameAr),
       lastNameAr = Value(lastNameAr),
       deviceId = Value(deviceId);
  static Insertable<Student> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? firstNameAr,
    Expression<String>? lastNameAr,
    Expression<String>? firstNameFr,
    Expression<String>? lastNameFr,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? gender,
    Expression<DateTime>? birthDate,
    Expression<String>? birthPlace,
    Expression<DateTime>? registrationDate,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? deviceId,
    Expression<String>? schoolLevel,
    Expression<bool>? isArchived,
    Expression<String>? photoPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (firstNameAr != null) 'first_name_ar': firstNameAr,
      if (lastNameAr != null) 'last_name_ar': lastNameAr,
      if (firstNameFr != null) 'first_name_fr': firstNameFr,
      if (lastNameFr != null) 'last_name_fr': lastNameFr,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (gender != null) 'gender': gender,
      if (birthDate != null) 'birth_date': birthDate,
      if (birthPlace != null) 'birth_place': birthPlace,
      if (registrationDate != null) 'registration_date': registrationDate,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (schoolLevel != null) 'school_level': schoolLevel,
      if (isArchived != null) 'is_archived': isArchived,
      if (photoPath != null) 'photo_path': photoPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? firstNameAr,
    Value<String>? lastNameAr,
    Value<String?>? firstNameFr,
    Value<String?>? lastNameFr,
    Value<String?>? phone,
    Value<String?>? address,
    Value<String?>? gender,
    Value<DateTime?>? birthDate,
    Value<String?>? birthPlace,
    Value<DateTime>? registrationDate,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? deviceId,
    Value<String?>? schoolLevel,
    Value<bool>? isArchived,
    Value<String?>? photoPath,
    Value<int>? rowid,
  }) {
    return StudentsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      firstNameAr: firstNameAr ?? this.firstNameAr,
      lastNameAr: lastNameAr ?? this.lastNameAr,
      firstNameFr: firstNameFr ?? this.firstNameFr,
      lastNameFr: lastNameFr ?? this.lastNameFr,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      birthPlace: birthPlace ?? this.birthPlace,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      schoolLevel: schoolLevel ?? this.schoolLevel,
      isArchived: isArchived ?? this.isArchived,
      photoPath: photoPath ?? this.photoPath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (firstNameAr.present) {
      map['first_name_ar'] = Variable<String>(firstNameAr.value);
    }
    if (lastNameAr.present) {
      map['last_name_ar'] = Variable<String>(lastNameAr.value);
    }
    if (firstNameFr.present) {
      map['first_name_fr'] = Variable<String>(firstNameFr.value);
    }
    if (lastNameFr.present) {
      map['last_name_fr'] = Variable<String>(lastNameFr.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (birthPlace.present) {
      map['birth_place'] = Variable<String>(birthPlace.value);
    }
    if (registrationDate.present) {
      map['registration_date'] = Variable<DateTime>(registrationDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (schoolLevel.present) {
      map['school_level'] = Variable<String>(schoolLevel.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('firstNameAr: $firstNameAr, ')
          ..write('lastNameAr: $lastNameAr, ')
          ..write('firstNameFr: $firstNameFr, ')
          ..write('lastNameFr: $lastNameFr, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gender: $gender, ')
          ..write('birthDate: $birthDate, ')
          ..write('birthPlace: $birthPlace, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('schoolLevel: $schoolLevel, ')
          ..write('isArchived: $isArchived, ')
          ..write('photoPath: $photoPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeachersTable extends Teachers with TableInfo<$TeachersTable, Teacher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeachersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _firstNameArMeta = const VerificationMeta(
    'firstNameAr',
  );
  @override
  late final GeneratedColumn<String> firstNameAr = GeneratedColumn<String>(
    'first_name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameArMeta = const VerificationMeta(
    'lastNameAr',
  );
  @override
  late final GeneratedColumn<String> lastNameAr = GeneratedColumn<String>(
    'last_name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameFrMeta = const VerificationMeta(
    'firstNameFr',
  );
  @override
  late final GeneratedColumn<String> firstNameFr = GeneratedColumn<String>(
    'first_name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameFrMeta = const VerificationMeta(
    'lastNameFr',
  );
  @override
  late final GeneratedColumn<String> lastNameFr = GeneratedColumn<String>(
    'last_name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _idCardMeta = const VerificationMeta('idCard');
  @override
  late final GeneratedColumn<String> idCard = GeneratedColumn<String>(
    'id_card',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employmentStartDateMeta =
      const VerificationMeta('employmentStartDate');
  @override
  late final GeneratedColumn<DateTime> employmentStartDate =
      GeneratedColumn<DateTime>(
        'employment_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _employmentEndDateMeta = const VerificationMeta(
    'employmentEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> employmentEndDate =
      GeneratedColumn<DateTime>(
        'employment_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _salaryTypeMeta = const VerificationMeta(
    'salaryType',
  );
  @override
  late final GeneratedColumn<String> salaryType = GeneratedColumn<String>(
    'salary_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('percentage'),
  );
  static const VerificationMeta _teacherSharePctMeta = const VerificationMeta(
    'teacherSharePct',
  );
  @override
  late final GeneratedColumn<double> teacherSharePct = GeneratedColumn<double>(
    'teacher_share_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teacherFixedAmountMeta =
      const VerificationMeta('teacherFixedAmount');
  @override
  late final GeneratedColumn<double> teacherFixedAmount =
      GeneratedColumn<double>(
        'teacher_fixed_amount',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overdueThresholdDaysMeta =
      const VerificationMeta('overdueThresholdDays');
  @override
  late final GeneratedColumn<int> overdueThresholdDays = GeneratedColumn<int>(
    'overdue_threshold_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    firstNameAr,
    lastNameAr,
    firstNameFr,
    lastNameFr,
    phone,
    address,
    email,
    idCard,
    employmentStartDate,
    employmentEndDate,
    salaryType,
    teacherSharePct,
    teacherFixedAmount,
    isArchived,
    photoPath,
    gender,
    overdueThresholdDays,
    createdAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teachers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Teacher> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('first_name_ar')) {
      context.handle(
        _firstNameArMeta,
        firstNameAr.isAcceptableOrUnknown(
          data['first_name_ar']!,
          _firstNameArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstNameArMeta);
    }
    if (data.containsKey('last_name_ar')) {
      context.handle(
        _lastNameArMeta,
        lastNameAr.isAcceptableOrUnknown(
          data['last_name_ar']!,
          _lastNameArMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastNameArMeta);
    }
    if (data.containsKey('first_name_fr')) {
      context.handle(
        _firstNameFrMeta,
        firstNameFr.isAcceptableOrUnknown(
          data['first_name_fr']!,
          _firstNameFrMeta,
        ),
      );
    }
    if (data.containsKey('last_name_fr')) {
      context.handle(
        _lastNameFrMeta,
        lastNameFr.isAcceptableOrUnknown(
          data['last_name_fr']!,
          _lastNameFrMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('id_card')) {
      context.handle(
        _idCardMeta,
        idCard.isAcceptableOrUnknown(data['id_card']!, _idCardMeta),
      );
    }
    if (data.containsKey('employment_start_date')) {
      context.handle(
        _employmentStartDateMeta,
        employmentStartDate.isAcceptableOrUnknown(
          data['employment_start_date']!,
          _employmentStartDateMeta,
        ),
      );
    }
    if (data.containsKey('employment_end_date')) {
      context.handle(
        _employmentEndDateMeta,
        employmentEndDate.isAcceptableOrUnknown(
          data['employment_end_date']!,
          _employmentEndDateMeta,
        ),
      );
    }
    if (data.containsKey('salary_type')) {
      context.handle(
        _salaryTypeMeta,
        salaryType.isAcceptableOrUnknown(data['salary_type']!, _salaryTypeMeta),
      );
    }
    if (data.containsKey('teacher_share_pct')) {
      context.handle(
        _teacherSharePctMeta,
        teacherSharePct.isAcceptableOrUnknown(
          data['teacher_share_pct']!,
          _teacherSharePctMeta,
        ),
      );
    }
    if (data.containsKey('teacher_fixed_amount')) {
      context.handle(
        _teacherFixedAmountMeta,
        teacherFixedAmount.isAcceptableOrUnknown(
          data['teacher_fixed_amount']!,
          _teacherFixedAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('overdue_threshold_days')) {
      context.handle(
        _overdueThresholdDaysMeta,
        overdueThresholdDays.isAcceptableOrUnknown(
          data['overdue_threshold_days']!,
          _overdueThresholdDaysMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Teacher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Teacher(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      firstNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name_ar'],
      )!,
      lastNameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name_ar'],
      )!,
      firstNameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name_fr'],
      ),
      lastNameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name_fr'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      idCard: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_card'],
      ),
      employmentStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}employment_start_date'],
      ),
      employmentEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}employment_end_date'],
      ),
      salaryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salary_type'],
      )!,
      teacherSharePct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}teacher_share_pct'],
      ),
      teacherFixedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}teacher_fixed_amount'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      overdueThresholdDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overdue_threshold_days'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $TeachersTable createAlias(String alias) {
    return $TeachersTable(attachedDatabase, alias);
  }
}

class Teacher extends DataClass implements Insertable<Teacher> {
  final String id;
  final String code;
  final String firstNameAr;
  final String lastNameAr;
  final String? firstNameFr;
  final String? lastNameFr;
  final String? phone;
  final String? address;
  final String? email;
  final String? idCard;
  final DateTime? employmentStartDate;
  final DateTime? employmentEndDate;
  final String salaryType;
  final double? teacherSharePct;
  final double? teacherFixedAmount;
  final bool isArchived;
  final String? photoPath;
  final String? gender;
  final int? overdueThresholdDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deviceId;
  const Teacher({
    required this.id,
    required this.code,
    required this.firstNameAr,
    required this.lastNameAr,
    this.firstNameFr,
    this.lastNameFr,
    this.phone,
    this.address,
    this.email,
    this.idCard,
    this.employmentStartDate,
    this.employmentEndDate,
    required this.salaryType,
    this.teacherSharePct,
    this.teacherFixedAmount,
    required this.isArchived,
    this.photoPath,
    this.gender,
    this.overdueThresholdDays,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['first_name_ar'] = Variable<String>(firstNameAr);
    map['last_name_ar'] = Variable<String>(lastNameAr);
    if (!nullToAbsent || firstNameFr != null) {
      map['first_name_fr'] = Variable<String>(firstNameFr);
    }
    if (!nullToAbsent || lastNameFr != null) {
      map['last_name_fr'] = Variable<String>(lastNameFr);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || idCard != null) {
      map['id_card'] = Variable<String>(idCard);
    }
    if (!nullToAbsent || employmentStartDate != null) {
      map['employment_start_date'] = Variable<DateTime>(employmentStartDate);
    }
    if (!nullToAbsent || employmentEndDate != null) {
      map['employment_end_date'] = Variable<DateTime>(employmentEndDate);
    }
    map['salary_type'] = Variable<String>(salaryType);
    if (!nullToAbsent || teacherSharePct != null) {
      map['teacher_share_pct'] = Variable<double>(teacherSharePct);
    }
    if (!nullToAbsent || teacherFixedAmount != null) {
      map['teacher_fixed_amount'] = Variable<double>(teacherFixedAmount);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || overdueThresholdDays != null) {
      map['overdue_threshold_days'] = Variable<int>(overdueThresholdDays);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  TeachersCompanion toCompanion(bool nullToAbsent) {
    return TeachersCompanion(
      id: Value(id),
      code: Value(code),
      firstNameAr: Value(firstNameAr),
      lastNameAr: Value(lastNameAr),
      firstNameFr: firstNameFr == null && nullToAbsent
          ? const Value.absent()
          : Value(firstNameFr),
      lastNameFr: lastNameFr == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNameFr),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      idCard: idCard == null && nullToAbsent
          ? const Value.absent()
          : Value(idCard),
      employmentStartDate: employmentStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(employmentStartDate),
      employmentEndDate: employmentEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(employmentEndDate),
      salaryType: Value(salaryType),
      teacherSharePct: teacherSharePct == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherSharePct),
      teacherFixedAmount: teacherFixedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherFixedAmount),
      isArchived: Value(isArchived),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      overdueThresholdDays: overdueThresholdDays == null && nullToAbsent
          ? const Value.absent()
          : Value(overdueThresholdDays),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Teacher.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Teacher(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      firstNameAr: serializer.fromJson<String>(json['firstNameAr']),
      lastNameAr: serializer.fromJson<String>(json['lastNameAr']),
      firstNameFr: serializer.fromJson<String?>(json['firstNameFr']),
      lastNameFr: serializer.fromJson<String?>(json['lastNameFr']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      email: serializer.fromJson<String?>(json['email']),
      idCard: serializer.fromJson<String?>(json['idCard']),
      employmentStartDate: serializer.fromJson<DateTime?>(
        json['employmentStartDate'],
      ),
      employmentEndDate: serializer.fromJson<DateTime?>(
        json['employmentEndDate'],
      ),
      salaryType: serializer.fromJson<String>(json['salaryType']),
      teacherSharePct: serializer.fromJson<double?>(json['teacherSharePct']),
      teacherFixedAmount: serializer.fromJson<double?>(
        json['teacherFixedAmount'],
      ),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      gender: serializer.fromJson<String?>(json['gender']),
      overdueThresholdDays: serializer.fromJson<int?>(
        json['overdueThresholdDays'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'firstNameAr': serializer.toJson<String>(firstNameAr),
      'lastNameAr': serializer.toJson<String>(lastNameAr),
      'firstNameFr': serializer.toJson<String?>(firstNameFr),
      'lastNameFr': serializer.toJson<String?>(lastNameFr),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'email': serializer.toJson<String?>(email),
      'idCard': serializer.toJson<String?>(idCard),
      'employmentStartDate': serializer.toJson<DateTime?>(employmentStartDate),
      'employmentEndDate': serializer.toJson<DateTime?>(employmentEndDate),
      'salaryType': serializer.toJson<String>(salaryType),
      'teacherSharePct': serializer.toJson<double?>(teacherSharePct),
      'teacherFixedAmount': serializer.toJson<double?>(teacherFixedAmount),
      'isArchived': serializer.toJson<bool>(isArchived),
      'photoPath': serializer.toJson<String?>(photoPath),
      'gender': serializer.toJson<String?>(gender),
      'overdueThresholdDays': serializer.toJson<int?>(overdueThresholdDays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Teacher copyWith({
    String? id,
    String? code,
    String? firstNameAr,
    String? lastNameAr,
    Value<String?> firstNameFr = const Value.absent(),
    Value<String?> lastNameFr = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> idCard = const Value.absent(),
    Value<DateTime?> employmentStartDate = const Value.absent(),
    Value<DateTime?> employmentEndDate = const Value.absent(),
    String? salaryType,
    Value<double?> teacherSharePct = const Value.absent(),
    Value<double?> teacherFixedAmount = const Value.absent(),
    bool? isArchived,
    Value<String?> photoPath = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<int?> overdueThresholdDays = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
  }) => Teacher(
    id: id ?? this.id,
    code: code ?? this.code,
    firstNameAr: firstNameAr ?? this.firstNameAr,
    lastNameAr: lastNameAr ?? this.lastNameAr,
    firstNameFr: firstNameFr.present ? firstNameFr.value : this.firstNameFr,
    lastNameFr: lastNameFr.present ? lastNameFr.value : this.lastNameFr,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    email: email.present ? email.value : this.email,
    idCard: idCard.present ? idCard.value : this.idCard,
    employmentStartDate: employmentStartDate.present
        ? employmentStartDate.value
        : this.employmentStartDate,
    employmentEndDate: employmentEndDate.present
        ? employmentEndDate.value
        : this.employmentEndDate,
    salaryType: salaryType ?? this.salaryType,
    teacherSharePct: teacherSharePct.present
        ? teacherSharePct.value
        : this.teacherSharePct,
    teacherFixedAmount: teacherFixedAmount.present
        ? teacherFixedAmount.value
        : this.teacherFixedAmount,
    isArchived: isArchived ?? this.isArchived,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    gender: gender.present ? gender.value : this.gender,
    overdueThresholdDays: overdueThresholdDays.present
        ? overdueThresholdDays.value
        : this.overdueThresholdDays,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Teacher copyWithCompanion(TeachersCompanion data) {
    return Teacher(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      firstNameAr: data.firstNameAr.present
          ? data.firstNameAr.value
          : this.firstNameAr,
      lastNameAr: data.lastNameAr.present
          ? data.lastNameAr.value
          : this.lastNameAr,
      firstNameFr: data.firstNameFr.present
          ? data.firstNameFr.value
          : this.firstNameFr,
      lastNameFr: data.lastNameFr.present
          ? data.lastNameFr.value
          : this.lastNameFr,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      email: data.email.present ? data.email.value : this.email,
      idCard: data.idCard.present ? data.idCard.value : this.idCard,
      employmentStartDate: data.employmentStartDate.present
          ? data.employmentStartDate.value
          : this.employmentStartDate,
      employmentEndDate: data.employmentEndDate.present
          ? data.employmentEndDate.value
          : this.employmentEndDate,
      salaryType: data.salaryType.present
          ? data.salaryType.value
          : this.salaryType,
      teacherSharePct: data.teacherSharePct.present
          ? data.teacherSharePct.value
          : this.teacherSharePct,
      teacherFixedAmount: data.teacherFixedAmount.present
          ? data.teacherFixedAmount.value
          : this.teacherFixedAmount,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      gender: data.gender.present ? data.gender.value : this.gender,
      overdueThresholdDays: data.overdueThresholdDays.present
          ? data.overdueThresholdDays.value
          : this.overdueThresholdDays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Teacher(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('firstNameAr: $firstNameAr, ')
          ..write('lastNameAr: $lastNameAr, ')
          ..write('firstNameFr: $firstNameFr, ')
          ..write('lastNameFr: $lastNameFr, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('email: $email, ')
          ..write('idCard: $idCard, ')
          ..write('employmentStartDate: $employmentStartDate, ')
          ..write('employmentEndDate: $employmentEndDate, ')
          ..write('salaryType: $salaryType, ')
          ..write('teacherSharePct: $teacherSharePct, ')
          ..write('teacherFixedAmount: $teacherFixedAmount, ')
          ..write('isArchived: $isArchived, ')
          ..write('photoPath: $photoPath, ')
          ..write('gender: $gender, ')
          ..write('overdueThresholdDays: $overdueThresholdDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    code,
    firstNameAr,
    lastNameAr,
    firstNameFr,
    lastNameFr,
    phone,
    address,
    email,
    idCard,
    employmentStartDate,
    employmentEndDate,
    salaryType,
    teacherSharePct,
    teacherFixedAmount,
    isArchived,
    photoPath,
    gender,
    overdueThresholdDays,
    createdAt,
    updatedAt,
    deviceId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Teacher &&
          other.id == this.id &&
          other.code == this.code &&
          other.firstNameAr == this.firstNameAr &&
          other.lastNameAr == this.lastNameAr &&
          other.firstNameFr == this.firstNameFr &&
          other.lastNameFr == this.lastNameFr &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.email == this.email &&
          other.idCard == this.idCard &&
          other.employmentStartDate == this.employmentStartDate &&
          other.employmentEndDate == this.employmentEndDate &&
          other.salaryType == this.salaryType &&
          other.teacherSharePct == this.teacherSharePct &&
          other.teacherFixedAmount == this.teacherFixedAmount &&
          other.isArchived == this.isArchived &&
          other.photoPath == this.photoPath &&
          other.gender == this.gender &&
          other.overdueThresholdDays == this.overdueThresholdDays &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class TeachersCompanion extends UpdateCompanion<Teacher> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> firstNameAr;
  final Value<String> lastNameAr;
  final Value<String?> firstNameFr;
  final Value<String?> lastNameFr;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> email;
  final Value<String?> idCard;
  final Value<DateTime?> employmentStartDate;
  final Value<DateTime?> employmentEndDate;
  final Value<String> salaryType;
  final Value<double?> teacherSharePct;
  final Value<double?> teacherFixedAmount;
  final Value<bool> isArchived;
  final Value<String?> photoPath;
  final Value<String?> gender;
  final Value<int?> overdueThresholdDays;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const TeachersCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.firstNameAr = const Value.absent(),
    this.lastNameAr = const Value.absent(),
    this.firstNameFr = const Value.absent(),
    this.lastNameFr = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.email = const Value.absent(),
    this.idCard = const Value.absent(),
    this.employmentStartDate = const Value.absent(),
    this.employmentEndDate = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.teacherSharePct = const Value.absent(),
    this.teacherFixedAmount = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.gender = const Value.absent(),
    this.overdueThresholdDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeachersCompanion.insert({
    required String id,
    required String code,
    required String firstNameAr,
    required String lastNameAr,
    this.firstNameFr = const Value.absent(),
    this.lastNameFr = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.email = const Value.absent(),
    this.idCard = const Value.absent(),
    this.employmentStartDate = const Value.absent(),
    this.employmentEndDate = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.teacherSharePct = const Value.absent(),
    this.teacherFixedAmount = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.gender = const Value.absent(),
    this.overdueThresholdDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       firstNameAr = Value(firstNameAr),
       lastNameAr = Value(lastNameAr),
       deviceId = Value(deviceId);
  static Insertable<Teacher> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? firstNameAr,
    Expression<String>? lastNameAr,
    Expression<String>? firstNameFr,
    Expression<String>? lastNameFr,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? email,
    Expression<String>? idCard,
    Expression<DateTime>? employmentStartDate,
    Expression<DateTime>? employmentEndDate,
    Expression<String>? salaryType,
    Expression<double>? teacherSharePct,
    Expression<double>? teacherFixedAmount,
    Expression<bool>? isArchived,
    Expression<String>? photoPath,
    Expression<String>? gender,
    Expression<int>? overdueThresholdDays,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (firstNameAr != null) 'first_name_ar': firstNameAr,
      if (lastNameAr != null) 'last_name_ar': lastNameAr,
      if (firstNameFr != null) 'first_name_fr': firstNameFr,
      if (lastNameFr != null) 'last_name_fr': lastNameFr,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (email != null) 'email': email,
      if (idCard != null) 'id_card': idCard,
      if (employmentStartDate != null)
        'employment_start_date': employmentStartDate,
      if (employmentEndDate != null) 'employment_end_date': employmentEndDate,
      if (salaryType != null) 'salary_type': salaryType,
      if (teacherSharePct != null) 'teacher_share_pct': teacherSharePct,
      if (teacherFixedAmount != null)
        'teacher_fixed_amount': teacherFixedAmount,
      if (isArchived != null) 'is_archived': isArchived,
      if (photoPath != null) 'photo_path': photoPath,
      if (gender != null) 'gender': gender,
      if (overdueThresholdDays != null)
        'overdue_threshold_days': overdueThresholdDays,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeachersCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? firstNameAr,
    Value<String>? lastNameAr,
    Value<String?>? firstNameFr,
    Value<String?>? lastNameFr,
    Value<String?>? phone,
    Value<String?>? address,
    Value<String?>? email,
    Value<String?>? idCard,
    Value<DateTime?>? employmentStartDate,
    Value<DateTime?>? employmentEndDate,
    Value<String>? salaryType,
    Value<double?>? teacherSharePct,
    Value<double?>? teacherFixedAmount,
    Value<bool>? isArchived,
    Value<String?>? photoPath,
    Value<String?>? gender,
    Value<int?>? overdueThresholdDays,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return TeachersCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      firstNameAr: firstNameAr ?? this.firstNameAr,
      lastNameAr: lastNameAr ?? this.lastNameAr,
      firstNameFr: firstNameFr ?? this.firstNameFr,
      lastNameFr: lastNameFr ?? this.lastNameFr,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      email: email ?? this.email,
      idCard: idCard ?? this.idCard,
      employmentStartDate: employmentStartDate ?? this.employmentStartDate,
      employmentEndDate: employmentEndDate ?? this.employmentEndDate,
      salaryType: salaryType ?? this.salaryType,
      teacherSharePct: teacherSharePct ?? this.teacherSharePct,
      teacherFixedAmount: teacherFixedAmount ?? this.teacherFixedAmount,
      isArchived: isArchived ?? this.isArchived,
      photoPath: photoPath ?? this.photoPath,
      gender: gender ?? this.gender,
      overdueThresholdDays: overdueThresholdDays ?? this.overdueThresholdDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (firstNameAr.present) {
      map['first_name_ar'] = Variable<String>(firstNameAr.value);
    }
    if (lastNameAr.present) {
      map['last_name_ar'] = Variable<String>(lastNameAr.value);
    }
    if (firstNameFr.present) {
      map['first_name_fr'] = Variable<String>(firstNameFr.value);
    }
    if (lastNameFr.present) {
      map['last_name_fr'] = Variable<String>(lastNameFr.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (idCard.present) {
      map['id_card'] = Variable<String>(idCard.value);
    }
    if (employmentStartDate.present) {
      map['employment_start_date'] = Variable<DateTime>(
        employmentStartDate.value,
      );
    }
    if (employmentEndDate.present) {
      map['employment_end_date'] = Variable<DateTime>(employmentEndDate.value);
    }
    if (salaryType.present) {
      map['salary_type'] = Variable<String>(salaryType.value);
    }
    if (teacherSharePct.present) {
      map['teacher_share_pct'] = Variable<double>(teacherSharePct.value);
    }
    if (teacherFixedAmount.present) {
      map['teacher_fixed_amount'] = Variable<double>(teacherFixedAmount.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (overdueThresholdDays.present) {
      map['overdue_threshold_days'] = Variable<int>(overdueThresholdDays.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeachersCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('firstNameAr: $firstNameAr, ')
          ..write('lastNameAr: $lastNameAr, ')
          ..write('firstNameFr: $firstNameFr, ')
          ..write('lastNameFr: $lastNameFr, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('email: $email, ')
          ..write('idCard: $idCard, ')
          ..write('employmentStartDate: $employmentStartDate, ')
          ..write('employmentEndDate: $employmentEndDate, ')
          ..write('salaryType: $salaryType, ')
          ..write('teacherSharePct: $teacherSharePct, ')
          ..write('teacherFixedAmount: $teacherFixedAmount, ')
          ..write('isArchived: $isArchived, ')
          ..write('photoPath: $photoPath, ')
          ..write('gender: $gender, ')
          ..write('overdueThresholdDays: $overdueThresholdDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClassroomsTable extends Classrooms
    with TableInfo<$ClassroomsTable, Classroom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClassroomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _floorMeta = const VerificationMeta('floor');
  @override
  late final GeneratedColumn<int> floor = GeneratedColumn<int>(
    'floor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameAr,
    nameFr,
    floor,
    capacity,
    notes,
    isArchived,
    createdAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'classrooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Classroom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(
        _nameFrMeta,
        nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta),
      );
    }
    if (data.containsKey('floor')) {
      context.handle(
        _floorMeta,
        floor.isAcceptableOrUnknown(data['floor']!, _floorMeta),
      );
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Classroom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Classroom(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      ),
      floor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}floor'],
      ),
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $ClassroomsTable createAlias(String alias) {
    return $ClassroomsTable(attachedDatabase, alias);
  }
}

class Classroom extends DataClass implements Insertable<Classroom> {
  final String id;
  final String nameAr;
  final String? nameFr;
  final int? floor;
  final int? capacity;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deviceId;
  const Classroom({
    required this.id,
    required this.nameAr,
    this.nameFr,
    this.floor,
    this.capacity,
    this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    if (!nullToAbsent || nameFr != null) {
      map['name_fr'] = Variable<String>(nameFr);
    }
    if (!nullToAbsent || floor != null) {
      map['floor'] = Variable<int>(floor);
    }
    if (!nullToAbsent || capacity != null) {
      map['capacity'] = Variable<int>(capacity);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  ClassroomsCompanion toCompanion(bool nullToAbsent) {
    return ClassroomsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameFr: nameFr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameFr),
      floor: floor == null && nullToAbsent
          ? const Value.absent()
          : Value(floor),
      capacity: capacity == null && nullToAbsent
          ? const Value.absent()
          : Value(capacity),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Classroom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Classroom(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameFr: serializer.fromJson<String?>(json['nameFr']),
      floor: serializer.fromJson<int?>(json['floor']),
      capacity: serializer.fromJson<int?>(json['capacity']),
      notes: serializer.fromJson<String?>(json['notes']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameFr': serializer.toJson<String?>(nameFr),
      'floor': serializer.toJson<int?>(floor),
      'capacity': serializer.toJson<int?>(capacity),
      'notes': serializer.toJson<String?>(notes),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Classroom copyWith({
    String? id,
    String? nameAr,
    Value<String?> nameFr = const Value.absent(),
    Value<int?> floor = const Value.absent(),
    Value<int?> capacity = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
  }) => Classroom(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameFr: nameFr.present ? nameFr.value : this.nameFr,
    floor: floor.present ? floor.value : this.floor,
    capacity: capacity.present ? capacity.value : this.capacity,
    notes: notes.present ? notes.value : this.notes,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Classroom copyWithCompanion(ClassroomsCompanion data) {
    return Classroom(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      floor: data.floor.present ? data.floor.value : this.floor,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      notes: data.notes.present ? data.notes.value : this.notes,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Classroom(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameFr: $nameFr, ')
          ..write('floor: $floor, ')
          ..write('capacity: $capacity, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameAr,
    nameFr,
    floor,
    capacity,
    notes,
    isArchived,
    createdAt,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Classroom &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameFr == this.nameFr &&
          other.floor == this.floor &&
          other.capacity == this.capacity &&
          other.notes == this.notes &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class ClassroomsCompanion extends UpdateCompanion<Classroom> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String?> nameFr;
  final Value<int?> floor;
  final Value<int?> capacity;
  final Value<String?> notes;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const ClassroomsCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.floor = const Value.absent(),
    this.capacity = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClassroomsCompanion.insert({
    required String id,
    required String nameAr,
    this.nameFr = const Value.absent(),
    this.floor = const Value.absent(),
    this.capacity = const Value.absent(),
    this.notes = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameAr = Value(nameAr),
       deviceId = Value(deviceId);
  static Insertable<Classroom> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameFr,
    Expression<int>? floor,
    Expression<int>? capacity,
    Expression<String>? notes,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameFr != null) 'name_fr': nameFr,
      if (floor != null) 'floor': floor,
      if (capacity != null) 'capacity': capacity,
      if (notes != null) 'notes': notes,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClassroomsCompanion copyWith({
    Value<String>? id,
    Value<String>? nameAr,
    Value<String?>? nameFr,
    Value<int?>? floor,
    Value<int?>? capacity,
    Value<String?>? notes,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return ClassroomsCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameFr: nameFr ?? this.nameFr,
      floor: floor ?? this.floor,
      capacity: capacity ?? this.capacity,
      notes: notes ?? this.notes,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (floor.present) {
      map['floor'] = Variable<int>(floor.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClassroomsCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameFr: $nameFr, ')
          ..write('floor: $floor, ')
          ..write('capacity: $capacity, ')
          ..write('notes: $notes, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubjectGroupsTable extends SubjectGroups
    with TableInfo<$SubjectGroupsTable, SubjectGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
    'name_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectArMeta = const VerificationMeta(
    'subjectAr',
  );
  @override
  late final GeneratedColumn<String> subjectAr = GeneratedColumn<String>(
    'subject_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectFrMeta = const VerificationMeta(
    'subjectFr',
  );
  @override
  late final GeneratedColumn<String> subjectFr = GeneratedColumn<String>(
    'subject_fr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schoolLevelMeta = const VerificationMeta(
    'schoolLevel',
  );
  @override
  late final GeneratedColumn<String> schoolLevel = GeneratedColumn<String>(
    'school_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capacityMeta = const VerificationMeta(
    'capacity',
  );
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
    'capacity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameAr,
    nameFr,
    subjectAr,
    subjectFr,
    schoolLevel,
    description,
    capacity,
    isArchived,
    createdAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subject_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubjectGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(
        _nameFrMeta,
        nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta),
      );
    }
    if (data.containsKey('subject_ar')) {
      context.handle(
        _subjectArMeta,
        subjectAr.isAcceptableOrUnknown(data['subject_ar']!, _subjectArMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectArMeta);
    }
    if (data.containsKey('subject_fr')) {
      context.handle(
        _subjectFrMeta,
        subjectFr.isAcceptableOrUnknown(data['subject_fr']!, _subjectFrMeta),
      );
    }
    if (data.containsKey('school_level')) {
      context.handle(
        _schoolLevelMeta,
        schoolLevel.isAcceptableOrUnknown(
          data['school_level']!,
          _schoolLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schoolLevelMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('capacity')) {
      context.handle(
        _capacityMeta,
        capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubjectGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_fr'],
      ),
      subjectAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_ar'],
      )!,
      subjectFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_fr'],
      ),
      schoolLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school_level'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      capacity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}capacity'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $SubjectGroupsTable createAlias(String alias) {
    return $SubjectGroupsTable(attachedDatabase, alias);
  }
}

class SubjectGroup extends DataClass implements Insertable<SubjectGroup> {
  final String id;
  final String nameAr;
  final String? nameFr;
  final String subjectAr;
  final String? subjectFr;
  final String schoolLevel;
  final String? description;
  final int? capacity;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deviceId;
  const SubjectGroup({
    required this.id,
    required this.nameAr,
    this.nameFr,
    required this.subjectAr,
    this.subjectFr,
    required this.schoolLevel,
    this.description,
    this.capacity,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    if (!nullToAbsent || nameFr != null) {
      map['name_fr'] = Variable<String>(nameFr);
    }
    map['subject_ar'] = Variable<String>(subjectAr);
    if (!nullToAbsent || subjectFr != null) {
      map['subject_fr'] = Variable<String>(subjectFr);
    }
    map['school_level'] = Variable<String>(schoolLevel);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || capacity != null) {
      map['capacity'] = Variable<int>(capacity);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  SubjectGroupsCompanion toCompanion(bool nullToAbsent) {
    return SubjectGroupsCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameFr: nameFr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameFr),
      subjectAr: Value(subjectAr),
      subjectFr: subjectFr == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectFr),
      schoolLevel: Value(schoolLevel),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      capacity: capacity == null && nullToAbsent
          ? const Value.absent()
          : Value(capacity),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory SubjectGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectGroup(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameFr: serializer.fromJson<String?>(json['nameFr']),
      subjectAr: serializer.fromJson<String>(json['subjectAr']),
      subjectFr: serializer.fromJson<String?>(json['subjectFr']),
      schoolLevel: serializer.fromJson<String>(json['schoolLevel']),
      description: serializer.fromJson<String?>(json['description']),
      capacity: serializer.fromJson<int?>(json['capacity']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameFr': serializer.toJson<String?>(nameFr),
      'subjectAr': serializer.toJson<String>(subjectAr),
      'subjectFr': serializer.toJson<String?>(subjectFr),
      'schoolLevel': serializer.toJson<String>(schoolLevel),
      'description': serializer.toJson<String?>(description),
      'capacity': serializer.toJson<int?>(capacity),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  SubjectGroup copyWith({
    String? id,
    String? nameAr,
    Value<String?> nameFr = const Value.absent(),
    String? subjectAr,
    Value<String?> subjectFr = const Value.absent(),
    String? schoolLevel,
    Value<String?> description = const Value.absent(),
    Value<int?> capacity = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
  }) => SubjectGroup(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameFr: nameFr.present ? nameFr.value : this.nameFr,
    subjectAr: subjectAr ?? this.subjectAr,
    subjectFr: subjectFr.present ? subjectFr.value : this.subjectFr,
    schoolLevel: schoolLevel ?? this.schoolLevel,
    description: description.present ? description.value : this.description,
    capacity: capacity.present ? capacity.value : this.capacity,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  SubjectGroup copyWithCompanion(SubjectGroupsCompanion data) {
    return SubjectGroup(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      subjectAr: data.subjectAr.present ? data.subjectAr.value : this.subjectAr,
      subjectFr: data.subjectFr.present ? data.subjectFr.value : this.subjectFr,
      schoolLevel: data.schoolLevel.present
          ? data.schoolLevel.value
          : this.schoolLevel,
      description: data.description.present
          ? data.description.value
          : this.description,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectGroup(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameFr: $nameFr, ')
          ..write('subjectAr: $subjectAr, ')
          ..write('subjectFr: $subjectFr, ')
          ..write('schoolLevel: $schoolLevel, ')
          ..write('description: $description, ')
          ..write('capacity: $capacity, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameAr,
    nameFr,
    subjectAr,
    subjectFr,
    schoolLevel,
    description,
    capacity,
    isArchived,
    createdAt,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectGroup &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameFr == this.nameFr &&
          other.subjectAr == this.subjectAr &&
          other.subjectFr == this.subjectFr &&
          other.schoolLevel == this.schoolLevel &&
          other.description == this.description &&
          other.capacity == this.capacity &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class SubjectGroupsCompanion extends UpdateCompanion<SubjectGroup> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String?> nameFr;
  final Value<String> subjectAr;
  final Value<String?> subjectFr;
  final Value<String> schoolLevel;
  final Value<String?> description;
  final Value<int?> capacity;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const SubjectGroupsCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.subjectAr = const Value.absent(),
    this.subjectFr = const Value.absent(),
    this.schoolLevel = const Value.absent(),
    this.description = const Value.absent(),
    this.capacity = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectGroupsCompanion.insert({
    required String id,
    required String nameAr,
    this.nameFr = const Value.absent(),
    required String subjectAr,
    this.subjectFr = const Value.absent(),
    required String schoolLevel,
    this.description = const Value.absent(),
    this.capacity = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameAr = Value(nameAr),
       subjectAr = Value(subjectAr),
       schoolLevel = Value(schoolLevel),
       deviceId = Value(deviceId);
  static Insertable<SubjectGroup> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameFr,
    Expression<String>? subjectAr,
    Expression<String>? subjectFr,
    Expression<String>? schoolLevel,
    Expression<String>? description,
    Expression<int>? capacity,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameFr != null) 'name_fr': nameFr,
      if (subjectAr != null) 'subject_ar': subjectAr,
      if (subjectFr != null) 'subject_fr': subjectFr,
      if (schoolLevel != null) 'school_level': schoolLevel,
      if (description != null) 'description': description,
      if (capacity != null) 'capacity': capacity,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? nameAr,
    Value<String?>? nameFr,
    Value<String>? subjectAr,
    Value<String?>? subjectFr,
    Value<String>? schoolLevel,
    Value<String?>? description,
    Value<int?>? capacity,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return SubjectGroupsCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameFr: nameFr ?? this.nameFr,
      subjectAr: subjectAr ?? this.subjectAr,
      subjectFr: subjectFr ?? this.subjectFr,
      schoolLevel: schoolLevel ?? this.schoolLevel,
      description: description ?? this.description,
      capacity: capacity ?? this.capacity,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (subjectAr.present) {
      map['subject_ar'] = Variable<String>(subjectAr.value);
    }
    if (subjectFr.present) {
      map['subject_fr'] = Variable<String>(subjectFr.value);
    }
    if (schoolLevel.present) {
      map['school_level'] = Variable<String>(schoolLevel.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectGroupsCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameFr: $nameFr, ')
          ..write('subjectAr: $subjectAr, ')
          ..write('subjectFr: $subjectFr, ')
          ..write('schoolLevel: $schoolLevel, ')
          ..write('description: $description, ')
          ..write('capacity: $capacity, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectGroupIdMeta = const VerificationMeta(
    'subjectGroupId',
  );
  @override
  late final GeneratedColumn<String> subjectGroupId = GeneratedColumn<String>(
    'subject_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subject_groups (id)',
    ),
  );
  static const VerificationMeta _teacherIdMeta = const VerificationMeta(
    'teacherId',
  );
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
    'teacher_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teachers (id)',
    ),
  );
  static const VerificationMeta _classroomIdMeta = const VerificationMeta(
    'classroomId',
  );
  @override
  late final GeneratedColumn<String> classroomId = GeneratedColumn<String>(
    'classroom_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES classrooms (id)',
    ),
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyPriceMeta = const VerificationMeta(
    'monthlyPrice',
  );
  @override
  late final GeneratedColumn<double> monthlyPrice = GeneratedColumn<double>(
    'monthly_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionsPerMonthMeta = const VerificationMeta(
    'sessionsPerMonth',
  );
  @override
  late final GeneratedColumn<int> sessionsPerMonth = GeneratedColumn<int>(
    'sessions_per_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherSharePctMeta = const VerificationMeta(
    'teacherSharePct',
  );
  @override
  late final GeneratedColumn<double> teacherSharePct = GeneratedColumn<double>(
    'teacher_share_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teacherFixedAmountMeta =
      const VerificationMeta('teacherFixedAmount');
  @override
  late final GeneratedColumn<double> teacherFixedAmount =
      GeneratedColumn<double>(
        'teacher_fixed_amount',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectGroupId,
    teacherId,
    classroomId,
    dayOfWeek,
    startTime,
    endTime,
    monthlyPrice,
    sessionsPerMonth,
    teacherSharePct,
    teacherFixedAmount,
    isActive,
    isArchived,
    createdAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_group_id')) {
      context.handle(
        _subjectGroupIdMeta,
        subjectGroupId.isAcceptableOrUnknown(
          data['subject_group_id']!,
          _subjectGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectGroupIdMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(
        _teacherIdMeta,
        teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('classroom_id')) {
      context.handle(
        _classroomIdMeta,
        classroomId.isAcceptableOrUnknown(
          data['classroom_id']!,
          _classroomIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classroomIdMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('monthly_price')) {
      context.handle(
        _monthlyPriceMeta,
        monthlyPrice.isAcceptableOrUnknown(
          data['monthly_price']!,
          _monthlyPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyPriceMeta);
    }
    if (data.containsKey('sessions_per_month')) {
      context.handle(
        _sessionsPerMonthMeta,
        sessionsPerMonth.isAcceptableOrUnknown(
          data['sessions_per_month']!,
          _sessionsPerMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionsPerMonthMeta);
    }
    if (data.containsKey('teacher_share_pct')) {
      context.handle(
        _teacherSharePctMeta,
        teacherSharePct.isAcceptableOrUnknown(
          data['teacher_share_pct']!,
          _teacherSharePctMeta,
        ),
      );
    }
    if (data.containsKey('teacher_fixed_amount')) {
      context.handle(
        _teacherFixedAmountMeta,
        teacherFixedAmount.isAcceptableOrUnknown(
          data['teacher_fixed_amount']!,
          _teacherFixedAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_group_id'],
      )!,
      teacherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_id'],
      )!,
      classroomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classroom_id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      monthlyPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_price'],
      )!,
      sessionsPerMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sessions_per_month'],
      )!,
      teacherSharePct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}teacher_share_pct'],
      ),
      teacherFixedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}teacher_fixed_amount'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String subjectGroupId;
  final String teacherId;
  final String classroomId;
  final int dayOfWeek;
  final DateTime startTime;
  final DateTime endTime;
  final double monthlyPrice;
  final int sessionsPerMonth;
  final double? teacherSharePct;
  final double? teacherFixedAmount;
  final bool isActive;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deviceId;
  const Session({
    required this.id,
    required this.subjectGroupId,
    required this.teacherId,
    required this.classroomId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.monthlyPrice,
    required this.sessionsPerMonth,
    this.teacherSharePct,
    this.teacherFixedAmount,
    required this.isActive,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_group_id'] = Variable<String>(subjectGroupId);
    map['teacher_id'] = Variable<String>(teacherId);
    map['classroom_id'] = Variable<String>(classroomId);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['monthly_price'] = Variable<double>(monthlyPrice);
    map['sessions_per_month'] = Variable<int>(sessionsPerMonth);
    if (!nullToAbsent || teacherSharePct != null) {
      map['teacher_share_pct'] = Variable<double>(teacherSharePct);
    }
    if (!nullToAbsent || teacherFixedAmount != null) {
      map['teacher_fixed_amount'] = Variable<double>(teacherFixedAmount);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      subjectGroupId: Value(subjectGroupId),
      teacherId: Value(teacherId),
      classroomId: Value(classroomId),
      dayOfWeek: Value(dayOfWeek),
      startTime: Value(startTime),
      endTime: Value(endTime),
      monthlyPrice: Value(monthlyPrice),
      sessionsPerMonth: Value(sessionsPerMonth),
      teacherSharePct: teacherSharePct == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherSharePct),
      teacherFixedAmount: teacherFixedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherFixedAmount),
      isActive: Value(isActive),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      subjectGroupId: serializer.fromJson<String>(json['subjectGroupId']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      classroomId: serializer.fromJson<String>(json['classroomId']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      monthlyPrice: serializer.fromJson<double>(json['monthlyPrice']),
      sessionsPerMonth: serializer.fromJson<int>(json['sessionsPerMonth']),
      teacherSharePct: serializer.fromJson<double?>(json['teacherSharePct']),
      teacherFixedAmount: serializer.fromJson<double?>(
        json['teacherFixedAmount'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectGroupId': serializer.toJson<String>(subjectGroupId),
      'teacherId': serializer.toJson<String>(teacherId),
      'classroomId': serializer.toJson<String>(classroomId),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'monthlyPrice': serializer.toJson<double>(monthlyPrice),
      'sessionsPerMonth': serializer.toJson<int>(sessionsPerMonth),
      'teacherSharePct': serializer.toJson<double?>(teacherSharePct),
      'teacherFixedAmount': serializer.toJson<double?>(teacherFixedAmount),
      'isActive': serializer.toJson<bool>(isActive),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Session copyWith({
    String? id,
    String? subjectGroupId,
    String? teacherId,
    String? classroomId,
    int? dayOfWeek,
    DateTime? startTime,
    DateTime? endTime,
    double? monthlyPrice,
    int? sessionsPerMonth,
    Value<double?> teacherSharePct = const Value.absent(),
    Value<double?> teacherFixedAmount = const Value.absent(),
    bool? isActive,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
  }) => Session(
    id: id ?? this.id,
    subjectGroupId: subjectGroupId ?? this.subjectGroupId,
    teacherId: teacherId ?? this.teacherId,
    classroomId: classroomId ?? this.classroomId,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    monthlyPrice: monthlyPrice ?? this.monthlyPrice,
    sessionsPerMonth: sessionsPerMonth ?? this.sessionsPerMonth,
    teacherSharePct: teacherSharePct.present
        ? teacherSharePct.value
        : this.teacherSharePct,
    teacherFixedAmount: teacherFixedAmount.present
        ? teacherFixedAmount.value
        : this.teacherFixedAmount,
    isActive: isActive ?? this.isActive,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      subjectGroupId: data.subjectGroupId.present
          ? data.subjectGroupId.value
          : this.subjectGroupId,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      classroomId: data.classroomId.present
          ? data.classroomId.value
          : this.classroomId,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      monthlyPrice: data.monthlyPrice.present
          ? data.monthlyPrice.value
          : this.monthlyPrice,
      sessionsPerMonth: data.sessionsPerMonth.present
          ? data.sessionsPerMonth.value
          : this.sessionsPerMonth,
      teacherSharePct: data.teacherSharePct.present
          ? data.teacherSharePct.value
          : this.teacherSharePct,
      teacherFixedAmount: data.teacherFixedAmount.present
          ? data.teacherFixedAmount.value
          : this.teacherFixedAmount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('teacherId: $teacherId, ')
          ..write('classroomId: $classroomId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('monthlyPrice: $monthlyPrice, ')
          ..write('sessionsPerMonth: $sessionsPerMonth, ')
          ..write('teacherSharePct: $teacherSharePct, ')
          ..write('teacherFixedAmount: $teacherFixedAmount, ')
          ..write('isActive: $isActive, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectGroupId,
    teacherId,
    classroomId,
    dayOfWeek,
    startTime,
    endTime,
    monthlyPrice,
    sessionsPerMonth,
    teacherSharePct,
    teacherFixedAmount,
    isActive,
    isArchived,
    createdAt,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.subjectGroupId == this.subjectGroupId &&
          other.teacherId == this.teacherId &&
          other.classroomId == this.classroomId &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.monthlyPrice == this.monthlyPrice &&
          other.sessionsPerMonth == this.sessionsPerMonth &&
          other.teacherSharePct == this.teacherSharePct &&
          other.teacherFixedAmount == this.teacherFixedAmount &&
          other.isActive == this.isActive &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> subjectGroupId;
  final Value<String> teacherId;
  final Value<String> classroomId;
  final Value<int> dayOfWeek;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<double> monthlyPrice;
  final Value<int> sessionsPerMonth;
  final Value<double?> teacherSharePct;
  final Value<double?> teacherFixedAmount;
  final Value<bool> isActive;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.subjectGroupId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.classroomId = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.monthlyPrice = const Value.absent(),
    this.sessionsPerMonth = const Value.absent(),
    this.teacherSharePct = const Value.absent(),
    this.teacherFixedAmount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String subjectGroupId,
    required String teacherId,
    required String classroomId,
    required int dayOfWeek,
    required DateTime startTime,
    required DateTime endTime,
    required double monthlyPrice,
    required int sessionsPerMonth,
    this.teacherSharePct = const Value.absent(),
    this.teacherFixedAmount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectGroupId = Value(subjectGroupId),
       teacherId = Value(teacherId),
       classroomId = Value(classroomId),
       dayOfWeek = Value(dayOfWeek),
       startTime = Value(startTime),
       endTime = Value(endTime),
       monthlyPrice = Value(monthlyPrice),
       sessionsPerMonth = Value(sessionsPerMonth),
       deviceId = Value(deviceId);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? subjectGroupId,
    Expression<String>? teacherId,
    Expression<String>? classroomId,
    Expression<int>? dayOfWeek,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? monthlyPrice,
    Expression<int>? sessionsPerMonth,
    Expression<double>? teacherSharePct,
    Expression<double>? teacherFixedAmount,
    Expression<bool>? isActive,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectGroupId != null) 'subject_group_id': subjectGroupId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (classroomId != null) 'classroom_id': classroomId,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (monthlyPrice != null) 'monthly_price': monthlyPrice,
      if (sessionsPerMonth != null) 'sessions_per_month': sessionsPerMonth,
      if (teacherSharePct != null) 'teacher_share_pct': teacherSharePct,
      if (teacherFixedAmount != null)
        'teacher_fixed_amount': teacherFixedAmount,
      if (isActive != null) 'is_active': isActive,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectGroupId,
    Value<String>? teacherId,
    Value<String>? classroomId,
    Value<int>? dayOfWeek,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<double>? monthlyPrice,
    Value<int>? sessionsPerMonth,
    Value<double?>? teacherSharePct,
    Value<double?>? teacherFixedAmount,
    Value<bool>? isActive,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      subjectGroupId: subjectGroupId ?? this.subjectGroupId,
      teacherId: teacherId ?? this.teacherId,
      classroomId: classroomId ?? this.classroomId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      sessionsPerMonth: sessionsPerMonth ?? this.sessionsPerMonth,
      teacherSharePct: teacherSharePct ?? this.teacherSharePct,
      teacherFixedAmount: teacherFixedAmount ?? this.teacherFixedAmount,
      isActive: isActive ?? this.isActive,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectGroupId.present) {
      map['subject_group_id'] = Variable<String>(subjectGroupId.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (classroomId.present) {
      map['classroom_id'] = Variable<String>(classroomId.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (monthlyPrice.present) {
      map['monthly_price'] = Variable<double>(monthlyPrice.value);
    }
    if (sessionsPerMonth.present) {
      map['sessions_per_month'] = Variable<int>(sessionsPerMonth.value);
    }
    if (teacherSharePct.present) {
      map['teacher_share_pct'] = Variable<double>(teacherSharePct.value);
    }
    if (teacherFixedAmount.present) {
      map['teacher_fixed_amount'] = Variable<double>(teacherFixedAmount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('teacherId: $teacherId, ')
          ..write('classroomId: $classroomId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('monthlyPrice: $monthlyPrice, ')
          ..write('sessionsPerMonth: $sessionsPerMonth, ')
          ..write('teacherSharePct: $teacherSharePct, ')
          ..write('teacherFixedAmount: $teacherFixedAmount, ')
          ..write('isActive: $isActive, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnrollmentsTable extends Enrollments
    with TableInfo<$EnrollmentsTable, Enrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnrollmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _subjectGroupIdMeta = const VerificationMeta(
    'subjectGroupId',
  );
  @override
  late final GeneratedColumn<String> subjectGroupId = GeneratedColumn<String>(
    'subject_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subject_groups (id)',
    ),
  );
  static const VerificationMeta _enrollmentDateMeta = const VerificationMeta(
    'enrollmentDate',
  );
  @override
  late final GeneratedColumn<DateTime> enrollmentDate =
      GeneratedColumn<DateTime>(
        'enrollment_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _customPriceOverrideMeta =
      const VerificationMeta('customPriceOverride');
  @override
  late final GeneratedColumn<double> customPriceOverride =
      GeneratedColumn<double>(
        'custom_price_override',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customDiscountMeta = const VerificationMeta(
    'customDiscount',
  );
  @override
  late final GeneratedColumn<double> customDiscount = GeneratedColumn<double>(
    'custom_discount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isTransferredMeta = const VerificationMeta(
    'isTransferred',
  );
  @override
  late final GeneratedColumn<bool> isTransferred = GeneratedColumn<bool>(
    'is_transferred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_transferred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    subjectGroupId,
    enrollmentDate,
    customPriceOverride,
    customDiscount,
    status,
    notes,
    isTransferred,
    createdAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'enrollments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Enrollment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('subject_group_id')) {
      context.handle(
        _subjectGroupIdMeta,
        subjectGroupId.isAcceptableOrUnknown(
          data['subject_group_id']!,
          _subjectGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectGroupIdMeta);
    }
    if (data.containsKey('enrollment_date')) {
      context.handle(
        _enrollmentDateMeta,
        enrollmentDate.isAcceptableOrUnknown(
          data['enrollment_date']!,
          _enrollmentDateMeta,
        ),
      );
    }
    if (data.containsKey('custom_price_override')) {
      context.handle(
        _customPriceOverrideMeta,
        customPriceOverride.isAcceptableOrUnknown(
          data['custom_price_override']!,
          _customPriceOverrideMeta,
        ),
      );
    }
    if (data.containsKey('custom_discount')) {
      context.handle(
        _customDiscountMeta,
        customDiscount.isAcceptableOrUnknown(
          data['custom_discount']!,
          _customDiscountMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_transferred')) {
      context.handle(
        _isTransferredMeta,
        isTransferred.isAcceptableOrUnknown(
          data['is_transferred']!,
          _isTransferredMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Enrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Enrollment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      subjectGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_group_id'],
      )!,
      enrollmentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}enrollment_date'],
      )!,
      customPriceOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}custom_price_override'],
      ),
      customDiscount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}custom_discount'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isTransferred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_transferred'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $EnrollmentsTable createAlias(String alias) {
    return $EnrollmentsTable(attachedDatabase, alias);
  }
}

class Enrollment extends DataClass implements Insertable<Enrollment> {
  final String id;
  final String studentId;
  final String subjectGroupId;
  final DateTime enrollmentDate;
  final double? customPriceOverride;
  final double? customDiscount;
  final String status;
  final String? notes;
  final bool isTransferred;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deviceId;
  const Enrollment({
    required this.id,
    required this.studentId,
    required this.subjectGroupId,
    required this.enrollmentDate,
    this.customPriceOverride,
    this.customDiscount,
    required this.status,
    this.notes,
    required this.isTransferred,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['subject_group_id'] = Variable<String>(subjectGroupId);
    map['enrollment_date'] = Variable<DateTime>(enrollmentDate);
    if (!nullToAbsent || customPriceOverride != null) {
      map['custom_price_override'] = Variable<double>(customPriceOverride);
    }
    if (!nullToAbsent || customDiscount != null) {
      map['custom_discount'] = Variable<double>(customDiscount);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_transferred'] = Variable<bool>(isTransferred);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  EnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return EnrollmentsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      subjectGroupId: Value(subjectGroupId),
      enrollmentDate: Value(enrollmentDate),
      customPriceOverride: customPriceOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(customPriceOverride),
      customDiscount: customDiscount == null && nullToAbsent
          ? const Value.absent()
          : Value(customDiscount),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isTransferred: Value(isTransferred),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Enrollment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Enrollment(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      subjectGroupId: serializer.fromJson<String>(json['subjectGroupId']),
      enrollmentDate: serializer.fromJson<DateTime>(json['enrollmentDate']),
      customPriceOverride: serializer.fromJson<double?>(
        json['customPriceOverride'],
      ),
      customDiscount: serializer.fromJson<double?>(json['customDiscount']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isTransferred: serializer.fromJson<bool>(json['isTransferred']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'subjectGroupId': serializer.toJson<String>(subjectGroupId),
      'enrollmentDate': serializer.toJson<DateTime>(enrollmentDate),
      'customPriceOverride': serializer.toJson<double?>(customPriceOverride),
      'customDiscount': serializer.toJson<double?>(customDiscount),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'isTransferred': serializer.toJson<bool>(isTransferred),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Enrollment copyWith({
    String? id,
    String? studentId,
    String? subjectGroupId,
    DateTime? enrollmentDate,
    Value<double?> customPriceOverride = const Value.absent(),
    Value<double?> customDiscount = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
    bool? isTransferred,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
  }) => Enrollment(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    subjectGroupId: subjectGroupId ?? this.subjectGroupId,
    enrollmentDate: enrollmentDate ?? this.enrollmentDate,
    customPriceOverride: customPriceOverride.present
        ? customPriceOverride.value
        : this.customPriceOverride,
    customDiscount: customDiscount.present
        ? customDiscount.value
        : this.customDiscount,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    isTransferred: isTransferred ?? this.isTransferred,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Enrollment copyWithCompanion(EnrollmentsCompanion data) {
    return Enrollment(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      subjectGroupId: data.subjectGroupId.present
          ? data.subjectGroupId.value
          : this.subjectGroupId,
      enrollmentDate: data.enrollmentDate.present
          ? data.enrollmentDate.value
          : this.enrollmentDate,
      customPriceOverride: data.customPriceOverride.present
          ? data.customPriceOverride.value
          : this.customPriceOverride,
      customDiscount: data.customDiscount.present
          ? data.customDiscount.value
          : this.customDiscount,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      isTransferred: data.isTransferred.present
          ? data.isTransferred.value
          : this.isTransferred,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Enrollment(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('enrollmentDate: $enrollmentDate, ')
          ..write('customPriceOverride: $customPriceOverride, ')
          ..write('customDiscount: $customDiscount, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isTransferred: $isTransferred, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    subjectGroupId,
    enrollmentDate,
    customPriceOverride,
    customDiscount,
    status,
    notes,
    isTransferred,
    createdAt,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Enrollment &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.subjectGroupId == this.subjectGroupId &&
          other.enrollmentDate == this.enrollmentDate &&
          other.customPriceOverride == this.customPriceOverride &&
          other.customDiscount == this.customDiscount &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.isTransferred == this.isTransferred &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class EnrollmentsCompanion extends UpdateCompanion<Enrollment> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> subjectGroupId;
  final Value<DateTime> enrollmentDate;
  final Value<double?> customPriceOverride;
  final Value<double?> customDiscount;
  final Value<String> status;
  final Value<String?> notes;
  final Value<bool> isTransferred;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const EnrollmentsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.subjectGroupId = const Value.absent(),
    this.enrollmentDate = const Value.absent(),
    this.customPriceOverride = const Value.absent(),
    this.customDiscount = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isTransferred = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnrollmentsCompanion.insert({
    required String id,
    required String studentId,
    required String subjectGroupId,
    this.enrollmentDate = const Value.absent(),
    this.customPriceOverride = const Value.absent(),
    this.customDiscount = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isTransferred = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       subjectGroupId = Value(subjectGroupId),
       deviceId = Value(deviceId);
  static Insertable<Enrollment> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? subjectGroupId,
    Expression<DateTime>? enrollmentDate,
    Expression<double>? customPriceOverride,
    Expression<double>? customDiscount,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<bool>? isTransferred,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (subjectGroupId != null) 'subject_group_id': subjectGroupId,
      if (enrollmentDate != null) 'enrollment_date': enrollmentDate,
      if (customPriceOverride != null)
        'custom_price_override': customPriceOverride,
      if (customDiscount != null) 'custom_discount': customDiscount,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (isTransferred != null) 'is_transferred': isTransferred,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnrollmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? subjectGroupId,
    Value<DateTime>? enrollmentDate,
    Value<double?>? customPriceOverride,
    Value<double?>? customDiscount,
    Value<String>? status,
    Value<String?>? notes,
    Value<bool>? isTransferred,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return EnrollmentsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectGroupId: subjectGroupId ?? this.subjectGroupId,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      customPriceOverride: customPriceOverride ?? this.customPriceOverride,
      customDiscount: customDiscount ?? this.customDiscount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isTransferred: isTransferred ?? this.isTransferred,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (subjectGroupId.present) {
      map['subject_group_id'] = Variable<String>(subjectGroupId.value);
    }
    if (enrollmentDate.present) {
      map['enrollment_date'] = Variable<DateTime>(enrollmentDate.value);
    }
    if (customPriceOverride.present) {
      map['custom_price_override'] = Variable<double>(
        customPriceOverride.value,
      );
    }
    if (customDiscount.present) {
      map['custom_discount'] = Variable<double>(customDiscount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isTransferred.present) {
      map['is_transferred'] = Variable<bool>(isTransferred.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnrollmentsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('enrollmentDate: $enrollmentDate, ')
          ..write('customPriceOverride: $customPriceOverride, ')
          ..write('customDiscount: $customDiscount, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isTransferred: $isTransferred, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnrollmentWaitlistTable extends EnrollmentWaitlist
    with TableInfo<$EnrollmentWaitlistTable, EnrollmentWaitlistData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnrollmentWaitlistTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _subjectGroupIdMeta = const VerificationMeta(
    'subjectGroupId',
  );
  @override
  late final GeneratedColumn<String> subjectGroupId = GeneratedColumn<String>(
    'subject_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subject_groups (id)',
    ),
  );
  static const VerificationMeta _requestedAtMeta = const VerificationMeta(
    'requestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> requestedAt = GeneratedColumn<DateTime>(
    'requested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    subjectGroupId,
    requestedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'enrollment_waitlist';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnrollmentWaitlistData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('subject_group_id')) {
      context.handle(
        _subjectGroupIdMeta,
        subjectGroupId.isAcceptableOrUnknown(
          data['subject_group_id']!,
          _subjectGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectGroupIdMeta);
    }
    if (data.containsKey('requested_at')) {
      context.handle(
        _requestedAtMeta,
        requestedAt.isAcceptableOrUnknown(
          data['requested_at']!,
          _requestedAtMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnrollmentWaitlistData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnrollmentWaitlistData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      subjectGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_group_id'],
      )!,
      requestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}requested_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $EnrollmentWaitlistTable createAlias(String alias) {
    return $EnrollmentWaitlistTable(attachedDatabase, alias);
  }
}

class EnrollmentWaitlistData extends DataClass
    implements Insertable<EnrollmentWaitlistData> {
  final String id;
  final String studentId;
  final String subjectGroupId;
  final DateTime requestedAt;
  final String deviceId;
  const EnrollmentWaitlistData({
    required this.id,
    required this.studentId,
    required this.subjectGroupId,
    required this.requestedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['subject_group_id'] = Variable<String>(subjectGroupId);
    map['requested_at'] = Variable<DateTime>(requestedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  EnrollmentWaitlistCompanion toCompanion(bool nullToAbsent) {
    return EnrollmentWaitlistCompanion(
      id: Value(id),
      studentId: Value(studentId),
      subjectGroupId: Value(subjectGroupId),
      requestedAt: Value(requestedAt),
      deviceId: Value(deviceId),
    );
  }

  factory EnrollmentWaitlistData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnrollmentWaitlistData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      subjectGroupId: serializer.fromJson<String>(json['subjectGroupId']),
      requestedAt: serializer.fromJson<DateTime>(json['requestedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'subjectGroupId': serializer.toJson<String>(subjectGroupId),
      'requestedAt': serializer.toJson<DateTime>(requestedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  EnrollmentWaitlistData copyWith({
    String? id,
    String? studentId,
    String? subjectGroupId,
    DateTime? requestedAt,
    String? deviceId,
  }) => EnrollmentWaitlistData(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    subjectGroupId: subjectGroupId ?? this.subjectGroupId,
    requestedAt: requestedAt ?? this.requestedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  EnrollmentWaitlistData copyWithCompanion(EnrollmentWaitlistCompanion data) {
    return EnrollmentWaitlistData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      subjectGroupId: data.subjectGroupId.present
          ? data.subjectGroupId.value
          : this.subjectGroupId,
      requestedAt: data.requestedAt.present
          ? data.requestedAt.value
          : this.requestedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnrollmentWaitlistData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, studentId, subjectGroupId, requestedAt, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnrollmentWaitlistData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.subjectGroupId == this.subjectGroupId &&
          other.requestedAt == this.requestedAt &&
          other.deviceId == this.deviceId);
}

class EnrollmentWaitlistCompanion
    extends UpdateCompanion<EnrollmentWaitlistData> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> subjectGroupId;
  final Value<DateTime> requestedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const EnrollmentWaitlistCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.subjectGroupId = const Value.absent(),
    this.requestedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnrollmentWaitlistCompanion.insert({
    required String id,
    required String studentId,
    required String subjectGroupId,
    this.requestedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       subjectGroupId = Value(subjectGroupId),
       deviceId = Value(deviceId);
  static Insertable<EnrollmentWaitlistData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? subjectGroupId,
    Expression<DateTime>? requestedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (subjectGroupId != null) 'subject_group_id': subjectGroupId,
      if (requestedAt != null) 'requested_at': requestedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnrollmentWaitlistCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? subjectGroupId,
    Value<DateTime>? requestedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return EnrollmentWaitlistCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectGroupId: subjectGroupId ?? this.subjectGroupId,
      requestedAt: requestedAt ?? this.requestedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (subjectGroupId.present) {
      map['subject_group_id'] = Variable<String>(subjectGroupId.value);
    }
    if (requestedAt.present) {
      map['requested_at'] = Variable<DateTime>(requestedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnrollmentWaitlistCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CancellationsTable extends Cancellations
    with TableInfo<$CancellationsTable, Cancellation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CancellationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _cancelDateMeta = const VerificationMeta(
    'cancelDate',
  );
  @override
  late final GeneratedColumn<DateTime> cancelDate = GeneratedColumn<DateTime>(
    'cancel_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelledByUserIdMeta = const VerificationMeta(
    'cancelledByUserId',
  );
  @override
  late final GeneratedColumn<String> cancelledByUserId =
      GeneratedColumn<String>(
        'cancelled_by_user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    cancelDate,
    reason,
    cancelledByUserId,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cancellations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cancellation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('cancel_date')) {
      context.handle(
        _cancelDateMeta,
        cancelDate.isAcceptableOrUnknown(data['cancel_date']!, _cancelDateMeta),
      );
    } else if (isInserting) {
      context.missing(_cancelDateMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('cancelled_by_user_id')) {
      context.handle(
        _cancelledByUserIdMeta,
        cancelledByUserId.isAcceptableOrUnknown(
          data['cancelled_by_user_id']!,
          _cancelledByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cancellation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cancellation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      cancelDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancel_date'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      cancelledByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cancelled_by_user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $CancellationsTable createAlias(String alias) {
    return $CancellationsTable(attachedDatabase, alias);
  }
}

class Cancellation extends DataClass implements Insertable<Cancellation> {
  final String id;
  final String sessionId;
  final DateTime cancelDate;
  final String? reason;
  final String? cancelledByUserId;
  final DateTime createdAt;
  final String deviceId;
  const Cancellation({
    required this.id,
    required this.sessionId,
    required this.cancelDate,
    this.reason,
    this.cancelledByUserId,
    required this.createdAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['cancel_date'] = Variable<DateTime>(cancelDate);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || cancelledByUserId != null) {
      map['cancelled_by_user_id'] = Variable<String>(cancelledByUserId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  CancellationsCompanion toCompanion(bool nullToAbsent) {
    return CancellationsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      cancelDate: Value(cancelDate),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      cancelledByUserId: cancelledByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledByUserId),
      createdAt: Value(createdAt),
      deviceId: Value(deviceId),
    );
  }

  factory Cancellation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cancellation(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      cancelDate: serializer.fromJson<DateTime>(json['cancelDate']),
      reason: serializer.fromJson<String?>(json['reason']),
      cancelledByUserId: serializer.fromJson<String?>(
        json['cancelledByUserId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'cancelDate': serializer.toJson<DateTime>(cancelDate),
      'reason': serializer.toJson<String?>(reason),
      'cancelledByUserId': serializer.toJson<String?>(cancelledByUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Cancellation copyWith({
    String? id,
    String? sessionId,
    DateTime? cancelDate,
    Value<String?> reason = const Value.absent(),
    Value<String?> cancelledByUserId = const Value.absent(),
    DateTime? createdAt,
    String? deviceId,
  }) => Cancellation(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    cancelDate: cancelDate ?? this.cancelDate,
    reason: reason.present ? reason.value : this.reason,
    cancelledByUserId: cancelledByUserId.present
        ? cancelledByUserId.value
        : this.cancelledByUserId,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Cancellation copyWithCompanion(CancellationsCompanion data) {
    return Cancellation(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      cancelDate: data.cancelDate.present
          ? data.cancelDate.value
          : this.cancelDate,
      reason: data.reason.present ? data.reason.value : this.reason,
      cancelledByUserId: data.cancelledByUserId.present
          ? data.cancelledByUserId.value
          : this.cancelledByUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cancellation(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('cancelDate: $cancelDate, ')
          ..write('reason: $reason, ')
          ..write('cancelledByUserId: $cancelledByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    cancelDate,
    reason,
    cancelledByUserId,
    createdAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cancellation &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.cancelDate == this.cancelDate &&
          other.reason == this.reason &&
          other.cancelledByUserId == this.cancelledByUserId &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class CancellationsCompanion extends UpdateCompanion<Cancellation> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<DateTime> cancelDate;
  final Value<String?> reason;
  final Value<String?> cancelledByUserId;
  final Value<DateTime> createdAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const CancellationsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.cancelDate = const Value.absent(),
    this.reason = const Value.absent(),
    this.cancelledByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CancellationsCompanion.insert({
    required String id,
    required String sessionId,
    required DateTime cancelDate,
    this.reason = const Value.absent(),
    this.cancelledByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       cancelDate = Value(cancelDate),
       deviceId = Value(deviceId);
  static Insertable<Cancellation> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<DateTime>? cancelDate,
    Expression<String>? reason,
    Expression<String>? cancelledByUserId,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (cancelDate != null) 'cancel_date': cancelDate,
      if (reason != null) 'reason': reason,
      if (cancelledByUserId != null) 'cancelled_by_user_id': cancelledByUserId,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CancellationsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<DateTime>? cancelDate,
    Value<String?>? reason,
    Value<String?>? cancelledByUserId,
    Value<DateTime>? createdAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return CancellationsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      cancelDate: cancelDate ?? this.cancelDate,
      reason: reason ?? this.reason,
      cancelledByUserId: cancelledByUserId ?? this.cancelledByUserId,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (cancelDate.present) {
      map['cancel_date'] = Variable<DateTime>(cancelDate.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (cancelledByUserId.present) {
      map['cancelled_by_user_id'] = Variable<String>(cancelledByUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CancellationsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('cancelDate: $cancelDate, ')
          ..write('reason: $reason, ')
          ..write('cancelledByUserId: $cancelledByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _teacherIdMeta = const VerificationMeta(
    'teacherId',
  );
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
    'teacher_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teachers (id)',
    ),
  );
  static const VerificationMeta _enrollmentIdMeta = const VerificationMeta(
    'enrollmentId',
  );
  @override
  late final GeneratedColumn<String> enrollmentId = GeneratedColumn<String>(
    'enrollment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES enrollments (id)',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
    'created_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceTransactionIdMeta =
      const VerificationMeta('referenceTransactionId');
  @override
  late final GeneratedColumn<String> referenceTransactionId =
      GeneratedColumn<String>(
        'reference_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rateSnapshotMeta = const VerificationMeta(
    'rateSnapshot',
  );
  @override
  late final GeneratedColumn<String> rateSnapshot = GeneratedColumn<String>(
    'rate_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceSnapshotMeta = const VerificationMeta(
    'priceSnapshot',
  );
  @override
  late final GeneratedColumn<String> priceSnapshot = GeneratedColumn<String>(
    'price_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cycleNumberMeta = const VerificationMeta(
    'cycleNumber',
  );
  @override
  late final GeneratedColumn<int> cycleNumber = GeneratedColumn<int>(
    'cycle_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    teacherId,
    enrollmentId,
    sessionId,
    type,
    amount,
    transactionDate,
    note,
    createdByUserId,
    deviceId,
    referenceTransactionId,
    rateSnapshot,
    createdAt,
    paymentMethod,
    priceSnapshot,
    cycleNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    }
    if (data.containsKey('teacher_id')) {
      context.handle(
        _teacherIdMeta,
        teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta),
      );
    }
    if (data.containsKey('enrollment_id')) {
      context.handle(
        _enrollmentIdMeta,
        enrollmentId.isAcceptableOrUnknown(
          data['enrollment_id']!,
          _enrollmentIdMeta,
        ),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('reference_transaction_id')) {
      context.handle(
        _referenceTransactionIdMeta,
        referenceTransactionId.isAcceptableOrUnknown(
          data['reference_transaction_id']!,
          _referenceTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('rate_snapshot')) {
      context.handle(
        _rateSnapshotMeta,
        rateSnapshot.isAcceptableOrUnknown(
          data['rate_snapshot']!,
          _rateSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('price_snapshot')) {
      context.handle(
        _priceSnapshotMeta,
        priceSnapshot.isAcceptableOrUnknown(
          data['price_snapshot']!,
          _priceSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('cycle_number')) {
      context.handle(
        _cycleNumberMeta,
        cycleNumber.isAcceptableOrUnknown(
          data['cycle_number']!,
          _cycleNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      ),
      teacherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_id'],
      ),
      enrollmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrollment_id'],
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      referenceTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_transaction_id'],
      ),
      rateSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rate_snapshot'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      priceSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_snapshot'],
      ),
      cycleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_number'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String? studentId;
  final String? teacherId;
  final String? enrollmentId;
  final String? sessionId;
  final String type;
  final double amount;
  final DateTime transactionDate;
  final String? note;
  final String? createdByUserId;
  final String deviceId;
  final String? referenceTransactionId;
  final String? rateSnapshot;
  final DateTime createdAt;
  final String? paymentMethod;
  final String? priceSnapshot;
  final int? cycleNumber;
  const Transaction({
    required this.id,
    this.studentId,
    this.teacherId,
    this.enrollmentId,
    this.sessionId,
    required this.type,
    required this.amount,
    required this.transactionDate,
    this.note,
    this.createdByUserId,
    required this.deviceId,
    this.referenceTransactionId,
    this.rateSnapshot,
    required this.createdAt,
    this.paymentMethod,
    this.priceSnapshot,
    this.cycleNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || studentId != null) {
      map['student_id'] = Variable<String>(studentId);
    }
    if (!nullToAbsent || teacherId != null) {
      map['teacher_id'] = Variable<String>(teacherId);
    }
    if (!nullToAbsent || enrollmentId != null) {
      map['enrollment_id'] = Variable<String>(enrollmentId);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || createdByUserId != null) {
      map['created_by_user_id'] = Variable<String>(createdByUserId);
    }
    map['device_id'] = Variable<String>(deviceId);
    if (!nullToAbsent || referenceTransactionId != null) {
      map['reference_transaction_id'] = Variable<String>(
        referenceTransactionId,
      );
    }
    if (!nullToAbsent || rateSnapshot != null) {
      map['rate_snapshot'] = Variable<String>(rateSnapshot);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || priceSnapshot != null) {
      map['price_snapshot'] = Variable<String>(priceSnapshot);
    }
    if (!nullToAbsent || cycleNumber != null) {
      map['cycle_number'] = Variable<int>(cycleNumber);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      studentId: studentId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentId),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      enrollmentId: enrollmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(enrollmentId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      type: Value(type),
      amount: Value(amount),
      transactionDate: Value(transactionDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdByUserId: createdByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByUserId),
      deviceId: Value(deviceId),
      referenceTransactionId: referenceTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceTransactionId),
      rateSnapshot: rateSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(rateSnapshot),
      createdAt: Value(createdAt),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      priceSnapshot: priceSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(priceSnapshot),
      cycleNumber: cycleNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleNumber),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String?>(json['studentId']),
      teacherId: serializer.fromJson<String?>(json['teacherId']),
      enrollmentId: serializer.fromJson<String?>(json['enrollmentId']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      note: serializer.fromJson<String?>(json['note']),
      createdByUserId: serializer.fromJson<String?>(json['createdByUserId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      referenceTransactionId: serializer.fromJson<String?>(
        json['referenceTransactionId'],
      ),
      rateSnapshot: serializer.fromJson<String?>(json['rateSnapshot']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      priceSnapshot: serializer.fromJson<String?>(json['priceSnapshot']),
      cycleNumber: serializer.fromJson<int?>(json['cycleNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String?>(studentId),
      'teacherId': serializer.toJson<String?>(teacherId),
      'enrollmentId': serializer.toJson<String?>(enrollmentId),
      'sessionId': serializer.toJson<String?>(sessionId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'note': serializer.toJson<String?>(note),
      'createdByUserId': serializer.toJson<String?>(createdByUserId),
      'deviceId': serializer.toJson<String>(deviceId),
      'referenceTransactionId': serializer.toJson<String?>(
        referenceTransactionId,
      ),
      'rateSnapshot': serializer.toJson<String?>(rateSnapshot),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'priceSnapshot': serializer.toJson<String?>(priceSnapshot),
      'cycleNumber': serializer.toJson<int?>(cycleNumber),
    };
  }

  Transaction copyWith({
    String? id,
    Value<String?> studentId = const Value.absent(),
    Value<String?> teacherId = const Value.absent(),
    Value<String?> enrollmentId = const Value.absent(),
    Value<String?> sessionId = const Value.absent(),
    String? type,
    double? amount,
    DateTime? transactionDate,
    Value<String?> note = const Value.absent(),
    Value<String?> createdByUserId = const Value.absent(),
    String? deviceId,
    Value<String?> referenceTransactionId = const Value.absent(),
    Value<String?> rateSnapshot = const Value.absent(),
    DateTime? createdAt,
    Value<String?> paymentMethod = const Value.absent(),
    Value<String?> priceSnapshot = const Value.absent(),
    Value<int?> cycleNumber = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    studentId: studentId.present ? studentId.value : this.studentId,
    teacherId: teacherId.present ? teacherId.value : this.teacherId,
    enrollmentId: enrollmentId.present ? enrollmentId.value : this.enrollmentId,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    transactionDate: transactionDate ?? this.transactionDate,
    note: note.present ? note.value : this.note,
    createdByUserId: createdByUserId.present
        ? createdByUserId.value
        : this.createdByUserId,
    deviceId: deviceId ?? this.deviceId,
    referenceTransactionId: referenceTransactionId.present
        ? referenceTransactionId.value
        : this.referenceTransactionId,
    rateSnapshot: rateSnapshot.present ? rateSnapshot.value : this.rateSnapshot,
    createdAt: createdAt ?? this.createdAt,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    priceSnapshot: priceSnapshot.present
        ? priceSnapshot.value
        : this.priceSnapshot,
    cycleNumber: cycleNumber.present ? cycleNumber.value : this.cycleNumber,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      enrollmentId: data.enrollmentId.present
          ? data.enrollmentId.value
          : this.enrollmentId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      note: data.note.present ? data.note.value : this.note,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      referenceTransactionId: data.referenceTransactionId.present
          ? data.referenceTransactionId.value
          : this.referenceTransactionId,
      rateSnapshot: data.rateSnapshot.present
          ? data.rateSnapshot.value
          : this.rateSnapshot,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      priceSnapshot: data.priceSnapshot.present
          ? data.priceSnapshot.value
          : this.priceSnapshot,
      cycleNumber: data.cycleNumber.present
          ? data.cycleNumber.value
          : this.cycleNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('teacherId: $teacherId, ')
          ..write('enrollmentId: $enrollmentId, ')
          ..write('sessionId: $sessionId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('note: $note, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('deviceId: $deviceId, ')
          ..write('referenceTransactionId: $referenceTransactionId, ')
          ..write('rateSnapshot: $rateSnapshot, ')
          ..write('createdAt: $createdAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('priceSnapshot: $priceSnapshot, ')
          ..write('cycleNumber: $cycleNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    teacherId,
    enrollmentId,
    sessionId,
    type,
    amount,
    transactionDate,
    note,
    createdByUserId,
    deviceId,
    referenceTransactionId,
    rateSnapshot,
    createdAt,
    paymentMethod,
    priceSnapshot,
    cycleNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.teacherId == this.teacherId &&
          other.enrollmentId == this.enrollmentId &&
          other.sessionId == this.sessionId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.transactionDate == this.transactionDate &&
          other.note == this.note &&
          other.createdByUserId == this.createdByUserId &&
          other.deviceId == this.deviceId &&
          other.referenceTransactionId == this.referenceTransactionId &&
          other.rateSnapshot == this.rateSnapshot &&
          other.createdAt == this.createdAt &&
          other.paymentMethod == this.paymentMethod &&
          other.priceSnapshot == this.priceSnapshot &&
          other.cycleNumber == this.cycleNumber);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String?> studentId;
  final Value<String?> teacherId;
  final Value<String?> enrollmentId;
  final Value<String?> sessionId;
  final Value<String> type;
  final Value<double> amount;
  final Value<DateTime> transactionDate;
  final Value<String?> note;
  final Value<String?> createdByUserId;
  final Value<String> deviceId;
  final Value<String?> referenceTransactionId;
  final Value<String?> rateSnapshot;
  final Value<DateTime> createdAt;
  final Value<String?> paymentMethod;
  final Value<String?> priceSnapshot;
  final Value<int?> cycleNumber;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.enrollmentId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.referenceTransactionId = const Value.absent(),
    this.rateSnapshot = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.priceSnapshot = const Value.absent(),
    this.cycleNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    this.studentId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.enrollmentId = const Value.absent(),
    this.sessionId = const Value.absent(),
    required String type,
    required double amount,
    required DateTime transactionDate,
    this.note = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    required String deviceId,
    this.referenceTransactionId = const Value.absent(),
    this.rateSnapshot = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.priceSnapshot = const Value.absent(),
    this.cycleNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       amount = Value(amount),
       transactionDate = Value(transactionDate),
       deviceId = Value(deviceId);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? teacherId,
    Expression<String>? enrollmentId,
    Expression<String>? sessionId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<DateTime>? transactionDate,
    Expression<String>? note,
    Expression<String>? createdByUserId,
    Expression<String>? deviceId,
    Expression<String>? referenceTransactionId,
    Expression<String>? rateSnapshot,
    Expression<DateTime>? createdAt,
    Expression<String>? paymentMethod,
    Expression<String>? priceSnapshot,
    Expression<int>? cycleNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (enrollmentId != null) 'enrollment_id': enrollmentId,
      if (sessionId != null) 'session_id': sessionId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (note != null) 'note': note,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (deviceId != null) 'device_id': deviceId,
      if (referenceTransactionId != null)
        'reference_transaction_id': referenceTransactionId,
      if (rateSnapshot != null) 'rate_snapshot': rateSnapshot,
      if (createdAt != null) 'created_at': createdAt,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (priceSnapshot != null) 'price_snapshot': priceSnapshot,
      if (cycleNumber != null) 'cycle_number': cycleNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? studentId,
    Value<String?>? teacherId,
    Value<String?>? enrollmentId,
    Value<String?>? sessionId,
    Value<String>? type,
    Value<double>? amount,
    Value<DateTime>? transactionDate,
    Value<String?>? note,
    Value<String?>? createdByUserId,
    Value<String>? deviceId,
    Value<String?>? referenceTransactionId,
    Value<String?>? rateSnapshot,
    Value<DateTime>? createdAt,
    Value<String?>? paymentMethod,
    Value<String?>? priceSnapshot,
    Value<int?>? cycleNumber,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      enrollmentId: enrollmentId ?? this.enrollmentId,
      sessionId: sessionId ?? this.sessionId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      note: note ?? this.note,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      deviceId: deviceId ?? this.deviceId,
      referenceTransactionId:
          referenceTransactionId ?? this.referenceTransactionId,
      rateSnapshot: rateSnapshot ?? this.rateSnapshot,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      priceSnapshot: priceSnapshot ?? this.priceSnapshot,
      cycleNumber: cycleNumber ?? this.cycleNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (enrollmentId.present) {
      map['enrollment_id'] = Variable<String>(enrollmentId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (referenceTransactionId.present) {
      map['reference_transaction_id'] = Variable<String>(
        referenceTransactionId.value,
      );
    }
    if (rateSnapshot.present) {
      map['rate_snapshot'] = Variable<String>(rateSnapshot.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (priceSnapshot.present) {
      map['price_snapshot'] = Variable<String>(priceSnapshot.value);
    }
    if (cycleNumber.present) {
      map['cycle_number'] = Variable<int>(cycleNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('teacherId: $teacherId, ')
          ..write('enrollmentId: $enrollmentId, ')
          ..write('sessionId: $sessionId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('note: $note, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('deviceId: $deviceId, ')
          ..write('referenceTransactionId: $referenceTransactionId, ')
          ..write('rateSnapshot: $rateSnapshot, ')
          ..write('createdAt: $createdAt, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('priceSnapshot: $priceSnapshot, ')
          ..write('cycleNumber: $cycleNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTable extends Attendance
    with TableInfo<$AttendanceTable, AttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _teacherIdMeta = const VerificationMeta(
    'teacherId',
  );
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
    'teacher_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teachers (id)',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id)',
    ),
  );
  static const VerificationMeta _attendanceDateMeta = const VerificationMeta(
    'attendanceDate',
  );
  @override
  late final GeneratedColumn<DateTime> attendanceDate =
      GeneratedColumn<DateTime>(
        'attendance_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _checkInTimeMeta = const VerificationMeta(
    'checkInTime',
  );
  @override
  late final GeneratedColumn<DateTime> checkInTime = GeneratedColumn<DateTime>(
    'check_in_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _personTypeMeta = const VerificationMeta(
    'personType',
  );
  @override
  late final GeneratedColumn<String> personType = GeneratedColumn<String>(
    'person_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInMethodMeta = const VerificationMeta(
    'checkInMethod',
  );
  @override
  late final GeneratedColumn<String> checkInMethod = GeneratedColumn<String>(
    'check_in_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('barcode'),
  );
  static const VerificationMeta _isManualEntryMeta = const VerificationMeta(
    'isManualEntry',
  );
  @override
  late final GeneratedColumn<bool> isManualEntry = GeneratedColumn<bool>(
    'is_manual_entry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual_entry" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkedInByUserIdMeta = const VerificationMeta(
    'checkedInByUserId',
  );
  @override
  late final GeneratedColumn<String> checkedInByUserId =
      GeneratedColumn<String>(
        'checked_in_by_user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    teacherId,
    sessionId,
    attendanceDate,
    checkInTime,
    personType,
    checkInMethod,
    isManualEntry,
    checkedInByUserId,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    }
    if (data.containsKey('teacher_id')) {
      context.handle(
        _teacherIdMeta,
        teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('attendance_date')) {
      context.handle(
        _attendanceDateMeta,
        attendanceDate.isAcceptableOrUnknown(
          data['attendance_date']!,
          _attendanceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attendanceDateMeta);
    }
    if (data.containsKey('check_in_time')) {
      context.handle(
        _checkInTimeMeta,
        checkInTime.isAcceptableOrUnknown(
          data['check_in_time']!,
          _checkInTimeMeta,
        ),
      );
    }
    if (data.containsKey('person_type')) {
      context.handle(
        _personTypeMeta,
        personType.isAcceptableOrUnknown(data['person_type']!, _personTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_personTypeMeta);
    }
    if (data.containsKey('check_in_method')) {
      context.handle(
        _checkInMethodMeta,
        checkInMethod.isAcceptableOrUnknown(
          data['check_in_method']!,
          _checkInMethodMeta,
        ),
      );
    }
    if (data.containsKey('is_manual_entry')) {
      context.handle(
        _isManualEntryMeta,
        isManualEntry.isAcceptableOrUnknown(
          data['is_manual_entry']!,
          _isManualEntryMeta,
        ),
      );
    }
    if (data.containsKey('checked_in_by_user_id')) {
      context.handle(
        _checkedInByUserIdMeta,
        checkedInByUserId.isAcceptableOrUnknown(
          data['checked_in_by_user_id']!,
          _checkedInByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      ),
      teacherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_id'],
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      attendanceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}attendance_date'],
      )!,
      checkInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_in_time'],
      )!,
      personType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person_type'],
      )!,
      checkInMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_method'],
      )!,
      isManualEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manual_entry'],
      )!,
      checkedInByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checked_in_by_user_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $AttendanceTable createAlias(String alias) {
    return $AttendanceTable(attachedDatabase, alias);
  }
}

class AttendanceData extends DataClass implements Insertable<AttendanceData> {
  final String id;
  final String? studentId;
  final String? teacherId;
  final String sessionId;
  final DateTime attendanceDate;
  final DateTime checkInTime;
  final String personType;
  final String checkInMethod;
  final bool isManualEntry;
  final String? checkedInByUserId;
  final DateTime createdAt;
  final String deviceId;
  const AttendanceData({
    required this.id,
    this.studentId,
    this.teacherId,
    required this.sessionId,
    required this.attendanceDate,
    required this.checkInTime,
    required this.personType,
    required this.checkInMethod,
    required this.isManualEntry,
    this.checkedInByUserId,
    required this.createdAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || studentId != null) {
      map['student_id'] = Variable<String>(studentId);
    }
    if (!nullToAbsent || teacherId != null) {
      map['teacher_id'] = Variable<String>(teacherId);
    }
    map['session_id'] = Variable<String>(sessionId);
    map['attendance_date'] = Variable<DateTime>(attendanceDate);
    map['check_in_time'] = Variable<DateTime>(checkInTime);
    map['person_type'] = Variable<String>(personType);
    map['check_in_method'] = Variable<String>(checkInMethod);
    map['is_manual_entry'] = Variable<bool>(isManualEntry);
    if (!nullToAbsent || checkedInByUserId != null) {
      map['checked_in_by_user_id'] = Variable<String>(checkedInByUserId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  AttendanceCompanion toCompanion(bool nullToAbsent) {
    return AttendanceCompanion(
      id: Value(id),
      studentId: studentId == null && nullToAbsent
          ? const Value.absent()
          : Value(studentId),
      teacherId: teacherId == null && nullToAbsent
          ? const Value.absent()
          : Value(teacherId),
      sessionId: Value(sessionId),
      attendanceDate: Value(attendanceDate),
      checkInTime: Value(checkInTime),
      personType: Value(personType),
      checkInMethod: Value(checkInMethod),
      isManualEntry: Value(isManualEntry),
      checkedInByUserId: checkedInByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedInByUserId),
      createdAt: Value(createdAt),
      deviceId: Value(deviceId),
    );
  }

  factory AttendanceData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceData(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String?>(json['studentId']),
      teacherId: serializer.fromJson<String?>(json['teacherId']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      attendanceDate: serializer.fromJson<DateTime>(json['attendanceDate']),
      checkInTime: serializer.fromJson<DateTime>(json['checkInTime']),
      personType: serializer.fromJson<String>(json['personType']),
      checkInMethod: serializer.fromJson<String>(json['checkInMethod']),
      isManualEntry: serializer.fromJson<bool>(json['isManualEntry']),
      checkedInByUserId: serializer.fromJson<String?>(
        json['checkedInByUserId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String?>(studentId),
      'teacherId': serializer.toJson<String?>(teacherId),
      'sessionId': serializer.toJson<String>(sessionId),
      'attendanceDate': serializer.toJson<DateTime>(attendanceDate),
      'checkInTime': serializer.toJson<DateTime>(checkInTime),
      'personType': serializer.toJson<String>(personType),
      'checkInMethod': serializer.toJson<String>(checkInMethod),
      'isManualEntry': serializer.toJson<bool>(isManualEntry),
      'checkedInByUserId': serializer.toJson<String?>(checkedInByUserId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  AttendanceData copyWith({
    String? id,
    Value<String?> studentId = const Value.absent(),
    Value<String?> teacherId = const Value.absent(),
    String? sessionId,
    DateTime? attendanceDate,
    DateTime? checkInTime,
    String? personType,
    String? checkInMethod,
    bool? isManualEntry,
    Value<String?> checkedInByUserId = const Value.absent(),
    DateTime? createdAt,
    String? deviceId,
  }) => AttendanceData(
    id: id ?? this.id,
    studentId: studentId.present ? studentId.value : this.studentId,
    teacherId: teacherId.present ? teacherId.value : this.teacherId,
    sessionId: sessionId ?? this.sessionId,
    attendanceDate: attendanceDate ?? this.attendanceDate,
    checkInTime: checkInTime ?? this.checkInTime,
    personType: personType ?? this.personType,
    checkInMethod: checkInMethod ?? this.checkInMethod,
    isManualEntry: isManualEntry ?? this.isManualEntry,
    checkedInByUserId: checkedInByUserId.present
        ? checkedInByUserId.value
        : this.checkedInByUserId,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId ?? this.deviceId,
  );
  AttendanceData copyWithCompanion(AttendanceCompanion data) {
    return AttendanceData(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      attendanceDate: data.attendanceDate.present
          ? data.attendanceDate.value
          : this.attendanceDate,
      checkInTime: data.checkInTime.present
          ? data.checkInTime.value
          : this.checkInTime,
      personType: data.personType.present
          ? data.personType.value
          : this.personType,
      checkInMethod: data.checkInMethod.present
          ? data.checkInMethod.value
          : this.checkInMethod,
      isManualEntry: data.isManualEntry.present
          ? data.isManualEntry.value
          : this.isManualEntry,
      checkedInByUserId: data.checkedInByUserId.present
          ? data.checkedInByUserId.value
          : this.checkedInByUserId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceData(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('teacherId: $teacherId, ')
          ..write('sessionId: $sessionId, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('personType: $personType, ')
          ..write('checkInMethod: $checkInMethod, ')
          ..write('isManualEntry: $isManualEntry, ')
          ..write('checkedInByUserId: $checkedInByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    teacherId,
    sessionId,
    attendanceDate,
    checkInTime,
    personType,
    checkInMethod,
    isManualEntry,
    checkedInByUserId,
    createdAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceData &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.teacherId == this.teacherId &&
          other.sessionId == this.sessionId &&
          other.attendanceDate == this.attendanceDate &&
          other.checkInTime == this.checkInTime &&
          other.personType == this.personType &&
          other.checkInMethod == this.checkInMethod &&
          other.isManualEntry == this.isManualEntry &&
          other.checkedInByUserId == this.checkedInByUserId &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class AttendanceCompanion extends UpdateCompanion<AttendanceData> {
  final Value<String> id;
  final Value<String?> studentId;
  final Value<String?> teacherId;
  final Value<String> sessionId;
  final Value<DateTime> attendanceDate;
  final Value<DateTime> checkInTime;
  final Value<String> personType;
  final Value<String> checkInMethod;
  final Value<bool> isManualEntry;
  final Value<String?> checkedInByUserId;
  final Value<DateTime> createdAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const AttendanceCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.attendanceDate = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.personType = const Value.absent(),
    this.checkInMethod = const Value.absent(),
    this.isManualEntry = const Value.absent(),
    this.checkedInByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceCompanion.insert({
    required String id,
    this.studentId = const Value.absent(),
    this.teacherId = const Value.absent(),
    required String sessionId,
    required DateTime attendanceDate,
    this.checkInTime = const Value.absent(),
    required String personType,
    this.checkInMethod = const Value.absent(),
    this.isManualEntry = const Value.absent(),
    this.checkedInByUserId = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       attendanceDate = Value(attendanceDate),
       personType = Value(personType),
       deviceId = Value(deviceId);
  static Insertable<AttendanceData> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? teacherId,
    Expression<String>? sessionId,
    Expression<DateTime>? attendanceDate,
    Expression<DateTime>? checkInTime,
    Expression<String>? personType,
    Expression<String>? checkInMethod,
    Expression<bool>? isManualEntry,
    Expression<String>? checkedInByUserId,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (teacherId != null) 'teacher_id': teacherId,
      if (sessionId != null) 'session_id': sessionId,
      if (attendanceDate != null) 'attendance_date': attendanceDate,
      if (checkInTime != null) 'check_in_time': checkInTime,
      if (personType != null) 'person_type': personType,
      if (checkInMethod != null) 'check_in_method': checkInMethod,
      if (isManualEntry != null) 'is_manual_entry': isManualEntry,
      if (checkedInByUserId != null) 'checked_in_by_user_id': checkedInByUserId,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceCompanion copyWith({
    Value<String>? id,
    Value<String?>? studentId,
    Value<String?>? teacherId,
    Value<String>? sessionId,
    Value<DateTime>? attendanceDate,
    Value<DateTime>? checkInTime,
    Value<String>? personType,
    Value<String>? checkInMethod,
    Value<bool>? isManualEntry,
    Value<String?>? checkedInByUserId,
    Value<DateTime>? createdAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return AttendanceCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      sessionId: sessionId ?? this.sessionId,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      checkInTime: checkInTime ?? this.checkInTime,
      personType: personType ?? this.personType,
      checkInMethod: checkInMethod ?? this.checkInMethod,
      isManualEntry: isManualEntry ?? this.isManualEntry,
      checkedInByUserId: checkedInByUserId ?? this.checkedInByUserId,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (attendanceDate.present) {
      map['attendance_date'] = Variable<DateTime>(attendanceDate.value);
    }
    if (checkInTime.present) {
      map['check_in_time'] = Variable<DateTime>(checkInTime.value);
    }
    if (personType.present) {
      map['person_type'] = Variable<String>(personType.value);
    }
    if (checkInMethod.present) {
      map['check_in_method'] = Variable<String>(checkInMethod.value);
    }
    if (isManualEntry.present) {
      map['is_manual_entry'] = Variable<bool>(isManualEntry.value);
    }
    if (checkedInByUserId.present) {
      map['checked_in_by_user_id'] = Variable<String>(checkedInByUserId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('teacherId: $teacherId, ')
          ..write('sessionId: $sessionId, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('personType: $personType, ')
          ..write('checkInMethod: $checkInMethod, ')
          ..write('isManualEntry: $isManualEntry, ')
          ..write('checkedInByUserId: $checkedInByUserId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('teacher'),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    passwordHash,
    role,
    firstName,
    lastName,
    isActive,
    createdAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String username;
  final String passwordHash;
  final String role;
  final String firstName;
  final String lastName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String deviceId;
  const User({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role'] = Variable<String>(role);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      role: Value(role),
      firstName: Value(firstName),
      lastName: Value(lastName),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'role': serializer.toJson<String>(role),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? passwordHash,
    String? role,
    String? firstName,
    String? lastName,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    role: role ?? this.role,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    passwordHash,
    role,
    firstName,
    lastName,
    isActive,
    createdAt,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String username,
    required String passwordHash,
    this.role = const Value.absent(),
    required String firstName,
    required String lastName,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       username = Value(username),
       passwordHash = Value(passwordHash),
       firstName = Value(firstName),
       lastName = Value(lastName),
       deviceId = Value(deviceId);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<String>? role,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    action,
    entityType,
    entityId,
    details,
    timestamp,
    deviceId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final String id;
  final String userId;
  final String action;
  final String entityType;
  final String? entityId;
  final String? details;
  final DateTime timestamp;
  final String deviceId;
  final DateTime createdAt;
  const AuditLogData({
    required this.id,
    required this.userId,
    required this.action,
    required this.entityType,
    this.entityId,
    this.details,
    required this.timestamp,
    required this.deviceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      userId: Value(userId),
      action: Value(action),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      timestamp: Value(timestamp),
      deviceId: Value(deviceId),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      details: serializer.fromJson<String?>(json['details']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'details': serializer.toJson<String?>(details),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLogData copyWith({
    String? id,
    String? userId,
    String? action,
    String? entityType,
    Value<String?> entityId = const Value.absent(),
    Value<String?> details = const Value.absent(),
    DateTime? timestamp,
    String? deviceId,
    DateTime? createdAt,
  }) => AuditLogData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    action: action ?? this.action,
    entityType: entityType ?? this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    details: details.present ? details.value : this.details,
    timestamp: timestamp ?? this.timestamp,
    deviceId: deviceId ?? this.deviceId,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      details: data.details.present ? data.details.value : this.details,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('timestamp: $timestamp, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    action,
    entityType,
    entityId,
    details,
    timestamp,
    deviceId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.details == this.details &&
          other.timestamp == this.timestamp &&
          other.deviceId == this.deviceId &&
          other.createdAt == this.createdAt);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> action;
  final Value<String> entityType;
  final Value<String?> entityId;
  final Value<String?> details;
  final Value<DateTime> timestamp;
  final Value<String> deviceId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogCompanion.insert({
    required String id,
    required String userId,
    required String action,
    required String entityType,
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.timestamp = const Value.absent(),
    required String deviceId,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       action = Value(action),
       entityType = Value(entityType),
       deviceId = Value(deviceId);
  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? details,
    Expression<DateTime>? timestamp,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (details != null) 'details': details,
      if (timestamp != null) 'timestamp': timestamp,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? action,
    Value<String>? entityType,
    Value<String?>? entityId,
    Value<String?>? details,
    Value<DateTime>? timestamp,
    Value<String>? deviceId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('timestamp: $timestamp, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudentCardsTable extends StudentCards
    with TableInfo<$StudentCardsTable, StudentCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudentCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _secureTokenMeta = const VerificationMeta(
    'secureToken',
  );
  @override
  late final GeneratedColumn<String> secureToken = GeneratedColumn<String>(
    'secure_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _barcodeContentMeta = const VerificationMeta(
    'barcodeContent',
  );
  @override
  late final GeneratedColumn<String> barcodeContent = GeneratedColumn<String>(
    'barcode_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issuedDateMeta = const VerificationMeta(
    'issuedDate',
  );
  @override
  late final GeneratedColumn<DateTime> issuedDate = GeneratedColumn<DateTime>(
    'issued_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _revokedDateMeta = const VerificationMeta(
    'revokedDate',
  );
  @override
  late final GeneratedColumn<DateTime> revokedDate = GeneratedColumn<DateTime>(
    'revoked_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    studentId,
    secureToken,
    barcodeContent,
    issuedDate,
    isActive,
    revokedDate,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'student_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudentCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('secure_token')) {
      context.handle(
        _secureTokenMeta,
        secureToken.isAcceptableOrUnknown(
          data['secure_token']!,
          _secureTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_secureTokenMeta);
    }
    if (data.containsKey('barcode_content')) {
      context.handle(
        _barcodeContentMeta,
        barcodeContent.isAcceptableOrUnknown(
          data['barcode_content']!,
          _barcodeContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_barcodeContentMeta);
    }
    if (data.containsKey('issued_date')) {
      context.handle(
        _issuedDateMeta,
        issuedDate.isAcceptableOrUnknown(data['issued_date']!, _issuedDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('revoked_date')) {
      context.handle(
        _revokedDateMeta,
        revokedDate.isAcceptableOrUnknown(
          data['revoked_date']!,
          _revokedDateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudentCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudentCard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      secureToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secure_token'],
      )!,
      barcodeContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode_content'],
      )!,
      issuedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issued_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      revokedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revoked_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $StudentCardsTable createAlias(String alias) {
    return $StudentCardsTable(attachedDatabase, alias);
  }
}

class StudentCard extends DataClass implements Insertable<StudentCard> {
  final String id;
  final String studentId;
  final String secureToken;
  final String barcodeContent;
  final DateTime issuedDate;
  final bool isActive;
  final DateTime? revokedDate;
  final DateTime createdAt;
  final String deviceId;
  const StudentCard({
    required this.id,
    required this.studentId,
    required this.secureToken,
    required this.barcodeContent,
    required this.issuedDate,
    required this.isActive,
    this.revokedDate,
    required this.createdAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['student_id'] = Variable<String>(studentId);
    map['secure_token'] = Variable<String>(secureToken);
    map['barcode_content'] = Variable<String>(barcodeContent);
    map['issued_date'] = Variable<DateTime>(issuedDate);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || revokedDate != null) {
      map['revoked_date'] = Variable<DateTime>(revokedDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  StudentCardsCompanion toCompanion(bool nullToAbsent) {
    return StudentCardsCompanion(
      id: Value(id),
      studentId: Value(studentId),
      secureToken: Value(secureToken),
      barcodeContent: Value(barcodeContent),
      issuedDate: Value(issuedDate),
      isActive: Value(isActive),
      revokedDate: revokedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedDate),
      createdAt: Value(createdAt),
      deviceId: Value(deviceId),
    );
  }

  factory StudentCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudentCard(
      id: serializer.fromJson<String>(json['id']),
      studentId: serializer.fromJson<String>(json['studentId']),
      secureToken: serializer.fromJson<String>(json['secureToken']),
      barcodeContent: serializer.fromJson<String>(json['barcodeContent']),
      issuedDate: serializer.fromJson<DateTime>(json['issuedDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      revokedDate: serializer.fromJson<DateTime?>(json['revokedDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'studentId': serializer.toJson<String>(studentId),
      'secureToken': serializer.toJson<String>(secureToken),
      'barcodeContent': serializer.toJson<String>(barcodeContent),
      'issuedDate': serializer.toJson<DateTime>(issuedDate),
      'isActive': serializer.toJson<bool>(isActive),
      'revokedDate': serializer.toJson<DateTime?>(revokedDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  StudentCard copyWith({
    String? id,
    String? studentId,
    String? secureToken,
    String? barcodeContent,
    DateTime? issuedDate,
    bool? isActive,
    Value<DateTime?> revokedDate = const Value.absent(),
    DateTime? createdAt,
    String? deviceId,
  }) => StudentCard(
    id: id ?? this.id,
    studentId: studentId ?? this.studentId,
    secureToken: secureToken ?? this.secureToken,
    barcodeContent: barcodeContent ?? this.barcodeContent,
    issuedDate: issuedDate ?? this.issuedDate,
    isActive: isActive ?? this.isActive,
    revokedDate: revokedDate.present ? revokedDate.value : this.revokedDate,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId ?? this.deviceId,
  );
  StudentCard copyWithCompanion(StudentCardsCompanion data) {
    return StudentCard(
      id: data.id.present ? data.id.value : this.id,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      secureToken: data.secureToken.present
          ? data.secureToken.value
          : this.secureToken,
      barcodeContent: data.barcodeContent.present
          ? data.barcodeContent.value
          : this.barcodeContent,
      issuedDate: data.issuedDate.present
          ? data.issuedDate.value
          : this.issuedDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      revokedDate: data.revokedDate.present
          ? data.revokedDate.value
          : this.revokedDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudentCard(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('secureToken: $secureToken, ')
          ..write('barcodeContent: $barcodeContent, ')
          ..write('issuedDate: $issuedDate, ')
          ..write('isActive: $isActive, ')
          ..write('revokedDate: $revokedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    studentId,
    secureToken,
    barcodeContent,
    issuedDate,
    isActive,
    revokedDate,
    createdAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentCard &&
          other.id == this.id &&
          other.studentId == this.studentId &&
          other.secureToken == this.secureToken &&
          other.barcodeContent == this.barcodeContent &&
          other.issuedDate == this.issuedDate &&
          other.isActive == this.isActive &&
          other.revokedDate == this.revokedDate &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class StudentCardsCompanion extends UpdateCompanion<StudentCard> {
  final Value<String> id;
  final Value<String> studentId;
  final Value<String> secureToken;
  final Value<String> barcodeContent;
  final Value<DateTime> issuedDate;
  final Value<bool> isActive;
  final Value<DateTime?> revokedDate;
  final Value<DateTime> createdAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const StudentCardsCompanion({
    this.id = const Value.absent(),
    this.studentId = const Value.absent(),
    this.secureToken = const Value.absent(),
    this.barcodeContent = const Value.absent(),
    this.issuedDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.revokedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudentCardsCompanion.insert({
    required String id,
    required String studentId,
    required String secureToken,
    required String barcodeContent,
    this.issuedDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.revokedDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       studentId = Value(studentId),
       secureToken = Value(secureToken),
       barcodeContent = Value(barcodeContent),
       deviceId = Value(deviceId);
  static Insertable<StudentCard> custom({
    Expression<String>? id,
    Expression<String>? studentId,
    Expression<String>? secureToken,
    Expression<String>? barcodeContent,
    Expression<DateTime>? issuedDate,
    Expression<bool>? isActive,
    Expression<DateTime>? revokedDate,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (studentId != null) 'student_id': studentId,
      if (secureToken != null) 'secure_token': secureToken,
      if (barcodeContent != null) 'barcode_content': barcodeContent,
      if (issuedDate != null) 'issued_date': issuedDate,
      if (isActive != null) 'is_active': isActive,
      if (revokedDate != null) 'revoked_date': revokedDate,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudentCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? studentId,
    Value<String>? secureToken,
    Value<String>? barcodeContent,
    Value<DateTime>? issuedDate,
    Value<bool>? isActive,
    Value<DateTime?>? revokedDate,
    Value<DateTime>? createdAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return StudentCardsCompanion(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      secureToken: secureToken ?? this.secureToken,
      barcodeContent: barcodeContent ?? this.barcodeContent,
      issuedDate: issuedDate ?? this.issuedDate,
      isActive: isActive ?? this.isActive,
      revokedDate: revokedDate ?? this.revokedDate,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (secureToken.present) {
      map['secure_token'] = Variable<String>(secureToken.value);
    }
    if (barcodeContent.present) {
      map['barcode_content'] = Variable<String>(barcodeContent.value);
    }
    if (issuedDate.present) {
      map['issued_date'] = Variable<DateTime>(issuedDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (revokedDate.present) {
      map['revoked_date'] = Variable<DateTime>(revokedDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudentCardsCompanion(')
          ..write('id: $id, ')
          ..write('studentId: $studentId, ')
          ..write('secureToken: $secureToken, ')
          ..write('barcodeContent: $barcodeContent, ')
          ..write('issuedDate: $issuedDate, ')
          ..write('isActive: $isActive, ')
          ..write('revokedDate: $revokedDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String? value;
  const Setting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  Setting copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => Setting(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TeacherSubjectGroupsTable extends TeacherSubjectGroups
    with TableInfo<$TeacherSubjectGroupsTable, TeacherSubjectGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeacherSubjectGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teacherIdMeta = const VerificationMeta(
    'teacherId',
  );
  @override
  late final GeneratedColumn<String> teacherId = GeneratedColumn<String>(
    'teacher_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES teachers (id)',
    ),
  );
  static const VerificationMeta _subjectGroupIdMeta = const VerificationMeta(
    'subjectGroupId',
  );
  @override
  late final GeneratedColumn<String> subjectGroupId = GeneratedColumn<String>(
    'subject_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subject_groups (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    teacherId,
    subjectGroupId,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'teacher_subject_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<TeacherSubjectGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('teacher_id')) {
      context.handle(
        _teacherIdMeta,
        teacherId.isAcceptableOrUnknown(data['teacher_id']!, _teacherIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teacherIdMeta);
    }
    if (data.containsKey('subject_group_id')) {
      context.handle(
        _subjectGroupIdMeta,
        subjectGroupId.isAcceptableOrUnknown(
          data['subject_group_id']!,
          _subjectGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subjectGroupIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TeacherSubjectGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TeacherSubjectGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      teacherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}teacher_id'],
      )!,
      subjectGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_group_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $TeacherSubjectGroupsTable createAlias(String alias) {
    return $TeacherSubjectGroupsTable(attachedDatabase, alias);
  }
}

class TeacherSubjectGroup extends DataClass
    implements Insertable<TeacherSubjectGroup> {
  final String id;
  final String teacherId;
  final String subjectGroupId;
  final DateTime createdAt;
  final String deviceId;
  const TeacherSubjectGroup({
    required this.id,
    required this.teacherId,
    required this.subjectGroupId,
    required this.createdAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['teacher_id'] = Variable<String>(teacherId);
    map['subject_group_id'] = Variable<String>(subjectGroupId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  TeacherSubjectGroupsCompanion toCompanion(bool nullToAbsent) {
    return TeacherSubjectGroupsCompanion(
      id: Value(id),
      teacherId: Value(teacherId),
      subjectGroupId: Value(subjectGroupId),
      createdAt: Value(createdAt),
      deviceId: Value(deviceId),
    );
  }

  factory TeacherSubjectGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TeacherSubjectGroup(
      id: serializer.fromJson<String>(json['id']),
      teacherId: serializer.fromJson<String>(json['teacherId']),
      subjectGroupId: serializer.fromJson<String>(json['subjectGroupId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'teacherId': serializer.toJson<String>(teacherId),
      'subjectGroupId': serializer.toJson<String>(subjectGroupId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  TeacherSubjectGroup copyWith({
    String? id,
    String? teacherId,
    String? subjectGroupId,
    DateTime? createdAt,
    String? deviceId,
  }) => TeacherSubjectGroup(
    id: id ?? this.id,
    teacherId: teacherId ?? this.teacherId,
    subjectGroupId: subjectGroupId ?? this.subjectGroupId,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId ?? this.deviceId,
  );
  TeacherSubjectGroup copyWithCompanion(TeacherSubjectGroupsCompanion data) {
    return TeacherSubjectGroup(
      id: data.id.present ? data.id.value : this.id,
      teacherId: data.teacherId.present ? data.teacherId.value : this.teacherId,
      subjectGroupId: data.subjectGroupId.present
          ? data.subjectGroupId.value
          : this.subjectGroupId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TeacherSubjectGroup(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, teacherId, subjectGroupId, createdAt, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TeacherSubjectGroup &&
          other.id == this.id &&
          other.teacherId == this.teacherId &&
          other.subjectGroupId == this.subjectGroupId &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class TeacherSubjectGroupsCompanion
    extends UpdateCompanion<TeacherSubjectGroup> {
  final Value<String> id;
  final Value<String> teacherId;
  final Value<String> subjectGroupId;
  final Value<DateTime> createdAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const TeacherSubjectGroupsCompanion({
    this.id = const Value.absent(),
    this.teacherId = const Value.absent(),
    this.subjectGroupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TeacherSubjectGroupsCompanion.insert({
    required String id,
    required String teacherId,
    required String subjectGroupId,
    this.createdAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       teacherId = Value(teacherId),
       subjectGroupId = Value(subjectGroupId),
       deviceId = Value(deviceId);
  static Insertable<TeacherSubjectGroup> custom({
    Expression<String>? id,
    Expression<String>? teacherId,
    Expression<String>? subjectGroupId,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teacherId != null) 'teacher_id': teacherId,
      if (subjectGroupId != null) 'subject_group_id': subjectGroupId,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TeacherSubjectGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? teacherId,
    Value<String>? subjectGroupId,
    Value<DateTime>? createdAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return TeacherSubjectGroupsCompanion(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      subjectGroupId: subjectGroupId ?? this.subjectGroupId,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (teacherId.present) {
      map['teacher_id'] = Variable<String>(teacherId.value);
    }
    if (subjectGroupId.present) {
      map['subject_group_id'] = Variable<String>(subjectGroupId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeacherSubjectGroupsCompanion(')
          ..write('id: $id, ')
          ..write('teacherId: $teacherId, ')
          ..write('subjectGroupId: $subjectGroupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchoolClosuresTable extends SchoolClosures
    with TableInfo<$SchoolClosuresTable, SchoolClosure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolClosuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closureDateMeta = const VerificationMeta(
    'closureDate',
  );
  @override
  late final GeneratedColumn<DateTime> closureDate = GeneratedColumn<DateTime>(
    'closure_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    closureDate,
    reason,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'school_closures';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchoolClosure> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('closure_date')) {
      context.handle(
        _closureDateMeta,
        closureDate.isAcceptableOrUnknown(
          data['closure_date']!,
          _closureDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_closureDateMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchoolClosure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolClosure(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      closureDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closure_date'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $SchoolClosuresTable createAlias(String alias) {
    return $SchoolClosuresTable(attachedDatabase, alias);
  }
}

class SchoolClosure extends DataClass implements Insertable<SchoolClosure> {
  final String id;
  final DateTime closureDate;
  final String? reason;
  final DateTime createdAt;
  final String deviceId;
  const SchoolClosure({
    required this.id,
    required this.closureDate,
    this.reason,
    required this.createdAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['closure_date'] = Variable<DateTime>(closureDate);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  SchoolClosuresCompanion toCompanion(bool nullToAbsent) {
    return SchoolClosuresCompanion(
      id: Value(id),
      closureDate: Value(closureDate),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      createdAt: Value(createdAt),
      deviceId: Value(deviceId),
    );
  }

  factory SchoolClosure.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolClosure(
      id: serializer.fromJson<String>(json['id']),
      closureDate: serializer.fromJson<DateTime>(json['closureDate']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'closureDate': serializer.toJson<DateTime>(closureDate),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  SchoolClosure copyWith({
    String? id,
    DateTime? closureDate,
    Value<String?> reason = const Value.absent(),
    DateTime? createdAt,
    String? deviceId,
  }) => SchoolClosure(
    id: id ?? this.id,
    closureDate: closureDate ?? this.closureDate,
    reason: reason.present ? reason.value : this.reason,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId ?? this.deviceId,
  );
  SchoolClosure copyWithCompanion(SchoolClosuresCompanion data) {
    return SchoolClosure(
      id: data.id.present ? data.id.value : this.id,
      closureDate: data.closureDate.present
          ? data.closureDate.value
          : this.closureDate,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolClosure(')
          ..write('id: $id, ')
          ..write('closureDate: $closureDate, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, closureDate, reason, createdAt, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolClosure &&
          other.id == this.id &&
          other.closureDate == this.closureDate &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class SchoolClosuresCompanion extends UpdateCompanion<SchoolClosure> {
  final Value<String> id;
  final Value<DateTime> closureDate;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const SchoolClosuresCompanion({
    this.id = const Value.absent(),
    this.closureDate = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchoolClosuresCompanion.insert({
    required String id,
    required DateTime closureDate,
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       closureDate = Value(closureDate),
       deviceId = Value(deviceId);
  static Insertable<SchoolClosure> custom({
    Expression<String>? id,
    Expression<DateTime>? closureDate,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (closureDate != null) 'closure_date': closureDate,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchoolClosuresCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? closureDate,
    Value<String?>? reason,
    Value<DateTime>? createdAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return SchoolClosuresCompanion(
      id: id ?? this.id,
      closureDate: closureDate ?? this.closureDate,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (closureDate.present) {
      map['closure_date'] = Variable<DateTime>(closureDate.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolClosuresCompanion(')
          ..write('id: $id, ')
          ..write('closureDate: $closureDate, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchoolLevelsTable extends SchoolLevels
    with TableInfo<$SchoolLevelsTable, SchoolLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    deviceId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'school_levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchoolLevel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchoolLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchoolLevel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SchoolLevelsTable createAlias(String alias) {
    return $SchoolLevelsTable(attachedDatabase, alias);
  }
}

class SchoolLevel extends DataClass implements Insertable<SchoolLevel> {
  final String id;
  final String name;
  final String deviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SchoolLevel({
    required this.id,
    required this.name,
    required this.deviceId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SchoolLevelsCompanion toCompanion(bool nullToAbsent) {
    return SchoolLevelsCompanion(
      id: Value(id),
      name: Value(name),
      deviceId: Value(deviceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SchoolLevel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchoolLevel(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SchoolLevel copyWith({
    String? id,
    String? name,
    String? deviceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SchoolLevel(
    id: id ?? this.id,
    name: name ?? this.name,
    deviceId: deviceId ?? this.deviceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SchoolLevel copyWithCompanion(SchoolLevelsCompanion data) {
    return SchoolLevel(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchoolLevel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, deviceId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchoolLevel &&
          other.id == this.id &&
          other.name == this.name &&
          other.deviceId == this.deviceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SchoolLevelsCompanion extends UpdateCompanion<SchoolLevel> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> deviceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SchoolLevelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchoolLevelsCompanion.insert({
    required String id,
    required String name,
    required String deviceId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       deviceId = Value(deviceId);
  static Insertable<SchoolLevel> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? deviceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchoolLevelsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? deviceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SchoolLevelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolLevelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentAllocationsTable extends PaymentAllocations
    with TableInfo<$PaymentAllocationsTable, PaymentAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentTransactionIdMeta =
      const VerificationMeta('paymentTransactionId');
  @override
  late final GeneratedColumn<String> paymentTransactionId =
      GeneratedColumn<String>(
        'payment_transaction_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES transactions (id)',
        ),
      );
  static const VerificationMeta _chargeTransactionIdMeta =
      const VerificationMeta('chargeTransactionId');
  @override
  late final GeneratedColumn<String> chargeTransactionId =
      GeneratedColumn<String>(
        'charge_transaction_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES transactions (id)',
        ),
      );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentTransactionId,
    chargeTransactionId,
    amount,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payment_transaction_id')) {
      context.handle(
        _paymentTransactionIdMeta,
        paymentTransactionId.isAcceptableOrUnknown(
          data['payment_transaction_id']!,
          _paymentTransactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentTransactionIdMeta);
    }
    if (data.containsKey('charge_transaction_id')) {
      context.handle(
        _chargeTransactionIdMeta,
        chargeTransactionId.isAcceptableOrUnknown(
          data['charge_transaction_id']!,
          _chargeTransactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chargeTransactionIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      paymentTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_transaction_id'],
      )!,
      chargeTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}charge_transaction_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $PaymentAllocationsTable createAlias(String alias) {
    return $PaymentAllocationsTable(attachedDatabase, alias);
  }
}

class PaymentAllocation extends DataClass
    implements Insertable<PaymentAllocation> {
  final String id;
  final String paymentTransactionId;
  final String chargeTransactionId;
  final double amount;
  final DateTime createdAt;
  final String deviceId;
  const PaymentAllocation({
    required this.id,
    required this.paymentTransactionId,
    required this.chargeTransactionId,
    required this.amount,
    required this.createdAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payment_transaction_id'] = Variable<String>(paymentTransactionId);
    map['charge_transaction_id'] = Variable<String>(chargeTransactionId);
    map['amount'] = Variable<double>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  PaymentAllocationsCompanion toCompanion(bool nullToAbsent) {
    return PaymentAllocationsCompanion(
      id: Value(id),
      paymentTransactionId: Value(paymentTransactionId),
      chargeTransactionId: Value(chargeTransactionId),
      amount: Value(amount),
      createdAt: Value(createdAt),
      deviceId: Value(deviceId),
    );
  }

  factory PaymentAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentAllocation(
      id: serializer.fromJson<String>(json['id']),
      paymentTransactionId: serializer.fromJson<String>(
        json['paymentTransactionId'],
      ),
      chargeTransactionId: serializer.fromJson<String>(
        json['chargeTransactionId'],
      ),
      amount: serializer.fromJson<double>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'paymentTransactionId': serializer.toJson<String>(paymentTransactionId),
      'chargeTransactionId': serializer.toJson<String>(chargeTransactionId),
      'amount': serializer.toJson<double>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  PaymentAllocation copyWith({
    String? id,
    String? paymentTransactionId,
    String? chargeTransactionId,
    double? amount,
    DateTime? createdAt,
    String? deviceId,
  }) => PaymentAllocation(
    id: id ?? this.id,
    paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
    chargeTransactionId: chargeTransactionId ?? this.chargeTransactionId,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId ?? this.deviceId,
  );
  PaymentAllocation copyWithCompanion(PaymentAllocationsCompanion data) {
    return PaymentAllocation(
      id: data.id.present ? data.id.value : this.id,
      paymentTransactionId: data.paymentTransactionId.present
          ? data.paymentTransactionId.value
          : this.paymentTransactionId,
      chargeTransactionId: data.chargeTransactionId.present
          ? data.chargeTransactionId.value
          : this.chargeTransactionId,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocation(')
          ..write('id: $id, ')
          ..write('paymentTransactionId: $paymentTransactionId, ')
          ..write('chargeTransactionId: $chargeTransactionId, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    paymentTransactionId,
    chargeTransactionId,
    amount,
    createdAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAllocation &&
          other.id == this.id &&
          other.paymentTransactionId == this.paymentTransactionId &&
          other.chargeTransactionId == this.chargeTransactionId &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class PaymentAllocationsCompanion extends UpdateCompanion<PaymentAllocation> {
  final Value<String> id;
  final Value<String> paymentTransactionId;
  final Value<String> chargeTransactionId;
  final Value<double> amount;
  final Value<DateTime> createdAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const PaymentAllocationsCompanion({
    this.id = const Value.absent(),
    this.paymentTransactionId = const Value.absent(),
    this.chargeTransactionId = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentAllocationsCompanion.insert({
    required String id,
    required String paymentTransactionId,
    required String chargeTransactionId,
    required double amount,
    this.createdAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       paymentTransactionId = Value(paymentTransactionId),
       chargeTransactionId = Value(chargeTransactionId),
       amount = Value(amount),
       deviceId = Value(deviceId);
  static Insertable<PaymentAllocation> custom({
    Expression<String>? id,
    Expression<String>? paymentTransactionId,
    Expression<String>? chargeTransactionId,
    Expression<double>? amount,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentTransactionId != null)
        'payment_transaction_id': paymentTransactionId,
      if (chargeTransactionId != null)
        'charge_transaction_id': chargeTransactionId,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentAllocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? paymentTransactionId,
    Value<String>? chargeTransactionId,
    Value<double>? amount,
    Value<DateTime>? createdAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return PaymentAllocationsCompanion(
      id: id ?? this.id,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      chargeTransactionId: chargeTransactionId ?? this.chargeTransactionId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentTransactionId.present) {
      map['payment_transaction_id'] = Variable<String>(
        paymentTransactionId.value,
      );
    }
    if (chargeTransactionId.present) {
      map['charge_transaction_id'] = Variable<String>(
        chargeTransactionId.value,
      );
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('paymentTransactionId: $paymentTransactionId, ')
          ..write('chargeTransactionId: $chargeTransactionId, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClosedPeriodsTable extends ClosedPeriods
    with TableInfo<$ClosedPeriodsTable, ClosedPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClosedPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _closedByUserIdMeta = const VerificationMeta(
    'closedByUserId',
  );
  @override
  late final GeneratedColumn<String> closedByUserId = GeneratedColumn<String>(
    'closed_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    closedAt,
    closedByUserId,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'closed_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClosedPeriod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('closed_by_user_id')) {
      context.handle(
        _closedByUserIdMeta,
        closedByUserId.isAcceptableOrUnknown(
          data['closed_by_user_id']!,
          _closedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClosedPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClosedPeriod(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      )!,
      closedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closed_by_user_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $ClosedPeriodsTable createAlias(String alias) {
    return $ClosedPeriodsTable(attachedDatabase, alias);
  }
}

class ClosedPeriod extends DataClass implements Insertable<ClosedPeriod> {
  final String id;
  final int year;
  final int month;
  final DateTime closedAt;
  final String? closedByUserId;
  final String deviceId;
  const ClosedPeriod({
    required this.id,
    required this.year,
    required this.month,
    required this.closedAt,
    this.closedByUserId,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['closed_at'] = Variable<DateTime>(closedAt);
    if (!nullToAbsent || closedByUserId != null) {
      map['closed_by_user_id'] = Variable<String>(closedByUserId);
    }
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  ClosedPeriodsCompanion toCompanion(bool nullToAbsent) {
    return ClosedPeriodsCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      closedAt: Value(closedAt),
      closedByUserId: closedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(closedByUserId),
      deviceId: Value(deviceId),
    );
  }

  factory ClosedPeriod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClosedPeriod(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      closedAt: serializer.fromJson<DateTime>(json['closedAt']),
      closedByUserId: serializer.fromJson<String?>(json['closedByUserId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'closedAt': serializer.toJson<DateTime>(closedAt),
      'closedByUserId': serializer.toJson<String?>(closedByUserId),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  ClosedPeriod copyWith({
    String? id,
    int? year,
    int? month,
    DateTime? closedAt,
    Value<String?> closedByUserId = const Value.absent(),
    String? deviceId,
  }) => ClosedPeriod(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    closedAt: closedAt ?? this.closedAt,
    closedByUserId: closedByUserId.present
        ? closedByUserId.value
        : this.closedByUserId,
    deviceId: deviceId ?? this.deviceId,
  );
  ClosedPeriod copyWithCompanion(ClosedPeriodsCompanion data) {
    return ClosedPeriod(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      closedByUserId: data.closedByUserId.present
          ? data.closedByUserId.value
          : this.closedByUserId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClosedPeriod(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('closedAt: $closedAt, ')
          ..write('closedByUserId: $closedByUserId, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, year, month, closedAt, closedByUserId, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClosedPeriod &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.closedAt == this.closedAt &&
          other.closedByUserId == this.closedByUserId &&
          other.deviceId == this.deviceId);
}

class ClosedPeriodsCompanion extends UpdateCompanion<ClosedPeriod> {
  final Value<String> id;
  final Value<int> year;
  final Value<int> month;
  final Value<DateTime> closedAt;
  final Value<String?> closedByUserId;
  final Value<String> deviceId;
  final Value<int> rowid;
  const ClosedPeriodsCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.closedByUserId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClosedPeriodsCompanion.insert({
    required String id,
    required int year,
    required int month,
    this.closedAt = const Value.absent(),
    this.closedByUserId = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       year = Value(year),
       month = Value(month),
       deviceId = Value(deviceId);
  static Insertable<ClosedPeriod> custom({
    Expression<String>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<DateTime>? closedAt,
    Expression<String>? closedByUserId,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (closedAt != null) 'closed_at': closedAt,
      if (closedByUserId != null) 'closed_by_user_id': closedByUserId,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClosedPeriodsCompanion copyWith({
    Value<String>? id,
    Value<int>? year,
    Value<int>? month,
    Value<DateTime>? closedAt,
    Value<String?>? closedByUserId,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return ClosedPeriodsCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      closedAt: closedAt ?? this.closedAt,
      closedByUserId: closedByUserId ?? this.closedByUserId,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (closedByUserId.present) {
      map['closed_by_user_id'] = Variable<String>(closedByUserId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClosedPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('closedAt: $closedAt, ')
          ..write('closedByUserId: $closedByUserId, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamiliesTable extends Families with TableInfo<$FamiliesTable, Family> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamiliesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<double> discountPercent = GeneratedColumn<double>(
    'discount_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountFixedMeta = const VerificationMeta(
    'discountFixed',
  );
  @override
  late final GeneratedColumn<double> discountFixed = GeneratedColumn<double>(
    'discount_fixed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    discountPercent,
    discountFixed,
    createdAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'families';
  @override
  VerificationContext validateIntegrity(
    Insertable<Family> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('discount_fixed')) {
      context.handle(
        _discountFixedMeta,
        discountFixed.isAcceptableOrUnknown(
          data['discount_fixed']!,
          _discountFixedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Family map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Family(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percent'],
      ),
      discountFixed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_fixed'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $FamiliesTable createAlias(String alias) {
    return $FamiliesTable(attachedDatabase, alias);
  }
}

class Family extends DataClass implements Insertable<Family> {
  final String id;
  final String name;
  final double? discountPercent;
  final double? discountFixed;
  final DateTime createdAt;
  final String deviceId;
  const Family({
    required this.id,
    required this.name,
    this.discountPercent,
    this.discountFixed,
    required this.createdAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || discountPercent != null) {
      map['discount_percent'] = Variable<double>(discountPercent);
    }
    if (!nullToAbsent || discountFixed != null) {
      map['discount_fixed'] = Variable<double>(discountFixed);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  FamiliesCompanion toCompanion(bool nullToAbsent) {
    return FamiliesCompanion(
      id: Value(id),
      name: Value(name),
      discountPercent: discountPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercent),
      discountFixed: discountFixed == null && nullToAbsent
          ? const Value.absent()
          : Value(discountFixed),
      createdAt: Value(createdAt),
      deviceId: Value(deviceId),
    );
  }

  factory Family.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Family(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      discountPercent: serializer.fromJson<double?>(json['discountPercent']),
      discountFixed: serializer.fromJson<double?>(json['discountFixed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'discountPercent': serializer.toJson<double?>(discountPercent),
      'discountFixed': serializer.toJson<double?>(discountFixed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Family copyWith({
    String? id,
    String? name,
    Value<double?> discountPercent = const Value.absent(),
    Value<double?> discountFixed = const Value.absent(),
    DateTime? createdAt,
    String? deviceId,
  }) => Family(
    id: id ?? this.id,
    name: name ?? this.name,
    discountPercent: discountPercent.present
        ? discountPercent.value
        : this.discountPercent,
    discountFixed: discountFixed.present
        ? discountFixed.value
        : this.discountFixed,
    createdAt: createdAt ?? this.createdAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Family copyWithCompanion(FamiliesCompanion data) {
    return Family(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      discountFixed: data.discountFixed.present
          ? data.discountFixed.value
          : this.discountFixed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Family(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountFixed: $discountFixed, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    discountPercent,
    discountFixed,
    createdAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Family &&
          other.id == this.id &&
          other.name == this.name &&
          other.discountPercent == this.discountPercent &&
          other.discountFixed == this.discountFixed &&
          other.createdAt == this.createdAt &&
          other.deviceId == this.deviceId);
}

class FamiliesCompanion extends UpdateCompanion<Family> {
  final Value<String> id;
  final Value<String> name;
  final Value<double?> discountPercent;
  final Value<double?> discountFixed;
  final Value<DateTime> createdAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const FamiliesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountFixed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamiliesCompanion.insert({
    required String id,
    required String name,
    this.discountPercent = const Value.absent(),
    this.discountFixed = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       deviceId = Value(deviceId);
  static Insertable<Family> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? discountPercent,
    Expression<double>? discountFixed,
    Expression<DateTime>? createdAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (discountFixed != null) 'discount_fixed': discountFixed,
      if (createdAt != null) 'created_at': createdAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamiliesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double?>? discountPercent,
    Value<double?>? discountFixed,
    Value<DateTime>? createdAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return FamiliesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      discountPercent: discountPercent ?? this.discountPercent,
      discountFixed: discountFixed ?? this.discountFixed,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<double>(discountPercent.value);
    }
    if (discountFixed.present) {
      map['discount_fixed'] = Variable<double>(discountFixed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamiliesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountFixed: $discountFixed, ')
          ..write('createdAt: $createdAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyMembersTable extends FamilyMembers
    with TableInfo<$FamilyMembersTable, FamilyMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES families (id)',
    ),
  );
  static const VerificationMeta _studentIdMeta = const VerificationMeta(
    'studentId',
  );
  @override
  late final GeneratedColumn<String> studentId = GeneratedColumn<String>(
    'student_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES students (id)',
    ),
  );
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    studentId,
    joinedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('student_id')) {
      context.handle(
        _studentIdMeta,
        studentId.isAcceptableOrUnknown(data['student_id']!, _studentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_studentIdMeta);
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      )!,
      studentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}student_id'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $FamilyMembersTable createAlias(String alias) {
    return $FamilyMembersTable(attachedDatabase, alias);
  }
}

class FamilyMember extends DataClass implements Insertable<FamilyMember> {
  final String id;
  final String familyId;
  final String studentId;
  final DateTime joinedAt;
  final String deviceId;
  const FamilyMember({
    required this.id,
    required this.familyId,
    required this.studentId,
    required this.joinedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['student_id'] = Variable<String>(studentId);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  FamilyMembersCompanion toCompanion(bool nullToAbsent) {
    return FamilyMembersCompanion(
      id: Value(id),
      familyId: Value(familyId),
      studentId: Value(studentId),
      joinedAt: Value(joinedAt),
      deviceId: Value(deviceId),
    );
  }

  factory FamilyMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyMember(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      studentId: serializer.fromJson<String>(json['studentId']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'studentId': serializer.toJson<String>(studentId),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  FamilyMember copyWith({
    String? id,
    String? familyId,
    String? studentId,
    DateTime? joinedAt,
    String? deviceId,
  }) => FamilyMember(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    studentId: studentId ?? this.studentId,
    joinedAt: joinedAt ?? this.joinedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  FamilyMember copyWithCompanion(FamilyMembersCompanion data) {
    return FamilyMember(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      studentId: data.studentId.present ? data.studentId.value : this.studentId,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMember(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('studentId: $studentId, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, familyId, studentId, joinedAt, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyMember &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.studentId == this.studentId &&
          other.joinedAt == this.joinedAt &&
          other.deviceId == this.deviceId);
}

class FamilyMembersCompanion extends UpdateCompanion<FamilyMember> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> studentId;
  final Value<DateTime> joinedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const FamilyMembersCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.studentId = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyMembersCompanion.insert({
    required String id,
    required String familyId,
    required String studentId,
    this.joinedAt = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyId = Value(familyId),
       studentId = Value(studentId),
       deviceId = Value(deviceId);
  static Insertable<FamilyMember> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? studentId,
    Expression<DateTime>? joinedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (studentId != null) 'student_id': studentId,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? familyId,
    Value<String>? studentId,
    Value<DateTime>? joinedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return FamilyMembersCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      studentId: studentId ?? this.studentId,
      joinedAt: joinedAt ?? this.joinedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (studentId.present) {
      map['student_id'] = Variable<String>(studentId.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('studentId: $studentId, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $TeachersTable teachers = $TeachersTable(this);
  late final $ClassroomsTable classrooms = $ClassroomsTable(this);
  late final $SubjectGroupsTable subjectGroups = $SubjectGroupsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $EnrollmentsTable enrollments = $EnrollmentsTable(this);
  late final $EnrollmentWaitlistTable enrollmentWaitlist =
      $EnrollmentWaitlistTable(this);
  late final $CancellationsTable cancellations = $CancellationsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $AttendanceTable attendance = $AttendanceTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $StudentCardsTable studentCards = $StudentCardsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $TeacherSubjectGroupsTable teacherSubjectGroups =
      $TeacherSubjectGroupsTable(this);
  late final $SchoolClosuresTable schoolClosures = $SchoolClosuresTable(this);
  late final $SchoolLevelsTable schoolLevels = $SchoolLevelsTable(this);
  late final $PaymentAllocationsTable paymentAllocations =
      $PaymentAllocationsTable(this);
  late final $ClosedPeriodsTable closedPeriods = $ClosedPeriodsTable(this);
  late final $FamiliesTable families = $FamiliesTable(this);
  late final $FamilyMembersTable familyMembers = $FamilyMembersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    students,
    teachers,
    classrooms,
    subjectGroups,
    sessions,
    enrollments,
    enrollmentWaitlist,
    cancellations,
    transactions,
    attendance,
    users,
    auditLog,
    studentCards,
    settings,
    teacherSubjectGroups,
    schoolClosures,
    schoolLevels,
    paymentAllocations,
    closedPeriods,
    families,
    familyMembers,
  ];
}

typedef $$StudentsTableCreateCompanionBuilder =
    StudentsCompanion Function({
      required String id,
      required String code,
      required String firstNameAr,
      required String lastNameAr,
      Value<String?> firstNameFr,
      Value<String?> lastNameFr,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> gender,
      Value<DateTime?> birthDate,
      Value<String?> birthPlace,
      Value<DateTime> registrationDate,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String deviceId,
      Value<String?> schoolLevel,
      Value<bool> isArchived,
      Value<String?> photoPath,
      Value<int> rowid,
    });
typedef $$StudentsTableUpdateCompanionBuilder =
    StudentsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> firstNameAr,
      Value<String> lastNameAr,
      Value<String?> firstNameFr,
      Value<String?> lastNameFr,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> gender,
      Value<DateTime?> birthDate,
      Value<String?> birthPlace,
      Value<DateTime> registrationDate,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deviceId,
      Value<String?> schoolLevel,
      Value<bool> isArchived,
      Value<String?> photoPath,
      Value<int> rowid,
    });

final class $$StudentsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentsTable, Student> {
  $$StudentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EnrollmentsTable, List<Enrollment>>
  _enrollmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.enrollments,
    aliasName: 'students__id__enrollments__student_id',
  );

  $$EnrollmentsTableProcessedTableManager get enrollmentsRefs {
    final manager = $$EnrollmentsTableTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_enrollmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EnrollmentWaitlistTable,
    List<EnrollmentWaitlistData>
  >
  _enrollmentWaitlistRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.enrollmentWaitlist,
        aliasName: 'students__id__enrollment_waitlist__student_id',
      );

  $$EnrollmentWaitlistTableProcessedTableManager get enrollmentWaitlistRefs {
    final manager = $$EnrollmentWaitlistTableTableManager(
      $_db,
      $_db.enrollmentWaitlist,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _enrollmentWaitlistRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'students__id__transactions__student_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceData>>
  _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: 'students__id__attendance__student_id',
  );

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StudentCardsTable, List<StudentCard>>
  _studentCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studentCards,
    aliasName: 'students__id__student_cards__student_id',
  );

  $$StudentCardsTableProcessedTableManager get studentCardsRefs {
    final manager = $$StudentCardsTableTableManager(
      $_db,
      $_db.studentCards,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studentCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FamilyMembersTable, List<FamilyMember>>
  _familyMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.familyMembers,
    aliasName: 'students__id__family_members__student_id',
  );

  $$FamilyMembersTableProcessedTableManager get familyMembersRefs {
    final manager = $$FamilyMembersTableTableManager(
      $_db,
      $_db.familyMembers,
    ).filter((f) => f.studentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_familyMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudentsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastNameAr => $composableBuilder(
    column: $table.lastNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstNameFr => $composableBuilder(
    column: $table.firstNameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastNameFr => $composableBuilder(
    column: $table.lastNameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolLevel => $composableBuilder(
    column: $table.schoolLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> enrollmentsRefs(
    Expression<bool> Function($$EnrollmentsTableFilterComposer f) f,
  ) {
    final $$EnrollmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentsTableFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> enrollmentWaitlistRefs(
    Expression<bool> Function($$EnrollmentWaitlistTableFilterComposer f) f,
  ) {
    final $$EnrollmentWaitlistTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollmentWaitlist,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentWaitlistTableFilterComposer(
            $db: $db,
            $table: $db.enrollmentWaitlist,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attendanceRefs(
    Expression<bool> Function($$AttendanceTableFilterComposer f) f,
  ) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> studentCardsRefs(
    Expression<bool> Function($$StudentCardsTableFilterComposer f) f,
  ) {
    final $$StudentCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentCards,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentCardsTableFilterComposer(
            $db: $db,
            $table: $db.studentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> familyMembersRefs(
    Expression<bool> Function($$FamilyMembersTableFilterComposer f) f,
  ) {
    final $$FamilyMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableFilterComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastNameAr => $composableBuilder(
    column: $table.lastNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstNameFr => $composableBuilder(
    column: $table.firstNameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastNameFr => $composableBuilder(
    column: $table.lastNameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolLevel => $composableBuilder(
    column: $table.schoolLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentsTable> {
  $$StudentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastNameAr => $composableBuilder(
    column: $table.lastNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstNameFr => $composableBuilder(
    column: $table.firstNameFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastNameFr => $composableBuilder(
    column: $table.lastNameFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get birthPlace => $composableBuilder(
    column: $table.birthPlace,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get schoolLevel => $composableBuilder(
    column: $table.schoolLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  Expression<T> enrollmentsRefs<T extends Object>(
    Expression<T> Function($$EnrollmentsTableAnnotationComposer a) f,
  ) {
    final $$EnrollmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> enrollmentWaitlistRefs<T extends Object>(
    Expression<T> Function($$EnrollmentWaitlistTableAnnotationComposer a) f,
  ) {
    final $$EnrollmentWaitlistTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.enrollmentWaitlist,
          getReferencedColumn: (t) => t.studentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EnrollmentWaitlistTableAnnotationComposer(
                $db: $db,
                $table: $db.enrollmentWaitlist,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($$AttendanceTableAnnotationComposer a) f,
  ) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> studentCardsRefs<T extends Object>(
    Expression<T> Function($$StudentCardsTableAnnotationComposer a) f,
  ) {
    final $$StudentCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studentCards,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.studentCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> familyMembersRefs<T extends Object>(
    Expression<T> Function($$FamilyMembersTableAnnotationComposer a) f,
  ) {
    final $$FamilyMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.studentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentsTable,
          Student,
          $$StudentsTableFilterComposer,
          $$StudentsTableOrderingComposer,
          $$StudentsTableAnnotationComposer,
          $$StudentsTableCreateCompanionBuilder,
          $$StudentsTableUpdateCompanionBuilder,
          (Student, $$StudentsTableReferences),
          Student,
          PrefetchHooks Function({
            bool enrollmentsRefs,
            bool enrollmentWaitlistRefs,
            bool transactionsRefs,
            bool attendanceRefs,
            bool studentCardsRefs,
            bool familyMembersRefs,
          })
        > {
  $$StudentsTableTableManager(_$AppDatabase db, $StudentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> firstNameAr = const Value.absent(),
                Value<String> lastNameAr = const Value.absent(),
                Value<String?> firstNameFr = const Value.absent(),
                Value<String?> lastNameFr = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> birthPlace = const Value.absent(),
                Value<DateTime> registrationDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String?> schoolLevel = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion(
                id: id,
                code: code,
                firstNameAr: firstNameAr,
                lastNameAr: lastNameAr,
                firstNameFr: firstNameFr,
                lastNameFr: lastNameFr,
                phone: phone,
                address: address,
                gender: gender,
                birthDate: birthDate,
                birthPlace: birthPlace,
                registrationDate: registrationDate,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                schoolLevel: schoolLevel,
                isArchived: isArchived,
                photoPath: photoPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String firstNameAr,
                required String lastNameAr,
                Value<String?> firstNameFr = const Value.absent(),
                Value<String?> lastNameFr = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<String?> birthPlace = const Value.absent(),
                Value<DateTime> registrationDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String deviceId,
                Value<String?> schoolLevel = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentsCompanion.insert(
                id: id,
                code: code,
                firstNameAr: firstNameAr,
                lastNameAr: lastNameAr,
                firstNameFr: firstNameFr,
                lastNameFr: lastNameFr,
                phone: phone,
                address: address,
                gender: gender,
                birthDate: birthDate,
                birthPlace: birthPlace,
                registrationDate: registrationDate,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                schoolLevel: schoolLevel,
                isArchived: isArchived,
                photoPath: photoPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                enrollmentsRefs = false,
                enrollmentWaitlistRefs = false,
                transactionsRefs = false,
                attendanceRefs = false,
                studentCardsRefs = false,
                familyMembersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (enrollmentsRefs) db.enrollments,
                    if (enrollmentWaitlistRefs) db.enrollmentWaitlist,
                    if (transactionsRefs) db.transactions,
                    if (attendanceRefs) db.attendance,
                    if (studentCardsRefs) db.studentCards,
                    if (familyMembersRefs) db.familyMembers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (enrollmentsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          Enrollment
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._enrollmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).enrollmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (enrollmentWaitlistRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          EnrollmentWaitlistData
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._enrollmentWaitlistRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).enrollmentWaitlistRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attendanceRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          AttendanceData
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._attendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (studentCardsRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          StudentCard
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._studentCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).studentCardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (familyMembersRefs)
                        await $_getPrefetchedData<
                          Student,
                          $StudentsTable,
                          FamilyMember
                        >(
                          currentTable: table,
                          referencedTable: $$StudentsTableReferences
                              ._familyMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudentsTableReferences(
                                db,
                                table,
                                p0,
                              ).familyMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentsTable,
      Student,
      $$StudentsTableFilterComposer,
      $$StudentsTableOrderingComposer,
      $$StudentsTableAnnotationComposer,
      $$StudentsTableCreateCompanionBuilder,
      $$StudentsTableUpdateCompanionBuilder,
      (Student, $$StudentsTableReferences),
      Student,
      PrefetchHooks Function({
        bool enrollmentsRefs,
        bool enrollmentWaitlistRefs,
        bool transactionsRefs,
        bool attendanceRefs,
        bool studentCardsRefs,
        bool familyMembersRefs,
      })
    >;
typedef $$TeachersTableCreateCompanionBuilder =
    TeachersCompanion Function({
      required String id,
      required String code,
      required String firstNameAr,
      required String lastNameAr,
      Value<String?> firstNameFr,
      Value<String?> lastNameFr,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> email,
      Value<String?> idCard,
      Value<DateTime?> employmentStartDate,
      Value<DateTime?> employmentEndDate,
      Value<String> salaryType,
      Value<double?> teacherSharePct,
      Value<double?> teacherFixedAmount,
      Value<bool> isArchived,
      Value<String?> photoPath,
      Value<String?> gender,
      Value<int?> overdueThresholdDays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$TeachersTableUpdateCompanionBuilder =
    TeachersCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> firstNameAr,
      Value<String> lastNameAr,
      Value<String?> firstNameFr,
      Value<String?> lastNameFr,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> email,
      Value<String?> idCard,
      Value<DateTime?> employmentStartDate,
      Value<DateTime?> employmentEndDate,
      Value<String> salaryType,
      Value<double?> teacherSharePct,
      Value<double?> teacherFixedAmount,
      Value<bool> isArchived,
      Value<String?> photoPath,
      Value<String?> gender,
      Value<int?> overdueThresholdDays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$TeachersTableReferences
    extends BaseReferences<_$AppDatabase, $TeachersTable, Teacher> {
  $$TeachersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'teachers__id__sessions__teacher_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.teacherId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'teachers__id__transactions__teacher_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.teacherId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceData>>
  _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: 'teachers__id__attendance__teacher_id',
  );

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.teacherId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TeacherSubjectGroupsTable,
    List<TeacherSubjectGroup>
  >
  _teacherSubjectGroupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.teacherSubjectGroups,
        aliasName: 'teachers__id__teacher_subject_groups__teacher_id',
      );

  $$TeacherSubjectGroupsTableProcessedTableManager
  get teacherSubjectGroupsRefs {
    final manager = $$TeacherSubjectGroupsTableTableManager(
      $_db,
      $_db.teacherSubjectGroups,
    ).filter((f) => f.teacherId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _teacherSubjectGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TeachersTableFilterComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastNameAr => $composableBuilder(
    column: $table.lastNameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstNameFr => $composableBuilder(
    column: $table.firstNameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastNameFr => $composableBuilder(
    column: $table.lastNameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idCard => $composableBuilder(
    column: $table.idCard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get employmentStartDate => $composableBuilder(
    column: $table.employmentStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get employmentEndDate => $composableBuilder(
    column: $table.employmentEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salaryType => $composableBuilder(
    column: $table.salaryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get teacherSharePct => $composableBuilder(
    column: $table.teacherSharePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get teacherFixedAmount => $composableBuilder(
    column: $table.teacherFixedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overdueThresholdDays => $composableBuilder(
    column: $table.overdueThresholdDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attendanceRefs(
    Expression<bool> Function($$AttendanceTableFilterComposer f) f,
  ) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> teacherSubjectGroupsRefs(
    Expression<bool> Function($$TeacherSubjectGroupsTableFilterComposer f) f,
  ) {
    final $$TeacherSubjectGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teacherSubjectGroups,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeacherSubjectGroupsTableFilterComposer(
            $db: $db,
            $table: $db.teacherSubjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TeachersTableOrderingComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastNameAr => $composableBuilder(
    column: $table.lastNameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstNameFr => $composableBuilder(
    column: $table.firstNameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastNameFr => $composableBuilder(
    column: $table.lastNameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idCard => $composableBuilder(
    column: $table.idCard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get employmentStartDate => $composableBuilder(
    column: $table.employmentStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get employmentEndDate => $composableBuilder(
    column: $table.employmentEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salaryType => $composableBuilder(
    column: $table.salaryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get teacherSharePct => $composableBuilder(
    column: $table.teacherSharePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get teacherFixedAmount => $composableBuilder(
    column: $table.teacherFixedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overdueThresholdDays => $composableBuilder(
    column: $table.overdueThresholdDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeachersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeachersTable> {
  $$TeachersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get firstNameAr => $composableBuilder(
    column: $table.firstNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastNameAr => $composableBuilder(
    column: $table.lastNameAr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstNameFr => $composableBuilder(
    column: $table.firstNameFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastNameFr => $composableBuilder(
    column: $table.lastNameFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get idCard =>
      $composableBuilder(column: $table.idCard, builder: (column) => column);

  GeneratedColumn<DateTime> get employmentStartDate => $composableBuilder(
    column: $table.employmentStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get employmentEndDate => $composableBuilder(
    column: $table.employmentEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get salaryType => $composableBuilder(
    column: $table.salaryType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get teacherSharePct => $composableBuilder(
    column: $table.teacherSharePct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get teacherFixedAmount => $composableBuilder(
    column: $table.teacherFixedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get overdueThresholdDays => $composableBuilder(
    column: $table.overdueThresholdDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($$AttendanceTableAnnotationComposer a) f,
  ) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.teacherId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> teacherSubjectGroupsRefs<T extends Object>(
    Expression<T> Function($$TeacherSubjectGroupsTableAnnotationComposer a) f,
  ) {
    final $$TeacherSubjectGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.teacherSubjectGroups,
          getReferencedColumn: (t) => t.teacherId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TeacherSubjectGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.teacherSubjectGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TeachersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeachersTable,
          Teacher,
          $$TeachersTableFilterComposer,
          $$TeachersTableOrderingComposer,
          $$TeachersTableAnnotationComposer,
          $$TeachersTableCreateCompanionBuilder,
          $$TeachersTableUpdateCompanionBuilder,
          (Teacher, $$TeachersTableReferences),
          Teacher,
          PrefetchHooks Function({
            bool sessionsRefs,
            bool transactionsRefs,
            bool attendanceRefs,
            bool teacherSubjectGroupsRefs,
          })
        > {
  $$TeachersTableTableManager(_$AppDatabase db, $TeachersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeachersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeachersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeachersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> firstNameAr = const Value.absent(),
                Value<String> lastNameAr = const Value.absent(),
                Value<String?> firstNameFr = const Value.absent(),
                Value<String?> lastNameFr = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> idCard = const Value.absent(),
                Value<DateTime?> employmentStartDate = const Value.absent(),
                Value<DateTime?> employmentEndDate = const Value.absent(),
                Value<String> salaryType = const Value.absent(),
                Value<double?> teacherSharePct = const Value.absent(),
                Value<double?> teacherFixedAmount = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> overdueThresholdDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeachersCompanion(
                id: id,
                code: code,
                firstNameAr: firstNameAr,
                lastNameAr: lastNameAr,
                firstNameFr: firstNameFr,
                lastNameFr: lastNameFr,
                phone: phone,
                address: address,
                email: email,
                idCard: idCard,
                employmentStartDate: employmentStartDate,
                employmentEndDate: employmentEndDate,
                salaryType: salaryType,
                teacherSharePct: teacherSharePct,
                teacherFixedAmount: teacherFixedAmount,
                isArchived: isArchived,
                photoPath: photoPath,
                gender: gender,
                overdueThresholdDays: overdueThresholdDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String firstNameAr,
                required String lastNameAr,
                Value<String?> firstNameFr = const Value.absent(),
                Value<String?> lastNameFr = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> idCard = const Value.absent(),
                Value<DateTime?> employmentStartDate = const Value.absent(),
                Value<DateTime?> employmentEndDate = const Value.absent(),
                Value<String> salaryType = const Value.absent(),
                Value<double?> teacherSharePct = const Value.absent(),
                Value<double?> teacherFixedAmount = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> overdueThresholdDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => TeachersCompanion.insert(
                id: id,
                code: code,
                firstNameAr: firstNameAr,
                lastNameAr: lastNameAr,
                firstNameFr: firstNameFr,
                lastNameFr: lastNameFr,
                phone: phone,
                address: address,
                email: email,
                idCard: idCard,
                employmentStartDate: employmentStartDate,
                employmentEndDate: employmentEndDate,
                salaryType: salaryType,
                teacherSharePct: teacherSharePct,
                teacherFixedAmount: teacherFixedAmount,
                isArchived: isArchived,
                photoPath: photoPath,
                gender: gender,
                overdueThresholdDays: overdueThresholdDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeachersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionsRefs = false,
                transactionsRefs = false,
                attendanceRefs = false,
                teacherSubjectGroupsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionsRefs) db.sessions,
                    if (transactionsRefs) db.transactions,
                    if (attendanceRefs) db.attendance,
                    if (teacherSubjectGroupsRefs) db.teacherSubjectGroups,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionsRefs)
                        await $_getPrefetchedData<
                          Teacher,
                          $TeachersTable,
                          Session
                        >(
                          currentTable: table,
                          referencedTable: $$TeachersTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeachersTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teacherId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Teacher,
                          $TeachersTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$TeachersTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeachersTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teacherId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attendanceRefs)
                        await $_getPrefetchedData<
                          Teacher,
                          $TeachersTable,
                          AttendanceData
                        >(
                          currentTable: table,
                          referencedTable: $$TeachersTableReferences
                              ._attendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeachersTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teacherId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (teacherSubjectGroupsRefs)
                        await $_getPrefetchedData<
                          Teacher,
                          $TeachersTable,
                          TeacherSubjectGroup
                        >(
                          currentTable: table,
                          referencedTable: $$TeachersTableReferences
                              ._teacherSubjectGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TeachersTableReferences(
                                db,
                                table,
                                p0,
                              ).teacherSubjectGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.teacherId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TeachersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeachersTable,
      Teacher,
      $$TeachersTableFilterComposer,
      $$TeachersTableOrderingComposer,
      $$TeachersTableAnnotationComposer,
      $$TeachersTableCreateCompanionBuilder,
      $$TeachersTableUpdateCompanionBuilder,
      (Teacher, $$TeachersTableReferences),
      Teacher,
      PrefetchHooks Function({
        bool sessionsRefs,
        bool transactionsRefs,
        bool attendanceRefs,
        bool teacherSubjectGroupsRefs,
      })
    >;
typedef $$ClassroomsTableCreateCompanionBuilder =
    ClassroomsCompanion Function({
      required String id,
      required String nameAr,
      Value<String?> nameFr,
      Value<int?> floor,
      Value<int?> capacity,
      Value<String?> notes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$ClassroomsTableUpdateCompanionBuilder =
    ClassroomsCompanion Function({
      Value<String> id,
      Value<String> nameAr,
      Value<String?> nameFr,
      Value<int?> floor,
      Value<int?> capacity,
      Value<String?> notes,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$ClassroomsTableReferences
    extends BaseReferences<_$AppDatabase, $ClassroomsTable, Classroom> {
  $$ClassroomsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'classrooms__id__sessions__classroom_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.classroomId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClassroomsTableFilterComposer
    extends Composer<_$AppDatabase, $ClassroomsTable> {
  $$ClassroomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.classroomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClassroomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClassroomsTable> {
  $$ClassroomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get floor => $composableBuilder(
    column: $table.floor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClassroomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClassroomsTable> {
  $$ClassroomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<int> get floor =>
      $composableBuilder(column: $table.floor, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.classroomId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClassroomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClassroomsTable,
          Classroom,
          $$ClassroomsTableFilterComposer,
          $$ClassroomsTableOrderingComposer,
          $$ClassroomsTableAnnotationComposer,
          $$ClassroomsTableCreateCompanionBuilder,
          $$ClassroomsTableUpdateCompanionBuilder,
          (Classroom, $$ClassroomsTableReferences),
          Classroom,
          PrefetchHooks Function({bool sessionsRefs})
        > {
  $$ClassroomsTableTableManager(_$AppDatabase db, $ClassroomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClassroomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClassroomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClassroomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String?> nameFr = const Value.absent(),
                Value<int?> floor = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClassroomsCompanion(
                id: id,
                nameAr: nameAr,
                nameFr: nameFr,
                floor: floor,
                capacity: capacity,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameAr,
                Value<String?> nameFr = const Value.absent(),
                Value<int?> floor = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => ClassroomsCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameFr: nameFr,
                floor: floor,
                capacity: capacity,
                notes: notes,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClassroomsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<
                      Classroom,
                      $ClassroomsTable,
                      Session
                    >(
                      currentTable: table,
                      referencedTable: $$ClassroomsTableReferences
                          ._sessionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ClassroomsTableReferences(
                            db,
                            table,
                            p0,
                          ).sessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.classroomId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ClassroomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClassroomsTable,
      Classroom,
      $$ClassroomsTableFilterComposer,
      $$ClassroomsTableOrderingComposer,
      $$ClassroomsTableAnnotationComposer,
      $$ClassroomsTableCreateCompanionBuilder,
      $$ClassroomsTableUpdateCompanionBuilder,
      (Classroom, $$ClassroomsTableReferences),
      Classroom,
      PrefetchHooks Function({bool sessionsRefs})
    >;
typedef $$SubjectGroupsTableCreateCompanionBuilder =
    SubjectGroupsCompanion Function({
      required String id,
      required String nameAr,
      Value<String?> nameFr,
      required String subjectAr,
      Value<String?> subjectFr,
      required String schoolLevel,
      Value<String?> description,
      Value<int?> capacity,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$SubjectGroupsTableUpdateCompanionBuilder =
    SubjectGroupsCompanion Function({
      Value<String> id,
      Value<String> nameAr,
      Value<String?> nameFr,
      Value<String> subjectAr,
      Value<String?> subjectFr,
      Value<String> schoolLevel,
      Value<String?> description,
      Value<int?> capacity,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$SubjectGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectGroupsTable, SubjectGroup> {
  $$SubjectGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'subject_groups__id__sessions__subject_group_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.subjectGroupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EnrollmentsTable, List<Enrollment>>
  _enrollmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.enrollments,
    aliasName: 'subject_groups__id__enrollments__subject_group_id',
  );

  $$EnrollmentsTableProcessedTableManager get enrollmentsRefs {
    final manager = $$EnrollmentsTableTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.subjectGroupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_enrollmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EnrollmentWaitlistTable,
    List<EnrollmentWaitlistData>
  >
  _enrollmentWaitlistRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.enrollmentWaitlist,
        aliasName: 'subject_groups__id__enrollment_waitlist__subject_group_id',
      );

  $$EnrollmentWaitlistTableProcessedTableManager get enrollmentWaitlistRefs {
    final manager = $$EnrollmentWaitlistTableTableManager(
      $_db,
      $_db.enrollmentWaitlist,
    ).filter((f) => f.subjectGroupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _enrollmentWaitlistRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TeacherSubjectGroupsTable,
    List<TeacherSubjectGroup>
  >
  _teacherSubjectGroupsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.teacherSubjectGroups,
        aliasName:
            'subject_groups__id__teacher_subject_groups__subject_group_id',
      );

  $$TeacherSubjectGroupsTableProcessedTableManager
  get teacherSubjectGroupsRefs {
    final manager = $$TeacherSubjectGroupsTableTableManager(
      $_db,
      $_db.teacherSubjectGroups,
    ).filter((f) => f.subjectGroupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _teacherSubjectGroupsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectGroupsTable> {
  $$SubjectGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectAr => $composableBuilder(
    column: $table.subjectAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectFr => $composableBuilder(
    column: $table.subjectFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schoolLevel => $composableBuilder(
    column: $table.schoolLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.subjectGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> enrollmentsRefs(
    Expression<bool> Function($$EnrollmentsTableFilterComposer f) f,
  ) {
    final $$EnrollmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.subjectGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentsTableFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> enrollmentWaitlistRefs(
    Expression<bool> Function($$EnrollmentWaitlistTableFilterComposer f) f,
  ) {
    final $$EnrollmentWaitlistTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollmentWaitlist,
      getReferencedColumn: (t) => t.subjectGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentWaitlistTableFilterComposer(
            $db: $db,
            $table: $db.enrollmentWaitlist,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> teacherSubjectGroupsRefs(
    Expression<bool> Function($$TeacherSubjectGroupsTableFilterComposer f) f,
  ) {
    final $$TeacherSubjectGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.teacherSubjectGroups,
      getReferencedColumn: (t) => t.subjectGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeacherSubjectGroupsTableFilterComposer(
            $db: $db,
            $table: $db.teacherSubjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectGroupsTable> {
  $$SubjectGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameFr => $composableBuilder(
    column: $table.nameFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectAr => $composableBuilder(
    column: $table.subjectAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectFr => $composableBuilder(
    column: $table.subjectFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schoolLevel => $composableBuilder(
    column: $table.schoolLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get capacity => $composableBuilder(
    column: $table.capacity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectGroupsTable> {
  $$SubjectGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get subjectAr =>
      $composableBuilder(column: $table.subjectAr, builder: (column) => column);

  GeneratedColumn<String> get subjectFr =>
      $composableBuilder(column: $table.subjectFr, builder: (column) => column);

  GeneratedColumn<String> get schoolLevel => $composableBuilder(
    column: $table.schoolLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.subjectGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> enrollmentsRefs<T extends Object>(
    Expression<T> Function($$EnrollmentsTableAnnotationComposer a) f,
  ) {
    final $$EnrollmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.subjectGroupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> enrollmentWaitlistRefs<T extends Object>(
    Expression<T> Function($$EnrollmentWaitlistTableAnnotationComposer a) f,
  ) {
    final $$EnrollmentWaitlistTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.enrollmentWaitlist,
          getReferencedColumn: (t) => t.subjectGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EnrollmentWaitlistTableAnnotationComposer(
                $db: $db,
                $table: $db.enrollmentWaitlist,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> teacherSubjectGroupsRefs<T extends Object>(
    Expression<T> Function($$TeacherSubjectGroupsTableAnnotationComposer a) f,
  ) {
    final $$TeacherSubjectGroupsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.teacherSubjectGroups,
          getReferencedColumn: (t) => t.subjectGroupId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TeacherSubjectGroupsTableAnnotationComposer(
                $db: $db,
                $table: $db.teacherSubjectGroups,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SubjectGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectGroupsTable,
          SubjectGroup,
          $$SubjectGroupsTableFilterComposer,
          $$SubjectGroupsTableOrderingComposer,
          $$SubjectGroupsTableAnnotationComposer,
          $$SubjectGroupsTableCreateCompanionBuilder,
          $$SubjectGroupsTableUpdateCompanionBuilder,
          (SubjectGroup, $$SubjectGroupsTableReferences),
          SubjectGroup,
          PrefetchHooks Function({
            bool sessionsRefs,
            bool enrollmentsRefs,
            bool enrollmentWaitlistRefs,
            bool teacherSubjectGroupsRefs,
          })
        > {
  $$SubjectGroupsTableTableManager(_$AppDatabase db, $SubjectGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String?> nameFr = const Value.absent(),
                Value<String> subjectAr = const Value.absent(),
                Value<String?> subjectFr = const Value.absent(),
                Value<String> schoolLevel = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectGroupsCompanion(
                id: id,
                nameAr: nameAr,
                nameFr: nameFr,
                subjectAr: subjectAr,
                subjectFr: subjectFr,
                schoolLevel: schoolLevel,
                description: description,
                capacity: capacity,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameAr,
                Value<String?> nameFr = const Value.absent(),
                required String subjectAr,
                Value<String?> subjectFr = const Value.absent(),
                required String schoolLevel,
                Value<String?> description = const Value.absent(),
                Value<int?> capacity = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => SubjectGroupsCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameFr: nameFr,
                subjectAr: subjectAr,
                subjectFr: subjectFr,
                schoolLevel: schoolLevel,
                description: description,
                capacity: capacity,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubjectGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionsRefs = false,
                enrollmentsRefs = false,
                enrollmentWaitlistRefs = false,
                teacherSubjectGroupsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionsRefs) db.sessions,
                    if (enrollmentsRefs) db.enrollments,
                    if (enrollmentWaitlistRefs) db.enrollmentWaitlist,
                    if (teacherSubjectGroupsRefs) db.teacherSubjectGroups,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionsRefs)
                        await $_getPrefetchedData<
                          SubjectGroup,
                          $SubjectGroupsTable,
                          Session
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectGroupsTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (enrollmentsRefs)
                        await $_getPrefetchedData<
                          SubjectGroup,
                          $SubjectGroupsTable,
                          Enrollment
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectGroupsTableReferences
                              ._enrollmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).enrollmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (enrollmentWaitlistRefs)
                        await $_getPrefetchedData<
                          SubjectGroup,
                          $SubjectGroupsTable,
                          EnrollmentWaitlistData
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectGroupsTableReferences
                              ._enrollmentWaitlistRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).enrollmentWaitlistRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (teacherSubjectGroupsRefs)
                        await $_getPrefetchedData<
                          SubjectGroup,
                          $SubjectGroupsTable,
                          TeacherSubjectGroup
                        >(
                          currentTable: table,
                          referencedTable: $$SubjectGroupsTableReferences
                              ._teacherSubjectGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubjectGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).teacherSubjectGroupsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subjectGroupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubjectGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectGroupsTable,
      SubjectGroup,
      $$SubjectGroupsTableFilterComposer,
      $$SubjectGroupsTableOrderingComposer,
      $$SubjectGroupsTableAnnotationComposer,
      $$SubjectGroupsTableCreateCompanionBuilder,
      $$SubjectGroupsTableUpdateCompanionBuilder,
      (SubjectGroup, $$SubjectGroupsTableReferences),
      SubjectGroup,
      PrefetchHooks Function({
        bool sessionsRefs,
        bool enrollmentsRefs,
        bool enrollmentWaitlistRefs,
        bool teacherSubjectGroupsRefs,
      })
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      required String id,
      required String subjectGroupId,
      required String teacherId,
      required String classroomId,
      required int dayOfWeek,
      required DateTime startTime,
      required DateTime endTime,
      required double monthlyPrice,
      required int sessionsPerMonth,
      Value<double?> teacherSharePct,
      Value<double?> teacherFixedAmount,
      Value<bool> isActive,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<String> id,
      Value<String> subjectGroupId,
      Value<String> teacherId,
      Value<String> classroomId,
      Value<int> dayOfWeek,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<double> monthlyPrice,
      Value<int> sessionsPerMonth,
      Value<double?> teacherSharePct,
      Value<double?> teacherFixedAmount,
      Value<bool> isActive,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SubjectGroupsTable _subjectGroupIdTable(_$AppDatabase db) => db
      .subjectGroups
      .createAlias('sessions__subject_group_id__subject_groups__id');

  $$SubjectGroupsTableProcessedTableManager get subjectGroupId {
    final $_column = $_itemColumn<String>('subject_group_id')!;

    final manager = $$SubjectGroupsTableTableManager(
      $_db,
      $_db.subjectGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeachersTable _teacherIdTable(_$AppDatabase db) =>
      db.teachers.createAlias('sessions__teacher_id__teachers__id');

  $$TeachersTableProcessedTableManager get teacherId {
    final $_column = $_itemColumn<String>('teacher_id')!;

    final manager = $$TeachersTableTableManager(
      $_db,
      $_db.teachers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClassroomsTable _classroomIdTable(_$AppDatabase db) =>
      db.classrooms.createAlias('sessions__classroom_id__classrooms__id');

  $$ClassroomsTableProcessedTableManager get classroomId {
    final $_column = $_itemColumn<String>('classroom_id')!;

    final manager = $$ClassroomsTableTableManager(
      $_db,
      $_db.classrooms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_classroomIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CancellationsTable, List<Cancellation>>
  _cancellationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cancellations,
    aliasName: 'sessions__id__cancellations__session_id',
  );

  $$CancellationsTableProcessedTableManager get cancellationsRefs {
    final manager = $$CancellationsTableTableManager(
      $_db,
      $_db.cancellations,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cancellationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'sessions__id__transactions__session_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceData>>
  _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: 'sessions__id__attendance__session_id',
  );

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionsPerMonth => $composableBuilder(
    column: $table.sessionsPerMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get teacherSharePct => $composableBuilder(
    column: $table.teacherSharePct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get teacherFixedAmount => $composableBuilder(
    column: $table.teacherFixedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectGroupsTableFilterComposer get subjectGroupId {
    final $$SubjectGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableFilterComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableFilterComposer get teacherId {
    final $$TeachersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableFilterComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassroomsTableFilterComposer get classroomId {
    final $$ClassroomsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classroomId,
      referencedTable: $db.classrooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassroomsTableFilterComposer(
            $db: $db,
            $table: $db.classrooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cancellationsRefs(
    Expression<bool> Function($$CancellationsTableFilterComposer f) f,
  ) {
    final $$CancellationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cancellations,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CancellationsTableFilterComposer(
            $db: $db,
            $table: $db.cancellations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attendanceRefs(
    Expression<bool> Function($$AttendanceTableFilterComposer f) f,
  ) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionsPerMonth => $composableBuilder(
    column: $table.sessionsPerMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get teacherSharePct => $composableBuilder(
    column: $table.teacherSharePct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get teacherFixedAmount => $composableBuilder(
    column: $table.teacherFixedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectGroupsTableOrderingComposer get subjectGroupId {
    final $$SubjectGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableOrderingComposer get teacherId {
    final $$TeachersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableOrderingComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassroomsTableOrderingComposer get classroomId {
    final $$ClassroomsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classroomId,
      referencedTable: $db.classrooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassroomsTableOrderingComposer(
            $db: $db,
            $table: $db.classrooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionsPerMonth => $composableBuilder(
    column: $table.sessionsPerMonth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get teacherSharePct => $composableBuilder(
    column: $table.teacherSharePct,
    builder: (column) => column,
  );

  GeneratedColumn<double> get teacherFixedAmount => $composableBuilder(
    column: $table.teacherFixedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$SubjectGroupsTableAnnotationComposer get subjectGroupId {
    final $$SubjectGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableAnnotationComposer get teacherId {
    final $$TeachersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableAnnotationComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClassroomsTableAnnotationComposer get classroomId {
    final $$ClassroomsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.classroomId,
      referencedTable: $db.classrooms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClassroomsTableAnnotationComposer(
            $db: $db,
            $table: $db.classrooms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cancellationsRefs<T extends Object>(
    Expression<T> Function($$CancellationsTableAnnotationComposer a) f,
  ) {
    final $$CancellationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cancellations,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CancellationsTableAnnotationComposer(
            $db: $db,
            $table: $db.cancellations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($$AttendanceTableAnnotationComposer a) f,
  ) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool subjectGroupId,
            bool teacherId,
            bool classroomId,
            bool cancellationsRefs,
            bool transactionsRefs,
            bool attendanceRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectGroupId = const Value.absent(),
                Value<String> teacherId = const Value.absent(),
                Value<String> classroomId = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<double> monthlyPrice = const Value.absent(),
                Value<int> sessionsPerMonth = const Value.absent(),
                Value<double?> teacherSharePct = const Value.absent(),
                Value<double?> teacherFixedAmount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                subjectGroupId: subjectGroupId,
                teacherId: teacherId,
                classroomId: classroomId,
                dayOfWeek: dayOfWeek,
                startTime: startTime,
                endTime: endTime,
                monthlyPrice: monthlyPrice,
                sessionsPerMonth: sessionsPerMonth,
                teacherSharePct: teacherSharePct,
                teacherFixedAmount: teacherFixedAmount,
                isActive: isActive,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectGroupId,
                required String teacherId,
                required String classroomId,
                required int dayOfWeek,
                required DateTime startTime,
                required DateTime endTime,
                required double monthlyPrice,
                required int sessionsPerMonth,
                Value<double?> teacherSharePct = const Value.absent(),
                Value<double?> teacherFixedAmount = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                subjectGroupId: subjectGroupId,
                teacherId: teacherId,
                classroomId: classroomId,
                dayOfWeek: dayOfWeek,
                startTime: startTime,
                endTime: endTime,
                monthlyPrice: monthlyPrice,
                sessionsPerMonth: sessionsPerMonth,
                teacherSharePct: teacherSharePct,
                teacherFixedAmount: teacherFixedAmount,
                isActive: isActive,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subjectGroupId = false,
                teacherId = false,
                classroomId = false,
                cancellationsRefs = false,
                transactionsRefs = false,
                attendanceRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cancellationsRefs) db.cancellations,
                    if (transactionsRefs) db.transactions,
                    if (attendanceRefs) db.attendance,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (subjectGroupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectGroupId,
                                    referencedTable: $$SessionsTableReferences
                                        ._subjectGroupIdTable(db),
                                    referencedColumn: $$SessionsTableReferences
                                        ._subjectGroupIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (teacherId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teacherId,
                                    referencedTable: $$SessionsTableReferences
                                        ._teacherIdTable(db),
                                    referencedColumn: $$SessionsTableReferences
                                        ._teacherIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (classroomId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.classroomId,
                                    referencedTable: $$SessionsTableReferences
                                        ._classroomIdTable(db),
                                    referencedColumn: $$SessionsTableReferences
                                        ._classroomIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cancellationsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          Cancellation
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._cancellationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).cancellationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attendanceRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          AttendanceData
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._attendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({
        bool subjectGroupId,
        bool teacherId,
        bool classroomId,
        bool cancellationsRefs,
        bool transactionsRefs,
        bool attendanceRefs,
      })
    >;
typedef $$EnrollmentsTableCreateCompanionBuilder =
    EnrollmentsCompanion Function({
      required String id,
      required String studentId,
      required String subjectGroupId,
      Value<DateTime> enrollmentDate,
      Value<double?> customPriceOverride,
      Value<double?> customDiscount,
      Value<String> status,
      Value<String?> notes,
      Value<bool> isTransferred,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$EnrollmentsTableUpdateCompanionBuilder =
    EnrollmentsCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> subjectGroupId,
      Value<DateTime> enrollmentDate,
      Value<double?> customPriceOverride,
      Value<double?> customDiscount,
      Value<String> status,
      Value<String?> notes,
      Value<bool> isTransferred,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$EnrollmentsTableReferences
    extends BaseReferences<_$AppDatabase, $EnrollmentsTable, Enrollment> {
  $$EnrollmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('enrollments__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubjectGroupsTable _subjectGroupIdTable(_$AppDatabase db) => db
      .subjectGroups
      .createAlias('enrollments__subject_group_id__subject_groups__id');

  $$SubjectGroupsTableProcessedTableManager get subjectGroupId {
    final $_column = $_itemColumn<String>('subject_group_id')!;

    final manager = $$SubjectGroupsTableTableManager(
      $_db,
      $_db.subjectGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Transaction>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'enrollments__id__transactions__enrollment_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.enrollmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EnrollmentsTableFilterComposer
    extends Composer<_$AppDatabase, $EnrollmentsTable> {
  $$EnrollmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enrollmentDate => $composableBuilder(
    column: $table.enrollmentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customPriceOverride => $composableBuilder(
    column: $table.customPriceOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customDiscount => $composableBuilder(
    column: $table.customDiscount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTransferred => $composableBuilder(
    column: $table.isTransferred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableFilterComposer get subjectGroupId {
    final $$SubjectGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableFilterComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.enrollmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnrollmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnrollmentsTable> {
  $$EnrollmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enrollmentDate => $composableBuilder(
    column: $table.enrollmentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customPriceOverride => $composableBuilder(
    column: $table.customPriceOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customDiscount => $composableBuilder(
    column: $table.customDiscount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTransferred => $composableBuilder(
    column: $table.isTransferred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableOrderingComposer get subjectGroupId {
    final $$SubjectGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnrollmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnrollmentsTable> {
  $$EnrollmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get enrollmentDate => $composableBuilder(
    column: $table.enrollmentDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get customPriceOverride => $composableBuilder(
    column: $table.customPriceOverride,
    builder: (column) => column,
  );

  GeneratedColumn<double> get customDiscount => $composableBuilder(
    column: $table.customDiscount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isTransferred => $composableBuilder(
    column: $table.isTransferred,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableAnnotationComposer get subjectGroupId {
    final $$SubjectGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.enrollmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EnrollmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnrollmentsTable,
          Enrollment,
          $$EnrollmentsTableFilterComposer,
          $$EnrollmentsTableOrderingComposer,
          $$EnrollmentsTableAnnotationComposer,
          $$EnrollmentsTableCreateCompanionBuilder,
          $$EnrollmentsTableUpdateCompanionBuilder,
          (Enrollment, $$EnrollmentsTableReferences),
          Enrollment,
          PrefetchHooks Function({
            bool studentId,
            bool subjectGroupId,
            bool transactionsRefs,
          })
        > {
  $$EnrollmentsTableTableManager(_$AppDatabase db, $EnrollmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnrollmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnrollmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnrollmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> subjectGroupId = const Value.absent(),
                Value<DateTime> enrollmentDate = const Value.absent(),
                Value<double?> customPriceOverride = const Value.absent(),
                Value<double?> customDiscount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isTransferred = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentsCompanion(
                id: id,
                studentId: studentId,
                subjectGroupId: subjectGroupId,
                enrollmentDate: enrollmentDate,
                customPriceOverride: customPriceOverride,
                customDiscount: customDiscount,
                status: status,
                notes: notes,
                isTransferred: isTransferred,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String subjectGroupId,
                Value<DateTime> enrollmentDate = const Value.absent(),
                Value<double?> customPriceOverride = const Value.absent(),
                Value<double?> customDiscount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isTransferred = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentsCompanion.insert(
                id: id,
                studentId: studentId,
                subjectGroupId: subjectGroupId,
                enrollmentDate: enrollmentDate,
                customPriceOverride: customPriceOverride,
                customDiscount: customDiscount,
                status: status,
                notes: notes,
                isTransferred: isTransferred,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnrollmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                studentId = false,
                subjectGroupId = false,
                transactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (studentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.studentId,
                                    referencedTable:
                                        $$EnrollmentsTableReferences
                                            ._studentIdTable(db),
                                    referencedColumn:
                                        $$EnrollmentsTableReferences
                                            ._studentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (subjectGroupId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subjectGroupId,
                                    referencedTable:
                                        $$EnrollmentsTableReferences
                                            ._subjectGroupIdTable(db),
                                    referencedColumn:
                                        $$EnrollmentsTableReferences
                                            ._subjectGroupIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Enrollment,
                          $EnrollmentsTable,
                          Transaction
                        >(
                          currentTable: table,
                          referencedTable: $$EnrollmentsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EnrollmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.enrollmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EnrollmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnrollmentsTable,
      Enrollment,
      $$EnrollmentsTableFilterComposer,
      $$EnrollmentsTableOrderingComposer,
      $$EnrollmentsTableAnnotationComposer,
      $$EnrollmentsTableCreateCompanionBuilder,
      $$EnrollmentsTableUpdateCompanionBuilder,
      (Enrollment, $$EnrollmentsTableReferences),
      Enrollment,
      PrefetchHooks Function({
        bool studentId,
        bool subjectGroupId,
        bool transactionsRefs,
      })
    >;
typedef $$EnrollmentWaitlistTableCreateCompanionBuilder =
    EnrollmentWaitlistCompanion Function({
      required String id,
      required String studentId,
      required String subjectGroupId,
      Value<DateTime> requestedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$EnrollmentWaitlistTableUpdateCompanionBuilder =
    EnrollmentWaitlistCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> subjectGroupId,
      Value<DateTime> requestedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$EnrollmentWaitlistTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EnrollmentWaitlistTable,
          EnrollmentWaitlistData
        > {
  $$EnrollmentWaitlistTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('enrollment_waitlist__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubjectGroupsTable _subjectGroupIdTable(_$AppDatabase db) => db
      .subjectGroups
      .createAlias('enrollment_waitlist__subject_group_id__subject_groups__id');

  $$SubjectGroupsTableProcessedTableManager get subjectGroupId {
    final $_column = $_itemColumn<String>('subject_group_id')!;

    final manager = $$SubjectGroupsTableTableManager(
      $_db,
      $_db.subjectGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EnrollmentWaitlistTableFilterComposer
    extends Composer<_$AppDatabase, $EnrollmentWaitlistTable> {
  $$EnrollmentWaitlistTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableFilterComposer get subjectGroupId {
    final $$SubjectGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableFilterComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnrollmentWaitlistTableOrderingComposer
    extends Composer<_$AppDatabase, $EnrollmentWaitlistTable> {
  $$EnrollmentWaitlistTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableOrderingComposer get subjectGroupId {
    final $$SubjectGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnrollmentWaitlistTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnrollmentWaitlistTable> {
  $$EnrollmentWaitlistTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableAnnotationComposer get subjectGroupId {
    final $$SubjectGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EnrollmentWaitlistTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnrollmentWaitlistTable,
          EnrollmentWaitlistData,
          $$EnrollmentWaitlistTableFilterComposer,
          $$EnrollmentWaitlistTableOrderingComposer,
          $$EnrollmentWaitlistTableAnnotationComposer,
          $$EnrollmentWaitlistTableCreateCompanionBuilder,
          $$EnrollmentWaitlistTableUpdateCompanionBuilder,
          (EnrollmentWaitlistData, $$EnrollmentWaitlistTableReferences),
          EnrollmentWaitlistData,
          PrefetchHooks Function({bool studentId, bool subjectGroupId})
        > {
  $$EnrollmentWaitlistTableTableManager(
    _$AppDatabase db,
    $EnrollmentWaitlistTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnrollmentWaitlistTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnrollmentWaitlistTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnrollmentWaitlistTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> subjectGroupId = const Value.absent(),
                Value<DateTime> requestedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentWaitlistCompanion(
                id: id,
                studentId: studentId,
                subjectGroupId: subjectGroupId,
                requestedAt: requestedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String subjectGroupId,
                Value<DateTime> requestedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => EnrollmentWaitlistCompanion.insert(
                id: id,
                studentId: studentId,
                subjectGroupId: subjectGroupId,
                requestedAt: requestedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EnrollmentWaitlistTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false, subjectGroupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable:
                                    $$EnrollmentWaitlistTableReferences
                                        ._studentIdTable(db),
                                referencedColumn:
                                    $$EnrollmentWaitlistTableReferences
                                        ._studentIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (subjectGroupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectGroupId,
                                referencedTable:
                                    $$EnrollmentWaitlistTableReferences
                                        ._subjectGroupIdTable(db),
                                referencedColumn:
                                    $$EnrollmentWaitlistTableReferences
                                        ._subjectGroupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EnrollmentWaitlistTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnrollmentWaitlistTable,
      EnrollmentWaitlistData,
      $$EnrollmentWaitlistTableFilterComposer,
      $$EnrollmentWaitlistTableOrderingComposer,
      $$EnrollmentWaitlistTableAnnotationComposer,
      $$EnrollmentWaitlistTableCreateCompanionBuilder,
      $$EnrollmentWaitlistTableUpdateCompanionBuilder,
      (EnrollmentWaitlistData, $$EnrollmentWaitlistTableReferences),
      EnrollmentWaitlistData,
      PrefetchHooks Function({bool studentId, bool subjectGroupId})
    >;
typedef $$CancellationsTableCreateCompanionBuilder =
    CancellationsCompanion Function({
      required String id,
      required String sessionId,
      required DateTime cancelDate,
      Value<String?> reason,
      Value<String?> cancelledByUserId,
      Value<DateTime> createdAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$CancellationsTableUpdateCompanionBuilder =
    CancellationsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<DateTime> cancelDate,
      Value<String?> reason,
      Value<String?> cancelledByUserId,
      Value<DateTime> createdAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$CancellationsTableReferences
    extends BaseReferences<_$AppDatabase, $CancellationsTable, Cancellation> {
  $$CancellationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('cancellations__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CancellationsTableFilterComposer
    extends Composer<_$AppDatabase, $CancellationsTable> {
  $$CancellationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelDate => $composableBuilder(
    column: $table.cancelDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cancelledByUserId => $composableBuilder(
    column: $table.cancelledByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CancellationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CancellationsTable> {
  $$CancellationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelDate => $composableBuilder(
    column: $table.cancelDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cancelledByUserId => $composableBuilder(
    column: $table.cancelledByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CancellationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CancellationsTable> {
  $$CancellationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelDate => $composableBuilder(
    column: $table.cancelDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get cancelledByUserId => $composableBuilder(
    column: $table.cancelledByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CancellationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CancellationsTable,
          Cancellation,
          $$CancellationsTableFilterComposer,
          $$CancellationsTableOrderingComposer,
          $$CancellationsTableAnnotationComposer,
          $$CancellationsTableCreateCompanionBuilder,
          $$CancellationsTableUpdateCompanionBuilder,
          (Cancellation, $$CancellationsTableReferences),
          Cancellation,
          PrefetchHooks Function({bool sessionId})
        > {
  $$CancellationsTableTableManager(_$AppDatabase db, $CancellationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CancellationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CancellationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CancellationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> cancelDate = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<String?> cancelledByUserId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CancellationsCompanion(
                id: id,
                sessionId: sessionId,
                cancelDate: cancelDate,
                reason: reason,
                cancelledByUserId: cancelledByUserId,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required DateTime cancelDate,
                Value<String?> reason = const Value.absent(),
                Value<String?> cancelledByUserId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => CancellationsCompanion.insert(
                id: id,
                sessionId: sessionId,
                cancelDate: cancelDate,
                reason: reason,
                cancelledByUserId: cancelledByUserId,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CancellationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$CancellationsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$CancellationsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CancellationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CancellationsTable,
      Cancellation,
      $$CancellationsTableFilterComposer,
      $$CancellationsTableOrderingComposer,
      $$CancellationsTableAnnotationComposer,
      $$CancellationsTableCreateCompanionBuilder,
      $$CancellationsTableUpdateCompanionBuilder,
      (Cancellation, $$CancellationsTableReferences),
      Cancellation,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      Value<String?> studentId,
      Value<String?> teacherId,
      Value<String?> enrollmentId,
      Value<String?> sessionId,
      required String type,
      required double amount,
      required DateTime transactionDate,
      Value<String?> note,
      Value<String?> createdByUserId,
      required String deviceId,
      Value<String?> referenceTransactionId,
      Value<String?> rateSnapshot,
      Value<DateTime> createdAt,
      Value<String?> paymentMethod,
      Value<String?> priceSnapshot,
      Value<int?> cycleNumber,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String?> studentId,
      Value<String?> teacherId,
      Value<String?> enrollmentId,
      Value<String?> sessionId,
      Value<String> type,
      Value<double> amount,
      Value<DateTime> transactionDate,
      Value<String?> note,
      Value<String?> createdByUserId,
      Value<String> deviceId,
      Value<String?> referenceTransactionId,
      Value<String?> rateSnapshot,
      Value<DateTime> createdAt,
      Value<String?> paymentMethod,
      Value<String?> priceSnapshot,
      Value<int?> cycleNumber,
      Value<int> rowid,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Transaction> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('transactions__student_id__students__id');

  $$StudentsTableProcessedTableManager? get studentId {
    final $_column = $_itemColumn<String>('student_id');
    if ($_column == null) return null;
    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeachersTable _teacherIdTable(_$AppDatabase db) =>
      db.teachers.createAlias('transactions__teacher_id__teachers__id');

  $$TeachersTableProcessedTableManager? get teacherId {
    final $_column = $_itemColumn<String>('teacher_id');
    if ($_column == null) return null;
    final manager = $$TeachersTableTableManager(
      $_db,
      $_db.teachers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EnrollmentsTable _enrollmentIdTable(_$AppDatabase db) => db
      .enrollments
      .createAlias('transactions__enrollment_id__enrollments__id');

  $$EnrollmentsTableProcessedTableManager? get enrollmentId {
    final $_column = $_itemColumn<String>('enrollment_id');
    if ($_column == null) return null;
    final manager = $$EnrollmentsTableTableManager(
      $_db,
      $_db.enrollments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_enrollmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('transactions__session_id__sessions__id');

  $$SessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<String>('session_id');
    if ($_column == null) return null;
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceTransactionId => $composableBuilder(
    column: $table.referenceTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rateSnapshot => $composableBuilder(
    column: $table.rateSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceSnapshot => $composableBuilder(
    column: $table.priceSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleNumber => $composableBuilder(
    column: $table.cycleNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableFilterComposer get teacherId {
    final $$TeachersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableFilterComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnrollmentsTableFilterComposer get enrollmentId {
    final $$EnrollmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollmentId,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentsTableFilterComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceTransactionId => $composableBuilder(
    column: $table.referenceTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rateSnapshot => $composableBuilder(
    column: $table.rateSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceSnapshot => $composableBuilder(
    column: $table.priceSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleNumber => $composableBuilder(
    column: $table.cycleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableOrderingComposer get teacherId {
    final $$TeachersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableOrderingComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnrollmentsTableOrderingComposer get enrollmentId {
    final $$EnrollmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollmentId,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentsTableOrderingComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get referenceTransactionId => $composableBuilder(
    column: $table.referenceTransactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rateSnapshot => $composableBuilder(
    column: $table.rateSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priceSnapshot => $composableBuilder(
    column: $table.priceSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cycleNumber => $composableBuilder(
    column: $table.cycleNumber,
    builder: (column) => column,
  );

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableAnnotationComposer get teacherId {
    final $$TeachersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableAnnotationComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EnrollmentsTableAnnotationComposer get enrollmentId {
    final $$EnrollmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.enrollmentId,
      referencedTable: $db.enrollments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EnrollmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.enrollments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Transaction, $$TransactionsTableReferences),
          Transaction,
          PrefetchHooks Function({
            bool studentId,
            bool teacherId,
            bool enrollmentId,
            bool sessionId,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> studentId = const Value.absent(),
                Value<String?> teacherId = const Value.absent(),
                Value<String?> enrollmentId = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> createdByUserId = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String?> referenceTransactionId = const Value.absent(),
                Value<String?> rateSnapshot = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> priceSnapshot = const Value.absent(),
                Value<int?> cycleNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                studentId: studentId,
                teacherId: teacherId,
                enrollmentId: enrollmentId,
                sessionId: sessionId,
                type: type,
                amount: amount,
                transactionDate: transactionDate,
                note: note,
                createdByUserId: createdByUserId,
                deviceId: deviceId,
                referenceTransactionId: referenceTransactionId,
                rateSnapshot: rateSnapshot,
                createdAt: createdAt,
                paymentMethod: paymentMethod,
                priceSnapshot: priceSnapshot,
                cycleNumber: cycleNumber,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> studentId = const Value.absent(),
                Value<String?> teacherId = const Value.absent(),
                Value<String?> enrollmentId = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                required String type,
                required double amount,
                required DateTime transactionDate,
                Value<String?> note = const Value.absent(),
                Value<String?> createdByUserId = const Value.absent(),
                required String deviceId,
                Value<String?> referenceTransactionId = const Value.absent(),
                Value<String?> rateSnapshot = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<String?> priceSnapshot = const Value.absent(),
                Value<int?> cycleNumber = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                studentId: studentId,
                teacherId: teacherId,
                enrollmentId: enrollmentId,
                sessionId: sessionId,
                type: type,
                amount: amount,
                transactionDate: transactionDate,
                note: note,
                createdByUserId: createdByUserId,
                deviceId: deviceId,
                referenceTransactionId: referenceTransactionId,
                rateSnapshot: rateSnapshot,
                createdAt: createdAt,
                paymentMethod: paymentMethod,
                priceSnapshot: priceSnapshot,
                cycleNumber: cycleNumber,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                studentId = false,
                teacherId = false,
                enrollmentId = false,
                sessionId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (studentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.studentId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._studentIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._studentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (teacherId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teacherId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._teacherIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._teacherIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (enrollmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.enrollmentId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._enrollmentIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._enrollmentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Transaction, $$TransactionsTableReferences),
      Transaction,
      PrefetchHooks Function({
        bool studentId,
        bool teacherId,
        bool enrollmentId,
        bool sessionId,
      })
    >;
typedef $$AttendanceTableCreateCompanionBuilder =
    AttendanceCompanion Function({
      required String id,
      Value<String?> studentId,
      Value<String?> teacherId,
      required String sessionId,
      required DateTime attendanceDate,
      Value<DateTime> checkInTime,
      required String personType,
      Value<String> checkInMethod,
      Value<bool> isManualEntry,
      Value<String?> checkedInByUserId,
      Value<DateTime> createdAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$AttendanceTableUpdateCompanionBuilder =
    AttendanceCompanion Function({
      Value<String> id,
      Value<String?> studentId,
      Value<String?> teacherId,
      Value<String> sessionId,
      Value<DateTime> attendanceDate,
      Value<DateTime> checkInTime,
      Value<String> personType,
      Value<String> checkInMethod,
      Value<bool> isManualEntry,
      Value<String?> checkedInByUserId,
      Value<DateTime> createdAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$AttendanceTableReferences
    extends BaseReferences<_$AppDatabase, $AttendanceTable, AttendanceData> {
  $$AttendanceTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('attendance__student_id__students__id');

  $$StudentsTableProcessedTableManager? get studentId {
    final $_column = $_itemColumn<String>('student_id');
    if ($_column == null) return null;
    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeachersTable _teacherIdTable(_$AppDatabase db) =>
      db.teachers.createAlias('attendance__teacher_id__teachers__id');

  $$TeachersTableProcessedTableManager? get teacherId {
    final $_column = $_itemColumn<String>('teacher_id');
    if ($_column == null) return null;
    final manager = $$TeachersTableTableManager(
      $_db,
      $_db.teachers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('attendance__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personType => $composableBuilder(
    column: $table.personType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkInMethod => $composableBuilder(
    column: $table.checkInMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkedInByUserId => $composableBuilder(
    column: $table.checkedInByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableFilterComposer get teacherId {
    final $$TeachersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableFilterComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personType => $composableBuilder(
    column: $table.personType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkInMethod => $composableBuilder(
    column: $table.checkInMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkedInByUserId => $composableBuilder(
    column: $table.checkedInByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableOrderingComposer get teacherId {
    final $$TeachersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableOrderingComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personType => $composableBuilder(
    column: $table.personType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkInMethod => $composableBuilder(
    column: $table.checkInMethod,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isManualEntry => $composableBuilder(
    column: $table.isManualEntry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkedInByUserId => $composableBuilder(
    column: $table.checkedInByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeachersTableAnnotationComposer get teacherId {
    final $$TeachersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableAnnotationComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceTable,
          AttendanceData,
          $$AttendanceTableFilterComposer,
          $$AttendanceTableOrderingComposer,
          $$AttendanceTableAnnotationComposer,
          $$AttendanceTableCreateCompanionBuilder,
          $$AttendanceTableUpdateCompanionBuilder,
          (AttendanceData, $$AttendanceTableReferences),
          AttendanceData,
          PrefetchHooks Function({
            bool studentId,
            bool teacherId,
            bool sessionId,
          })
        > {
  $$AttendanceTableTableManager(_$AppDatabase db, $AttendanceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> studentId = const Value.absent(),
                Value<String?> teacherId = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> attendanceDate = const Value.absent(),
                Value<DateTime> checkInTime = const Value.absent(),
                Value<String> personType = const Value.absent(),
                Value<String> checkInMethod = const Value.absent(),
                Value<bool> isManualEntry = const Value.absent(),
                Value<String?> checkedInByUserId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceCompanion(
                id: id,
                studentId: studentId,
                teacherId: teacherId,
                sessionId: sessionId,
                attendanceDate: attendanceDate,
                checkInTime: checkInTime,
                personType: personType,
                checkInMethod: checkInMethod,
                isManualEntry: isManualEntry,
                checkedInByUserId: checkedInByUserId,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> studentId = const Value.absent(),
                Value<String?> teacherId = const Value.absent(),
                required String sessionId,
                required DateTime attendanceDate,
                Value<DateTime> checkInTime = const Value.absent(),
                required String personType,
                Value<String> checkInMethod = const Value.absent(),
                Value<bool> isManualEntry = const Value.absent(),
                Value<String?> checkedInByUserId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => AttendanceCompanion.insert(
                id: id,
                studentId: studentId,
                teacherId: teacherId,
                sessionId: sessionId,
                attendanceDate: attendanceDate,
                checkInTime: checkInTime,
                personType: personType,
                checkInMethod: checkInMethod,
                isManualEntry: isManualEntry,
                checkedInByUserId: checkedInByUserId,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttendanceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({studentId = false, teacherId = false, sessionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (studentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.studentId,
                                    referencedTable: $$AttendanceTableReferences
                                        ._studentIdTable(db),
                                    referencedColumn:
                                        $$AttendanceTableReferences
                                            ._studentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (teacherId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.teacherId,
                                    referencedTable: $$AttendanceTableReferences
                                        ._teacherIdTable(db),
                                    referencedColumn:
                                        $$AttendanceTableReferences
                                            ._teacherIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable: $$AttendanceTableReferences
                                        ._sessionIdTable(db),
                                    referencedColumn:
                                        $$AttendanceTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AttendanceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceTable,
      AttendanceData,
      $$AttendanceTableFilterComposer,
      $$AttendanceTableOrderingComposer,
      $$AttendanceTableAnnotationComposer,
      $$AttendanceTableCreateCompanionBuilder,
      $$AttendanceTableUpdateCompanionBuilder,
      (AttendanceData, $$AttendanceTableReferences),
      AttendanceData,
      PrefetchHooks Function({bool studentId, bool teacherId, bool sessionId})
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String username,
      required String passwordHash,
      Value<String> role,
      required String firstName,
      required String lastName,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> username,
      Value<String> passwordHash,
      Value<String> role,
      Value<String> firstName,
      Value<String> lastName,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AuditLogTable, List<AuditLogData>>
  _auditLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.auditLog,
    aliasName: 'users__id__audit_log__user_id',
  );

  $$AuditLogTableProcessedTableManager get auditLogRefs {
    final manager = $$AuditLogTableTableManager(
      $_db,
      $_db.auditLog,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_auditLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> auditLogRefs(
    Expression<bool> Function($$AuditLogTableFilterComposer f) f,
  ) {
    final $$AuditLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditLog,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditLogTableFilterComposer(
            $db: $db,
            $table: $db.auditLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  Expression<T> auditLogRefs<T extends Object>(
    Expression<T> Function($$AuditLogTableAnnotationComposer a) f,
  ) {
    final $$AuditLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.auditLog,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuditLogTableAnnotationComposer(
            $db: $db,
            $table: $db.auditLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool auditLogRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                firstName: firstName,
                lastName: lastName,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String username,
                required String passwordHash,
                Value<String> role = const Value.absent(),
                required String firstName,
                required String lastName,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                firstName: firstName,
                lastName: lastName,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({auditLogRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (auditLogRefs) db.auditLog],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (auditLogRefs)
                    await $_getPrefetchedData<User, $UsersTable, AuditLogData>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences
                          ._auditLogRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UsersTableReferences(db, table, p0).auditLogRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool auditLogRefs})
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      required String id,
      required String userId,
      required String action,
      required String entityType,
      Value<String?> entityId,
      Value<String?> details,
      Value<DateTime> timestamp,
      required String deviceId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> action,
      Value<String> entityType,
      Value<String?> entityId,
      Value<String?> details,
      Value<DateTime> timestamp,
      Value<String> deviceId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AuditLogTableReferences
    extends BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData> {
  $$AuditLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('audit_log__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (AuditLogData, $$AuditLogTableReferences),
          AuditLogData,
          PrefetchHooks Function({bool userId})
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                details: details,
                timestamp: timestamp,
                deviceId: deviceId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String action,
                required String entityType,
                Value<String?> entityId = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                required String deviceId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                details: details,
                timestamp: timestamp,
                deviceId: deviceId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuditLogTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$AuditLogTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$AuditLogTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (AuditLogData, $$AuditLogTableReferences),
      AuditLogData,
      PrefetchHooks Function({bool userId})
    >;
typedef $$StudentCardsTableCreateCompanionBuilder =
    StudentCardsCompanion Function({
      required String id,
      required String studentId,
      required String secureToken,
      required String barcodeContent,
      Value<DateTime> issuedDate,
      Value<bool> isActive,
      Value<DateTime?> revokedDate,
      Value<DateTime> createdAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$StudentCardsTableUpdateCompanionBuilder =
    StudentCardsCompanion Function({
      Value<String> id,
      Value<String> studentId,
      Value<String> secureToken,
      Value<String> barcodeContent,
      Value<DateTime> issuedDate,
      Value<bool> isActive,
      Value<DateTime?> revokedDate,
      Value<DateTime> createdAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$StudentCardsTableReferences
    extends BaseReferences<_$AppDatabase, $StudentCardsTable, StudentCard> {
  $$StudentCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('student_cards__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StudentCardsTableFilterComposer
    extends Composer<_$AppDatabase, $StudentCardsTable> {
  $$StudentCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secureToken => $composableBuilder(
    column: $table.secureToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcodeContent => $composableBuilder(
    column: $table.barcodeContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revokedDate => $composableBuilder(
    column: $table.revokedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudentCardsTable> {
  $$StudentCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secureToken => $composableBuilder(
    column: $table.secureToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcodeContent => $composableBuilder(
    column: $table.barcodeContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revokedDate => $composableBuilder(
    column: $table.revokedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudentCardsTable> {
  $$StudentCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get secureToken => $composableBuilder(
    column: $table.secureToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get barcodeContent => $composableBuilder(
    column: $table.barcodeContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get issuedDate => $composableBuilder(
    column: $table.issuedDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get revokedDate => $composableBuilder(
    column: $table.revokedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudentCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudentCardsTable,
          StudentCard,
          $$StudentCardsTableFilterComposer,
          $$StudentCardsTableOrderingComposer,
          $$StudentCardsTableAnnotationComposer,
          $$StudentCardsTableCreateCompanionBuilder,
          $$StudentCardsTableUpdateCompanionBuilder,
          (StudentCard, $$StudentCardsTableReferences),
          StudentCard,
          PrefetchHooks Function({bool studentId})
        > {
  $$StudentCardsTableTableManager(_$AppDatabase db, $StudentCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudentCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudentCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudentCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<String> secureToken = const Value.absent(),
                Value<String> barcodeContent = const Value.absent(),
                Value<DateTime> issuedDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> revokedDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudentCardsCompanion(
                id: id,
                studentId: studentId,
                secureToken: secureToken,
                barcodeContent: barcodeContent,
                issuedDate: issuedDate,
                isActive: isActive,
                revokedDate: revokedDate,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String studentId,
                required String secureToken,
                required String barcodeContent,
                Value<DateTime> issuedDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> revokedDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => StudentCardsCompanion.insert(
                id: id,
                studentId: studentId,
                secureToken: secureToken,
                barcodeContent: barcodeContent,
                issuedDate: issuedDate,
                isActive: isActive,
                revokedDate: revokedDate,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StudentCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable: $$StudentCardsTableReferences
                                    ._studentIdTable(db),
                                referencedColumn: $$StudentCardsTableReferences
                                    ._studentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StudentCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudentCardsTable,
      StudentCard,
      $$StudentCardsTableFilterComposer,
      $$StudentCardsTableOrderingComposer,
      $$StudentCardsTableAnnotationComposer,
      $$StudentCardsTableCreateCompanionBuilder,
      $$StudentCardsTableUpdateCompanionBuilder,
      (StudentCard, $$StudentCardsTableReferences),
      StudentCard,
      PrefetchHooks Function({bool studentId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$TeacherSubjectGroupsTableCreateCompanionBuilder =
    TeacherSubjectGroupsCompanion Function({
      required String id,
      required String teacherId,
      required String subjectGroupId,
      Value<DateTime> createdAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$TeacherSubjectGroupsTableUpdateCompanionBuilder =
    TeacherSubjectGroupsCompanion Function({
      Value<String> id,
      Value<String> teacherId,
      Value<String> subjectGroupId,
      Value<DateTime> createdAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$TeacherSubjectGroupsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TeacherSubjectGroupsTable,
          TeacherSubjectGroup
        > {
  $$TeacherSubjectGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TeachersTable _teacherIdTable(_$AppDatabase db) => db.teachers
      .createAlias('teacher_subject_groups__teacher_id__teachers__id');

  $$TeachersTableProcessedTableManager get teacherId {
    final $_column = $_itemColumn<String>('teacher_id')!;

    final manager = $$TeachersTableTableManager(
      $_db,
      $_db.teachers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_teacherIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubjectGroupsTable _subjectGroupIdTable(_$AppDatabase db) =>
      db.subjectGroups.createAlias(
        'teacher_subject_groups__subject_group_id__subject_groups__id',
      );

  $$SubjectGroupsTableProcessedTableManager get subjectGroupId {
    final $_column = $_itemColumn<String>('subject_group_id')!;

    final manager = $$SubjectGroupsTableTableManager(
      $_db,
      $_db.subjectGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TeacherSubjectGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $TeacherSubjectGroupsTable> {
  $$TeacherSubjectGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$TeachersTableFilterComposer get teacherId {
    final $$TeachersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableFilterComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableFilterComposer get subjectGroupId {
    final $$SubjectGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableFilterComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeacherSubjectGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeacherSubjectGroupsTable> {
  $$TeacherSubjectGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeachersTableOrderingComposer get teacherId {
    final $$TeachersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableOrderingComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableOrderingComposer get subjectGroupId {
    final $$SubjectGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeacherSubjectGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeacherSubjectGroupsTable> {
  $$TeacherSubjectGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$TeachersTableAnnotationComposer get teacherId {
    final $$TeachersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.teacherId,
      referencedTable: $db.teachers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeachersTableAnnotationComposer(
            $db: $db,
            $table: $db.teachers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubjectGroupsTableAnnotationComposer get subjectGroupId {
    final $$SubjectGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectGroupId,
      referencedTable: $db.subjectGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjectGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TeacherSubjectGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeacherSubjectGroupsTable,
          TeacherSubjectGroup,
          $$TeacherSubjectGroupsTableFilterComposer,
          $$TeacherSubjectGroupsTableOrderingComposer,
          $$TeacherSubjectGroupsTableAnnotationComposer,
          $$TeacherSubjectGroupsTableCreateCompanionBuilder,
          $$TeacherSubjectGroupsTableUpdateCompanionBuilder,
          (TeacherSubjectGroup, $$TeacherSubjectGroupsTableReferences),
          TeacherSubjectGroup,
          PrefetchHooks Function({bool teacherId, bool subjectGroupId})
        > {
  $$TeacherSubjectGroupsTableTableManager(
    _$AppDatabase db,
    $TeacherSubjectGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeacherSubjectGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeacherSubjectGroupsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TeacherSubjectGroupsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> teacherId = const Value.absent(),
                Value<String> subjectGroupId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TeacherSubjectGroupsCompanion(
                id: id,
                teacherId: teacherId,
                subjectGroupId: subjectGroupId,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String teacherId,
                required String subjectGroupId,
                Value<DateTime> createdAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => TeacherSubjectGroupsCompanion.insert(
                id: id,
                teacherId: teacherId,
                subjectGroupId: subjectGroupId,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TeacherSubjectGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({teacherId = false, subjectGroupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (teacherId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.teacherId,
                                referencedTable:
                                    $$TeacherSubjectGroupsTableReferences
                                        ._teacherIdTable(db),
                                referencedColumn:
                                    $$TeacherSubjectGroupsTableReferences
                                        ._teacherIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (subjectGroupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectGroupId,
                                referencedTable:
                                    $$TeacherSubjectGroupsTableReferences
                                        ._subjectGroupIdTable(db),
                                referencedColumn:
                                    $$TeacherSubjectGroupsTableReferences
                                        ._subjectGroupIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TeacherSubjectGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeacherSubjectGroupsTable,
      TeacherSubjectGroup,
      $$TeacherSubjectGroupsTableFilterComposer,
      $$TeacherSubjectGroupsTableOrderingComposer,
      $$TeacherSubjectGroupsTableAnnotationComposer,
      $$TeacherSubjectGroupsTableCreateCompanionBuilder,
      $$TeacherSubjectGroupsTableUpdateCompanionBuilder,
      (TeacherSubjectGroup, $$TeacherSubjectGroupsTableReferences),
      TeacherSubjectGroup,
      PrefetchHooks Function({bool teacherId, bool subjectGroupId})
    >;
typedef $$SchoolClosuresTableCreateCompanionBuilder =
    SchoolClosuresCompanion Function({
      required String id,
      required DateTime closureDate,
      Value<String?> reason,
      Value<DateTime> createdAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$SchoolClosuresTableUpdateCompanionBuilder =
    SchoolClosuresCompanion Function({
      Value<String> id,
      Value<DateTime> closureDate,
      Value<String?> reason,
      Value<DateTime> createdAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

class $$SchoolClosuresTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolClosuresTable> {
  $$SchoolClosuresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closureDate => $composableBuilder(
    column: $table.closureDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchoolClosuresTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolClosuresTable> {
  $$SchoolClosuresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closureDate => $composableBuilder(
    column: $table.closureDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolClosuresTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolClosuresTable> {
  $$SchoolClosuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get closureDate => $composableBuilder(
    column: $table.closureDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$SchoolClosuresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolClosuresTable,
          SchoolClosure,
          $$SchoolClosuresTableFilterComposer,
          $$SchoolClosuresTableOrderingComposer,
          $$SchoolClosuresTableAnnotationComposer,
          $$SchoolClosuresTableCreateCompanionBuilder,
          $$SchoolClosuresTableUpdateCompanionBuilder,
          (
            SchoolClosure,
            BaseReferences<_$AppDatabase, $SchoolClosuresTable, SchoolClosure>,
          ),
          SchoolClosure,
          PrefetchHooks Function()
        > {
  $$SchoolClosuresTableTableManager(
    _$AppDatabase db,
    $SchoolClosuresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolClosuresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolClosuresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolClosuresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> closureDate = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchoolClosuresCompanion(
                id: id,
                closureDate: closureDate,
                reason: reason,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime closureDate,
                Value<String?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => SchoolClosuresCompanion.insert(
                id: id,
                closureDate: closureDate,
                reason: reason,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchoolClosuresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolClosuresTable,
      SchoolClosure,
      $$SchoolClosuresTableFilterComposer,
      $$SchoolClosuresTableOrderingComposer,
      $$SchoolClosuresTableAnnotationComposer,
      $$SchoolClosuresTableCreateCompanionBuilder,
      $$SchoolClosuresTableUpdateCompanionBuilder,
      (
        SchoolClosure,
        BaseReferences<_$AppDatabase, $SchoolClosuresTable, SchoolClosure>,
      ),
      SchoolClosure,
      PrefetchHooks Function()
    >;
typedef $$SchoolLevelsTableCreateCompanionBuilder =
    SchoolLevelsCompanion Function({
      required String id,
      required String name,
      required String deviceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SchoolLevelsTableUpdateCompanionBuilder =
    SchoolLevelsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> deviceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SchoolLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolLevelsTable> {
  $$SchoolLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchoolLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolLevelsTable> {
  $$SchoolLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchoolLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolLevelsTable> {
  $$SchoolLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SchoolLevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchoolLevelsTable,
          SchoolLevel,
          $$SchoolLevelsTableFilterComposer,
          $$SchoolLevelsTableOrderingComposer,
          $$SchoolLevelsTableAnnotationComposer,
          $$SchoolLevelsTableCreateCompanionBuilder,
          $$SchoolLevelsTableUpdateCompanionBuilder,
          (
            SchoolLevel,
            BaseReferences<_$AppDatabase, $SchoolLevelsTable, SchoolLevel>,
          ),
          SchoolLevel,
          PrefetchHooks Function()
        > {
  $$SchoolLevelsTableTableManager(_$AppDatabase db, $SchoolLevelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchoolLevelsCompanion(
                id: id,
                name: name,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String deviceId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchoolLevelsCompanion.insert(
                id: id,
                name: name,
                deviceId: deviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchoolLevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchoolLevelsTable,
      SchoolLevel,
      $$SchoolLevelsTableFilterComposer,
      $$SchoolLevelsTableOrderingComposer,
      $$SchoolLevelsTableAnnotationComposer,
      $$SchoolLevelsTableCreateCompanionBuilder,
      $$SchoolLevelsTableUpdateCompanionBuilder,
      (
        SchoolLevel,
        BaseReferences<_$AppDatabase, $SchoolLevelsTable, SchoolLevel>,
      ),
      SchoolLevel,
      PrefetchHooks Function()
    >;
typedef $$PaymentAllocationsTableCreateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      required String id,
      required String paymentTransactionId,
      required String chargeTransactionId,
      required double amount,
      Value<DateTime> createdAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$PaymentAllocationsTableUpdateCompanionBuilder =
    PaymentAllocationsCompanion Function({
      Value<String> id,
      Value<String> paymentTransactionId,
      Value<String> chargeTransactionId,
      Value<double> amount,
      Value<DateTime> createdAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$PaymentAllocationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation
        > {
  $$PaymentAllocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _paymentTransactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        'payment_allocations__payment_transaction_id__transactions__id',
      );

  $$TransactionsTableProcessedTableManager get paymentTransactionId {
    final $_column = $_itemColumn<String>('payment_transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _paymentTransactionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _chargeTransactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias(
        'payment_allocations__charge_transaction_id__transactions__id',
      );

  $$TransactionsTableProcessedTableManager get chargeTransactionId {
    final $_column = $_itemColumn<String>('charge_transaction_id')!;

    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chargeTransactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get paymentTransactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get chargeTransactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chargeTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get paymentTransactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get chargeTransactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chargeTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get paymentTransactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get chargeTransactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chargeTransactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentAllocationsTable,
          PaymentAllocation,
          $$PaymentAllocationsTableFilterComposer,
          $$PaymentAllocationsTableOrderingComposer,
          $$PaymentAllocationsTableAnnotationComposer,
          $$PaymentAllocationsTableCreateCompanionBuilder,
          $$PaymentAllocationsTableUpdateCompanionBuilder,
          (PaymentAllocation, $$PaymentAllocationsTableReferences),
          PaymentAllocation,
          PrefetchHooks Function({
            bool paymentTransactionId,
            bool chargeTransactionId,
          })
        > {
  $$PaymentAllocationsTableTableManager(
    _$AppDatabase db,
    $PaymentAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> paymentTransactionId = const Value.absent(),
                Value<String> chargeTransactionId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentAllocationsCompanion(
                id: id,
                paymentTransactionId: paymentTransactionId,
                chargeTransactionId: chargeTransactionId,
                amount: amount,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String paymentTransactionId,
                required String chargeTransactionId,
                required double amount,
                Value<DateTime> createdAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => PaymentAllocationsCompanion.insert(
                id: id,
                paymentTransactionId: paymentTransactionId,
                chargeTransactionId: chargeTransactionId,
                amount: amount,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentAllocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({paymentTransactionId = false, chargeTransactionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (paymentTransactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.paymentTransactionId,
                                    referencedTable:
                                        $$PaymentAllocationsTableReferences
                                            ._paymentTransactionIdTable(db),
                                    referencedColumn:
                                        $$PaymentAllocationsTableReferences
                                            ._paymentTransactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (chargeTransactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.chargeTransactionId,
                                    referencedTable:
                                        $$PaymentAllocationsTableReferences
                                            ._chargeTransactionIdTable(db),
                                    referencedColumn:
                                        $$PaymentAllocationsTableReferences
                                            ._chargeTransactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PaymentAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentAllocationsTable,
      PaymentAllocation,
      $$PaymentAllocationsTableFilterComposer,
      $$PaymentAllocationsTableOrderingComposer,
      $$PaymentAllocationsTableAnnotationComposer,
      $$PaymentAllocationsTableCreateCompanionBuilder,
      $$PaymentAllocationsTableUpdateCompanionBuilder,
      (PaymentAllocation, $$PaymentAllocationsTableReferences),
      PaymentAllocation,
      PrefetchHooks Function({
        bool paymentTransactionId,
        bool chargeTransactionId,
      })
    >;
typedef $$ClosedPeriodsTableCreateCompanionBuilder =
    ClosedPeriodsCompanion Function({
      required String id,
      required int year,
      required int month,
      Value<DateTime> closedAt,
      Value<String?> closedByUserId,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$ClosedPeriodsTableUpdateCompanionBuilder =
    ClosedPeriodsCompanion Function({
      Value<String> id,
      Value<int> year,
      Value<int> month,
      Value<DateTime> closedAt,
      Value<String?> closedByUserId,
      Value<String> deviceId,
      Value<int> rowid,
    });

class $$ClosedPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $ClosedPeriodsTable> {
  $$ClosedPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closedByUserId => $composableBuilder(
    column: $table.closedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClosedPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClosedPeriodsTable> {
  $$ClosedPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closedByUserId => $composableBuilder(
    column: $table.closedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClosedPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClosedPeriodsTable> {
  $$ClosedPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<String> get closedByUserId => $composableBuilder(
    column: $table.closedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);
}

class $$ClosedPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClosedPeriodsTable,
          ClosedPeriod,
          $$ClosedPeriodsTableFilterComposer,
          $$ClosedPeriodsTableOrderingComposer,
          $$ClosedPeriodsTableAnnotationComposer,
          $$ClosedPeriodsTableCreateCompanionBuilder,
          $$ClosedPeriodsTableUpdateCompanionBuilder,
          (
            ClosedPeriod,
            BaseReferences<_$AppDatabase, $ClosedPeriodsTable, ClosedPeriod>,
          ),
          ClosedPeriod,
          PrefetchHooks Function()
        > {
  $$ClosedPeriodsTableTableManager(_$AppDatabase db, $ClosedPeriodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClosedPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClosedPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClosedPeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<DateTime> closedAt = const Value.absent(),
                Value<String?> closedByUserId = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClosedPeriodsCompanion(
                id: id,
                year: year,
                month: month,
                closedAt: closedAt,
                closedByUserId: closedByUserId,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int year,
                required int month,
                Value<DateTime> closedAt = const Value.absent(),
                Value<String?> closedByUserId = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => ClosedPeriodsCompanion.insert(
                id: id,
                year: year,
                month: month,
                closedAt: closedAt,
                closedByUserId: closedByUserId,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClosedPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClosedPeriodsTable,
      ClosedPeriod,
      $$ClosedPeriodsTableFilterComposer,
      $$ClosedPeriodsTableOrderingComposer,
      $$ClosedPeriodsTableAnnotationComposer,
      $$ClosedPeriodsTableCreateCompanionBuilder,
      $$ClosedPeriodsTableUpdateCompanionBuilder,
      (
        ClosedPeriod,
        BaseReferences<_$AppDatabase, $ClosedPeriodsTable, ClosedPeriod>,
      ),
      ClosedPeriod,
      PrefetchHooks Function()
    >;
typedef $$FamiliesTableCreateCompanionBuilder =
    FamiliesCompanion Function({
      required String id,
      required String name,
      Value<double?> discountPercent,
      Value<double?> discountFixed,
      Value<DateTime> createdAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$FamiliesTableUpdateCompanionBuilder =
    FamiliesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double?> discountPercent,
      Value<double?> discountFixed,
      Value<DateTime> createdAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$FamiliesTableReferences
    extends BaseReferences<_$AppDatabase, $FamiliesTable, Family> {
  $$FamiliesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FamilyMembersTable, List<FamilyMember>>
  _familyMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.familyMembers,
    aliasName: 'families__id__family_members__family_id',
  );

  $$FamilyMembersTableProcessedTableManager get familyMembersRefs {
    final manager = $$FamilyMembersTableTableManager(
      $_db,
      $_db.familyMembers,
    ).filter((f) => f.familyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_familyMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FamiliesTableFilterComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountFixed => $composableBuilder(
    column: $table.discountFixed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> familyMembersRefs(
    Expression<bool> Function($$FamilyMembersTableFilterComposer f) f,
  ) {
    final $$FamilyMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.familyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableFilterComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FamiliesTableOrderingComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountFixed => $composableBuilder(
    column: $table.discountFixed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamiliesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get discountFixed => $composableBuilder(
    column: $table.discountFixed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  Expression<T> familyMembersRefs<T extends Object>(
    Expression<T> Function($$FamilyMembersTableAnnotationComposer a) f,
  ) {
    final $$FamilyMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.familyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FamiliesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamiliesTable,
          Family,
          $$FamiliesTableFilterComposer,
          $$FamiliesTableOrderingComposer,
          $$FamiliesTableAnnotationComposer,
          $$FamiliesTableCreateCompanionBuilder,
          $$FamiliesTableUpdateCompanionBuilder,
          (Family, $$FamiliesTableReferences),
          Family,
          PrefetchHooks Function({bool familyMembersRefs})
        > {
  $$FamiliesTableTableManager(_$AppDatabase db, $FamiliesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamiliesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamiliesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamiliesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> discountPercent = const Value.absent(),
                Value<double?> discountFixed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamiliesCompanion(
                id: id,
                name: name,
                discountPercent: discountPercent,
                discountFixed: discountFixed,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<double?> discountPercent = const Value.absent(),
                Value<double?> discountFixed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => FamiliesCompanion.insert(
                id: id,
                name: name,
                discountPercent: discountPercent,
                discountFixed: discountFixed,
                createdAt: createdAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FamiliesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({familyMembersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (familyMembersRefs) db.familyMembers,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (familyMembersRefs)
                    await $_getPrefetchedData<
                      Family,
                      $FamiliesTable,
                      FamilyMember
                    >(
                      currentTable: table,
                      referencedTable: $$FamiliesTableReferences
                          ._familyMembersRefsTable(db),
                      managerFromTypedResult: (p0) => $$FamiliesTableReferences(
                        db,
                        table,
                        p0,
                      ).familyMembersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.familyId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FamiliesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamiliesTable,
      Family,
      $$FamiliesTableFilterComposer,
      $$FamiliesTableOrderingComposer,
      $$FamiliesTableAnnotationComposer,
      $$FamiliesTableCreateCompanionBuilder,
      $$FamiliesTableUpdateCompanionBuilder,
      (Family, $$FamiliesTableReferences),
      Family,
      PrefetchHooks Function({bool familyMembersRefs})
    >;
typedef $$FamilyMembersTableCreateCompanionBuilder =
    FamilyMembersCompanion Function({
      required String id,
      required String familyId,
      required String studentId,
      Value<DateTime> joinedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$FamilyMembersTableUpdateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<String> id,
      Value<String> familyId,
      Value<String> studentId,
      Value<DateTime> joinedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$FamilyMembersTableReferences
    extends BaseReferences<_$AppDatabase, $FamilyMembersTable, FamilyMember> {
  $$FamilyMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FamiliesTable _familyIdTable(_$AppDatabase db) =>
      db.families.createAlias('family_members__family_id__families__id');

  $$FamiliesTableProcessedTableManager get familyId {
    final $_column = $_itemColumn<String>('family_id')!;

    final manager = $$FamiliesTableTableManager(
      $_db,
      $_db.families,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_familyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StudentsTable _studentIdTable(_$AppDatabase db) =>
      db.students.createAlias('family_members__student_id__students__id');

  $$StudentsTableProcessedTableManager get studentId {
    final $_column = $_itemColumn<String>('student_id')!;

    final manager = $$StudentsTableTableManager(
      $_db,
      $_db.students,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FamilyMembersTableFilterComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$FamiliesTableFilterComposer get familyId {
    final $$FamiliesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.familyId,
      referencedTable: $db.families,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliesTableFilterComposer(
            $db: $db,
            $table: $db.families,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudentsTableFilterComposer get studentId {
    final $$StudentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableFilterComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FamilyMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$FamiliesTableOrderingComposer get familyId {
    final $$FamiliesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.familyId,
      referencedTable: $db.families,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliesTableOrderingComposer(
            $db: $db,
            $table: $db.families,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudentsTableOrderingComposer get studentId {
    final $$StudentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableOrderingComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FamilyMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$FamiliesTableAnnotationComposer get familyId {
    final $$FamiliesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.familyId,
      referencedTable: $db.families,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamiliesTableAnnotationComposer(
            $db: $db,
            $table: $db.families,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudentsTableAnnotationComposer get studentId {
    final $$StudentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studentId,
      referencedTable: $db.students,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudentsTableAnnotationComposer(
            $db: $db,
            $table: $db.students,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FamilyMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamilyMembersTable,
          FamilyMember,
          $$FamilyMembersTableFilterComposer,
          $$FamilyMembersTableOrderingComposer,
          $$FamilyMembersTableAnnotationComposer,
          $$FamilyMembersTableCreateCompanionBuilder,
          $$FamilyMembersTableUpdateCompanionBuilder,
          (FamilyMember, $$FamilyMembersTableReferences),
          FamilyMember,
          PrefetchHooks Function({bool familyId, bool studentId})
        > {
  $$FamilyMembersTableTableManager(_$AppDatabase db, $FamilyMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyId = const Value.absent(),
                Value<String> studentId = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersCompanion(
                id: id,
                familyId: familyId,
                studentId: studentId,
                joinedAt: joinedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyId,
                required String studentId,
                Value<DateTime> joinedAt = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersCompanion.insert(
                id: id,
                familyId: familyId,
                studentId: studentId,
                joinedAt: joinedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FamilyMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({familyId = false, studentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (familyId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.familyId,
                                referencedTable: $$FamilyMembersTableReferences
                                    ._familyIdTable(db),
                                referencedColumn: $$FamilyMembersTableReferences
                                    ._familyIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (studentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.studentId,
                                referencedTable: $$FamilyMembersTableReferences
                                    ._studentIdTable(db),
                                referencedColumn: $$FamilyMembersTableReferences
                                    ._studentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FamilyMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamilyMembersTable,
      FamilyMember,
      $$FamilyMembersTableFilterComposer,
      $$FamilyMembersTableOrderingComposer,
      $$FamilyMembersTableAnnotationComposer,
      $$FamilyMembersTableCreateCompanionBuilder,
      $$FamilyMembersTableUpdateCompanionBuilder,
      (FamilyMember, $$FamilyMembersTableReferences),
      FamilyMember,
      PrefetchHooks Function({bool familyId, bool studentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StudentsTableTableManager get students =>
      $$StudentsTableTableManager(_db, _db.students);
  $$TeachersTableTableManager get teachers =>
      $$TeachersTableTableManager(_db, _db.teachers);
  $$ClassroomsTableTableManager get classrooms =>
      $$ClassroomsTableTableManager(_db, _db.classrooms);
  $$SubjectGroupsTableTableManager get subjectGroups =>
      $$SubjectGroupsTableTableManager(_db, _db.subjectGroups);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$EnrollmentsTableTableManager get enrollments =>
      $$EnrollmentsTableTableManager(_db, _db.enrollments);
  $$EnrollmentWaitlistTableTableManager get enrollmentWaitlist =>
      $$EnrollmentWaitlistTableTableManager(_db, _db.enrollmentWaitlist);
  $$CancellationsTableTableManager get cancellations =>
      $$CancellationsTableTableManager(_db, _db.cancellations);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$AttendanceTableTableManager get attendance =>
      $$AttendanceTableTableManager(_db, _db.attendance);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$StudentCardsTableTableManager get studentCards =>
      $$StudentCardsTableTableManager(_db, _db.studentCards);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$TeacherSubjectGroupsTableTableManager get teacherSubjectGroups =>
      $$TeacherSubjectGroupsTableTableManager(_db, _db.teacherSubjectGroups);
  $$SchoolClosuresTableTableManager get schoolClosures =>
      $$SchoolClosuresTableTableManager(_db, _db.schoolClosures);
  $$SchoolLevelsTableTableManager get schoolLevels =>
      $$SchoolLevelsTableTableManager(_db, _db.schoolLevels);
  $$PaymentAllocationsTableTableManager get paymentAllocations =>
      $$PaymentAllocationsTableTableManager(_db, _db.paymentAllocations);
  $$ClosedPeriodsTableTableManager get closedPeriods =>
      $$ClosedPeriodsTableTableManager(_db, _db.closedPeriods);
  $$FamiliesTableTableManager get families =>
      $$FamiliesTableTableManager(_db, _db.families);
  $$FamilyMembersTableTableManager get familyMembers =>
      $$FamilyMembersTableTableManager(_db, _db.familyMembers);
}
