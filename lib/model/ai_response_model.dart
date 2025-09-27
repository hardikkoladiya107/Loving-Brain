import 'dart:convert';

import 'conversation_model.dart';

class AiResponseModel {
  AiResponseModel({
    String? id,
    String? object,
    num? createdAt,
    String? status,
    bool? background,
    Billing? billing,
    Conversation? conversation,
    dynamic error,
    dynamic incompleteDetails,
    List<Instructions>? instructions,
    dynamic maxOutputTokens,
    dynamic maxToolCalls,
    String? model,
    List<ConversationItem>? output,
    bool? parallelToolCalls,
    dynamic previousResponseId,
    Prompt? prompt,
    dynamic promptCacheKey,
    Reasoning? reasoning,
    dynamic safetyIdentifier,
    String? serviceTier,
    bool? store,
    num? temperature,
    Text? text,
    String? toolChoice,
    num? topLogprobs,
    num? topP,
    String? truncation,
    Usage? usage,
    dynamic user,
    dynamic metadata,
  }) {
    _id = id;
    _object = object;
    _createdAt = createdAt;
    _status = status;
    _background = background;
    _billing = billing;
    _conversation = conversation;
    _error = error;
    _incompleteDetails = incompleteDetails;
    _instructions = instructions;
    _maxOutputTokens = maxOutputTokens;
    _maxToolCalls = maxToolCalls;
    _model = model;
    _output = output;
    _parallelToolCalls = parallelToolCalls;
    _previousResponseId = previousResponseId;
    _prompt = prompt;
    _promptCacheKey = promptCacheKey;
    _reasoning = reasoning;
    _safetyIdentifier = safetyIdentifier;
    _serviceTier = serviceTier;
    _store = store;
    _temperature = temperature;
    _text = text;
    _toolChoice = toolChoice;
    _topLogprobs = topLogprobs;
    _topP = topP;
    _truncation = truncation;
    _usage = usage;
    _user = user;
    _metadata = metadata;
  }

  AiResponseModel.fromJson(dynamic json) {
    _id = json['id'];
    _object = json['object'];
    _createdAt = json['created_at'];
    _status = json['status'];
    _background = json['background'];
    _billing = json['billing'] != null
        ? Billing.fromJson(json['billing'])
        : null;
    _conversation = json['conversation'] != null
        ? Conversation.fromJson(json['conversation'])
        : null;
    _error = json['error'];
    _incompleteDetails = json['incomplete_details'];
    if (json['instructions'] != null) {
      _instructions = [];
      json['instructions'].forEach((v) {
        _instructions?.add(Instructions.fromJson(v));
      });
    }
    _maxOutputTokens = json['max_output_tokens'];
    _maxToolCalls = json['max_tool_calls'];
    _model = json['model'];
    if (json['output'] != null) {
      _output = [];
      json['output'].forEach((v) {
        _output?.add(ConversationItem.fromJson(v));
      });
    }
    _parallelToolCalls = json['parallel_tool_calls'];
    _previousResponseId = json['previous_response_id'];
    _prompt = json['prompt'] != null ? Prompt.fromJson(json['prompt']) : null;
    _promptCacheKey = json['prompt_cache_key'];
    _reasoning = json['reasoning'] != null
        ? Reasoning.fromJson(json['reasoning'])
        : null;
    _safetyIdentifier = json['safety_identifier'];
    _serviceTier = json['service_tier'];
    _store = json['store'];
    _temperature = json['temperature'];
    _text = json['text'] != null ? Text.fromJson(json['text']) : null;
    _toolChoice = json['tool_choice'];

    _topLogprobs = json['top_logprobs'];
    _topP = json['top_p'];
    _truncation = json['truncation'];
    _usage = json['usage'] != null ? Usage.fromJson(json['usage']) : null;
    _user = json['user'];
    _metadata = json['metadata'];
  }

  String? _id;
  String? _object;
  num? _createdAt;
  String? _status;
  bool? _background;
  Billing? _billing;
  Conversation? _conversation;
  dynamic _error;
  dynamic _incompleteDetails;
  List<Instructions>? _instructions;
  dynamic _maxOutputTokens;
  dynamic _maxToolCalls;
  String? _model;
  List<ConversationItem>? _output;
  bool? _parallelToolCalls;
  dynamic _previousResponseId;
  Prompt? _prompt;
  dynamic _promptCacheKey;
  Reasoning? _reasoning;
  dynamic _safetyIdentifier;
  String? _serviceTier;
  bool? _store;
  num? _temperature;
  Text? _text;
  String? _toolChoice;
  num? _topLogprobs;
  num? _topP;
  String? _truncation;
  Usage? _usage;
  dynamic _user;
  dynamic _metadata;

