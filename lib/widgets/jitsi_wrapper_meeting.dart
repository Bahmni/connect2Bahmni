import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

import '../domain/models/bahmni_appointment.dart';
import '../domain/models/user.dart';


joinJitsiWrapperMeeting(BahmniAppointment appointment, User user) async {
  //TODO Load from config or read from appointment
  var options = JitsiMeetingOptions(roomNameOrUrl: 'bahmni-connect-room');
  await JitsiMeetWrapper.joinMeeting(options: options);

  // Define meetings options here
  // var customOptions = JitsiMeetingOptions(
  //     roomNameOrUrl: appointment.uuid!,
  //     serverUrl: serverUrl,
  //     subject: 'Consultation',
  //     userDisplayName: user.person.display,
  //     userEmail: '',
  //     isAudioOnly: false,
  //     isAudioMuted: false,
  //     isVideoMuted: false
  // );
  // debugPrint('server url  ${customOptions.roomNameOrUrl}');
  //
  // debugPrint("JitsiMeetingOptions: $options");
  // await JitsiMeetWrapper.joinMeeting(
  //   options: customOptions,
  //   listener: JitsiMeetingListener(
  //       onConferenceWillJoin: (message) {
  //         debugPrint("${options.roomNameOrUrl} will join with message: $message");
  //       },
  //       onConferenceJoined: (message) {
  //         debugPrint("${options.roomNameOrUrl} joined with message: $message");
  //       },
  //       onConferenceTerminated: (message, error) {
  //         debugPrint("${options.roomNameOrUrl} terminated with message: $message");
  //       }),
  // );
}