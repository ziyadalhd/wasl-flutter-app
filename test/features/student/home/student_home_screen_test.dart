import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasl/features/student/home/presentation/pages/student_home_screen.dart';
import 'package:wasl/features/student/home/presentation/widgets/student_app_bar.dart';
import 'package:wasl/features/student/home/presentation/widgets/section_header.dart';
import 'package:wasl/features/student/home/presentation/widgets/listing_card.dart';
import 'package:wasl/features/student/home/presentation/widgets/promo_banner.dart';

// Simple transparent 1x1 pixel GIF
final List<int> _transparentImage = <int>[
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x21, 0xf9, 0x04, 0x01, 0x00, 0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00,
  0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3b
];

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('StudentHomeScreen displays all main components', (WidgetTester tester) async {
    // Provide a MediaQuery to ensure layout works (though MaterialApp usually does this)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StudentHomeScreen()),
      ),
    );

    // Verify StudentAppBar is present
    expect(find.byType(StudentAppBar), findsOneWidget);

    // Verify SectionHeaders are present (Housing and Transport)
    expect(find.byType(SectionHeader), findsNWidgets(2));
    expect(find.text('السكن'), findsOneWidget);
    expect(find.text('النقل'), findsOneWidget);

    // Verify ListingCards are present
    expect(find.byType(ListingCard), findsWidgets);

    // Scroll to see PromoBanner if needed
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
    await tester.pump();
    
    expect(find.byType(PromoBanner), findsOneWidget);

    // Verify BottomNavigationBar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool get autoUncompress => true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 404;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([_transparentImage])
        .listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}
