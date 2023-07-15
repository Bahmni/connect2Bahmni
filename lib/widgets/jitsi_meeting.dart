import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/bahmni_appointment.dart';
import '../domain/models/user.dart';
import '../providers/user_provider.dart';

class LaunchMeeting extends StatefulWidget {
  final BahmniAppointment? event;
  const LaunchMeeting({Key? key, this.event}) : super(key: key);

  @override
  State<LaunchMeeting> createState() => _LaunchMeetingState();
}

const String defaultTitleText = "Consultation";

class _LaunchMeetingState extends State<LaunchMeeting> {
  final serverText = TextEditingController();
  final roomIdentifier = TextEditingController();
  final titleText = TextEditingController(text: defaultTitleText);
  final nameText = TextEditingController();
  final emailText = TextEditingController();
  final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80"); //transparent blue
  bool? isAudioOnly = true;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    roomIdentifier.text = widget.event?.uuid ?? const Uuid().v4();
    titleText.text = defaultTitleText;
    nameText.text = userProvider.user!.person.display;

    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Join Meeting'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: kIsWeb
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.30,
                child: meetConfig(),
              ),
              SizedBox(
                  width: width * 0.60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Colors.white54,
                        child: SizedBox(
                          width: width * 0.60 * 0.70,
                          height: width * 0.60 * 0.70,
                          child: const Text("Not yet implemented"),
                        )),
                  ))
            ],
          )
              : meetConfig(),
        ),
      ),
    );
  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // const SizedBox(
          //   height: 16.0,
          // ),
          // TextField(
          //   controller: serverText,
          //   decoration: const InputDecoration(
          //       border: OutlineInputBorder(),
          //       labelText: "Server URL",
          //       hintText: "Hint: Leave empty for meet.jitsi.si"),
          // ),
          const SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: roomIdentifier,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Room",
            ),
          ),
          const SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: titleText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Subject",
            ),
          ),
          const SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: nameText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Display Name",
            ),
          ),
          const SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: emailText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
          ),
          // const SizedBox(
          //   height: 14.0,
          // ),
          // TextField(
          //   controller: iosAppBarRGBAColor,
          //   decoration: const InputDecoration(
          //       border: OutlineInputBorder(),
          //       labelText: "AppBar Color(IOS only)",
          //       hintText: "Hint: This HAS to be in HEX RGBA format"),
          // ),
          const SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: const Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          const SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: const Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          const SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: const Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          const Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _joinMeeting();
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue)),
              child: const Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String? serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<String, Object> featureFlags = {};

    var options = JitsiMeetingOptions(
        roomNameOrUrl: roomIdentifier.text,
        serverUrl: serverUrl,
        subject: titleText.text,
        userDisplayName: nameText.text,
        userEmail: emailText.text,
        isAudioMuted: isAudioMuted,
        isAudioOnly: isAudioOnly,
        isVideoMuted: isVideoMuted,
        featureFlags: featureFlags
    );

    //debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeetWrapper.joinMeeting(
      options: options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.roomNameOrUrl} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.roomNameOrUrl} joined with message: $message");
          },
          onConferenceTerminated: (message, error) {
            debugPrint("${options.roomNameOrUrl} terminated with message: $message");
          },
          onClosed: () => {
            debugPrint("${options.roomNameOrUrl} closed")
          }),
    );
  }

  // void _onConferenceWillJoin(message) {
  //   debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  // }
  //
  // void _onConferenceJoined(message) {
  //   debugPrint("_onConferenceJoined broadcasted with message: $message");
  // }
  //
  // void _onConferenceTerminated(message) {
  //   debugPrint("_onConferenceTerminated broadcasted with message: $message");
  // }
  //
  // _onError(error) {
  //   debugPrint("_onError broadcasted: $error");
  // }
}

joinJitsiMeeting(BahmniAppointment appointment, User user) async {
  //TODO Load from config or read from appointment
  String? serverUrl;

  // Enable or disable any feature flag here
  // If feature flag are not provided, default values will be used
  // Full list of feature flags (and defaults) available in the README
  Map<String, Object> featureFlags = {};
  // Define meetings options here
  var options = JitsiMeetingOptions(
      roomNameOrUrl: appointment.uuid!,
      serverUrl: serverUrl,
      subject: 'Consultation',
      userDisplayName: user.person.display,
      userEmail: '',
      isAudioMuted: false,
      isAudioOnly: false,
      isVideoMuted: false,
      featureFlags: featureFlags
  );
  debugPrint('server url  ${options.serverUrl}');

  debugPrint("JitsiMeetingOptions: $options");
  await JitsiMeetWrapper.joinMeeting(
    options: options,
    listener: JitsiMeetingListener(
        onConferenceWillJoin: (message) {
          debugPrint("${options.roomNameOrUrl} will join with message: $message");
        },
        onConferenceJoined: (message) {
          debugPrint("${options.roomNameOrUrl} joined with message: $message");
        },
        onConferenceTerminated: (message, error) {
          debugPrint("${options.roomNameOrUrl} terminated with message: $message");
        }),
  );
}