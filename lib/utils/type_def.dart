import 'package:fpdart/fpdart.dart';
import 'package:reddit/utils/failuer.dart';

typedef FutureEither<T>=Future<Either<Failure,T>>;
typedef FutureVoid =FutureEither<void>;