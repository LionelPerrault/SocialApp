import 'dart:convert';

import 'package:flutter/foundation.dart';

/// The [RecaptchaResponse] is a model described
/// with a [success], a [challengeTimeStamp] , a [hostName],
/// a [score], an [action] and [errorCodes] .
class RecaptchaResponse {
  /// Indicates whether this request was a valid reCAPTCHA token for the site.
  final bool success;

  /// The Timestamp of the challenge load.
  final DateTime challengeTimeStamp;

  /// The Host Name of the site where the reCAPTCHA was solved.
  final String hostName;

  /// Score Range (0.0 - 1.0) where 1.0 is a human.
  final double score;

  /// The defined 'action' from the response.
  final String action;

  /// A List of 'error-codes' received from the response.
  final List<String> errorCodes;

  /// Constructor
  RecaptchaResponse({
    required this.success,
    required this.challengeTimeStamp,
    required this.hostName,
    required this.score,
    required this.action,
    this.errorCodes = const [],
  });

  /// Creates a copy of the [RecaptchaResponse] object
  /// but with the given fields replaced with the new values.
  RecaptchaResponse copyWith({
    bool? success,
    DateTime? challengeTimeStamp,
    String? hostName,
    double? score,
    String? action,
    List<String>? errorCodes,
  }) {
    return RecaptchaResponse(
      success: success ?? this.success,
      challengeTimeStamp: challengeTimeStamp ?? this.challengeTimeStamp,
      hostName: hostName ?? this.hostName,
      score: score ?? this.score,
      action: action ?? this.action,
      errorCodes: errorCodes ?? this.errorCodes,
    );
  }

  /// Converts the [RecaptchaResponse] object into `JSON` format.
  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'challengeTimeStamp': challengeTimeStamp.millisecondsSinceEpoch,
      'hostname': hostName,
      'score': score,
      'action': action,
      'error-codes': errorCodes,
    };
  }

  /// Converts the `JSON` data into [RecaptchaResponse] object.
  factory RecaptchaResponse.fromMap(Map<String, dynamic> map) {
    return RecaptchaResponse(
      success: map['success'] ?? false,
      challengeTimeStamp: DateTime.parse(map['challenge_ts']),
      hostName: map['hostname'] ?? '',
      score: map['score']?.toDouble() ?? 0.0,
      action: map['action'] ?? '',
      errorCodes: map['error-codes'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory RecaptchaResponse.fromJson(String source) =>
      RecaptchaResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RecaptchaResponse(success: $success, challengeTimeStamp: $challengeTimeStamp, hostName: $hostName, score: $score, action: $action, errorCodes: $errorCodes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecaptchaResponse &&
        other.success == success &&
        other.challengeTimeStamp == challengeTimeStamp &&
        other.hostName == hostName &&
        other.score == score &&
        other.action == action &&
        listEquals(other.errorCodes, errorCodes);
  }

  @override
  int get hashCode {
    return success.hashCode ^
        challengeTimeStamp.hashCode ^
        hostName.hashCode ^
        score.hashCode ^
        action.hashCode ^
        errorCodes.hashCode;
  }
}
