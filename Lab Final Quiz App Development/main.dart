import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Quiz',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

// 🏠 Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.quiz_rounded, color: Colors.white, size: 100),
              const SizedBox(height: 30),
              Text(
                "Smart Quiz",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text("Start Quiz"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 📂 Category Screen
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final res =
        await http.get(Uri.parse("https://opentdb.com/api_category.php"));
    final data = jsonDecode(res.body);
    setState(() {
      categories = data["trivia_categories"];
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Category"), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var cat = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizConfigScreen(
                          categoryId: cat["id"],
                          name: cat["name"],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 6,
                    color: Colors.deepPurple.shade50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          cat["name"],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ⚙️ Quiz Config Screen
class QuizConfigScreen extends StatefulWidget {
  final int categoryId;
  final String name;
  const QuizConfigScreen(
      {super.key, required this.categoryId, required this.name});
  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  String difficulty = "easy";
  int amount = 5;
  String type = "multiple";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Difficulty",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: ["easy", "medium", "hard"].map((level) {
                return ChoiceChip(
                  label: Text(level.toUpperCase()),
                  selected: difficulty == level,
                  onSelected: (v) => setState(() => difficulty = level),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            const Text("Select Question Type",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  label: const Text("Multiple Choice"),
                  selected: type == "multiple",
                  onSelected: (v) => setState(() => type = "multiple"),
                ),
                ChoiceChip(
                  label: const Text("True / False"),
                  selected: type == "boolean",
                  onSelected: (v) => setState(() => type = "boolean"),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text("Number of Questions: $amount",
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: amount.toDouble(),
              min: 5,
              max: 20,
              divisions: 3,
              label: "$amount",
              activeColor: Colors.deepPurple,
              onChanged: (v) => setState(() => amount = v.toInt()),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        categoryId: widget.categoryId,
                        difficulty: difficulty,
                        amount: amount,
                        type: type,
                      ),
                    ),
                  );
                },
                child: const Text("Start Quiz"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ❓ Quiz Screen with Prev/Next
class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String difficulty;
  final int amount;
  final String type;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.difficulty,
    required this.amount,
    required this.type,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List questions = [];
  int index = 0;
  int score = 0;
  bool loading = true;
  List<String?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final url =
        "https://opentdb.com/api.php?amount=${widget.amount}&category=${widget.categoryId}&difficulty=${widget.difficulty}&type=${widget.type}";
    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);
    setState(() {
      questions = data["results"];
      selectedAnswers = List.filled(questions.length, null);
      loading = false;
    });
  }

  void handleAnswer(String option) {
    final correct = questions[index]["correct_answer"];
    setState(() {
      selectedAnswers[index] = option;
    });
    if (index == questions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: selectedAnswers
                .where((a) =>
                    a != null &&
                    a ==
                        questions[selectedAnswers.indexOf(a)]["correct_answer"])
                .length,
            total: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    var q = questions[index];
    List<String> options = List<String>.from(q["incorrect_answers"]);
    options.add(q["correct_answer"]);
    options.shuffle();

    String? selected = selectedAnswers[index];

    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${index + 1}/${questions.length}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q["question"],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            ...options.map((opt) {
              final isCorrect = opt == q["correct_answer"];
              Color? color;

              if (selected != null) {
                if (opt == selected) {
                  color = selected == q["correct_answer"]
                      ? Colors.green.shade200
                      : Colors.red.shade200;
                } else if (isCorrect) {
                  color = Colors.green.shade100;
                }
              }

              return Card(
                color: color,
                child: ListTile(
                  title: Text(opt),
                  onTap: selected == null ? () => handleAnswer(opt) : null,
                ),
              );
            }),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  label: const Text("Previous"),
                  onPressed: index > 0 ? () => setState(() => index--) : null,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward_ios),
                  label: const Text("Next"),
                  onPressed: index < questions.length - 1
                      ? () => setState(() => index++)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 🏁 Result Screen
class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  const ResultScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).round();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B247A), Color(0xFF1BCEDF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events_rounded,
                    color: Colors.white, size: 100),
                const SizedBox(height: 20),
                Text("Your Score",
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 20)),
                Text("$score / $total",
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Text("$percent%",
                    style: GoogleFonts.poppins(
                        color: Colors.white70, fontSize: 22)),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Play Again"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
