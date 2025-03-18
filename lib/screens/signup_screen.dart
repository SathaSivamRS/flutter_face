import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../services/auth_service.dart';
import 'package:login/pages/home_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String passwordStrength = "";

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool isTempEmail(String email) {
    List<String> tempDomains = [
      "mailinator.com",
      "guerrillamail.com",
      "tempmail.com",
      "10minutemail.com",
      "emailondeck.com",
      "dispostable.com",
      "cybtric.com",
    ];
    String domain = email.split("@").last;
    return tempDomains.contains(domain);
  }

  void signup() async {
    if (!_formKey.currentState!.validate()) return;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (isTempEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Temporary emails are not allowed!")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "fullName": fullNameController.text.trim(),
          "email": email,
          "phone": phoneController.text.trim(),
          "createdAt": FieldValue.serverTimestamp(),
        });

        await user.sendEmailVerification(); // ✅ Verification Email Sent

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Verify your email before logging in!"),
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = "❌ Signup failed. Try again!";
      if (e.code == 'email-already-in-use') {
        message = "⚠️ This email is already in use!";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void signupWithGoogle() async {
    User? user = await _auth.signInWithGoogle();
    if (!mounted) return;

    if (user != null) {
      await user.reload();
      if (!user.emailVerified) {
        await user
            .sendEmailVerification(); // ✅ Google Users Also Need Email Verification
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ Check your email and verify first!"),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    }
  }

  void checkPasswordStrength(String password) {
    if (password.length < 6) {
      setState(() => passwordStrength = "Weak ❌");
    } else if (password.length < 10) {
      setState(() => passwordStrength = "Medium ⚠️");
    } else {
      setState(() => passwordStrength = "Strong ✅");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildTextField(
                      fullNameController,
                      "Full Name",
                      Icons.person,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(emailController, "Email", Icons.email),
                    const SizedBox(height: 12),
                    _buildPhoneField(),
                    const SizedBox(height: 12),
                    _buildPasswordField(),
                    const SizedBox(height: 12),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 20),
                    _buildSignupButton(),
                    const SizedBox(height: 10),
                    _buildGoogleButton(),
                    const SizedBox(height: 10),
                    _buildLoginText(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const [
        Icon(Icons.person_add, size: 80, color: Colors.white),
        SizedBox(height: 10),
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty ? "This field is required" : null,
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      controller: phoneController,
      initialCountryCode: "IN",
      disableLengthCheck: true,
      decoration: InputDecoration(
        hintText: "Phone Number",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      onChanged: checkPasswordStrength,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.deepPurple,
          ),
          onPressed:
              () => setState(() => isPasswordVisible = !isPasswordVisible),
        ),
        hintText: "Password",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !isConfirmPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
        suffixIcon: IconButton(
          icon: Icon(
            isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.deepPurple,
          ),
          onPressed:
              () => setState(
                () => isConfirmPasswordVisible = !isConfirmPasswordVisible,
              ),
        ),
        hintText: "Confirm Password",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return ElevatedButton(onPressed: signup, child: const Text("Sign Up"));
  }

  Widget _buildGoogleButton() {
    return ElevatedButton.icon(
      onPressed: signupWithGoogle,
      icon: Image.asset('assets/google_logo.png', height: 24),
      label: const Text("Sign in with Google"),
    );
  }

  Widget _buildLoginText() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text("Already have an account? Login"),
    );
  }
}
