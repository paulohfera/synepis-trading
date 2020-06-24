import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synepistrading/core/network/network_info.dart';

class MockDataConnectioChecker extends Mock implements Connectivity {}

void main() {
  NetworkInfo networkInfo;
  MockDataConnectioChecker mockDataConnectioChecker;

  setUp(() {
    mockDataConnectioChecker = MockDataConnectioChecker();
    networkInfo = NetworkInfo(mockDataConnectioChecker);
  });

  test(
    "should forward the call to DataConnectionChecker.hasConnection",
    () async {
      // arrange
      final hasConnectionFuture = Future.value(ConnectivityResult.mobile);

      when(mockDataConnectioChecker.checkConnectivity())
          .thenAnswer((_) => hasConnectionFuture);
      // act
      final result = networkInfo.isConnected;
      //assert
      verify(mockDataConnectioChecker.checkConnectivity());
      expect(result, isInstanceOf<Future<bool>>());
    },
  );
}
