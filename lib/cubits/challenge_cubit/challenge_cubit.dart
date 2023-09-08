import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/cubits/challenge_cubit/challenge_state.dart';


class ChallengeCubit extends Cubit<ChallengeState> {
  ChallengeCubit() : super(ChallengeInitialState());

  static ChallengeCubit get(context) => BlocProvider.of(context);

  
}