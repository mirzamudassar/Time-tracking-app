import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:time_tracking_app/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);

class $initGetIt {
  $initGetIt(this.getIt);

  final GetIt getIt;

  void call() {
    _registerDependencies();
  }

  void _registerDependencies() {
    getIt.init(environment: 'dev');
  }
}