# Jawaker Solitaire Floating Bot

مشروع Android/Kotlin أولي قابل للبناء عبر GitHub Actions، ومهيأ كحد أدنى لـ Android 10 (API 29).

## ما يتضمنه
- لوحة تحكم عائمة قابلة للسحب مع تشغيل/إيقاف وإغلاق.
- طلب موافقة المستخدم على MediaProjection والتقاط الشاشة عبر ImageReader.
- خدمة Accessibility مع `dispatchGesture` لتنفيذ السحب.
- إعدادات Gradle وGitHub Actions لإنتاج `app-debug.apk`.

## مهم قبل الاستخدام
هذا المشروع يوفّر بنية التطبيق وخدمات النظام، لكنه **ليس محرك لعب مكتملًا بعد**. ملف `BoardAnalyzer.kt` هو نقطة ربط آمنة للتعرّف على اللوحة، ولا يصنّف الرتب/الأنواع ولا يحسب النقلات حاليًا؛ لذلك لن ينفّذ نقلات تلقائية على لعبة حقيقية. لا يصح اعتبار التقاط الشاشة وحده قراءةً صحيحة للكروت. يلزم بناء واختبار OCR/Computer Vision ومحلّل قواعد Solitaire على لقطات فعلية من نسخة جواكر المستخدمة قبل تفعيل النقلات.

## إعداد الهاتف
1. ثبّت APK وافتح التطبيق.
2. اسمح بالظهور فوق التطبيقات.
3. فعّل خدمة `Jawaker Bot Gesture Service` يدويًا من إعدادات إمكانية الوصول.
4. اضغط بدء التقاط الشاشة ووافق على نافذة أندرويد.
5. ستظهر اللوحة العائمة. زر التشغيل يفعّل دورة التحليل، لكنه لا ينفذ حركة ما لم يتوفر محرك تعرّف ونقلات موثوق.

## بناء APK محليًا
يتطلب JDK 17 وAndroid SDK مع تثبيت Android SDK Platform 35 وBuild Tools المناسبة:
```bash
./gradlew assembleDebug
```
الناتج:
`app/build/outputs/apk/debug/app-debug.apk`

## بناء APK على GitHub
ارفع المشروع إلى مستودع GitHub، ثم شغّل workflow من Actions أو ادفع commit. ستجد APK في Artifacts باسم `Jawaker-Solitaire-Floating-Bot-debug`.

## توافق الجهاز
تم ضبط minSdk على 29 (Android 10). أبعاد الشاشة 720×1640 تستخدم كمرجع اختباري؛ التنفيذ يقرأ أبعاد الشاشة الفعلية من النظام. قد تتطلب أجهزة HiOS السماح بالتشغيل في الخلفية وتعطيل تحسين البطارية للتطبيق.


## محرك الرؤية والمنطق (نسخة مدمجة أولية)
- أضيف ML Kit Text Recognition لقراءة رموز الرتب من قصاصة الزاوية العلوية.
- أضيف تصنيف أولي لحبر الكرت إلى أحمر/أسود.
- أضيف `SolitaireEngine` مستقلًا لتخطيط نقلات الأساس، النقل بين الأعمدة، كشف الأوراق المخفية، والسحب عند عدم وجود حركة.
- أضيف `CardVision` لتقسيم الشاشة إلى 7 أعمدة وصف الأساس والمخزون.

### حدود الدقة الحالية — اقرأ قبل التشغيل
هذا ليس بعد بوتًا ذاتيًا موثوقًا على لعبة جواكر مباشرة. مواقع اللوحة مضبوطة كنسب ابتدائية وتحتاج معايرة على لقطة فعلية من نسخة اللعبة. كما أن تصنيف الأحمر/الأسود لا يحدد نوع الرمز الدقيق (كبة/ديناري أو بستوني/سباتي)، ولا يكفي OCR وحده لتمييز كل الرتب على رسومات الكروت. كذلك يلزم رصد عدد الكروت المقلوبة ومكدس السحب بدقة. لهذا السبب لا يرسل `BoardAnalyzer` إيماءات لعب تخمينية؛ محرك القواعد موجود، لكن ربطه النهائي بقراءة مؤكدة للوحة غير مفعل عمدًا حتى لا ينقل كروتًا خطأً أو يفسد الجولة.

لإكماله على نحو موثوق نحتاج لقطات شاشة فعلية من شاشة اللعبة (بما فيها بداية الجولة، تراكب الأعمدة، الأساس، المخزون، وحالة السحب) ومعرفة إعداد السحب من المخزون. بعد معايرة الإحداثيات وإضافة تمييز رموز الأنواع واختبار OCR، يمكن ربط `SolitaireEngine` بمخطط الإيماءات.


## Screenshot calibration (TECNO POVA / Jawaker)
The layout anchors were updated using the supplied Jawaker Solitaire screenshots.
The screenshots were 674x1536 PNGs while the phone information page reports 720x1640;
the aspect ratio is effectively the same, so normalized coordinates scale to both.

- Tableau columns: normalized X centers 0.110, 0.250, 0.390, 0.530, 0.670, 0.810, 0.950.
- Tableau first face-up row: normalized Y 0.338.
- Approximate card width/height: 0.130 / 0.195 of the frame.
- Vertical exposed-card step: 0.0415 of frame height.
- Four foundations: X centers 0.110, 0.250, 0.390, 0.530 at Y 0.285.
- Waste: X 0.740; stock: X 0.950; both at Y 0.285.

The recognizer extracts rank glyphs from the upper-left card index and estimates ink colour
(red/black). The hidden-card count is a heuristic based on red back-edge bands. It is not
a certified card detector and may need adjustment for animation, different Jawaker themes,
or changes in the game layout. Exact suit (heart/diamond/club/spade) is not yet reliably
classified. The app therefore does not automatically execute a move based on uncertain OCR.

## Build
Push this project to GitHub and run the **Build Android APK** workflow from the Actions tab.
The workflow uploads the debug APK as an artifact. A successful ZIP upload does not itself
mean an APK has already been built or tested.
