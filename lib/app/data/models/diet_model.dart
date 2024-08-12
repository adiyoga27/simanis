
class DietModel {
    int? dietId;
    String? title;
    int? amount;
    List<Time>? times;

    DietModel({
        this.dietId,
        this.title,
        this.amount,
        this.times,
    });

    factory DietModel.fromJson(Map<String, dynamic> json) => DietModel(
        dietId: json["diet_id"],
        title: json["title"],
        amount: json["amount"],
        times: List<Time>.from(json["times"].map((x) => Time.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "diet_id": dietId,
        "title": title,
        "amount": amount,
        "times": List<dynamic>.from(times!.map((x) => x.toJson())),
    };
}

class Time {
    int? timeId;
    int? dietId;
    String? title;
    List<Food>? food;

    Time({
        this.timeId,
        this.dietId,
        this.title,
        this.food,
    });

    factory Time.fromJson(Map<String, dynamic> json) => Time(
        timeId: json["time_id"],
        dietId: json["diet_id"],
        title: json["title"],
        food: List<Food>.from(json["food"].map((x) => Food.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "time_id": timeId,
        "diet_id": dietId,
        "title": title,
        "food": List<dynamic>.from(food!.map((x) => x.toJson())),
    };
}

class Food {
    int? foodId;
    int? timeId;
    String? material;
    String? unit;
    String? menu;

    Food({
        this.foodId,
        this.timeId,
        this.material,
        this.unit,
        this.menu,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        foodId: json["food_id"],
        timeId: json["time_id"],
        material: json["material"],
        unit: json["unit"],
        menu: json["menu"],
    );

    Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "time_id": timeId,
        "material": material,
        "unit": unit,
        "menu": menu,
    };
}
