enum PaymentMethod {
  visa,
  D17;

  String get name {
    switch (this) {
      case PaymentMethod.visa:
        return 'Visa';
      case PaymentMethod.D17:
        return 'D17';
      default:
        return '';
    }
  }
}
