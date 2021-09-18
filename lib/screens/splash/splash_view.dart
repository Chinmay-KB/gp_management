import 'package:flutter/material.dart';
import 'package:gp_management/screens/splash/splash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      viewModelBuilder: () => SplashViewModel(),
      onModelReady: (model) => model.init(),
      builder: (
        BuildContext context,
        SplashViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'GP Management',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (!model.isBusy)
                  Align(
                    alignment: Alignment(0, 0.8),
                    child: GestureDetector(
                      onTap: model.onLogin,
                      child: AnimatedOpacity(
                        duration: Duration(seconds: 2),
                        opacity: model.isLoggedIn ? 0 : 1,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Image.asset(
                                    'images/google_icon.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    'Sign in with Google',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
