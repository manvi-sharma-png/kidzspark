import 'dart:math'; //
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Student'), // 👈 ADD

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

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  int stars = 0;

  bool answered = false;
  String? selectedOption;

  List<int> usedQuestions = [];
  Random random = Random();

  int timeLeft = 10;
  Timer? timer;

  final List<Map<String, Object>> questions = [
    {
      'question': 'Which is a fruit?',
      'options': ['Carrot', 'Apple', 'Onion', 'Potato'],
      'answer': 'Apple',
    },
    {
      'question': 'Which is a color?',
      'options': ['Dog', 'Red', 'Hand', 'Banana'],
      'answer': 'Red',
    },
    {
      'question': 'Which is a body part?',
      'options': ['Leg', 'Mango', 'Blue', 'Tomato'],
      'answer': 'Leg',
    },
    {
      'question': 'Which is a vegetable?',
      'options': ['Banana', 'Potato', 'Cat', 'Pink'],
      'answer': 'Potato',
    },
  ];

  @override
  void initState() {
    super.initState();
    nextRandomQuestion();
  }

  void startTimer() {
    timeLeft = 10;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft == 0) {
        t.cancel();
        nextRandomQuestion();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  void nextRandomQuestion() {
    if (usedQuestions.length == questions.length) {
      showResult();
      return;
    }

    int newIndex;
    do {
      newIndex = random.nextInt(questions.length);
    } while (usedQuestions.contains(newIndex));

    usedQuestions.add(newIndex);

    setState(() {
      currentQuestion = newIndex;
      answered = false;
      selectedOption = null;
    });

    startTimer();
  }

  void answerQuestion(String selected) {
    if (answered) return;

    timer?.cancel();

    setState(() {
      answered = true;
      selectedOption = selected;
    });

    bool isCorrect = selected == questions[currentQuestion]['answer'];

    if (isCorrect) {
      score++;
      stars += 10;
    }

    Future.delayed(const Duration(seconds: 1), () {
      nextRandomQuestion();
    });
  }

  Color getOptionColor(String option) {
    if (!answered) return Colors.blue;

    if (option == questions[currentQuestion]['answer']) {
      return Colors.green;
    }

    if (option == selectedOption) {
      return Colors.red;
    }

    return Colors.grey;
  }

  void showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Game Over"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Score: $score / ${questions.length}"),
            const SizedBox(height: 10),
            Text("Stars: ⭐ $stars"),
            const SizedBox(height: 10),
            Text(
              score >= 3 ? "🏆 Awesome!" : "🙂 Try Again",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                stars = 0;
                usedQuestions.clear();
              });
              nextRandomQuestion();
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Game 🎮")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: timeLeft / 10,
              backgroundColor: const Color.fromARGB(255, 255, 0, 0),
              color: Colors.orange,
            ),
            const SizedBox(height: 10),
            Text("⏱ Time: $timeLeft sec"),

            const SizedBox(height: 20),

            Text(
              q['question'] as String,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ...(q['options'] as List<String>).map((option) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getOptionColor(option),
                  ),
                  onPressed: () => answerQuestion(option),
                  child: Text(option),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
// ================= MINI GAME =================

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
            gameCard(context, "Color Game", Icons.color_lens, const ColorGamePage()),
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
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji Hint
          Text(
            current['hint']!,
            style: const TextStyle(fontSize: 70),
          ),

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

          Text(
            message,
            style: const TextStyle(fontSize: 20),
          ),
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
      "correct": "Help him"
    },
    {
      "text": "🍫 Rahul has chocolates. Friend asks.",
      "options": ["Share", "Refuse"],
      "correct": "Share"
    },
    {
      "text": "👵 Talking to grandmother.",
      "options": ["Speak politely", "Be rude"],
      "correct": "Speak politely"
    },
    {
      "text": "🧒 Friend falls while playing.",
      "options": ["Help", "Laugh"],
      "correct": "Help"
    },
    {
      "text": "📚 In classroom teacher is teaching.",
      "options": ["Listen", "Disturb"],
      "correct": "Listen"
    },
    {
      "text": "🏠 At home parents ask for help.",
      "options": ["Help", "Ignore"],
      "correct": "Help"
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
              )
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
      appBar: AppBar(title: const Text("Student Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Name: Your Name"),
            Text("University Roll No: XXXXX"),
            Text("Class Roll No: XXX"),
            Text("Section: X"),
            Text("Department/Year: BCA 2nd Year"),
            Text("University: Your University Name"),
          ],
        ),
      ),
    );
  }
}