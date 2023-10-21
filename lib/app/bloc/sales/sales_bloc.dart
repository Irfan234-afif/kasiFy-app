// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';

import 'package:kasir_app/app/model/sales_model.dart';
import 'package:kasir_app/app/repository/sales_repository.dart';
import 'package:meta/meta.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final SalesRepository _salesRepository = SalesRepository();
  SalesBloc() : super(SalesInitial()) {
    on<SalesGetEvent>((event, emit) async {
      emit(SalesLoadingState());
      print('sales get');
      try {
        final res = await _salesRepository.getSales(event.email);
        // creating data
        // List<SalesModel> salesModel = [];
        // if (res.statusCode != 404) {
        //   // creating data
        //   salesModel = salesModelFromList(res.data['data']);
        // }
        // // sorting by created_at
        res?.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        // emit
        emit(SalesLoadedState(salesModel: res));
      } catch (e) {
        print("Sales Bloc : $e");
        emit(const SalesErrorState('Terjadi Kesalahan'));
      }
    });
    on<SalesAddEvent>((event, emit) async {
      List<SalesModel> data = List.from(state.salesModel ?? []);
      try {
        emit(SalesLoadingState());

        // final res = await _salesRepository.addSales(
        //   email: event.email,
        //   data: event.data,
        // );

        // if (res != null) {
        data.add(event.data);
        data.sort(
          (a, b) => b.createdAt!.compareTo(a.createdAt!),
        );

        emit(SalesLoadedState(salesModel: data));
        // } else {
        //   emit(SalesErrorState('Error'));
        // }
      } catch (e) {
        print(e);
        emit(SalesErrorState("Error $e"));
      }
    });
    // on<SalesGetTodayEvent>((event, emit) async {
    //   emit(SalesLoadingState());
    //   try {
    //     final res = await _salesRepository.getTodaySales(event.email);
    //     List<SalesModel> salesModel = [];
    //     if (res.statusCode != 404) {
    //       // creating data
    //       salesModel.add(SalesModel.fromJson(res.data['data']));
    //     }
    //     // emit
    //     emit(SalesLoadedState(salesModel: salesModel));
    //   } on DioException catch (e) {
    //     if (e.response != null) {
    //       if (e.response!.statusMessage == 'Unauthenticated') {
    //         emit(SalesErrorState(e.response!.statusMessage!));
    //       }
    //     } else {
    //       emit(const SalesErrorState('Terjadi kesalahan'));
    //     }
    //   } catch (e) {
    //     print(e);
    //     emit(const SalesErrorState('Terjadi Kesalahan'));
    //   }
    // });
  }
}
