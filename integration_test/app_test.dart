import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_preview_app/common/widget/c_link_preview_widget.dart';
import 'package:url_preview_app/common/widget/custom_button.dart';
import 'package:url_preview_app/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add and view category', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Find and tap the button to add a category
    final addCategoryButton = find.byType(Button);
    await tester.tap(addCategoryButton);
    await tester.pumpAndSettle();

    // Find the text field and enter a category name
    final categoryTextField = find.byType(TextField);
    await tester.enterText(categoryTextField, 'Test Category');
    await tester.pumpAndSettle();

    // Find and tap the "Save" button
    final saveButton = find.text('Save');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    // Find the category tile
    final categoryTile = find.text('Test Category');
    expect(categoryTile, findsOneWidget);
  });

  testWidgets('Add and view url', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Add category
    await addCategory(tester);

    // Find the button to add an url
    final addUrlButton = find.byType(Button).first;
    await tester.tap(addUrlButton);
    await tester.pumpAndSettle();

    // Find textfield and enter an url
    final urlTextField = find.byType(TextField);
    await tester.enterText(
        urlTextField, 'https://www.youtube.com/watch?v=_EYk-E29edo');
    await tester.pumpAndSettle();

    // Find and tap the "Save" button
    final saveUrlButton = find.text('Save');
    await tester.tap(saveUrlButton);
    await tester.pumpAndSettle();

    // Waiting for the url data to be fetched
    await Future.delayed(
        const Duration(seconds: 1), () async => await tester.pumpAndSettle());

    // Find the url tile
    final urlTile = find.byType(CustomLinkPreviewWidget);
    expect(urlTile, findsOneWidget);
  });

  testWidgets('Show a snackbar when adding an invalid link',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Add category
    await addCategory(tester);

    // Find the button to add an url
    final addUrlButton = find.byType(Button).first;
    await tester.tap(addUrlButton);
    await tester.pumpAndSettle();

    // Find textfield and enter an invalid links url
    final urlTextField = find.byType(TextField);
    await tester.enterText(urlTextField, 'invalid_link');
    await tester.pumpAndSettle();

    // Find and tap the "Save" button
    final saveUrlButton = find.text('Save');
    await tester.tap(saveUrlButton);
    await tester.pumpAndSettle();

    // Find the url tile
    final snackBar = find.byType(SnackBar);
    expect(snackBar, findsOneWidget);
  });
}

Future<void> addCategory(WidgetTester tester) async {
  // Find and tap the button to add category
  final addCategoryButton = find.byType(Button);
  await tester.tap(addCategoryButton);
  await tester.pumpAndSettle();

  // Find the text field and enter a category name
  final categoryTextField = find.byType(TextField);
  await tester.enterText(categoryTextField, 'Test Category');
  await tester.pumpAndSettle();

  // Find and tap the "Save" button
  final saveCategoryButton = find.text('Save');
  await tester.tap(saveCategoryButton);
  await tester.pumpAndSettle();

  // Find the category tile
  final categoryTile = find.text('Test Category');
  expect(categoryTile, findsOneWidget);

  // Find and tap the ExpansionTile to add a url
  final testCategoryExpansionTile = find.byType(ExpansionTile);
  await tester.tap(testCategoryExpansionTile);
  await tester.pumpAndSettle();
}