  AiResponseModel copyWith({
    String? id,
    String? object,
    num? createdAt,
    String? status,
    bool? background,
    Billing? billing,
    Conversation? conversation,
    dynamic error,
    dynamic incompleteDetails,
    List<Instructions>? instructions,
    dynamic maxOutputTokens,
    dynamic maxToolCalls,
    String? model,
    List<ConversationItem>? output,
    bool? parallelToolCalls,
    dynamic previousResponseId,
    Prompt? prompt,
    dynamic promptCacheKey,
    Reasoning? reasoning,
    dynamic safetyIdentifier,
    String? serviceTier,
    bool? store,
    num? temperature,
    Text? text,
    String? toolChoice,
    num? topLogprobs,
    num? topP,
    String? truncation,
    Usage? usage,
    dynamic user,
    dynamic metadata,
  }) => AiResponseModel(
    id: id ?? _id,
    object: object ?? _object,
    createdAt: createdAt ?? _createdAt,
    status: status ?? _status,
    background: background ?? _background,
    billing: billing ?? _billing,
    conversation: conversation ?? _conversation,
    error: error ?? _error,
    incompleteDetails: incompleteDetails ?? _incompleteDetails,
    instructions: instructions ?? _instructions,
    maxOutputTokens: maxOutputTokens ?? _maxOutputTokens,
    maxToolCalls: maxToolCalls ?? _maxToolCalls,
    model: model ?? _model,
    output: output ?? _output,
    parallelToolCalls: parallelToolCalls ?? _parallelToolCalls,
    previousResponseId: previousResponseId ?? _previousResponseId,
    prompt: prompt ?? _prompt,
    promptCacheKey: promptCacheKey ?? _promptCacheKey,
    reasoning: reasoning ?? _reasoning,
    safetyIdentifier: safetyIdentifier ?? _safetyIdentifier,
    serviceTier: serviceTier ?? _serviceTier,
    store: store ?? _store,
    temperature: temperature ?? _temperature,
    text: text ?? _text,
    toolChoice: toolChoice ?? _toolChoice,
    topLogprobs: topLogprobs ?? _topLogprobs,
    topP: topP ?? _topP,
    truncation: truncation ?? _truncation,
    usage: usage ?? _usage,
    user: user ?? _user,
    metadata: metadata ?? _metadata,
  );

  String? get id => _id;

  String? get object => _object;

  num? get createdAt => _createdAt;

  String? get status => _status;

  bool? get background => _background;

  Billing? get billing => _billing;

  Conversation? get conversation => _conversation;

  dynamic get error => _error;

  dynamic get incompleteDetails => _incompleteDetails;

  List<Instructions>? get instructions => _instructions;

  dynamic get maxOutputTokens => _maxOutputTokens;

  dynamic get maxToolCalls => _maxToolCalls;

  String? get model => _model;

  List<ConversationItem>? get output => _output;

  bool? get parallelToolCalls => _parallelToolCalls;

  dynamic get previousResponseId => _previousResponseId;

  Prompt? get prompt => _prompt;

  dynamic get promptCacheKey => _promptCacheKey;

  Reasoning? get reasoning => _reasoning;

  dynamic get safetyIdentifier => _safetyIdentifier;

  String? get serviceTier => _serviceTier;

  bool? get store => _store;

  num? get temperature => _temperature;

  Text? get text => _text;

  String? get toolChoice => _toolChoice;

  num? get topLogprobs => _topLogprobs;

  num? get topP => _topP;

  String? get truncation => _truncation;

  Usage? get usage => _usage;

  dynamic get user => _user;

