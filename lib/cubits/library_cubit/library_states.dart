abstract class LibraryState {}

class LibraryInitState extends LibraryState {}

// for classes
class LibraryClassLoadingState extends LibraryState {}

class LibraryAddNewClassState extends LibraryState {}

class LibraryEditClassState extends LibraryState {
  LibraryEditClassState(this.index);
  int index;
}

class LibraryDeleteClassState extends LibraryState {
  LibraryDeleteClassState(this.index);
  int index;
}

class LibrarySuccessOpenWordsScreenState extends LibraryState {}

// for words
class LibraryWordLoadingState extends LibraryState {}

class LibraryAddNewWordState extends LibraryState {
  LibraryAddNewWordState(this.classIndex);
  int classIndex;
}

class LibraryEditWordState extends LibraryState {
  LibraryEditWordState(this.classIndex, this.wordIndex);
  int classIndex;
  int wordIndex;
}

class LibraryDeleteWordState extends LibraryState {
  LibraryDeleteWordState(this.classIndex, this.wordIndex);
  int classIndex;
  int wordIndex;
}

class LibrarySuccessState extends LibraryState {}

class LibraryErrorState extends LibraryState {
  LibraryErrorState(this.errorMessage);
  String errorMessage;
}

class LibrarySelectChallengeSystem extends LibraryState {}

class LibrarySelectRandomWordsChallenge extends LibraryState {}

class LibraryStartRandomWordsChallenge extends LibraryState {}

class LibraryFinishChallengeState extends LibraryState {
  LibraryFinishChallengeState(this.result);
  int result;
}

class LibraryTryChallengeAgainState extends LibraryState {}
