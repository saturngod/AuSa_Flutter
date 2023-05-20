extension SecondToMinuteFormat on int {
  
  String minuteSecondFormat() {
    final String minutes = _formatNumber(this ~/ 60);
    final String seconds = _formatNumber(this % 60);
    return '$minutes : $seconds';
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }
}