  dynamic get metadata => _metadata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['object'] = _object;
    map['created_at'] = _createdAt;
    map['status'] = _status;
    map['background'] = _background;
    if (_billing != null) {
      map['billing'] = _billing?.toJson();
    }
    if (_conversation != null) {
      map['conversation'] = _conversation?.toJson();
    }
    map['error'] = _error;
    map['incomplete_details'] = _incompleteDetails;
    if (_instructions != null) {
      map['instructions'] = _instructions?.map((v) => v.toJson()).toList();
    }
    map['max_output_tokens'] = _maxOutputTokens;
    map['max_tool_calls'] = _maxToolCalls;
    map['model'] = _model;
    if (_output != null) {
      map['output'] = _output?.map((v) => v.toJson()).toList();
    }
    map['parallel_tool_calls'] = _parallelToolCalls;
    map['previous_response_id'] = _previousResponseId;
    if (_prompt != null) {
      map['prompt'] = _prompt?.toJson();
    }
    map['prompt_cache_key'] = _promptCacheKey;
    if (_reasoning != null) {
      map['reasoning'] = _reasoning?.toJson();
    }
    map['safety_identifier'] = _safetyIdentifier;
    map['service_tier'] = _serviceTier;
    map['store'] = _store;
    map['temperature'] = _temperature;
    if (_text != null) {
      map['text'] = _text?.toJson();
    }
    map['tool_choice'] = _toolChoice;
    map['top_logprobs'] = _topLogprobs;
    map['top_p'] = _topP;
    map['truncation'] = _truncation;
    if (_usage != null) {
      map['usage'] = _usage?.toJson();
    }
    map['user'] = _user;
    map['metadata'] = _metadata;
    return map;
  }
}



class Usage {
  Usage({
    num? inputTokens,
    InputTokensDetails? inputTokensDetails,
    num? outputTokens,
    OutputTokensDetails? outputTokensDetails,
    num? totalTokens,
  }) {
    _inputTokens = inputTokens;
    _inputTokensDetails = inputTokensDetails;
    _outputTokens = outputTokens;
    _outputTokensDetails = outputTokensDetails;
    _totalTokens = totalTokens;
  }

  Usage.fromJson(dynamic json) {
    _inputTokens = json['input_tokens'];
    _inputTokensDetails = json['input_tokens_details'] != null
        ? InputTokensDetails.fromJson(json['input_tokens_details'])
        : null;
    _outputTokens = json['output_tokens'];
    _outputTokensDetails = json['output_tokens_details'] != null
        ? OutputTokensDetails.fromJson(json['output_tokens_details'])
        : null;
    _totalTokens = json['total_tokens'];
  }

  num? _inputTokens;
  InputTokensDetails? _inputTokensDetails;
  num? _outputTokens;
  OutputTokensDetails? _outputTokensDetails;
  num? _totalTokens;

  Usage copyWith({
    num? inputTokens,
    InputTokensDetails? inputTokensDetails,
    num? outputTokens,
    OutputTokensDetails? outputTokensDetails,
    num? totalTokens,
  }) => Usage(
    inputTokens: inputTokens ?? _inputTokens,
    inputTokensDetails: inputTokensDetails ?? _inputTokensDetails,
    outputTokens: outputTokens ?? _outputTokens,
    outputTokensDetails: outputTokensDetails ?? _outputTokensDetails,
    totalTokens: totalTokens ?? _totalTokens,
  );

  num? get inputTokens => _inputTokens;

  InputTokensDetails? get inputTokensDetails => _inputTokensDetails;

  num? get outputTokens => _outputTokens;

  OutputTokensDetails? get outputTokensDetails => _outputTokensDetails;

  num? get totalTokens => _totalTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['input_tokens'] = _inputTokens;
    if (_inputTokensDetails != null) {
      map['input_tokens_details'] = _inputTokensDetails?.toJson();
    }
    map['output_tokens'] = _outputTokens;
    if (_outputTokensDetails != null) {
      map['output_tokens_details'] = _outputTokensDetails?.toJson();
    }
    map['total_tokens'] = _totalTokens;
    return map;
  }
}


class OutputTokensDetails {
  OutputTokensDetails({num? reasoningTokens}) {
    _reasoningTokens = reasoningTokens;
  }

  OutputTokensDetails.fromJson(dynamic json) {
    _reasoningTokens = json['reasoning_tokens'];
  }

  num? _reasoningTokens;

  OutputTokensDetails copyWith({num? reasoningTokens}) =>
      OutputTokensDetails(reasoningTokens: reasoningTokens ?? _reasoningTokens);

  num? get reasoningTokens => _reasoningTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reasoning_tokens'] = _reasoningTokens;
    return map;
  }
}


class InputTokensDetails {
  InputTokensDetails({num? cachedTokens}) {
    _cachedTokens = cachedTokens;
  }

  InputTokensDetails.fromJson(dynamic json) {
    _cachedTokens = json['cached_tokens'];
  }

