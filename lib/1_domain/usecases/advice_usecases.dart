import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceUseCases {
  final AdviceRepo _adviceRepo;

  AdviceUseCases({required AdviceRepo adviceRepo}) : _adviceRepo = adviceRepo;

  Future<Either<AdviceEntity, Failure>> getAdvice() async {
    // business logic should be done here
    return _adviceRepo.getAdviceFromDataSource();
  }

  Future<bool> updateFavoritesInDataSource(List<AdviceEntity> updatedList) {
    return _adviceRepo.updateFavoritesInDataSource(updatedList);
  }

  Future<List<AdviceEntity>> getFavoritesFromDataSource() {
    return _adviceRepo.getFavoritesFromDataSource();
  }

  bool checkIfAdviceAlreadyInFavorites(
      int newAdviceId, List<AdviceEntity> favorites) {
    return favorites.any((advice) => advice.id == newAdviceId);
  }

  List<AdviceEntity> addAdviceToFavorites(
      AdviceEntity newAdvice, List<AdviceEntity> favorites) {
    return [...favorites, newAdvice];
  }

  List<AdviceEntity> removeFromFavorites(
      int adviceId, List<AdviceEntity> favorites) {
    favorites.removeWhere((advice) => advice.id == adviceId);
    return List.from(favorites);
  }
}
