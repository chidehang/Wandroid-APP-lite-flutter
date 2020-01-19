class ArticleTagBean {
    String name;
    String url;

    ArticleTagBean({this.name, this.url});

    factory ArticleTagBean.fromJson(Map<String, dynamic> json) {
        return ArticleTagBean(
            name: json['name'],
            url: json['url'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['url'] = this.url;
        return data;
    }
}