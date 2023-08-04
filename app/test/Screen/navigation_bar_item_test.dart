import 'package:app/Screen/navigation_bar_items.dart';
import 'package:test/test.dart';

void main() {
  group('Navigation Bar Item Tests', () {

    test('.getSelectedIndex() default value', () {
      NavigationBarItems navigationBarItems = NavigationBarItems(mapScreenFunction: () {});
      expect(navigationBarItems.getSelectedIndex(), 0);
    });

    test('.getSelectedIndex() value changed', () {
      NavigationBarItems navigationBarItems = NavigationBarItems(mapScreenFunction: () {});
      navigationBarItems.setSelectedIndex(3);
      expect(navigationBarItems.getSelectedIndex(), 3);
    });

    test('.getValuesInOrder() default nav bar items', () {
      NavigationBarItems navigationBarItems = NavigationBarItems(mapScreenFunction: () {});
      expect(navigationBarItems.getValuesInOrder(), [
        navigationBarItems.mapScreen,
        navigationBarItems.routeScreen,
        navigationBarItems.timetableScreen,
        navigationBarItems.aboutScreen
      ]);
    });

    test('.getValuesInOrder() default nav bar items', () {
      NavigationBarItems navigationBarItems = NavigationBarItems(mapScreenFunction: () {});
      expect(navigationBarItems.getScreensInOrder(), [
        navigationBarItems.mapScreen.item2,
        navigationBarItems.routeScreen.item2,
        navigationBarItems.timetableScreen.item2,
        navigationBarItems.aboutScreen.item2
      ]);
    });
  });
}