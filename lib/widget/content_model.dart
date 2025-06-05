class OnboardingContent {
  final String image;
  final String title;
  final String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: 'Select from Our\nBest Menu',
    description: 'Pick your food from our menu\nMore than 35 items available',
    image: 'images/screen1.png',
  ),
  OnboardingContent(
    title: 'Easy and Online Payment',
    description: 'You can pay cash on delivery\nCard payment is available',
    image: 'images/screen2.png',
  ),
  OnboardingContent(
    title: 'Quick Delivery at Your Doorstep',
    description: 'Deliver your food right to\nyour doorstep quickly',
    image: 'images/screen3.png',
  ),
];
