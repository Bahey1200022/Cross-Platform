class UserPreferences {
  final bool showNSFW;
  bool? showNotifications;
  bool? showInSearch;
  bool? personalizeAds;
  bool? alcahol;
  bool? gambling;
  bool? dating;
  bool? pregnancyAndParenting;
  bool? weightLoss;
  bool? privateMessagesEmail;
  bool? chatMessages;
  bool? signedInWithGoogle;

  UserPreferences({
    required this.showNSFW,
    this.showNotifications,
    this.showInSearch,
    this.personalizeAds,
    this.alcahol,
    this.gambling,
    this.dating,
    this.pregnancyAndParenting,
    this.weightLoss,
    this.privateMessagesEmail,
    this.chatMessages,
    this.signedInWithGoogle = false,
  });
}
