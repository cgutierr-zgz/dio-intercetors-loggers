abstract class Environment {
  static final String env = const String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  ).toLowerCase();

  static const String clientID = String.fromEnvironment('CLIENT_ID');
}
