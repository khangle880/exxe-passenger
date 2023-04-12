enum Gender {
  male,
  female,
  noInfo,
}

extension GenderExt on Gender {
  String get name {
    switch (this) {
      case Gender.male:
        return 'Nam';
      case Gender.female:
        return 'Nữ';
      case Gender.noInfo:
        return 'Khác';
    }
  }
}

// Giới tính. Lấy một trong 2 giá trị sau:
// ---- male: Nam
// ---- female: Nữ
// ---- no_info:Không cung cấp

enum MethodLogin { checkPhone, phoneAndPassword }

enum CarAccountType { carDriver, customer }

enum VerifyState { draft, waiting, verify }

enum CallDataApiType { get, update, create }

// "Loại quan hệ với Chủ tài khoản. Nhận 1 trong các giá trị sau:
// ____ parent_relationship      : Quan hệ Cha/Mẹ
// ____ connubial_relationship: Quan hệ Vợ/Chồng
// ____ sibling_relationship       : Quan hệ Anh/Chị/Em "
enum Relationship {
  parentRelationship,
  connubialRelationship,
  siblingRelationship,
}

extension RelationshipExt on Relationship {
  String get name {
    switch (this) {
      case Relationship.parentRelationship:
        return "Cha/Mẹ";
      case Relationship.connubialRelationship:
        return "Vợ/Chồng";
      case Relationship.siblingRelationship:
        return "Anh/Chị/Em";
    }
  }
}
