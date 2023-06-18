import 'package:fpdart/fpdart.dart';

import 'package:reddit_clone/core/failure.dart';

/// Example:
///
/// FutureEither<UserModel> => Future<Either<Failure, UserModel>>
typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureEitherVoid = FutureEither<void>;

/// IsLloading , true or false
typedef IsLoading = bool;
