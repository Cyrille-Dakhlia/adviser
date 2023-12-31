import 'package:adviser/0_data/datasources/advice_remote_datasource.dart';
import 'package:adviser/0_data/exceptions/exceptions.dart';
import 'package:adviser/0_data/models/advice_model.dart';
import 'package:adviser/1_domain/entities/advice_entity.dart';
import 'package:adviser/1_domain/failures/failures.dart';
import 'package:adviser/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class AdviceRepoImpl implements AdviceRepo {
  final AdviceRemoteDataSource _adviceRemoteDataSource;

  AdviceRepoImpl({required AdviceRemoteDataSource adviceRemoteDataSource})
      : _adviceRemoteDataSource = adviceRemoteDataSource;

  @override
  Future<Either<AdviceEntity, Failure>> getAdviceFromDataSource() async {
    // we can check here if we have an Internet connection to choose the datasource (remote or local)
    try {
      final adviceModel =
          await _adviceRemoteDataSource.getRandomAdviceFromApi();
      return left(AdviceEntity(advice: adviceModel.advice, id: adviceModel.id));
    } on ServerException catch (_) {
      return right(ServerFailure());
    } on CacheException catch (_) {
      return right(CacheFailure());
    } catch (_) {
      return right(GeneralFailure());
    }
  }

  @override
  Future<bool> updateFavoritesInDataSource(
      List<AdviceEntity> updatedList) async {
    return await _adviceRemoteDataSource.updateFavoritesInDatabase(updatedList
        .map((ae) => AdviceModel(advice: ae.advice, id: ae.id))
        .toList());
    //TODO: handle exceptions
  }

  @override
  Future<List<AdviceEntity>> getFavoritesFromDataSource() async {
    try {
      final adviceModelList =
          await _adviceRemoteDataSource.getFavoritesFromDataSource();
      return adviceModelList
          .map((am) => AdviceEntity(advice: am.advice, id: am.id))
          .toList();
    } on Exception catch (e) {
      // TODO: handle exceptions
      debugPrint(e.toString());
      return List<AdviceEntity>.empty();
    }
  }
}
