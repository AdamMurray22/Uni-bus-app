import 'package:app/Screen/navigation_bar_item.dart';
import 'package:test/test.dart';

void main() {
  group('Navigation Bar Item Tests', () {

    test('.getSelectedIndex() default value', () {
      expect(NavigationBarItem.getSelectedIndex(), 0);
    });

    test('.getSelectedIndex() value changed', () {
      NavigationBarItem.setSelectedIndex(3);
      expect(NavigationBarItem.getSelectedIndex(), 3);
    });

    test('.getValuesInOrder() default nav bar items', () {
      expect(NavigationBarItem.getValuesInOrder(), [
        NavigationBarItem.mapScreen,
        NavigationBarItem.routeScreen,
        NavigationBarItem.timetableScreen,
        NavigationBarItem.aboutScreen
      ]);
    });

    test('.getValuesInOrder() default nav bar items', () {
      expect(NavigationBarItem.getScreensInOrder(), [
        NavigationBarItem.mapScreen.screen,
        NavigationBarItem.routeScreen.screen,
        NavigationBarItem.timetableScreen.screen,
        NavigationBarItem.aboutScreen.screen
      ]);
    });
  });
}