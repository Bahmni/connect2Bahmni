import 'package:flutter/foundation.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

import '../domain/models/bahmni_appointment.dart';
import '../domain/models/user.dart';


Future<void> startJitsiVideoCall(BahmniAppointment appointment, User user) async {
  //TODO Load from config or read from appointment
  var options = JitsiMeetConferenceOptions(
    room: appointment.uuid ?? 'bahmni-connect-room',
    userInfo: JitsiMeetUserInfo(
      displayName: user.person.display,
      email: '',
    ),
    configOverrides: {
      "subject": 'Consultation',
      "startWithAudioMuted": false,
      "startWithVideoMuted": false,
    },
  );
  
  var jitsiMeet = JitsiMeet();
  
  var listener = JitsiMeetEventListener(
    conferenceJoined: (url) {
      debugPrint("Conference joined: $url");
    },
    conferenceTerminated: (url, error) {
      debugPrint("Conference terminated: $url, error: $error");
    },
  );
  
  await jitsiMeet.join(options, listener);
}
