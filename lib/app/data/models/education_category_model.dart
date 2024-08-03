
class EducationCategoryModel {
    int id;
    String title;
    String slug;
    List<Education> educations;

    EducationCategoryModel({
        required this.id,
        required this.title,
        required this.slug,
        required this.educations,
    });

    factory EducationCategoryModel.fromJson(Map<String, dynamic> json) => EducationCategoryModel(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        educations: List<Education>.from(json["educations"].map((x) => Education.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "educations": List<dynamic>.from(educations.map((x) => x.toJson())),
    };
}

class Education {
    int id;
    String title;
    String content;
    String image;
    String slug;

    Education({
        required this.id,
        required this.title,
        required this.content,
        required this.image,
        required this.slug,
    });

    factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        image: json["image"],
        slug: json["slug"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "image": image,
        "slug": slug,
    };
}
