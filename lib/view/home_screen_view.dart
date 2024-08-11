
import 'dart:math';

import 'package:fl_mlkit_translate_text/fl_mlkit_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_waya/flutter_waya.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator_app/resources/components/app_colors.dart';
import 'package:translator_app/utils/routes/routes_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isListening=false;
  final SpeechToText speech = SpeechToText();
  bool _onDevice = false;
  String lastError = '';
  String lastStatus = '';
  double level = 0.0;
  bool _hasSpeech = false;
  String _currentLocaleId = '';
  List<LocaleName> localeNames = [];
  bool _logEvents = false;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }
  void startListening() {
    _logEvent('start listening');
    controller.text = '';
    lastError = '';
    final options = SpeechListenOptions(
        onDevice: _onDevice,
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    // Note that `listenFor` is the maximum, not the minimum, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech.listen(
      onResult: resultListener,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: getLanguageID(translateText.sourceLanguage.name),
      onSoundLevelChange: soundLevelListener,
      listenOptions: options,
    );
    setState(() {});
  }
  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }
  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }
  void resultListener(SpeechRecognitionResult result) {
    //_logEvent('Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      controller.text = '${result.recognizedWords}';//- ${result.finalResult}';
    });
  }
  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }
  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();

        // if (kDebugMode) {
        //   print("Home");
        //   localeNames.forEach((element) {
        //     print("${element.name} = ${element.localeId}");
        //   });
        // }
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }
  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = status;
    });
  }
  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }
  TextEditingController controller = TextEditingController();
  List<TranslateRemoteModel> remoteModels = [];
  FlMlKitTranslateText translateText = FlMlKitTranslateText();
  ValueNotifier<String> text = ValueNotifier<String>('No Translate');

  @override
  void initState() {
    super.initState();
    initSpeechState();
    addPostFrameCallback((duration) {
      getDownloadedModels();
    });
  }

  Future<void> getDownloadedModels() async {
    remoteModels = await translateText.getDownloadedModels();
    bool hasZH = false;
    for (var element in remoteModels) {
      if (element.language == TranslateLanguage.chinese) {
        hasZH = true;
        break;
      }
    }
    if (!hasZH) {
      final state =
      await translateText.downloadedModel(TranslateLanguage.chinese);
      'DownloadedModel TranslateLanguage.chinese = $state'.log();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const  Text('Language Translator',style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, RoutesNames.profile);
          }, icon: const Icon(Icons.person)),
        ],
        iconTheme: const  IconThemeData(
          color: AppColors.whiteColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            ElevatedText(
                text: 'TranslateRemoteModel Manager',
                onPressed: () {
                  context.requestFocus();
                  push(const TranslateRemoteModelManagerPage());
                }),
            const SizedBox(height: 20),
            Card(
              child: StatefulBuilder(builder: (_, state) {
                return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          context.requestFocus();
                          final language = await selectLanguage();
                          if (language != null &&
                              language != translateText.sourceLanguage &&
                              language != translateText.targetLanguage) {
                            translateText.switchLanguage(language, translateText.targetLanguage)
                                .then((value) {

                              state(() {});
                            });
                          }
                        },
                        child: Center(child: Text(translateText.sourceLanguage.name))
                    ),
                  ),
                  IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onPressed: () {
                        controller.text="";
                        text=ValueNotifier<String>('No Translate');
                        translateText
                            .switchLanguage(translateText.targetLanguage,
                            translateText.sourceLanguage)
                            .then((value) {
                          state(() {});
                          setState(() {});
                        });
                      },
                      icon: const Icon(Icons.swap_horizontal_circle)),
                  Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          context.requestFocus();
                          final language = await selectLanguage();
                          if (language != null &&
                              language != translateText.sourceLanguage &&
                              language != translateText.targetLanguage) {
                            translateText
                                .switchLanguage(translateText.sourceLanguage, language)
                                .then((value) {
                              state(() {});
                            });
                          }
                        },
                        child: Center(child: Text(translateText.targetLanguage.name))),
                  ),
                ]);
              }),
            ),
            const SizedBox(height: 5),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(translateText.sourceLanguage.name,style: TextStyle(color: AppColors.primary,fontSize: 20,fontWeight:FontWeight.w600),),
                    ),
                    TextField(
                        controller: controller,
                        // maxLength: 500,
                        maxLines: 4,
                        onSubmitted: (value) {
                          context.requestFocus();
                        },
                        decoration: const InputDecoration(
                           //  filled: true,
                           fillColor: Colors.red,
                            border: InputBorder.none,
                            hintText: 'Please enter text')
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: startListening,
                          child: Container(
                            decoration:BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary
                            ),
                            height: 45,
                            width: 45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/images/mic.png"),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ElevatedText(text: 'Translation', onPressed: translation,style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.secondary),
                        ),
                        textStyle: TextStyle(color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      const SizedBox(width: 5,),
                      Text(translateText.targetLanguage.name,style: TextStyle(color: AppColors.primary,fontSize: 20,fontWeight:FontWeight.w600),),
                      const SizedBox(width: 10,),
                      //Image.asset("assets/images/speaker.png",height: 32,width: 32,)
                    ],),
                  ),
                  ValueListenableBuilder(
                      valueListenable: text,
                      builder: (_, String value, __) {
                        return Universal(
                            onLongPress: () {
                              value.toClipboard;
                              showToast('Has been copied');
                            },
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: BText(value, color: Colors.black, textAlign: TextAlign.center));
                      }),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> translation() async {
    if (controller.text.isEmpty) {
      showToast('Please enter the text');
      return;
    }
    context.requestFocus();
    final hasSourceModel =
    await translateText.isModelDownloaded(translateText.sourceLanguage);
    final hasTargetModel =
    await translateText.isModelDownloaded(translateText.targetLanguage);
    if (hasSourceModel && hasTargetModel) {
      final value = await translateText.translate(controller.text);
      if (value != null) text.value = value;
    } else {
      showToast('No download TranslateRemoteModel');
    }
  }

  Future<TranslateLanguage?> selectLanguage() => Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10), right: Radius.circular(10))),
      child: CustomFutureBuilder<List<TranslateRemoteModel>>(
          future: translateText.getDownloadedModels,
          onWaiting: (_) => const CircularProgressIndicator(),
          onDone: (_, value, __) {
            return ScrollList.builder(
                itemBuilder: (_, index) {
                  return Universal(
                      onTap: () {
                        pop(value[index].language);
                      },
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: BText(value[index].language.toString(),
                          color: Colors.black));
                },
                itemCount: value.length,
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(thickness: 0.3));
          })).popupBottomSheet(
      options: const BottomSheetOptions(isScrollControlled: false));

  @override
  void dispose() {
    super.dispose();
    text.dispose();
    translateText.dispose();
  }
}

