import 'dart:math'; //
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;

void main() {
  runApp(const KidsStudyApp());
}

class KidsStudyApp extends StatelessWidget {
  const KidsStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Study Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ================= HOME =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DailyPlanPage(),
    AbcPage(),
    CategoryPage(),
    QuizPage(),
    GameMenuPage(),
    const StudentDetailsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFFF6B35),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Daily Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'ABC'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Game'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Student',
          ), // 👈 ADD
        ],
      ),
    );
  }
}

// ================= PAGE 1 =================
class DailyPlanPage extends StatefulWidget {
  const DailyPlanPage({super.key});

  @override
  State<DailyPlanPage> createState() => _DailyPlanPageState();
}

class _DailyPlanPageState extends State<DailyPlanPage> {
  final TextEditingController _topicController = TextEditingController();
  List<Map<String, String>> todayTasks = [];

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _generatePlan() {
    if (_topicController.text.isEmpty) return;

    String topic = _topicController.text.toLowerCase();

    setState(() {
      todayTasks = [
        {
          'task': 'Learn: $topic',
          'youtube':
              'https://www.youtube.com/results?search_query=class+1+$topic+for+kids',
        },
        {
          'task': 'Practice: Write $topic 5 times',
          'youtube':
              'https://www.youtube.com/results?search_query=how+to+draw+$topic+for+kids',
        },
        {
          'task': 'Revise: Say $topic meaning',
          'youtube':
              'https://www.youtube.com/results?search_query=$topic+meaning+for+kids',
        },
      ];
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Daily Study Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                labelText: 'Enter topic (Apple, A, Red)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _generatePlan,
                ),
              ),
              onSubmitted: (_) => _generatePlan(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: todayTasks.isEmpty
                  ? const Center(child: Text('Type a word to get your plan!'))
                  : ListView.builder(
                      itemCount: todayTasks.length,
                      itemBuilder: (context, index) {
                        final item = todayTasks[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.play_circle,
                              color: Colors.red,
                            ),
                            title: Text(item['task']!),
                            subtitle: const Text('Tap to watch YouTube video'),
                            onTap: () => _launchUrl(item['youtube']!),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PAGE 2 (INTERACTIVE ABC) =================
class AbcPage extends StatefulWidget {
  const AbcPage({super.key});

  @override
  State<AbcPage> createState() => _AbcPageState();
}

class _AbcPageState extends State<AbcPage> {
  final FlutterTts flutterTts = FlutterTts();
  int tappedIndex = -1;

  final List<Map<String, String>> abcData = const [
    {'letter': 'A', 'word': 'Apple', 'meaning': 'A red fruit. सेब'},
    {'letter': 'B', 'word': 'Ball', 'meaning': 'Round toy. गेंद'},
    {'letter': 'C', 'word': 'Cat', 'meaning': 'Pet animal. बिल्ली'},
    {'letter': 'D', 'word': 'Dog', 'meaning': 'Pet animal. कुत्ता'},
    {'letter': 'E', 'word': 'Elephant', 'meaning': 'Big animal. हाथी'},
    {'letter': 'F', 'word': 'Fish', 'meaning': 'Lives in water. मछली'},
    {'letter': 'G', 'word': 'Grapes', 'meaning': 'Small fruit. अंगूर'},
    {'letter': 'H', 'word': 'Hen', 'meaning': 'A bird. मुर्गी'},
    {'letter': 'I', 'word': 'Ice Cream', 'meaning': 'Cold sweet. आइसक्रीम'},
    {'letter': 'J', 'word': 'Jug', 'meaning': 'Water container. जग'},
    {'letter': 'K', 'word': 'Kite', 'meaning': 'Flies in sky. पतंग'},
    {'letter': 'L', 'word': 'Lion', 'meaning': 'King of jungle. शेर'},
    {'letter': 'M', 'word': 'Mango', 'meaning': 'Sweet fruit. आम'},
    {'letter': 'N', 'word': 'Nest', 'meaning': 'Bird house. घोंसला'},
    {'letter': 'O', 'word': 'Orange', 'meaning': 'Fruit. संतरा'},
    {'letter': 'P', 'word': 'Parrot', 'meaning': 'Green bird. तोता'},
    {'letter': 'Q', 'word': 'Queen', 'meaning': 'Female ruler. रानी'},
    {'letter': 'R', 'word': 'Rabbit', 'meaning': 'Small animal. खरगोश'},
    {'letter': 'S', 'word': 'Sun', 'meaning': 'Gives light. सूरज'},
    {'letter': 'T', 'word': 'Tiger', 'meaning': 'Wild animal. बाघ'},
    {'letter': 'U', 'word': 'Umbrella', 'meaning': 'Used in rain. छाता'},
    {'letter': 'V', 'word': 'Van', 'meaning': 'Vehicle. गाड़ी'},
    {'letter': 'W', 'word': 'Watch', 'meaning': 'Shows time. घड़ी'},
    {
      'letter': 'X',
      'word': 'Xylophone',
      'meaning': 'Musical instrument. ज़ाइलोफोन',
    },
    {'letter': 'Y', 'word': 'Yak', 'meaning': 'Mountain animal. याक'},
    {'letter': 'Z', 'word': 'Zebra', 'meaning': 'Striped animal. ज़ेबरा'},
  ];

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.2);
    await flutterTts.speak(text);
  }

  void onTap(int index, String letter, String word) {
    setState(() => tappedIndex = index);

    speak("$letter for $word");

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => tappedIndex = -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive ABC')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
        ),
        itemCount: abcData.length,
        itemBuilder: (context, index) {
          final item = abcData[index];
          final isTapped = tappedIndex == index;

          return GestureDetector(
            onTap: () => onTap(index, item['letter']!, item['word']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: isTapped
                  ? (Matrix4.identity()..scale(1.1))
                  : Matrix4.identity(),
              decoration: BoxDecoration(
                color: isTapped
                    ? Colors.orange.shade200
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['letter']!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                  Text(
                    item['word']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['meaning']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================= PAGE 3 =================
// ================= PAGE 3 (INTERACTIVE) =================

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final FlutterTts flutterTts = FlutterTts();
  int tappedIndex = -1;

  final Map<String, List<String>> data = const {
    'Fruits': [
      'Apple - सेब',
      'Banana - केला',
      'Mango - आम',
      'Orange - संतरा',
      'Grapes - अंगूर',
      'Pineapple - अनानास',
      'Papaya - पपीता',
      'Guava - अमरूद',
      'Watermelon - तरबूज',
      'Cherry - चेरी',
      'Strawberry - स्ट्रॉबेरी',
      'Pear - नाशपाती',
      'Peach - आड़ू',
      'Plum - आलूबुखारा',
      'Kiwi - कीवी',
    ],
    'Vegetables': [
      'Potato - आलू',
      'Tomato - टमाटर',
      'Onion - प्याज',
      'Carrot - गाजर',
      'Cabbage - पत्ता गोभी',
      'Spinach - पालक',
      'Brinjal - बैंगन',
      'Cauliflower - फूलगोभी',
      'Peas - मटर',
      'Radish - मूली',
      'Ladyfinger - भिंडी',
      'Pumpkin - कद्दू',
      'Garlic - लहसुन',
      'Ginger - अदरक',
      'Capsicum - शिमला मिर्च',
    ],
    'Body Parts': [
      'Head - सिर',
      'Eye - आँख',
      'Ear - कान',
      'Nose - नाक',
      'Mouth - मुँह',
      'Hand - हाथ',
      'Leg - पैर',
      'Finger - उंगली',
      'Foot - पैर का तलवा',
      'Hair - बाल',
      'Teeth - दाँत',
      'Tongue - जीभ',
      'Neck - गर्दन',
      'Shoulder - कंधा',
      'Knee - घुटना',
    ],
    'Colors': [
      'Red - लाल',
      'Blue - नीला',
      'Green - हरा',
      'Yellow - पीला',
      'Black - काला',
      'White - सफेद',
      'Pink - गुलाबी',
      'Orange - नारंगी',
      'Purple - बैंगनी',
      'Brown - भूरा',
      'Grey - धूसर',
      'Cyan - आसमानी',
      'Magenta - गहरा गुलाबी',
      'Gold - सुनहरा',
      'Silver - चांदी',
    ],
  };

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.speak(text);
  }

  void onTap(int index, String item) {
    setState(() => tappedIndex = index);

    // Speak only English part
    String englishWord = item.split(' - ')[0];
    speak(englishWord);

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => tappedIndex = -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: data.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interactive Learning'),
          bottom: TabBar(
            isScrollable: true,
            tabs: data.keys.map((e) => Tab(text: e)).toList(),
          ),
        ),
        body: TabBarView(
          children: data.keys.map((category) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data[category]!.length,
              itemBuilder: (context, index) {
                final item = data[category]![index];
                final isTapped = tappedIndex == index;

                return GestureDetector(
                  onTap: () => onTap(index, item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isTapped
                          ? Colors.orange.shade200
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.volume_up, color: Colors.orange),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ================= CLASS 1 (VERY EASY) =================

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String selectedClass = "Class 1";
  String selectedTopic = "Fruits";

  int index = 0;
  int score = 0;

  List<Map<String, dynamic>> questions = [];
  final Random random = Random();

  // ================= QUESTION BANK =================
  final Map<String, Map<String, List<Map<String, dynamic>>>> data = {
    // ================= CLASS 1 =================
    "Class 1": {
      "ABCD": [
        {
          "q": "What comes after A?",
          "a": "B",
          "o": ["B", "Y", "Z", "E"],
        },
        {
          "q": "What comes after C?",
          "a": "D",
          "o": ["A", "B", "D", "E"],
        },
        {
          "q": "What comes after E?",
          "a": "F",
          "o": ["F", "G", "H", "I"],
        },
        {
          "q": "What comes after H?",
          "a": "I",
          "o": ["G", "I", "J", "K"],
        },
        {
          "q": "What comes after M?",
          "a": "N",
          "o": ["L", "P", "O", "N"],
        },

        {
          "q": "What comes between B and D?",
          "a": "C",
          "o": ["E", "C", "A", "F"],
        },
        {
          "q": "What comes between E and G?",
          "a": "F",
          "o": ["D", "H", "F", "I"],
        },
        {
          "q": "What comes before X?",
          "a": "W",
          "o": ["Y", "V", "W", "U"],
        },
        {
          "q": "What comes 2 letters after K?",
          "a": "M",
          "o": ["N", "M", "L", "O"],
        },
        {
          "q": "What comes 2 letters before T?",
          "a": "R",
          "o": ["Q", "S", "R", "P"],
        },
        {
          "q": "Middle letter of 'DOG'?",
          "a": "O",
          "o": ["D", "G", "O", "N"],
        },
        {
          "q": "Middle letter of 'FISH'?",
          "a": "I",
          "o": ["F", "S", "H", "I"],
        },
        {
          "q": "Last letter of 'APPLE'?",
          "a": "E",
          "o": ["A", "P", "L", "E"],
        },
        {
          "q": "First letter of 'UMBRELLA'?",
          "a": "U",
          "o": ["M", "B", "U", "A"],
        },
        {
          "q": "How many vowels in 'EDUCATION'?",
          "a": "5",
          "o": ["3", "6", "5", "4"],
        },
        {
          "q": "Which is NOT a vowel?",
          "a": "B",
          "o": ["A", "E", "B", "I"],
        },
        {
          "q": "Which comes first: 'C' or 'E'?",
          "a": "C",
          "o": ["E", "C", "Both", "None"],
        },
        {
          "q": "Which comes last: 'M', 'N', 'O'?",
          "a": "O",
          "o": ["M", "P", "O", "N"],
        },
        {
          "q": "Spell 'BOY' - Second letter?",
          "a": "O",
          "o": ["B", "Y", "O", "A"],
        },
        {
          "q": "Spell 'GIRL' - Third letter?",
          "a": "R",
          "o": ["G", "I", "L", "R"],
        },
        {
          "q": "Missing: A, C, _, E",
          "a": "D",
          "o": ["B", "F", "D", "G"],
        },
        {
          "q": "Missing: P, _, R, S",
          "a": "Q",
          "o": ["O", "T", "Q", "U"],
        },
        {
          "q": "Missing: U, V, _, X",
          "a": "W",
          "o": ["T", "Y", "W", "Z"],
        },
        {
          "q": "Which set is in order?",
          "a": "L, M, N",
          "o": ["L, N, M", "M, L, N", "L, M, N", "N, M, L"],
        },
        {
          "q": "Which set is NOT in order?",
          "a": "R, T, S",
          "o": ["P, Q, R", "R, T, S", "X, Y, Z", "A, B, C"],
        },
        {
          "q": "How many letters from A to E?",
          "a": "5",
          "o": ["3", "4", "6", "5"],
        },
        {
          "q": "How many letters from P to T?",
          "a": "5",
          "o": ["4", "6", "5", "7"],
        },
        {
          "q": "What is the 3rd letter?",
          "a": "C",
          "o": ["A", "B", "D", "C"],
        },
        {
          "q": "What is the 7th letter?",
          "a": "G",
          "o": ["E", "F", "H", "G"],
        },
        {
          "q": "What is the 10th letter?",
          "a": "J",
          "o": ["H", "I", "K", "J"],
        },
        {
          "q": "Letter before 'J' and after 'H'?",
          "a": "I",
          "o": ["G", "K", "I", "L"],
        },
        {
          "q": "Letter after 'Q' and before 'S'?",
          "a": "R",
          "o": ["P", "T", "R", "U"],
        },
        {
          "q": "Which letter looks like '3'?",
          "a": "E",
          "o": ["B", "C", "E", "S"],
        },
        {
          "q": "Which letter looks like '0'?",
          "a": "O",
          "o": ["Q", "C", "O", "D"],
        },
        {
          "q": "B + D = ?",
          "a": "BD",
          "o": ["AB", "CD", "BD", "BC"],
        },
        {
          "q": "C + A + T = ?",
          "a": "CAT",
          "o": ["ACT", "TAC", "CAT", "CTA"],
        },
        {
          "q": "D + O + G = ?",
          "a": "DOG",
          "o": ["GOD", "ODG", "DOG", "GDO"],
        },
        {
          "q": "Which word starts with 'S'?",
          "a": "Sun",
          "o": ["Moon", "Star", "Sun", "Sky"],
        },
        {
          "q": "Which word starts with 'M'?",
          "a": "Moon",
          "o": ["Sun", "Star", "Moon", "Sky"],
        },
        {
          "q": "Which word ends with 'T'?",
          "a": "BAT",
          "o": ["BAD", "BAG", "BAN", "BAT"],
        },
        {
          "q": "Which word ends with 'G'?",
          "a": "BAG",
          "o": ["BAD", "BAT", "BAN", "BAG"],
        },
        {
          "q": "Reverse of 'ON' is?",
          "a": "NO",
          "o": ["OM", "NO", "ON", "MO"],
        },
        {
          "q": "Reverse of 'TO' is?",
          "a": "OT",
          "o": ["TA", "OT", "TO", "AT"],
        },
        {
          "q": "A, E, I, O, _?",
          "a": "U",
          "o": ["Y", "V", "U", "W"],
        },
        {
          "q": "B, D, F, H, _?",
          "a": "J",
          "o": ["I", "K", "J", "L"],
        },
        {
          "q": "Z, X, V, T, _?",
          "a": "R",
          "o": ["S", "Q", "R", "P"],
        },
        {
          "q": "Which group has only vowels?",
          "a": "A, E, I",
          "o": ["A, B, C", "X, Y, Z", "A, E, I", "P, Q, R"],
        },
        {
          "q": "Which group has NO vowels?",
          "a": "B, C, D",
          "o": ["A, B, C", "E, F, G", "O, P, Q", "B, C, D"],
        },
        {
          "q": "How many letters before 'E'?",
          "a": "4",
          "o": ["3", "5", "4", "6"],
        },
        {
          "q": "How many letters after 'W'?",
          "a": "3",
          "o": ["2", "4", "3", "5"],
        },
      ],

      "Colors": [
        {
          "q": "Sky color?",
          "a": "Blue",
          "o": ["Blue", "Red", "Green", "Black"],
        },
        {
          "q": "Grass color?",
          "a": "Green",
          "o": ["Green", "Blue", "Red", "Yellow"],
        },
        {
          "q": "Sun color?",
          "a": "Yellow",
          "o": ["Yellow", "Blue", "Black", "Pink"],
        },
        {
          "q": "Apple color?",
          "a": "Red",
          "o": ["Red", "Blue", "Green", "Black"],
        },
        {
          "q": "Milk color?",
          "a": "White",
          "o": ["White", "Black", "Red", "Green"],
        },

        {
          "q": "Banana color?",
          "a": "Yellow",
          "o": ["Yellow", "Green", "Red", "Blue"],
        },
        {
          "q": "Coal color?",
          "a": "Black",
          "o": ["Black", "White", "Yellow", "Pink"],
        },
        {
          "q": "Leaf color?",
          "a": "Green",
          "o": ["Green", "Red", "Blue", "Purple"],
        },
        {
          "q": "Strawberry color?",
          "a": "Red",
          "o": ["Red", "Green", "Blue", "Yellow"],
        },
        {
          "q": "Orange fruit color?",
          "a": "Orange",
          "o": ["Orange", "Red", "Green", "Blue"],
        },

        {
          "q": "Mix Red + White?",
          "a": "Pink",
          "o": ["Pink", "Green", "Blue", "Black"],
        },
        {
          "q": "Mix Blue + Yellow?",
          "a": "Green",
          "o": ["Green", "Red", "Pink", "White"],
        },
        {
          "q": "Mix Red + Blue?",
          "a": "Purple",
          "o": ["Purple", "Green", "Yellow", "Black"],
        },
        {
          "q": "Night sky color?",
          "a": "Black",
          "o": ["Black", "Blue", "Green", "Red"],
        },

        {
          "q": "Flower rose color?",
          "a": "Red",
          "o": ["Red", "Black", "Green", "Blue"],
        },
        {
          "q": "Cloud color?",
          "a": "White",
          "o": ["White", "Black", "Red", "Green"],
        },
        {
          "q": "Tomato color?",
          "a": "Red",
          "o": ["Red", "Blue", "Yellow", "Black"],
        },
        {
          "q": "Carrot color?",
          "a": "Orange",
          "o": ["Orange", "Green", "Blue", "Red"],
        },
        {
          "q": "Egg color?",
          "a": "White",
          "o": ["White", "Black", "Red", "Blue"],
        },

        {
          "q": "Which is dark color?",
          "a": "Black",
          "o": ["Black", "Yellow", "Pink", "White"],
        },
      ],

      "Fruits": [
        {
          "q": "Which is a fruit?",
          "a": "Apple",
          "o": ["Apple", "Car", "Bus", "Pen"],
        },
        {
          "q": "Which is yellow fruit?",
          "a": "Banana",
          "o": ["Banana", "Tomato", "Potato", "Chair"],
        },
        {
          "q": "Which is sweet fruit?",
          "a": "Mango",
          "o": ["Mango", "Stone", "Book", "Pen"],
        },
        {
          "q": "Which fruit grows on tree?",
          "a": "Apple",
          "o": ["Apple", "Car", "Table", "Bus"],
        },

        {
          "q": "Which fruit is red?",
          "a": "Apple",
          "o": ["Apple", "Banana", "Potato", "Tomato"],
        },
        {
          "q": "Which fruit is green?",
          "a": "Grapes",
          "o": ["Grapes", "Mango", "Car", "Pen"],
        },
        {
          "q": "Which fruit is orange?",
          "a": "Orange",
          "o": ["Orange", "Apple", "Book", "Chair"],
        },

        {
          "q": "Which fruit is soft inside?",
          "a": "Banana",
          "o": ["Banana", "Stone", "Iron", "Wood"],
        },
        {
          "q": "Which fruit is juicy?",
          "a": "Watermelon",
          "o": ["Watermelon", "Chair", "Bus", "Table"],
        },

        {
          "q": "Which is NOT a fruit?",
          "a": "Carrot",
          "o": ["Carrot", "Apple", "Mango", "Banana"],
        },
        {
          "q": "Which is NOT eaten as fruit?",
          "a": "Potato",
          "o": ["Potato", "Apple", "Grapes", "Orange"],
        },

        {
          "q": "Which fruit has seeds inside?",
          "a": "Apple",
          "o": ["Apple", "Car", "Bus", "Pen"],
        },
        {
          "q": "Which fruit is small?",
          "a": "Grapes",
          "o": ["Grapes", "Watermelon", "Table", "Chair"],
        },

        {
          "q": "Which fruit is big?",
          "a": "Watermelon",
          "o": ["Watermelon", "Apple", "Banana", "Grapes"],
        },

        {
          "q": "Which fruit is sour?",
          "a": "Lemon",
          "o": ["Lemon", "Mango", "Apple", "Banana"],
        },
        {
          "q": "Which fruit is used in juice?",
          "a": "Orange",
          "o": ["Orange", "Pen", "Book", "Chair"],
        },

        {
          "q": "Which fruit is healthy?",
          "a": "Apple",
          "o": ["Apple", "Candy", "Chips", "Cake"],
        },
        {
          "q": "Which fruit grows in bunch?",
          "a": "Grapes",
          "o": ["Grapes", "Apple", "Mango", "Orange"],
        },

        {
          "q": "Which fruit is tropical?",
          "a": "Mango",
          "o": ["Mango", "Ice", "Snow", "Stone"],
        },
        {
          "q": "Which fruit is soft and yellow?",
          "a": "Banana",
          "o": ["Banana", "Apple", "Bus", "Car"],
        },
      ],

      "Meaning": [
        {
          "q": "Dog means?",
          "a": "Animal",
          "o": ["Animal", "Fruit", "Color", "Thing"],
        },
        {
          "q": "Apple means?",
          "a": "Fruit",
          "o": ["Fruit", "Animal", "Color", "Place"],
        },

        {
          "q": "What is the meaning of 'Big'?",
          "a": "Large",
          "o": ["Small", "Large", "Tiny", "Short"],
        },
        {
          "q": "What is the meaning of 'Happy'?",
          "a": "Glad",
          "o": ["Sad", "Angry", "Glad", "Cry"],
        },
        {
          "q": "What is the meaning of 'Fast'?",
          "a": "Quick",
          "o": ["Slow", "Stop", "Quick", "Wait"],
        },
        {
          "q": "What is the meaning of 'Hot'?",
          "a": "Warm",
          "o": ["Cold", "Wet", "Warm", "Dry"],
        },
        {
          "q": "What is the meaning of 'Jump'?",
          "a": "Leap",
          "o": ["Sit", "Sleep", "Leap", "Walk"],
        },
        {
          "q": "What is the meaning of 'Small'?",
          "a": "Little",
          "o": ["Big", "Little", "Huge", "Tall"],
        },
        {
          "q": "What is the meaning of 'Sad'?",
          "a": "Unhappy",
          "o": ["Glad", "Unhappy", "Angry", "Laugh"],
        },
        {
          "q": "What is the meaning of 'Slow'?",
          "a": "Not fast",
          "o": ["Quick", "Not fast", "Run", "Fly"],
        },
        {
          "q": "What is the meaning of 'Cold'?",
          "a": "Chilly",
          "o": ["Hot", "Chilly", "Warm", "Fire"],
        },
        {
          "q": "What is the meaning of 'Sleep'?",
          "a": "Rest",
          "o": ["Run", "Rest", "Dance", "Eat"],
        },
        {
          "q": "What is the meaning of 'Eat'?",
          "a": "Take food",
          "o": ["Drink", "Take food", "Walk", "Jump"],
        },
        {
          "q": "What is the meaning of 'Drink'?",
          "a": "Take water",
          "o": ["Eat", "Take water", "Sleep", "Play"],
        },
        {
          "q": "What is the meaning of 'Run'?",
          "a": "Move fast",
          "o": ["Sit", "Move fast", "Stop", "Crawl"],
        },
        {
          "q": "What is the meaning of 'Walk'?",
          "a": "Move slowly",
          "o": ["Run", "Move slowly", "Fly", "Jump"],
        },
        {
          "q": "What is the meaning of 'Book'?",
          "a": "For reading",
          "o": ["For eating", "For reading", "For playing", "For sleeping"],
        },
        {
          "q": "What is the meaning of 'Sun'?",
          "a": "Star",
          "o": ["Moon", "Star", "Cloud", "Rain"],
        },
        {
          "q": "What is the meaning of 'Moon'?",
          "a": "Night light",
          "o": ["Day light", "Night light", "Star", "Sun"],
        },
        {
          "q": "What is the meaning of 'Mother'?",
          "a": "Mom",
          "o": ["Dad", "Mom", "Sister", "Brother"],
        },
        {
          "q": "What is the meaning of 'Father'?",
          "a": "Dad",
          "o": ["Mom", "Dad", "Uncle", "Grandpa"],
        },
        {
          "q": "What is the meaning of 'Friend'?",
          "a": "Buddy",
          "o": ["Enemy", "Buddy", "Teacher", "Stranger"],
        },
        {
          "q": "What is the meaning of 'Brave'?",
          "a": "Fearless",
          "o": ["Scared", "Fearless", "Weak", "Slow"],
        },
        {
          "q": "What is the meaning of 'Tiny'?",
          "a": "Very small",
          "o": ["Very big", "Very small", "Round", "Heavy"],
        },
        {
          "q": "What is the meaning of 'Huge'?",
          "a": "Very big",
          "o": ["Very big", "Very small", "Light", "Empty"],
        },
        {
          "q": "What is the meaning of 'Shout'?",
          "a": "Speak loudly",
          "o": ["Speak softly", "Speak loudly", "Cry", "Whisper"],
        },
        {
          "q": "What is the meaning of 'Gift'?",
          "a": "Present",
          "o": ["Take", "Present", "Hide", "Break"],
        },
        {
          "q": "What is the meaning of 'Clean'?",
          "a": "Not dirty",
          "o": ["Dirty", "Not dirty", "Wet", "Broken"],
        },
        {
          "q": "What is the meaning of 'Dirty'?",
          "a": "Not clean",
          "o": ["Clean", "Not clean", "Shiny", "New"],
        },
        {
          "q": "What is the meaning of 'Old'?",
          "a": "Not new",
          "o": ["New", "Not new", "Young", "Fresh"],
        },
        {
          "q": "What is the meaning of 'New'?",
          "a": "Not old",
          "o": ["Old", "Not old", "Broken", "Used"],
        },
        {
          "q": "What is the meaning of 'Start'?",
          "a": "Begin",
          "o": ["End", "Begin", "Stop", "Finish"],
        },
        {
          "q": "What is the meaning of 'End'?",
          "a": "Finish",
          "o": ["Start", "Finish", "Begin", "Continue"],
        },
        {
          "q": "What is the meaning of 'Up'?",
          "a": "Above",
          "o": ["Down", "Above", "Below", "Under"],
        },
        {
          "q": "What is the meaning of 'Down'?",
          "a": "Below",
          "o": ["Up", "Below", "Above", "Over"],
        },
        {
          "q": "What is the meaning of 'Day'?",
          "a": "Sun time",
          "o": ["Night time", "Sun time", "Dark", "Sleep"],
        },
        {
          "q": "What is the meaning of 'Night'?",
          "a": "Dark time",
          "o": ["Day time", "Dark time", "Sun", "Bright"],
        },
        {
          "q": "What is the meaning of 'Love'?",
          "a": "Like a lot",
          "o": ["Hate", "Like a lot", "Anger", "Fight"],
        },
        {
          "q": "What is the meaning of 'Hate'?",
          "a": "Dislike",
          "o": ["Love", "Dislike", "Like", "Enjoy"],
        },
        {
          "q": "What is the meaning of 'Give'?",
          "a": "Offer",
          "o": ["Take", "Offer", "Hide", "Keep"],
        },
        {
          "q": "What is the meaning of 'Take'?",
          "a": "Get",
          "o": ["Give", "Get", "Throw", "Leave"],
        },
        {
          "q": "What is the meaning of 'Open'?",
          "a": "Not closed",
          "o": ["Closed", "Not closed", "Locked", "Broken"],
        },
        {
          "q": "What is the meaning of 'Close'?",
          "a": "Shut",
          "o": ["Open", "Shut", "Break", "Throw"],
        },
        {
          "q": "What is the meaning of 'Wet'?",
          "a": "With water",
          "o": ["Dry", "With water", "Hot", "Cold"],
        },
        {
          "q": "What is the meaning of 'Dry'?",
          "a": "No water",
          "o": ["Wet", "No water", "Cold", "Rain"],
        },
        {
          "q": "What is the meaning of 'Hard'?",
          "a": "Not soft",
          "o": ["Soft", "Not soft", "Smooth", "Light"],
        },
        {
          "q": "What is the meaning of 'Soft'?",
          "a": "Not hard",
          "o": ["Hard", "Not hard", "Rough", "Heavy"],
        },
        {
          "q": "What is the meaning of 'Empty'?",
          "a": "Nothing inside",
          "o": ["Full", "Nothing inside", "Heavy", "Big"],
        },
        {
          "q": "What is the meaning of 'Full'?",
          "a": "No space",
          "o": ["Empty", "No space", "Light", "Small"],
        },
        {
          "q": "What is the meaning of 'Near'?",
          "a": "Close",
          "o": ["Far", "Close", "Away", "Distant"],
        },
        {
          "q": "What is the meaning of 'Far'?",
          "a": "Not near",
          "o": ["Near", "Not near", "Close", "Here"],
        },
        {
          "q": "What is the meaning of 'Quiet'?",
          "a": "No noise",
          "o": ["Loud", "No noise", "Shout", "Music"],
        },
      ],
    },

    // ================= CLASS 2 =================
    "Class 2": {
      "Logic": [
        // 🔢 Number Pattern
        {
          "q": "What comes next? 2, 4, 6, ?",
          "a": "8",
          "o": ["8", "5", "10", "3"],
        },
        {
          "q": "What comes next? 1, 3, 5, ?",
          "a": "7",
          "o": ["7", "6", "8", "9"],
        },
        {
          "q": "What comes next? 10, 20, 30, ?",
          "a": "40",
          "o": ["40", "25", "35", "50"],
        },
        {
          "q": "What comes next? 5, 10, 15, ?",
          "a": "20",
          "o": ["20", "25", "30", "15"],
        },

        // 🌟 Missing Pattern
        {
          "q": "What is missing? Sun, Moon, Stars, ?",
          "a": "Sky",
          "o": ["Sky", "Car", "Book", "Dog"],
        },
        {
          "q": "What is missing? A, B, C, ?",
          "a": "D",
          "o": ["D", "E", "F", "G"],
        },
        {
          "q": "What is missing? Monday, Tuesday, ?",
          "a": "Wednesday",
          "o": ["Wednesday", "Sunday", "Friday", "April"],
        },
        {
          "q": "What is missing? 100, 200, 300, ?",
          "a": "400",
          "o": ["400", "250", "350", "500"],
        },

        // ❌ Odd One Out
        {
          "q": "Odd one out: Apple, Banana, Car, Mango",
          "a": "Car",
          "o": ["Car", "Apple", "Banana", "Mango"],
        },
        {
          "q": "Odd one out: Dog, Cat, Lion, Chair",
          "a": "Chair",
          "o": ["Lion", "Dog", "Cat", "Chair"],
        },
        {
          "q": "Odd one out: Red, Blue, Green, Ball",
          "a": "Ball",
          "o": ["Red", "Ball", "Blue", "Green"],
        },
        {
          "q": "Odd one out: Pen, Book, Table, Pencil",
          "a": "Table",
          "o": ["Book", "Pen", "Table", "Pencil"],
        },

        // ⚡ Comparison (Fast/Big/Small)
        {
          "q": "Which is faster?",
          "a": "Car",
          "o": ["Snail", "Turtle", "Car", "Stone"],
        },
        {
          "q": "Which is biggest?",
          "a": "Elephant",
          "o": ["Cat", "Cat", "Elephant", "Rat"],
        },
        {
          "q": "Which is smallest?",
          "a": "Ant",
          "o": ["Cow", "Dog", "Horse", "Ant"],
        },
        {
          "q": "Which is heavy?",
          "a": "Rock",
          "o": ["Rock", "Feather", "Paper", "Leaf"],
        },

        // 🧠 Simple Reasoning
        {
          "q": "What is used to open a door?",
          "a": "Key",
          "o": ["Key", "Book", "Pen", "Ball"],
        },
        {
          "q": "What do we use to eat rice?",
          "a": "Spoon",
          "o": ["Spoon", "Pencil", "Bag", "Shoes"],
        },
        {
          "q": "What helps us see in dark?",
          "a": "Torch",
          "o": ["Torch", "Book", "Plate", "Chair"],
        },
        {
          "q": "What do we use to drink water?",
          "a": "Glass",
          "o": ["Glass", "Pen", "Bag", "Shoes"],
        },

        // 🔁 Pattern Thinking
        {
          "q": "Pattern: A, C, E, ?",
          "a": "G",
          "o": ["G", "B", "D", "F"],
        },
        {
          "q": "Pattern: 2, 4, 8, ?",
          "a": "16",
          "o": ["16", "10", "12", "14"],
        },
        {
          "q": "Choose correct: I ___ a boy.",
          "a": "am",
          "o": ["is", "am", "are", "be"],
        },
        {
          "q": "Choose correct: She ___ happy.",
          "a": "is",
          "o": ["am", "is", "are", "was"],
        },
        {
          "q": "Choose correct: They ___ playing.",
          "a": "are",
          "o": ["is", "am", "are", "was"],
        },
        {
          "q": "Choose correct: He ___ my brother.",
          "a": "is",
          "o": ["am", "is", "are", "be"],
        },
        {
          "q": "Choose correct: We ___ friends.",
          "a": "are",
          "o": ["is", "am", "are", "was"],
        },
        {
          "q": "Choose correct: You ___ good.",
          "a": "are",
          "o": ["is", "am", "are", "be"],
        },
        {
          "q": "Choose correct: It ___ a cat.",
          "a": "is",
          "o": ["am", "is", "are", "be"],
        },
        {
          "q": "Choose correct: This is ___ apple.",
          "a": "an",
          "o": ["a", "an", "the", "no"],
        },
        {
          "q": "Choose correct: I have ___ dog.",
          "a": "a",
          "o": ["an", "a", "the", "my"],
        },
        {
          "q": "Choose correct: She eats ___ orange.",
          "a": "an",
          "o": ["a", "an", "the", "one"],
        },
        {
          "q": "Choose correct: He is ___ teacher.",
          "a": "a",
          "o": ["an", "a", "the", "good"],
        },
        {
          "q": "Choose correct: ___ is my book.",
          "a": "This",
          "o": ["This", "These", "That", "Those"],
        },
        {
          "q": "Choose correct: ___ are my toys.",
          "a": "These",
          "o": ["This", "These", "That", "Those"],
        },
        {
          "q": "Choose correct: ___ is a bird.",
          "a": "That",
          "o": ["This", "These", "That", "Those"],
        },
        {
          "q": "Choose correct: ___ are stars.",
          "a": "Those",
          "o": ["This", "These", "That", "Those"],
        },
        {
          "q": "Choose correct: I ___ to school.",
          "a": "go",
          "o": ["goes", "go", "going", "went"],
        },
        {
          "q": "Choose correct: She ___ to school.",
          "a": "goes",
          "o": ["go", "goes", "going", "gone"],
        },
        {
          "q": "Choose correct: They ___ football.",
          "a": "play",
          "o": ["plays", "play", "playing", "played"],
        },
        {
          "q": "Choose correct: He ___ football.",
          "a": "plays",
          "o": ["play", "plays", "playing", "played"],
        },
        {
          "q": "Choose correct: The cat ___ milk.",
          "a": "drinks",
          "o": ["drink", "drinks", "drinking", "drank"],
        },
        {
          "q": "Choose correct: Cats ___ milk.",
          "a": "drink",
          "o": ["drinks", "drink", "drinking", "drank"],
        },
        {
          "q": "Choose correct: I ___ a book.",
          "a": "have",
          "o": ["has", "have", "having", "had"],
        },
        {
          "q": "Choose correct: She ___ a doll.",
          "a": "has",
          "o": ["have", "has", "having", "had"],
        },
        {
          "q": "Choose correct: We ___ happy.",
          "a": "are",
          "o": ["is", "am", "are", "was"],
        },
        {
          "q": "Choose correct: The sky ___ blue.",
          "a": "is",
          "o": ["am", "is", "are", "be"],
        },
        {
          "q": "Choose correct: I like ___.",
          "a": "to read",
          "o": ["to eat", "to read", "to sleep", "to run"],
        },
        {
          "q": "Choose correct: My name ___ Ram.",
          "a": "is",
          "o": ["am", "is", "are", "be"],
        },
        {
          "q": "Choose correct: ___ name is Sita.",
          "a": "Her",
          "o": ["His", "Her", "My", "Your"],
        },
        {
          "q": "Choose correct: ___ name is Tom.",
          "a": "His",
          "o": ["Her", "His", "My", "Our"],
        },
        {
          "q": "Choose correct: This is ___ pen.",
          "a": "my",
          "o": ["me", "my", "I", "mine"],
        },
        {
          "q": "Choose correct: I see ___.",
          "a": "a bird",
          "o": ["an bird", "a bird", "bird", "the birds"],
        },
        {
          "q": "Choose correct: She is ___ girl.",
          "a": "a good",
          "o": ["an good", "a good", "good", "the good"],
        },
        {
          "q": "Choose correct: We ___ in Class 1.",
          "a": "are",
          "o": ["is", "am", "are", "be"],
        },
        {
          "q": "Choose correct: The dog ___ big.",
          "a": "is",
          "o": ["am", "is", "are", "be"],
        },
        {
          "q": "Choose correct: Dogs ___ big.",
          "a": "are",
          "o": ["is", "am", "are", "was"],
        },
        {
          "q": "Choose correct: I ___ two eyes.",
          "a": "have",
          "o": ["has", "have", "having", "had"],
        },
        {
          "q": "Choose correct: He ___ one nose.",
          "a": "has",
          "o": ["have", "has", "having", "had"],
        },
        {
          "q": "Choose correct: ___ is a banana.",
          "a": "This",
          "o": ["These", "This", "That", "Those"],
        },
        {
          "q": "Choose correct: ___ are bananas.",
          "a": "These",
          "o": ["This", "These", "That", "Those"],
        },
        {
          "q": "Choose correct: I can ___ fast.",
          "a": "run",
          "o": ["runs", "run", "running", "ran"],
        },
        {
          "q": "Choose correct: She can ___ well.",
          "a": "sing",
          "o": ["sings", "sing", "singing", "sang"],
        },
        {
          "q": "Choose correct: The sun ___ hot.",
          "a": "is",
          "o": ["am", "is", "are", "be"],
        },
        {
          "q": "Choose correct: Stars ___ bright.",
          "a": "are",
          "o": ["is", "am", "are", "was"],
        },
        {
          "q": "Choose correct: I ___ water.",
          "a": "drink",
          "o": ["drinks", "drink", "drinking", "drank"],
        },
        {
          "q": "Choose correct: Mom ___ food.",
          "a": "cooks",
          "o": ["cook", "cooks", "cooking", "cooked"],
        },
        {
          "q": "Choose correct: Dad ___ a car.",
          "a": "has",
          "o": ["have", "has", "having", "had"],
        },
        {
          "q": "Choose correct: We ___ to park.",
          "a": "go",
          "o": ["goes", "go", "going", "went"],
        },
        {
          "q": "Choose correct: The bird ___ fly.",
          "a": "can",
          "o": ["cans", "can", "canning", "could"],
        },
        {
          "q": "Choose correct: Fish ___ swim.",
          "a": "can",
          "o": ["cans", "can", "canning", "could"],
        },
        {
          "q": "Choose correct: I ___ 6 years old.",
          "a": "am",
          "o": ["is", "am", "are", "be"],
        },
      ],
    },
    // ================= CLASS 3 =================
    "Class 3": {
      "Math": [
        // ➕ BASIC + PATTERN
        {
          "q": "5 + 3 = ?",
          "a": "8",
          "o": ["6", "7", "8", "9"],
        },
        {
          "q": "10 - 4 = ?",
          "a": "6",
          "o": ["5", "6", "7", "8"],
        },
        {
          "q": "7 + 6 = ?",
          "a": "13",
          "o": ["12", "13", "14", "15"],
        },
        {
          "q": "15 - 7 = ?",
          "a": "8",
          "o": ["7", "8", "9", "10"],
        },

        // 🔢 MULTIPLICATION INTRO
        {
          "q": "2 × 3 = ?",
          "a": "6",
          "o": ["5", "6", "7", "8"],
        },
        {
          "q": "4 × 2 = ?",
          "a": "8",
          "o": ["6", "7", "8", "9"],
        },
        {
          "q": "3 × 3 = ?",
          "a": "9",
          "o": ["8", "9", "10", "12"],
        },

        // 🧠 WORD PROBLEMS
        {
          "q": "Ravi has 5 apples and gets 3 more. Total?",
          "a": "8",
          "o": ["6", "7", "8", "9"],
        },
        {
          "q": "There are 10 birds, 4 fly away. Left?",
          "a": "6",
          "o": ["5", "6", "7", "8"],
        },

        // 🔁 NUMBER SEQUENCE
        {
          "q": "What comes next? 2, 4, 6, ? 🤔 (Even numbers party!)",
          "a": "8",
          "o": ["5", "8", "11", "12"],
        },
        {
          "q": "What comes next? 1, 3, 5, ? 😄 (Odd numbers dancing!)",
          "a": "7",
          "o": ["4", "6", "7", "10"],
        },
        {
          "q":
              "What comes next? 10, 20, 30, ? 🚀 (Counting by 10 like a rocket!)",
          "a": "40",
          "o": ["20", "35", "40", "60"],
        },
        {
          "q": "What comes next? 5, 10, 15, ? 🍕 (Pizza slices increasing!)",
          "a": "20",
          "o": ["10", "18", "20", "30"],
        },
        {
          "q": "What comes next? 1, 4, 7, ? 🐒 (Monkey jumping 3 steps!)",
          "a": "10",
          "o": ["7", "9", "10", "13"],
        },
        {
          "q": "What comes next? 9, 8, 7, ? 🐢 (Turtle going down slowly!)",
          "a": "6",
          "o": ["3", "6", "7", "9"],
        },
        {
          "q": "What comes next? 3, 6, 9, ? 🎈 (Balloons flying in 3s!)",
          "a": "12",
          "o": ["6", "10", "12", "15"],
        },
        {
          "q": "What comes next? 2, 5, 8, ? 🐸 (Frog jumps 3 steps!)",
          "a": "11",
          "o": ["8", "10", "11", "14"],
        },
        {
          "q": "What comes next? 7, 14, 21, ? 🦁 (Lion counting loudly!)",
          "a": "28",
          "o": ["21", "24", "28", "35"],
        },
        {
          "q": "What comes next? 100, 90, 80, ? 🧊 (Ice melting down!)",
          "a": "70",
          "o": ["50", "60", "70", "90"],
        },

        // ❌ REASONING
        {
          "q": "Which is bigger? 🤔",
          "a": "15",
          "o": ["10", "12", "15", "9"],
        },
        {
          "q": "Which is smallest? 🧐",
          "a": "3",
          "o": ["3", "5", "7", "9"],
        },
        {
          "q": "Which is bigger? 🐘",
          "a": "20",
          "o": ["18", "20", "17", "19"],
        },
        {
          "q": "Which is smallest? 🐭",
          "a": "2",
          "o": ["4", "2", "6", "3"],
        },
        {
          "q": "Which is bigger? 🚀",
          "a": "50",
          "o": ["45", "50", "48", "49"],
        },
        {
          "q": "Which is smallest? 🍬",
          "a": "1",
          "o": ["2", "3", "1", "4"],
        },

        // 🧠 LOGIC MIX
        {
          "q": "Why did 6 cry? 😢",
          "a": "Because 7 ate 9!",
          "o": [
            "Because 5 was late",
            "Because 7 ate 9!",
            "Because 10 shouted",
            "Because 8 slept",
          ],
        },
        {
          "q": "What is 2 + 2? 🤓 (Easy peasy lemon squeezy!)",
          "a": "4",
          "o": ["3", "4", "5", "22"],
        },
        {
          "q": "If you eat 3 candies and get 2 more 🍬, how many now?",
          "a": "5",
          "o": ["4", "5", "6", "7"],
        },
        {
          "q": "Why was the equal sign (=) so happy? 😄",
          "a": "Because both sides were equal!",
          "o": [
            "Because it was funny",
            "Because both sides were equal!",
            "Because it was long",
            "Because it danced",
          ],
        },
        {
          "q": "What comes after 10? 🤔 (No cheating!)",
          "a": "11",
          "o": ["9", "10", "11", "12"],
        },
        {
          "q": "If you have 1 pizza 🍕 and eat it all, how many left?",
          "a": "0",
          "o": ["1", "0", "2", "10"],
        },
        {
          "q": "Why was 9 scared of 7? 😱",
          "a": "Because 7 ate 9!",
          "o": [
            "Because 6 shouted",
            "Because 7 ate 9!",
            "Because 8 ran away",
            "Because 10 laughed",
          ],
        },
        {
          "q": "What is 5 + 0? 😎 (Zero is lazy!)",
          "a": "5",
          "o": ["0", "5", "10", "50"],
        },
        {
          "q": "If you have 10 balloons 🎈 and 2 fly away, how many left?",
          "a": "8",
          "o": ["6", "7", "8", "9"],
        },
        {
          "q": "What is 1 + 1? 🤭 (Not 11 this time!)",
          "a": "2",
          "o": ["2", "11", "3", "1"],
        },
      ],
    },
    // ========== CLASS 4 =================
    "Class 4": {
      "Math": [
        {
          "q": "If 12 kids share 36 candies 🍬 equally, how many each?",
          "a": "3",
          "o": ["2", "3", "4", "5"],
        },
        {
          "q": "What is 25 × 4? 🧠 (Think fast!)",
          "a": "100",
          "o": ["80", "90", "100", "120"],
        },
        {
          "q": "If a book costs ₹50 and you buy 3 📚, total?",
          "a": "150",
          "o": ["100", "120", "150", "180"],
        },
        {
          "q": "What is 144 ÷ 12? 🤔",
          "a": "12",
          "o": ["10", "11", "12", "14"],
        },
        {
          "q": "If 1 dozen = 12 eggs 🥚, how many in 2 dozen?",
          "a": "24",
          "o": ["12", "18", "24", "30"],
        },
      ],

      "Logic": [
        {
          "q": "What comes next? 2, 6, 18, ? 🚀",
          "a": "54",
          "o": ["24", "36", "54", "72"],
        },
        {
          "q": "What comes next? 100, 90, 80, ? ⬇️",
          "a": "70",
          "o": ["60", "65", "70", "75"],
        },
        {
          "q": "Odd one out: Cow, Goat, Tiger, Lion 🐄",
          "a": "Goat",
          "o": ["Cow", "Goat", "Tiger", "Lion"],
        },
        {
          "q": "If yesterday was Monday, what is today? 📅",
          "a": "Tuesday",
          "o": ["Sunday", "Monday", "Tuesday", "Wednesday"],
        },
        {
          "q": "Which number is divisible by 5? 🔢",
          "a": "45",
          "o": ["42", "43", "44", "45"],
        },
      ],

      "Fun Thinking": [
        {
          "q":
              "I am a number. When you add 10 to me, I become 20. Who am I? 🤓",
          "a": "10",
          "o": ["5", "10", "15", "20"],
        },
        {
          "q": "I am less than 50 but more than 40, and even. Who am I? 😄",
          "a": "42",
          "o": ["41", "42", "43", "45"],
        },
        {
          "q": "What has 4 legs but cannot walk? 🪑",
          "a": "Table",
          "o": ["Dog", "Chair", "Table", "Horse"],
        },
        {
          "q": "If you multiply me by 0, what do you get? 😜",
          "a": "0",
          "o": ["0", "1", "Same number", "10"],
        },
        {
          "q": "What comes next? 1, 4, 9, 16, ? 🧩",
          "a": "25",
          "o": ["20", "24", "25", "30"],
        },
      ],
    },

    // ================= CLASS 5 =================
    "Class 5": {
      "Math": [
        {
          "q": "345 + 278 = ? 🧮 (Big numbers party 🎉)",
          "a": "623",
          "o": ["613", "623", "633", "643"],
        },
        {
          "q": "900 - 456 = ? 🤯 (Money spent on snacks 🍔)",
          "a": "444",
          "o": ["434", "444", "454", "464"],
        },
        {
          "q": "36 × 5 = ? 💪 (5 groups workout!)",
          "a": "180",
          "o": ["160", "170", "180", "190"],
        },
        {
          "q": "144 ÷ 12 = ? 🍫 (Sharing chocolates equally)",
          "a": "12",
          "o": ["10", "11", "12", "13"],
        },
        {
          "q": "25% of 200 = ? 🎯 (Quarter of treasure!)",
          "a": "50",
          "o": ["40", "50", "60", "70"],
        },
        {
          "q": "What is 999 + 1? 🚀 (Level up!)",
          "a": "1000",
          "o": ["999", "1000", "1001", "1010"],
        },
      ],

      "Logic": [
        {
          "q": "What comes next? 2, 6, 12, 20, ? 🧠",
          "a": "30",
          "o": ["28", "30", "32", "34"],
        },
        {
          "q": "Odd one out: Cat, Dog, Lion, Car 🚗",
          "a": "Car",
          "o": ["Car", "Cat", "Dog", "Lion"],
        },
        {
          "q": "If 3 apples cost 30 🍎, 1 apple costs?",
          "a": "10",
          "o": ["5", "10", "15", "20"],
        },
        {
          "q": "Which is smallest number? 🤏",
          "a": "0",
          "o": ["0", "1", "2", "3"],
        },
        {
          "q": "What is missing? 5, 10, 20, 40, ? 🚀",
          "a": "80",
          "o": ["60", "70", "80", "90"],
        },
        {
          "q": "What comes next? 1, 4, 9, 16, ? 🔍",
          "a": "25",
          "o": ["20", "24", "25", "30"],
        },
      ],

      "GK": [
        {
          "q": "Which planet is known as Red Planet? 🔴",
          "a": "Mars",
          "o": ["Earth", "Mars", "Jupiter", "Venus"],
        },
        {
          "q": "Who is called Father of Nation (India)? 🇮🇳",
          "a": "Mahatma Gandhi",
          "o": ["Nehru", "Gandhi", "Subhash", "Bhagat Singh"],
        },
        {
          "q": "Which animal is called King of Jungle? 🦁",
          "a": "Lion",
          "o": ["Tiger", "Lion", "Elephant", "Bear"],
        },
        {
          "q": "How many days in a week? 📅",
          "a": "7",
          "o": ["5", "6", "7", "8"],
        },
        {
          "q": "Which is largest ocean? 🌊",
          "a": "Pacific",
          "o": ["Atlantic", "Indian", "Pacific", "Arctic"],
        },
      ],

      "Meaning": [
        {
          "q": "Respect means? 🙏",
          "a": "Honor",
          "o": ["Honor", "Fight", "Run", "Eat"],
        },
        {
          "q": "Honesty means? 😊",
          "a": "Truthfulness",
          "o": ["Truthfulness", "Anger", "Fear", "Noise"],
        },
        {
          "q": "Wisdom means? 🧠",
          "a": "Smart thinking",
          "o": ["Smart thinking", "Running", "Eating", "Sleeping"],
        },
        {
          "q": "Brave means? 🦁",
          "a": "Fearless",
          "o": ["Fearless", "Lazy", "Angry", "Slow"],
        },
      ],
    },
  };
  // ================= LOAD QUESTIONS =================
  void loadQuestions() {
    questions = List.from(data[selectedClass]?[selectedTopic] ?? []);
    questions.shuffle(random);

    index = 0;
    score = 0;

    setState(() {});
  }

  // ================= ANSWER =================
  void answer(String opt) {
    if (opt == questions[index]["a"]) {
      score++;
    }

    if (index < questions.length - 1) {
      setState(() => index++);
    } else {
      showResult();
    }
  }

  // ================= RESULT =================
  void showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Quiz Completed"),
        content: Text("Score: $score / ${questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              loadQuestions();
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text("No Questions Found")));
    }

    final q = questions[index];

    return Scaffold(
      appBar: AppBar(title: const Text("Kids Quiz App 🎮")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= CLASS =================
            DropdownButton<String>(
              value: selectedClass,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "Class 1", child: Text("Class 1")),
                DropdownMenuItem(value: "Class 2", child: Text("Class 2")),
                DropdownMenuItem(value: "Class 3", child: Text("Class 3")),
                DropdownMenuItem(value: "Class 4", child: Text("Class 4")),
                DropdownMenuItem(value: "Class 5", child: Text("Class 5")),
              ],
              onChanged: (v) {
                setState(() {
                  selectedClass = v!;
                  selectedTopic = data[v]!.keys.first;
                  loadQuestions();
                });
              },
            ),

            // ================= TOPIC =================
            DropdownButton<String>(
              value: selectedTopic,
              isExpanded: true,
              items: data[selectedClass]!.keys
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  selectedTopic = v!;
                  loadQuestions();
                });
              },
            ),

            const SizedBox(height: 20),

            // ================= QUESTION =================
            Text(
              q["q"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // ================= OPTIONS =================
            ...(q["o"] as List<String>).map((opt) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  onPressed: () => answer(opt),
                  child: Text(opt),
                ),
              );
            }),

            const Spacer(),

            Text("Score: $score / ${questions.length}"),
          ],
        ),
      ),
    );
  }
}

