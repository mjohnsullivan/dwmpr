import 'package:dwmpr/github/graphql.dart';
import 'package:dwmpr/github/repository.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My App')),
        body: Center(
          child: RepoList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}

class RepoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: repositories(),
        builder: (context, AsyncSnapshot<List<Repository>> snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? ListView(
                    children: snapshot.data.map((repo) => Repo(repo)).toList(),
                  )
                : CircularProgressIndicator());
  }
}

class Repo extends StatelessWidget {
  final Repository repo;
  Repo(this.repo);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(repo.name),
      subtitle: Text(repo.description ?? 'No description'),
      leading: CircleAvatar(child: Text('${repo.starCount}')),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                  height: 200.0,
                  child: Center(
                    child: Text('Nr Forks: ${repo.forkCount}'),
                  ));
            });
      },
    );
  }
}