  num? _cachedTokens;

  InputTokensDetails copyWith({num? cachedTokens}) =>
      InputTokensDetails(cachedTokens: cachedTokens ?? _cachedTokens);

  num? get cachedTokens => _cachedTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cached_tokens'] = _cachedTokens;
    return map;
  }
}


class Text {
  Text({Format? format, String? verbosity}) {
    _format = format;
    _verbosity = verbosity;
  }

  Text.fromJson(dynamic json) {
    _format = json['format'] != null ? Format.fromJson(json['format']) : null;
    _verbosity = json['verbosity'];
  }

  Format? _format;
  String? _verbosity;

  Text copyWith({Format? format, String? verbosity}) =>
      Text(format: format ?? _format, verbosity: verbosity ?? _verbosity);

  Format? get format => _format;

  String? get verbosity => _verbosity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_format != null) {
      map['format'] = _format?.toJson();
    }
    map['verbosity'] = _verbosity;
    return map;
  }
}


class Format {
  Format({String? type}) {
    _type = type;
  }

  Format.fromJson(dynamic json) {
    _type = json['type'];
  }

  String? _type;

  Format copyWith({String? type}) => Format(type: type ?? _type);

  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    return map;
  }
}



class Reasoning {
  Reasoning({String? effort, dynamic summary}) {
    _effort = effort;
    _summary = summary;
  }

  Reasoning.fromJson(dynamic json) {
    _effort = json['effort'];
    _summary = json['summary'];
  }

  String? _effort;
  dynamic _summary;

  Reasoning copyWith({String? effort, dynamic summary}) =>
      Reasoning(effort: effort ?? _effort, summary: summary ?? _summary);

  String? get effort => _effort;

  dynamic get summary => _summary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['effort'] = _effort;
    map['summary'] = _summary;
    return map;
  }
}



class Prompt {
  Prompt({String? id, dynamic variables, String? version}) {
    _id = id;
    _variables = variables;
    _version = version;
  }

  Prompt.fromJson(dynamic json) {
    _id = json['id'];
    _variables = json['variables'];
    _version = json['version'];
  }

  String? _id;
  dynamic _variables;
  String? _version;

  Prompt copyWith({String? id, dynamic variables, String? version}) => Prompt(
    id: id ?? _id,
    variables: variables ?? _variables,
    version: version ?? _version,
  );

  String? get id => _id;

  dynamic get variables => _variables;

  String? get version => _version;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['variables'] = _variables;
    map['version'] = _version;
    return map;
  }
}



class Instructions {
  Instructions({String? type, List<Content>? content, String? role}) {
    _type = type;
    _content = content;
    _role = role;
  }

  Instructions.fromJson(dynamic json) {
    _type = json['type'];
    if (json['content'] != null) {
      _content = [];
      json['content'].forEach((v) {
        _content?.add(Content.fromJson(v));
      });
    }
    _role = json['role'];
  }

  String? _type;
  List<Content>? _content;
  String? _role;

  Instructions copyWith({String? type, List<Content>? content, String? role}) =>
      Instructions(
        type: type ?? _type,
        content: content ?? _content,
        role: role ?? _role,
      );

  String? get type => _type;

  List<Content>? get content => _content;

  String? get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    if (_content != null) {
      map['content'] = _content?.map((v) => v.toJson()).toList();
    }
    map['role'] = _role;
    return map;
  }
}

class Content {
  Content({String? type, String? text}) {
    _type = type;
    _text = text;
  }

  Content.fromJson(dynamic json) {
    _type = json['type'];
    _text = json['text'];
  }

  String? _type;
  String? _text;

  Content copyWith({String? type, String? text}) =>
      Content(type: type ?? _type, text: text ?? _text);

  String? get type => _type;

  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['text'] = _text;
    return map;
  }
}

class Conversation {
  Conversation({String? id}) {
    _id = id;
  }

  Conversation.fromJson(dynamic json) {
    _id = json['id'];
  }

  String? _id;

  Conversation copyWith({String? id}) => Conversation(id: id ?? _id);

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }
}

class Billing {
  Billing({String? payer}) {
    _payer = payer;
  }

  Billing.fromJson(dynamic json) {
    _payer = json['payer'];
  }

  String? _payer;

  Billing copyWith({String? payer}) => Billing(payer: payer ?? _payer);

  String? get payer => _payer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payer'] = _payer;
    return map;
  }
}