//============= MINI GAME ======f===========

class GameMenuPage extends StatelessWidget {
  const GameMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fun Games 🎮")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            gameCard(
              context,
              "Counting Game",
              Icons.calculate,
              const CountingGamePage(),
            ),
            gameCard(
              context,
              "Story Game",
              Icons.menu_book,
              const StoryGamePage(),
            ),
            gameCard(context, "Guess Game", Icons.help, const MiniGamePage()),
            gameCard(
              context,
              "Color Game",
              Icons.color_lens,
              const ColorGamePage(),
            ),
            //gameCard(
            //context,
            //"Good Habits",
            //Icons.star,
            //const ValuesMatchGamePage(), // ✅ comma added,
          ],
        ),
      ),
    );
  }

  Widget gameCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.orange),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class MiniGamePage extends StatefulWidget {
  const MiniGamePage({super.key});

  @override
  State<MiniGamePage> createState() => _MiniGamePageState();
}

class _MiniGamePageState extends State<MiniGamePage> {
  final List<Map<String, String>> data = [
    {'word': 'Apple', 'hint': '🍎'},
    {'word': 'Banana', 'hint': '🍌'},
    {'word': 'Dog', 'hint': '🐶'},
    {'word': 'Cat', 'hint': '🐱'},
    {'word': 'Car', 'hint': '🚗'},
    {'word': 'Ball', 'hint': '⚽'},
    {'word': 'Fish', 'hint': '🐟'},
    {'word': 'Sun', 'hint': '☀️'},
    {'word': 'Moon', 'hint': '🌙'},
    {'word': 'Star', 'hint': '⭐'},
    {'word': 'Tree', 'hint': '🌳'},
    {'word': 'Flower', 'hint': '🌸'},
    {'word': 'Book', 'hint': '📚'},
    {'word': 'Pen', 'hint': '🖊️'},
    {'word': 'Bus', 'hint': '🚌'},
  ];

