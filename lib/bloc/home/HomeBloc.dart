import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rentry/model/RegisterReq.dart';
import 'package:flutter_rentry/repository/AuthenticationRepository.dart';
import 'package:flutter_rentry/repository/HomeRepository.dart';
import 'HomeEvent.dart';
import 'package:flutter_rentry/bloc/authentication/AuthenticationState.dart';

import 'HomeState.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository;

  AuthenticationBloc() {
    homeRepository = HomeRepository();
  }

  @override
  HomeState get initialState => InitialHomeState();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is InitialEvent) {
      yield InitialHomeState();
    } else if (event is HomeReqAuthenticationEvent) {
      yield ProgressState();
      yield* callHomeApi(event.token);
    } else if (event is ItemDetailReqEvent) {
      yield ProgressState();
      yield* callItemDetailApi(event.token, event.categoryName);
    } else if (event is LocationSeachReqEvent) {
      yield ProgressState();
      yield* callLocatinoSearchApi(event.token, event.seachKey);
    } else if (event is SubCategorySearchReqEvent) {
      yield ProgressState();
      yield* callSubCategorySearchApi(event.token, event.seachKey);
    } else if (event is SubCategoryListReqEvent) {
      yield ProgressState();
      yield* callSubCategoryListApi(event.token, event.categoryId);
    }
  }

  Stream<HomeState> callHomeApi(String token) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "HOME_API_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final homeResponse = await homeRepository.callHomeApi(token);
      debugPrint("HOME_API_CALL_RES ${jsonEncode(homeResponse)}");
      yield HomeResState(res: homeResponse);
    } catch (e) {
      debugPrint("Exception while Home ${e.toString()}");
    }
  }

  Stream<HomeState> callItemDetailApi(
      String token, String categoryName) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "HOME_API_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final itemDetailResponse =
          await homeRepository.callItemDetailApi(token, categoryName);
      debugPrint("ITEMDETAIL_API_CALL_RES ${jsonEncode(itemDetailResponse)}");
      yield ItemDetailResState(res: itemDetailResponse);
    } catch (e) {
      debugPrint("Exception while itemDetail ${e.toString()}");
    }
  }

  Stream<HomeState> callLocatinoSearchApi(
      String token, String searchKey) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "LocatinoSeach_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final locationSearchResponse =
          await homeRepository.callLocaitonSearchApi(token, searchKey);
      debugPrint("LocatinoSeach_API_CALL_RES ${jsonEncode(locationSearchResponse)}");
      yield LocationSearchResState(res: locationSearchResponse);
    } catch (e) {
      debugPrint("Exception while LocatinoSeach ${e.toString()}");
    }
  }

  Stream<HomeState> callSubCategorySearchApi(
      String token, String searchKey) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "SubCategorySeach_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final subCategorySearchResponse =
          await homeRepository.callLocaitonSearchApi(token, searchKey);
      debugPrint("subCategorySearchResponse ${jsonEncode(subCategorySearchResponse)}");
      yield SubCategorySearchResState(res: subCategorySearchResponse);
    } catch (e) {
      debugPrint("Exception while subCategorySearchResponse ${e.toString()}");
    }
  }

  Stream<HomeState> callSubCategoryListApi(
      String token, String categoryId) async* {
    try {
      homeRepository =
          homeRepository != null ? homeRepository : HomeRepository();
      debugPrint(
          "SubCategorySeach_CALL ${token} ${homeRepository == null ? "NULL" : "NOTNULL"}");
      final subCategoryListResponse =
          await homeRepository.callSubCategoryListApi(token, categoryId);
      debugPrint("subCategorySearchResponse ${jsonEncode(subCategoryListResponse)}");
      yield SubCategoryListResState(res: subCategoryListResponse);
    } catch (e) {
      debugPrint("Exception while subCategoryListResponse ${e.toString()}");
    }
  }


}
