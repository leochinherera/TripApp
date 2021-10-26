class Localization {
  final List<Animals> animals;
  final List<States> states;

  Localization({this.animals, this.states});

  factory Localization.fromJson(Map<String, dynamic> json) {
    return Localization(
      states: parseStates(json),
      animals: parseAnimals(json),
    );
  }

  static List<States> parseStates(statesJson) {
    var slist = statesJson['states'] as List;
    List<States> statesList =
        slist.map((data) => States.fromJson(data)).toList();
    return statesList;
  }

  static List<Animals> parseAnimals(animalsJson) {
    var plist = animalsJson['animals'] as List;
    List<Animals> animalsList =
        plist.map((data) => Animals.fromJson(data)).toList();
    return animalsList;
  }
}

class States {
  final int id;
  final String name;

  States({this.id, this.name});

  factory States.fromJson(Map<String, dynamic> parsedJson) {
    return States(id: parsedJson['id'], name: parsedJson['name']);
  }
}

class Animals {
  final int id;
  final String name;
  final int stateId;

  Animals({this.id, this.name, this.stateId});

  factory Animals.fromJson(Map<String, dynamic> parsedJson) {
    return Animals(
        id: parsedJson['id'],
        name: parsedJson['name'],
        stateId: parsedJson['state_id']);
  }
}
