class SearchKeyBean {
    int id = 0;
    String link = "";
    String name = "";
    int order = 0;
    int visible = 0;

    SearchKeyBean({this.id, this.link, this.name, this.order, this.visible});

    factory SearchKeyBean.fromJson(Map<String, dynamic> json) {
        return SearchKeyBean(
            id: json['id'],
            link: json['link'],
            name: json['name'],
            order: json['order'],
            visible: json['visible'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['link'] = this.link;
        data['name'] = this.name;
        data['order'] = this.order;
        data['visible'] = this.visible;
        return data;
    }

    factory SearchKeyBean.fromMap(Map<String, dynamic> map) {
        return SearchKeyBean(
            id: map['id'],
            link: map['link'],
            name: map['name'],
            visible: map['visible'],
        );
    }

    Map<String, dynamic> toMap() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['link'] = this.link;
        data['name'] = this.name;
        data['visible'] = this.visible;
        return data;
    }
}