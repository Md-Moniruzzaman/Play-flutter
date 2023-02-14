// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetTeacherCollection on Isar {
  IsarCollection<Teacher> get teachers => collection();
}

const TeacherSchema = CollectionSchema(
  name: r'Teacher',
  schema:
      r'{"name":"Teacher","idName":"id","properties":[{"name":"name","type":"String"}],"indexes":[],"links":[{"name":"course","target":"Course"}]}',
  idName: r'id',
  propertyIds: {r'name': 0},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {r'course': 0},
  backlinkLinkNames: {},
  getId: _teacherGetId,
  setId: _teacherSetId,
  getLinks: _teacherGetLinks,
  attachLinks: _teacherAttachLinks,
  serializeNative: _teacherSerializeNative,
  deserializeNative: _teacherDeserializeNative,
  deserializePropNative: _teacherDeserializePropNative,
  serializeWeb: _teacherSerializeWeb,
  deserializeWeb: _teacherDeserializeWeb,
  deserializePropWeb: _teacherDeserializePropWeb,
  version: 4,
);

int? _teacherGetId(Teacher object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _teacherSetId(Teacher object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _teacherGetLinks(Teacher object) {
  return [object.course];
}

void _teacherSerializeNative(
    IsarCollection<Teacher> collection,
    IsarCObject cObj,
    Teacher object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final name$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.name);
  final size = (staticSize + 3 + (name$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeByteList(offsets[0], name$Bytes);
}

Teacher _teacherDeserializeNative(IsarCollection<Teacher> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Teacher();
  object.id = id;
  object.name = reader.readString(offsets[0]);
  _teacherAttachLinks(collection, id, object);
  return object;
}

P _teacherDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _teacherSerializeWeb(
    IsarCollection<Teacher> collection, Teacher object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'name', object.name);
  return jsObj;
}

Teacher _teacherDeserializeWeb(
    IsarCollection<Teacher> collection, Object jsObj) {
  final object = Teacher();
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.name = IsarNative.jsObjectGet(jsObj, r'name') ?? '';
  _teacherAttachLinks(collection, IsarNative.jsObjectGet(jsObj, r'id'), object);
  return object;
}

P _teacherDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'name':
      return (IsarNative.jsObjectGet(jsObj, r'name') ?? '') as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _teacherAttachLinks(IsarCollection<dynamic> col, int id, Teacher object) {
  object.course.attach(col, col.isar.courses, r'course', id);
}

extension TeacherQueryWhereSort on QueryBuilder<Teacher, Teacher, QWhere> {
  QueryBuilder<Teacher, Teacher, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TeacherQueryWhere on QueryBuilder<Teacher, Teacher, QWhereClause> {
  QueryBuilder<Teacher, Teacher, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TeacherQueryFilter
    on QueryBuilder<Teacher, Teacher, QFilterCondition> {
  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension TeacherQueryLinks
    on QueryBuilder<Teacher, Teacher, QFilterCondition> {
  QueryBuilder<Teacher, Teacher, QAfterFilterCondition> course(
      FilterQuery<Course> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(
        query.collection.isar.courses,
        q,
        r'course',
      );
    });
  }
}

extension TeacherQueryWhereSortBy on QueryBuilder<Teacher, Teacher, QSortBy> {
  QueryBuilder<Teacher, Teacher, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension TeacherQueryWhereSortThenBy
    on QueryBuilder<Teacher, Teacher, QSortThenBy> {
  QueryBuilder<Teacher, Teacher, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Teacher, Teacher, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension TeacherQueryWhereDistinct
    on QueryBuilder<Teacher, Teacher, QDistinct> {
  QueryBuilder<Teacher, Teacher, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension TeacherQueryProperty
    on QueryBuilder<Teacher, Teacher, QQueryProperty> {
  QueryBuilder<Teacher, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Teacher, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
