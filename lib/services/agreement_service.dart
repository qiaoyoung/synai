import 'package:shared_preferences/shared_preferences.dart';

class AgreementService {
  static const String _agreedToTermsKey = 'agreed_to_terms';
  
  // Check if user has agreed to terms
  Future<bool> hasUserAgreedToTerms() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_agreedToTermsKey) ?? false;
  }
  
  // Save user agreement status
  Future<void> saveAgreementStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_agreedToTermsKey, status);
  }
} 