  int currentIndex = 0;
  List<String> options = [];
  Random random = Random();
  String message = "";
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadGame();
  }

  void loadGame() {
    currentIndex = random.nextInt(data.length);

    List<String> allWords = data.map((e) => e['word']!).toList();
    allWords.shuffle();

    options = allWords.take(4).toList();

    // Ensure correct answer is included
    if (!options.contains(data[currentIndex]['word'])) {
      options[0] = data[currentIndex]['word']!;
      options.shuffle();
    }

    setState(() => message = "");
  }

  void checkAnswer(String selected) {
    if (selected == data[currentIndex]['word']) {
      score++;
      setState(() => message = "🎉 Correct!");
    } else {
      setState(() => message = "❌ Wrong!");
    }

    Future.delayed(const Duration(seconds: 1), loadGame);
  }

  @override
  Widget build(BuildContext context) {
    final current = data[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guess Game 🎮"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Center(child: Text("⭐ $score")),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji Hint
          Text(current['hint']!, style: const TextStyle(fontSize: 70)),

          const SizedBox(height: 20),

          // Options
          ...options.map((option) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: ElevatedButton(
                onPressed: () => checkAnswer(option),
                child: Text(option),
              ),
            );
          }).toList(),

          const SizedBox(height: 20),

          Text(message, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}

