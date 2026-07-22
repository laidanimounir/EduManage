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
          ..write('deviceId: $deviceId')
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
          other.deviceId == this.deviceId);
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
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
    email,
    idCard,
    employmentStartDate,
    employmentEndDate,
    salaryType,
    teacherSharePct,
    teacherFixedAmount,
    createdAt,
    updatedAt,
    deviceId,
  );
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
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StudentsTable students = $StudentsTable(this);
  late final $TeachersTable teachers = $TeachersTable(this);
  late final $ClassroomsTable classrooms = $ClassroomsTable(this);
  late final $SubjectGroupsTable subjectGroups = $SubjectGroupsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $EnrollmentsTable enrollments = $EnrollmentsTable(this);
  late final $CancellationsTable cancellations = $CancellationsTable(this);
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
    cancellations,
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
          PrefetchHooks Function({bool enrollmentsRefs})
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
          prefetchHooksCallback: ({enrollmentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (enrollmentsRefs) db.enrollments],
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
                      managerFromTypedResult: (p0) => $$StudentsTableReferences(
                        db,
                        table,
                        p0,
                      ).enrollmentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.studentId == item.id),
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
      PrefetchHooks Function({bool enrollmentsRefs})
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
          PrefetchHooks Function({bool sessionsRefs})
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
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<Teacher, $TeachersTable, Session>(
                      currentTable: table,
                      referencedTable: $$TeachersTableReferences
                          ._sessionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TeachersTableReferences(db, table, p0).sessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.teacherId == item.id),
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
      PrefetchHooks Function({bool sessionsRefs})
    >;
typedef $$ClassroomsTableCreateCompanionBuilder =
    ClassroomsCompanion Function({
      required String id,
      required String nameAr,
      Value<String?> nameFr,
      Value<int?> floor,
      Value<int?> capacity,
      Value<String?> notes,
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
          PrefetchHooks Function({bool sessionsRefs, bool enrollmentsRefs})
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
              ({sessionsRefs = false, enrollmentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionsRefs) db.sessions,
                    if (enrollmentsRefs) db.enrollments,
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
      PrefetchHooks Function({bool sessionsRefs, bool enrollmentsRefs})
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
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cancellationsRefs) db.cancellations,
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
          PrefetchHooks Function({bool studentId, bool subjectGroupId})
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
                                referencedTable: $$EnrollmentsTableReferences
                                    ._studentIdTable(db),
                                referencedColumn: $$EnrollmentsTableReferences
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
                                referencedTable: $$EnrollmentsTableReferences
                                    ._subjectGroupIdTable(db),
                                referencedColumn: $$EnrollmentsTableReferences
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
  $$CancellationsTableTableManager get cancellations =>
      $$CancellationsTableTableManager(_db, _db.cancellations);
}
