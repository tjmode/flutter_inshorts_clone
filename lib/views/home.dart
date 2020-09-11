import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inshortsclone/NetworkDrive/data.dart';
import 'package:inshortsclone/NetworkDrive/news.dart';
import 'package:inshortsclone/models/category_model.dart';
import 'package:inshortsclone/models/article_model.dart';
import 'package:inshortsclone/views/article_view.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async{
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("TECHI"),
            Text("NEWS", style: TextStyle(
              color: Colors.blue
            )),
          ],
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ): SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          child: Column(
            children: <Widget>[

              ///Category
              Container(
                height: 60,
                child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return CategoryTile(
                        imageUrl: categories[index].imageUrl,
                        categoryName: categories[index].cateoryName,
                      );
                    }),
              ),

              ///Blog post
              Container(
                padding: EdgeInsets.only(top: 20),
                child: ListView.builder(
                  itemCount: articles.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                    return BlogTile(
                      imageUrl: articles[index].urlToImage,
                      title: articles[index].title,
                      desc: articles[index].description,
                      url: articles[index].url,
                    );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile  extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("OOOOOO");
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl, width: 120, height: 60, fit: BoxFit.cover,)
            ),
            Container(
              alignment: Alignment.center,
              width: 120, height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child:  Text(categoryName, style: TextStyle(
                color: Colors.white
              ),),
            )
          ],
        ),
      ),
    );
  }
}


class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile({@required this.imageUrl, @required this.title, @required this.desc, @required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ArticleView(
            blogUrl: url,

          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            Image.network(imageUrl),
            SizedBox(height: 12,),
            Text(title, style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.w600
            ),),
            SizedBox(height: 12,),
            Text(desc, style: TextStyle(
              color: Colors.black54
            ),)
          ],
        ),
      ),
    );
  }
}
