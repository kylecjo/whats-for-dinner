import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/business.dart';
import '../models/choose_one_arguments.dart';
import '../models/custom_list.dart';
import '../models/http_exception.dart';
import '../providers/auth.dart';
import '../providers/custom_lists.dart';
import '../screens/choose_one_screen.dart';
import '../widgets/custom_list_dismissible_card.dart';

class CustomListScreen extends StatefulWidget {
  final CustomList customList;
  static const routeName = '/customList';

  CustomListScreen(this.customList);

  @override
  _CustomListScreenState createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  final TextEditingController _textController = TextEditingController();

  void chooseOne(List<Business> businesses, String errorText) {
    try {
      Navigator.pushNamed(
        context,
        ChooseOneScreen.routeName,
        arguments: ChooseOneArguments(businesses),
      );
    } catch (_) {
      final snackBar = SnackBar(
        content: Text(errorText),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.customList.name),
        actions: [
          InkWell(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Icon(Icons.casino)),
              onTap: () {
                chooseOne(widget.customList.businesses,
                    'There are no items in this custom list');
              }),
          InkWell(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Icon(Icons.share)),
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
              }),
        ],
      ),
      body: Consumer<CustomLists>(
        builder: (ctx, data, child) => Column(
          children: [
            Expanded(
              child: widget.customList.businesses.length > 0
                  ? ListView.builder(
                      itemCount: widget.customList.businesses.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CustomListDismissibleCard(
                            widget.customList.businesses[index],
                            widget.customList);
                      },
                    )
                  : Center(
                      child: Text(
                          'No restaurants in ${widget.customList.name} yet!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 14))),
            ),
          ],
        ),
      ),
    );
  }
}
