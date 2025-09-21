import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common texts
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get welcomeBack =>
      _localizedValues[locale.languageCode]!['welcome_back']!;
  String get signInToContinue =>
      _localizedValues[locale.languageCode]!['sign_in_to_continue']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get forgotPassword =>
      _localizedValues[locale.languageCode]!['forgot_password']!;
  String get invalidCredentials =>
      _localizedValues[locale.languageCode]!['invalid_credentials']!;

  // Role names
  String get ngo => _localizedValues[locale.languageCode]!['ngo']!;
  String get admin => _localizedValues[locale.languageCode]!['admin']!;
  String get company => _localizedValues[locale.languageCode]!['company']!;

  // Carbon restoration project types
  String get treePlantation =>
      _localizedValues[locale.languageCode]!['tree_plantation']!;
  String get mangroveRestoration =>
      _localizedValues[locale.languageCode]!['mangrove_restoration']!;
  String get forestConservation =>
      _localizedValues[locale.languageCode]!['forest_conservation']!;
  String get agroforestry =>
      _localizedValues[locale.languageCode]!['agroforestry']!;
  String get wetlandRestoration =>
      _localizedValues[locale.languageCode]!['wetland_restoration']!;
  String get grasslandRestoration =>
      _localizedValues[locale.languageCode]!['grassland_restoration']!;

  // Project related
  String get projects => _localizedValues[locale.languageCode]!['projects']!;
  String get submitProject =>
      _localizedValues[locale.languageCode]!['submit_project']!;
  String get projectTitle =>
      _localizedValues[locale.languageCode]!['project_title']!;
  String get projectDescription =>
      _localizedValues[locale.languageCode]!['project_description']!;
  String get location => _localizedValues[locale.languageCode]!['location']!;
  String get photos => _localizedValues[locale.languageCode]!['photos']!;
  String get projectType =>
      _localizedValues[locale.languageCode]!['project_type']!;
  String get startDate => _localizedValues[locale.languageCode]!['start_date']!;
  String get beneficiaryCount =>
      _localizedValues[locale.languageCode]!['beneficiary_count']!;

  // Navigation
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  String get marketplace =>
      _localizedValues[locale.languageCode]!['marketplace']!;
  String get map => _localizedValues[locale.languageCode]!['map']!;
  String get notifications =>
      _localizedValues[locale.languageCode]!['notifications']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;

  // Actions
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get share => _localizedValues[locale.languageCode]!['share']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get filter => _localizedValues[locale.languageCode]!['filter']!;
  String get sort => _localizedValues[locale.languageCode]!['sort']!;

  // Status
  String get pending => _localizedValues[locale.languageCode]!['pending']!;
  String get approved => _localizedValues[locale.languageCode]!['approved']!;
  String get completed => _localizedValues[locale.languageCode]!['completed']!;
  String get rejected => _localizedValues[locale.languageCode]!['rejected']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Vsmart',
      'welcome_back': 'Welcome Back',
      'sign_in_to_continue':
          'Sign in to continue to your carbon restoration projects',
      'login': 'Login',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'invalid_credentials':
          'Invalid credentials. Please check your email and password.',
      'ngo': 'NGO',
      'admin': 'Administrator',
      'company': 'Company',
      'tree_plantation': 'Tree Plantation',
      'mangrove_restoration': 'Mangrove Restoration',
      'forest_conservation': 'Forest Conservation',
      'agroforestry': 'Agroforestry',
      'wetland_restoration': 'Wetland Restoration',
      'grassland_restoration': 'Grassland Restoration',
      'projects': 'Projects',
      'submit_project': 'Submit Project',
      'project_title': 'Project Title',
      'project_description': 'Project Description',
      'location': 'Location',
      'photos': 'Photos',
      'project_type': 'Project Type',
      'start_date': 'Start Date',
      'beneficiary_count': 'Beneficiary Count',
      'home': 'Home',
      'dashboard': 'Dashboard',
      'marketplace': 'Marketplace',
      'map': 'Map',
      'notifications': 'Notifications',
      'profile': 'Profile',
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'share': 'Share',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'pending': 'Pending',
      'approved': 'Approved',
      'completed': 'Completed',
      'rejected': 'Rejected',
    },
    'te': {
      'app_name': 'వీస్మార్ట్',
      'welcome_back': 'తిరిగి స్వాగతం',
      'sign_in_to_continue':
          'మీ కార్బన్ పునరుద్ధరణ ప్రాజెక్టులను కొనసాగించడానికి సైన్ ఇన్ చేయండి',
      'login': 'లాగిన్',
      'email': 'ఇమెయిల్',
      'password': 'పాస్‌వర్డ్',
      'forgot_password': 'పాస్‌వర్డ్ మర్చిపోయారా?',
      'invalid_credentials':
          'తప్పుడు ఆధారాలు. దయచేసి మీ ఇమెయిల్ మరియు పాస్‌వర్డ్‌ను తనిఖీ చేయండి.',
      'ngo': 'ఎన్‌జీఓ',
      'admin': 'నిర్వాహకుడు',
      'company': 'కంపెనీ',
      'tree_plantation': 'వృక్ష రోపణ',
      'mangrove_restoration': 'మడ అటవీ పునరుద్ధరణ',
      'forest_conservation': 'అటవీ పరిరక్షణ',
      'agroforestry': 'వ్యవసాయ వనరులు',
      'wetland_restoration': 'చిత్తడి భూముల పునరుద్ధరణ',
      'grassland_restoration': 'గడ్డి భూముల పునరుద్ధరణ',
      'projects': 'ప్రాజెక్టులు',
      'submit_project': 'ప్రాజెక్ట్ సమర్పించండి',
      'project_title': 'ప్రాజెక్ట్ శీర్షిక',
      'project_description': 'ప్రాజెక్ట్ వివరణ',
      'location': 'ప్రాంతం',
      'photos': 'ఫోటోలు',
      'project_type': 'ప్రాజెక్ట్ రకం',
      'start_date': 'ప్రారంభ తేదీ',
      'beneficiary_count': 'లబ్ధిదారుల సంఖ్య',
      'home': 'ఇల్లు',
      'dashboard': 'డ్యాష్‌బోర్డ్',
      'marketplace': 'మార్కెట్‌ప్లేస్',
      'map': 'మ్యాప్',
      'notifications': 'నోటిఫికేషన్లు',
      'profile': 'ప్రొఫైల్',
      'settings': 'సెట్టింగ్‌లు',
      'save': 'సేవ్ చేయండి',
      'cancel': 'రద్దు చేయండి',
      'delete': 'తొలగించండి',
      'edit': 'సవరించండి',
      'share': 'భాగస్వామ్యం చేయండి',
      'search': 'వెతకండి',
      'filter': 'ఫిల్టర్',
      'sort': 'క్రమబద్ధీకరించండి',
      'pending': 'పెండింగ్',
      'approved': 'ఆమోదించబడింది',
      'completed': 'పూర్తయింది',
      'rejected': 'తిరస్కరించబడింది',
    },
    'ta': {
      'app_name': 'வீஸ்மார்ட்',
      'welcome_back': 'வரவேற்கிறோம்',
      'sign_in_to_continue': 'உங்கள் கார்பன் மீட்சி திட்டங்களை தொடர உள்நுழைக',
      'login': 'உள்நுழைய',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'forgot_password': 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?',
      'invalid_credentials':
          'தவறான அடையாளங்கள். உங்கள் மின்னஞ்சல் மற்றும் கடவுச்சொல்லை சரிபார்க்கவும்.',
      'ngo': 'தன்னார்வ நிறுவனம்',
      'admin': 'நிர்வாகம்',
      'company': 'நிறுவனம்',
      'tree_plantation': 'மரம் நடுதல்',
      'mangrove_restoration': 'சதுப்பு நில மீட்சி',
      'forest_conservation': 'காடு பாதுகாப்பு',
      'agroforestry': 'வேளாண் காடு வளர்ப்பு',
      'wetland_restoration': 'சதுப்பு நில மீட்சி',
      'grassland_restoration': 'புல்வெளி மீட்சி',
      'projects': 'திட்டங்கள்',
      'submit_project': 'திட்டம் சமர்ப்பிக்க',
      'project_title': 'திட்ட தலைப்பு',
      'project_description': 'திட்ட விளக்கம்',
      'location': 'இடம்',
      'photos': 'புகைப்படங்கள்',
      'project_type': 'திட்ட வகை',
      'start_date': 'தொடக்க தேதி',
      'beneficiary_count': 'பயனாளிகள் எண்ணிக்கை',
      'home': 'வீடு',
      'dashboard': 'கட்டுப்பாட்டு பலகை',
      'marketplace': 'சந்தை',
      'map': 'வரைபடம்',
      'notifications': 'அறிவிப்புகள்',
      'profile': 'சுயவிவரம்',
      'settings': 'அமைப்புகள்',
      'save': 'சேமி',
      'cancel': 'ரத்து',
      'delete': 'நீக்கு',
      'edit': 'திருத்து',
      'share': 'பகிர்',
      'search': 'தேடு',
      'filter': 'வடிகட்டு',
      'sort': 'வரிசைப்படுத்து',
      'pending': 'நிலுவையில்',
      'approved': 'அங்கீகரிக்கப்பட்டது',
      'completed': 'நிறைவு',
      'rejected': 'நிராகரிக்கப்பட்டது',
    },
    'kn': {
      'app_name': 'ವಿಸ್ಮಾರ್ಟ್',
      'welcome_back': 'ಸ್ವಾಗತ',
      'sign_in_to_continue':
          'ನಿಮ್ಮ ಇಂಗಾಲ ಪುನರುಸ್ಥಾಪನೆ ಯೋಜನೆಗಳನ್ನು ಮುಂದುವರಿಸಲು ಸೈನ್ ಇನ್ ಮಾಡಿ',
      'login': 'ಲಾಗಿನ್',
      'email': 'ಇಮೇಲ್',
      'password': 'ಪಾಸ್‌ವರ್ಡ್',
      'forgot_password': 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿದ್ದೀರಾ?',
      'invalid_credentials':
          'ಅಮಾನ್ಯ ಅರ್ಹತೆಗಳು. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಇಮೇಲ್ ಮತ್ತು ಪಾಸ್‌ವರ್ಡ್ ಪರಿಶೀಲಿಸಿ.',
      'ngo': 'ಎನ್‌ಜಿಓ',
      'admin': 'ನಿರ್ವಾಹಕ',
      'company': 'ಕಂಪನಿ',
      'tree_plantation': 'ಮರ ನೆಡುವಿಕೆ',
      'mangrove_restoration': 'ಮ್ಯಾಂಗ್ರೋವ್ ಪುನರ್ ಸ್ಥಾಪನೆ',
      'forest_conservation': 'ಅರಣ್ಯ ಸಂರಕ್ಷಣೆ',
      'agroforestry': 'ಕೃಷಿ ಅರಣ್ಯಗಳು',
      'wetland_restoration': 'ತೇವ ಭೂಮಿ ಪುನರ್ ಸ್ಥಾಪನೆ',
      'grassland_restoration': 'ಹುಲ್ಲುಗಾವಲು ಪುನರ್ ಸ್ಥಾಪನೆ',
      'projects': 'ಯೋಜನೆಗಳು',
      'submit_project': 'ಯೋಜನೆ ಸಲ್ಲಿಸಿ',
      'project_title': 'ಯೋಜನೆ ಶೀರ್ಷಿಕೆ',
      'project_description': 'ಯೋಜನೆ ವಿವರಣೆ',
      'location': 'ಸ್ಥಳ',
      'photos': 'ಫೋಟೋಗಳು',
      'project_type': 'ಯೋಜನೆ ಪ್ರಕಾರ',
      'start_date': 'ಪ್ರಾರಂಭ ದಿನಾಂಕ',
      'beneficiary_count': 'ಫಲಾನುಭವಿಗಳ ಸಂಖ್ಯೆ',
      'home': 'ಮನೆ',
      'dashboard': 'ಡ್ಯಾಶ್‌ಬೋರ್ಡ್',
      'marketplace': 'ಮಾರುಕಟ್ಟೆ',
      'map': 'ನಕ್ಷೆ',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
      'profile': 'ಪ್ರೊಫೈಲ್',
      'settings': 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
      'save': 'ಉಳಿಸಿ',
      'cancel': 'ರದ್ದುಮಾಡಿ',
      'delete': 'ಅಳಿಸಿ',
      'edit': 'ಸಂಪಾದಿಸಿ',
      'share': 'ಹಂಚಿಕೊಳ್ಳಿ',
      'search': 'ಹುಡುಕಿ',
      'filter': 'ಫಿಲ್ಟರ್',
      'sort': 'ವರ್ಗೀಕರಿಸಿ',
      'pending': 'ಬಾಕಿ',
      'approved': 'ಅನುಮೋದಿಸಲಾಗಿದೆ',
      'completed': 'ಪೂರ್ಣಗೊಂಡಿದೆ',
      'rejected': 'ತಿರಸ್ಕರಿಸಲಾಗಿದೆ',
    },
    'ml': {
      'app_name': 'വിസ്മാർട്ട്',
      'welcome_back': 'തിരിച്ചുവരവിനെ സ്വാഗതം',
      'sign_in_to_continue':
          'നിങ്ങളുടെ കാർബൺ പുനരുദ്ധാരണ പദ്ധതികൾ തുടരുന്നതിന് സൈൻ ഇൻ ചെയ്യുക',
      'login': 'ലോഗിൻ',
      'email': 'ഇമെയിൽ',
      'password': 'പാസ്‌വേഡ്',
      'forgot_password': 'പാസ്‌വേഡ് മറന്നോ?',
      'invalid_credentials':
          'അസാധുവായ ആധികാരികത. ദയവായി നിങ്ങളുടെ ഇമെയിൽ, പാസ്‌വേഡ് എന്നിവ പരിശോധിക്കുക.',
      'ngo': 'എൻജിഒ',
      'admin': 'അഡ്മിനിസ്ട്രേറ്റർ',
      'company': 'കമ്പനി',
      'tree_plantation': 'വൃക്ഷത്തൈ നടൽ',
      'mangrove_restoration': 'കണ്ടൽക്കാട് പുനരുദ്ധാരണം',
      'forest_conservation': 'വന സംരക്ഷണം',
      'agroforestry': 'കാർഷിക വനവൽക്കരണം',
      'wetland_restoration': 'തണ്ണീർത്തട പുനരുദ്ധാരണം',
      'grassland_restoration': 'പുൽമേട് പുനരുദ്ധാരണം',
      'projects': 'പദ്ധതികൾ',
      'submit_project': 'പദ്ധതി സമർപ്പിക്കുക',
      'project_title': 'പദ്ധതി ശീർഷകം',
      'project_description': 'പദ്ധതി വിവരണം',
      'location': 'സ്ഥലം',
      'photos': 'ഫോട്ടോകൾ',
      'project_type': 'പദ്ധതി തരം',
      'start_date': 'ആരംഭ തീയതി',
      'beneficiary_count': 'ഗുണഭോക്താക്കളുടെ എണ്ണം',
      'home': 'വീട്',
      'dashboard': 'ഡാഷ്‌ബോർഡ്',
      'marketplace': 'മാർക്കറ്റ്പ്ലേസ്',
      'map': 'ഭൂപടം',
      'notifications': 'അറിയിപ്പുകൾ',
      'profile': 'പ്രൊഫൈൽ',
      'settings': 'സെറ്റിംഗ്സ്',
      'save': 'സേവ് ചെയ്യുക',
      'cancel': 'റദ്ദാക്കുക',
      'delete': 'ഇല്ലാതാക്കുക',
      'edit': 'എഡിറ്റ് ചെയ്യുക',
      'share': 'പങ്കിടുക',
      'search': 'തിരയുക',
      'filter': 'ഫിൽറ്റർ',
      'sort': 'അടുക്കുക',
      'pending': 'തീർപ്പാക്കാത്തത്',
      'approved': 'അംഗീകരിച്ചത്',
      'completed': 'പൂർത്തിയായത്',
      'rejected': 'നിരസിച്ചത്',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'te', 'ta', 'kn', 'ml'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
