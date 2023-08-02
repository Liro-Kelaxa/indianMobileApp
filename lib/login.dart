// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   late String _email, _password;
//   // final TextEditingController emailController = TextEditingController();
//   // String get email {
//   //   return emailController.text.toString();
//   // }

//   // String get password {
//   //   return passwordController.text.toString();
//   // }

//   // final TextEditingController passwordController = TextEditingController();

//   void signIn() async {
//     await FirebaseAuth.instance
//         .signInWithEmailAndPassword(email: _email, password: _password)
//         .catchError((onError) {
//       print(onError);
//     }).then((authUser) {
//       print(authUser.user?.uid);
// // b5MamPGxzaeMf6Ov454Ine8s7dD3
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 onSaved: (value) {
//                   _email = value!;
//                 },
//                 // controller: emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                 ),
//               ),
//               SizedBox(height: 16.0),
//               TextFormField(
//                 onSaved: (value) {
//                   _password = value!;
//                 },
//                 // controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                 ),
//               ),
//               SizedBox(height: 24.0),
//               ElevatedButton(
//                 onPressed: () {
//                   if (formKey.currentState!.validate()) {
//                     formKey.currentState?.save();
//                     signIn();
//                   }
//                   // Implement the login process here
//                   // String email = emailController.text.trim();
//                   // String password = passwordController.text.trim();
//                   // Call the login function here, e.g., loginWithEmailAndPassword(email, password);
//                 },
//                 child: Text('Login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_translate/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  bool passwordVisible = true;

  // Future<void> signInWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //     if (googleSignInAccount != null) {
  //       GoogleSignInAuthentication googleSignInAuthentication =
  //           await googleSignInAccount.authentication;
  //       AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );
  //       UserCredential authResult =
  //           await _auth.signInWithCredential(credential);
  //       User? user = authResult.user;
  //       if (user != null) {
  //         print("User Name: ${user.displayName}");
  //         print("User Email ${user.email}");
  //         // Navigate to your desired screen after successful authentication.
  //         // For example, you can uncomment the lines below to navigate to a home page:
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => HomePage()),
  //         // );
  //       }
  //     }
  //   } catch (e) {
  //     print("Error during Google sign-in: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 224, 218),
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              obscureText: passwordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.black),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  child: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 200),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.all(15)),
              onPressed: () {
                //  Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const HomePage()),
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
