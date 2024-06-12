import 'package:get/get.dart';

import '../modules/absensi/bindings/absensi_binding.dart';
import '../modules/absensi/views/absensi_view.dart';
import '../modules/absent/bindings/absent_binding.dart';
import '../modules/absent/views/absent_view.dart';
import '../modules/add_pegawai/bindings/add_pegawai_binding.dart';
import '../modules/add_pegawai/views/add_pegawai_view.dart';
import '../modules/all_presensi/bindings/all_presensi_binding.dart';
import '../modules/all_presensi/views/all_presensi_view.dart';
import '../modules/all_user/bindings/all_user_binding.dart';
import '../modules/all_user/views/all_user_view.dart';
import '../modules/clock_in/bindings/clock_in_binding.dart';
import '../modules/clock_in/views/clock_in_view.dart';
import '../modules/clock_out/bindings/clock_out_binding.dart';
import '../modules/clock_out/views/clock_out_view.dart';
import '../modules/detail_absen/user/bindings/detail_absen_user_binding.dart';
import '../modules/detail_absen/user/views/detail_absen_user_view.dart';
import '../modules/detail_presensi/bindings/detail_presensi_binding.dart';
import '../modules/detail_presensi/views/detail_presensi_view.dart';
import '../modules/export/bindings/export_binding.dart';
import '../modules/export/views/export_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/new_password/bindings/new_password_binding.dart';
import '../modules/new_password/views/new_password_view.dart';
import '../modules/op/bindings/op_binding.dart';
import '../modules/op/views/op_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ADD_PEGAWAI,
      page: () => AddPegawaiView(),
      binding: AddPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => const NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENSI,
      page: () => DetailPresensiView(),
      binding: DetailPresensiBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRESENSI,
      page: () => const AllPresensiView(),
      binding: AllPresensiBinding(),
    ),
    GetPage(
      name: _Paths.ABSENSI,
      page: () => AbsensiView(),
      binding: AbsensiBinding(),
    ),
    GetPage(
      name: _Paths.CLOCK_IN,
      page: () => ClockInView(),
      binding: ClockInBinding(),
    ),
    GetPage(
      name: _Paths.CLOCK_OUT,
      page: () => const ClockOutView(),
      binding: ClockOutBinding(),
    ),
    GetPage(
      name: _Paths.ALL_USER,
      page: () => const AllUserView(),
      binding: AllUserBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_ABSEN_USER,
      page: () => DetailAbsenUserView(),
      binding: DetailAbsenUserBinding(),
    ),
    GetPage(
      name: _Paths.ABSENT,
      page: () => AbsentView(),
      binding: AbsentBinding(),
    ),
    GetPage(
      name: _Paths.OP,
      page: () => const OpView(),
      binding: OpBinding(),
    ),
    GetPage(
      name: _Paths.EXPORT,
      page: () => const ExportView(),
      binding: ExportBinding(),
    ),
  ];
}
