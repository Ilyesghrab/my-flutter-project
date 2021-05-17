import 'package:bloc/bloc.dart';
import 'package:myapp/pages/CategoriesPage.dart';
import 'package:myapp/pages/HomePage.dart';
import 'package:myapp/List/mylist.dart';
import 'package:myapp/Scanner/scan.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  //MyAccountClickedEvent,
  MyOrdersClickedEvent,
  MyScannerClickedEvent,
  MyLogOutClickedEvent,
  MyListClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => CategoriesPage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield CategoriesPage();
        break;
      /* case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPageState();
        break;*/
      case NavigationEvents.MyOrdersClickedEvent:
        yield ScanPage();
        break;
      case NavigationEvents.MyScannerClickedEvent:
        yield ScanPage();
        break;
      case NavigationEvents.MyLogOutClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyListClickedEvent:
        yield MyList();
        break;
    }
  }
}
