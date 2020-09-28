import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qutub_clinet/Providers/addressProvider.dart';
import 'package:qutub_clinet/Providers/cartItemsCounterProvider.dart';
import 'package:qutub_clinet/Providers/counrtyCodeProvider.dart';
import 'package:qutub_clinet/Providers/userProvider.dart';

import 'Providers/bottomNavProvider.dart';
import 'ui/splash.dart';

void main(){

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: BottomNavProvider()),
        ChangeNotifierProvider.value(value: CountryCodeProvider()),
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: CartCounterProvider()),
         ChangeNotifierProvider.value(value: AddressProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'ar',
        ),
        home: Splash(),
      ),
    ));


} 