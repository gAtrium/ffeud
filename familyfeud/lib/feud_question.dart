class CfeudQuestion {
  String question = "";
  List<String> answers = [];
  List<int> answerPoints = [];
  CfeudQuestion(this.question, this.answers, int partamount) {
    List<int> distribution = List<int>.generate(
        partamount, (i) => 100 ~/ (i + 1)); // generate descending distribution

    int total = distribution.reduce((a, b) => a + b); // sum of distribution
    answerPoints = distribution
        .map((value) => (value ~/ total) * 100)
        .toList(); // divide by total and multiply by 100 to get percentage
  }
}

String Question1_question = """ Fill in the blank. 
If you are bored, you should ..... """;

List<String> Question1_answers = [
  "Read a book",
  "Watch a movie",
  "Call a friend",
  "Play a game",
  "Take a nap ",
  "Learn a new skill",
  "Go for a walk",
  "Clean your room",
  "Listen to music"
];
List<int> Question1_popularities = [25, 20, 15, 12, 10, 8, 5, 3, 2];

String emergency_question = """Fill in the blank.
In case of a heart attack, you should ......""";

List<String> emergency_answers = [
  "Call an ambulance",
  "Lie down and rest",
  "Take aspirin",
  "Perform CPR",
  "Stay calm and focused",
  "Chew and swallow an aspirin",
  "Loosen tight clothing",
  "Wait and see if symptoms go away",
  "Do not ignore or delay seeking medical attention"
];

List<int> emergency_popularities = [40, 20, 10, 8, 6, 5, 4, 3, 2];
