import '../authentication/authentication_provider.dart';
import 'admin_user_repository.dart';

class AdminUserController {
  late AuthenticationProvider adminProvider;
  late AdminUserRepository adminRepository;

  AdminUserController(
      {required this.adminProvider, AdminUserRepository? repository}) {
    adminRepository = repository ?? AdminUserRepository();
  }
}
