import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kp_msiap/beranda.dart';
import 'package:kp_msiap/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CustomCacheManager.instance;
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uid = prefs.getString('uid');
  AwesomeNotifications().initialize(
      null,[NotificationChannel(
      channelKey: 'basic',
      channelName: 'Basic Notifikasi',
      channelDescription: 'Notifikasi aplikasi siap'),
  ],
    debug: true,
  );
  runApp( MaterialApp(
    home: uid == null? const login(): const Beranda(),
    builder: EasyLoading.init(),
  ));
}

class CustomCacheManager {
  static const key = 'gambar_key';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _login();
}

class _login extends State<login> {
  final bool islogin=true;
  final _formkey=GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Scaffold(
          backgroundColor: const Color(0xff4B5526),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
          child:SingleChildScrollView(
          child: SizedBox(
            height: 750,
            child:Form(
              key: _formkey,
              child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                //bg design, we use 3 svg img
                Positioned(
                  left: -26,
                  top: 51.0,
                  child: SvgPicture.string(
                    '<svg viewBox="-26.0 51.0 91.92 91.92" ><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -26.0, 96.96)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, -10.83, 105.24)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.707107, -0.707107, 0.707107, 0.707107, 16.51, 93.51)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 91.92,
                    height: 91.92,
                  ),
                ),
                Positioned(
                  right: 43.0,
                  top: -103,
                  child: SvgPicture.string(
                    '<svg viewBox="63.0 -103.0 268.27 268.27" ><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 63.0, 67.08)" d="M 147.2896423339844 0 L 196.3861999511719 98.19309997558594 L 147.2896423339844 196.3861999511719 L 49.09654235839844 196.3861999511719 L 0 98.19309234619141 L 49.09656143188477 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 113.73, 79.36)" d="M 0 0 L 83.46413421630859 33.38565444946289 L 166.9282684326172 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="matrix(0.5, -0.866025, 0.866025, 0.5, 184.38, 23.77)" d="M 0 111.9401321411133 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 268.27,
                    height: 268.27,
                  ),
                ),
                Positioned(
                  right: -19,
                  top: 31.0,
                  child: SvgPicture.string(
                    '<svg viewBox="329.0 31.0 65.0 65.0" ><path transform="translate(329.0, 31.0)" d="M 48.75 0 L 65 32.5 L 48.75 65 L 16.24999809265137 65 L 0 32.5 L 16.25000381469727 0 Z" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(333.88, 47.58)" d="M 0 0 L 27.625 11.05000019073486 L 55.25 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(361.5, 58.63)" d="M 0 37.04999923706055 L 0 0" fill="none" stroke="#ffffff" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 65.0,
                    height: 65.0,
                  ),
                ),

                //card and footer ui
                Positioned(
                  bottom: 20.0,
                  child: Column(
                    children: <Widget>[
                      buildCard(size),
                      buildFooter(size),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
        ),
      ),
      );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo & text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox( height: size.height * 0.14,),
                  SizedBox(
                    height: size.height * 0.04,
                    child: Image.asset(
                      'assets/logo_dahana.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.width * 0.02), // Spasi antara logo Dahana dan logo Dirgantara
              Column(
                children: [
                  SizedBox( height: size.height * 0.14,),
                  SizedBox(
                    height: size.height * 0.04,
                    child: Image.asset(
                      'assets/logo_dirgantara.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.width * 0.00), // Spasi antara logo Dahana dan logo Dirgantara
              Column(
                children: [
                  logo(size.height / 8, size.height / 8),
                  SizedBox(
                    height: size.height * 0.04,
                    child: Image.asset(
                      'assets/Logo_PT_Pindad_(Persero).png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.width * 0.02), // Spasi antara logo Dahana dan logo Dirgantara
              Column(
                children: [
                  SizedBox( height: size.height * 0.14,),
                  SizedBox(
                    height: size.height * 0.04,
                    child: Image.asset(
                      'assets/2560px-PT-PAL.svg.png',
                      width: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          richText(24),
          SizedBox(
            height: size.height * 0.05,
          ),

          //email & password textField
          emailTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          passwordTextField(size),
          SizedBox(
            height: size.height * 0.03,
          ),

          //sign in button
          signInButton(context, size),
        ],
      ),

    );
  }

  Widget buildFooter(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: size.height * 0.04,
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Text.rich(
          TextSpan(
            style: GoogleFonts.inter(
              fontSize: 12.0,
              color: Colors.white,
            ),
            children: [
              const TextSpan(
                text: 'Tidak Punya Akun? ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Daftar Disini',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>const register()));
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }


  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/Logo-Len.png',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: Colors.black,
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: emailController,
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: emailController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: emailController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(44, 185, 176, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(44, 185, 176, 1),
                )),
            prefixIcon: Icon(
              Icons.mail_outline_rounded,
              color: emailController.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: emailController.text.isEmpty
                  ? const Center()
                  : const Icon(
                Icons.check,
                color: Colors.white,
                size: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: passController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: passController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: passController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(44, 185, 176, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(44, 185, 176, 1),
                )),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: passController.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: passController.text.isEmpty
                  ? const Center()
                  : const Icon(
                Icons.check,
                color: Colors.white,
                size: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signInButton(BuildContext context,Size size) {
    return GestureDetector(
      onTap: ()=>handelsubmit(),
      child: Container(
      alignment: Alignment.center,
      height: size.height / 13,
      width: size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: const Color(0xff4B5526),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C2E84).withOpacity(0.2),
            offset: const Offset(0, 15.0),
            blurRadius: 60.0,
          ),
        ],
      ),
      child: Text(
        'Sign in',
        style: GoogleFonts.inter(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    );
  }

  Future handelsubmit() async {
    if (!_formkey.currentState!.validate()) return;
    final email = emailController.value.text;
    final password = passController.value.text;
    if(islogin && email.isNotEmpty && password.isNotEmpty){
        try {
          final userCredential = await auth().login(email, password);
          SharedPreferences preferences=await SharedPreferences.getInstance();
          preferences.setString('uid', userCredential!.user!.uid);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=>const Beranda()));
        } catch (error) {
          showSnackbar("Email atau password salah");
        }
    }else{
      showSnackbar("Email atau password tidak boleh kosong");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Gagal login',
          message: message,
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }






}