class TranslateRemoteModelManagerPage extends StatefulWidget {
  const TranslateRemoteModelManagerPage({super.key});

  @override
  State<TranslateRemoteModelManagerPage> createState() =>
      _TranslateRemoteModelManagerPageState();
}

class _TranslateRemoteModelManagerPageState extends State<TranslateRemoteModelManagerPage> {
  List<String> listLanguage = [];

  @override
  void initState() {
    super.initState();
    addPostFrameCallback((duration) => getDownloadedModels());
  }

  Future<void> getDownloadedModels() async {
    var list = await FlMlKitTranslateText().getDownloadedModels();
    listLanguage = list.builder(
            (item) => FlMlKitTranslateText().toAbbreviations(item.language));
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarText('Translate Manager',leading:  IconButton(icon:const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,), onPressed: () {Navigator.pop(context);  },),),
        body: ScrollList.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (_, int index) {

            var item = TranslateLanguage.values[index];
            var abb = FlMlKitTranslateText().toAbbreviations(item);
            var isDownload = listLanguage.contains(abb);
            return Universal(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                children: [
                  RText(texts: [
                    '${abb.toUpperCase()}  ',
                    item.toString().split('.')[1]
                  ], styles: const [
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
                    TextStyle(),
                  ]),
                  ValueBuilder<bool>(builder: (_, bool? isLoading, updater) {
                    isLoading ??= false;
                    if (isLoading) return const CircularProgressIndicator();
                    return isDownload
                        ? ElevatedText(
                        text: 'Delete',
                        onPressed: () async {
                          updater(true);
                          final state = await FlMlKitTranslateText()
                              .deleteDownloadedModel(item);
                          updater(false);
                          if (state) getDownloadedModels();
                        })
                        : ElevatedText(
                        text: 'Download',
                        onPressed: () async {
                          updater(true);
                          final state = await FlMlKitTranslateText().downloadedModel(item);
                          updater(false);
                          if (state) getDownloadedModels();
                        });
                  })
                ]);

          },
          itemCount: TranslateLanguage.values.length,
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        )
    );
  }
}