class ColorGamePage extends StatefulWidget {
  const ColorGamePage({super.key});

  @override
  State<ColorGamePage> createState() => _ColorGamePageState();
}

class _ColorGamePageState extends State<ColorGamePage> {
  final Map<String, Color> colors = {
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
    'Purple': Colors.purple,
    'Orange': Colors.orange,
  };

  late String target;
  List<String> options = [];
  String msg = "";
  int score = 0;
  int timeLeft = 10;
  int level = 1;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    level = 1;
    next();
    startTimer();
  }

  void startTimer() {
    timeLeft = 10;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (timeLeft > 0) {
        setState(() => timeLeft--);
        return true;
      } else {
        setState(() => msg = "⏰ Time's up!");
        await Future.delayed(const Duration(seconds: 1));
        next();
        return false;
      }
    });
  }

  void next() {
    final keys = colors.keys.toList()..shuffle();
    target = keys[0];
    options = keys.take(4).toList();
    setState(() => msg = "");
    startTimer();
  }

  void check(String c) {
    if (c == target) {
      score++;
      if (score % 5 == 0) level++; // level up every 5 points
      setState(() => msg = "🎉 Correct! +1");
    } else {
      setState(() => msg = "❌ Oops! Try again");
    }

    Future.delayed(const Duration(milliseconds: 800), next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🎨 Color Game"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Score: $score   Level: $level",
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 10),

          Text(
            "⏳ Time: $timeLeft",
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),

          const SizedBox(height: 20),

          Text(
            "Find: $target 🎯",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            children: options.map((c) {
              return GestureDetector(
                onTap: () => check(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 90,
                  height: 90,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors[c],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Text(
            msg,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: startGame, child: const Text("🔄 Restart")),
        ],
      ),
    );
  }
}

class CountingGamePage extends StatefulWidget {
  const CountingGamePage({super.key});

  @override
  State<CountingGamePage> createState() => _CountingGamePageState();
}

class _CountingGamePageState extends State<CountingGamePage> {
  int target = 0;
  int tapped = 0;
  String message = "";
  int score = 0;
  int level = 1;
  int timeLeft = 10;

  Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    level = 1;
    nextRound();
  }

  void nextRound() {
    setState(() {
      target = random.nextInt(5) + level; // small + level based
      tapped = 0;
      message = "";
      timeLeft = 10;
    });
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (timeLeft > 0) {
        setState(() => timeLeft--);
        return true;
      } else {
        setState(() => message = "⏰ Time's up!");
        await Future.delayed(const Duration(seconds: 1));
        nextRound();
        return false;
      }
    });
  }

  void tapApple() {
    if (tapped < target) {
      setState(() {
        tapped++;
        message = "🍎 Yum!";
      });
    }

    if (tapped == target) {
      score++;
      if (score % 3 == 0) level++; // level up

      setState(() => message = "🎉 Perfect Count!");

      Future.delayed(const Duration(milliseconds: 800), nextRound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🍎 Counting Game"), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Score: $score   Level: $level",
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 10),

          Text(
            "⏳ Time: $timeLeft",
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),

          const SizedBox(height: 20),

          Text(
            "Tap $target Apples 🎯",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(target + 2, (index) {
              // extra apples to confuse 😄
              return GestureDetector(
                onTap: tapApple,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(8),
                  child: const Text("🍎", style: TextStyle(fontSize: 45)),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          Text("Tapped: $tapped", style: const TextStyle(fontSize: 20)),

          const SizedBox(height: 10),

          Text(
            message,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ElevatedButton(onPressed: startGame, child: const Text("🔄 Restart")),
        ],
      ),
    );
  }
}

class StoryGamePage extends StatefulWidget {
  const StoryGamePage({super.key});

  @override
  State<StoryGamePage> createState() => _StoryGamePageState();
}

class _StoryGamePageState extends State<StoryGamePage> {
  final Random random = Random();

  List<Map<String, dynamic>> questions = [
    {
      "text": "👦 You meet your teacher.",
      "options": ["Greet politely", "Ignore"],
      "correct": "Greet politely",
      "explain": "Greeting shows respect.",
    },
    {
      "text": "👴 Old man needs help.",
      "options": ["Help", "Ignore"],
      "correct": "Help",
      "explain": "Helping is kindness.",
    },
    {
      "text": "🧑 New friend meets you.",
      "options": ["Smile & say hello", "Stay silent"],
      "correct": "Smile & say hello",
      "explain": "Smile builds friendship.",
    },
    {
      "text": "🏫 Teacher teaching.",
      "options": ["Listen", "Disturb"],
      "correct": "Listen",
      "explain": "Listening improves learning.",
    },
    {
      "text": "🏠 Parents ask help.",
      "options": ["Help happily", "Refuse"],
      "correct": "Help happily",
      "explain": "Helping builds responsibility.",
    },
    {
      "text": "📱 Someone talking.",
      "options": ["Listen", "Use phone"],
      "correct": "Listen",
      "explain": "Respect others while talking.",
    },
    {
      "text": "😡 Angry with friend.",
      "options": ["Talk calmly", "Shout"],
      "correct": "Talk calmly",
      "explain": "Calmness solves problems.",
    },
    {
      "text": "🎒 School assembly.",
      "options": ["Stand properly", "Talk"],
      "correct": "Stand properly",
      "explain": "Discipline matters.",
    },
    {
      "text": "🚶 Walk on road.",
      "options": ["Follow rules", "Run anywhere"],
      "correct": "Follow rules",
      "explain": "Safety first.",
    },
    {
      "text": "🍫 Have chocolates.",
      "options": ["Share", "Eat alone"],
      "correct": "Share",
      "explain": "Sharing is caring.",
    },

    {
      "text": "👵 Talking to grandmother.",
      "options": ["Speak politely", "Be rude"],
      "correct": "Speak politely",
      "explain": "Respect elders.",
    },
    {
      "text": "📚 Homework time.",
      "options": ["Complete on time", "Skip"],
      "correct": "Complete on time",
      "explain": "Discipline builds success.",
    },
    {
      "text": "🧹 Room is dirty.",
      "options": ["Clean", "Ignore"],
      "correct": "Clean",
      "explain": "Cleanliness is good habit.",
    },
    {
      "text": "🤝 Friend needs help.",
      "options": ["Help", "Laugh"],
      "correct": "Help",
      "explain": "Helping builds friendship.",
    },
    {
      "text": "📢 Teacher asks question.",
      "options": ["Answer politely", "Stay silent"],
      "correct": "Answer politely",
      "explain": "Confidence matters.",
    },

    {
      "text": "😴 In class feeling sleepy.",
      "options": ["Stay active", "Sleep"],
      "correct": "Stay active",
      "explain": "Focus is important.",
    },
    {
      "text": "🍎 Lunch time.",
      "options": ["Share food", "Hide food"],
      "correct": "Share food",
      "explain": "Sharing builds love.",
    },
    {
      "text": "🎤 Speaking on stage.",
      "options": ["Speak confidently", "Be afraid"],
      "correct": "Speak confidently",
      "explain": "Confidence grows personality.",
    },
    {
      "text": "🧍 Meeting strangers.",
      "options": ["Be polite", "Be rude"],
      "correct": "Be polite",
      "explain": "Politeness is key.",
    },
    {
      "text": "📖 Reading book.",
      "options": ["Focus", "Play mobile"],
      "correct": "Focus",
      "explain": "Focus improves knowledge.",
    },

    {
      "text": "🧒 Younger sibling cries.",
      "options": ["Help", "Ignore"],
      "correct": "Help",
      "explain": "Care for others.",
    },
    {
      "text": "📦 Found lost item.",
      "options": ["Return", "Keep"],
      "correct": "Return",
      "explain": "Honesty is best.",
    },
    {
      "text": "🧑‍🏫 Teacher scolds.",
      "options": ["Accept mistake", "Argue"],
      "correct": "Accept mistake",
      "explain": "Learn from mistakes.",
    },
    {
      "text": "🧼 Hands dirty.",
      "options": ["Wash", "Ignore"],
      "correct": "Wash",
      "explain": "Hygiene is important.",
    },
    {
      "text": "🚸 Crossing road.",
      "options": ["Use zebra crossing", "Run"],
      "correct": "Use zebra crossing",
      "explain": "Follow safety rules.",
    },

    {
      "text": "📅 Time management.",
      "options": ["Plan work", "Waste time"],
      "correct": "Plan work",
      "explain": "Planning helps success.",
    },
    {
      "text": "💬 Talking to elders.",
      "options": ["Use respectful words", "Use slang"],
      "correct": "Use respectful words",
      "explain": "Respect shows personality.",
    },
    {
      "text": "📖 Exam time.",
      "options": ["Study honestly", "Cheat"],
      "correct": "Study honestly",
      "explain": "Honesty is important.",
    },
    {
      "text": "🎯 Goal setting.",
      "options": ["Work hard", "Give up"],
      "correct": "Work hard",
      "explain": "Hard work leads success.",
    },
    {
      "text": "🌟 Daily habit.",
      "options": ["Be positive", "Complain"],
      "correct": "Be positive",
      "explain": "Positive thinking improves life.",
    },
  ];

  int index = 0;
  int score = 0;
  String message = "";
  String explanation = "";

  void choose(String option) {
    final q = questions[index];

    if (option == q["correct"]) {
      score++;
      message = "🌟 Awesome!";
    } else {
      message = "😅 Try better!";
    }

    explanation = q["explain"];
    setState(() {});

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        index++;
        message = "";
        explanation = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (index >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text("Story Learning 📖")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🎉 Completed!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Score: $score / ${questions.length}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              const Text(
                "💡 Be polite, confident and helpful.\nYou are becoming a great personality!",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    index = 0;
                    score = 0;
                  });
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
        ),
      );
    }

    final q = questions[index];

    return Scaffold(
      appBar: AppBar(
        title: Text("Story Learning 📖 (${index + 1}/${questions.length})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(value: (index + 1) / questions.length),

            const SizedBox(height: 20),

            Text(
              q["text"],
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            ...q["options"].map<Widget>((opt) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => choose(opt),
                  child: Text(opt),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            Text(
              message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(explanation, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Manvi Sharma"),
            Text("University Roll No: 2342010386"),
            Text("Class Roll No: 31"),
            Text("Section: C"),
            Text("Department/Year: BCA 3rd Year"),
            Text("University: GLA University Mathura"),
          ],
        ),
      ),
    );
  }
}
