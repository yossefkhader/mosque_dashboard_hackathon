class Course {
  final String id;
  final String title;
  final String lang;
  final bool rtl;
  final String? level;
  final int? estimatedTotalTimeMin;
  final String? audience;
  final List<String>? outcomes;
  final List<Module> modules;
  final List<QuickSizeGuide>? quickSizesGuide;
  final StarterChecklists? starterChecklists;
  final AppIntegration? appIntegration;

  Course({
    required this.id,
    required this.title,
    required this.lang,
    required this.rtl,
    this.level,
    this.estimatedTotalTimeMin,
    this.audience,
    this.outcomes,
    required this.modules,
    this.quickSizesGuide,
    this.starterChecklists,
    this.appIntegration,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      lang: json['lang'],
      rtl: json['rtl'] ?? false,
      level: json['level'],
      estimatedTotalTimeMin: json['estimatedTotalTimeMin'],
      audience: json['audience'],
      outcomes: json['outcomes']?.cast<String>(),
      modules: (json['modules'] as List)
          .map((module) => Module.fromJson(module))
          .toList(),
      quickSizesGuide: json['quickSizesGuide'] != null
          ? (json['quickSizesGuide'] as List)
              .map((guide) => QuickSizeGuide.fromJson(guide))
              .toList()
          : null,
      starterChecklists: json['starterChecklists'] != null
          ? StarterChecklists.fromJson(json['starterChecklists'])
          : null,
      appIntegration: json['appIntegration'] != null
          ? AppIntegration.fromJson(json['appIntegration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lang': lang,
      'rtl': rtl,
      'level': level,
      'estimatedTotalTimeMin': estimatedTotalTimeMin,
      'audience': audience,
      'outcomes': outcomes,
      'modules': modules.map((module) => module.toJson()).toList(),
      'quickSizesGuide':
          quickSizesGuide?.map((guide) => guide.toJson()).toList(),
      'starterChecklists': starterChecklists?.toJson(),
      'appIntegration': appIntegration?.toJson(),
    };
  }

  // Get total number of lessons across all modules
  int get totalLessons {
    return modules.fold(0, (sum, module) => sum + module.lessons.length);
  }

  // Get estimated time display string
  String get estimatedTimeDisplay {
    if (estimatedTotalTimeMin == null) return '';
    final hours = estimatedTotalTimeMin! ~/ 60;
    final minutes = estimatedTotalTimeMin! % 60;
    if (hours > 0) {
      return '$hours س ${minutes > 0 ? '$minutes د' : ''}';
    }
    return '$minutes د';
  }
}

class Module {
  final String id;
  final String title;
  final int? timeMin;
  final String? summary;
  final List<Lesson> lessons;

  Module({
    required this.id,
    required this.title,
    this.timeMin,
    this.summary,
    required this.lessons,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      title: json['title'],
      timeMin: json['timeMin'],
      summary: json['summary'],
      lessons: (json['lessons'] as List)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timeMin': timeMin,
      'summary': summary,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }

  String get timeDisplay {
    if (timeMin == null) return '';
    return '$timeMin د';
  }
}

class Lesson {
  final String id;
  final String title;
  final List<String>? objectives;
  final List<String>? steps;
  final List<LessonLink>? links;
  final List<String>? checklist;
  final String? assignment;
  final Quiz? quiz;
  final List<Downloadable>? downloadables;

  Lesson({
    required this.id,
    required this.title,
    this.objectives,
    this.steps,
    this.links,
    this.checklist,
    this.assignment,
    this.quiz,
    this.downloadables,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      objectives: json['objectives']?.cast<String>(),
      steps: json['steps']?.cast<String>(),
      links: json['links'] != null
          ? (json['links'] as List)
              .map((link) => LessonLink.fromJson(link))
              .toList()
          : null,
      checklist: json['checklist']?.cast<String>(),
      assignment: json['assignment'],
      quiz: json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null,
      downloadables: json['downloadables'] != null
          ? (json['downloadables'] as List)
              .map((downloadable) => Downloadable.fromJson(downloadable))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'objectives': objectives,
      'steps': steps,
      'links': links?.map((link) => link.toJson()).toList(),
      'checklist': checklist,
      'assignment': assignment,
      'quiz': quiz?.toJson(),
      'downloadables': downloadables?.map((d) => d.toJson()).toList(),
    };
  }

  // Get content indicators for UI
  List<String> get contentIndicators {
    List<String> indicators = [];
    if (objectives?.isNotEmpty == true) indicators.add('أهداف');
    if (steps?.isNotEmpty == true) indicators.add('خطوات');
    if (links?.isNotEmpty == true) indicators.add('روابط');
    if (checklist?.isNotEmpty == true) indicators.add('قائمة تحقق');
    if (assignment != null) indicators.add('مهمة');
    if (quiz != null) indicators.add('اختبار');
    if (downloadables?.isNotEmpty == true) indicators.add('تحميلات');
    return indicators;
  }
}

class LessonLink {
  final String label;
  final String url;

  LessonLink({
    required this.label,
    required this.url,
  });

  factory LessonLink.fromJson(Map<String, dynamic> json) {
    return LessonLink(
      label: json['label'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'url': url,
    };
  }
}

class Quiz {
  final String type;
  final String question;
  final List<String> choices;
  final int answerIndex;

  Quiz({
    required this.type,
    required this.question,
    required this.choices,
    required this.answerIndex,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      type: json['type'],
      question: json['question'],
      choices: json['choices'].cast<String>(),
      answerIndex: json['answerIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'question': question,
      'choices': choices,
      'answerIndex': answerIndex,
    };
  }
}

class Downloadable {
  final String type;
  final String filename;
  final String content;

  Downloadable({
    required this.type,
    required this.filename,
    required this.content,
  });

  factory Downloadable.fromJson(Map<String, dynamic> json) {
    return Downloadable(
      type: json['type'],
      filename: json['filename'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'filename': filename,
      'content': content,
    };
  }
}

class QuickSizeGuide {
  final String name;
  final String size;
  final String use;

  QuickSizeGuide({
    required this.name,
    required this.size,
    required this.use,
  });

  factory QuickSizeGuide.fromJson(Map<String, dynamic> json) {
    return QuickSizeGuide(
      name: json['name'],
      size: json['size'],
      use: json['use'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
      'use': use,
    };
  }
}

class StarterChecklists {
  final List<String>? weekly;
  final List<String>? assets;
  final List<String>? setup;
  final List<String>? monthly;
  final List<String>? quarterly;
  final List<String>? yearEnd;

  StarterChecklists({
    this.weekly,
    this.assets,
    this.setup,
    this.monthly,
    this.quarterly,
    this.yearEnd,
  });

  factory StarterChecklists.fromJson(Map<String, dynamic> json) {
    return StarterChecklists(
      weekly: json['weekly']?.cast<String>(),
      assets: json['assets']?.cast<String>(),
      setup: json['setup']?.cast<String>(),
      monthly: json['monthly']?.cast<String>(),
      quarterly: json['quarterly']?.cast<String>(),
      yearEnd: json['yearEnd']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekly': weekly,
      'assets': assets,
      'setup': setup,
      'monthly': monthly,
      'quarterly': quarterly,
      'yearEnd': yearEnd,
    };
  }
}

class AppIntegration {
  final String? type;
  final int? version;
  final RenderConfig? render;

  AppIntegration({
    this.type,
    this.version,
    this.render,
  });

  factory AppIntegration.fromJson(Map<String, dynamic> json) {
    return AppIntegration(
      type: json['type'],
      version: json['version'],
      render:
          json['render'] != null ? RenderConfig.fromJson(json['render']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'version': version,
      'render': render?.toJson(),
    };
  }
}

class RenderConfig {
  final String? component;
  final Map<String, dynamic>? props;

  RenderConfig({
    this.component,
    this.props,
  });

  factory RenderConfig.fromJson(Map<String, dynamic> json) {
    return RenderConfig(
      component: json['component'],
      props: json['props'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'component': component,
      'props': props,
    };
  }
}