class AppBarText extends AppBar {
  AppBarText(String text, {Widget? leading,super.key})
      : super(
      leading: leading,
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: Text(text,style: TextStyle(color: AppColors.whiteColor),),
      centerTitle: true);
}

class ElevatedText extends ElevatedButton {

  ElevatedText({super.key, required String text, required super.onPressed, super.style,TextStyle? textStyle})
      : super(child: Text(text,style:textStyle?? TextStyle(color: AppColors.primary),));
}


String getLanguageID(String languageName) {
  switch (languageName.toLowerCase()) {
    case "afrikaans":
      return "af_ZA";
    case "amharic":
      return "am_ET";
    case "arabic (algeria)":
      return "ar_DZ";
    case "arabic (bahrain)":
      return "ar_BH";
    case "arabic (egypt)":
      return "ar_EG";
    case "arabic (israel)":
      return "ar_IL";
    case "arabic (jordan)":
      return "ar_JO";
    case "arabic (kuwait)":
      return "ar_KW";
    case "arabic (lebanon)":
      return "ar_LB";
    case "arabic (morocco)":
      return "ar_MA";
    case "arabic (oman)":
      return "ar_OM";
    case "arabic (palestine)":
      return "ar_PS";
    case "arabic (qatar)":
      return "ar_QA";
    case "arabic (saudi arabia)":
      return "ar_SA";
    case "arabic (tunisia)":
      return "ar_TN";
    case "arabic (united arab emirates)":
      return "ar_AE";
    case "armenian":
      return "hy_AM";
    case "azerbaijani":
      return "az_AZ";
    case "bangla (bangladesh)":
      return "bn_BD";
    case "bangla (india)":
      return "bn_IN";
    case "basque":
      return "eu_ES";
    case "bulgarian":
      return "bg_BG";
    case "burmese (myanmar (burma))":
      return "my_MM";
    case "cantonese (traditional han,hong kong)":
      return "yue_HK";
    case "catalan":
      return "ca_ES";
    case "croatian":
      return "hr_HR";
    case "czech":
      return "cs_CZ";
    case "danish":
      return "da_DK";
    case "dutch":
      return "nl_NL";
    case "english (australia)":
      return "en_AU";
    case "english (canada)":
      return "en_CA";
    case "english (ghana)":
      return "en_GH";
    case "english (india)":
      return "en_IN";
    case "english (indonesia)":
      return "en_ID";
    case "english (ireland)":
      return "en_IE";
    case "english (kenya)":
      return "en_KE";
    case "english (new zealand)":
      return "en_NZ";
    case "english (nigeria)":
      return "en_NG";
    case "english (philippines)":
      return "en_PH";
    case "english (singapore)":
      return "en_SG";
    case "english (south africa)":
      return "en_ZA";
    case "english (tanzania)":
      return "en_TZ";
    case "english (thailand)":
      return "en_TH";
    case "english (united kingdom)":
      return "en_GB";
    case "english":
      return "en_US";
    case "english (world)":
      return "en_001";
    case "estonian":
      return "et_EE";
    case "filipino":
      return "fil_PH";
    case "finnish":
      return "fi_FI";
    case "french (canada)":
      return "fr_CA";
    case "french (france)":
      return "fr_FR";
    case "galician":
      return "gl_ES";
    case "georgian":
      return "ka_GE";
    case "german (austria)":
      return "de_AT";
    case "german (germany)":
      return "de_DE";
    case "greek":
      return "el_GR";
    case "gujarati":
      return "gu_IN";
    case "hebrew":
      return "iw_IL";
    case "hindi":
      return "hi_IN";
    case "hungarian":
      return "hu_HU";
    case "icelandic":
      return "is_IS";
    case "indonesian":
      return "in_ID";
    case "italian":
      return "it_IT";
    case "japanese":
      return "ja_JP";
    case "javanese":
      return "jv_ID";
    case "kannada":
      return "kn_IN";
    case "khmer":
      return "km_KH";
    case "korean":
      return "ko_KR";
    case "lao":
      return "lo_LA";
    case "latvian":
      return "lv_LV";
    case "lithuanian":
      return "lt_LT";
    case "malay":
      return "ms_MY";
    case "malayalam":
      return "ml_IN";
    case "marathi":
      return "mr_IN";
    case "nepali":
      return "ne_NP";
    case "norwegian bokmål":
      return "nb_NO";
    case "persian":
      return "fa_IR";
    case "polish":
      return "pl_PL";
    case "portuguese (brazil)":
      return "pt_BR";
    case "portuguese (portugal)":
      return "pt_PT";
    case "romanian":
      return "ro_RO";
    case "russian":
      return "ru_RU";
    case "serbian":
      return "sr_RS";
    case "sinhala":
      return "si_LK";
    case "slovak":
      return "sk_SK";
    case "slovenian":
      return "sl_SI";
    case "spanish (argentina)":
      return "es_AR";
    case "spanish (bolivia)":
      return "es_BO";
    case "spanish (chile)":
      return "es_CL";
    case "spanish (colombia)":
      return "es_CO";
    case "spanish (costa rica)":
      return "es_CR";
    case "spanish (dominican republic)":
      return "es_DO";
    case "spanish (ecuador)":
      return "es_EC";
    case "spanish (el salvador)":
      return "es_SV";
    case "spanish (guatemala)":
      return "es_GT";
    case "spanish (honduras)":
      return "es_HN";
    case "spanish (mexico)":
      return "es_MX";
    case "spanish (nicaragua)":
      return "es_NI";
    case "spanish (panama)":
      return "es_PA";
    case "spanish (paraguay)":
      return "es_PY";
    case "spanish (peru)":
      return "es_PE";
    case "spanish (puerto rico)":
      return "es_PR";
    case "spanish (spain)":
      return "es_ES";
    case "spanish (united states)":
      return "es_US";
    case "spanish (uruguay)":
      return "es_UY";
    case "spanish (venezuela)":
      return "es_VE";
    case "sundanese":
      return "su_ID";
    case "swahili":
      return "sw_";
    case "swahili (tanzania)":
      return "sw_TZ";
    case "swedish":
      return "sv_SE";
    case "tamil (india)":
      return "ta_IN";
    case "tamil (malaysia)":
      return "ta_MY";
    case "tamil (singapore)":
      return "ta_SG";
    case "tamil (sri lanka)":
      return "ta_LK";
    case "telugu":
      return "te_IN";
    case "thai":
      return "th_TH";
    case "turkish":
      return "tr_TR";
    case "ukrainian":
      return "uk_UA";
    case "urdu (india)":
      return "ur_IN";
    case "urdu (pakistan)":
      return "ur_PK";
    case "urdu":
      return "ur_PK";
    case "uzbek":
      return "uz_UZ";
    case "vietnamese":
      return "vi_VN";
    case "zulu":
      return "zu_ZA";
    case "cmn (simplified han,china)":
      return "cmn_CN";
    case "cmn (simplified han,hong kong)":
      return "cmn_HK";
    case "cmn (traditional han,taiwan)":
      return "cmn_TW";
    default:
      return ""; // Default to empty string if language not found
  }
}

