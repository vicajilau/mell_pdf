enum LogEvent {
  error
}

extension LoggedEvent on LogEvent {
  String get value {
    switch (this) {
      case LogEvent.error:
        return "error_controlled";
    }
  }
}