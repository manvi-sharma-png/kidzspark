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
          "o": ["B", "C", "D", "E"],
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
          "o": ["L", "N", "O", "P"],
        },

        {
          "q": "What comes before B?",
          "a": "A",
          "o": ["A", "C", "D", "E"],
        },
        {
          "q": "What comes before D?",
          "a": "C",
          "o": ["A", "B", "C", "E"],
        },
        {
          "q": "What comes before G?",
          "a": "F",
          "o": ["E", "F", "G", "H"],
        },

        {
          "q": "Which comes between A and C?",
          "a": "B",
          "o": ["B", "D", "E", "F"],
        },
        {
          "q": "Which comes between D and F?",
          "a": "E",
          "o": ["E", "G", "H", "I"],
        },

        {
          "q": "Arrange: A, B, ?, D",
          "a": "C",
          "o": ["C", "E", "F", "G"],
        },
        {
          "q": "Arrange: E, F, ?, H",
          "a": "G",
          "o": ["G", "I", "J", "K"],
        },

        {
          "q": "Which letter is first?",
          "a": "A",
          "o": ["A", "B", "C", "D"],
        },
        {
          "q": "Which letter is last?",
          "a": "Z",
          "o": ["Z", "Y", "X", "W"],
        },

        {
          "q": "Which comes after K?",
          "a": "L",
          "o": ["L", "M", "N", "O"],
        },
        {
          "q": "Which comes after T?",
          "a": "U",
          "o": ["U", "V", "W", "X"],
        },

        {
          "q": "Which comes before M?",
          "a": "L",
          "o": ["L", "N", "O", "P"],
        },
        {
          "q": "Which comes before S?",
          "a": "R",
          "o": ["R", "T", "U", "V"],
        },

        {
          "q": "Skip letter: A, B, ?, D",
          "a": "C",
          "o": ["C", "E", "F", "G"],
        },
        {
          "q": "Skip letter: G, H, ?, J",
          "a": "I",
          "o": ["I", "K", "L", "M"],
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
          "o": ["Chair", "Dog", "Cat", "Lion"],
        },
        {
          "q": "Odd one out: Red, Blue, Green, Ball",
          "a": "Ball",
          "o": ["Ball", "Red", "Blue", "Green"],
        },
        {
          "q": "Odd one out: Pen, Book, Table, Pencil",
          "a": "Table",
          "o": ["Table", "Pen", "Book", "Pencil"],
        },

        // ⚡ Comparison (Fast/Big/Small)
        {
          "q": "Which is faster?",
          "a": "Car",
          "o": ["Car", "Turtle", "Snail", "Stone"],
        },
        {
          "q": "Which is biggest?",
          "a": "Elephant",
          "o": ["Elephant", "Cat", "Dog", "Rat"],
        },
        {
          "q": "Which is smallest?",
          "a": "Ant",
          "o": ["Ant", "Dog", "Horse", "Cow"],
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
          "q": "What comes next? 2, 4, 6, ?",
          "a": "8",
          "o": ["7", "8", "9", "10"],
        },
        {
          "q": "What comes next? 1, 3, 5, ?",
          "a": "7",
          "o": ["6", "7", "8", "9"],
        },
        {
          "q": "What comes next? 10, 20, 30, ?",
          "a": "40",
          "o": ["35", "40", "45", "50"],
        },

        // ❌ REASONING
        {
          "q": "Which is bigger?",
          "a": "15",
          "o": ["10", "12", "15", "9"],
        },
        {
          "q": "Which is smallest?",
          "a": "3",
          "o": ["3", "5", "7", "9"],
        },

        // 🧠 LOGIC MIX
        {
          "q": "If you have 2 hands, how many fingers total?",
          "a": "10",
          "o": ["8", "10", "12", "14"],
        },
        {
          "q": "What is 6 + 6?",
          "a": "12",
          "o": ["10", "11", "12", "13"],
        },

        // 🔥 HARD LEVEL
        {
          "q": "20 - 9 = ?",
          "a": "11",
          "o": ["10", "11", "12", "13"],
        },
        {
          "q": "5 + 5 + 5 = ?",
          "a": "15",
          "o": ["10", "15", "20", "25"],
        },
      ],
    },
    // ========== CLASS 4 =================
    "Class 4": {
      "Math": [
        {
          "q": "125 + 75 = ?",
          "a": "200",
          "o": ["180", "190", "200", "210"],
        },
        {
          "q": "240 - 95 = ?",
          "a": "145",
          "o": ["135", "145", "155", "165"],
        },
        {
          "q": "15 × 4 = ?",
          "a": "60",
          "o": ["50", "55", "60", "65"],
        },
        {
          "q": "100 ÷ 4 = ?",
          "a": "25",
          "o": ["20", "25", "30", "35"],
        },
        {
          "q": "What is half of 90?",
          "a": "45",
          "o": ["40", "45", "50", "55"],
        },
      ],

      "Logic": [
        {
          "q": "What comes next? 3, 6, 9, ?",
          "a": "12",
          "o": ["10", "11", "12", "13"],
        },
        {
          "q": "Odd one out: Apple, Mango, Car, Banana",
          "a": "Car",
          "o": ["Car", "Apple", "Mango", "Banana"],
        },
        {
          "q": "Which is heavier?",
          "a": "Rock",
          "o": ["Feather", "Leaf", "Rock", "Paper"],
        },
        {
          "q": "What is missing? Sun, Moon, Stars, ?",
          "a": "Sky",
          "o": ["Sky", "Tree", "Car", "Book"],
        },
        {
          "q": "Which is fastest?",
          "a": "Aeroplane",
          "o": ["Bike", "Train", "Car", "Aeroplane"],
        },
      ],

      "Meaning": [
        {
          "q": "Honest means?",
          "a": "Truthful",
          "o": ["Truthful", "Lazy", "Fast", "Weak"],
        },
        {
          "q": "Brave means?",
          "a": "Fearless",
          "o": ["Fearless", "Weak", "Slow", "Angry"],
        },
        {
          "q": "Kind means?",
          "a": "Helpful",
          "o": ["Helpful", "Rude", "Angry", "Lazy"],
        },
      ],
    },

    // ================= CLASS 5 =================
    "Class 5": {
      "Math": [
        {
          "q": "345 + 278 = ?",
          "a": "623",
          "o": ["613", "623", "633", "643"],
        },
        {
          "q": "900 - 456 = ?",
          "a": "444",
          "o": ["434", "444", "454", "464"],
        },
        {
          "q": "36 × 5 = ?",
          "a": "180",
          "o": ["160", "170", "180", "190"],
        },
        {
          "q": "144 ÷ 12 = ?",
          "a": "12",
          "o": ["10", "11", "12", "13"],
        },
        {
          "q": "25% of 200 = ?",
          "a": "50",
          "o": ["40", "50", "60", "70"],
        },
      ],

      "Logic": [
        {
          "q": "What comes next? 2, 6, 12, 20, ?",
          "a": "30",
          "o": ["28", "30", "32", "34"],
        },
        {
          "q": "Odd one out: Cat, Dog, Lion, Car",
          "a": "Car",
          "o": ["Car", "Cat", "Dog", "Lion"],
        },
        {
          "q": "If 3 apples cost 30, 1 apple costs?",
          "a": "10",
          "o": ["5", "10", "15", "20"],
        },
        {
          "q": "Which is smallest number?",
          "a": "0",
          "o": ["0", "1", "2", "3"],
        },
        {
          "q": "What is missing? 5, 10, 20, 40, ?",
          "a": "80",
          "o": ["60", "70", "80", "90"],
        },
      ],

      "Meaning": [
        {
          "q": "Respect means?",
          "a": "Honor",
          "o": ["Honor", "Fight", "Run", "Eat"],
        },
        {
          "q": "Honesty means?",
          "a": "Truthfulness",
          "o": ["Truthfulness", "Anger", "Fear", "Noise"],
        },
        {
          "q": "Wisdom means?",
          "a": "Smart thinking",
          "o": ["Smart thinking", "Running", "Eating", "Sleeping"],
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
  };

  late String target;
  List<String> options = [];
  String msg = "";

  @override
  void initState() {
    super.initState();
    next();
  }

  void next() {
    final keys = colors.keys.toList()..shuffle();
    target = keys[0];
    options = keys.take(4).toList();
    setState(() => msg = "");
  }

  void check(String c) {
    setState(() => msg = c == target ? "🎉 Correct!" : "❌ Wrong");
    Future.delayed(const Duration(seconds: 1), next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Color Game")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Find $target", style: const TextStyle(fontSize: 22)),
          Wrap(
            children: options.map((c) {
              return GestureDetector(
                onTap: () => check(c),
                child: Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.all(10),
                  color: colors[c],
                ),
              );
            }).toList(),
          ),
          Text(msg),
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
  Random random = Random();

  @override
  void initState() {
    super.initState();
    newGame();
  }

  void newGame() {
    setState(() {
      target = random.nextInt(100) + 1; // 1 to 5
      tapped = 0;
      message = "";
    });
  }

  void tapApple() {
    if (tapped < target) {
      setState(() => tapped++);
    }

    if (tapped == target) {
      setState(() => message = "🎉 Great! You counted correctly!");
      Future.delayed(const Duration(seconds: 1), newGame);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counting Game 🎮")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Count $target Apples 🍎",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(target, (index) {
              return GestureDetector(
                onTap: tapApple,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text("🍎", style: TextStyle(fontSize: 50)),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          Text("Tapped: $tapped", style: const TextStyle(fontSize: 20)),

          const SizedBox(height: 10),

          Text(message, style: const TextStyle(fontSize: 20)),
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

  List<Map<String, dynamic>> allQuestions = [
    {
      "text": "👦 Rahul sees an old man carrying bags.",
      "options": ["Help him", "Ignore"],
      "correct": "Help him",
    },
    {
      "text": "🍫 Rahul has chocolates. Friend asks.",
      "options": ["Share", "Refuse"],
      "correct": "Share",
    },
    {
      "text": "👵 Talking to grandmother.",
      "options": ["Speak politely", "Be rude"],
      "correct": "Speak politely",
    },
    {
      "text": "🧒 Friend falls while playing.",
      "options": ["Help", "Laugh"],
      "correct": "Help",
    },
    {
      "text": "📚 In classroom teacher is teaching.",
      "options": ["Listen", "Disturb"],
      "correct": "Listen",
    },
    {
      "text": "🏠 At home parents ask for help.",
      "options": ["Help", "Ignore"],
      "correct": "Help",
    },
  ];

  List<Map<String, dynamic>> selectedQuestions = [];

  int step = 0;
  int score = 0;
  String message = "";

  @override
  void initState() {
    super.initState();
    loadDailyQuestions();
  }

  void loadDailyQuestions() {
    List<Map<String, dynamic>> temp = List.from(allQuestions);
    temp.shuffle();

    selectedQuestions = temp.take(3).toList(); // ⭐ only 3 questions

    step = 0;
    score = 0;
    message = "";
  }

  void choose(String option) {
    if (option == selectedQuestions[step]["correct"]) {
      score++;
      message = "🎉 Good Choice!";
    } else {
      message = "❌ Not correct";
    }

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        step++;
        message = "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (step >= selectedQuestions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text("Story Game 📖")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🎉 Completed!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Score: $score / ${selectedQuestions.length}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    loadDailyQuestions(); // 🔄 new random set
                  });
                },
                child: const Text("Play Again"),
              ),
            ],
          ),
        ),
      );
    }

    final q = selectedQuestions[step];

    return Scaffold(
      appBar: AppBar(title: const Text("Story Game 📖")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

            Text(message, style: const TextStyle(fontSize: 18)),
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
