import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projecture/utils/color_utils.dart';

import 'package:projecture/view/auth/Drawer_BottomNavbar_screen.dart';
import 'package:projecture/view/auth/checking_screen.dart';
import 'package:projecture/view/auth/company_list_screen.dart';
import 'package:projecture/view/auth/done_screen.dart';
import 'package:projecture/view/auth/events/christmasEvent_screen.dart';
import 'package:projecture/view/auth/events/deepavaliEvent_screen.dart';
import 'package:projecture/view/auth/events/holiEvents_screen.dart';
import 'package:projecture/view/auth/events/independenceEvent_screen.dart';
import 'package:projecture/view/auth/events_screen.dart';
import 'package:projecture/view/auth/history_screen.dart';
import 'package:projecture/view/auth/home_screen.dart';
import 'package:projecture/view/auth/inprocess_screen.dart';
import 'package:projecture/view/auth/issue_screen.dart';
import 'package:projecture/view/auth/notice_list_screen.dart';
import 'package:projecture/view/auth/profile_screen.dart';
import 'package:projecture/view/auth/register_screen.dart';
import 'package:projecture/view/auth/splash_screen.dart';
import 'package:projecture/view/auth/splash_screen.dart';
import 'package:projecture/view/auth/todo_screen.dart';
import 'package:projecture/view/auth/wallet_screen.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GetMaterialApp(
          title: 'Projecture',
          theme: ThemeData(
            progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: ColorUtils.primaryColor),
          ),
          debugShowCheckedModeBanner: false,
          // smartManagement: SmartManagement.full,
          home: SplashScreen(),
          //home: EventScreen(),
          //home: CompanyListScreen(),
        );
      },
    );
  }
}
