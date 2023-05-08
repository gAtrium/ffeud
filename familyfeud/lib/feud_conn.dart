enum feud_comm_type {
  INVALID,
  HOST_READY,
  PRESENTER_READY,
  HOST_TYPE_SHOWDOWN,
  HOST_TYPE_FEUDQUIZ,
  PRESENTER_ANSWER,
  PRESENTER_SHOWDOWN_PRESS,
  PRESENTER_NEXT
}

class feud_comm {
  feud_comm_type packettype = feud_comm_type.INVALID;

  int showdown_press_index = -1;
  List<String> feudquiz_answers = [];
  int feudquiz_answer_index = -1;
}

extension ToJson on feud_comm {
  Map<String, dynamic> toJson() => {
        'packettype': packettype.toString(),
        'showdown_press_index': showdown_press_index,
        'feudquiz_answers': feudquiz_answers,
        'feudquiz_answer_index': feudquiz_answer_index,
      };
}

extension FromJson on Map<String, dynamic> {
  feud_comm toFeudComm() => feud_comm()
    ..packettype = feud_comm_type.values.firstWhere(
      (e) => e.toString() == this['packettype'],
      orElse: () => feud_comm_type.INVALID,
    )
    ..showdown_press_index = this['showdown_press_index'] ?? -1
    ..feudquiz_answers = List<String>.from(this['feudquiz_answers'] ?? [])
    ..feudquiz_answer_index = this['feudquiz_answer_index'] ?? -1;
}
