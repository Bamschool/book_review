import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:review_book/firebase_options.dart';
import 'package:review_book/src/Init/cubit/init_cubit.dart';
import 'package:review_book/src/app.dart';
import 'package:review_book/src/common/cubit/app_data_load_cubit.dart';
import 'package:review_book/src/common/cubit/authentication_cubit.dart';
import 'package:review_book/src/common/cubit/upload_data_load.cubut.dart';
import 'package:review_book/src/common/interceptor/custom_interceptor.dart';
import 'package:review_book/src/common/repository/authentication_repository.dart';
import 'package:review_book/src/common/repository/naver_api_repository.dart';
import 'package:review_book/src/common/repository/user_repository.dart';
import 'package:review_book/src/spalsh/cubit/cubit/spalsh_cubit_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  Dio dio = Dio(BaseOptions(baseUrl: 'https://openapi.naver.com/'));
  dio.interceptors.add(CustomInterCeptor());
  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;
  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    var stroage = FirebaseStorage.instance;
    // return const App();
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => NaverBookRepository(dio),
          ),
          RepositoryProvider(
            create: (context) =>
                AuthenticationRepository(FirebaseAuth.instance),
          ),
          RepositoryProvider(
            create: (context) => UserRepository(db),
          ),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => SplashCubit(),
          ),
          BlocProvider(
            create: (context) => AuthenticationCubit(
              context.read<AuthenticationRepository>(),
              context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => InitCubit(),
          ),
          BlocProvider(
            create: (context) => UploadCubit(stroage),
          ),
          BlocProvider(
            create: (context) => AppDataLoadCubit(),
            lazy: false,
          )
        ], child: const App())
        //  MultiBlocProvider(
        //   providers: const [],
        //   child: const App(),
        // ),
        );
  }
}
