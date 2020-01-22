class Pair<F, S> {
  final F first;
  final S second;

  const Pair(this.first, this.second);

  int get hashCode => 37 * first.hashCode + second.hashCode;

  bool operator ==(other) => other.first == first && other.second == second;
}