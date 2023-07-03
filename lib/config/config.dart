/// A Configuration Class that holds the `Google reCAPTCHA v3` API Confidential Information.
class Config {
  /// Prevents from object instantiation.
  Config._();

  /// Holds the 'Site Key' for the `Google reCAPTCHA v3` API .
  static const String siteKey = '6LdJxO8mAAAAANFdwyPTI0lUaY972EhxE7PSiV4k';

  /// Holds the 'Secret Key' for the `Google reCAPTCHA v3` API .
  static const String secretKey = '6LdJxO8mAAAAAPJcPSzK9OYTsI6AGB6My2ufAlMI';

  /// Holds the 'Verfication URL' for the `Google reCAPTCHA v3` API .
  static final verificationURL =
      Uri.parse('https://www.google.com/recaptcha/api/siteverify');
}
