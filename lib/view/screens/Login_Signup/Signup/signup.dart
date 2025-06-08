import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/utils/validation_utils.dart';
import 'package:meal_app/view/screens/Login_Signup/Login/login.dart';
import 'package:meal_app/viewmodels/signup_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  final bool showAdminOption; 

  const SignUpScreen({super.key, this.showAdminOption = false});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isAdminAccount = false; 
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _gender = ['Male', 'Female'];
  String? _selectedGender;
  DateTime? _selectedDate;

  void _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (!ValidationUtils.isValidText(name)) {
      _nameFocusNode.requestFocus();
      _showFieldError("Please enter a valid name");
      return;
    }

    if (!ValidationUtils.isValidEmail(email)) {
      _emailFocusNode.requestFocus();
      _showFieldError("Please enter a valid email address");
      return;
    }

    if (!ValidationUtils.isValidPhoneNumber(phone)) {
      _phoneFocusNode.requestFocus();
      _showFieldError("Please enter a valid phone number");
      return;
    }

    if (!ValidationUtils.isValidPassword(password)) {
      _passwordFocusNode.requestFocus();
      _showFieldError("Password must meet complexity requirements");
      return;
    }

    if (password != confirmPassword) {
      _confirmPasswordFocusNode.requestFocus();
      _showFieldError("Passwords do not match");
      return;
    }

    if (_selectedGender == null) {
      _showFieldError("Please select a gender");
      return;
    }

    if (_selectedDate == null) {
      _showFieldError("Please select your date of birth");
      return;
    }

    final vm = SignUpViewModel();
    String? result = await vm.registerUser(
      name: name,
      email: email,
      password: password,
      gender: _selectedGender!,
      dateOfBirth: _selectedDate!,
      isAdmin: _isAdminAccount,
      phoneNumber: phone,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Icon(
              result == null ? Icons.check_circle : Icons.error,
              color: result == null ? AppColors.success : AppColors.error,
            ),
            const SizedBox(width: 8),
            Text(
              result == null ? 'Success' : 'Error',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Text(
          result == null
              ? 'Account created successfully!'
              : 'Something went wrong:\n$result',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // closes dialog
              if (result == null) {
                Navigator.of(context).maybePop(); // goes back to previous screen (safely)
              }
            },
            child: const Text('OK', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showFieldError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.error,
      ),
    );
  }

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildField(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 8),
          field,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                //clipper: TopWaveClipper(),
                child: Container(
                  color: Colors.green,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  const Text('SignUp',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      )),
                  const SizedBox(height: 5),
                  Container(height: 2, width: 60, color: Colors.green),
                  const SizedBox(height: 30),

                  _buildField(
                    'Full Name',
                    TextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      decoration: const InputDecoration(border: UnderlineInputBorder())
                      ),
                  ),
                  _buildField(
                    'Email',
                    TextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(border: UnderlineInputBorder()),
                    ),
                  ),
                  _buildField(
                    'Phone Number',
                    TextField(
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(border: UnderlineInputBorder()),
                    ),
                  ),
                  _buildField(
                    'Gender',
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: _gender.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                      onChanged: (val) => setState(() => _selectedGender = val),
                      decoration: const InputDecoration(border: UnderlineInputBorder()),
                    ),
                  ),
                  _buildField(
                    'Date Of birth:',
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : '${_selectedDate!.toLocal()}'.split(' ')[0],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDate,
                          child: const Text("Pick Date"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildField(
                    'Password',
                    TextField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                  ),
                  _buildField(
                    'Confirm Password',
                    TextField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                  ),

                  if (widget.showAdminOption)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isAdminAccount,
                            onChanged: (val) {
                              setState(() {
                                _isAdminAccount = val ?? false;
                              });
                            },
                          ),
                          const Text("Create Admin Account"),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Create Account"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Login",
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class TopWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     path.lineTo(0, size.height - 50);
//     var controlPoint = Offset(size.width / 2, size.height);
//     var endPoint = Offset(size.width, size.height - 50);
//     path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
//}
