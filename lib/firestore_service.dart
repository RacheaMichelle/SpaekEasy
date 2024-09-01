import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:language_learning_assistant/models/users.dart';
import 'package:language_learning_assistant/models/language_progress.dart';
import 'package:language_learning_assistant/models/phrase.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String generateNewDocumentId(String collectionPath) {
    return _db.collection(collectionPath).doc().id;
  }

  // Save user profile
  Future<void> saveUserProfile(User user, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(user.uid).set(data);
    } catch (e) {
      print('Error saving user profile: $e');
      throw e;
    }
  }

  // Fetch user profile
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>? ??
            {}; // Return an empty map if data is null
      } else {
        return {}; // Return an empty map if the document does not exist
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      return {}; // Return an empty map on error
    }
  }

// Get a new document ID
  String getNewDocumentId(String collection) {
    return _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(collection)
        .doc()
        .id;
  }

  // Save language

  // Save phrase

  // Get phrase
  Future<Map<String, dynamic>> getPhrase(User user, String phraseId) async {
    DocumentSnapshot doc = await _db
        .collection('users')
        .doc(user.uid)
        .collection('phrases')
        .doc(phraseId)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  // Save progress
  Future<void> saveProgress(
      User user, String progressId, Map<String, dynamic> progressData) async {
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc(progressId)
        .set(progressData);
  }

  // Get progress
  Future<Map<String, dynamic>> getProgress(User user, String progressId) async {
    DocumentSnapshot doc = await _db
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .doc(progressId)
        .get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<void> updateLanguageLevel(
      User user, String languageId, String? level) {
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('languages')
        .doc(languageId)
        .update({'level': level});
  }

  Future<List<Map<String, dynamic>>> getLanguages(User user) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
        .collection('users')
        .doc(user.uid)
        .collection('languages')
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch language details

  Future<void> updateLanguageProgress(
      String userId, String languageId, String phraseId) async {
    DocumentReference languageProgressRef = _db
        .collection('users')
        .doc(userId)
        .collection('languageProgress')
        .doc(languageId);

    DocumentSnapshot languageProgressSnapshot = await languageProgressRef.get();

    if (languageProgressSnapshot.exists) {
      LanguageProgressModel existingProgress = LanguageProgressModel.fromMap(
        languageProgressSnapshot.data() as Map<String, dynamic>,
      );

      if (!existingProgress.completedPhrases.contains(phraseId)) {
        existingProgress.completedPhrases.add(phraseId);
        existingProgress.progress =
            (existingProgress.completedPhrases.length / 20) * 100;

        await languageProgressRef.update(existingProgress.toMap());
      }
    } else {
      LanguageProgressModel newProgress = LanguageProgressModel(
        languageId: languageId,
        completedPhrases: [phraseId],
        progress: (1 / 20) * 100,
      );

      await languageProgressRef.set(newProgress.toMap());
    }
  }

  // Save a phrase to Firestore

  // Fetch phrases for a specific language under a specific user
  // Save a phrase to Firestore under a specific user's languages collection
  // Save a phrase to Firestore under a specific user's languages collection
  Future<void> savePhrase(String userId, PhraseModel phrase) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('languages')
          .doc(phrase.languageId)
          .collection('phrases')
          .doc(phrase.id)
          .set(phrase.toMap());
    } catch (e) {
      print('Error saving phrase: $e');
      throw e;
    }
  }

  // Fetch phrases for a specific language under a specific user
  Future<List<PhraseModel>> getPhrases(String languageId) async {
    try {
      QuerySnapshot query = await _db
          .collection('languages')
          .doc(languageId)
          .collection('phrases')
          .get();

      return query.docs
          .map((doc) => PhraseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching phrases: $e');
      throw e;
    }
  }

  // Updated saveLanguage method
  Future<void> saveLanguage(String languageId, String name, String description,
      Map<String, String> phrases) async {
    try {
      DocumentReference languageRef =
          _db.collection('languages').doc(languageId);

      // Prepare the data map
      Map<String, dynamic> data = {
        'name': name,
        'description': description,
        'phrases': phrases,
      };

      // Check if the document exists
      DocumentSnapshot docSnapshot = await languageRef.get();
      if (!docSnapshot.exists) {
        // If the document doesn't exist, create it
        await languageRef.set(data);
        print("$languageId document created successfully.");
      } else {
        // If it exists, you might want to update it or handle it differently
        print("$languageId document already exists.");
      }
    } catch (e) {
      print("Error saving $languageId document: $e");
    }
  }

// Save Portuguese Language

  Future<void> populateLanguages() async {
    // Define the phrases for each language
    Map<String, Map<String, String>> phrases = {
      'Portuguese': {
        "how_are_you": "Como você está?",
        "good_morning": "Bom dia",
        "thank_you": "Obrigado",
        "please": "Por favor",
        "yes": "Sim",
        "no": "Não",
        "excuse_me": "Com licença",
        "sorry": "Desculpe",
        "goodbye": "Adeus",
        "help": "Ajuda",
        "where_is": "Onde fica?",
        "what_is_your_name": "Qual é o seu nome?",
        "my_name_is": "Meu nome é",
        "how_much": "Quanto custa?",
        "i_dont_understand": "Eu não entendo",
        "do_you_speak_english": "Você fala inglês?",
        "i_speak_a_little": "Eu falo um pouco",
        "what_time_is_it": "Que horas são?",
        "i_need_a_doctor": "Eu preciso de um médico",
        "call_the_police": "Chame a polícia",
      },

      // Save French Language

      'French': {
        "how_are_you": "Comment ça va?",
        "good_morning": "Bonjour",
        "thank_you": "Merci",
        "please": "S'il vous plaît",
        "yes": "Oui",
        "no": "Non",
        "excuse_me": "Excusez-moi",
        "sorry": "Désolé",
        "goodbye": "Au revoir",
        "help": "Aidez-moi",
        "where_is": "Où est?",
        "what_is_your_name": "Comment vous appelez-vous?",
        "my_name_is": "Je m'appelle",
        "how_much": "Combien ça coûte?",
        "i_dont_understand": "Je ne comprends pas",
        "do_you_speak_english": "Parlez-vous anglais?",
        "i_speak_a_little": "Je parle un peu",
        "what_time_is_it": "Quelle heure est-il?",
        "i_need_a_doctor": "J'ai besoin d'un médecin",
        "call_the_police": "Appelez la police",
      },

      'Spanish': {
        "how_are_you": "¿Cómo estás?",
        "good_morning": "Buenos días",
        "thank_you": "Gracias",
        "please": "Por favor",
        "yes": "Sí",
        "no": "No",
        "excuse_me": "Perdón",
        "sorry": "Lo siento",
        "goodbye": "Adiós",
        "help": "Ayuda",
        "where_is": "¿Dónde está?",
        "what_is_your_name": "¿Cómo te llamas?",
        "my_name_is": "Me llamo",
        "how_much": "¿Cuánto cuesta?",
        "i_dont_understand": "No entiendo",
        "do_you_speak_english": "¿Hablas inglés?",
        "i_speak_a_little": "Hablo un poco",
        "what_time_is_it": "¿Qué hora es?",
        "i_need_a_doctor": "Necesito un médico",
        "call_the_police": "Llame a la policía",
      },

      'Japanese': {
        "how_are_you": "お元気ですか？ (Ogenki desu ka?)",
        "good_morning": "おはようございます (Ohayou gozaimasu)",
        "thank_you": "ありがとうございます (Arigatou gozaimasu)",
        "please": "お願いします (Onegaishimasu)",
        "yes": "はい (Hai)",
        "no": "いいえ (Iie)",
        "excuse_me": "すみません (Sumimasen)",
        "sorry": "ごめんなさい (Gomen nasai)",
        "goodbye": "さようなら (Sayounara)",
        "help": "助けて (Tasukete)",
        "where_is": "どこですか？ (Doko desu ka?)",
        "what_is_your_name": "お名前は何ですか？ (Onamae wa nan desu ka?)",
        "my_name_is": "私の名前は (Watashi no namae wa)",
        "how_much": "いくらですか？ (Ikura desu ka?)",
        "i_dont_understand": "分かりません (Wakarimasen)",
        "do_you_speak_english": "英語を話せますか？ (Eigo o hanasemasu ka?)",
        "i_speak_a_little": "少し話せます (Sukoshi hanasemasu)",
        "what_time_is_it": "今何時ですか？ (Ima nanji desu ka?)",
        "i_need_a_doctor": "医者が必要です (Isha ga hitsuyou desu)",
        "call_the_police": "警察を呼んでください (Keisatsu o yonde kudasai)",
      },

      'Chinese': {
        "how_are_you": "你好吗？ (Nǐ hǎo ma?)",
        "good_morning": "早上好 (Zǎoshang hǎo)",
        "thank_you": "谢谢 (Xièxiè)",
        "please": "请 (Qǐng)",
        "yes": "是 (Shì)",
        "no": "不是 (Bùshì)",
        "excuse_me": "劳驾 (Láojià)",
        "sorry": "对不起 (Duìbùqǐ)",
        "goodbye": "再见 (Zàijiàn)",
        "help": "救命 (Jiùmìng)",
        "where_is": "在哪里？ (Zài nǎlǐ?)",
        "what_is_your_name": "你叫什么名字？ (Nǐ jiào shénme míngzì?)",
        "my_name_is": "我的名字是 (Wǒ de míngzì shì)",
        "how_much": "多少钱？ (Duōshǎo qián?)",
        "i_dont_understand": "我不懂 (Wǒ bù dǒng)",
        "do_you_speak_english": "你会说英语吗？ (Nǐ huì shuō yīngyǔ ma?)",
        "i_speak_a_little": "我会说一点 (Wǒ huì shuō yīdiǎn)",
        "what_time_is_it": "现在几点了？ (Xiànzài jǐ diǎnle?)",
        "i_need_a_doctor": "我需要医生 (Wǒ xūyào yīshēng)",
        "call_the_police": "报警 (Bàojǐng)",
      },

      'Korean': {
        "how_are_you": "잘 지내세요? (Jal jinaeseyo?)",
        "good_morning": "좋은 아침이에요 (Joeun achimieyo)",
        "thank_you": "감사합니다 (Gamsahamnida)",
        "please": "부탁합니다 (Butakhamnida)",
        "yes": "네 (Ne)",
        "no": "아니요 (Aniyo)",
        "excuse_me": "실례합니다 (Sillyehamnida)",
        "sorry": "죄송합니다 (Joesonghamnida)",
        "goodbye": "안녕히 가세요 (Annyeonghi gaseyo)",
        "help": "도와주세요 (Dowajuseyo)",
        "where_is": "어디예요? (Eodiyeyo?)",
        "what_is_your_name": "이름이 뭐예요? (Ireumi mwoyeyo?)",
        "my_name_is": "제 이름은 (Je ireumeun)",
        "how_much": "얼마예요? (Eolmayeyo?)",
        "i_dont_understand": "이해하지 못했어요 (Ihaehaji mothaesseoyo)",
        "do_you_speak_english": "영어를 할 수 있어요? (Yeongeoreul hal su isseoyo?)",
        "i_speak_a_little": "조금 할 수 있어요 (Jogeum hal su isseoyo)",
        "what_time_is_it": "몇 시예요? (Myeot siyeyo?)",
        "i_need_a_doctor": "의사가 필요해요 (Uisaga piryohaeyo)",
        "call_the_police": "경찰을 불러 주세요 (Gyeongchareul bulleo juseyo)",
      },

      'Italian': {
        "how_are_you": "Come stai?",
        "good_morning": "Buongiorno",
        "thank_you": "Grazie",
        "please": "Per favore",
        "yes": "Sì",
        "no": "No",
        "excuse_me": "Mi scusi",
        "sorry": "Mi dispiace",
        "goodbye": "Arrivederci",
        "help": "Aiuto",
        "where_is": "Dove si trova?",
        "what_is_your_name": "Come ti chiami?",
        "my_name_is": "Mi chiamo",
        "how_much": "Quanto costa?",
        "i_dont_understand": "Non capisco",
        "do_you_speak_english": "Parli inglese?",
        "i_speak_a_little": "Parlo un po'",
        "what_time_is_it": "Che ore sono?",
        "i_need_a_doctor": "Ho bisogno di un dottore",
        "call_the_police": "Chiami la polizia",
      },

      'German': {
        "how_are_you": "Wie geht es Ihnen?",
        "good_morning": "Guten Morgen",
        "thank_you": "Danke",
        "please": "Bitte",
        "yes": "Ja",
        "no": "Nein",
        "excuse_me": "Entschuldigen Sie",
        "sorry": "Es tut mir leid",
        "goodbye": "Auf Wiedersehen",
        "help": "Hilfe",
        "where_is": "Wo ist?",
        "what_is_your_name": "Wie heißen Sie?",
        "my_name_is": "Ich heiße",
        "how_much": "Wie viel kostet das?",
        "i_dont_understand": "Ich verstehe nicht",
        "do_you_speak_english": "Sprechen Sie Englisch?",
        "i_speak_a_little": "Ich spreche ein wenig",
        "what_time_is_it": "Wie spät ist es?",
        "i_need_a_doctor": "Ich brauche einen Arzt",
        "call_the_police": "Rufen Sie die Polizei",
      },
      'Arabic': {
        "how_are_you": "كيف حالك؟ (Kayfa halak?)",
        "good_morning": "صباح الخير (Sabah al-khayr)",
        "thank_you": "شكرا (Shukran)",
        "please": "من فضلك (Min fadlak)",
        "yes": "نعم (Na'am)",
        "no": "لا (La)",
        "excuse_me": "عفوا (Afwan)",
        "sorry": "آسف (Asif)",
        "goodbye": "مع السلامة (Ma'a as-salama)",
        "help": "النجدة (An-najda)",
        "where_is": "أين هو؟ (Ayna huwa?)",
        "what_is_your_name": "ما اسمك؟ (Ma ismuka?)",
        "my_name_is": "اسمي (Ismi)",
        "how_much": "كم سعر هذا؟ (Kam si'r hatha?)",
        "i_dont_understand": "أنا لا أفهم (Ana la afham)",
        "do_you_speak_english":
            "هل تتحدث الإنجليزية؟ (Hal tatakallam al-ingliziyya?)",
        "i_speak_a_little": "أنا أتكلم قليلا (Ana atakallam qaleelan)",
        "what_time_is_it": "كم الساعة؟ (Kam as-sa'a?)",
        "i_need_a_doctor": "أحتاج إلى طبيب (Ahtaj ila tabib)",
        "call_the_police": "اتصل بالشرطة (Ittasil bil-shurta)",
      },
      'Kiswahili': {
        "how_are_you": "Habari yako?",
        "good_morning": "Habari za asubuhi",
        "thank_you": "Asante",
        "please": "Tafadhali",
        "yes": "Ndiyo",
        "no": "Hapana",
        "excuse_me": "Samahani",
        "sorry": "Pole",
        "goodbye": "Kwaheri",
        "help": "Msaada",
        "where_is": "Iko wapi?",
        "what_is_your_name": "Jina lako nani?",
        "my_name_is": "Jina langu ni",
        "how_much": "Hii ni bei gani?",
        "i_dont_understand": "Sielewi",
        "do_you_speak_english": "Unazungumza Kiingereza?",
        "i_speak_a_little": "Ninazungumza kidogo",
        "what_time_is_it": "Ni saa ngapi?",
        "i_need_a_doctor": "Nahitaji daktari",
        "call_the_police": "Piga simu kwa polisi",
      },
      'English': {
        "how_are_you": "How are you?",
        "good_morning": "Good morning",
        "thank_you": "Thank you",
        "please": "Please",
        "yes": "Yes",
        "no": "No",
        "excuse_me": "Excuse me",
        "sorry": "Sorry",
        "goodbye": "Goodbye",
        "help": "Help",
        "where_is": "Where is?",
        "what_is_your_name": "What is your name?",
        "my_name_is": "My name is",
        "how_much": "How much?",
        "i_dont_understand": "I don't understand",
        "do_you_speak_english": "Do you speak English?",
        "i_speak_a_little": "I speak a little",
        "what_time_is_it": "What time is it?",
        "i_need_a_doctor": "I need a doctor",
        "call_the_police": "Call the police",
      },
    };
    final Map<String, String> descriptions = {
      'Spanish':
          'Spanish is a Romance language that originated in the Iberian Peninsula and has over 460 million native speakers worldwide.',
      'French':
          'French is a Romance language spoken by about 275 million people as a first or second language, primarily in France and parts of Canada, Belgium, and Switzerland.',
      'German':
          'German is a West Germanic language mainly spoken in Germany, Austria, Switzerland, and parts of Italy, Belgium, and Luxembourg.',
      'Japanese':
          'Japanese is an East Asian language spoken by about 128 million people, primarily in Japan, and known for its complex writing system using Kanji and Kana.',
      'Chinese':
          'Chinese refers to a family of languages spoken by the Han majority and many other ethnic groups in China. Mandarin is the most spoken with over 900 million speakers.',
      'Italian':
          'Italian is a Romance language of the Indo-European language family, spoken by about 85 million people, mainly in Italy and Switzerland.',
      'Korean':
          'Korean is the official language of both South and North Korea, spoken by about 77 million people. It uses the Hangul script, which is known for its scientific design.',
      'Portuguese':
          'Portuguese is a Romance language spoken by about 260 million people worldwide, primarily in Portugal, Brazil, and several African countries.',
      'Arabic':
          'Arabic is a Semitic language spoken across the Arab world. It is known for its rich literary tradition and is the liturgical language of Islam.',
      'Kiswahili':
          'Kiswahili, or Swahili, is a Bantu language widely spoken in East Africa. It serves as a lingua franca in the region and is one of the official languages of the African Union.',
      'English':
          'English is a West Germanic language originating in medieval England. It is widely spoken around the world and serves as a global lingua franca, particularly in international business, science, technology, and diplomacy.'
    };

    // Loop through each language and its phrases, and save them to Firestore
    for (var entry in phrases.entries) {
      final language = entry.key;
      final phrasesMap = entry.value;
      final description = descriptions[language] ?? 'No description available';
      await saveLanguageDetails(language, phrasesMap, description);
    }
  }

  String normalizePhrase(String phrase) {
    return phrase.toLowerCase().trim();
  }

  final Map<String, String> phraseMapping = {
    // English
    "how are you": "how_are_you",
    "good morning": "good_morning",
    "thank you": "thank_you",
    "please": "please",
    "yes": "yes",
    "no": "no",
    "excuse me": "excuse_me",
    "sorry": "sorry",
    "goodbye": "goodbye",
    "help": "help",
    "where is": "where_is",
    "what is your name": "what_is_your_name",
    "my name is": "my_name_is",
    "how much": "how_much",
    "i don't understand": "i_dont_understand",
    "do you speak english": "do_you_speak_english",
    "i speak a little": "i_speak_a_little",
    "what time is it": "what_time_is_it",
    "i need a doctor": "i_need_a_doctor",
    "call the police": "call_the_police",

// Kiswahili

    "Habari yako?": "how_are_you",
    "Habari za asubuhi": "good_morning",
    "Asante": "thank_you",
    "Tafadhali": "please",
    "Ndiyo": "yes",
    "Hapana": "no",
    "Samahani": "excuse_me",
    "Pole": "sorry",
    "Kwaheri": "goodbye",
    "Msaada": "help",
    "Iko wapi?": "where_is",
    "Jina lako nani?": "what_is_your_name",
    "Jina langu ni": "my_name_is",
    "Hii ni bei gani?": "how_much",
    "Sielewi": "i_dont_understand",
    "Unazungumza Kiingereza?": "do_you_speak_english",
    "Ninazungumza kidogo": "i_speak_a_little",
    "Ni saa ngapi?": "what_time_is_it",
    "Nahitaji daktari": "i_need_a_doctor",
    "Piga simu kwa polisi": "call_the_police",

    // French

    "Bonjour": "good_morning",
    "Comment ça va?": "how_are_you",
    "Merci": "thank_you",
    "S'il vous plaît": "please",
    "Oui": "yes",
    "Non": "no",
    "Excusez-moi": "excuse_me",
    "Désolé": "sorry",
    "Au revoir": "goodbye",
    "Aidez-moi": "help",
    "Où est": "where_is",
    "Comment vous appelez-vous?": "what_is_your_name",
    "Je m'appelle": "my_name_is",
    "Combien ça coûte?": "how_much",
    "Je ne comprends pas": "i_dont_understand",
    "Parlez-vous anglais?": "do_you_speak_english",
    "Je parle un peu": "i_speak_a_little",
    "Quelle heure est-il?": "what_time_is_it",
    "J'ai besoin d'un docteur": "i_need_a_doctor",
    "Appelez la police": "call_the_police",

    // German

    "Guten Morgen": "good_morning",
    "Wie geht es dir?": "how_are_you",
    "Danke": "thank_you",
    "Bitte": "please",
    "Ja": "yes",
    "Nein": "no",
    "Entschuldigung": "excuse_me",
    "Es tut mir leid": "sorry",
    "Auf Wiedersehen": "goodbye",
    "Hilfe": "help",
    "Wo ist": "where_is",
    "Wie heißen Sie?": "what_is_your_name",
    "Ich heiße": "my_name_is",
    "Wie viel kostet das?": "how_much",
    "Ich verstehe nicht": "i_dont_understand",
    "Sprechen Sie Englisch?": "do_you_speak_english",
    "Ich spreche ein wenig": "i_speak_a_little",
    "Wie spät ist es?": "what_time_is_it",
    "Ich brauche einen Arzt": "i_need_a_doctor",
    "Rufen Sie die Polizei": "call_the_police",

    // Spanish

    "Buenos días": "good_morning",
    "¿Cómo estás?": "how_are_you",
    "Gracias": "thank_you",
    "Por favor": "please",
    "Sí": "yes",
    "No": "no",
    "Perdón": "excuse_me",
    "Lo siento": "sorry",
    "Adiós": "goodbye",
    "Ayuda": "help",
    "¿Dónde está?": "where_is",
    "¿Cómo te llamas?": "what_is_your_name",
    "Me llamo": "my_name_is",
    "¿Cuánto cuesta?": "how_much",
    "No entiendo": "i_dont_understand",
    "¿Hablas inglés?": "do_you_speak_english",
    "Hablo un poco": "i_speak_a_little",
    "¿Qué hora es?": "what_time_is_it",
    "Necesito un médico": "i_need_a_doctor",
    "Llama a la policía": "call_the_police",

    // Korean

    "좋은 아침": "good_morning",
    "잘 지내세요?": "how_are_you",
    "감사합니다": "thank_you",
    "제발": "please",
    "예": "yes",
    "아니오": "no",
    "실례합니다": "excuse_me",
    "죄송합니다": "sorry",
    "안녕히 가세요": "goodbye",
    "도와주세요": "help",
    "어디에 있나요?": "where_is",
    "이름이 뭐에요?": "what_is_your_name",
    "제 이름은": "my_name_is",
    "얼마에요?": "how_much",
    "이해하지 못해요": "i_dont_understand",
    "영어 할 수 있어요?": "do_you_speak_english",
    "조금 할 수 있어요": "i_speak_a_little",
    "몇 시에요?": "what_time_is_it",
    "의사가 필요해요": "i_need_a_doctor",
    "경찰에 전화하세요": "call_the_police",

    // Arabic

    "صباح الخير": "good_morning",
    "كيف حالك؟": "how_are_you",
    "شكرا": "thank_you",
    "من فضلك": "please",
    "نعم": "yes",
    "لا": "no",
    "عفوا": "excuse_me",
    "آسف": "sorry",
    "وداعا": "goodbye",
    "مساعدة": "help",
    "أين هو؟": "where_is",
    "ما اسمك؟": "what_is_your_name",
    "اسمي": "my_name_is",
    "كم يكلف؟": "how_much",
    "لا أفهم": "i_dont_understand",
    "هل تتحدث الإنجليزية؟": "do_you_speak_english",
    "أتحدث قليلا": "i_speak_a_little",
    "كم الساعة؟": "what_time_is_it",
    "أحتاج إلى طبيب": "i_need_a_doctor",
    "اتصل بالشرطة": "call_the_police",

    // Japanese

    "おはようございます": "good_morning",
    "お元気ですか？": "how_are_you",
    "ありがとう": "thank_you",
    "お願いします": "please",
    "はい": "yes",
    "いいえ": "no",
    "すみません": "excuse_me",
    "ごめんなさい": "sorry",
    "さようなら": "goodbye",
    "助けてください": "help",
    "どこですか？": "where_is",
    "お名前は何ですか？": "what_is_your_name",
    "私の名前は": "my_name_is",
    "いくらですか？": "how_much",
    "わかりません": "i_dont_understand",
    "英語を話せますか？": "do_you_speak_english",
    "少し話せます": "i_speak_a_little",
    "今何時ですか？": "what_time_is_it",
    "医者が必要です": "i_need_a_doctor",
    "警察に電話してください": "call_the_police",

    // Chinese

    "早上好": "good_morning",
    "你好吗？": "how_are_you",
    "谢谢": "thank_you",
    "请": "please",
    "是": "yes",
    "不是": "no",
    "对不起": "excuse_me",
    "抱歉": "sorry",
    "再见": "goodbye",
    "帮助": "help",
    "在哪里？": "where_is",
    "你叫什么名字？": "what_is_your_name",
    "我的名字是": "my_name_is",
    "多少钱？": "how_much",
    "我不明白": "i_dont_understand",
    "你会说英语吗？": "do_you_speak_english",
    "我会说一点": "i_speak_a_little",
    "现在几点了？": "what_time_is_it",
    "我需要医生": "i_need_a_doctor",
    "打电话给警察": "call_the_police",

    // Italian

    "Buongiorno": "good_morning",
    "Come stai?": "how_are_you",
    "Grazie": "thank_you",
    "Per favore": "please",
    "Sì": "yes",
    "No": "no",
    "Mi scusi": "excuse_me",
    "Mi dispiace": "sorry",
    "Addio": "goodbye",
    "Aiuto": "help",
    "Dove si trova?": "where_is",
    "Come ti chiami?": "what_is_your_name",
    "Mi chiamo": "my_name_is",
    "Quanto costa?": "how_much",
    "Non capisco": "i_dont_understand",
    "Parli inglese?": "do_you_speak_english",
    "Parlo un po'": "i_speak_a_little",
    "Che ore sono?": "what_time_is_it",
    "Ho bisogno di un medico": "i_need_a_doctor",
    "Chiama la polizia": "call_the_police",

    // Portuguese

    "Bom dia": "good_morning",
    "Como vai?": "how_are_you",
    "Obrigado": "thank_you",
    "Por favor": "please",
    "Sim": "yes",
    "Não": "no",
    "Com licença": "excuse_me",
    "Desculpe": "sorry",
    "Adeus": "goodbye",
    "Ajuda": "help",
    "Onde está?": "where_is",
    "Qual é o seu nome?": "what_is_your_name",
    "Meu nome é": "my_name_is",
    "Quanto custa?": "how_much",
    "Não entendo": "i_dont_understand",
    "Você fala inglês?": "do_you_speak_english",
    "Falo um pouco": "i_speak_a_little",
    "Que horas são?": "what_time_is_it",
    "Preciso de um médico": "i_need_a_doctor",
    "Chame a polícia": "call_the_police",
  };

  String getDatabaseKey(String userInput) {
    return phraseMapping[normalizePhrase(userInput)] ??
        normalizePhrase(userInput);
  }

  Future<void> saveLanguageDetails(
      String language, Map<String, String> phrases, String description) async {
    try {
      await _db.collection('languages').doc(language).set({
        'description': description,
        'phrases': phrases,
      }, SetOptions(merge: true)); // Merge with existing data if it exists
    } catch (e) {
      throw Exception('Error saving language details: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> getLanguageDetails(String languageId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _db.collection('languages').doc(languageId).get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error fetching $languageId details: $e");
      return null;
    }
  }

  Future<String?> findSourceLanguage(String phrase) async {
    try {
      QuerySnapshot languagesSnapshot = await _db.collection('languages').get();
      for (var doc in languagesSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic>? phrases =
            data['phrases'] as Map<String, dynamic>?;

        if (phrases != null) {
          if (phrases.containsValue(normalizePhrase(phrase))) {
            return doc.id; // Return language ID if phrase is found
          }
        }
      }
      return null;
    } catch (e) {
      print("Error finding source language: $e");
      return null;
    }
  }

  Future<String?> translatePhrase(String languageId, String userInput) async {
    try {
      DocumentSnapshot docSnapshot =
          await _db.collection('languages').doc(languageId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        Map<String, String> phrases = {};

        if (data.containsKey('phrases')) {
          final dynamicPhrases = data['phrases'] as Map<String, dynamic>;
          dynamicPhrases.forEach((key, value) {
            if (key is String && value is String) {
              phrases[key.toLowerCase()] = value;
            }
          });

          String normalizedInput = normalizePhrase(userInput);
          String dbKey = getDatabaseKey(normalizedInput);

          // Check if the phrase exists in the current language
          if (phrases.containsKey(dbKey)) {
            return phrases[dbKey];
          }

          // If not, try to find the source language and translate from there
          String? sourceLanguageId = await findSourceLanguage(normalizedInput);
          if (sourceLanguageId != null && sourceLanguageId != languageId) {
            // Recursively call translatePhrase with the source language
            String? translatedPhrase =
                await translatePhrase(sourceLanguageId, userInput);
            if (translatedPhrase != null) {
              // Translate the translated phrase to the target language
              return await translatePhrase(languageId, translatedPhrase);
            }
          }

          print("Phrase not found for key: $dbKey");
          return "Translation not found";
        } else {
          print("No phrases found in document.");
          return "No phrases found";
        }
      } else {
        print("Document does not exist.");
        return "Document not found";
      }
    } catch (e) {
      print("Error translating $userInput in $languageId: $e");
      return null;
    }
  }
}
