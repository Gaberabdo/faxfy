class UserRoleEntities {
  final List<Roles> role;

  UserRoleEntities({required this.role});
}

enum Roles { read, write, create, edit ,follow}
