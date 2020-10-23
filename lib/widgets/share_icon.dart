import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../providers/custom_lists.dart';

class ShareIcon extends StatefulWidget {
  final customList;

  ShareIcon(this.customList);

  @override
  _ShareIconState createState() => _ShareIconState();
}

class _ShareIconState extends State<ShareIcon> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Icon(Icons.share, color: Theme.of(context).primaryIconTheme.color)),
        onTap: () {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Enter user email',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 15)),
                  content: TextField(
                    controller: _textController,
                    textInputAction: TextInputAction.go,
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Submit'),
                      onPressed: () {
                        _share();
                        _textController.clear();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        });
  }

  Future<void> _share() async {
    final customListProvider = Provider.of<CustomLists>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
    try {
      await customListProvider.shareList(
          authProvider.uid, widget.customList, _textController.text);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Success'),
          content: Text('Share was successful!'),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } on HttpException catch (e) {
      _showErrorDialog(e.message);
    } catch (e) {
      var errorMessage = e.toString();
      if (e.toString().contains('No element')) {
        errorMessage = 'User not found';
      }
      _showErrorDialog(errorMessage);
    }

    _textController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
